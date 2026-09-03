## AdsManager - publicite Unity Ads (Android) + Adsterra (desktop).
##
## Plateformes :
##   - Android  : SDK Unity Ads natif (banniere, interstitiel, recompense)
##                via le plugin UnityAds.
##   - PC / autres : les tags HTML Adsterra sont rendus dans le navigateur
##                systeme (page locale generee par AdsManager). La recompense
##                est accordee apres un temps minimum de visionnage
##                (REWARD_MIN_VIEW_S) + retour au jeu.
##
## Unity Ads IDs (Android) :
##   - Game ID : 800360647
##   - Placements : Banner_Android, Interstitial_Android, Rewarded_Android
##
## Consentement GDPR : le joueur doit accepter avant la premiere pub, le choix
## est memorise (user://astro_recolte_ads.cfg) et modifiable dans Parametres.
## Plafond quotidien : MAX_REWARDED_PER_DAY pubs recompensees par jour.
extends Node

# --- Unity Ads Configuration (Android) ------------------------------------
# Game ID Unity Ads (depuis cloud.unity.com)
const UNITY_GAME_ID: String = "800360647"

# Placement IDs (configures dans Unity Dashboard)
const PLACEMENT_INTERSTITIAL: String = "Interstitial_Android"
const PLACEMENT_REWARDED: String = "Rewarded_Android"
const PLACEMENT_BANNER: String = "Banner_Android"

# Mode test (mettre a false en production)
const TEST_MODE: bool = true  # TODO: repasser a false en production

# --- Zones Adsterra (desktop fallback) ------------------------------------
# Tags HTML/JS Adsterra utilises dans la page desktop (navigateur systeme).
const DESKTOP_AD_ZONES: Array[String] = [
	"""<script>
  atOptions = {
    'key' : 'f4572b309ba38734770ce69a48a06606',
    'format' : 'iframe',
    'height' : 250,
    'width' : 300,
    'params' : {}
  };
</script>
<script src="https://www.highperformanceformat.com/f4572b309ba38734770ce69a48a06606/invoke.js"></script>""",
	"""<script async="async" data-cfasync="false" src="https://pl30848212.effectivecpmnetwork.com/9d4b72438678918e9dd773f5315482a0/invoke.js"></script>
<div id="container-9d4b72438678918e9dd773f5315482a0"></div>""",
]
var _desktop_rotation_index: int = 0

# Duree minimale de visionnage avant d'accorder la recompense (secondes),
# enforcee cote Android par le plugin et cote desktop par AdsManager.
const REWARD_MIN_VIEW_S: float = 15.0
const REWARD_MIN_VIEW_MS: int = 15000

# Plafond quotidien de pubs recompensees (economie des cristaux).
const MAX_REWARDED_PER_DAY: int = 5

# Freq. des interstitiels (Android) : un tous les N secteurs + un sur game
# over, avec un temps de repos entre deux pour ne pas etouffer le joueur.
const INTERSTITIAL_EVERY_ZONES: int = 3
const INTERSTITIAL_COOLDOWN_MS: int = 90000
const GAMEOVER_INTERSTITIAL_MIN_SESSION_S: float = 60.0
const GAMEOVER_INTERSTITIAL_COOLDOWN_MS: int = 120000

# Page locale generee pour les pubs desktop (navigateur systeme).
const DESKTOP_AD_PAGE_NAME: String = "unity_ads_ad.html"
# Repli si la page locale ne peut pas etre ecrite (ex: export Web).
const DESKTOP_AD_PAGE_URL_FALLBACK: String = "https://multidevsn.github.io/ad.html"

# Persistance (consentement + compteur quotidien).
const SAVE_PATH: String = "user://astro_recolte_ads.cfg"

const CONSENT_ACCEPTED: String = "accepted"
const CONSENT_DECLINED: String = "declined"
const CONSENT_UNDECIDED: String = "undecided"

var _consent: String = CONSENT_UNDECIDED
var _views_date: String = ""
var _views_count: int = 0
var _plugin_missing: bool = false
var _initialized: bool = false

# Etat desktop (pub ouverte dans le navigateur).
var _desktop_open_at: int = -1
var _desktop_focus_back: bool = false
var _desktop_lost_focus: bool = false
var _desktop_continue_pressed: bool = false

# Etat banniere / interstitiels.
var _banner_visible: bool = false
var _last_interstitial_ms: int = 0
var _last_gameover_interstitial_ms: int = 0
var _reward_pending: bool = false


