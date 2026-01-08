# ui/GachaUI.gd
extends Control
class_name GachaUI

# =====================
# Signals
# =====================
signal pull_sequence_completed

# =====================
# UI References
# =====================
@onready var dim_bg: ColorRect = $CanvasLayer/DimBackground
@onready var banner_panel: BannerPanel = $CanvasLayer/BannerPanel
@onready var pull_result_screen: Control = $CanvasLayer/PullResultScreen  # We'll build this!
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_manager: AudioManager = AudioManager

# =====================
# Systems
# =====================
@export var gacha_manager: GachaManager

# =====================
# Pull State
# =====================
var is_pulling: bool = false
var current_results: Array[Dictionary] = []
var reveal_index: int = 0

# =====================
# Lifecycle
# =====================
func _ready() -> void:
	gacha_manager = GachaManager.get_instance()
	hide()
	pull_result_screen.hide()

# =====================
# Public Entry
# =====================
func open_with_banner(banner: BannerBase) -> void:
	show()
	dim_bg.visible = true
	banner_panel.setup(banner)
	animation_player.play("gacha_open")

# =====================
# Pull Triggers
# =====================
func start_single_pull() -> void:
	if is_pulling: return
	_perform_pull(false)

func start_multi_pull() -> void:
	if is_pulling: return
	_perform_pull(true)

func _perform_pull(is_multi: bool) -> void:
	is_pulling = true
	banner_panel.disable_pull_buttons()
	
	gacha_manager.perform_single_pull() if not is_multi else gacha_manager.perform_multi_pull()
	
	# Transition to result screen
	animation_player.play("summon_ritual")
	audio_manager.play_sfx(audio_manager.gacha_pull_sfx)

# =====================
# Pull Completed — Start Reveal
# =====================
func _on_gacha_pull_completed(results: Array[Dictionary]) -> void:
	current_results = results
	reveal_index = 0
	
	# Hide banner, show result canvas
	banner_panel.hide()
	pull_result_screen.show()
	pull_result_screen.prepare_results(current_results)
	
	animation_player.play("reveal_sequence_start")
	audio_manager.play_music(audio_manager.gacha_music, 1.0)

# =====================
# Reveal Flow (Delegated to PullResultScreen)
# =====================
# Connect in _ready():
# pull_result_screen.reveal_completed.connect(_on_reveal_sequence_complete)

func _on_reveal_sequence_complete() -> void:
	is_pulling = false
	banner_panel.enable_pull_buttons()
	pull_sequence_completed.emit()
	
	# Option: auto-open inventory or campfire
	# UIManager.show_inventory()

# =====================
# Close
# =====================
func close_gacha() -> void:
	if is_pulling: return
	animation_player.play_backwards("gacha_open")
	await animation_player.animation_finished
	hide()
	dim_bg.visible = false