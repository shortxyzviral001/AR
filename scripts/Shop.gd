extends Node
## Autoload : monnaie persistante (Cristaux) et boutique de cosmetiques.
##
## Les objets vendus sont des "Ensembles" (coque + trainee + insigne).
## Plutot que d'ecrire 1000 entrees a la main, on definit 10 finitions de
## coque, 10 styles de trainee et 10 insignes (30 "briques" au total,
## chacune avec un nom, une couleur et un palier de rarete 1-10), puis on
## genere par combinaison les 10 x 10 x 10 = 1000 ensembles possibles, en
## calculant le nom et le prix de chacun a partir de ses trois briques.
## Le prix grimpe avec la somme des paliers : les premiers ensembles sont
## abordables des les premieres parties, les plus prestigieux demandent
## une progression sur la duree pour etre tous acquis.

const SAVE_PATH: String = "user://shop.cfg"

const HULL_FINISHES: Array[Dictionary] = [
	{"name": "Blanc Nacre", "color": Color("#e9edf3"), "tier": 1, "silhouette": "classique"},
	{"name": "Gris Titane", "color": Color("#9aa4b2"), "tier": 2, "silhouette": "classique"},
	{"name": "Bleu Comete", "color": Color("#4d9dff"), "tier": 3, "silhouette": "intercepteur"},
	{"name": "Vert Nebuleuse", "color": Color("#4dffa6"), "tier": 4, "silhouette": "intercepteur"},
	{"name": "Violet Pulsar", "color": Color("#9a5bff"), "tier": 5, "silhouette": "bombardier"},
	{"name": "Corail Solaire", "color": Color("#ff7a59"), "tier": 6, "silhouette": "bombardier"},
	{"name": "Cyan Quantique", "color": Color("#37e4e0"), "tier": 7, "silhouette": "furtif"},
	{"name": "Magenta Nova", "color": Color("#ff4dc4"), "tier": 8, "silhouette": "furtif"},
	{"name": "Or Stellaire", "color": Color("#ffcc4d"), "tier": 9, "silhouette": "legendaire"},
	{"name": "Prisme Cosmique", "color": Color("#ffffff"), "tier": 10, "silhouette": "legendaire"},
]

const SILHOUETTE_LABELS: Dictionary = {
	"classique": "Classique",
	"intercepteur": "Intercepteur",
	"bombardier": "Bombardier",
	"furtif": "Furtif",
	"legendaire": "Legendaire",
}

const TRAIL_STYLES: Array[Dictionary] = [
	{"name": "Poussiere", "color": Color("#8a92a0"), "tier": 1, "style": "dust"},
	{"name": "Etincelles", "color": Color("#ffe38a"), "tier": 2, "style": "sparkle"},
	{"name": "Ionisee", "color": Color("#6bc7ff"), "tier": 3, "style": "stream"},
	{"name": "Plasma Vert", "color": Color("#5bffb0"), "tier": 4, "style": "smoke"},
	{"name": "Plasma Violet", "color": Color("#b06bff"), "tier": 5, "style": "smoke"},
	{"name": "Braise", "color": Color("#ff8a4d"), "tier": 6, "style": "flame"},
	{"name": "Cristal", "color": Color("#7af0ff"), "tier": 7, "style": "ring"},
	{"name": "Spectre Rose", "color": Color("#ff6bb0"), "tier": 8, "style": "sparkle"},
	{"name": "Flamme Doree", "color": Color("#ffd24d"), "tier": 9, "style": "flame"},
	{"name": "Aurore Prismatique", "color": Color("#ffffff"), "tier": 10, "style": "ring"},
]

const BADGES: Array[Dictionary] = [
	{"name": "Comete", "color": Color("#cfd8e6"), "tier": 1, "icon": "comete"},
	{"name": "Meteore", "color": Color("#c9a27e"), "tier": 2, "icon": "meteore"},
	{"name": "Etoile Filante", "color": Color("#fff2b0"), "tier": 3, "icon": "etoile_filante"},
	{"name": "Nebuleuse", "color": Color("#c68cff"), "tier": 4, "icon": "nebuleuse"},
	{"name": "Satellite", "color": Color("#9fd8ff"), "tier": 5, "icon": "satellite"},
	{"name": "Pulsar", "color": Color("#8cffe0"), "tier": 6, "icon": "pulsar"},
	{"name": "Trou Noir", "color": Color("#9a8cd6"), "tier": 7, "icon": "trou_noir"},
	{"name": "Supernova", "color": Color("#ff9a4d"), "tier": 8, "icon": "supernova"},
	{"name": "Constellation", "color": Color("#ffe27a"), "tier": 9, "icon": "constellation"},
	{"name": "Couronne Galactique", "color": Color("#ffd24d"), "tier": 10, "icon": "couronne"},
]

