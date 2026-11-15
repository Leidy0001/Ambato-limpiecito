class_name DialogBox
extends PanelContainer
## Caja de diálogo inferior. Muestra una lista de líneas, una por "página".
## "interact" (E/Enter) completa la línea actual o avanza a la siguiente.

signal _advanced

@onready var _speaker: Label = %Speaker
@onready var _text: TypewriterLabel = %Text
@onready var _arrow: Label = %Arrow


func _ready() -> void:
	hide()


## Muestra las líneas y termina cuando el jugador cierra la última.
func show_lines(lines: Array[String], speaker: String = "") -> void:
	if lines.is_empty():
		return
	_speaker.text = speaker
	_speaker.visible = not speaker.is_empty()
	show()
	for line in lines:
		_arrow.hide()
		_type_line(line)
		await _advanced
	hide()


func _type_line(line: String) -> void:
	await _text.type_text(line)
	_arrow.show()


func _input(event: InputEvent) -> void:
	if not visible or not event.is_action_pressed("interact"):
		return
	# Marcar como manejado ANTES de avanzar para que el jugador no reciba esta pulsación.
	get_viewport().set_input_as_handled()
	if _text.is_typing():
		_text.skip()
	else:
		_advanced.emit()
