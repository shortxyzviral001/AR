# Astro Récolte (Astro Harvest)

Jeu arcade 2D spatial, sans fin, développé avec **Godot 4.7** : attrape les
étoiles, esquive les météores et les vaisseaux ennemis, affronte des boss de
secteur et débloque plus de 1 000 ensembles cosmétiques dans la boutique.

![Godot](https://img.shields.io/badge/Godot-4.7-478cbf?logo=godot-engine&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20Desktop-informational)
![License](https://img.shields.io/badge/license-propriétaire-lightgrey)

## Sommaire

- [Ouvrir le projet](#ouvrir-le-projet)
- [Commandes](#commandes)
- [Objectif du jeu](#objectif-du-jeu)
- [Structure du dépôt](#structure-du-dépôt)
- [Documentation complémentaire](#documentation-complémentaire)
- [Build & release](#build--release)
- [Tests](#tests)
- [Sécurité & secrets](#sécurité--secrets)
- [Licence](#licence)

## Ouvrir le projet

1. Installe [Godot Engine 4.7](https://godotengine.org/download).
2. Lance Godot, clique sur **Importer**, puis choisis `project.godot` à la
   racine de ce dépôt.
3. Appuie sur **Play** (F5) pour lancer le jeu dans l'éditeur.

## Commandes

- Flèches ou ZQSD/WASD pour bouger (8 directions).
- Sur mobile : un stick analogique unique (bas à gauche de l'écran) qui
  pilote le déplacement dans toutes les directions.
- Clic gauche maintenu pour suivre la souris.
- Espace ou Entrée pour lancer/rejouer.
- Le tir du vaisseau est automatique — pas de bouton à gérer, concentre-toi
  sur l'esquive et le positionnement.
- Pendant la partie : le rouage (en haut à droite) ouvre les Paramètres, le
  triangle ouvre la Pause (Reprendre / Paramètres / Quitter la partie).
  Échap (ou le bouton retour Android) fait aussi office de pause.

## Objectif du jeu

Attrape les étoiles, évite les météores, et récupère les cœurs quand ils
apparaissent. Des vaisseaux ennemis (chasseurs et intercepteurs) traversent
l'écran : ton vaisseau les mitraille automatiquement, ou tu peux simplement
les esquiver. Toutes les ~40 secondes, un boss de secteur apparaît avec sa
propre barre de vie et un pattern de tir signature ; une fois vaincu, tu
passes au secteur suivant (fond, couleurs et difficulté changent) et la
partie continue, de plus en plus intense — indéfiniment, sans fin fixée à
l'avance.

Chaque étoile, ennemi vaincu ou boss rapporte des cristaux, utilisables dans
la Boutique pour débloquer parmi 1 000 ensembles cosmétiques (coque +
traînée + insigne) à équiper sur ton vaisseau. Un classement en ligne
(pseudo unique, ratio score/temps) permet de se comparer aux autres joueurs.

## Structure du dépôt

```
.
├── assets/            Sprites, icônes, fonds (SVG/PNG/JPG)
├── scenes/            Scène principale Godot (Main.tscn)
├── scripts/           Logique du jeu (GDScript) et autoloads
│   ├── Main.gd            Boucle de jeu, UI, ennemis, boss, boutique in-game
│   ├── Settings.gd        Paramètres persistants + traductions FR/EN
│   ├── Shop.gd            Génération et logique de la boutique cosmétique
│   ├── Leaderboard.gd     Classement en ligne (Firebase Firestore, REST)
│   ├── AdsManager.gd      Publicités Adsterra (Android + Desktop, sans SDK natif)
│   ├── Audio.gd           SFX/musique 100% synthétisés en code
│   ├── Starfield.gd       Fond étoilé défilant, transitions de secteur
│   ├── TouchControls.gd   Joystick tactile (mobile)
│   └── UpdateChecker.gd   Vérification de mise à jour disponible
├── tests/             Smoke tests headless (voir #tests)
├── tools/             Scripts d'aide au build/install/diagnostic (Windows & Linux)
├── update/            Pages statiques de mise à jour / téléchargement
├── docs/              Documentation détaillée (voir ci-dessous)
├── export_presets.cfg Presets d'export Godot (Android, Windows Desktop)
└── project.godot      Configuration du projet Godot
```

## Documentation complémentaire

- [`docs/CHANGELOG.md`](docs/CHANGELOG.md) — historique détaillé des versions.
- [`docs/LEADERBOARD_SETUP.md`](docs/LEADERBOARD_SETUP.md) — configuration du
  classement en ligne (Firebase Firestore gratuit, règles de sécurité).
- [`docs/ADS_SETUP.md`](docs/ADS_SETUP.md) — configuration des publicités
  (Adsterra, toutes plateformes, formats et flux de récompense maison).
- [`docs/STORE_LISTING.md`](docs/STORE_LISTING.md) — texte de présentation et
  recommandations de captures d'écran pour les fiches store (Uptodown,
  Play Store...).

## Build & release

### Localement (Godot Editor)

**Projet > Exporter**, choisis le preset (`Android` ou `Windows Desktop`),
renseigne le keystore de release dans la section **Keystore** (jamais commité
dans ce dépôt — voir [Sécurité & secrets](#sécurité--secrets)), puis clique
sur **Exporter le projet**.

### Automatiquement (GitHub Actions)

Un workflow (`.github/workflows/release.yml`) exporte et signe
automatiquement l'APK Android puis publie une GitHub Release à chaque tag
`v*` poussé sur le dépôt :

```bash
git tag v1.23.0
git push origin v1.23.0
```

Il nécessite trois secrets configurés une seule fois dans
**Settings > Secrets and variables > Actions** du dépôt GitHub :
`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_ALIAS`,
`ANDROID_KEYSTORE_PASSWORD` (voir les commentaires en tête du workflow).

**Important — à chaque nouvelle version** : incrémente `version/code` et
`version/name` dans `export_presets.cfg`, **et** synchronise
`config/version_code` / `config/version` dans `project.godot` (utilisé par
`UpdateChecker.gd` pour détecter les mises à jour disponibles côté client).

## Tests

Le dossier `tests/` contient des smoke tests headless Godot (intro
cinématique, publicités, transitions de secteur). Exemple d'exécution en
local :

```bash
godot --headless --path . res://tests/intro_smoke.tscn
godot --headless --path . res://tests/ads_smoke.tscn
godot --headless --path . res://tests/cine_smoke.tscn
```

Voir aussi `tools/diagnose_install.sh` pour diagnostiquer un APK qui refuse
de s'installer (signature, alignement, architecture).

## Sécurité & secrets

- Le fichier `.godot/` (cache local Godot, régénéré automatiquement) et les
  fichiers de keystore (`*.keystore`, `*.jks`) sont exclus du suivi Git via
  `.gitignore` — **ne les commite jamais**.
- Les identifiants de signature Android (mot de passe du keystore de
  release) ne doivent exister que localement ou en secret GitHub Actions,
  jamais dans un fichier versionné.
- Les URLs de zones Adsterra dans `scripts/AdsManager.gd` ne sont pas des
  secrets (elles sont destinées à apparaître publiquement dans les pubs
  affichées) ; en revanche, la **clé API Adsterra** (reporting/statistiques)
  ne doit jamais être committée — elle ne sert qu'en local ou en script
  d'export de données, jamais dans le code du jeu lui-même.

## Licence

Voir [`LICENSE`](LICENSE) — tous droits réservés. Contact :
[@shortxyzviral001](https://github.com/shortxyzviral001).
