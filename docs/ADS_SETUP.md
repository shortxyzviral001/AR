# Publicité — Unity Ads (SDK natif) + Adsterra (desktop)


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