const RARITY_BANDS: Array[Dictionary] = [
	{"max_tier_sum": 10, "label": "Commun", "color": Color("#b7c2d0")},
	{"max_tier_sum": 16, "label": "Rare", "color": Color("#6bc7ff")},
	{"max_tier_sum": 22, "label": "Epique", "color": Color("#c68cff")},
	{"max_tier_sum": 999, "label": "Legendaire", "color": Color("#ffcc4d")},
]

const DEFAULT_SET_ID: String = "set_0_0_0"
const PRICE_BASE: float = 18.0
const PRICE_EXPONENT: float = 1.55

const DAILY_BASE_REWARD: int = 25
const DAILY_STREAK_BONUS: int = 8
const DAILY_STREAK_CAP: int = 14

var currency: int = 0
var best_combo: int = 0
var last_played_date: String = ""
var streak_days: int = 0
var owned_sets: Dictionary = {}
var equipped_set: String = DEFAULT_SET_ID

# -- Lifetime stats (for achievements & settings) --
var games_played: int = 0
var total_crystals_earned: int = 0
var bosses_defeated: int = 0
var best_score: int = 0

var _catalog_cache: Array[Dictionary] = []


func _ready() -> void:
	owned_sets[DEFAULT_SET_ID] = true
	_build_catalog()
	_load()


func _build_catalog() -> void:
	_catalog_cache.clear()
	for h in range(HULL_FINISHES.size()):
		for t in range(TRAIL_STYLES.size()):
			for b in range(BADGES.size()):
				var tier_sum: int = int(HULL_FINISHES[h].tier) + int(TRAIL_STYLES[t].tier) + int(BADGES[b].tier)
				var silhouette: String = String(HULL_FINISHES[h].silhouette)
				_catalog_cache.append({
					"id": "set_%d_%d_%d" % [h, t, b],
					"name": "%s %s / %s / %s" % [
						SILHOUETTE_LABELS.get(silhouette, "Vaisseau"), HULL_FINISHES[h].name,
						TRAIL_STYLES[t].name, BADGES[b].name,
					],
					"hull": h,
					"trail": t,
					"badge": b,
					"tier_sum": tier_sum,
					"price": _price_for_tier_sum(tier_sum),
					"rarity": _rarity_for_tier_sum(tier_sum),
				})


func _price_for_tier_sum(tier_sum: int) -> int:
	return int(round(PRICE_BASE * pow(float(tier_sum), PRICE_EXPONENT)))


func _rarity_for_tier_sum(tier_sum: int) -> Dictionary:
	for band in RARITY_BANDS:
		if tier_sum <= int(band.max_tier_sum):
			return band
	return RARITY_BANDS[RARITY_BANDS.size() - 1]


func catalog() -> Array[Dictionary]:
	return _catalog_cache


func item_by_id(id: String) -> Dictionary:
	for item in _catalog_cache:
		if String(item.id) == id:
			return item
	return {}


func hull_info(index: int) -> Dictionary:
	return HULL_FINISHES[index]


func trail_info(index: int) -> Dictionary:
	return TRAIL_STYLES[index]


func badge_info(index: int) -> Dictionary:
	return BADGES[index]


func badge_icon(index: int) -> String:
	return String(BADGES[index].get("icon", "comete"))


func hull_silhouette(index: int) -> String:
	return String(HULL_FINISHES[index].silhouette)


func equipped_hull_color() -> Color:
	return hull_color_for(equipped_set)


func equipped_hull_silhouette() -> String:
	var item: Dictionary = item_by_id(equipped_set)
	if item.is_empty():
		return "classique"
	return hull_silhouette(int(item.hull))


