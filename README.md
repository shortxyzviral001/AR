<<<<<<< HEAD
# AR

A repository for Augmented Reality (AR) experiments, prototypes, and reusable components.

> NOTE: This README is a starter template. Replace sections and examples to reflect the exact purpose and setup of this repository.

---

## Table of contents

- [About](#about)
- [Features](#features)
- [Languages & Tech](#languages--tech)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Run / Use](#run--use)
- [Project structure](#project-structure)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## About

This repository holds AR-related code: demos, example scenes, shaders, tracking utilities, web viewers, and helper libraries. It is intended to collect experimentations and share components that can be reused across AR projects.

If this isn't the correct description for the project, update this section with a short (1–3 sentence) summary of the repository's purpose.

## Features

- Prototype AR scenes and interactions
- Reusable components and utilities for tracking, anchors, and UI
- Example integrations (WebAR / Unity / native) — add or remove as appropriate

## Languages & Tech

List of primary languages and technologies used in the repo (GitHub will display language composition automatically):

- Unity (C#)
- JavaScript / TypeScript (for web viewers)
- GLSL / ShaderLab (shaders)
- README: adjust to match actual contents

Replace or remove items above to reflect this project's real tech stack.

## Getting started

### Prerequisites

Install the tools required for the parts of the project you will use. Common ones for AR projects:

- Git
- Unity (2020.3 LTS or later) with AR Foundation if using Unity
- Node.js and npm/yarn for web viewers
- Android Studio / Xcode for mobile builds (when building to device)

### Installation

1. Clone the repository:

   git clone https://github.com/shortxyzviral001/AR.git
   cd AR

2. Follow the platform-specific README files inside folders (e.g. `unity/`, `web/`) if present. Typical steps:

   - Unity: open the project folder in Unity Hub and let it import packages
   - Web: cd into `web/` and run `npm install` or `yarn`

### Run / Use

Examples (update to match your project):

- Unity: Open the project in Unity, open the sample scene at `Assets/Scenes/SampleScene.unity`, then press Play.
- Web: cd web && npm start — open http://localhost:3000 to view the WebAR demo.

## Project structure

A suggested layout — adapt to the repository's actual structure:

- /unity/        — Unity project, scenes, assets, scripts
- /web/          — WebAR viewer and related front-end code
- /docs/         — Project documentation, design notes
- /examples/     — Small runnable examples and demos
- /tools/        — Utility scripts, build scripts

## Development

- Create feature branches from `main` (or the repository's default branch):

  git checkout -b feat/short-description

- Commit messages should be clear and small, e.g. `feat(input): add hand-gesture recognizer`
- Add tests or example scenes demonstrating the change when applicable

## Contributing

Contributions are welcome. Please:

1. Fork the repository
2. Create a feature branch
3. Open a pull request with a clear description of your changes

Add labels, issue templates, and a contributing.md file for more detailed guidance.

## License

This repository does not include a license file yet. If you want to make the code open source, add a LICENSE (for example, MIT) and update this section.

## Contact

Project owner: shortxyzviral001

---

If you want, I can:
- tailor this README to a specific subfolder (Unity, Web, etc.),
- add badges, a license file, or CI instructions,
- or open a pull request with a more detailed README that includes screenshots and best-practice setup steps.
=======
# Astro Recolte

Petit jeu arcade 2D pour Godot 4.7.

## Ouvrir le projet

1. Lance Godot Engine.
2. Clique sur **Importer**.
3. Choisis `project.godot` dans ce dossier.
4. Appuie sur **Play**.

## Commandes

- Fleches ou ZQSD/WASD pour bouger (8 directions).
- Sur mobile : un stick analogique unique (bas a gauche de l'ecran) qui
  pilote le deplacement dans toutes les directions.
- Clic gauche maintenu pour suivre la souris.
- Espace ou Entree pour lancer/rejouer.
- Le tir du vaisseau est automatique : pas de bouton a gerer, concentre-toi
  sur l'esquive et le positionnement.
- Pendant la partie : le rouage (en haut a droite) ouvre les Parametres, le
  triangle ouvre la Pause (Reprendre / Parametres / Quitter la partie).
  Echap (ou le bouton retour Android) fait aussi office de pause.

## Objectif

Attrape les etoiles, evite les meteores, et recupere les coeurs quand ils
apparaissent. Des vaisseaux ennemis (chasseurs et intercepteurs) traversent
l'ecran : ton vaisseau les mitraille automatiquement, ou tu peux simplement
les esquiver. Toutes les ~40 secondes, un boss de secteur apparait avec sa
propre barre de vie et des salves de tirs a esquiver ; une fois vaincu, tu
passes au secteur suivant (fond, couleurs et difficulte changent) et la
partie continue, de plus en plus intense — indefiniment, sans fin fixee a
l'avance.

Chaque etoile, ennemi vaincu ou boss rapporte des cristaux, utilisables dans
la Boutique pour debloquer parmi 1000 ensembles cosmetiques (coque + trainee
+ insigne) a equiper sur ton vaisseau.

## Changelog (corrections et ameliorations)

- Corrige un bug d'affichage : la Camera2D creee par script utilisait le mode
  d'ancrage par defaut (centre), ce qui decalait toute la zone de jeu et ne
  laissait visible qu'un quart de l'ecran en bas a droite. La camera utilise
  desormais `ANCHOR_MODE_FIXED_TOP_LEFT`, alignee sur l'origine du monde.
- Plafonne la difficulte (`MAX_DIFFICULTY`) pour eviter que la vitesse de
  chute des objets ne devienne infinie/injouable lors des parties tres longues.
- Ajoute une sauvegarde locale du meilleur score (`user://astro_recolte.save`),
  affiche sur l'ecran d'accueil et sur l'ecran de fin de partie.
- Ajoute la touche Echap pour quitter le jeu.
- Ajoute un pseudo unique par joueur et un classement en ligne (voir ci-dessous).
- Rend la montee en difficulte plus marquee (courbe plus raide, vitesse et
  frequence de chute augmentent plus vite avec le temps).
- Ajoute des controles tactiles pour mobile : un joystick a gauche qui pilote
  uniquement le deplacement horizontal, et deux boutons a droite (haut/bas)
  pour le deplacement vertical. Le stick et un bouton peuvent etre utilises
  en meme temps (deux doigts).
- Ajoute deux malus : un qui ralentit temporairement le vaisseau, un autre
  qui retire des points. Les coeurs (vies) sont devenus plus rares.
- Ajoute un ecran Parametres : difficulte (Facile/Normal/Difficile), afficher
  ou non les controles tactiles, et reinitialiser le record local.

### Version 1.1.0 — vitesse, contenu et republication

- **Stick analogique complet** : le joystick tactile pilote desormais les 4
  directions (haut/bas/gauche/droite) au lieu de se limiter a l'horizontal.
  Les deux boutons separes haut/bas ont ete retires (devenus inutiles).
- **Vitesse du vaisseau augmentee** (+44%, de 430 a 620 px/s) pour des
  controles plus nerveux.
- **Tir automatique** : le vaisseau tire en continu vers le haut.
- **Vaisseaux ennemis** : "Chasseur" (1 point de vie, tombe en ligne
  ondulante) et "Intercepteur" (2 points de vie, tire occasionnellement).
  Detruits par le tir automatique (bonus de score) ou percutes au contact
  (perte d'une vie, comme un meteore).
- **Boss de secteur** : toutes les ~40 secondes (delai qui augmente
  legerement a chaque secteur), un boss avec barre de vie affichee en haut
  de l'ecran apparait, se deplace en patrouille et tire des salves. Le
  vaincre rapporte un gros bonus de score et fait passer au secteur suivant.
- **Secteurs ("changements de plan")** : 5 themes visuels qui s'enchainent
  et se repetent en s'intensifiant (fond, couleur des etoiles, teinte des
  meteores, vitesse de chute) — Ceinture Bleue, Nebuleuse Violette, Ceinture
  Ambree, Zone Cramoisie, Abysses Emeraude. Le changement de secteur est
  annonce par une banniere et une transition de couleur en fondu.
- **Bouclier bref apres un coup** : ~0.9s d'invulnerabilite (vaisseau
  clignotant) apres avoir ete touche, pour eviter les pertes de vie en
  cascade injustes quand plusieurs dangers se chevauchent.
- **Assets visuels retravailles** : vaisseau du joueur, etoile, meteore et
  coeur redessines avec plus de details (degrades, lumieres, halos), plus 4
  nouveaux visuels (vaisseau ennemi, boss, tirs joueur/ennemi).
- **Icone de l'application corrigee** : l'icone de lancement (et l'ecran de
  demarrage Android) pointait par erreur vers l'asset "meteore" au lieu d'un
  logo dedie. Un nouveau badge dedie a ete cree (`assets/icon_*.svg`), avec
  les 4 variantes attendues par Android (icone simple, premier plan/fond
  adaptatifs, version monochrome).
- **Version app bump** : `version/code` passe de 1 a 2 et `version/name` de
  vide a `1.1.0` dans `export_presets.cfg`, comme l'exige Uptodown pour
  resoumettre une mise a jour.

### Version 1.2.0 — correction d'affichage, boutique et progression infinie

- **Correctif visuel majeur** : le jeu paraissait sombre, comme voile par une
  couche de transparence. Cause identifiee et corrigee : un `ColorRect`
  d'assombrissement (72% d'opacite) place derriere les ecrans de menu
  n'etait jamais masque une fois la partie lancee — il restait actif en
  permanence, y compris pendant le jeu. Il ne s'affiche desormais que
  lorsqu'un ecran de menu est visible (confirme par capture d'ecran reelle :
  la couleur de fond mesuree correspond exactement a la valeur configuree).
- **Partie de type infini confirme** : les secteurs continuent de s'enchainer
  indefiniment (les 5 themes de base tournent en boucle), la vie des boss
  continue d'augmenter sans plafond a chaque secteur, et la banniere
  affiche desormais un numero de cycle une fois les 5 premiers secteurs
  boucles (ex. "SECTEUR 8 - Nebuleuse Violette (Cycle 2)"), pour bien
  montrer que la progression ne s'arrete jamais.
- **Monnaie persistante (cristaux)** : gagnee en jouant (etoiles, ennemis
  vaincus, boss vaincus, bonus de fin de partie proportionnel au score) et
  sauvegardee entre les sessions.
- **Boutique de 1000 ensembles cosmetiques** (`scripts/Shop.gd`, nouvel
  autoload) : 10 finitions de coque x 10 styles de trainee x 10 insignes,
  generes par combinaison a partir de 30 "briques" definies une seule fois.
  Prix croissant avec la rarete (Commun/Rare/Epique/Legendaire) — les
  premiers ensembles sont abordables des les premieres parties, les
  posseder tous demande une progression sur plusieurs semaines/mois de jeu,
  comme demande. Ecran dedie avec filtres par rarete, tri par prix et
  pagination (12 ensembles par page). Formules de prix et de gain en
  `scripts/Shop.gd`, faciles a retoucher pour ajuster le rythme.
- **Cosmetiques appliques en jeu** : la coque du vaisseau prend la teinte de
  l'ensemble equipe, et une trainee de particules coloree suit le vaisseau
  en continu.
- **Systeme de combo** : les etoiles attrapees d'affilee sans encaisser de
  degats augmentent un combo (bonus de score et de cristaux, popup "Combo
  xN !"), remis a zero au premier coup reellement encaisse. Le meilleur
  combo est sauvegarde.
- **Popups de texte flottant** sur les gains (score, cristaux, vies) pour un
  retour visuel plus satisfaisant.
- **Theme visuel global** : les panneaux et boutons (menus, boutique,
  parametres, credits...) utilisent desormais un habillage spatial dedie
  (StyleBoxFlat, coins arrondis, bordures bleutees) au lieu du gris par
  defaut de Godot.
- **Ecran Credits** ajoute, mettant en avant **multidevsn**.
- **Ecran Parametres reorganise** : sections clairement separees
  (Difficulte / Controles / Progression / Divers), stats de progression
  (cristaux, ensembles possedes, meilleur combo) et acces direct a la
  Boutique et aux Credits.

### Version 1.3.0 — pause, navigation et barre de jeu

- **Vrai systeme de pause** : le jeu se met desormais correctement en pause
  (plus aucun objet ne bouge ni ne spawn) au lieu d'etre interrompu ou de
  quitter l'application. Touche Echap / bouton retour Android : met en
  pause pendant une partie, reprend si deja en pause.
- **Deux boutons dans la barre du haut pendant la partie** : un rouage
  (Parametres, accessible directement sans passer par la pause — la partie
  se met en pause automatiquement) et un triangle (Pause, ouvre l'ecran
  Pause avec Reprendre / Parametres / Quitter la partie).
- **Navigation retour corrigee** : fermer les Parametres ramene desormais au
  bon endroit — a l'ecran Pause si on les a ouverts pendant une partie, a
  l'accueil sinon. Avant ce correctif, on retombait toujours a l'accueil,
  perdant la partie en cours.
- **Barre de donnees (HUD) redessinee** : fond habille (coins arrondis,
  bordure bleutee) au lieu d'un simple rectangle plat, chaque statistique
  (score, vies, temps, cristaux) precedee d'une puce de couleur dediee pour
  une lecture plus rapide.

L'app avait ete refusee par Uptodown ("ne respecte pas les standards minimum
de qualite"). En inspectant l'APK envoye, deux points concrets ressortent
et sont corriges cote projet ci-dessus (contenu de jeu plus riche, icone
propre) ; **un point reste a faire de ton cote avant de reexporter**, car il
touche a un fichier prive (le keystore) que je ne peux pas generer a ta
place :

**L'APK est signe avec la cle de debug partagee de Godot** (certificat
`CN=Godot, O=Stichting Godot`), pas avec une cle qui t'appartient. C'est le
signal le plus net qu'une app n'a pas ete preparee pour une vraie
publication — n'importe quel projet Godot non configure produit exactement
la meme signature, ce qui est reconnu comme peu serieux par les stores.
Pour corriger ca dans Godot :

1. Genere ta propre cle (une seule fois, a garder precieusement — la perdre
   veut dire ne plus jamais pouvoir mettre a jour l'app sous la meme
   identite) :
   ```
   keytool -genkeypair -v -keystore astro-recolte-release.keystore -alias astro_recolte -keyalg RSA -keysize 2048 -validity 10000
   ```
   (le JDK doit etre installe ; Godot en a besoin de toute facon pour
   signer). Choisis un mot de passe solide et note-le.
2. Dans Godot : **Editeur > Gerer les modeles d'exportation**, verifie que
   les modeles Android 4.7 sont installes.
3. **Projet > Exporter**, selectionne le preset Android, section
   **Keystore** : renseigne le chemin du fichier `.keystore` cree a
   l'etape 1, l'alias (`astro_recolte`) et les mots de passe, dans la
   partie **Release** (pas Debug).
4. Exporte avec **Exporter le projet** (pas "Exporter comme debug") pour
   generer un APK signe avec ta cle.
5. Sur la console Uptodown, ajoute cette nouvelle version (le `version/code`
   est deja passe a 2, donc superieur a la precedente comme demande) et
   complete bien la description et les captures d'ecran de la fiche — un
   deuxieme critere frequent de refus Uptodown est une fiche incomplete.

### Version 1.4.0 — son, variete visuelle, boss signature et retention

- **Son** (100% synthetise en code, aucun fichier externe — `scripts/Audio.gd`) :
  effets pour chaque evenement de jeu (ramassage, tir, degats, bouclier,
  destruction d'ennemi/boss, combo, achat, pause, fin de partie) et une
  musique d'ambiance en boucle dont le pitch/tempo augmente legerement a
  chaque secteur. Reglages "Effets sonores" / "Musique" dans Parametres.
- **5 silhouettes de vaisseau distinctes** (et non plus de simples
  recolorations) : Classique, Intercepteur, Bombardier, Furtif et
  Legendaire, chacune associee a 2 des 10 paliers de coque de la Boutique.
  Chaque silhouette a sa propre forme, ses propres reacteurs et details.
- **6 styles de trainee** avec un comportement de particules different
  (et pas seulement une couleur differente) : poussiere, etincelles
  (utilise le sprite etoile), flux, fumee, flamme, anneau.
- **Bouton "Voir sur mon vaisseau"** dans chaque fiche de la Boutique :
  applique l'apparence a l'aperçu sans depenser de cristaux ni de
  l'equiper ; revient automatiquement a l'equipement reel en quittant la
  Boutique.
- **Patterns de tir signature par boss** (`scripts/Main.gd`, fonctions
  `_fire_pattern_*`) : chacun des 5 boss de secteur a sa propre attaque —
  eventail simple (Sentinelle Azur), eventail pivotant (Devoreur Pourpre),
  mur large (Colosse Ambre), rafale visee (Faucheur Ecarlate), eventail
  balayant (Gardien Emeraude).
- **Accessibilite** : options "Reduire les secousses d'ecran" (desactive
  le tremblement de camera) et "Contraste eleve" (renforce le contour des
  textes du HUD et assombrit le voile de menu) dans Parametres.
- **Bonus de connexion quotidien** : cristaux offerts a la premiere
  ouverture de l'app chaque jour, avec un bonus croissant selon la serie
  de jours consecutifs (jusqu'a 14 jours). Annonce sur l'ecran d'accueil.
- **Tutoriel** : court recapitulatif des mecaniques affiche automatiquement
  a la toute premiere partie, et accessible a tout moment via Parametres
  > Revoir le tutoriel.

### Version 1.5.0 — design premium de la Boutique

Les objets de la Boutique reposaient uniquement sur des changements de
couleur du meme vaisseau et des badges/trainees representes par de simples
points colores. Refonte complete pour donner a chaque objet une vraie
presence visuelle :

- **10 icones de badge dediees, dessinees a la main** (`assets/badge_*.svg`)
  au lieu de points de couleur : comete, meteore, etoile filante, nebuleuse,
  satellite, pulsar, trou noir, supernova, constellation, couronne
  galactique — chacune une forme reconnaissable, teintee selon le badge.
- **6 icones de style de trainee dediees** (`assets/trail_*.svg`) qui
  representent visuellement le comportement de particules (poussiere,
  etincelles, flux, fumee, flamme, anneau) au lieu d'un simple point.
- **Fiches boutique repensees** : mise en scene du vaisseau plus grande
  (74px) sur un halo colore selon la rarete, icones de trainee et de badge
  affichees avec leur nom, au lieu d'un empilement de texte et de points.
- **Traitement visuel par rarete** : bordure et lueur de la carte colorees
  selon Commun (gris discret) / Rare (bleu) / Epique (violet) / Legendaire
  (or, bordure plus epaisse, lueur plus forte et ruban etoile dans le
  coin) — les objets rares se distinguent au premier coup d'oeil dans la
  grille, comme dans une vraie boutique de cosmetiques.
- **Grille reorganisee en 2 colonnes** (au lieu de 3) pour laisser plus de
  place a chaque fiche desormais plus riche ; 6 objets par page au lieu de
  12.



Le jeu calcule un ratio **score / temps** (points par seconde) a la fin de
chaque partie et l'envoie a une base de donnees en ligne, avec le temps de
la partie comme critere de departage. Le classement est consultable depuis
l'ecran d'accueil ou l'ecran de fin de partie ("Classement").

Aucun serveur a coder ou a faire tourner : les donnees sont stockees dans
**Firebase Firestore** (le plan gratuit "Spark" suffit largement), un service
entierement gere par Google. La seule chose a faire, une seule fois, c'est de
creer un projet Firebase gratuit et de coller une configuration :

1. Va sur https://console.firebase.google.com/ et cree un projet (gratuit,
   aucune carte bancaire requise pour le plan Spark).
2. Dans le menu de gauche, cherche **"Databases & Storage" > "Firestore"**
   (selon la version de la console, l'intitule peut varier legerement).
   Clique sur **"Creer une base de donnees"**. Choisis l'edition
   **"Standard"** (pas "Enterprise"). Pour le **"Database ID"**, laisse ou
   tape exactement `(default)` avec les parentheses : le script du jeu
   pointe precisement vers cette base par defaut. Choisis une region proche
   de toi, puis pour les regles de depart choisis le mode qui bloque tout
   ("production" / "Deny all") : on les remplace nous-memes a l'etape
   suivante.
3. Va dans l'onglet **Regles** de Firestore. **Efface tout le contenu de
   l'editeur** et colle **uniquement** le bloc ci-dessous (rien d'autre :
   pas de titre, pas de texte d'explication), puis clique sur **Publier** :

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /scores/{pseudoId} {
         allow read: if true;

         allow create: if request.resource.data.keys().hasAll(['pseudo', 'score', 'elapsed', 'ratio'])
                       && request.resource.data.pseudo is string
                       && request.resource.data.pseudo == pseudoId
                       && request.resource.data.pseudo.size() >= 3
                       && request.resource.data.pseudo.size() <= 16
                       && request.resource.data.score is int
                       && request.resource.data.score >= 0
                       && request.resource.data.elapsed is number
                       && request.resource.data.elapsed > 0
                       && request.resource.data.ratio is number;

         allow update: if request.resource.data.pseudo == resource.data.pseudo
                       && request.resource.data.score is int
                       && request.resource.data.score > resource.data.score;

         allow delete: if false;
       }
     }
   }
   ```

4. Recupere ton **ID de projet** : icone d'engrenage en haut a gauche >
   **Parametres du projet** > General > "ID du projet" (une chaine du style
   `astro-recolte-1234`).
5. Ouvre `scripts/Leaderboard.gd` et remplace la ligne :
   `const FIREBASE_PROJECT_ID: String = "TON-PROJECT-ID-FIREBASE"`
   par ton propre ID de projet.
6. Reexporte l'APK Android (la permission Internet est deja activee dans
   `export_presets.cfg`).

Pas de cle API a gerer : les regles ci-dessus autorisent des requetes non
authentifiees mais valident les donnees (format du pseudo, score >= 0, et
surtout : une mise a jour n'est acceptee que si le nouveau score est
meilleur que l'ancien).

**Limite importante a connaitre** : ce systeme est simple par conception et
ne verifie pas l'identite du joueur (pas de compte, pas de mot de passe).
N'importe qui capable d'envoyer une requete HTTP peut en theorie pousser un
score truque sous un pseudo existant (les regles empechent seulement qu'un
score renvoye soit *inferieur* a l'ancien). C'est largement suffisant pour un
classement amical entre joueurs de bonne foi, mais ce n'est pas un systeme
anti-triche robuste. Pour ca, il faudrait une vraie authentification des
joueurs (Firebase Authentication) et une validation cote serveur (Cloud
Functions), ce qui impliquerait cette fois d'ecrire et heberger du code.

Le classement affiche est mis a jour a chaque ouverture de l'ecran
"Classement" (pas en temps reel) : il faut le rouvrir pour voir les scores
des autres joueurs.

## Publicite - Unity Ads (SDK natif)

Les publicites sont fournies par **Unity Ads** via le SDK natif Android
(plugin `UnityAds`, dans `android/plugins/unityads/`). L'application
"AstroRecolte" (Game ID: `800360647`) dispose de 3 placements :
- **Banner_Android** : banniere en bas de l'ecran pendant la partie
- **Interstitial_Android** : interstitiel tous les N secteurs + ecran game over
- **Rewarded_Android** : pub recompensee pour doubler les cristaux

**La pub recompensee n'apparait jamais automatiquement** : elle ne s'affiche
que quand le joueur clique sur le bouton "Regarder une pub pour x2 cristaux"
de l'ecran de fin de partie.

Pour configurer Unity Ads :

1. Verifie les placements dans Unity Dashboard (cloud.unity.com > Monetisation > Placements).
2. Le plugin Unity Ads est gere automatiquement lors de l'export Android.
3. En mode test, les pubs affichent des creatives de test Unity.

La recompense est accordee quand la video a ete visionnee completement
(callback `onRewardedCompleted` du SDK Unity Ads).

Sur desktop (PC/Mac/Linux), la pub s'ouvre dans le navigateur systeme avec
un timer de 15 secondes comme fallback.

Deux garde-fous sont en place :

- **Consentement (GDPR)** : avant la premiere pub, un ecran demande
  l'autorisation (Accepter / Refuser). Le choix est memorise dans
  `user://astro_recolte_ads.cfg` et modifiable a tout moment dans
  Parametres > Publicites.
- **Plafond quotidien** : au maximum 5 pubs recompensees par jour
  (`MAX_REWARDED_PER_DAY` dans `AdsManager.gd`), compteur sauvegarde, pour
  ne pas casser l'economie des cristaux. Le bouton x2 se desactive avec le
  message adequat une fois le plafond atteint.

La pub est neutralisee sur desktop (pas de WebView) : le jeu reste jouable
pendant le developpement.

---

## Player Description (English)

### Astro Harvest

Dive into space with **Astro Harvest**, a fast-paced, colorful arcade game where every second counts.

**The concept:** pilot your ship in 8 directions to catch falling **stars** for points and crystals, while dodging **meteors** and enemy ships. Your cannon fires automatically — focus on dodging and positioning.

**During the run:**
- Enemy ships (hunters and interceptors) cross the screen — your shots destroy them, or you can dodge them.
- Every ~40 seconds, a **sector boss** appears with its own health bar and signature attack patterns. Defeat it to advance to the next sector... and the run continues, getting more intense, **endlessly**.
- 5 sectors with different themes (Blue Belt, Violet Nebula, Crimson Zone…) cycling with increasing difficulty.
- Chain star catches without taking damage to build your **combo** and multiply earnings.

**Progression & customization:**
- Earn **crystals** from each run and daily login (daily bonus streak!).
- Spend them in the **Shop**: over **1,000 cosmetic sets** (hull + trail + badge) to collect and equip, from Common to Legendary.

**Also features:**
- Online **leaderboard** to compare your score/time ratio with other players (unique nickname).
- Touch controls optimized for mobile (joystick) and keyboard on desktop.
- Immersive music and sound effects, difficulty settings and accessibility options (reduce screen shake, high contrast).
- Automatic save of your best score.

*Catch the stars, dodge the meteors, beat the bosses — and see how far you can go.*

### Short Description (Uptodown, ~400 chars)

> Fast-paced space arcade! Pilot your ship to catch stars and dodge meteors. Fight unique sector bosses every ~40s in an endless, increasingly intense run. Earn crystals to unlock 1,000+ cosmetic sets (hull, trail, badge) in the shop. Compete on the global leaderboard. Touch & keyboard controls. Daily rewards, combo system, immersive soundtrack. How far can you go?

### Recommended Screenshots for Uptodown

| # | Screen | What to show |
|---|--------|-------------|
| 1 | **Title / Start menu** | Game title, Play button, language options (FR/EN) |
| 2 | **Gameplay** | Ship dodging meteors + catching stars, HUD visible (score, lives, time, crystals) |
| 3 | **Boss fight** | Sector boss with health bar, bullet patterns, intense action |
| 4 | **Game Over** | Score, crystals earned, x2 crystals button, replay option |
| 5 | **Game Over (after x2 reward)** | Bonus x2 activated, new record shown |
| 6 | **Shop** | Cosmetic cards grid with rarity colors (Common → Legendary) |
| 7 | **Online Leaderboard** | Player rankings with score/time ratios |
| 8 | **Settings (fullscreen)** | Difficulty, audio, accessibility, language options |
| 9 | **Language selection** | FR/EN picker on first launch |
| 10 | **Combo in action** | Gameplay moment with "Combo x15!" floating text + particle effects |

**Tips:**
- Capture in **landscape mode** (game is 960×540 landscape).
- Screenshots #2 (gameplay) and #3 (boss) are the most impactful for the store listing.
- Screenshot #6 (shop) shows content depth.
- Avoid the ad consent screen (not appealing).
>>>>>>> 8d76003 (Initial commit)
