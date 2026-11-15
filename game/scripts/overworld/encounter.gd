class_name Encounter
extends StaticBody2D
## Criatura de basura mutada en el mapa. Al interactuar pide un combate (RF-03).

signal triggered(encounter: Encounter)

@export var creature: CreatureData

var _idle_tween: Tween

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if creature != null:
		_sprite.texture = creature.front_sprite
	_idle_tween = create_tween().set_loops()
	_idle_tween.tween_property(_sprite, "position:y", -2.0, 0.6).set_trans(Tween.TRANS_SINE)
	_idle_tween.tween_property(_sprite, "position:y", 0.0, 0.6).set_trans(Tween.TRANS_SINE)


func interact() -> void:
	triggered.emit(self)


## Animación de purificación tras ganar el combate.
func purify() -> void:
	_shape.set_deferred("disabled", true)
	if _idle_tween != null:
		_idle_tween.kill()
	var tw := create_tween()
	tw.tween_property(_sprite, "modulate", Color(3, 3, 3, 1), 0.2)
	tw.tween_property(_sprite, "modulate", Color(1, 1, 1, 0), 0.5)
	await tw.finished
	queue_free()
