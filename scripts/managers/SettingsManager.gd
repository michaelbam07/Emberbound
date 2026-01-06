# scripts/managers/SettingsManager.gd
extends Node
class_name SettingsManager

# =====================
# Signals (For UI sliders to update in real-time)
# =====================
signal master_volume_changed(value: float)
signal music_volume_changed(value: float)
signal sfx_volume_changed(value: float)
signal fullscreen_toggled(enabled: bool)

# =====================
# Volume Settings
# =====================
var master_volume: float = 1.0 :
	set(value):
		master_volume = clampf(value, 0.0, 1.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
		master_volume_changed.emit(master_volume)
		_save_settings()

var music_volume: float = 0.8 :
	set(value):
		music_volume = clampf(value, 0.0, 1.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
		music_volume_changed.emit(music_volume)
		_save_settings()

var sfx_volume: float = 0.8 :
	set(value):
		sfx_volume = clampf(value, 0.0, 1.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
		sfx_volume_changed.emit(sfx_volume)
		_save_settings()

# =====================
# Display Settings
# =====================
var fullscreen: bool = false :
	set(value):
		fullscreen = value
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen_toggled.emit(fullscreen)
		_save_settings()

# =====================
# Mute Toggles
# =====================
var music_muted: bool = false :
	set(value):
		music_muted = value
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), music_muted)
		_save_settings()

var sfx_muted: bool = false :
	set(value):
		sfx_muted = value
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), sfx_muted)
		_save_settings()

# =====================
# Save Path
# =====================
const SETTINGS_PATH: String = "user://settings.save"

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	_load_settings()
	# Apply initial values (in case load failed)
	master_volume = master_volume
	music_volume = music_volume
	sfx_volume = sfx_volume
	fullscreen = fullscreen

# =====================
# Save / Load
# =====================
func _save_settings() -> void:
	var data = {
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"fullscreen": fullscreen,
		"music_muted": music_muted,
		"sfx_muted": sfx_muted
	}
	
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func _load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if not file:
		return
	
	var content = file.get_as_text()
	file.close()
	
	var parse = JSON.new()
	if parse.parse(content) != OK:
		return
	
	var data = parse.data
	
	master_volume = data.get("master_volume", 1.0)
	music_volume = data.get("music_volume", 0.8)
	sfx_volume = data.get("sfx_volume", 0.8)
	fullscreen = data.get("fullscreen", false)
	music_muted = data.get("music_muted", false)
	sfx_muted = data.get("sfx_muted", false)

# =====================
# Debug / Reset
# =====================
func reset_to_defaults() -> void:
	master_volume = 1.0
	music_volume = 0.8
	sfx_volume = 0.8
	fullscreen = false
	music_muted = false
	sfx_muted = false
	_save_settings()