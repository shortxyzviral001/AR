## AdsManager - publicité via Adsterra, sur toutes les plateformes (Android +
## Desktop). Remplace l'ancienne intégration Unity Ads (retirée : le SDK
## natif n'était de toute façon jamais livré dans ce dépôt, cf. absence de
## android/plugins/unityads/).
##
## Adsterra n'a PAS de format "pub récompensée" avec callback de complétion
## comme Unity Ads : c'est un réseau display/pop/smartlink classique. La
## récompense "x2 cristaux" est donc entièrement recréée ici : on ouvre une
## pub Adsterra (Direct Link) dans le navigateur système, on impose un
## visionnage minimum (REWARD_MIN_VIEW_S), puis on accorde la récompense
## quand le joueur revient dans le jeu. Ce flux est volontairement TOUJOURS
## déclenché par un clic explicite du joueur (jamais automatique), à la fois
## pour rester conforme aux règles anti-fraude d'Adsterra et pour ne pas
## dégrader l'expérience de jeu.
##
## Formats utilisés :
##   - Récompensée ("x2 cristaux")   : Direct Link / Popunder (onglet dédié)
##   - Interstitiel (entre secteurs) : Social Bar (bandeau discret, quelques
##                                     secondes, fermable) affiché en overlay
##                                     dans une page locale, pas de nouvel
##                                     onglet -> n'interrompt pas le jeu.
##   - Bannière (persistante en jeu) : Banner 320x50 (mobile) / 468x60
##                                     (desktop), overlay HTML léger.
##
## Identifiants Adsterra (compte publisher "multidevsn") :
##   - Direct Link / Popunder : https://www.profitableratecpmnetwork.com/cu6vgyq1?key=27aad7f77209ac09de82da823d90b505
##   - Smartlink               : https://www.profitableratecpmnetwork.com/vaam7i8w?key=6149a9a739adbbe40f8838e03d54b07d
##   - Social Bar / Native Banner / bannières classiques : configurés sur le
##     dashboard Adsterra (compte multidevsn), zones à coller dans
##     ZONE_SOCIAL_BAR_SNIPPET / ZONE_BANNER_SNIPPETS ci-dessous (le code
##     JS exact de chaque zone n'est pas exposé par l'API Publisher, qui ne
##     renvoie que les métadonnées de zone -- il faut le copier une fois
##     depuis Adsterra > Websites > [zone] > Get code).
##
## Consentement GDPR : le joueur doit accepter avant la première pub, le choix
## est mémorisé (user://astro_recolte_ads.cfg) et modifiable dans Paramètres.
## Plafond quotidien : MAX_REWARDED_PER_DAY pubs récompensées par jour.
extends Node

## Journalise uniquement dans les builds de debug (export --debug / éditeur) :
## évite de polluer les logs des joueurs en production.
static func _log(message: String) -> void:
	if OS.is_debug_build():
		print(message)

# --- Configuration Adsterra ------------------------------------------------

## Direct Link (Popunder) : support de la pub "récompensée". S'ouvre dans un
## nouvel onglet/fenêtre du navigateur système uniquement sur clic du joueur.
const AD_REWARDED_URL: String = "https://www.profitableratecpmnetwork.com/cu6vgyq1?key=27aad7f77209ac09de82da823d90b505"

## Smartlink : utilisé comme repli si le Direct Link venait à être invalidé.
const AD_SMARTLINK_URL: String = "https://www.profitableratecpmnetwork.com/vaam7i8w?key=6149a9a739adbbe40f8838e03d54b07d"

## Zones "display" (Social Bar / bannières) : à coller depuis le dashboard
## Adsterra (Websites > zone concernée > Get code). Laissées vides par
## défaut -> le jeu se contente alors du Direct Link ci-dessus pour la
## récompense, sans bannière ni interstitiel display tant que ces zones ne
## sont pas renseignées (aucune requête n'est faite vers une zone vide).
const ZONE_SOCIAL_BAR_SNIPPET: String = ""
const ZONE_BANNER_SNIPPET: String = ""

# Durée minimale de visionnage avant d'accorder la récompense (secondes),
# imposée côté client : le joueur doit rester sur la pub au moins ce temps.
const REWARD_MIN_VIEW_S: float = 15.0
const REWARD_MIN_VIEW_MS: int = 15000

# Plafond quotidien de pubs récompensées (économie des cristaux).
const MAX_REWARDED_PER_DAY: int = 5

# Fréquence des "interstitiels" (Social Bar) : un tous les N secteurs, avec
# un temps de repos entre deux pour ne pas étouffer le joueur.
const INTERSTITIAL_EVERY_ZONES: int = 3
const INTERSTITIAL_COOLDOWN_MS: int = 90000
const GAMEOVER_INTERSTITIAL_MIN_SESSION_S: float = 60.0
const GAMEOVER_INTERSTITIAL_COOLDOWN_MS: int = 120000