func _ready() -> void:
	_load()
	_load_notified()
	if OS.get_name() == "Android":
		if not Engine.has_singleton("UnityAds"):
			push_warning("[AdsManager] Plugin UnityAds introuvable - pubs indisponibles")
			_plugin_missing = true
		else:
			print("[AdsManager] Plugin UnityAds pret - initialisation...")
			var plugin = _get_plugin()
			if plugin:
				plugin.initialize(UNITY_GAME_ID, TEST_MODE)
				# Connecter les signaux du plugin
				plugin.connect("onInitialized", _on_unity_initialized)
				plugin.connect("onRewardedLoaded", _on_rewarded_loaded)
				plugin.connect("onRewardedFailed", _on_rewarded_failed)
				plugin.connect("onRewardedCompleted", _on_rewarded_completed)
				plugin.connect("onRewardedHidden", _on_rewarded_hidden)
				plugin.connect("onInterstitialLoaded", _on_interstitial_loaded)
				plugin.connect("onInterstitialFailed", _on_interstitial_failed)
				plugin.connect("onBannerLoaded", _on_banner_loaded)
				plugin.connect("onBannerFailed", _on_banner_failed)


func _notification(what: int) -> void:
	# Sur desktop, on sait que le joueur revient du navigateur quand l'app
	# reprend le focus -> la recompense peut etre accordee.
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		_desktop_focus_back = true
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		_desktop_lost_focus = true


# --- Unity Ads Callbacks -------------------------------------------------

func _on_unity_initialized(success: bool) -> void:
	if success:
		print("[AdsManager] Unity Ads initialise avec succes")
		_initialized = true
		# Precharger les pubs
		_preload_ads()
	else:
		push_warning("[AdsManager] Echec initialisation Unity Ads")


func _preload_ads() -> void:
	if not _initialized:
		return
	var plugin = _get_plugin()
	if plugin == null:
		return
	# Precharger interstitiel et rewarded
	plugin.loadInterstitial(PLACEMENT_INTERSTITIAL)
	plugin.loadRewarded(PLACEMENT_REWARDED)


func _on_rewarded_loaded(_placement: String) -> void:
	print("[AdsManager] Pub recompensee pretee")


func _on_rewarded_failed(_placement: String, error: String) -> void:
	push_warning("[AdsManager] Echec chargement pub recompensee: ", error)


func _on_rewarded_completed(_placement: String) -> void:
	print("[AdsManager] Pub recompensee terminee - recompense accordee")
	_reward_pending = true


func _on_rewarded_hidden(_placement: String) -> void:
	print("[AdsManager] Pub recompensee fermee")


func _on_interstitial_loaded(_placement: String) -> void:
	print("[AdsManager] Interstitiel prete")


func _on_interstitial_failed(_placement: String, error: String) -> void:
	push_warning("[AdsManager] Echec chargement interstitiel: ", error)


func _on_banner_loaded(_placement: String) -> void:
	print("[AdsManager] Banniere chargée")


func _on_banner_failed(_placement: String, error: String) -> void:
	push_warning("[AdsManager] Echec chargement banniere: ", error)


# --- Persistance ---------------------------------------------------------

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


## Remet le compteur a zero si la date a change.
func _ensure_day() -> void:
	var today: String = _today()
	if _views_date != today:
		_views_date = today
		_views_count = 0
		_save()


func _get_plugin():
	if _plugin_missing or OS.get_name() != "Android":
		return null
	return Engine.get_singleton("UnityAds")


# --- Consentement GDPR ---------------------------------------------------

## Le joueur a accepte les publicites.
func has_consent() -> bool:
	return _consent == CONSENT_ACCEPTED


## Un choix (accepter ou refuser) a deja ete fait.
func consent_decided() -> bool:
	return _consent != CONSENT_UNDECIDED


func set_consent(accepted: bool) -> void:
	_consent = CONSENT_ACCEPTED if accepted else CONSENT_DECLINED
	_save()
	if not accepted:
		hide_game_banner()


# --- Plafond quotidien ---------------------------------------------------

func rewarded_views_today() -> int:
	_ensure_day()
	return _views_count


func views_remaining_today() -> int:
	return max(MAX_REWARDED_PER_DAY - rewarded_views_today(), 0)


## La pub peut-elle etre proposee (consentement OK + plafond pas atteint) ?
func can_show_rewarded() -> bool:
	if not has_consent():
		return false
	_ensure_day()
	return _views_count < MAX_REWARDED_PER_DAY


# --- Public API (recompense) ---------------------------------------------

