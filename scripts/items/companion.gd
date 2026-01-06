# res://core/companions/companion.gd
extends Node

class_name Companion

# ===================
# Companion Properties
# ===================
var id: String
var name: String
var rarity: Dictionary
var role: Dictionary
var sprite_key: String
var base_stats: Dictionary
var current_stats: Dictionary
var passive: Dictionary
var active_ability: Dictionary
var personality: String
var flavor_text: String
var lore: String
var relationships: Array = []

# Track cooldowns for active abilities
var active_cooldown_timer: Timer

# ===================
# Initialization
# ===================
func _init(companion_data: Dictionary) -> void:
	id = companion_data.get("id", "")
	name = companion_data.get("name", "Unknown")
	rarity = companion_data.get("rarity", {})
	role = companion_data.get("role", {})
	sprite_key = companion_data.get("sprite_key", "")
	base_stats = companion_data.get("base_stats", {})
	current_stats = base_stats.duplicate()  # runtime stats can change
	passive = companion_data.get("passive", {})
	active_ability = companion_data.get("active_ability", {})
	personality = companion_data.get("personality", "")
	flavor_text = companion_data.get("flavor_text", "")
	lore = companion_data.get("lore", "")
	relationships = companion_data.get("relationships", [])
	
	# Set up timer for active ability cooldown
	active_cooldown_timer = Timer.new()
	active_cooldown_timer.wait_time = active_ability.get("cooldown", 0)
	active_cooldown_timer.one_shot = true
	add_child(active_cooldown_timer)

# ===================
# Stats & Effects
# ===================
func take_damage(amount: float) -> void:
	current_stats.health = max(current_stats.health - amount, 0)

func heal(amount: float) -> void:
	current_stats.health = min(current_stats.health + amount, base_stats.health)

func is_alive() -> bool:
	return current_stats.health > 0

# ===================
# Active Ability
# ===================
func can_use_active() -> bool:
	return active_ability != null and not active_cooldown_timer.is_stopped()

func use_active_ability() -> void:
	if not active_ability or active_cooldown_timer.is_stopped():
		return
	print("%s uses %s!" % [name, active_ability.get("name", "Unknown Ability")])
	active_cooldown_timer.start()
	# TODO: Implement actual effect logic (damage, buffs, etc.)

# ===================
# Utility
# ===================
func get_relationship_bonuses() -> Dictionary:
	# Example: return bonus stats from relationships
	var bonuses := {}
	for rel in relationships:
		# This is placeholder logic, can integrate with companion_manager
		bonuses[rel] = {"damage": 5}  # e.g., +5 damage if this companion is present
	return bonuses
