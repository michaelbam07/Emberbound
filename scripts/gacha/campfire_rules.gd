# core/dialogue/campfire_rules.gd
extends RefCounted
class_name CampfireRules

# =====================
# Design Tunables
# =====================
const MIN_PARTY_SIZE: int = 2
const MAX_PARTY_SIZE: int = 4

const MAX_BANTER_PER_CAMP: int = 3          # Allow a few lines per rest
const PAIR_COOLDOWN_CAMPS: int = 2          # Camps before same duo can talk again

const BASE_WEIGHT: int = 10
const RELATIONSHIP_BONUS: int = 20
const CONTEXT_BONUS: int = 30
const UNUSED_BONUS: int = 15                # Favor fresh dialogue

# =====================
# Runtime State (Per Run/Session)
# =====================
var camp_counter: int = 0
var banter_this_camp: int = 0

# "companion_a|companion_b" → last camp index used
var last_used_pairs: Dictionary = {}

# "dialogue_id" → last camp index used (for global cooldowns)
var used_dialogue_this_run: Dictionary = {}

# =====================
# Public Entry Point
# =====================
func start_new_camp() -> void:
	camp_counter += 1
	banter_this_camp = 0

func can_trigger_banter(party: Array, context: String = "") -> bool:
	if party.size() < MIN_PARTY_SIZE or party.size() > MAX_PARTY_SIZE:
		return false
	
	if banter_this_camp >= MAX_BANTER_PER_CAMP:
		return false
	
	return true

# =====================
# Participant Selection
# =====================
func get_valid_speakers(party: Array) -> Array[String]:
	var valid: Array[String] = []
	for companion in party:
		if companion and companion.can_speak():  # is_exhausted, silenced, etc.
			valid.append(companion.id)
	return valid

# =====================
# Pair Management
# =====================
func is_pair_on_cooldown(a_id: String, b_id: String) -> bool:
	var key = _pair_key(a_id, b_id)
	if not last_used_pairs.has(key):
		return false
	return (camp_counter - last_used_pairs[key]) < PAIR_COOLDOWN_CAMPS

func mark_pair_used(a_id: String, b_id: String) -> void:
	last_used_pairs[_pair_key(a_id, b_id)] = camp_counter

# =====================
# Dialogue Scoring (Weighted Random)
# =====================
func score_dialogue_entry(
	entry: Dictionary,
	speakers: Array[String],
	player_data,
	context: String = ""
) -> int:
	var score: int = entry.get("weight", BASE_WEIGHT)
	
	# Must have at least one valid speaker
	var entry_speakers: Array = entry.get("speakers", [])
	if entry_speakers.is_empty():
		entry_speakers = [entry.get("speaker", "")]
	
	var valid_count = 0
	for sp in entry_speakers:
		if sp in speakers:
			valid_count += 1
	if valid_count == 0:
		return -999  # Invalid — can't play
	
	score += valid_count * 5  # Bonus for more participants
	
	# Relationship requirements
	if entry.has("requires_relationship"):
		for rel in entry["requires_relationship"]:
			if player_data.has_relationship(rel[0], rel[1]):
				score += RELATIONSHIP_BONUS
	
	# Context match
	if entry.get("context", "") == context:
		score += CONTEXT_BONUS
	
	# Freshness bonus
	var dialogue_id = entry.get("id", "")
	if dialogue_id != "" and used_dialogue_this_run.has(dialogue_id):
		var camps_since = camp_counter - used_dialogue_this_run[dialogue_id]
		score += min(camps_since * 5, UNUSED_BONUS * 3)
	
	# Priority flag
	if entry.get("priority", false):
		score += 50
	
	return score

func mark_dialogue_used(dialogue_id: String) -> void:
	if dialogue_id != "":
		used_dialogue_this_run[dialogue_id] = camp_counter
	banter_this_camp += 1

# =====================
# Helper
# =====================
func _pair_key(a: String, b: String) -> String:
	return a < b ? "%s|%s" % [a, b] : "%s|%s" % [b, a]