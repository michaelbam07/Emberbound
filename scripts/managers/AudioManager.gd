# scripts/managers/AudioManager.gd
extends Node
class_name AudioManager

# =====================
# Signals (For UI sync, e.g., animate on beat)
# =====================
signal sfx_played(stream_name: String)
signal music_changed(new_stream: AudioStream)

# =====================
# Exported Audio Assets
# =====================
@export_group("SFX")
@export var gacha_pull_sfx: AudioStream
@export var rare_pull_sfx: AudioStream
@export var epic_pull_sfx: AudioStream
@export var legendary_pull_sfx: AudioStream
@export var mythic_pull_sfx: AudioStream
@export var dupe_sfx: AudioStream
@export var level_up_sfx: AudioStream
@export var inventory_open_sfx: AudioStream
@export var inventory_select_sfx: AudioStream
@export var campfire_ambient_sfx: AudioStream
@export var campfire_roar_sfx: AudioStream
@export var popup_sfx: AudioStream
@export var button_click_sfx: AudioStream

@export_group("Music")
@export var menu_music: AudioStream
@export var gacha_music: AudioStream
@export var campfire_music: AudioStream
@export var combat_music: AudioStream

# =====================
# Volume Settings (Saved in PlayerData later)
# =====================
@export_range(0.0, 1.0, 0.01) var master_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var music_volume: float = 0.7
@export_range(0.0, 1.0, 0.01) var sfx_volume: float = 0.8

# =====================
# Audio Players
# =====================
var music_player: AudioStreamPlayer
var music_tween: Tween

# Multiple SFX players for overlap (pulls + clicks + campfire)
var sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_CHANNELS: int = 8

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	# Music player with fade support
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"
	
	# Create SFX pool
	for i in MAX_SFX_CHANNELS:
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)
	
	# Set initial volumes
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))

# =====================
# SFX Playback (Channel Pooling)
# =====================
func play_sfx(stream: AudioStream, pitch: float = 1.0, volume_db: float = 0.0) -> void:
	if not stream:
		return
	
	# Find free player
	var player: AudioStreamPlayer = null
	for p in sfx_players:
		if not p.playing:
			player = p
			break
	
	# If all busy, use the oldest
	if not player:
		player = sfx_players[0]
	
	player.stream = stream
	player.pitch_scale = pitch
	player.volume_db = volume_db
	player.play()
	sfx_played.emit(stream.resource_path.get_file())

# Specific SFX shortcuts
func play_gacha_pull(rarity: String = "common") -> void:
	var sfx = match rarity.to_lower():
		"mythic": mythic_pull_sfx
		"legendary": legendary_pull_sfx
		"epic": epic_pull_sfx
		"rare": rare_pull_sfx
		_: gacha_pull_sfx
	play_sfx(sfx, randf_range(0.95, 1.05))

func play_campfire_roar() -> void:
	play_sfx(campfire_roar_sfx, 1.0, 3.0)  # Louder!

func play_level_up() -> void:
	play_sfx(level_up_sfx, 1.1)

func play_inventory_open() -> void:
	play_sfx(inventory_open_sfx)

func play_button_click() -> void:
	play_sfx(button_click_sfx, randf_range(0.9, 1.1))

# =====================
# Music System (Crossfade)
# =====================
func play_music(stream: AudioStream, fade_duration: float = 1.0) -> void:
	if not stream or music_player.stream == stream:
		return
	
	if music_player.playing:
		# Fade out current
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", -80, fade_duration)
		await music_tween.finished
		music_player.stop()
	
	music_player.stream = stream
	music_player.volume_db = -80
	music_player.play()
	
	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", linear_to_db(music_volume), fade_duration)
	music_changed.emit(stream)

func stop_music(fade_duration: float = 1.0) -> void:
	if music_player.playing:
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", -80, fade_duration)
		await music_tween.finished
		music_player.stop()

# =====================
# Ambient Loops
# =====================
func play_campfire_ambient(loop: bool = true) -> void:
	play_music(campfire_music, 2.0)  # Slow fade in
	play_sfx(campfire_ambient_sfx, 1.0, -6.0)  # Quiet loop

# =====================
# Volume Controls
# =====================
func set_master_volume(value: float) -> void:
	master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func set_music_volume(value: float) -> void:
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))