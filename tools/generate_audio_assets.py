#!/usr/bin/env python3
"""
generate_audio_assets.py
=======================

Genere des assets audio (musique + SFX) via des IA publiques GRATUITES quand
un endpoint libre est accessible, puis les integre dans le projet Godot
sous assets/audio/ (remplacement des versions synthetisees en code).

Le jeu detecte automatiquement les fichiers dans res://assets/audio/ et les
utilise a la place des sons proceduraux. Aucune modification du code du jeu
n'est necessaire apres avoir lance ce script.

Fichiers attendus (noms fixes, voir Audio.gd -> _try_load_external_assets):
  music_loop.ogg      - musique de gameplay en boucle
  ambient_loop.ogg    - ambiance gameplay (hum moteurs + souffle spatial)
  cine_ambient.ogg    - musique cinematique histoire
  cine_tension.ogg    - musique cinematique alerte boss
  cine_victory.ogg    - musique cinematique victoire
  cine_warp.ogg       - musique cinematique transition
  sfx_laser.ogg, sfx_alarm.ogg, sfx_boom.ogg, sfx_whoosh.ogg, ... (optionnel)

Endpoints testes (aout 2026 - la plupart exigent desormais une cle/paiement):
  - https://audio.pollinations.ai/{prompt}   (TTS, ne fait pas de musique)
  - https://gen.pollinations.ai/audio/...     (exige une cle API)
  - https://enter.pollinations.ai/audio?prompt=... (interface web, pas d'API)
  - https://text.pollinations.ai/...?model=openai-audio  (TTS voix)
  - https://api.streamelements.com/kappa/v2/speech (voix, exige auth)
Si aucun endpoint n'est joignable, le script s'arrete proprement : le jeu
conserve ses sons 100% synthetises (aucun fichier vide n'est cree).

Usage:
  python tools/generate_audio_assets.py          # tente tout, sec qu'il trouve
  python tools/generate_audio_assets.py --list   # affiche les endpoints
  python tools/generate_audio_assets.py --force  # regenere meme si fichiers existent
"""

import os
import sys
import time
import shutil
import urllib.request
import urllib.parse
import urllib.error

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AUDIO_DIR = os.path.join(PROJECT_ROOT, "assets", "audio")

# ---------------------------------------------------------------------------
# Endpoints gratuits a essayer (dans l'ordre de preference)
# ---------------------------------------------------------------------------

# 1. Pollinations audio legacy (TTS uniquement - pas de musique, mais voix)
ENDPOINTS = [
    {
        "name": "pollinations-audio",
        "kind": "tts",
        "url": "https://text.pollinations.ai/{text}?model=openai-audio&voice=alloy",
    },
    {
        "name": "pollinations-gen-audio",
        "kind": "music",
        "url": "https://gen.pollinations.ai/audio/{prompt}",
        "note": "exige une cle API dep 2026 (401 sans cle)",
    },
    {
        "name": "streamelements-tts",
        "kind": "tts",
        "url": "https://api.streamelements.com/kappa/v2/speech?voice=Brian&text={text}",
        "note": "exige auth dep 2026 (401)",
    },
]

# Prompts de musique (utilises si un endpoint 'music' fonctionne)
MUSIC_PROMPTS = {
    "music_loop": "calm ambient space exploration music loop, soft synth pads, 8 seconds",
    "ambient_loop": "low engine hum and gentle space wind ambience loop, dark and spacious",
    "cine_ambient": "emotional sci-fi cinematic score, slow piano and strings, hopeful",
    "cine_tension": "tense cinematic build-up, dark drones and pulsing bass, alarm feel",
    "cine_victory": "triumphant fanfare, bright brass and strings, uplifting victory",
    "cine_warp": "fast rising warp jump whoosh, accelerating synth sweep",
}


def http_get(url: str, timeout: float = 60.0) -> bytes:
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Mozilla/5.0 (AstroRecolte-asset-gen)"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return resp.read()


def is_audio(data: bytes) -> bool:
    """Heuristique : rejette les reponses HTML/JSON, garde l'audio."""
    if not data or len(data) < 256:
        return False
    if data[:5] in (b"<!doc", b"<html", b"<!DOC", b"<HTML"):
        return False
    if data[:1] == b"{" and b"error" in data[:200]:
        return False
    if data[:1] == b"[":
        return False
    return True


def probe_endpoint(ep: dict) -> bool:
    """Teste si un endpoint repond avec de l'audio pour un petit prompt."""
    try:
        url = ep["url"].format(text=urllib.parse.quote("test"), prompt=urllib.parse.quote("test tone"))
        data = http_get(url, timeout=30.0)
        ok = is_audio(data)
        print(f"  [{'OK' if ok else '--'}] {ep['name']}")
        return ok
    except urllib.error.HTTPError as e:
        print(f"  [{'OK' if e.code == 200 else e.code}] {ep['name']}  ({ep.get('note', '')})")
        return False
    except Exception as e:
        print(f"  [--] {ep['name']}  ({type(e).__name__})")
        return False


def main() -> int:
    os.makedirs(AUDIO_DIR, exist_ok=True)

    if "--list" in sys.argv:
        print("Endpoints candidats (IA gratuites) :")
        for ep in ENDPOINTS:
            print(f"  - {ep['name']}: {ep['url']}  ({ep.get('note', '')})")
        print("\nFichiers attendus dans assets/audio/ :")
        for f in MUSIC_PROMPTS:
            print(f"  - {f}.ogg")
        print("  - sfx_<nom>.ogg (remplace un effet : sfx_laser, sfx_alarm, ...)")
        return 0

    force = "--force" in sys.argv
    existing = [f for f in MUSIC_PROMPTS if os.path.exists(os.path.join(AUDIO_DIR, f + ".ogg"))]
    if existing and not force:
        print(f"Des assets existent deja ({len(existing)}), rien a faire. Utilisez --force pour regenerer.")
        return 0

    print("Probing des endpoints d'IA audio gratuits...")
    working = [ep for ep in ENDPOINTS if probe_endpoint(ep)]
    if not working:
        print("\nAucun endpoint audio gratuit joignable depuis ce poste.")
        print("Les API audio IA (pollinations, streamelements, ...) exigent desormais")
        print("une cle ou un compte payant. Le jeu utilise donc ses sons 100% synthetises.")
        print("Re-essayez plus tard ou ajoutez vos propres fichiers dans assets/audio/.")
        return 1

    ep = working[0]
    print(f"\nEndpoint retenu : {ep['name']}")

    if ep["kind"] == "music":
        for name, prompt in MUSIC_PROMPTS.items():
            out = os.path.join(AUDIO_DIR, name + ".ogg")
            print(f"  Generation de {name}.ogg ...")
            try:
                url = ep["url"].format(prompt=urllib.parse.quote(prompt))
                data = http_get(url, timeout=180.0)
                if is_audio(data):
                    with open(out, "wb") as f:
                        f.write(data)
                    print(f"    -> {out} ({len(data)//1024} Ko)")
                else:
                    print(f"    !! reponse non-audio, ignoree")
            except Exception as e:
                print(f"    !! {type(e).__name__}: {e}")
            time.sleep(2)  # rate-limit amiable
    elif ep["kind"] == "tts":
        print("  Cet endpoint ne produit que de la voix (pas de musique).")
        print("  Il peut servir pour le doublage, pas pour les boucles musicales.")
        print("  Le jeu garde sa musique synthetisee.")

    print("\nTermine. Redemarrez le jeu : Audio.gd chargera automatiquement")
    print("les fichiers presents dans assets/audio/ (voir _try_load_external_assets).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
