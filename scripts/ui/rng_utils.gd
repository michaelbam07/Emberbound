# utils/RNGUtils.gd
extends Node
class_name RNGUtils

# =====================
# Shared RNG (Seedable)
# =====================
static var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

static func _init() -> void:
	_rng.randomize()  # Default random seed

static func set_seed(seed_value: int) -> void:
	_rng.seed = seed_value

static func randomize_seed() -> void:
	_rng.randomize()

# =====================
# Basic Random
# =====================
static func chance(percent: float) -> bool:
	# 0.0 → 100.0
	return _rng.randf_range(0.0, 100.0) <= clampf(percent, 0.0, 100.0)

static func randi_range(min_val: int, max_val: int) -> int:
	return _rng.randi_range(min_val, max_val)

static func randf_range(min_val: float, max_val: float) -> float:
	return _rng.randf_range(min_val, max_val)

static func coin_flip() -> bool:
	return _rng.randi() % 2 == 0

# =====================
# Array & Collection
# =====================
static func pick_random(array: Array):
	if array.is_empty():
		return null
	return array[_rng.randi() % array.size()]

static func shuffle_array(array: Array) -> Array:
	var shuffled = array.duplicate()
	shuffled.shuffle()
	return shuffled

# =====================
# Weighted Choice (Safe & Normalized)
# =====================
static func weighted_choice(weights: Dictionary) -> String:
	var total: float = 0.0
	for w in weights.values():
		total += float(w)
	
	if total <= 0.0:
		push_warning("RNGUtils: Weighted choice with zero total weight")
		return weights.keys().front() if not weights.is_empty() else ""
	
	var roll: float = _rng.randf() * total
	var accum: float = 0.0
	
	for key in weights.keys():
		accum += float(weights[key])
		if roll <= accum:
			return key
	
	return weights.keys().back()  # Fallback

# =====================
# Soft Pity Roll (Normalized!)
# =====================
static func roll_with_soft_pity(
	base_rates: Dictionary,
	pity_counters: Dictionary,
	pity_rules: Dictionary
) -> String:
	var adjusted_rates := base_rates.duplicate()
	
	for rarity in pity_rules.keys():
		var rule = pity_rules[rarity]
		var count: int = pity_counters.get(rarity, 0)
		
		if count >= rule.soft_start:
			var pulls_into_soft := count - rule.soft_start + 1
			var bonus := pulls_into_soft * rule.soft_bonus
			adjusted_rates[rarity] = adjusted_rates.get(rarity, 0.0) + bonus
	
	# Normalize to prevent >100%
	var total: float = 0.0
	for v in adjusted_rates.values():
		total += v
	if total > 0.0:
		for k in adjusted_rates.keys():
			adjusted_rates[k] /= total
	
	return weighted_choice(adjusted_rates)

# =====================
# Featured Rate-Up Helper
# =====================
static func roll_featured(
	normal_pool: Array[String],
	featured_pool: Array[String],
	featured_chance: float = 50.0
) -> String:
	if featured_pool.is_empty():
		return pick_random(normal_pool)
	
	if chance(featured_chance):
		return pick_random(featured_pool)
	else:
		return pick_random(normal_pool)

# =====================
# Rarity Helpers (With Your Emberbound Rarities)
# =====================
static func get_rarity_drop_rate(rarity: String) -> float:
	match rarity.to_lower():
		"common": return 50.0
		"uncommon": return 30.0
		"rare": return 13.0
		"epic": return 5.5
		"legendary": return 1.4
		"mythic": return 0.1
		_: return 0.0