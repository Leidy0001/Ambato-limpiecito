extends Node
## Estado global de la partida (RF-02, RF-04, RF-05).

signal zone_unlocked(zone_id: int)

const TOTAL_ZONES := 4

var current_zone: int = 1
var unlocked_zones: Array[int] = [1]
var purified_zones: Array[int] = []
var purified_creatures: Array[String] = []
var seen_capsules: Array[String] = []
var inventory: Dictionary = {}  # item_id -> cantidad


func purify_zone(zone_id: int) -> void:
	if zone_id in purified_zones:
		return
	purified_zones.append(zone_id)
	var next := zone_id + 1
	if next <= TOTAL_ZONES and next not in unlocked_zones:
		unlocked_zones.append(next)
		zone_unlocked.emit(next)


func is_zone_purified(zone_id: int) -> bool:
	return zone_id in purified_zones


func add_item(item_id: String, amount: int = 1) -> void:
	inventory[item_id] = inventory.get(item_id, 0) + amount
