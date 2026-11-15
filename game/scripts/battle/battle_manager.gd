class_name BattleManager
extends Node
## Máquina de estados del combate por turnos (RF-03).
## Solo lógica: la escena BattleScene escucha las señales y anima el resultado.

enum BattleState { INICIO, SELECCION_ACCION, TURNO_JUGADOR, TURNO_ENEMIGO, RESOLUCION, VICTORIA, DERROTA }

const PLAYER_MAX_HP := 100

signal state_changed(new_state: BattleState)
signal battle_finished(won: bool, purified: bool)
## Se emite tras cada ataque, con la vida que le queda al objetivo.
signal attack_executed(by_player: bool, attack: AttackData, hit: bool, target_hp: int)

@export var enemy: CreatureData

var state: BattleState = BattleState.INICIO
var player_hp: int = PLAYER_MAX_HP
var enemy_hp: int = 0


func start_battle(enemy_data: CreatureData) -> void:
	enemy = enemy_data
	enemy_hp = enemy.max_hp
	player_hp = PLAYER_MAX_HP
	_change_state(BattleState.SELECCION_ACCION)


func player_attack(attack: AttackData) -> void:
	if state != BattleState.SELECCION_ACCION:
		return
	_change_state(BattleState.TURNO_JUGADOR)
	var hit := randf() <= attack.accuracy
	if hit:
		enemy_hp = maxi(enemy_hp - attack.power, 0)
	attack_executed.emit(true, attack, hit, enemy_hp)
	_resolve_or_continue(BattleState.TURNO_ENEMIGO)
	if state == BattleState.TURNO_ENEMIGO:
		_enemy_turn()


func _enemy_turn() -> void:
	if enemy.attacks.is_empty():
		_change_state(BattleState.SELECCION_ACCION)
		return
	var atk: AttackData = enemy.attacks.pick_random()
	var hit := randf() <= atk.accuracy
	if hit:
		player_hp = maxi(player_hp - atk.power, 0)
	attack_executed.emit(false, atk, hit, player_hp)
	_resolve_or_continue(BattleState.SELECCION_ACCION)


func _resolve_or_continue(next: BattleState) -> void:
	_change_state(BattleState.RESOLUCION)
	if enemy_hp <= 0:
		_change_state(BattleState.VICTORIA)
		if enemy.id not in GameState.purified_creatures:
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
