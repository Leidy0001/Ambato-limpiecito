extends Node2D
## Escena raíz. Más adelante cargará el menú principal o la zona actual.

func _ready() -> void:
	print("Ambato Limpiecito iniciado. Zona actual: ", GameState.current_zone)
