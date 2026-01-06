# core/instances/CompanionInstance.gd
@tool
extends GachaItem
class_name CompanionInstance

# =====================
# Visual & Identity
# =====================
@export var role: String = "support"
@export var personality: String = "loyal"
@export_multiline var flavor_text: String = ""
@export_multiline var lore: String = ""

@export var portrait: Texture2D
@export var campfire_sprite: Texture2D
@export var battle_sprite: AnimatedSprite2D  # Or SpriteFrames

# =====================
# Abilities
# =====================
@export var passive: Dictionary = {}
@export var active_ability: Dictionary = {}

# Runtime cooldown
var active_cooldown_timer: Timer

# =====================
# Combat Stats
# =====================
@export var base_stats: Dictionary = {
	"health": 100,
	"damage": 20,
	"attack_speed": 1.0,
	"move_speed": 150
}

var current_stats: Dictionary

# =====================
# Equipment & Relationships
# =====================
@export var equipped_weapon: WeaponInstance = null
@export var relationships: Array[String] = []  # Companion IDs

# =====================
# Initialization
# =====================
func _init() -> void:
	super._init()
	current_stats = base_stats.duplicate()
	
	# Cooldown timer for active ability
	active_cooldown_timer = Timer.new()
	active_cooldown_timer.one_shot = true
	add_child(active_cooldown_timer)
	if active_ability.has("cooldown"):
		active_cooldown_timer.wait_time = active_ability.cooldown

# =====================
# Combat
# =====================
func take_damage(amount: float) -> void:
	var final_damage = amount
	if equipped_weapon and equipped_weapon.has_method("modify_incoming_damage"):
		final_damage = equipped_weapon.modify_incoming_damage(final_damage)
	
	current_stats.health = max(current_stats.health - final_damage, 0)
	if current_stats.health <= 0:
		die()

func heal(amount: float) -> void:
	current_stats.health = min(current_stats.health + amount, get_max_health())

func get_max_health() -> int:
	return base_stats.health + (level - 1) * 20  # Example scaling

func is_alive() -> bool:
	return current_stats.health > 0

func die() -> void:
	print("%s has fallen..." % name)
	# Trigger death animation, banter, etc.

# =====================
# Active Ability
# =====================
func can_use_active() -> bool:
	return active_ability != {} and active_cooldown_timer.is_stopped()

func use_active_ability(target = null) -> void:
	if not can_use_active():
		return
	
	print("%s uses %s!" % [name, active_ability.get("name", "Ability")])
	active_cooldown_timer.start()
	
	# TODO: Real effect logic — damage, heal, buff, etc.
	# Example: if active_ability.type == "damage":
	#     target.take_damage(active_ability.power * level)

# =====================
# Equipment
# =====================
func equip_weapon(weapon: WeaponInstance) -> void:
	if equipped_weapon == weapon:
		return
	if equipped_weapon:
		unequip_weapon()
	equipped_weapon = weapon
	if weapon:
		weapon.owner = self
		recalculate_stats()

func unequip_weapon() -> void:
	if equipped_weapon:
		equipped_weapon.owner = null
		equipped_weapon = null
		recalculate_stats()

func recalculate_stats() -> void:
	# Reapply weapon bonuses, level scaling, bond bonuses, etc.
	pass

# =====================
# Bond & Relationships
# =====================
func gain_bond(amount: int = 20) -> void:
	super.gain_bond(amount)
	# Bond can give small stat boosts
	recalculate_stats()

func add_relationship(partner_id: String) -> void:
	if partner_id in relationships:
		return
	relationships.append(partner_id)
	# Trigger special banter next campfire
	BanterManager.trigger_relationship_line(self.id, partner_id)

# =====================
# Display
# =====================
func get_display_name() -> String:
	var suffix = " (Lv.%d)" % level
	if bond >= get_bond_to_next_level() * 0.7:
		suffix += " ♡"
	return name + suffix

# =====================
# Editor Warnings
# =====================
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if portrait == null:
		warnings.append("Add a portrait — companions need faces!")
	if passive.is_empty() and active_ability.is_empty():
		warnings.append("Give them at least one ability!")
	return warnings