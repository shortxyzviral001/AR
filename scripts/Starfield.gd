extends Node2D
## Fond etoile defilant. Le fond et la teinte des etoiles peuvent
## transitionner en douceur d'un secteur a l'autre via set_zone(), pour
## marquer visuellement les "changements de plan".

@export var star_count: int = 110

const TRANSITION_SPEED: float = 1.2

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _stars: Array[Dictionary] = []

var _bg_color: Color = Color("#07101f")
var _bg_target: Color = Color("#07101f")
var _star_tint: Color = Color(1.0, 1.0, 1.0)
var _star_tint_target: Color = Color(1.0, 1.0, 1.0)

## AI-generated nebula texture drawn beneath the stars (set per zone).
const NEBULA_ALPHA: float = 0.30
var _bg_texture: Texture2D
var _bg_texture_alpha: float = 0.0
var _elapsed: float = 0.0


func _ready() -> void:
	_rng.randomize()
	_rebuild()
	get_viewport().size_changed.connect(_rebuild)


func _process(delta: float) -> void:
	var size: Vector2 = get_viewport_rect().size
	_elapsed += delta
	for star in _stars:
		var position: Vector2 = star["position"]
		position.y += float(star["speed"]) * delta
		if position.y > size.y + 6.0:
			position.y = -6.0
			position.x = _rng.randf_range(0.0, size.x)
		star["position"] = position

	var lerp_amount: float = clampf(TRANSITION_SPEED * delta, 0.0, 1.0)
	_bg_color = _bg_color.lerp(_bg_target, lerp_amount)
	_star_tint = _star_tint.lerp(_star_tint_target, lerp_amount)
	_bg_texture_alpha = move_toward(_bg_texture_alpha, 1.0, TRANSITION_SPEED * delta)
	queue_redraw()


func _draw() -> void:
	var size: Vector2 = get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), _bg_color)
	if _bg_texture != null and _bg_texture_alpha > 0.0:
		# Slow parallax drift so the nebula breathes (artwork unchanged)
		var drift: Vector2 = Vector2(sin(_elapsed * 0.05) * 26.0, cos(_elapsed * 0.035) * 18.0)
		var draw_rect: Rect2 = Rect2(-40.0 + drift.x, -40.0 + drift.y, size.x + 80.0, size.y + 80.0)
		draw_texture_rect(_bg_texture, draw_rect, false, Color(1.0, 1.0, 1.0, NEBULA_ALPHA * _bg_texture_alpha))
	for star in _stars:
		var base_color: Color = star["color"]
		draw_circle(star["position"], star["radius"], base_color * _star_tint)


func _rebuild() -> void:
	var size: Vector2 = get_viewport_rect().size
	_stars.clear()
	for i in range(star_count):
		_stars.append({
			"position": Vector2(_rng.randf_range(0.0, size.x), _rng.randf_range(0.0, size.y)),
			"radius": _rng.randf_range(1.0, 2.7),
			"speed": _rng.randf_range(10.0, 46.0),
			"color": Color(0.55 + _rng.randf() * 0.35, 0.75 + _rng.randf() * 0.2, 1.0, 0.45 + _rng.randf() * 0.45)
		})
	queue_redraw()


## Appelee par Main.gd a chaque changement de secteur : fait fondre le fond
## et la teinte des etoiles vers les nouvelles couleurs en douceur au lieu
## d'un changement brutal. Un fond nebuleux (genere par IA) peut etre fourni.
func set_zone(bg: Color, star_tint: Color, bg_texture: Texture2D = null) -> void:
	_bg_target = bg
	_star_tint_target = star_tint
	if bg_texture != null and bg_texture != _bg_texture:
		_bg_texture = bg_texture
		_bg_texture_alpha = 0.0
