extends Node
## Autoload : vérifie la version la plus récente sur multidevsn.github.io
## et signale une mise à jour disponible au joueur.

const VERSION_URL: String = "https://multidevsn.github.io/astrorecolte/version.json"
const CHECK_INTERVAL: float = 86400.0  # Re-check every 24 hours

var latest_version: String = ""
var latest_code: int = 0
var changelog: String = ""
var download_url: String = ""
var update_available: bool = false
var check_done: bool = false
var _http: HTTPRequest
var _last_check: float = 0.0


func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 10
	_http.request_completed.connect(_on_request_completed)
	add_child(_http)


func check_for_update() -> void:
	if _http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return  # Already checking
	var err: int = _http.request(VERSION_URL)
	if err != OK:
		push_warning("UpdateChecker: HTTP request failed (err %d)" % err)


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	check_done = true
	_last_check = Time.get_ticks_msec() / 1000.0
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		return
	var json_text: String = body.get_string_from_utf8()
	var json: JSON = JSON.new()
	if json.parse(json_text) != OK:
		push_warning("UpdateChecker: Invalid JSON")
		return
	var data: Dictionary = json.data
	if not data is Dictionary:
		return
	latest_version = str(data.get("latest_version", ""))
	latest_code = int(data.get("latest_code", 0))
	download_url = str(data.get("download_url", ""))
	var current_code: int = _get_current_code()
	update_available = latest_code > current_code
	# Pick changelog for current language
	var lang: String = Settings.language if Settings.language != "" else "fr"
	var cl: Dictionary = data.get("changelog", {})
	if cl is Dictionary:
		changelog = str(cl.get(lang, cl.get("fr", "")))


func should_check() -> bool:
	return (Time.get_ticks_msec() / 1000.0) - _last_check > CHECK_INTERVAL


func _get_current_code() -> int:
	# Lu depuis application/config/version_code (Project Settings), qui doit
	# rester synchronise avec version/code dans export_presets.cfg a chaque
	# release (voir project.godot). Avant ce correctif, ce ProjectSetting
	# n'existait pas : la lecture echouait systematiquement et retombait sur
	# une valeur "9" codee en dur, bien inferieure aux versions publiees
	# recentes -> le jeu annoncait une mise a jour disponible en permanence,
	# meme pour les joueurs deja a jour.
	return ProjectSettings.get_setting("application/config/version_code", 1)
