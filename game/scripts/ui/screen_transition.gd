class_name ScreenTransition
extends CanvasLayer
## Transiciones a pantalla completa: destellos de encuentro (RF-03) y fundidos.

const FLASH := Color(1, 1, 1, 0.9)
const CLEAR := Color(0, 0, 0, 0)
const BLACK := Color(0, 0, 0, 1)

@onready var _rect: ColorRect = $Rect


func _ready() -> void:
	_rect.color = CLEAR


## Tres destellos blancos y fundido a negro, como al encontrar una criatura.
func play_battle_intro() -> void:
	var tw := create_tween()
	for i in 3:
		tw.tween_property(_rect, "color", FLASH, 0.07)
		tw.tween_property(_rect, "color", Color(1, 1, 1, 0), 0.07)
	tw.tween_property(_rect, "color", BLACK, 0.35)
	await tw.finished


func fade_out(duration: float = 0.3) -> void:
	var tw := create_tween()
	tw.tween_property(_rect, "color", BLACK, duration)
	await tw.finished


func fade_in(duration: float = 0.3) -> void:
	var tw := create_tween()
	tw.tween_property(_rect, "color", CLEAR, duration)
	await tw.finished
