# scripts/managers/BanterManager.gd
extends Node
class_name BanterManager

# Loaded from dialogue.json or .tres
var dialogue_data: Dictionary = {}

# Optional: Seed for reproducible "random" banter (great for testing)
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()  # Or seed with fixed value for testing

# =====================
# Loading
# =====================
func load_from_json(path: String = "res://data/dialogue.json") -> bool:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("BanterManager: Cannot open %s" % path)
		return false
	
	var json_text = file.get_as_text()
	file.close()
	
	var parse_result = JSON.new()
	var error = parse_result.parse(json_text)
	if error != OK:
		push_error("BanterManager: Invalid JSON in %s — %s" % [path, parse_result.get_error_message()])
		return false
	
	dialogue_data = parse_result.data
	return true

# =====================
# Core Banter Retrieval
# =====================
func get_banter(companion_ids: Array[String], context: String, fallback: String = "") -> String:
	if dialogue_data.is_empty():
		return fallback
	
	if not dialogue_data.has(context):
		return fallback
	
	var candidates: Array[Dictionary] = []
	for entry in dialogue_data[context]:
		if "speaker" in entry and entry.speaker in companion_ids:
			if "text" in entry:
				candidates.append(entry)
	
	if candidates.is_empty():
		return fallback
	
	var chosen: Dictionary = candidates[rng.randi() % candidates.size()]
	return chosen["text"]

# =====================
# Convenience Overloads
# =====================
func get_random_idle_banter(companion_ids: Array[String]) -> String:
	return get_banter(companion_ids, "campfire_idle", "…")

func get_pull_reaction(companion_ids: Array[String], rarity: String) -> String:
	var context = "after_pull_%s" % rarity.to_lower()
	return get_banter(companion_ids, context, "Nice pull!")

func get_low_health_banter(companion_ids: Array[String]) -> String:
	return get_banter(companion_ids, "low_health", "We're hurt!")

func get_boss_spotted_banter(companion_ids: Array[String]) -> String:
	return get_banter(companion_ids, "entering_boss_room", "Here we go...")