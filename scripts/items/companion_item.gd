# core/gacha/companion_item.gd
@tool
extends GachaItem
class_name CompanionItem

# =====================
# Companion-Specific Properties
# =====================
@export var role: String = "support" :
	set(value):
		role = value
		notify_property_list_changed()  # Update editor

@export var personality: String = "loyal"
@export_multiline var flavor_text: String = ""
@export_multiline var lore: String = ""

# Relationships — for special banter, stat bonuses, duo abilities
@export var relationships: Array[String] = []  # IDs of companions they have history with

# Banter tags — helps BanterManager pick context-appropriate lines
@export var banter_tags: Array[String] = []  # e.g., "cynical", "optimistic", "foodie", "mechanic"

# Visuals
@export var portrait: Texture2D
@export var campfire_sprite: Texture2D
@export var battle_sprite: Texture2D

# Passive & Active (copied from base data, can be upgraded)
@export var passive: Dictionary = {}
@export var active_ability: Dictionary = {}

# =====================
# Signals
# =====================
signal relationship_formed(partner_id: String)
signal personality_line_triggered(tag: String)

# =====================
# Relationship System
# =====================
func add_relationship(partner_id: String) -> void:
	if partner_id in relationships:
		return
	relationships.append(partner_id)
	relationship_formed.emit(partner_id)
	# Optional: unlock special banter or stat bonus
	print("%s formed a bond with %s!" % [name, CompanionDB.get_companion(partner_id).name])

func has_relationship_with(partner_id: String) -> bool:
	return partner_id in relationships

# =====================
# Banter Helpers
# =====================
func has_personality_tag(tag: String) -> bool:
	return tag.to_lower() in banter_tags.map(func(t): return t.to_lower())

func trigger_personality_line(tag: String) -> void:
	personality_line_triggered.emit(tag)

# =====================
# Display Overrides
# =====================
func get_display_name() -> String:
	var suffix = ""
	if level > 1:
		suffix += " (Lv.%d)" % level
	if bond > 50:
		suffix += " ♡"  # Heart for high bond
	return super.get_display_name() + suffix

# =====================
# Editor Validation
# =====================
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if id.is_empty():
		warnings.append("Companion ID is required!")
	if role.is_empty():
		warnings.append("Assign a role (support, brawler, etc.)")
	if portrait == null:
		warnings.append("Add a portrait for inventory/campfire!")
	return warnings