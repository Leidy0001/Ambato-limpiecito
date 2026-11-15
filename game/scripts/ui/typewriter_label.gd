class_name TypewriterLabel
extends Label
## Label con efecto máquina de escribir (RF-05). Lo usan el diálogo,
## la cápsula histórica y los mensajes de combate.
##
## Uso: `await label.type_text("Hola")`. Llamar a `skip()` muestra todo el texto.

signal typing_finished

@export var chars_per_second: float = 40.0

var _tween: Tween


func type_text(new_text: String) -> void:
	_stop_tween()
	text = new_text
	visible_ratio = 0.0
	var total := get_total_character_count()
	if total == 0:
		visible_ratio = 1.0
		return
	_tween = create_tween()
	_tween.tween_property(self, "visible_ratio", 1.0, total / chars_per_second)
	_tween.finished.connect(_on_tween_finished)
	await typing_finished


func is_typing() -> bool:
	return _tween != null and _tween.is_valid() and _tween.is_running()


## Termina de escribir de inmediato.
func skip() -> void:
	if not is_typing():
		return
	_stop_tween()
	visible_ratio = 1.0
	typing_finished.emit()


func _on_tween_finished() -> void:
	_tween = null
	typing_finished.emit()


func _stop_tween() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = null
