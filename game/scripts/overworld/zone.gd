class_name Zone
extends Node2D
## Lógica común de una zona del overworld. Cada zona es una escena propia
## (p. ej. zona1/zona1_quinta_juan_leon_mera.tscn) que usa este script.
##
## Flujo: NPC entrega la misión → el jugador vence a la criatura objetivo →
## MissionManager.complete() → purificación visual → cápsula histórica (RF-02..05).

## Main escucha esta señal para abrir la escena de combate.
signal battle_requested(enemy: CreatureData)
signal purification_finished

@export var zone_id: int = 1
@export var zone_name: String = ""
@export var main_mission: MissionData
@export var capsule: HistoricCapsule

var _pending_encounter: Encounter
var _purifying := false
var _unlocked_zone := 0

@onready var _map: PlaceholderMap = $Ground
@onready var _entities: Node2D = $Entities
@onready var _trash: Node2D = $Trash
@onready var _player: Player = $Entities/Player
@onready var _filter: PurificationFilter = $PurificationFilter
@onready var _dialog: DialogBox = $UI/DialogBox
@onready var _capsule_modal: CapsuleModal = $UI/CapsuleModal
@onready var _mission_hud: MissionHud = $UI/MissionHud


func _ready() -> void:
	if main_mission != null:
		MissionManager.register(main_mission)
	MissionManager.mission_state_changed.connect(_on_mission_state_changed)
	MissionManager.zone_purified.connect(_on_zone_purified)
	GameState.zone_unlocked.connect(_on_zone_unlocked)

	for child in _entities.get_children():
		if child is Npc:
			(child as Npc).talked.connect(_on_npc_talked)
		elif child is Encounter:
			var encounter := child as Encounter
			if encounter.creature != null and encounter.creature.id in GameState.purified_creatures:
				encounter.queue_free()
			else:
				encounter.triggered.connect(_on_encounter_triggered)

	_player.set_camera_limits(_map.get_pixel_bounds())
	_mission_hud.track(main_mission)
	_update_npc_alerts()

	var purified := GameState.is_zone_purified(zone_id)
	_filter.set_purified(purified)
	if purified:
		for trash in _trash.get_children():
			trash.queue_free()


## Main la llama al volver del combate.
func on_battle_finished(won: bool) -> void:
	var encounter := _pending_encounter
	_pending_encounter = null
	if not won:
		await _say(["Te quedaste sin energía y te retiras a descansar.", "¡Inténtalo de nuevo cuando quieras!"])
		_player.input_enabled = true
		return

	if encounter != null:
		var creature := encounter.creature  # purify() libera el nodo
		await encounter.purify()
		if _is_mission_target(creature):
			MissionManager.complete(main_mission.id)
			if _purifying:
				await purification_finished
	_player.input_enabled = true


func _on_npc_talked(npc: Npc) -> void:
	var mission := npc.mission
	var state: int = MissionManager.State.PENDIENTE
	if mission != null:
		state = MissionManager.get_state(mission.id)
	await _say(npc.get_lines(state), npc.display_name)
	if mission != null and state == MissionManager.State.PENDIENTE:
		MissionManager.start(mission.id)


func _on_encounter_triggered(encounter: Encounter) -> void:
	if main_mission != null and MissionManager.get_state(main_mission.id) != MissionManager.State.EN_CURSO:
		await _say(["¡Una criatura de basura mutada bloquea el paso!", "Mejor habla primero con la guía."])
		return
	_player.input_enabled = false
	_pending_encounter = encounter
	battle_requested.emit(encounter.creature)


func _on_zone_purified(purified_zone_id: int) -> void:
	if purified_zone_id != zone_id:
		return
	_purifying = true
	await _play_purification()
	_purifying = false
	purification_finished.emit()


func _play_purification() -> void:
	await _say(["¡La zona se está purificando!"])
	for trash in _trash.get_children():
		if trash is Trash:
			(trash as Trash).clean(1.2)
	await _filter.purify(2.0)
	if capsule != null:
		await _capsule_modal.show_capsule(capsule)
		if capsule.id not in GameState.seen_capsules:
			GameState.seen_capsules.append(capsule.id)
	if _unlocked_zone > 0:
		await _say(["¡Desbloqueaste la Zona %d!" % _unlocked_zone])
		_unlocked_zone = 0


func _on_zone_unlocked(unlocked_zone_id: int) -> void:
	_unlocked_zone = unlocked_zone_id


func _on_mission_state_changed(_mission_id: String, _new_state: int) -> void:
	_update_npc_alerts()


func _update_npc_alerts() -> void:
	for child in _entities.get_children():
		if child is Npc:
			var npc := child as Npc
			var pending := npc.mission != null \
				and MissionManager.get_state(npc.mission.id) == MissionManager.State.PENDIENTE
			npc.set_alert(pending)


func _is_mission_target(creature: CreatureData) -> bool:
	return main_mission != null and creature != null and creature.id == main_mission.target_creature_id


## Muestra un diálogo bloqueando al jugador mientras dura.
func _say(lines: Array[String], speaker: String = "") -> void:
	var was_enabled := _player.input_enabled
	_player.input_enabled = false
	await _dialog.show_lines(lines, speaker)
	_player.input_enabled = was_enabled
