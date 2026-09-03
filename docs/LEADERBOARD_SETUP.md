# Classement en ligne — configuration Firebase Firestore

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
5. Ouvre `scripts/Leaderboard.gd` et remplace la valeur de la constante
   `FIREBASE_PROJECT_ID` par ton propre ID de projet (le depot actuel pointe
   deja vers le projet Firebase de production du jeu — ne change cette
   valeur que si tu forkes le projet pour ton propre usage).
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

