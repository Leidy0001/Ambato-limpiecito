class_name CreatureHud
extends PanelContainer
## Nombre y barra de vida de un combatiente (RF-03).

const COLOR_OK := Color("4caf50")
const COLOR_WARN := Color("f4c430")
const COLOR_DANGER := Color("e63946")

var _max_hp := 1
var _fill := StyleBoxFlat.new()

@onready var _name: Label = %NameLabel
@onready var _hp_label: Label = %HpLabel
@onready var _bar: ProgressBar = %HpBar


func _ready() -> void:
	_bar.add_theme_stylebox_override("fill", _fill)
	_bar.value_changed.connect(_on_value_changed)


func setup(display_name: String, max_hp: int, hp: int) -> void:
	_name.text = display_name
	_max_hp = maxi(max_hp, 1)
	_bar.max_value = _max_hp
	_bar.value = hp
	_on_value_changed(hp)


func animate_hp(hp: int, duration: float = 0.5) -> void:
	var tw := create_tween()
	tw.tween_property(_bar, "value", float(hp), duration)
	await tw.finished


func _on_value_changed(value: float) -> void:
	_hp_label.text = "%d/%d" % [roundi(value), _max_hp]
	var ratio := value / _max_hp
	_fill.bg_color = COLOR_OK if ratio > 0.5 else (COLOR_WARN if ratio > 0.2 else COLOR_DANGER)
