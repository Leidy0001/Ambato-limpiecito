extends CharacterBody2D
## Jugador del overworld: movimiento en 4 direcciones (RF-01).

@export var speed: float = 80.0

var facing := Vector2.DOWN


func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
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
	# TODO: AnimatedSprite2D con animaciones walk_up/down/left/right e idle
