class_name Npc
extends StaticBody2D
## Personaje con el que se conversa. Puede entregar una misión (RF-02).
## Las líneas dependen del estado de la misión; la zona decide qué hacer con ellas.

signal talked(npc: Npc)

@export var npc_id: String = ""
@export var display_name: String = ""
@export var mission: MissionData
@export_multiline var lines_pending: Array[String] = []
@export_multiline var lines_in_progress: Array[String] = []
@export_multiline var lines_completed: Array[String] = []

@onready var _alert: Label = $Alert


func interact() -> void:
	talked.emit(self)


func get_lines(mission_state: int) -> Array[String]:
	match mission_state:
		MissionManager.State.EN_CURSO:
			return lines_in_progress
		MissionManager.State.COMPLETADA:
			return lines_completed
		_:
			return lines_pending


## Muestra el "!" sobre la cabeza cuando tiene una misión por entregar.
func set_alert(active: bool) -> void:
	_alert.visible = active
