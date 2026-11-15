class_name CapsuleModal
extends Control
## Modal de la cápsula histórica (RF-05): ilustración y páginas de 3-4 líneas
## con efecto máquina de escribir. E/Enter completa la página o pasa a la siguiente.

signal _advanced

@onready var _title: Label = %Title
@onready var _illustration: TextureRect = %Illustration
@onready var _body: TypewriterLabel = %Body
@onready var _footer: Label = %Footer


func _ready() -> void:
	hide()


func show_capsule(capsule: HistoricCapsule) -> void:
	if capsule == null or capsule.pages.is_empty():
		return
	_title.text = capsule.title
	_illustration.texture = capsule.illustration
	_illustration.visible = capsule.illustration != null
	show()
	var total := capsule.pages.size()
	for i in total:
		_footer.text = "%d/%d" % [i + 1, total]
		_type_page(capsule.pages[i], i == total - 1)
		await _advanced
	hide()
	# TODO(equipo): mini-trivia opcional (ver docs/decisiones-pendientes.md).


func _type_page(page: String, is_last: bool) -> void:
	await _body.type_text(page)
	_footer.text += "  E: cerrar" if is_last else "  E ▶"


func _input(event: InputEvent) -> void:
	if not visible or not event.is_action_pressed("interact"):
		return
	get_viewport().set_input_as_handled()
	if _body.is_typing():
		_body.skip()
	else:
		_advanced.emit()
