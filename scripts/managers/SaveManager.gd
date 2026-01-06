# scripts/managers/SaveManager.gd
extends Node
class_name SaveManager

# =====================
# Signals (For UI feedback)
# =====================
signal save_started()
signal save_completed(success: bool, message: String)
signal load_started()
signal load_completed(success: bool, message: String)
signal autosave_triggered()

# =====================
# Dependencies
# =====================
@export var player_data: PlayerData

# =====================
# Config
# =====================
const SAVE_PATH: String = "user://savegame.save"
const AUTOSAVE_PATH: String = "user://autosave.save"
const BACKUP_PATH: String = "user://savegame_backup.save"
const SAVE_VERSION: int = 3

@export var autosave_interval_minutes: float = 5.0
var autosave_timer: Timer

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	if not player_data:
		player_data = PlayerData.get_instance()
	
	# Autosave timer
	autosave_timer = Timer.new()
	autosave_timer.wait_time = autosave_interval_minutes * 60
	autosave_timer.one_shot = false
	autosave_timer.timeout.connect(_on_autosave)
	add_child(autosave_timer)
	autosave_timer.start()

# =====================
# Public API
# =====================
func save_game(slot_path: String = SAVE_PATH) -> void:
	save_started.emit()
	
	var success = _perform_save(slot_path)
	var message = "Game saved successfully!" if success else "Save failed!"
	
	save_completed.emit(success, message)
	if success:
		print(message)

func load_game(slot_path: String = SAVE_PATH) -> void:
	load_started.emit()
	
	var success = _perform_load(slot_path)
	var message = "Game loaded!" if success else "Load failed or no save found."
	
	load_completed.emit(success, message)
	if success:
		print(message)

func autosave() -> void:
	autosave_triggered.emit()
	save_game(AUTOSAVE_PATH)

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH) or FileAccess.file_exists(AUTOSAVE_PATH)

# =====================
# Core Save/Load
# =====================
func _perform_save(path: String) -> bool:
	var data = player_data.get_save_dict()  # You add this method to PlayerData
	data["save_version"] = SAVE_VERSION
	data["timestamp"] = Time.get_unix_time_from_system()
	data["playtime_seconds"] = player_data.get_playtime()  # Add if you track it
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("SaveManager: Cannot open file for writing: %s" % path)
		return false
	
	file.store_string(JSON.stringify(data, "  ", false))
	file.close()
	
	# Backup main save
	if path == SAVE_PATH:
		DirAccess.copy_absolute(SAVE_PATH, BACKUP_PATH)
	
	return true

func _perform_load(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return false
	
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("SaveManager: Cannot open file for reading: %s" % path)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var parse = JSON.new()
	var error = parse.parse(content)
	if error != OK:
		push_error("SaveManager: Corrupted save file")
		return false
	
	var data = parse.data
	
	# Version migration (future-proof)
	if data.get("save_version", 1) < SAVE_VERSION:
		data = _migrate_save_data(data)
	
	player_data.load_from_dict(data)
	return true

# =====================
# Version Migration (Example)
# =====================
func _migrate_save_data(data: Dictionary) -> Dictionary:
	var old_version = data.get("save_version", 1)
	if old_version < 2:
		# Example: add new field
		data["dust"] = data.get("shards", 0) * 2  # old shards → new dust
	if old_version < 3:
		data["relationships"] = {}  # new system
	
	data["save_version"] = SAVE_VERSION
	return data

# =====================
# Autosave Trigger
# =====================
func _on_autosave() -> void:
	if player_data.has_unsaved_changes():  # Optional flag
		autosave()

# =====================
# Debug / Convenience
# =====================
func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	if FileAccess.file_exists(AUTOSAVE_PATH):
		DirAccess.remove_absolute(AUTOSAVE_PATH)
	print("Save files deleted.")