class_name BattleScene
extends CanvasLayer
## Escena de combate por turnos (RF-03): jugador de espaldas, enemigo de frente,
## menú de 4 ataques ecológicos, barras de vida y mensajes de turno.
##
## La lógica vive en BattleManager. Esta escena solo la presenta: como el
## manager resuelve el turno completo de golpe, aquí se guardan los eventos y
## luego se reproducen uno por uno con animaciones.
##
## Uso desde Main: setup(enemigo) → (transición) → play() → await finished.

signal finished(won: bool)

const MESSAGE_PAUSE := 0.6
const SLIDE_DISTANCE := 140.0

## Ataques del jugador. TODO(equipo): moverlos a GameState cuando haya progresión.
@export var player_attacks: Array[AttackData] = []
## TODO(equipo): nombre oficial del protagonista (docs/decisiones-pendientes.md).
@export var player_name: String = "Eco-Guardián"

var _enemy: CreatureData
var _events: Array[Dictionary] = []
var _busy := false
var _enemy_home: Vector2
var _player_home: Vector2

@onready var _manager: BattleManager = $BattleManager
@onready var _enemy_sprite: TextureRect = $EnemySprite
@onready var _player_sprite: TextureRect = $PlayerSprite
@onready var _enemy_hud: CreatureHud = $EnemyHud
@onready var _player_hud: CreatureHud = $PlayerHud
@onready var _message: TypewriterLabel = %Message
@onready var _attack_menu: GridContainer = %AttackMenu


func _ready() -> void:
	_manager.attack_executed.connect(_on_attack_executed)
	_manager.battle_finished.connect(_on_battle_finished)
	_enemy_home = _enemy_sprite.position
	_player_home = _player_sprite.position
	_build_attack_menu()
	_attack_menu.hide()


## Prepara la pantalla (sin animar) para que la transición la revele lista.
func setup(enemy: CreatureData) -> void:
	_enemy = enemy
	_manager.start_battle(enemy)
	_enemy_sprite.texture = enemy.front_sprite
	_enemy_hud.setup(enemy.display_name, enemy.max_hp, _manager.enemy_hp)
	_player_hud.setup(player_name, BattleManager.PLAYER_MAX_HP, _manager.player_hp)
	_enemy_sprite.position = _enemy_home + Vector2(SLIDE_DISTANCE, 0)
	_player_sprite.position = _player_home - Vector2(SLIDE_DISTANCE, 0)
	_enemy_hud.modulate.a = 0.0
	_player_hud.modulate.a = 0.0
	_message.text = ""


## Animación de entrada y primer turno.
func play() -> void:
	_busy = true
	var tw := create_tween().set_parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(_enemy_sprite, "position", _enemy_home, 0.5)
	tw.tween_property(_player_sprite, "position", _player_home, 0.5)
	tw.chain().tween_property(_enemy_hud, "modulate:a", 1.0, 0.2)
	tw.tween_property(_player_hud, "modulate:a", 1.0, 0.2)
	await tw.finished
	await _say("¡%s bloquea el camino!" % _enemy.display_name)
	_open_menu()


func _build_attack_menu() -> void:
	for child in _attack_menu.get_children():
		child.queue_free()
	for attack in player_attacks:
		var button := Button.new()
		button.text = attack.display_name
		button.tooltip_text = attack.description
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.focus_entered.connect(_on_attack_focused.bind(attack))
		button.mouse_entered.connect(_on_attack_focused.bind(attack))
		button.pressed.connect(_on_attack_chosen.bind(attack))
		_attack_menu.add_child(button)


func _open_menu() -> void:
	_busy = false
	_attack_menu.show()
	if _attack_menu.get_child_count() > 0:
		(_attack_menu.get_child(0) as Button).grab_focus()


func _on_attack_focused(attack: AttackData) -> void:
	if _busy:
		return
	_message.skip()
	_message.text = "%s: %s" % [attack.display_name, attack.description]
	_message.visible_ratio = 1.0


func _on_attack_chosen(attack: AttackData) -> void:
	if _busy:
		return
	_busy = true
	_attack_menu.hide()
	_events.clear()
	_manager.player_attack(attack)  # resuelve el turno completo y llena _events
	await _play_events()


func _on_attack_executed(by_player: bool, attack: AttackData, hit: bool, target_hp: int) -> void:
	_events.append({"type": "attack", "by_player": by_player, "attack": attack, "hit": hit, "target_hp": target_hp})


func _on_battle_finished(won: bool, _purified: bool) -> void:
	_events.append({"type": "end", "won": won})


func _play_events() -> void:
	for event in _events:
		if event.type == "attack":
			await _play_attack(event.by_player, event.attack, event.hit, event.target_hp)
		elif event.type == "end":
			await _play_end(event.won)
			return
	_open_menu()


func _play_attack(by_player: bool, attack: AttackData, hit: bool, target_hp: int) -> void:
	var attacker := player_name if by_player else _enemy.display_name
	await _say("%s usó %s." % [attacker, attack.display_name])
	if not hit:
		await _say("¡Pero falló!")
		return
	var target_sprite := _enemy_sprite if by_player else _player_sprite
	var target_hud := _enemy_hud if by_player else _player_hud
	await _hit_effect(target_sprite)
	await target_hud.animate_hp(target_hp)


func _play_end(won: bool) -> void:
	if won:
		var tw := create_tween()
		tw.tween_property(_enemy_sprite, "modulate", Color(3, 3, 3, 1), 0.25)
		tw.tween_property(_enemy_sprite, "modulate", Color(1, 1, 1, 0), 0.5)
		await tw.finished
		await _say("¡%s fue purificado!" % _enemy.display_name)
	else:
		await _say("¡%s se quedó sin energía!" % player_name)
	await get_tree().create_timer(MESSAGE_PAUSE).timeout
	finished.emit(won)


func _hit_effect(sprite: TextureRect) -> void:
	var home := sprite.position
	var tw := create_tween()
	for i in 2:
		tw.tween_property(sprite, "modulate:a", 0.2, 0.06)
		tw.parallel().tween_property(sprite, "position:x", home.x + 3, 0.06)
		tw.tween_property(sprite, "modulate:a", 1.0, 0.06)
		tw.parallel().tween_property(sprite, "position:x", home.x - 3, 0.06)
	tw.tween_property(sprite, "position", home, 0.04)
	await tw.finished


func _say(text: String) -> void:
	await _message.type_text(text)
	await get_tree().create_timer(MESSAGE_PAUSE).timeout


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	# E también sirve para elegir el ataque enfocado (Enter/Espacio ya lo hacen como ui_accept).
	if _message.is_typing():
		_message.skip()
		get_viewport().set_input_as_handled()
	elif not _busy:
		var focused := get_viewport().gui_get_focus_owner()
		if focused is Button and _attack_menu.is_ancestor_of(focused):
			get_viewport().set_input_as_handled()
			(focused as Button).pressed.emit()
