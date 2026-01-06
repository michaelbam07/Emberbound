extends Node
class_name AudioManager

# -------------------------------------------------
# Exported SFX (assign in inspector)
# -------------------------------------------------
@export var gacha_pull_sfx: AudioStream
@export var rare_item_sfx: AudioStream
@export var popup_sfx: AudioStream
@export var inventory_open_sfx: AudioStream
@export var inventory_select_sfx: AudioStream
@export var campfire_sfx: AudioStream

# -------------------------------------------------
# Internal AudioPlayers
# -------------------------------------------------
var sfx_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

func _ready() -> void:
	# Single player for SFX (can overlap with another if needed)
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

	# Optional: separate music player
	music_player = AudioStreamPlayer.new()
	music_player.stream_paused = true
	add_child(music_player)

func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	sfx_player.stream = stream
	sfx_player.play()

func play_music(stream: AudioStream, loop: bool = true) -> void:
	if stream == null:
		return
	music_player.stream = stream
	music_player.loop = loop
	music_player.play()

func stop_music() -> void:
	music_player.stop()
