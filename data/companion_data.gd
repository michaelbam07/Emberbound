# scripts/data/CompanionDatabase.gd
extends Node
class_name CompanionDatabase

# Preload all companions (or load dynamically if you have 100+)
@export var companions: Array[CompanionResource] = []

# Fast lookup: ID → CompanionResource
var _companion_by_id: Dictionary = {}

func _ready() -> void:
	_build_lookup()
	
	# Optional: auto-load all .tres in folder (great for modding!)
	# _load_all_from_folder("res://data/companions/")

func _build_lookup() -> void:
	_companion_by_id.clear()
	for companion: CompanionResource in companions:
		if companion and not companion.id.is_empty():
			_companion_by_id[companion.id] = companion
		else:
			push_warning("Invalid companion resource found!")

# Public API
func get_companion(id: String) -> CompanionResource:
	return _companion_by_id.get(id)

func get_all_companions() -> Array[CompanionResource]:
	return companions.duplicate()

func get_companions_by_rarity(rarity: String) -> Array[CompanionResource]:
	var result: Array[CompanionResource] = []
	for c in companions:
		if c.rarity.to_lower() == rarity.to_lower():
			result.append(c)
	return result

# Optional: dynamic folder loading
func _load_all_from_folder(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var res: Resource = load(path + file_name)
				if res is CompanionResource:
					companions.append(res)
			file_name = dir.get_next()
		_build_lookup()