func hull_color_for(id: String) -> Color:
	var item: Dictionary = item_by_id(id)
	if item.is_empty():
		return Color.WHITE
	return HULL_FINISHES[int(item.hull)].color


func equipped_trail_color() -> Color:
	var item: Dictionary = item_by_id(equipped_set)
	if item.is_empty():
		return Color(0.6, 0.75, 1.0)
	return TRAIL_STYLES[int(item.trail)].color


func equipped_trail_style() -> String:
	var item: Dictionary = item_by_id(equipped_set)
	if item.is_empty():
		return "sparkle"
	return String(TRAIL_STYLES[int(item.trail)].get("style", "sparkle"))


func equipped_badge_color() -> Color:
	var item: Dictionary = item_by_id(equipped_set)
	if item.is_empty():
		return Color.WHITE
	return BADGES[int(item.badge)].color


func is_owned(id: String) -> bool:
	return bool(owned_sets.get(id, false))


func can_afford(id: String) -> bool:
	var item: Dictionary = item_by_id(id)
	if item.is_empty():
		return false
	return currency >= int(item.price)


func purchase(id: String) -> bool:
	if is_owned(id) or not can_afford(id):
		return false
	var item: Dictionary = item_by_id(id)
	currency -= int(item.price)
	owned_sets[id] = true
	save()
	return true


func equip(id: String) -> bool:
	if not is_owned(id):
		return false
	equipped_set = id
	save()
	return true


func add_currency(amount: int) -> void:
	if amount > 0:
		currency += amount


func register_combo(value: int) -> void:
	if value > best_combo:
		best_combo = value


func record_run(score: int, crystals: int, boss_kills: int) -> void:
	games_played += 1
	total_crystals_earned += crystals
	bosses_defeated += boss_kills
	if score > best_score:
		best_score = score
	save()


func owned_count() -> int:
	return owned_sets.size()


func total_count() -> int:
	return _catalog_cache.size()


func _load() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	currency = int(config.get_value("shop", "currency", currency))
	best_combo = int(config.get_value("shop", "best_combo", best_combo))
	equipped_set = String(config.get_value("shop", "equipped_set", equipped_set))
	last_played_date = String(config.get_value("shop", "last_played_date", last_played_date))
	streak_days = int(config.get_value("shop", "streak_days", streak_days))
	var owned_list: Array = config.get_value("shop", "owned_sets", [])
	for id in owned_list:
		owned_sets[String(id)] = true
	owned_sets[DEFAULT_SET_ID] = true
	if not owned_sets.has(equipped_set):
		equipped_set = DEFAULT_SET_ID
	games_played = int(config.get_value("shop", "games_played", 0))
	total_crystals_earned = int(config.get_value("shop", "total_crystals_earned", 0))
	bosses_defeated = int(config.get_value("shop", "bosses_defeated", 0))
	best_score = int(config.get_value("shop", "best_score", 0))


func save() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("shop", "currency", currency)
	config.set_value("shop", "best_combo", best_combo)
	config.set_value("shop", "equipped_set", equipped_set)
	config.set_value("shop", "owned_sets", owned_sets.keys())
	config.set_value("shop", "last_played_date", last_played_date)
	config.set_value("shop", "streak_days", streak_days)
	config.set_value("shop", "games_played", games_played)
	config.set_value("shop", "total_crystals_earned", total_crystals_earned)
	config.set_value("shop", "bosses_defeated", bosses_defeated)
	config.set_value("shop", "best_score", best_score)
	config.save(SAVE_PATH)


## Recompense de connexion quotidienne. A appeler une fois au demarrage de
## l'app. Renvoie le montant accorde (0 si deja recupere aujourd'hui).
func claim_daily_reward() -> int:
	var today: String = Time.get_date_string_from_system()
	if last_played_date == today:
		return 0

	var yesterday: String = Time.get_date_string_from_unix_time(int(Time.get_unix_time_from_system()) - 86400)
	if last_played_date == yesterday:
		streak_days += 1
	else:
		streak_days = 1
	streak_days = mini(streak_days, DAILY_STREAK_CAP)
	last_played_date = today

	var reward: int = DAILY_BASE_REWARD + (streak_days - 1) * DAILY_STREAK_BONUS
	add_currency(reward)
	save()
	return reward
