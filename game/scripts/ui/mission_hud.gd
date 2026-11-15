class_name MissionHud
extends PanelContainer
## Muestra la misión principal de la zona y su estado (RF-02).

var _mission: MissionData

@onready var _label: Label = %Label


func _ready() -> void:
	hide()
	MissionManager.mission_state_changed.connect(_on_mission_state_changed)


func track(mission: MissionData) -> void:
	_mission = mission
	_refresh()


func _on_mission_state_changed(mission_id: String, _new_state: int) -> void:
	if _mission != null and mission_id == _mission.id:
		_refresh()


func _refresh() -> void:
	if _mission == null:
		hide()
		return
	var state: int = MissionManager.get_state(_mission.id)
	_label.text = "Misión: %s · %s" % [_mission.title, _state_text(state)]
	show()


static func _state_text(state: int) -> String:
	match state:
		MissionManager.State.EN_CURSO:
			return "En curso"
		MissionManager.State.COMPLETADA:
			return "Completada"
		_:
			return "Pendiente"