## Affiche la pub du bouton x2 cristaux. Retourne vrai si lancee.
## Android : SDK Unity Ads. PC/autres : navigateur systeme.
func show_rewarded() -> bool:
	if not can_show_rewarded():
		return false
	if OS.get_name() == "Android":
		var plugin = _get_plugin()
		if plugin == null:
			return false
		if not plugin.isReady(PLACEMENT_REWARDED):
			# Recharger et retenter
			plugin.loadRewarded(PLACEMENT_REWARDED)
			return false
		_views_count += 1
		_save()
		plugin.showRewarded(PLACEMENT_REWARDED)
		return true
	# Desktop / autres plateformes : ouvre la pub dans le navigateur systeme.
	_views_count += 1
	_save()
	_open_desktop_ad()
	return true


## Retourne vrai UNE FOIS quand la recompense doit etre accordee :
##   - Android : callback onRewardedCompleted du plugin Unity Ads.
##   - Desktop : >= REWARD_MIN_VIEW_S ecoulees ET retour au jeu (ou clic sur
##     "J'ai regarde", ou focus jamais quitte).
func pop_reward() -> bool:
	if OS.get_name() == "Android":
		if _reward_pending:
			_reward_pending = false
			return true
		return false
	if _desktop_open_at < 0:
		return false
	var elapsed_s: float = (Time.get_ticks_msec() - _desktop_open_at) / 1000.0
	if elapsed_s < REWARD_MIN_VIEW_S:
		return false
	if _desktop_focus_back or _desktop_continue_pressed or not _desktop_lost_focus:
		_desktop_open_at = -1
		_desktop_focus_back = false
		_desktop_continue_pressed = false
		return true
	return false


## (Desktop) Le joueur signale qu'il a regarde la pub (bouton "J'ai regarde").
func desktop_mark_returned() -> void:
	_desktop_continue_pressed = true
	_desktop_focus_back = true


## Precharger les pubs recompensees pour le prochain affichage.
func reload_rewarded() -> void:
	if OS.get_name() != "Android":
		return
	var plugin = _get_plugin()
	if plugin == null:
		return
	if _initialized:
		plugin.loadRewarded(PLACEMENT_REWARDED)


## La pub recompensee est-elle prete ?
func is_rewarded_ready() -> bool:
	if OS.get_name() != "Android":
		return true
	var plugin = _get_plugin()
	if plugin == null:
		return false
	return plugin.isReady(PLACEMENT_REWARDED)


func reset_reward() -> void:
	pass


# --- Banniere en jeu (Android) -------------------------------------------

## Affiche la banniere Unity Ads pendant la partie (Android uniquement).
func show_game_banner() -> void:
	if OS.get_name() != "Android":
		return
	if not has_consent() or _banner_visible:
		return
	var plugin = _get_plugin()
	if plugin == null:
		return
	if not _initialized:
		return
	_banner_visible = true
	plugin.showBanner(PLACEMENT_BANNER, 0)


func hide_game_banner() -> void:
	if OS.get_name() != "Android":
		return
	if not _banner_visible:
		return
	var plugin = _get_plugin()
	if plugin == null:
		return
	_banner_visible = false
	plugin.hideBanner()


# --- Interstitiels (Android) ---------------------------------------------

## Un interstitiel tous les INTERSTITIAL_EVERY_ZONES secteurs, avec cooldown.
func maybe_show_interstitial(zone_index: int) -> void:
	if OS.get_name() != "Android":
		return
	if not has_consent():
		return
	if zone_index < INTERSTITIAL_EVERY_ZONES or zone_index % INTERSTITIAL_EVERY_ZONES != 0:
		return
	var now: int = Time.get_ticks_msec()
	if now - _last_interstitial_ms < INTERSTITIAL_COOLDOWN_MS:
		return
	_last_interstitial_ms = now
	var plugin = _get_plugin()
	if plugin == null:
		return
	if not _initialized:
		return
	if not plugin.isReady(PLACEMENT_INTERSTITIAL):
		plugin.loadInterstitial(PLACEMENT_INTERSTITIAL)
		return
	plugin.showInterstitial(PLACEMENT_INTERSTITIAL)


