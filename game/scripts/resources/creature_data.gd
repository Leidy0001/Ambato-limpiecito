class_name CreatureData
extends Resource
## Criatura de "basura mutada".

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var zone_id: int = 1
@export var is_boss: bool = false
@export var max_hp: int = 50
@export var front_sprite: Texture2D
@export var attacks: Array[AttackData] = []
