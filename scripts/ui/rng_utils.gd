extends Node
class_name RNGUtils

# Shared RNG instance
static var _rng := RandomNumberGenerator.new()

# -------------------------------------------------
# Initialization
# -------------------------------------------------
static func init(seed: int = -1) -> void:
	if seed == -1:
		_rng.randomize()
	else:
		_rng.seed = seed

# -------------------------------------------------
# Basic helpers
# -------------------------------------------------
static func chance(percent: float) -> bool:
	# percent: 0.0 → 100.0
	return _rng.randf_range(0.0, 100.0) <= percent

static func roll_range(min_value: int, max_value: int) -> int:
	return _rng.randi_range(min_value, max_value)

static func roll_float(min_value: float, max_value: float) -> float:
	return _rng.randf_range(min_value, max_value)

# -------------------------------------------------
# Weighted choice
# weights = { "5-star": 0.6, "4-star": 5.1, "3-star": 94.3 }
# -------------------------------------------------
static func weighted_choice(weights: Dictionary) -> String:
	var total := 0.0
	for value in weights.values():
		total += float(value)

	var roll := _rng.randf() * total
	var cumulative := 0.0

	for key in weights.keys():
		cumulative += float(weights[key])
		if roll <= cumulative:
			return key

	push_error("RNGUtils.weighted_choice failed — check weights")
	return weights.keys()[0]

# -------------------------------------------------
# Soft pity roll
# base_rates: Dictionary (rarity → base %)
# pity_count: pulls since last high rarity
# rules: Dictionary (rarity → {start, bonus})
# -------------------------------------------------
static func roll_with_soft_pity(
	base_rates: Dictionary,
	pity_count: int,
	rules: Dictionary
) -> String:
	var modified_rates := base_rates.duplicate(true)

	for rarity in rules.keys():
		var rule := rules[rarity]
		if pity_count >= rule.soft_start:
			var extra := (pity_count - rule.soft_start + 1) * rule.soft_bonus
			modified_rates[rarity] += extra

	return weighted_choice(modified_rates)

# -------------------------------------------------
# Pick random item from array
# -------------------------------------------------
static func pick_random(array: Array):
	if array.is_empty():
		return null
	return array[_rng.randi() % array.size()]
