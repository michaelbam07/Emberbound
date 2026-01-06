extends RefCounted
class_name PitySystem

# -------------------------------------------------
# Pity Rule Definition
# -------------------------------------------------
class PityRule:
	var rarity: String
	var hard_pity: int
	var soft_pity_start: int
	var soft_pity_bonus: float

	func _init(_rarity: String, _hard: int, _soft_start: int, _soft_bonus: float):
		rarity = _rarity
		hard_pity = _hard
		soft_pity_start = _soft_start
		soft_pity_bonus = _soft_bonus

# -------------------------------------------------
# Banner Rules
# -------------------------------------------------
var banner_rules: Dictionary = {} # banner_id -> Array[PityRule]

# -------------------------------------------------
# Registration (called at startup)
# -------------------------------------------------
func register_banner(banner_id: String, rules: Array) -> void:
	banner_rules[banner_id] = rules

# -------------------------------------------------
# Adjust base rates based on pity counters
# -------------------------------------------------
func apply_pity(banner_id: String, pity_state: Dictionary, base_table: Dictionary) -> Dictionary:
	if not banner_rules.has(banner_id):
		return base_table.duplicate(true)

	var adjusted := base_table.duplicate(true)

	for rule: PityRule in banner_rules[banner_id]:
		var count: int = pity_state.get(rule.rarity, 0)

		# ---------------- Hard pity ----------------
		if count >= rule.hard_pity:
			return _force_min_rarity(adjusted, rule.rarity)

		# ---------------- Soft pity ----------------
		if count >= rule.soft_pity_start:
			var steps: int = count - rule.soft_pity_start + 1
			var boost: float = 1.0 + (steps * rule.soft_pity_bonus)
			adjusted = _boost_rarity(adjusted, rule.rarity, boost)

	return _normalize(adjusted)

# -------------------------------------------------
# Pick a rarity based on adjusted table
# -------------------------------------------------
func get_rarity_with_pity(base_table: Dictionary, pity_state: Dictionary, banner_id: String) -> String:
	var adjusted := apply_pity(banner_id, pity_state, base_table)

	var roll := randf()  # 0.0 - 1.0
	var cumulative := 0.0
	for rarity in ["common", "uncommon", "rare", "epic", "legendary", "mythic"]:
		if not adjusted.has(rarity):
			continue
		cumulative += adjusted[rarity]
		if roll <= cumulative:
			return rarity
	return "common"

# -------------------------------------------------
# Helpers for adjusting probabilities
# -------------------------------------------------
func _force_min_rarity(table: Dictionary, min_rarity: String) -> Dictionary:
	var out := {}
	for r in table.keys():
		out[r] = table[r] if _rank(r) >= _rank(min_rarity) else 0.0
	return _normalize(out)

func _boost_rarity(table: Dictionary, rarity: String, boost: float) -> Dictionary:
	var out := table.duplicate(true)
	if out.has(rarity):
		out[rarity] *= boost
	return out

func _normalize(table: Dictionary) -> Dictionary:
	var total := 0.0
	for v in table.values():
		total += v
	if total <= 0.0:
		return table
	var out := {}
	for k in table.keys():
		out[k] = table[k] / total
	return out

# -------------------------------------------------
# Rarity Ranking
# -------------------------------------------------
func _rank(rarity: String) -> int:
	match rarity.to_lower():
		"common": return 1
		"uncommon": return 2
		"rare": return 3
		"epic": return 4
		"legendary": return 5
		"mythic": return 6
		_: return 0
