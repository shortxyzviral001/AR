extends Node
## Autoload (singleton) : gere le pseudo unique du joueur et communique en
## REST avec une base Firebase Firestore publique pour stocker/lire un
## classement global. Aucun serveur a coder ou faire tourner soi-meme :
## Firestore est entierement gere par Google, seule la configuration
## (project ID + regles de securite) est a faire une fois, voir le README.
##
## FIREBASE_PROJECT_ID pointe deja vers le projet Firebase de production
## (voir section "Classement en ligne" du README pour la configuration
## complete : regles Firestore, etc.). Si tu forkes ce projet, change cette
## valeur pour pointer vers TON propre projet Firebase.

const FIREBASE_PROJECT_ID: String = "multidevsngl"
const COLLECTION: String = "scores"
const PSEUDO_SAVE_PATH: String = "user://pseudo.save"
const FETCH_POOL_SIZE: int = 50
const DISPLAY_TOP_COUNT: int = 20
const MAX_RETRIES: int = 2
const REQUEST_TIMEOUT: float = 12.0

## Emis apres check_pseudo_available(). status : "available" | "taken" | "error"
signal pseudo_check_result(candidate: String, status: String)
## Emis apres submit_score(). status : "ok_new" | "ok_updated" | "not_beaten" | "error" | "retrying"
signal score_submit_result(status: String, score: int)
## Emis apres fetch_top(). entries : Array de Dictionary {pseudo, score, elapsed, ratio}
## status: "ok" | "offline" | "error"
signal leaderboard_ready(entries: Array)

var pseudo: String = ""
var online_mode: bool = true

var _http_check: HTTPRequest
var _http_submit: HTTPRequest
var _http_fetch: HTTPRequest

var _pending_pseudo: String = ""
var _pending_score: int = 0
var _pending_elapsed: float = 0.0
var _submit_stage: String = ""
var _submit_retries: int = 0
var _fetch_retries: int = 0


## Journalise uniquement dans les builds de debug (export --debug / editeur) :
## evite de polluer les logs des joueurs en production.
static func _log(message: String) -> void:
	if OS.is_debug_build():
		print(message)


func _ready() -> void:
	_http_check = HTTPRequest.new()
	_http_check.timeout = REQUEST_TIMEOUT
	add_child(_http_check)
	_http_check.request_completed.connect(_on_check_completed)

	_http_submit = HTTPRequest.new()
	_http_submit.timeout = REQUEST_TIMEOUT
	add_child(_http_submit)
	_http_submit.request_completed.connect(_on_submit_completed)

	_http_fetch = HTTPRequest.new()
	_http_fetch.timeout = REQUEST_TIMEOUT
	add_child(_http_fetch)
	_http_fetch.request_completed.connect(_on_fetch_completed)

	_load_local_pseudo()


func has_pseudo() -> bool:
	return pseudo != ""


func choose_pseudo(new_pseudo: String) -> void:
	pseudo = new_pseudo
	_save_local_pseudo()


func check_pseudo_available(candidate: String) -> void:
	_pending_pseudo = candidate
	var url: String = "%s/%s/%s" % [_base_url(), COLLECTION, candidate.uri_encode()]
	_http_check.request(url)


func submit_score(score: int, elapsed: float) -> void:
	if pseudo == "":
		score_submit_result.emit("error", score)
		return
	_pending_score = score
	_pending_elapsed = maxf(elapsed, 0.01)
	_submit_stage = "create"
	_submit_retries = 0
	_send_write(false)


func fetch_top() -> void:
	_fetch_retries = 0
	_do_fetch_top()


func _do_fetch_top() -> void:
	var query: Dictionary = {
		"structuredQuery": {
			"from": [{"collectionId": COLLECTION}],
			"orderBy": [{"field": {"fieldPath": "ratio"}, "direction": "DESCENDING"}],
			"limit": FETCH_POOL_SIZE,
		}
	}
	var url: String = "%s:runQuery" % _base_url()
	var headers: PackedStringArray = PackedStringArray(["Content-Type: application/json"])
	_http_fetch.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(query))


# ---------------------------------------------------------------------------
# Firestore : construction des requetes REST
# ---------------------------------------------------------------------------

func _base_url() -> String:
	return "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents" % FIREBASE_PROJECT_ID


func _doc_resource_name(a_pseudo: String) -> String:
	# Nom de ressource complet attendu dans le corps JSON (pas d'URL-encodage
	# ici : ce n'est pas une URL, juste une donnee interpretee par Firestore).
	return "projects/%s/databases/(default)/documents/%s/%s" % [FIREBASE_PROJECT_ID, COLLECTION, a_pseudo]


