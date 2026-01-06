extends Node
class_name BanterManager

var dialogue_data: Dictionary = {} # loaded from dialogue.json

func load_dialogue(data: Dictionary) -> void:
	dialogue_data = data

func get_banter(
	companion_ids: Array,
	context: String
) -> String:
	if not dialogue_data.has(context):
		return ""

	var candidates := []
	for entry in dialogue_data[context]:
		if entry["speaker"] in companion_ids:
			candidates.append(entry)

	if candidates.is_empty():
		return ""

	return candidates[randi() % candidates.size()]["text"]
