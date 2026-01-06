extends Control
class_name BannerPanel

# -------------------------------------------------
# UI References
# -------------------------------------------------
@onready var title_label: Label = $TitleLabel
@onready var featured_container: VBoxContainer = $FeaturedUnits
@onready var single_pull_btn: Button = $SinglePullButton
@onready var multi_pull_btn: Button = $MultiPullButton
@onready var close_btn: Button = $CloseButton

# -------------------------------------------------
# Runtime references
# -------------------------------------------------
var current_banner: BannerBase
var gacha_ui: GachaUI

# -------------------------------------------------
# Setup banner
# -------------------------------------------------
func set_banner(banner: BannerBase) -> void:
	current_banner = banner
	gacha_ui = get_parent().get_parent() as GachaUI

	title_label.text = "%s Banner" % current_banner.name.capitalize()

	_update_featured_units()
	_connect_buttons()

# -------------------------------------------------
# Button wiring
# -------------------------------------------------
func _connect_buttons() -> void:
	if not single_pull_btn.pressed.is_connected(_on_single_pull):
		single_pull_btn.pressed.connect(_on_single_pull)

	if not multi_pull_btn.pressed.is_connected(_on_multi_pull):
		multi_pull_btn.pressed.connect(_on_multi_pull)

	if not close_btn.pressed.is_connected(_on_close):
		close_btn.pressed.connect(_on_close)

# -------------------------------------------------
# Featured Units UI
# -------------------------------------------------
func _update_featured_units() -> void:
	_clear_container(featured_container)

	if current_banner.banner_type != "limited":
		var label := Label.new()
		label.text = "No featured units"
		featured_container.add_child(label)
		return

	for rarity in current_banner.featured_units.keys():
		for unit_id in current_banner.featured_units[rarity]:
			var label := Label.new()
			label.text = "%s (%s)" % [
				unit_id.capitalize(),
				rarity.capitalize()
			]
			label.add_theme_color_override(
				"font_color",
				ColorUtils.rarity_color(rarity)
			)
			featured_container.add_child(label)

# -------------------------------------------------
# Pull Actions (ANIMATION SAFE)
# -------------------------------------------------
func _on_single_pull() -> void:
	if current_banner == null:
		return

	gacha_ui.start_single_pull()

func _on_multi_pull() -> void:
	if current_banner == null:
		return

	gacha_ui.start_multi_pull()

# -------------------------------------------------
# Button Locking (called by GachaUI)
# -------------------------------------------------
func disable_buttons() -> void:
	single_pull_btn.disabled = true
	multi_pull_btn.disabled = true
	close_btn.disabled = true

func enable_buttons() -> void:
	single_pull_btn.disabled = false
	multi_pull_btn.disabled = false
	close_btn.disabled = false

# -------------------------------------------------
# Close
# -------------------------------------------------
func _on_close() -> void:
	hide()

# -------------------------------------------------
# Helpers
# -------------------------------------------------
func _clear_container(container: Control) -> void:
	for child in container.get_children():
		child.queue_free()
