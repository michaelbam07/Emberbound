# res://core/dialogue/campfire_rules.gd
extends RefCounted
class_name CampfireRules

# -------------------------------------------------
# Tunables (Design knobs)
# -------------------------------------------------
const MIN_PARTY_SIZE := 2
const MAX_PARTY_SIZE := 4

const MAX_BANTER_PER_CAMP := 1        # Prevents spam
const COOLDOWN_TURNS := 1             # Camps before same pair talks again

# -------------------------------------------------
# Runtime State (session-based)
# -------------------------------------------------
var last_used_pairs: Dictionary = {}  # "samira|xiao_yang" : turn_index
var camp_counter := 0

# -------------------------------------------------
# Entry Point
# -------------------------------------------------
func can_trigger_banter(
	party: Array,          # Array[CompanionInstance]
	context: String,
	player_data
) -> bool:
	# Party size check
	if party.size() < MIN_PARTY_SIZE or party.size() > MAX_PARTY_SIZE:
		return false

	# Optional story gating
	if context == "post_boss" and not player_data.flags.get("boss_defeated", false):
		return false

	return true

# -------------------------------------------------
# Participant Filtering
# -------------------------------------------------
func filter_valid_participants(party: Array) -> Array:
	var valid := []
	for c in party:
		if not c.is_exhausted and not c.is_silenced:
			valid.append(c)
	return valid

# -------------------------------------------------
# Pair Cooldown Logic
# -------------------------------------------------
func is_pair_on_cooldown(a_id: String, b_id: String) -> bool:
	var key := _pair_key(a_id, b_id)
	if not last_used_pairs.has(key):
		return false
	return (camp_counter - last_used_pairs[key]) < COOLDOWN_TURNS

func mark_pair_used(a_id: String, b_id: String) -> void:
	last_used_pairs[_pair_key(a_id, b_id)] = camp_counter

# -------------------------------------------------
# Camp Lifecycle
# -------------------------------------------------
func start_new_camp() -> void:
	camp_counter += 1

# -------------------------------------------------
# Banter Scoring (Optional but powerful)
# -------------------------------------------------
func score_entry(entry: Dictionary, party: Array, player_data) -> int:
	var score := 0

	# Favor unused dialogue
	score += entry.get("weight", 1)

	# Relationship bias
	if entry.has("requires"):
		for id in entry["requires"]:
			if player_data.has_relationship(id):
				score += 2

	# Context bonus
	if entry.get("context", "") == "post_boss":
		score += 3

	return score

# -------------------------------------------------
# Helpers
# -------------------------------------------------
func _pair_key(a: String, b: String) -> String:
	return a < b ? "%s|%s" % [a, b] : "%s|%s" % [b, a]
