class_name AttackData
extends Resource
## Ataque o habilidad ecológica (Reciclar, Filtro UV, Cortafuegos, Compostaje...).

enum EcoType { RECICLAJE, AGUA, AIRE, SUELO, NEUTRO }

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var eco_type: EcoType = EcoType.NEUTRO
@export var power: int = 10
@export_range(0.0, 1.0) var accuracy: float = 0.95
