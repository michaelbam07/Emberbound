# scripts/managers/PlayerStats.gd
extends RefCounted
class_name PlayerStats

# =====================
# Signals (For Achievement UI, Summary Screens)
# =====================
signal pull_recorded(rarity: String, total_pulls: int)
signal milestone_reached(milestone: String, value: int)
signal rarity_milestone(rarity: String, count: int)

# =====================
# Dependencies
# =====================
var player_data: PlayerData

# =====================
# Lifetime Tracking
# =====================
var total_pulls: int = 0
var pulls_by_rarity: Dictionary = {}  # "mythic": 3, "legendary": 15, etc.
var total_dust_earned: int = 0
var highest_pity_hit: int = 0
var total_free_pulls: int = 0

# Milestones (feel free to expand)
const MILESTONES := {
	"first_pull": 1,
	"addict": 100,
	"veteran": 500,
	"legend": 1000
}

# =====================
# Initialization
# =====================
func _init(_player_data: PlayerData) -> void:
	player_data = _player_data
	_initialize_rarity_tracking()

func _initialize_rarity_tracking() -> void:
	var rarities = ["common", "uncommon", "rare", "epic", "legendary", "mythic"]
	for r in rarities:
		pulls_by_rarity[r] = 0

# =====================
# Core Tracking
# =====================
func record_pull(rarity: String, banner_id: String, was_free: bool = false) -> void:
	total_pulls += 1
	pulls_by_rarity[rarity] = pulls_by_rarity.get(rarity, 0) + 1
	
	if was_free:
		total_free_pulls += 1
	
	# Check milestones
	_check_total_pull_milestones()
	_check_rarity_milestones(rarity)
	
	pull_recorded.emit(rarity, total_pulls)
	
	# Update pity in PlayerData
	player_data.increment_pity(banner_id)

func record_pity_hit(pity_count: int, rarity: String) -> void:
	if pity_count > highest_pity_hit:
		highest_pity_hit = pity_count
		milestone_reached.emit("highest_pity", pity_count)

func record_dust_earned(amount: int) -> void:
	total_dust_earned += amount

# =====================
# Milestone Checks
# =====================
func _check_total_pull_milestones() -> void:
	for milestone in MILESTONES.keys():
		if total_pulls == MILESTONES[milestone]:
			milestone_reached.emit(milestone, total_pulls)

func _check_rarity_milestones(rarity: String) -> void:
	var count = pulls_by_rarity[rarity]
	var milestones = [1, 5, 10, 25, 50, 100]
	for m in milestones:
		if count == m:
			rarity_milestone.emit(rarity, m)

# =====================
# Query Helpers
# =====================
func get_pull_rate(rarity: String) -> float:
	if total_pulls == 0:
		return 0.0
	return float(pulls_by_rarity.get(rarity, 0)) / total_pulls

func get_total_high_rarity_pulls() -> int:
	return pulls_by_rarity.get("mythic", 0) + pulls_by_rarity.get("legendary", 0) + pulls_by_rarity.get("epic", 0)

func get_favorite_rarity() -> String:
	var max_count = 0
	var favorite = "common"
	for r in pulls_by_rarity.keys():
		if pulls_by_rarity[r] > max_count:
			max_count = pulls_by_rarity[r]
			favorite = r
	return favorite

# =====================
# Debug / Summary
# =====================
func print_summary() -> void:
	print("=== Emberbound Gacha Journey ===")
	print("Total Pulls: %d" % total_pulls)
	print("Free Pulls: %d" % total_free_pulls)
	print("Dust Earned: %d" % total_dust_earned)
	print("Highest Pity Hit: %d" % highest_pity_hit)
	print("")
	print("By Rarity:")
	for r in pulls_by_rarity.keys():
		var rate = get_pull_rate(r) * 100
		print("  %s: %d (%.2f%%)" % [r.capitalize(), pulls_by_rarity[r], rate])
	print("Favorite Rarity: %s" % get_favorite_rarity().capitalize())