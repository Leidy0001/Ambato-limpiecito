extends Node
## Gestor global de misiones turísticas (RF-02).

enum State { PENDIENTE, EN_CURSO, COMPLETADA }

signal mission_state_changed(mission_id: String, new_state: State)
signal zone_purified(zone_id: int)

var _missions: Dictionary = {}  # id -> { "data": MissionData, "state": State }


func register(mission: MissionData) -> void:
	if not _missions.has(mission.id):
		_missions[mission.id] = {"data": mission, "state": State.PENDIENTE}


func start(mission_id: String) -> void:
	_set_state(mission_id, State.EN_CURSO)


func complete(mission_id: String) -> void:
	_set_state(mission_id, State.COMPLETADA)
	var mission: MissionData = _missions[mission_id].data
	if mission.is_main_mission:
		GameState.purify_zone(mission.zone_id)
		zone_purified.emit(mission.zone_id)


func get_state(mission_id: String) -> State:
	return _missions.get(mission_id, {"state": State.PENDIENTE}).state


func _set_state(mission_id: String, state: State) -> void:
	if not _missions.has(mission_id):
		push_warning("Misión no registrada: %s" % mission_id)
		return
	_missions[mission_id].state = state
	mission_state_changed.emit(mission_id, state)
