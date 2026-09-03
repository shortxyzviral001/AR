# Changelog

Historique des versions d'Astro Récolte (nom commercial : Astro Harvest).

## Version 1.0.0 — sortie initiale et corrections

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



