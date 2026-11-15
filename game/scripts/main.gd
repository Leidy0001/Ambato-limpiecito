extends Node2D
## Escena raíz: carga la zona actual y alterna entre overworld y combate.
## Más adelante cargará también el menú principal.

const ZONE_SCENES := {
	1: preload("res://scenes/overworld/zona1/zona1_quinta_juan_leon_mera.tscn"),
}
const BATTLE_SCENE := preload("res://scenes/battle/battle_scene.tscn")

var _zone: Zone

@onready var _transition: ScreenTransition = $ScreenTransition


func _ready() -> void:
	print("Ambato Limpiecito iniciado. Zona actual: ", GameState.current_zone)
	_load_zone(GameState.current_zone)


func _load_zone(zone_id: int) -> void:
	if not ZONE_SCENES.has(zone_id):
		push_error("Zona %d aún no implementada" % zone_id)
		return
	var scene: PackedScene = ZONE_SCENES[zone_id]
	_zone = scene.instantiate() as Zone
	add_child(_zone)
	move_child(_zone, 0)  # la transición queda siempre encima
	_zone.battle_requested.connect(_on_battle_requested)


func _on_battle_requested(enemy: CreatureData) -> void:
	await _transition.play_battle_intro()
	# La zona sale del árbol (sin liberarse) para conservar su estado.
	remove_child(_zone)
	var battle := BATTLE_SCENE.instantiate() as BattleScene
	add_child(battle)
	battle.setup(enemy)
	await _transition.fade_in()
	battle.play()
	var won: bool = await battle.finished

	await _transition.fade_out()
	battle.queue_free()
	add_child(_zone)
	move_child(_zone, 0)
	await _transition.fade_in()
	_zone.on_battle_finished(won)
