const RARITY = {
	COMMON = {id = "common", stars = 1, color = Color.GRAY, drop_rate = 0.50, dust_value = 5},
	UNCOMMON = {id = "uncommon", stars = 2, color = Color.GREEN, drop_rate = 0.30, dust_value = 10},
	RARE = {id = "rare", stars = 3, color = Color.BLUE, drop_rate = 0.13, dust_value = 25},
	EPIC = {id = "epic", stars = 4, color = Color.PURPLE, drop_rate = 0.055, dust_value = 50},
	LEGENDARY = {id = "legendary", stars = 5, color = Color.YELLOW, drop_rate = 0.014, dust_value = 100},
	MYTHIC = {id = "mythic", stars = 6, color = Color.ORANGE, drop_rate = 0.001, dust_value = 250}
}

const TYPES = {
	GUN = {id = "gun", description = "Standard projectile firearm"},
	MELEE = {id = "melee", description = "Close quarters combat weapon"},
	EXPLOSIVE = {id = "explosive", description = "Area of effect damage"},
	TRAP = {id = "trap", description = "Stationary tactical placement"},
	SNIPER = {id = "sniper", description = "Long range precision"}
}

# =====================
# Weapon Database (50)
# =====================
const WEAPONS = {
	# --- COMMON (12) ---
	"rusty_revolver": {
		"id": "rusty_revolver", "name": "Rusty Revolver", "type": TYPES.GUN, "rarity": RARITY.COMMON,
		"damage": 12, "fire_rate": 1.1, "range": 300, "passive": {"name": "Loose Hammer", "description": "5% chance to fire twice"},
		"active_ability": null, "flavor_text": "Better than a rock."
	},
	"kitchen_knife": {
		"id": "kitchen_knife", "name": "Kitchen Knife", "type": TYPES.MELEE, "rarity": RARITY.COMMON,
		"damage": 15, "fire_rate": 2.0, "range": 40, "passive": {"name": "Sharp", "description": "+2% Crit"},
		"active_ability": null, "flavor_text": "Meant for onions, works on bandits."
	},
	"wooden_club": {
		"id": "wooden_club", "name": "Wooden Club", "type": TYPES.MELEE, "rarity": RARITY.COMMON,
		"damage": 20, "fire_rate": 0.8, "range": 50, "passive": {"name": "Heavy", "description": "Knocks back enemies slightly"},
		"active_ability": null, "flavor_text": "Oink oink."
	},
	"scavenged_pipe": {
		"id": "scavenged_pipe", "name": "Scavenged Pipe", "type": TYPES.MELEE, "rarity": RARITY.COMMON,
		"damage": 18, "fire_rate": 1.0, "range": 55, "passive": null, "active_ability": null, "flavor_text": "Heavy plumbing."
	},
	"cracked_pistol": {
		"id": "cracked_pistol", "name": "Cracked Pistol", "type": TYPES.GUN, "rarity": RARITY.COMMON,
		"damage": 10, "fire_rate": 1.5, "range": 250, "passive": null, "active_ability": null, "flavor_text": "Watch the kick."
	},
	"makeshift_sling": {
		"id": "makeshift_sling", "name": "Makeshift Sling", "type": TYPES.GUN, "rarity": RARITY.COMMON,
		"damage": 8, "fire_rate": 1.2, "range": 350, "passive": {"name": "Silent", "description": "Less likely to alert others"},
		"active_ability": null, "flavor_text": "David's favorite."
	},
	"blunt_hatchet": {
		"id": "blunt_hatchet", "name": "Blunt Hatchet", "type": TYPES.MELEE, "rarity": RARITY.COMMON,
		"damage": 22, "fire_rate": 0.7, "range": 45, "passive": null, "active_ability": null, "flavor_text": "Needs sharpening."
	},
	"training_bow": {
		"id": "training_bow", "name": "Training Bow", "type": TYPES.SNIPER, "rarity": RARITY.COMMON,
		"damage": 18, "fire_rate": 0.6, "range": 500, "passive": null, "active_ability": null, "flavor_text": "Don't poke your eye out."
	},
	"iron_spike": {
		"id": "iron_spike", "name": "Iron Spike", "type": TYPES.TRAP, "rarity": RARITY.COMMON,
		"damage": 15, "fire_rate": 0.1, "range": 10, "passive": {"name": "Bleed", "description": "DOT for 2s"},
		"active_ability": null, "flavor_text": "Watch your step."
	},
	"tin_grenade": {
		"id": "tin_grenade", "name": "Tin Grenade", "type": TYPES.EXPLOSIVE, "rarity": RARITY.COMMON,
		"damage": 30, "fire_rate": 0.3, "range": 200, "passive": null, "active_ability": null, "flavor_text": "Loud pop."
	},
	"militia_rifle": {
		"id": "militia_rifle", "name": "Militia Rifle", "type": TYPES.GUN, "rarity": RARITY.COMMON,
		"damage": 25, "fire_rate": 0.5, "range": 450, "passive": null, "active_ability": null, "flavor_text": "Standard issue."
	},
	"lead_pellet_gun": {
		"id": "lead_pellet_gun", "name": "Lead Pellet Gun", "type": TYPES.GUN, "rarity": RARITY.COMMON,
		"damage": 5, "fire_rate": 3.0, "range": 200, "passive": {"name": "Stinging", "description": "Slows enemy by 2%"},
		"active_ability": null, "flavor_text": "More of a nuisance."
	},

	# --- UNCOMMON (10) ---
	"six_shooter": {
		"id": "six_shooter", "name": "Six Shooter", "type": TYPES.GUN, "rarity": RARITY.UNCOMMON,
		"damage": 25, "fire_rate": 1.2, "range": 400, "passive": {"name": "Quick Draw", "description": "First shot deals +10% damage"},
		"active_ability": null, "flavor_text": "Justice in six shots."
	},
	"tomahawk_tom": {
		"id": "tomahawk_tom", "name": "Tomahawk Tom", "type": TYPES.MELEE, "rarity": RARITY.UNCOMMON,
		"damage": 40, "fire_rate": 0.8, "range": 60, "passive": {"name": "Sharp Edge", "description": "Crits stun for 0.5s"},
		"active_ability": {"name": "Whirlwind", "description": "AOE spin", "cooldown": 15, "duration": 2}, "flavor_text": "Spin to win."
	},
	"hunting_crossbow": {
		"id": "hunting_crossbow", "name": "Hunting Crossbow", "type": TYPES.SNIPER, "rarity": RARITY.UNCOMMON,
		"damage": 55, "fire_rate": 0.4, "range": 600, "passive": {"name": "Piercing Bolt", "description": "Hits 2 targets"},
		"active_ability": null, "flavor_text": "Silent stalker."
	},
	"riot_shield": {
		"id": "riot_shield", "name": "Riot Shield", "type": TYPES.MELEE, "rarity": RARITY.UNCOMMON,
		"damage": 15, "fire_rate": 0.6, "range": 40, "passive": {"name": "Block", "description": "+10% Armor"},
		"active_ability": {"name": "Shield Bash", "description": "Heavy knockback", "cooldown": 8, "duration": 0}, "flavor_text": "Hold the line."
	},
	"double_barrel": {
		"id": "double_barrel", "name": "Double Barrel", "type": TYPES.GUN, "rarity": RARITY.UNCOMMON,
		"damage": 60, "fire_rate": 0.3, "range": 150, "passive": {"name": "Double Tap", "description": "Fires both shells at once"},
		"active_ability": null, "flavor_text": "Boom, boom."
	},
	"serrated_machete": {
		"id": "serrated_machete", "name": "Serrated Machete", "type": TYPES.MELEE, "rarity": RARITY.UNCOMMON,
		"damage": 35, "fire_rate": 1.1, "range": 55, "passive": {"name": "Lacerate", "description": "Increases damage over time"},
		"active_ability": null, "flavor_text": "Jagged and mean."
	},
	"bear_trap": {
		"id": "bear_trap", "name": "Bear Trap", "type": TYPES.TRAP, "rarity": RARITY.UNCOMMON,
		"damage": 50, "fire_rate": 0.1, "range": 20, "passive": {"name": "Root", "description": "Stops movement for 2s"},
		"active_ability": null, "flavor_text": "Snaps shut."
	},
	"carbine_9mm": {
		"id": "carbine_9mm", "name": "Carbine 9mm", "type": TYPES.GUN, "rarity": RARITY.UNCOMMON,
		"damage": 22, "fire_rate": 2.5, "range": 400, "passive": {"name": "Stable", "description": "Low recoil"},
		"active_ability": null, "flavor_text": "Reliable fire."
	},
	"fire_cracker": {
		"id": "fire_cracker", "name": "Fire Cracker", "type": TYPES.EXPLOSIVE, "rarity": RARITY.UNCOMMON,
		"damage": 20, "fire_rate": 0.8, "range": 250, "passive": {"name": "Panic", "description": "Small chance to scatter enemies"},
		"active_ability": null, "flavor_text": "Sparky."
	},
	"brass_knuckles": {
		"id": "brass_knuckles", "name": "Brass Knuckles", "type": TYPES.MELEE, "rarity": RARITY.UNCOMMON,
		"damage": 28, "fire_rate": 3.0, "range": 35, "passive": {"name": "Sucker Punch", "description": "+15% crit damage"},
		"active_ability": null, "flavor_text": "Personal touch."
	},

	# --- RARE (10) ---
	"dynamite_bundle": {
		"id": "dynamite_bundle", "name": "Dynamite Bundle", "type": TYPES.EXPLOSIVE, "rarity": RARITY.RARE,
		"damage": 100, "fire_rate": 0.4, "range": 300, "passive": {"name": "Big Blast", "description": "+20% AOE"},
		"active_ability": {"name": "Chain Reaction", "description": "Sequential explosions", "cooldown": 20, "duration": 0}, "flavor_text": "Watch the fuse."
	},
	"plasma_cutter": {
		"id": "plasma_cutter", "name": "Plasma Cutter", "type": TYPES.GUN, "rarity": RARITY.RARE,
		"damage": 45, "fire_rate": 1.2, "range": 200, "passive": {"name": "Melt", "description": "Ignores 20% Armor"},
		"active_ability": null, "flavor_text": "Industrial strength."
	},
	"bolter_rifle": {
		"id": "bolter_rifle", "name": "Bolter Rifle", "type": TYPES.GUN, "rarity": RARITY.RARE,
		"damage": 55, "fire_rate": 0.8, "range": 500, "passive": {"name": "Impact", "description": "Staggers enemies"},
		"active_ability": null, "flavor_text": "Heavy bolts."
	},
	"electrified_bat": {
		"id": "electrified_bat", "name": "Electrified Bat", "type": TYPES.MELEE, "rarity": RARITY.RARE,
		"damage": 42, "fire_rate": 1.0, "range": 60, "passive": {"name": "Shock", "description": "10% chance to stun"},
		"active_ability": {"name": "Overcharge", "description": "Next hit chains lightning", "cooldown": 12, "duration": 0}, "flavor_text": "Zapping good."
	},
	"repeater_sniper": {
		"id": "repeater_sniper", "name": "Repeater Sniper", "type": TYPES.SNIPER, "rarity": RARITY.RARE,
		"damage": 85, "fire_rate": 0.5, "range": 850, "passive": {"name": "Eagle Eye", "description": "+15% Accuracy"},
		"active_ability": null, "flavor_text": "Don't blink."
	},
	"acid_mine": {
		"id": "acid_mine", "name": "Acid Mine", "type": TYPES.TRAP, "rarity": RARITY.RARE,
		"damage": 40, "fire_rate": 0.1, "range": 50, "passive": {"name": "Corrosion", "description": "Weakens enemy armor"},
		"active_ability": null, "flavor_text": "Melting floor."
	},
	"flame_thrower": {
		"id": "flame_thrower", "name": "Flame Thrower", "type": TYPES.GUN, "rarity": RARITY.RARE,
		"damage": 15, "fire_rate": 10.0, "range": 180, "passive": {"name": "Burn", "description": "Stacks fire damage"},
		"active_ability": null, "flavor_text": "Keep it toasted."
	},
	"heavy_claymore": {
		"id": "heavy_claymore", "name": "Heavy Claymore", "type": TYPES.MELEE, "rarity": RARITY.RARE,
		"damage": 75, "fire_rate": 0.4, "range": 80, "passive": {"name": "Sweep", "description": "Hits all enemies in arc"},
		"active_ability": null, "flavor_text": "Big sword, big problems."
	},
	"poison_dart_gun": {
		"id": "poison_dart_gun", "name": "Poison Dart Gun", "type": TYPES.GUN, "rarity": RARITY.RARE,
		"damage": 10, "fire_rate": 1.8, "range": 400, "passive": {"name": "Neurotoxin", "description": "Slows and damages over time"},
		"active_ability": null, "flavor_text": "Silent but sickly."
	},
	"shrapnel_cannon": {
		"id": "shrapnel_cannon", "name": "Shrapnel Cannon", "type": TYPES.EXPLOSIVE, "rarity": RARITY.RARE,
		"damage": 65, "fire_rate": 0.6, "range": 350, "passive": {"name": "Bleed Out", "description": "Enemies take bleed damage in AOE"},
		"active_ability": null, "flavor_text": "Messy impact."
	},

	# --- EPIC (8) ---
	"steam_trap": {
		"id": "steam_trap", "name": "Steam Trap", "type": TYPES.TRAP, "rarity": RARITY.EPIC,
		"damage": 60, "fire_rate": 0.3, "range": 200, "passive": {"name": "Sticky Steam", "description": "30% Slow"},
		"active_ability": {"name": "Overheat", "description": "Fire cone AOE", "cooldown": 25, "duration": 4}, "flavor_text": "Steamy."
	},
	"void_pistol": {
		"id": "void_pistol", "name": "Void Pistol", "type": TYPES.GUN, "rarity": RARITY.EPIC,
		"damage": 55, "fire_rate": 2.0, "range": 350, "passive": {"name": "Erode", "description": "Every hit lowers defense"},
		"active_ability": {"name": "Blink Shot", "description": "Teleport to target", "cooldown": 10, "duration": 0}, "flavor_text": "From the dark."
	},
	"energy_scythe": {
		"id": "energy_scythe", "name": "Energy Scythe", "type": TYPES.MELEE, "rarity": RARITY.EPIC,
		"damage": 90, "fire_rate": 0.9, "range": 90, "passive": {"name": "Soul Siphon", "description": "Heal 2hp on kill"},
		"active_ability": {"name": "Reaper Arc", "description": "Large 360 swing", "cooldown": 18, "duration": 1}, "flavor_text": "Death's high-tech edge."
	},
	"storm_caller": {
		"id": "storm_caller", "name": "Storm Caller", "type": TYPES.SNIPER, "rarity": RARITY.EPIC,
		"damage": 140, "fire_rate": 0.3, "range": 900, "passive": {"name": "Lightning Bolt", "description": "Crit strikes trigger lightning"},
		"active_ability": null, "flavor_text": "Thunder follows."
	},
	"grenade_belt": {
		"id": "grenade_belt", "name": "Grenade Belt", "type": TYPES.EXPLOSIVE, "rarity": RARITY.EPIC,
		"damage": 80, "fire_rate": 1.0, "range": 300, "passive": {"name": "Cluster", "description": "Spawns 3 mini-bombs"},
		"active_ability": null, "flavor_text": "Sharing is scaring."
	},
	"plasma_rifle": {
		"id": "plasma_rifle", "name": "Plasma Rifle", "type": TYPES.GUN, "rarity": RARITY.EPIC,
		"damage": 70, "fire_rate": 1.5, "range": 450, "passive": {"name": "Heat up", "description": "Fire rate increases as you fire"},
		"active_ability": null, "flavor_text": "Glowing hot."
	},
	"titan_hammer": {
		"id": "titan_hammer", "name": "Titan Hammer", "type": TYPES.MELEE, "rarity": RARITY.EPIC,
		"damage": 150, "fire_rate": 0.3, "range": 70, "passive": {"name": "Shatter", "description": "Deals double damage to shields"},
		"active_ability": {"name": "Earthquake", "description": "Stuns all nearby", "cooldown": 30, "duration": 2}, "flavor_text": "Ground shaker."
	},
	"railgun_lite": {
		"id": "railgun_lite", "name": "Railgun Lite", "type": TYPES.SNIPER, "rarity": RARITY.EPIC,
		"damage": 180, "fire_rate": 0.2, "range": 1200, "passive": {"name": "Veloce", "description": "Instant bullet travel"},
		"active_ability": null, "flavor_text": "Fast and lethal."
	},

	# --- LEGENDARY (6) ---
	"laser_rifle": {
		"id": "laser_rifle", "name": "Laser Rifle", "type": TYPES.GUN, "rarity": RARITY.LEGENDARY,
		"damage": 120, "fire_rate": 1.0, "range": 600, "passive": {"name": "Precision Beam", "description": "Every 3rd shot pierces"},
		"active_ability": {"name": "Focused Blast", "description": "Linear beam melt", "cooldown": 30, "duration": 1.5}, "flavor_text": "Beam them up."
	},
	"dragon_cannon": {
		"id": "dragon_cannon", "name": "Dragon Cannon", "type": TYPES.EXPLOSIVE, "rarity": RARITY.LEGENDARY,
		"damage": 250, "fire_rate": 0.2, "range": 400, "passive": {"name": "Eternal Flame", "description": "Infinite burn duration"},
		"active_ability": {"name": "Fire Breath", "description": "Massive fire cone", "cooldown": 40, "duration": 5}, "flavor_text": "Hear the roar."
	},
	"obsidian_blade": {
		"id": "obsidian_blade", "name": "Obsidian Blade", "type": TYPES.MELEE, "rarity": RARITY.LEGENDARY,
		"damage": 180, "fire_rate": 1.2, "range": 65, "passive": {"name": "Bleeding Edge", "description": "Criticals deal 300% damage"},
		"active_ability": {"name": "Shadow Step", "description": "Dash through enemies", "cooldown": 12, "duration": 0}, "flavor_text": "Sharp as shadow."
	},
	"orbital_marker": {
		"id": "orbital_marker", "name": "Orbital Marker", "type": TYPES.SNIPER, "rarity": RARITY.LEGENDARY,
		"damage": 500, "fire_rate": 0.1, "range": 2000, "passive": {"name": "God Eye", "description": "Highlights all enemies"},
		"active_ability": {"name": "Strike", "description": "Beam from sky", "cooldown": 60, "duration": 0}, "flavor_text": "Death from above."
	},
	"vampire_fangs": {
		"id": "vampire_fangs", "name": "Vampire Fangs", "type": TYPES.MELEE, "rarity": RARITY.LEGENDARY,
		"damage": 110, "fire_rate": 2.5, "range": 40, "passive": {"name": "Life Steal", "description": "10% damage returned as HP"},
		"active_ability": null, "flavor_text": "Thirsty."
	},
	"chrono_rifle": {
		"id": "chrono_rifle", "name": "Chrono Rifle", "type": TYPES.GUN, "rarity": RARITY.LEGENDARY,
		"damage": 95, "fire_rate": 1.5, "range": 500, "passive": {"name": "Time Loop", "description": "Chance to instantly reload on kill"},
		"active_ability": {"name": "Stasis Shot", "description": "Freezes target time", "cooldown": 25, "duration": 3}, "flavor_text": "Tick tock."
	},

	# --- MYTHIC (4) ---
	"shock_gauntlet": {
		"id": "shock_gauntlet", "name": "Shock Gauntlet", "type": TYPES.MELEE, "rarity": RARITY.MYTHIC,
		"damage": 220, "fire_rate": 1.8, "range": 100, "passive": {"name": "Electrified", "description": "Damage chains to all nearby"},
		"active_ability": {"name": "Thunder Punch", "description": "Massive shockwave", "cooldown": 40, "duration": 1}, "flavor_text": "Power in your hands."
	},
	"singularity_launcher": {
		"id": "singularity_launcher", "name": "Singularity Launcher", "type": TYPES.EXPLOSIVE, "rarity": RARITY.MYTHIC,
		"damage": 400, "fire_rate": 0.1, "range": 800, "passive": {"name": "Gravity Well", "description": "Pulls enemies toward projectile"},
		"active_ability": {"name": "Black Hole", "description": "Crush all in radius", "cooldown": 90, "duration": 5}, "flavor_text": "The end of space."
	},
	"reaper_of_worlds": {
		"id": "reaper_of_worlds", "name": "Reaper of Worlds", "type": TYPES.SNIPER, "rarity": RARITY.MYTHIC,
		"damage": 999, "fire_rate": 0.05, "range": 5000, "passive": {"name": "Soul Harvest", "description": "Each kill grants permanent +1 damage"},
		"active_ability": null, "flavor_text": "One shot, one reality gone."
	},
	"god_slayer": {
		"id": "god_slayer", "name": "God Slayer", "type": TYPES.MELEE, "rarity": RARITY.MYTHIC,
		"damage": 350, "fire_rate": 1.0, "range": 120, "passive": {"name": "Omni-Slash", "description": "Every hit strikes twice"},
		"active_ability": {"name": "Ascension", "description": "Invulnerable for 10s", "cooldown": 120, "duration": 10}, "flavor_text": "Kneel."
	}
}

# =====================
# Helper Functions
# =====================

func get_weapon(id: String) -> Dictionary:
	return WEAPONS.get(id, {})

func get_all_by_rarity(rarity_id: String) -> Array:
	var result = []
	for key in WEAPONS:
		if WEAPONS[key].rarity.id == rarity_id:
			result.append(WEAPONS[key])
	return result

func get_random_weapon() -> Dictionary:
	var keys = WEAPONS.keys()
	return WEAPONS[keys[randi() % keys.size()]] 