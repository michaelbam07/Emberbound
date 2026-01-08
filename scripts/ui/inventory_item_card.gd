# ui/InventoryItemCard.gd
extends PanelContainer
class_name InventoryItemCard

# =====================
# Signals (For parent InventoryUI)
# =====================
signal clicked(item: GachaItem)
signal hovered(item: GachaItem)
signal hover_ended(item: GachaItem)

# =====================
# UI References
# =====================
@onready var border: TextureRect = $Border
@onready var glow_effect: ColorRect = $Border/GlowEffect  # Add this node
@onready var icon: TextureRect = $VBoxContainer/Icon
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var rarity_label: Label = $VBoxContainer/RarityLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var equipped_badge: TextureRect = $EquippedBadge  # Optional badge
@onready var heart_icon: TextureRect = $HeartIcon         # For high bond companions
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# =====================
# Runtime
# =====================
var item: GachaItem = null :
	set(value):
		item = value
		if item:
			_refresh_display()
		else:
			visible = false

var is_equipped: bool = false :
	set(value):
		is_equipped = value
		if equipped_badge:
			equipped_badge.visible = is_equipped

# =====================
# Setup
# =====================
func set_item(new_item: GachaItem, equipped: bool = false) -> void:
	item = new_item
	is_equipped = equipped
	_refresh_display()

# =====================
# Display Refresh
# =====================
func _refresh_display() -> void:
	if not item:
		visible = false
		return
	
	visible = true
	
	# Icon
	if item.has("icon") and item.icon:
		icon.texture = item.icon
	else:
		icon.texture = preload("res://assets/icons/default_item.png")
	
	# Name
	name_label.text = item.get_display_name()
	
	# Rarity
	var rarity_str = item.rarity if item.rarity is String else "common"
	rarity_label.text = ColorUtils.rarity_stars(rarity_str) + " " + ColorUtils.rarity_name(rarity_str)
	var rarity_color = ColorUtils.rarity_color(rarity_str)
	rarity_label.add_theme_color_override("font_color", rarity_color)
	
	# Border & Glow
	border.modulate = rarity_color
	glow_effect.color = ColorUtils.rarity_glow_color(rarity_str)
	
	if ColorUtils.is_epic_or_higher(rarity_str):
		anim_player.play("rare_glow")
	elif ColorUtils.is_rare_or_higher(rarity_str):
		anim_player.play("uncommon_glow")
	else:
		anim_player.stop()
		glow_effect.visible = false
	
	# Level & Bond (companions only)
	level_label.text = "Lv.%d" % item.level
	if item is CompanionInstance:
		heart_icon.visible = item.bond > 50
	else:
		heart_icon.visible = false
	
	# Equipped badge
	if equipped_badge:
		equipped_badge.visible = is_equipped

# =====================
# Interactions
# =====================
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(item)
		anim_player.play("click_bounce")

func _on_mouse_entered() -> void:
	anim_player.play("hover_scale")
	hovered.emit(item)

func _on_mouse_exited() -> void:
	anim_player.play_backwards("hover_scale")
	hover_ended.emit(item)

# =====================
# Editor Warnings
# =====================
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_node_or_null("VBoxContainer/Icon"):
		warnings.append("Add an Icon TextureRect for item visuals!")
	return warnings