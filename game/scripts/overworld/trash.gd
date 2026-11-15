class_name Trash
extends Sprite2D
## Basura decorativa del mapa. Desaparece al purificar la zona (RF-04).

enum Kind { BOTELLA, FUNDA, LATA }

const SIZE := 16

@export var kind: Kind = Kind.BOTELLA


func _ready() -> void:
	region_enabled = true
	region_rect = Rect2(kind * SIZE, 0, SIZE, SIZE)


func clean(duration: float = 0.8) -> void:
	var tw := create_tween().set_parallel()
	tw.tween_property(self, "modulate:a", 0.0, duration)
	tw.tween_property(self, "scale", Vector2(0.4, 0.4), duration)
	await tw.finished
	queue_free()
