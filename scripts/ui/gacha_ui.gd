extends Control
class_name GachaUI

# -------------------------------------------------
# UI References
# -------------------------------------------------
@onready var banner_panel: BannerPanel = $CanvasLayer/BannerPanel
@onready var dim_bg: ColorRect = $CanvasLayer/DimBackground
@onready var popup_manager: PopupManager = $CanvasLayer/PopupLayer/PopupManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# -------------------------------------------------
# Systems
# -------------------------------------------------
var gacha_manager: GachaManager

# Pull state
var is_pulling := false
var pending_results: Array = []
var reveal_index := 0

# -------------------------------------------------
# Lifecycle
# -------------------------------------------------
func _ready() -> void:
	gacha_manager = get_node("/root/GachaManager")
	hide()
	animation_player.animation_finished.connect(_on_animation_finished)

# -------------------------------------------------
# Open / Close
# -------------------------------------------------
func open_banner(banner: BannerBase) -> void:
	if is_pulling:
		return
	show()
	dim_bg.visible = true
	banner_panel.set_banner(banner)

func close() -> void:
	if is_pulling:
		return
	hide()
	dim_bg.visible = false

# -------------------------------------------------
# Pull Entry Points (called by BannerPanel)
# -------------------------------------------------
func start_single_pull() -> void:
	if is_pulling:
		return
	_start_pull_sequence(1)

func start_multi_pull() -> void:
	if is_pulling:
		return
	_start_pull_sequence(10)

# -------------------------------------------------
# Pull Flow Controller
# -------------------------------------------------
func _start_pull_sequence(count: int) -> void:
	is_pulling = true
	pending_results.clear()
	reveal_index = 0

	# Lock UI
	banner_panel.disable_buttons()

	# Pre-roll results (logic first, visuals later)
	for i in range(count):
		if banner_panel.current_banner.pull_type == "companion":
			pending_results.append(gacha_manager.pull_companion())
		else:
			pending_results.append(gacha_manager.pull_weapon())

	# Start summon animation
	animation_player.play("summon_start")

# -------------------------------------------------
# Animation Callbacks
# -------------------------------------------------
func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"summon_start":
			_reveal_next()
		"reveal_item":
			_reveal_next()

# -------------------------------------------------
# Reveal individual items
# -------------------------------------------------
func _reveal_next() -> void:
	if reveal_index >= pending_results.size():
		_on_pull_sequence_complete()
		return

	var item = pending_results[reveal_index]
	reveal_index += 1

	# Short delay for suspense
	yield(get_tree().create_timer(0.3), "timeout")

	# Show popup
	var color = ColorUtils.get_rarity_color(item.rarity)
	popup_manager.show("%s (%s)" % [item.name, item.rarity.capitalize()], color)

	# Play reveal animation
	animation_player.play("reveal_item")

# -------------------------------------------------
# End of pull sequence
# -------------------------------------------------
func _on_pull_sequence_complete() -> void:
	is_pulling = false
	banner_panel.enable_buttons()