## Un interstitiel sur l'ecran de fin de partie (session >= 1 min), cooldown.
func maybe_show_game_over_interstitial() -> void:
	if OS.get_name() != "Android":
		return
	if not has_consent():
		return
	var now: int = Time.get_ticks_msec()
	if now - _last_gameover_interstitial_ms < GAMEOVER_INTERSTITIAL_COOLDOWN_MS:
		return
	_last_gameover_interstitial_ms = now
	var plugin = _get_plugin()
	if plugin == null:
		return
	if not _initialized:
		return
	if not plugin.isReady(PLACEMENT_INTERSTITIAL):
		plugin.loadInterstitial(PLACEMENT_INTERSTITIAL)
		return
	plugin.showInterstitial(PLACEMENT_INTERSTITIAL)


# --- Desktop : page locale + navigateur -----------------------------------

## Genere une page HTML locale avec le code Unity Ads et l'ouvre dans le
## navigateur systeme.
func _open_desktop_ad() -> void:
	_desktop_open_at = Time.get_ticks_msec()
	_desktop_focus_back = false
	_desktop_lost_focus = false
	_desktop_continue_pressed = false
	var url: String = ""
	if _write_desktop_ad_page():
		var path: String = (OS.get_user_data_dir() + "/" + DESKTOP_AD_PAGE_NAME).replace("\\", "/")
		url = "file:///" + path
	else:
		url = DESKTOP_AD_PAGE_URL_FALLBACK
	print("[AdsManager] Ouverture de la pub (navigateur) : ", url)
	OS.shell_open(url)


## Choisit la prochaine zone Adsterra (round-robin) + cache-buster.
func _pick_desktop_zone() -> String:
	if DESKTOP_AD_ZONES.is_empty():
		return ""
	var snippet: String = str(DESKTOP_AD_ZONES[_desktop_rotation_index % DESKTOP_AD_ZONES.size()])
	_desktop_rotation_index += 1
	var cb: String = str(Time.get_ticks_usec())
	var out: String = snippet
	if out.contains("'params'"):
		out = out.replace("'params' : {}", "'params' : {'cb' : '%s'}" % cb)
		out = out.replace("'params': {}", "'params': {'cb' : '%s'}" % cb)
	out = out.replace("invoke.js", "invoke.js?cb=" + cb)
	return out


func _write_desktop_ad_page() -> bool:
	var snippet: String = _pick_desktop_zone()
	var html: String = """<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>Astro Recolte - Annonce</title>
<style>
  html, body { margin:0; padding:0; background:#050a14; color:#cfe0ff; font-family:system-ui, sans-serif; }
  body { min-height:100vh; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:18px; }
  .ad { width:100%; display:flex; align-items:center; justify-content:center; min-height:280px; }
  .hint { font-size:14px; color:#7f92b8; text-align:center; padding:0 16px; }
  .hint b { color:#ffd76b; }
</style>
</head>
<body>
  <div class="ad">""" + snippet + """</div>
  <p class="hint">Merci de regarder l'annonce !<br>Retourne dans le jeu (ou appuie sur <b>J'ai regarde</b>) pour recevoir ton bonus.</p>
</body>
</html>"""
	var file: FileAccess = FileAccess.open(OS.get_user_data_dir() + "/" + DESKTOP_AD_PAGE_NAME, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(html)
	file.close()
	return true


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


## Affiche une notification Android (menu deroulant) si une mise a jour
## est disponible et qu'on ne l'a pas deja notifiee pour cette version.
func notify_update_if_new() -> void:
	if OS.get_name() != "Android":
		return
	if not UpdateChecker.update_available or not UpdateChecker.check_done:
		return
	if UpdateChecker.latest_code <= _notified_code:
		return
	var plugin = _get_plugin()
	if plugin == null:
		return
	if not plugin.has_method("notifyUpdate"):
		return
	var lang: String = Settings.language if Settings.language != "" else "fr"
	var title: String = "Astro Recolte"
	var body: String = Settings.loc("update_body") % UpdateChecker.latest_version
	plugin.notifyUpdate(title, body, UpdateChecker.download_url)
	_notified_code = UpdateChecker.latest_code
	_save_notified()


func get_status() -> String:
	var base: String
	if OS.get_name() != "Android":
		base = "Desktop: pub dans le navigateur (min %ds)" % int(REWARD_MIN_VIEW_S)
	else:
		var plugin = _get_plugin()
		if plugin == null:
			base = "Android: plugin UnityAds ABSENT - verifier le manifest + reinstaller l'APK"
		else:
			base = "Android: " + plugin.getStatus()
	return "%s | consent=%s | pubs aujourd'hui: %d/%d | banniere=%s | init=%s" % [
		base, _consent, rewarded_views_today(), MAX_REWARDED_PER_DAY, _banner_visible, _initialized,
	]
