# ui/ItemDetailPopup.gd
extends Control
class_name ItemDetailPopup

# =====================
# UI References
# =====================
@onready var name_label: Label = $Panel/VBoxContainer/NameLabel
@onready var rarity_label: Label = $Panel/VBoxContainer/RarityLabel
@onready var type_label: Label = $Panel/VBoxContainer/TypeLabel
@onready var level_label: Label = $Panel/VBoxContainer/LevelLabel
@onready var stats_label: RichTextLabel = $Panel/VBoxContainer/StatsLabel  # Use RichTextLabel for formatting
@onready var passive_label: Label = $Panel/VBoxContainer/PassiveLabel
@onready var active_label: Label = $Panel/VBoxContainer/ActiveLabel
@onready var desc_label: Label = $Panel/VBoxContainer/DescriptionLabel
@onready var equipped_badge: TextureRect = $Panel/EquippedBadge
@onready var heart_icon: TextureRect = $Panel/HeartIcon
@onready var icon: TextureRect = $Panel/Icon
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# =====================
# Runtime
# =====================
var current_item: GachaItem = null

# =====================
# Public Entry
# =====================
func show_item(item: GachaItem) -> void:
	current_item = item
	_refresh_display()
	
	visible = true
	anim_player.play("open")

# =====================
# Display Refresh
# =====================
func _refresh_display() -> void:
	if not current_item:
		return
	
	# Icon
	if current_item.has("icon") and current_item.icon:
		icon.texture = current_item.icon
	else:
		icon.texture = preload("res://assets/icons/default.png")
	
	# Name & Rarity
	name_label.text = current_item.get_display_name()
	var rarity_str = current_item.rarity if current_item.rarity is String else "common"
	rarity_label.text = ColorUtils.rarity_stars(rarity_str) + " " + ColorUtils.rarity_name(rarity_str)
	var rarity_color = ColorUtils.rarity_color(rarity_str)
	rarity_label.add_theme_color_override("font_color", rarity_color)
	
	# Type / Role
	if current_item is CompanionInstance:
		type_label.text = "Role: %s" % current_item.role.capitalize()
		heart_icon.visible = current_item.bond > 50
	else:
		type_label.text = "Weapon Type"
		heart_icon.visible = false
	
	# Level
	level_label.text = "Level %d" % current_item.level
	if current_item.is_max_level():
		level_label.text += " [MAX]"
	
	# Equipped badge
	var is_equipped = PlayerData.get_instance().is_item_equipped(current_item)
	equipped_badge.visible = is_equipped
	
	# Stats (rich text for bold/color)
	stats_label.text = _build_stats_text(current_item)
	
	# Abilities
	if current_item is CompanionInstance:
		passive_label.text = "[Passive] %s" % current_item.passive.get("name", "")
		if current_item.active_ability:
			active_label.text = "[Active] %s - %s" % [
				current_item.active_ability.get("name", "Unknown"),
				current_item.active_ability.get("description", "")
			]
		else:
			active_label.text = ""
	else:
		passive_label.text = ""
		active_label.text = ""
	
	# Description / Lore
	desc_label.text = current_item.flavor_text if current_item.has("flavor_text") else current_item.lore

# =====================
# Stats Builder
# =====================
func _build_stats_text(item: GachaItem) -> String:
	var text = ""
	
	if item is WeaponItem:
		text += "[b]Damage:[/b] %d\n" % item.current_damage
		text += "[b]Fire Rate:[/b] %.2f\n" % item.current_fire_rate
		text += "[b]Range:[/b] %d\n" % item.current_range
		if item.crit_chance > 0:
			text += "[b]Crit Chance:[/b] %.1f%%\n" % (item.crit_chance * 100)
	
	elif item is CompanionInstance:
		text += "[b]Health:[/b] %d\n" % item.get_max_health()
		text += "[b]Damage:[/b] %d\n" % item.base_stats.get("damage", 0)
		text += "[b]Bond:[/b] %d / %d ♡\n" % [item.bond, item.get_bond_to_next_level()]
	
	return text

# =====================
# Close
# =====================
func _on_CloseButton_pressed() -> void:
	anim_player.play("close")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "close":
		visible = false
		current_item = null