class_name Player
extends CharacterBody2D
## Jugador del overworld: movimiento en 4 direcciones (RF-01).
## Pulsa "interact" para hablar o interactuar con lo que tiene enfrente.

const INTERACT_DISTANCE := 14.0

@export var speed: float = 80.0

var facing := Vector2.DOWN
## La zona lo desactiva durante diálogos, combates y cápsulas.
var input_enabled: bool = true

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _probe: RayCast2D = $InteractionProbe
@onready var _camera: Camera2D = $Camera2D


func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	if input_enabled:
		# Prioriza un solo eje para movimiento estilo Pokémon (sin diagonales)
		if Input.is_action_pressed("move_up"):
			dir = Vector2.UP
		elif Input.is_action_pressed("move_down"):
			dir = Vector2.DOWN
		elif Input.is_action_pressed("move_left"):
			dir = Vector2.LEFT
		elif Input.is_action_pressed("move_right"):
			dir = Vector2.RIGHT

	if dir != Vector2.ZERO:
		facing = dir
	velocity = dir * speed
	move_and_slide()
	_probe.target_position = facing * INTERACT_DISTANCE
	_update_animation(dir != Vector2.ZERO)


func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled or not event.is_action_pressed("interact"):
		return
	_probe.force_raycast_update()
	var target := _probe.get_collider()
	if target != null and target.has_method("interact"):
		get_viewport().set_input_as_handled()
		target.interact()


## Limita la cámara al tamaño del mapa (en píxeles).
func set_camera_limits(bounds: Rect2i) -> void:
	_camera.limit_left = bounds.position.x
	_camera.limit_top = bounds.position.y
	_camera.limit_right = bounds.end.x
	_camera.limit_bottom = bounds.end.y
	_camera.reset_smoothing()


func _update_animation(moving: bool) -> void:
	var anim := ("walk_" if moving else "idle_") + _direction_name(facing)
	if _sprite.animation != anim:
		_sprite.play(anim)


static func _direction_name(dir: Vector2) -> String:
	if dir == Vector2.UP:
		return "up"
	if dir == Vector2.LEFT:
		return "left"
	if dir == Vector2.RIGHT:
		return "right"
	return "down"
