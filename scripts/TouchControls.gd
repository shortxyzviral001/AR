extends CanvasLayer
## Controles tactiles pour mobile : un unique stick analogique en bas a
## gauche qui pilote le deplacement dans les 4 directions (haut/bas/
## gauche/droite, et toutes les diagonales). Le tir du vaisseau est
## automatique, donc aucun bouton supplementaire n'est necessaire : le
## stick est libre d'aller dans n'importe quelle direction du cercle.

const JOYSTICK_RADIUS: float = 100.0
const JOYSTICK_MAX_KNOB: float = 68.0
const EDGE_MARGIN: float = 34.0
## Zone morte proportionnelle (0..1) pour eviter les micro-derives au repos.
const DEAD_ZONE: float = 0.06

## Direction courante (-1..1 sur chaque axe) lue par Main.gd chaque frame.
var direction: Vector2 = Vector2.ZERO

var _joystick_base_pos: Vector2 = Vector2.ZERO

var _joystick_touch_index: int = -1
var _joystick_offset: Vector2 = Vector2.ZERO

var _base_visual: Panel
var _knob: Panel


func _ready() -> void:
	layer = 5
	_build_visuals()
	_recompute_layout()
	get_viewport().size_changed.connect(_recompute_layout)


func _build_visuals() -> void:
	_base_visual = _make_circle(JOYSTICK_RADIUS * 2.0, Color(1.0, 1.0, 1.0, 0.10))
	_knob = _make_circle(JOYSTICK_MAX_KNOB * 1.1, Color(1.0, 1.0, 1.0, 0.30))

	add_child(_base_visual)
	add_child(_knob)


func _make_circle(diameter: float, fill_color: Color) -> Panel:
	var panel: Panel = Panel.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.custom_minimum_size = Vector2(diameter, diameter)
	panel.size = Vector2(diameter, diameter)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = fill_color
	var radius: int = int(diameter * 0.5)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _recompute_layout() -> void:
	var size: Vector2 = get_viewport().get_visible_rect().size
	_joystick_base_pos = Vector2(EDGE_MARGIN + JOYSTICK_RADIUS, size.y - EDGE_MARGIN - JOYSTICK_RADIUS)
	_base_visual.position = _joystick_base_pos - Vector2(JOYSTICK_RADIUS, JOYSTICK_RADIUS)
	_update_knob_visual()


func _update_knob_visual() -> void:
	var half: float = _knob.size.x * 0.5
	_knob.position = _joystick_base_pos + _joystick_offset - Vector2(half, half)


func _input(event: InputEvent) -> void:
	if not visible:
		return

	# MOBILE FIX: only capture touches in the bottom 70% of the screen
	# to avoid stealing touches from Pause/Settings buttons in the top HUD.
	if event is InputEventScreenTouch:
		var screen_h: float = get_viewport().get_visible_rect().size.y
		if event.position.y < screen_h * 0.30:
			return
		if event.pressed:
			_on_touch_began(event.index, event.position)
		else:
			_on_touch_ended(event.index)
	elif event is InputEventScreenDrag:
		_on_touch_dragged(event.index, event.position)


func _on_touch_began(index: int, pos: Vector2) -> void:
	if _joystick_touch_index == -1 and pos.distance_to(_joystick_base_pos) <= JOYSTICK_RADIUS * 1.4:
		_joystick_touch_index = index
		_update_joystick(pos)


func _on_touch_dragged(index: int, pos: Vector2) -> void:
	if index == _joystick_touch_index:
		_update_joystick(pos)


func _on_touch_ended(index: int) -> void:
	if index == _joystick_touch_index:
		_joystick_touch_index = -1
		_joystick_offset = Vector2.ZERO
		_update_knob_visual()


func _update_joystick(pos: Vector2) -> void:
	var offset: Vector2 = pos - _joystick_base_pos
	if offset.length() > JOYSTICK_MAX_KNOB:
		offset = offset.normalized() * JOYSTICK_MAX_KNOB
	_joystick_offset = offset
	_update_knob_visual()


func reset() -> void:
	_joystick_touch_index = -1
	_joystick_offset = Vector2.ZERO
	_update_knob_visual()


func _process(_delta: float) -> void:
	if JOYSTICK_MAX_KNOB <= 0.0:
		direction = Vector2.ZERO
		return
	var raw: Vector2 = _joystick_offset / JOYSTICK_MAX_KNOB
	var length: float = raw.length()
	if length < DEAD_ZONE:
		direction = Vector2.ZERO
		return
	# Remappe la zone [DEAD_ZONE..1] vers [0..1] pour une reponse fluide
	# des la sortie de la zone morte, sans a-coup.
	var rescaled: float = clampf((length - DEAD_ZONE) / (1.0 - DEAD_ZONE), 0.0, 1.0)
	direction = raw.normalized() * rescaled
