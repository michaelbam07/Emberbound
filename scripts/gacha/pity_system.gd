# core/gacha/PitySystem.gd
extends RefCounted
class_name PitySystem

# =============================================
# Inner Rule Class (Pure Beauty)
# =============================================
class PityRule extends RefCounted:
	var rarity: String
	var hard_pity: int
	var soft_pity_start: int
	var soft_pity_bonus: float  # Bonus per pull after soft start
	
	func _init(_rarity: String, _hard: int, _soft_start: int, _soft_bonus: float) -> void:
		rarity = _rarity
		hard_pity = _hard
		soft_pity_start = _soft_start
		soft_pity_bonus = _soft_bonus

# =============================================
# Banner-Specific Rules
# =============================================
var banner_rules: Dictionary = {}  # banner_id → Array[PityRule]

# =============================================
# Registration (Called from BannerBase or startup)
# =============================================
func register_banner(banner_id: String, rules: Array[PityRule]) -> void:
	banner_rules[banner_id] = rules

# =============================================
# Main Entry Point — Returns Adjusted Rates
# =============================================
func get_adjusted_rates(banner_id: String, pity_counters: Dictionary, base_rates: Dictionary) -> Dictionary:
	if not banner_rules.has(banner_id):
		return base_rates.duplicate()
	
	var rules: Array[PityRule] = banner_rules[banner_id]
	var adjusted := base_rates.duplicate()
	
	for rule in rules:
		var count: int = pity_counters.get(rule.rarity, 0)
		
		# HARD PITY — Force guarantee
		if count >= rule.hard_pity:
			return _force_minimum_rarity(adjusted, rule.rarity)
		
		# SOFT PITY — Exponential ramp-up
		if count >= rule.soft_pity_start:
			var pulls_into_soft := count - rule.soft_pity_start + 1
			var multiplier := 1.0 + (pulls_into_soft * rule.soft_pity_bonus)
			adjusted[rule.rarity] *= multiplier
	
	return _normalize_rates(adjusted)

# =============================================
# Roll with Pity (Convenience Wrapper)
# =============================================
func roll_rarity(banner_id: String, pity_counters: Dictionary, base_rates: Dictionary) -> String:
	var adjusted = get_adjusted_rates(banner_id, pity_counters, base_rates)
	
	var roll := randf()
	var accum := 0.0
	for rarity in adjusted.keys():
		accum += adjusted[rarity]
		if roll <= accum:
			return rarity
	
	return "common"  # Fallback (should never hit)

# =============================================
# Private Helpers
# =============================================
func _force_minimum_rarity(table: Dictionary, min_rarity: String) -> Dictionary:
	var result := {}
	var min_rank := _rarity_rank(min_rarity)
	
	for r in table.keys():
		result[r] = table[r] if _rarity_rank(r) >= min_rank else 0.0
	
	return _normalize_rates(result)

func _normalize_rates(table: Dictionary) -> Dictionary:
	var total := 0.0
	for v in table.values():
		total += v
	
	if total <= 0.0:
		return table
	
	var normalized := {}
	for k in table.keys():
		normalized[k] = table[k] / total
	
	return normalized

func _rarity_rank(rarity: String) -> int:
	match rarity.to_lower():
		"common": return 1
		"uncommon": return 2
		"rare": return 3
		"epic": return 4
		"legendary": return 5
		"mythic": return 6
		_: return 0