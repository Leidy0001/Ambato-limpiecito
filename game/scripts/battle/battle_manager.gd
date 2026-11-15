extends Node
## Máquina de estados del combate por turnos (RF-03).

enum BattleState { INICIO, SELECCION_ACCION, TURNO_JUGADOR, TURNO_ENEMIGO, RESOLUCION, VICTORIA, DERROTA }

signal state_changed(new_state: BattleState)
signal battle_finished(won: bool, purified: bool)

@export var enemy: CreatureData

var state: BattleState = BattleState.INICIO
var player_hp: int = 100
var enemy_hp: int = 0


func start_battle(enemy_data: CreatureData) -> void:
	enemy = enemy_data
	enemy_hp = enemy.max_hp
	_change_state(BattleState.SELECCION_ACCION)


func player_attack(attack: AttackData) -> void:
	if state != BattleState.SELECCION_ACCION:
		return
	_change_state(BattleState.TURNO_JUGADOR)
	if randf() <= attack.accuracy:
		enemy_hp = max(enemy_hp - attack.power, 0)
	_resolve_or_continue(BattleState.TURNO_ENEMIGO)
	if state == BattleState.TURNO_ENEMIGO:
		_enemy_turn()


func _enemy_turn() -> void:
	if enemy.attacks.is_empty():
		_change_state(BattleState.SELECCION_ACCION)
		return
	var atk: AttackData = enemy.attacks.pick_random()
	if randf() <= atk.accuracy:
		player_hp = max(player_hp - atk.power, 0)
	_resolve_or_continue(BattleState.SELECCION_ACCION)


func _resolve_or_continue(next: BattleState) -> void:
	_change_state(BattleState.RESOLUCION)
	if enemy_hp <= 0:
		_change_state(BattleState.VICTORIA)
		GameState.purified_creatures.append(enemy.id)
		battle_finished.emit(true, true)
	elif player_hp <= 0:
		_change_state(BattleState.DERROTA)
		battle_finished.emit(false, false)
	else:
		_change_state(next)


func _change_state(new_state: BattleState) -> void:
	state = new_state
	state_changed.emit(new_state)
