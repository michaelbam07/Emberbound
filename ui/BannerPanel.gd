# ui/BannerPanel.gd
extends Control
class_name BannerPanel

# =====================
# Signals
# =====================
signal pull_requested(is_multi: bool)
signal closed

# =====================
# UI References
# =====================
@onready var title_label: Label = $TitleLabel
@onready var featured_container: VBoxContainer = $FeaturedUnits
@onready var single_pull_btn: Button = $SinglePullButton
@onready var multi_pull_btn: Button = $MultiPullButton
@onready var close_btn: Button = $CloseButton
@onready var pity_label: Label = $PityCounter  # Add this to your scene!
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Optional: Featured unit preview scene (for icons instead of text)
@export var featured_preview_scene: PackedScene

# =====================
# Runtime Data
# =====================
var current_banner: BannerBase = null :
	set(value):
		if current_banner != value:
			current_banner = value
			_refresh_banner_display()

# =====================
# Public Setup
# =====================
func setup(banner: BannerBase) -> void:
	current_banner = banner
	_connect_buttons()
	anim_player.play("slide_in")

# =====================
# Refresh Display
# =====================
func _refresh_banner_display() -> void:
	if not current_banner:
		push_warning("BannerPanel: No banner assigned!")
		return
	
	title_label.text = current_banner.name
	
	_update_featured_units()
	_update_pity_counter()

# =====================
# Featured Units Display
# =====================
func _update_featured_units() -> void:
	_clear_children(featured_container)
	
	if current_banner.featured_units.is_empty():
		var no_feat = Label.new()
		no_feat.text = "Standard Rates"
		no_feat.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_feat.add_theme_color_override("font_color", Color.GRAY)
		featured_container.add_child(no_feat)
		return
	
	for rarity: String in current_banner.featured_units.keys():
		for unit_id: String in current_banner.featured_units[rarity]:
			if featured_preview_scene:
				var preview = featured_preview_scene.instantiate()
				preview.unit_id = unit_id
				preview.rarity = rarity
				featured_container.add_child(preview)
			else:
				var label = Label.new()
				label.text = "%s (%s ★)" % [unit_id.capitalize(), rarity.capitalize()]
				label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				label.add_theme_color_override("font_color", get_rarity_color(rarity))
				featured_container.add_child(label)

# =====================
# Pity Counter (Live Update)
# =====================
func _update_pity_counter() -> void:
	if not pity_label:
		return
	
	var banner_id = current_banner.id
	var pity_data = PlayerData.get_pity_for_banner(banner_id)  # You'll add this!
	
	var legendary_pity = current_banner.hard_pity.get("legendary", 50)
	var current = pity_data.get("legendary", 0)
	
	var text = "Pity: %d / %d" % [current, legendary_pity]
	if current >= legendary_pity:
		text += " → GUARANTEED!"
		pity_label.add_theme_color_override("font_color", Color.GOLD)
	else:
		pity_label.add_theme_color_override("font_color", Color.WHITE)
	
	pity_label.text = text

# =====================
# Button Handling
# =====================
func _connect_buttons() -> void:
	single_pull_btn.pressed.connect(_on_single_pull)
	multi_pull_btn.pressed.connect(_on_multi_pull)
	close_btn.pressed.connect(_on_close)

func _on_single_pull() -> void:
	pull_requested.emit(false)

func _on_multi_pull() -> void:
	pull_requested.emit(true)

func _on_close() -> void:
	anim_player.play("slide_out")
	await anim_player.animation_finished
	closed.emit()
	hide()

# =====================
# Button State Control
# =====================
func disable_pull_buttons() -> void:
	single_pull_btn.disabled = true
	multi_pull_btn.disabled = true

func enable_pull_buttons() -> void:
	single_pull_btn.disabled = false
	multi_pull_btn.disabled = false

# =====================
# Helpers
# =====================
func _clear_children(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()

func get_rarity_color(rarity: String) -> Color:
	match rarity.to_lower():
		"common": return Color.GRAY
		"uncommon": return Color(0.2, 1, 0.2)
		"rare": return Color(0.2, 0.6, 1)
		"epic": return Color(0.9, 0.2, 1)
		"legendary": return Color(1, 0.8, 0.2)
		"mythic": return Color(1, 0.4, 0.1)
		_: return Color.WHITE