func _send_write(exists_precondition: bool) -> void:
	var ratio: float = float(_pending_score) / _pending_elapsed
	var body: Dictionary = {
		"writes": [
			{
				"update": {
					"name": _doc_resource_name(pseudo),
					"fields": {
						"pseudo": {"stringValue": pseudo},
						"score": {"integerValue": str(_pending_score)},
						"elapsed": {"doubleValue": _pending_elapsed},
						"ratio": {"doubleValue": ratio},
					},
				},
				"currentDocument": {"exists": exists_precondition},
			}
		]
	}
	var url: String = "%s:commit" % _base_url()
	var headers: PackedStringArray = PackedStringArray(["Content-Type: application/json"])
	_http_submit.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))


# ---------------------------------------------------------------------------
# Reponses HTTP
# ---------------------------------------------------------------------------

func _on_check_completed(result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	_log("[Leaderboard] check_pseudo -> result=%d response_code=%d" % [result, response_code])
	if result != HTTPRequest.RESULT_SUCCESS:
		pseudo_check_result.emit(_pending_pseudo, "error")
		return
	if response_code == 404:
		pseudo_check_result.emit(_pending_pseudo, "available")
	elif response_code == 200:
		pseudo_check_result.emit(_pending_pseudo, "taken")
	else:
		pseudo_check_result.emit(_pending_pseudo, "error")


func _on_submit_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var body_text: String = body.get_string_from_utf8()
	_log("[Leaderboard] submit (%s) -> result=%d code=%d" % [_submit_stage, result, response_code])

	# Retry on transient errors (network timeout, server 5xx)
	if result != HTTPRequest.RESULT_SUCCESS and _submit_retries < MAX_RETRIES:
		_submit_retries += 1
		score_submit_result.emit("retrying", _pending_score)
		_log("[Leaderboard] submit retry %d/%d" % [_submit_retries, MAX_RETRIES])
		await get_tree().create_timer(1.0 * _submit_retries).timeout
		_send_write(_submit_stage == "update")
		return

	if result != HTTPRequest.RESULT_SUCCESS:
		score_submit_result.emit("error", _pending_score)
		return

	if response_code == 200:
		var status: String = "ok_new" if _submit_stage == "create" else "ok_updated"
		score_submit_result.emit(status, _pending_score)
		return

	if _submit_stage == "create":
		_submit_stage = "update"
		_send_write(true)
		return

	if body_text.find("PERMISSION_DENIED") != -1:
		score_submit_result.emit("not_beaten", _pending_score)
	else:
		score_submit_result.emit("error", _pending_score)


func _on_fetch_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	_log("[Leaderboard] fetch_top -> result=%d response_code=%d" % [result, response_code])

	# Retry on transient errors
	if (result != HTTPRequest.RESULT_SUCCESS or response_code >= 500) and _fetch_retries < MAX_RETRIES:
		_fetch_retries += 1
		_log("[Leaderboard] fetch retry %d/%d" % [_fetch_retries, MAX_RETRIES])
		await get_tree().create_timer(1.0 * _fetch_retries).timeout
		_do_fetch_top()
		return

	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		leaderboard_ready.emit([])
		return

	var parsed: Variant = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_ARRAY:
		leaderboard_ready.emit([])
		return

	var entries: Array = []
	for row in parsed:
		if typeof(row) != TYPE_DICTIONARY or not row.has("document"):
			continue
		var fields: Dictionary = row["document"].get("fields", {})
		entries.append({
			"pseudo": fields.get("pseudo", {}).get("stringValue", "?"),
			"score": int(fields.get("score", {}).get("integerValue", "0")),
			"elapsed": float(fields.get("elapsed", {}).get("doubleValue", 0.0)),
			"ratio": float(fields.get("ratio", {}).get("doubleValue", 0.0)),
		})

	entries.sort_custom(_compare_entries)

	leaderboard_ready.emit(entries.slice(0, DISPLAY_TOP_COUNT))


func _compare_entries(a: Dictionary, b: Dictionary) -> bool:
	if a["ratio"] != b["ratio"]:
		return a["ratio"] > b["ratio"]
	return a["elapsed"] > b["elapsed"]


# ---------------------------------------------------------------------------
# Pseudo local
# ---------------------------------------------------------------------------

func _load_local_pseudo() -> void:
	if not FileAccess.file_exists(PSEUDO_SAVE_PATH):
		return
	var file: FileAccess = FileAccess.open(PSEUDO_SAVE_PATH, FileAccess.READ)
	if file:
		pseudo = file.get_line()
		file.close()


func _save_local_pseudo() -> void:
	var file: FileAccess = FileAccess.open(PSEUDO_SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_line(pseudo)
		file.close()
