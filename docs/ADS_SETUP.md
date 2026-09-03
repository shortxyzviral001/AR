# Publicité — Adsterra (toutes plateformes)

Le jeu monétise via **Adsterra**, sur Android et Desktop, sans SDK natif :
toutes les publicités s'ouvrent dans le navigateur système (ou une page
locale légère), toujours sur clic explicite du joueur.

> Historique : les versions précédentes documentaient une intégration Unity
> Ads (SDK natif Android), qui n'a en réalité jamais été livrée dans ce
> dépôt (le plugin `android/plugins/unityads/` référencé n'a jamais existé
> ici). L'intégration a été refaite entièrement sur Adsterra, réseau déjà
> utilisé pour le fallback desktop.

## Formats utilisés

| Emplacement | Format Adsterra | Comportement |
|---|---|---|
| Bouton "x2 cristaux" (fin de partie) | Direct Link / Popunder | Ouvre un nouvel onglet ; récompense accordée après un visionnage minimum de 15s **et** retour dans le jeu. |
| Tous les 3 secteurs | Smartlink (invite discrète, fermable) | Un encart en haut de l'écran propose la pub ; ignoré = disparaît seul après 6s. Jamais automatique. |
| Écran de fin de partie (session ≥ 60s) | Idem interstitiel | Même invite non-intrusive. |
| Bannière en jeu (optionnelle) | Banner 320×50 / 468×60 | Désactivée par défaut tant qu'aucune zone n'est renseignée dans `AdsManager.gd`. |

## Pourquoi pas de vraie "pub récompensée" native ?

Adsterra ne fournit pas de SDK mobile avec un format "Rewarded Video" et un
callback de complétion garanti, contrairement à Unity Ads/AdMob. Le flux de
récompense est donc **recréé côté client** dans `AdsManager.gd` :

1. Le joueur clique sur "Regarder une pub pour x2 cristaux".
2. Le jeu ouvre le Direct Link Adsterra dans le navigateur système
   (`OS.shell_open`), toujours suite à un clic — jamais en tâche de fond,
   pour rester conforme aux règles anti-fraude d'Adsterra.
3. Un minuteur de 15 secondes (`REWARD_MIN_VIEW_S`) démarre côté jeu.
4. La récompense n'est accordée que si **les 15 secondes se sont écoulées
   ET** le joueur est revenu dans l'app (détecté via le focus de la
   fenêtre) — ou a cliqué sur "J'ai regardé — Continuer" sur desktop.

## Configuration (identifiants Adsterra)

Compte publisher Adsterra rattaché à `multidevsn.github.io` :

- **Direct Link / Popunder** (récompense) :
  `https://www.profitableratecpmnetwork.com/cu6vgyq1?key=27aad7f77209ac09de82da823d90b505`
- **Smartlink** (interstitiel discret) :
  `https://www.profitableratecpmnetwork.com/vaam7i8w?key=6149a9a739adbbe40f8838e03d54b07d`
- **Social Bar / Native Banner / bannières classiques** (320×50, 468×60,
  728×90, 160×300, 160×600, 300×250) : zones créées sur le dashboard mais
  dont le code d'intégration (snippet JS) n'est pas exposé par l'API
  Publisher Adsterra (qui ne renvoie que les métadonnées de zone, pas le
  code HTML). Pour les activer :
  1. Va sur [Adsterra Publishers](https://beta.publishers.adsterra.com/) >
     **Websites** > sélectionne le domaine > la zone concernée > **Get
     code**.
  2. Colle le snippet copié dans `ZONE_SOCIAL_BAR_SNIPPET` ou
     `ZONE_BANNER_SNIPPET` en tête de `scripts/AdsManager.gd`.
  3. Tant que ces constantes sont vides, le jeu n'affiche aucune bannière ni
     interstitiel Social Bar — seul le Direct Link (récompense) fonctionne.

Pour lire les statistiques (impressions, clics, revenu) par programme, utilise
l'API Publisher Adsterra :

```bash
curl -H "X-API-Key: TA_CLE_API" \
  "https://api3.adsterratools.com/publisher/stats.json?start_date=2026-08-01&finish_date=2026-09-03"
```

La clé API se génère depuis le dashboard Adsterra > **API**. Elle ne sert
qu'au reporting/statistiques — elle n'est **pas** utilisée par le jeu
lui-même (le jeu n'a besoin que des URLs de zones ci-dessus, qui ne sont pas
des secrets à proprement parler puisqu'elles sont destinées à être visibles
publiquement dans les pubs affichées).

## Consentement GDPR & plafonds

- Avant la première pub, un écran demande l'autorisation (Accepter /
  Refuser). Le choix est mémorisé dans `user://astro_recolte_ads.cfg` et
  modifiable à tout moment dans Paramètres > Publicités.
- Plafond quotidien : au maximum 5 pubs récompensées par jour
  (`MAX_REWARDED_PER_DAY` dans `AdsManager.gd`), compteur sauvegardé, pour
  ne pas casser l'économie des cristaux.
- Aucune pub n'est jamais déclenchée automatiquement : chaque affichage part
  d'un clic explicite du joueur (bouton x2 cristaux, ou clic sur l'invite
  d'interstitiel).
