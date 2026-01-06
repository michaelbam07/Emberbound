extends Node
class_name PlayerData

static var instance: PlayerData = null

func _ready():
    instance = self

static func get_instance() -> PlayerData:
    return instance

# -------------------------------------------------
# Signals (UI, systems listen to these)
# -------------------------------------------------
signal currency_changed(type: String, new_amount: int)
signal companion_added(companion)
signal weapon_added(weapon)
signal pity_updated(banner_id: String, pity: int)
signal data_loaded()
signal data_saved()

# -------------------------------------------------
# Player Currencies
# -------------------------------------------------
var currencies := {
	"gold": 0,
	"gems": 0,
	"tickets": 0
}

# -------------------------------------------------
# Player Inventory
# -------------------------------------------------
var companions: Array = []   # CompanionItem instances
var weapons: Array = []      # WeaponItem instances

# -------------------------------------------------
# Pity Counters (per banner)
# banner_id -> pity count
# -------------------------------------------------
var pity_counters := {}

# -------------------------------------------------
# Player Progression
# -------------------------------------------------
var player_level: int = 1
var experience: int = 0

# -------------------------------------------------
# Equipped Items
# -------------------------------------------------
var equipped_companion_id: String = ""
var equipped_weapon_id: String = ""

# -------------------------------------------------
# Save Settings
# -------------------------------------------------
const SAVE_PATH := "user://player_data.save"
const SAVE_VERSION := 1

# -------------------------------------------------
# Currency API
# -------------------------------------------------
func add_currency(type: String, amount: int) -> void:
	if not currencies.has(type):
		currencies[type] = 0
	currencies[type] += amount
	emit_signal("currency_changed", type, currencies[type])

func spend_currency(type: String, amount: int) -> bool:
	if currencies.get(type, 0) < amount:
		return false
	currencies[type] -= amount
	emit_signal("currency_changed", type, currencies[type])
	return true

func get_currency(type: String) -> int:
	return currencies.get(type, 0)

# -------------------------------------------------
# Inventory API
# -------------------------------------------------
func add_companion(companion) -> void:
	companions.append(companion)
	emit_signal("companion_added", companion)

func add_weapon(weapon) -> void:
	weapons.append(weapon)
	emit_signal("weapon_added", weapon)

func get_companions_by_rarity(rarity: String) -> Array:
	var result = []
	for c in companions:
		if c.rarity == rarity:
			result.append(c)
	return result

func get_weapons_by_type(type: String) -> Array:
	var result = []
	for w in weapons:
		if w.weapon_type == type:
			result.append(w)
	return result

# -------------------------------------------------
# Pity System API
# -------------------------------------------------
func get_pity(banner_id: String) -> int:
	return pity_counters.get(banner_id, 0)

func increment_pity(banner_id: String) -> int:
	var value = pity_counters.get(banner_id, 0) + 1
	pity_counters[banner_id] = value
	emit_signal("pity_updated", banner_id, value)
	return value

func reset_pity(banner_id: String) -> void:
	pity_counters[banner_id] = 0
	emit_signal("pity_updated", banner_id, 0)

# -------------------------------------------------
# Experience & Leveling
# -------------------------------------------------
func add_experience(amount: int) -> void:
	experience += amount
	while experience >= required_exp_for_next_level():
		experience -= required_exp_for_next_level()
		player_level += 1

func required_exp_for_next_level() -> int:
	return 100 + (player_level * 25)

# -------------------------------------------------
# Save / Load
# -------------------------------------------------
func save_data() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("Failed to save PlayerData")
		return

	var data = {
		"version": SAVE_VERSION,
		"currencies": currencies,
		"pity": pity_counters,
		"level": player_level,
		"exp": experience,
		"companions": companions.map(func(c): return c.to_dict()),
		"weapons": weapons.map(func(w): return w.to_dict())
	}

	file.store_string(JSON.stringify(data))
	file.close()
	emit_signal("data_saved")

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to load PlayerData")
		return

	var json_text = file.get_as_text()
	file.close()

	var result = JSON.parse(json_text)
	if result.error != OK:
		push_error("Invalid save data")
		return

	var data = result.result
	if data.get("version", 0) != SAVE_VERSION:
		push_warning("Save version mismatch")

	currencies = data.get("currencies", currencies)
	pity_counters = data.get("pity", {})
	player_level = data.get("level", 1)
	experience = data.get("exp", 0)

	companions.clear()
	for c_data in data.get("companions", []):
		var c = CompanionItem.new()
		c.from_dict(c_data)
		companions.append(c)

	weapons.clear()
	for w_data in data.get("weapons", []):
		var w = WeaponItem.new()
		w.from_dict(w_data)
		weapons.append(w)

	emit_signal("data_loaded")

# -------------------------------------------------
# Debug / Testing Helpers
# -------------------------------------------------
func reset_all() -> void:
	currencies = {"gold": 0, "gems": 0, "tickets": 0}
	companions.clear()
	weapons.clear()
	pity_counters.clear()
	player_level = 1
	experience = 0
	emit_signal("data_loaded")

func equip_companion(id: String) -> void:
	equipped_companion_id = id
	save_data()

func equip_weapon(id: String) -> void:
	equipped_weapon_id = id
	save_data()
func get_equipped_companion() -> CompanionItem:
    for companion in companions:
        if companion.id == equipped_companion_id:
            return companion
    return null