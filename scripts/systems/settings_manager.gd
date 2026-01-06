extends Node
class_name SettingsManager

var master_volume: float = 1.0
var music_volume: float = 0.8
var sfx_volume: float = 0.8

func set_master_volume(val: float) -> void:
	master_volume = clamp(val, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(master_volume))

func set_music_volume(val: float) -> void:
	music_volume = clamp(val, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_volume))

func set_sfx_volume(val: float) -> void:
	sfx_volume = clamp(val, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))
