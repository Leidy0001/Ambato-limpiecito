class_name HistoricCapsule
extends Resource
## Cápsula histórica de la "Pokédex Turística" (RF-05).

@export var id: String = ""
@export var zone_id: int = 1
@export var title: String = ""
@export var illustration: Texture2D
## Cada página: máximo 3-4 líneas, tono "¿Sabías que...?"
@export_multiline var pages: Array[String] = []
@export_group("Trivia opcional")
@export var trivia_question: String = ""
@export var trivia_options: Array[String] = []
@export var trivia_answer_index: int = 0
@export var reward_item_id: String = ""