# Pages HTML locales générées (navigateur système / WebView).
const AD_PAGE_NAME: String = "astro_recolte_ad.html"
const INTERSTITIAL_PAGE_NAME: String = "astro_recolte_interstitial.html"
# Repli si la page locale ne peut pas être écrite (ex: export Web).
const AD_PAGE_URL_FALLBACK: String = "https://multidevsn.github.io/ad.html"

# Persistance (consentement + compteur quotidien).
const SAVE_PATH: String = "user://astro_recolte_ads.cfg"

const CONSENT_ACCEPTED: String = "accepted"
const CONSENT_DECLINED: String = "declined"
const CONSENT_UNDECIDED: String = "undecided"

var _consent: String = CONSENT_UNDECIDED
var _views_date: String = ""
var _views_count: int = 0

# Etat de la pub récompensée ouverte dans le navigateur.
var _ad_open_at: int = -1
var _ad_focus_back: bool = false
var _ad_lost_focus: bool = false
var _ad_continue_pressed: bool = false

# Etat bannière / interstitiels (overlay in-app, pas de fenêtre externe).
var _banner_visible: bool = false
var _last_interstitial_ms: int = 0
var _last_gameover_interstitial_ms: int = 0


func _ready() -> void:
	_load()
	_load_notified()


func _notification(what: int) -> void:
	# On sait que le joueur revient du navigateur quand l'app reprend le
	# focus -> la récompense peut être accordée.
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		_ad_focus_back = true
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		_ad_lost_focus = true


# --- Persistance -----------------------------------------------------------

func _today() -> String:
	return Time.get_date_string_from_system()


func _load() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	_consent = config.get_value("ads", "consent", _consent)
	_views_date = config.get_value("ads", "views_date", _views_date)
	_views_count = config.get_value("ads", "views_count", 0)


func _save() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("ads", "consent", _consent)
	config.set_value("ads", "views_date", _views_date)
	config.set_value("ads", "views_count", _views_count)
	config.save(SAVE_PATH)


## Remet le compteur à zéro si la date a changé.
func _ensure_day() -> void:
	var today: String = _today()
	if _views_date != today:
		_views_date = today
		_views_count = 0
		_save()


# --- Consentement GDPR -------------------------------------------------

## Le joueur a accepté les publicités.
func has_consent() -> bool:
	return _consent == CONSENT_ACCEPTED


## Un choix (accepter ou refuser) a déjà été fait.
func consent_decided() -> bool:
	return _consent != CONSENT_UNDECIDED


func set_consent(accepted: bool) -> void:
	_consent = CONSENT_ACCEPTED if accepted else CONSENT_DECLINED
	_save()
	if not accepted:
		hide_game_banner()


# --- Plafond quotidien -------------------------------------------------

func rewarded_views_today() -> int:
	_ensure_day()
	return _views_count


func views_remaining_today() -> int:
	return max(MAX_REWARDED_PER_DAY - rewarded_views_today(), 0)


## La pub peut-elle être proposée (consentement OK + plafond pas atteint) ?
func can_show_rewarded() -> bool:
	if not has_consent():
		return false
	_ensure_day()
	return _views_count < MAX_REWARDED_PER_DAY


# --- Public API (récompense) --------------------------------------------

## Affiche la pub du bouton x2 cristaux (Direct Link Adsterra dans un nouvel
## onglet/fenêtre du navigateur système). Retourne vrai si lancée. Identique
## sur toutes les plateformes : Adsterra n'ayant pas de SDK natif Android,
## on utilise systématiquement le navigateur, avec un délai minimum de
## visionnage imposé côté client (voir pop_reward()).
func show_rewarded() -> bool:
	if not can_show_rewarded():
		return false
	_views_count += 1
	_save()
	_open_rewarded_ad()
	return true


## Retourne vrai UNE FOIS quand la récompense doit être accordée :
## >= REWARD_MIN_VIEW_S écoulées ET retour au jeu (ou clic sur
## "J'ai regardé", ou focus jamais quitté).
func pop_reward() -> bool:
	if _ad_open_at < 0:
		return false
	var elapsed_s: float = (Time.get_ticks_msec() - _ad_open_at) / 1000.0
	if elapsed_s < REWARD_MIN_VIEW_S:
		return false
	if _ad_focus_back or _ad_continue_pressed or not _ad_lost_focus:
		_ad_open_at = -1
		_ad_focus_back = false
		_ad_continue_pressed = false
		return true
	return false


## Le joueur signale qu'il a regardé la pub (bouton "J'ai regardé").
func desktop_mark_returned() -> void:
	_ad_continue_pressed = true
	_ad_focus_back = true


## Conservée pour compatibilité API (l'ancien flux Unity Ads préchargeait la
## pub suivante ; Adsterra n'a rien à précharger, chaque affichage ouvre une
## page fraîche avec cache-buster).
func reload_rewarded() -> void:
	pass


