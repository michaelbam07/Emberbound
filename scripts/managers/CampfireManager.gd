# scripts/managers/CampfireManager.gd
extends Node
class_name CampfireManager

# =====================
# Dependencies
# =====================
@export var banter_manager: BanterManager
@export var campfire_ui: CampfireUI
@export var companion_manager: CompanionManager
@export var gacha_manager: GachaManager
@export var audio_manager: AudioManager
@export var campfire_rules: CampfireRules

# =====================
# Runtime
# =====================
var current_party: Array[CompanionInstance] = []

# =====================
# Public Entry
# =====================
func start_campfire(party_members: Array[CompanionInstance]) -> void:
	current_party = party_members.duplicate()
	
	# Reset campfire state
	campfire_rules.start_new_camp()
	
	# UI + Audio
	campfire_ui.show()
	campfire_ui.refresh_party_display(current_party)
	audio_manager.play_campfire_ambient()
	
	# Healing (full restore)
	for companion in current_party:
		companion.heal(companion.get_max_health())
	
	# Bond gain (the heart of campfire)
	_trigger_bond_growth()
	
	# Banter (the soul)
	_trigger_banter_sequence()
	
	# Bonus pull chance or dust reward
	_trigger_bonus_rewards()

func end_campfire() -> void:
	campfire_ui.hide()
	audio_manager.stop_music(2.0)  # Gentle fade out
	current_party.clear()

# =====================
# Bond & Growth
# =====================
func _trigger_bond_growth() -> void:
	var base_bond = 20
	for companion in current_party:
		var bonus = 0
		# Bonus for relationships
		for rel_id in companion.relationships:
			if current_party.any(func(c): return c.id == rel_id):
				bonus += 15
		companion.gain_bond(base_bond + bonus)
	
	campfire_ui.play_bond_animation()

# =====================
# Banter Sequence
# =====================
func _trigger_banter_sequence() -> void:
	var speakers = current_party.map(func(c): return c.id)
	
	while campfire_rules.can_trigger_banter(current_party):
		var line = banter_manager.get_random_banter(speakers, "campfire_idle")
		if line.is_empty():
			break
		
		campfire_ui.play_banter_line(line)
		await campfire_ui.banter_finished  # Wait for player to advance
		
		campfire_rules.banter_this_camp += 1

# =====================
# Bonus Rewards
# =====================
func _trigger_bonus_rewards() -> void:
	# Example: 1 in 5 chance for free pull based on party size/bond
	if randf() < (0.1 + current_party.size() * 0.05):
		campfire_ui.show_bonus_pull_button()
	else:
		# Always give some dust
		var dust = 50 + current_party.size() * 20
		PlayerData.add_currency("dust", dust)
		campfire_ui.show_dust_reward(dust)

func trigger_bonus_pull() -> void:
	audio_manager.play_campfire_roar()
	campfire_ui.play_big_flame_animation()
	gacha_manager.perform_free_pull()  # Free pull from active banner
	campfire_ui.show_message("The flames grant a bonus pull!")

# =====================
# Optional: Relationship Unlocks
# =====================
func _check_relationship_unlocks() -> void:
	for c1 in current_party:
		for c2 in current_party:
			if c1.id == c2.id:
				continue
			if not c1.has_relationship_with(c2.id):
				# Simple chance based on shared campfire time
				if randf() < 0.3:
					c1.add_relationship(c2.id)
					c2.add_relationship(c1.id)
					campfire_ui.show_relationship_unlock(c1, c2)