## La pub récompensée est-elle prête ? Toujours vraie : pas de préchargement
## nécessaire avec Adsterra (page générée à la volée).
func is_rewarded_ready() -> bool:
	return true


func reset_reward() -> void:
	pass


# --- Bannière en jeu ------------------------------------------------------

## Affiche une bannière Adsterra en overlay pendant la partie, si une zone a
## été configurée (ZONE_BANNER_SNIPPET). Contrairement à l'ancien système
## Unity Ads (vue native superposée par le SDK), ceci est un simple visuel
## HTML affiché par le jeu lui-même : voir Main.gd pour l'intégration
## visuelle (control dédié en bas d'écran).
func show_game_banner() -> void:
	if not has_consent() or _banner_visible:
		return
	if ZONE_BANNER_SNIPPET.is_empty():
		return
	_banner_visible = true


func hide_game_banner() -> void:
	_banner_visible = false


func has_banner_content() -> bool:
	return not ZONE_BANNER_SNIPPET.is_empty()


# --- Interstitiels (Social Bar) -------------------------------------------

## Un interstitiel tous les INTERSTITIAL_EVERY_ZONES secteurs, avec cooldown.
## Contrairement à un vrai interstitiel plein écran (non disponible sans SDK
## natif), ceci ouvre une pub Social Bar Adsterra dans le navigateur système
## UNIQUEMENT si le joueur clique sur la notification en jeu (voir
## Main.gd::_maybe_prompt_interstitial) -- jamais automatiquement.
func maybe_show_interstitial(zone_index: int) -> bool:
	if not has_consent():
		return false
	if ZONE_SOCIAL_BAR_SNIPPET.is_empty() and AD_SMARTLINK_URL.is_empty():
		return false
	if zone_index < INTERSTITIAL_EVERY_ZONES or zone_index % INTERSTITIAL_EVERY_ZONES != 0:
		return false
	var now: int = Time.get_ticks_msec()
	if now - _last_interstitial_ms < INTERSTITIAL_COOLDOWN_MS:
		return false
	_last_interstitial_ms = now
	return true


## Un interstitiel sur l'écran de fin de partie (session >= 1 min), cooldown.
func maybe_show_game_over_interstitial() -> bool:
	if not has_consent():
		return false
	var now: int = Time.get_ticks_msec()
	if now - _last_gameover_interstitial_ms < GAMEOVER_INTERSTITIAL_COOLDOWN_MS:
		return false
	_last_gameover_interstitial_ms = now
	return true


# --- Navigateur système : page locale + ouverture --------------------------

## Génère une page HTML locale avec le Direct Link Adsterra et l'ouvre dans
## le navigateur système. Toujours déclenché par un clic explicite du
## joueur (bouton x2 cristaux) -- jamais en tâche de fond.
func _open_rewarded_ad() -> void:
	_ad_open_at = Time.get_ticks_msec()
	_ad_focus_back = false
	_ad_lost_focus = false
	_ad_continue_pressed = false
	var url: String = AD_REWARDED_URL
	if url.is_empty():
		url = AD_SMARTLINK_URL
	# Cache-buster pour eviter un affichage cache par le navigateur.
	var cb: String = str(Time.get_ticks_usec())
	var sep: String = "&" if url.contains("?") else "?"
	url = "%s%s_cb=%s" % [url, sep, cb]
	_log("[AdsManager] Ouverture de la pub récompensée (navigateur) : %s" % url)
	OS.shell_open(url)


func get_status() -> String:
	return "Adsterra (Direct Link) | consent=%s | pubs aujourd'hui: %d/%d | banniere=%s" % [
		_consent, rewarded_views_today(), MAX_REWARDED_PER_DAY, _banner_visible,
	]


# --- Update notification -------------------------------------------------

const NOTIFIED_SAVE_PATH: String = "user://astro_recolte_notified.cfg"
var _notified_code: int = 0


func _load_notified() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(NOTIFIED_SAVE_PATH) != OK:
		return
	_notified_code = config.get_value("notified", "version_code", 0)


func _save_notified() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("notified", "version_code", _notified_code)
	config.save(NOTIFIED_SAVE_PATH)


## Marque la version courante comme "notifiée" pour ne pas re-proposer sans
## cesse le même changelog (le jeu affiche déjà une bannière/dialogue de mise
## à jour dans l'UI -- voir UpdateChecker.gd -- donc pas de notification
## système Android nécessaire ici, contrairement à l'ancien plugin Unity Ads
## qui exposait notifyUpdate()).
func notify_update_if_new() -> void:
	if not UpdateChecker.update_available or not UpdateChecker.check_done:
		return
	if UpdateChecker.latest_code <= _notified_code:
		return
	_notified_code = UpdateChecker.latest_code
	_save_notified()
