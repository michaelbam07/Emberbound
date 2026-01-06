# CompanionData.gd
# All companion definitions for gacha, campfire, and gameplay
extends Node
class_name CompanionData

# -----------------------------
# Rarity definitions
# -----------------------------
const RARITY = {
	"COMMON": { "id": "common", "name": "Common", "stars": 1, "color": Color8(158, 158, 158), "drop_rate": 0.50, "dust_value": 5, "shard_value": 1 },
	"UNCOMMON": { "id": "uncommon", "name": "Uncommon", "stars": 2, "color": Color8(76, 175, 80), "drop_rate": 0.30, "dust_value": 10, "shard_value": 2 },
	"RARE": { "id": "rare", "name": "Rare", "stars": 3, "color": Color8(33, 150, 243), "drop_rate": 0.13, "dust_value": 25, "shard_value": 5 },
	"EPIC": { "id": "epic", "name": "Epic", "stars": 4, "color": Color8(156, 39, 176), "drop_rate": 0.055, "dust_value": 50, "shard_value": 10 },
	"LEGENDARY": { "id": "legendary", "name": "Legendary", "stars": 5, "color": Color8(255, 193, 7), "drop_rate": 0.014, "dust_value": 100, "shard_value": 20 },
	"MYTHIC": { "id": "mythic", "name": "Mythic", "stars": 6, "color": Color8(255, 87, 34), "drop_rate": 0.001, "dust_value": 250, "shard_value": 50 }
}

# -----------------------------
# Roles
# -----------------------------
const ROLES = {
	"SHARPSHOOTER": { "id": "sharpshooter", "name": "Sharpshooter", "description": "Ranged damage, crit boosts" },
	"BRAWLER": { "id": "brawler", "name": "Brawler", "description": "Close-range crowd control" },
	"SUPPORT": { "id": "support", "name": "Support", "description": "Healing, shields, buffs" },
	"TRICKSTER": { "id": "trickster", "name": "Trickster", "description": "Debuffs, traps, status effects" },
	"SUMMONER": { "id": "summoner", "name": "Summoner", "description": "Deployable turrets or minions" }
}

# -----------------------------
# Companions dictionary
# -----------------------------
var COMPANIONS = {}

func _ready():
	# ============ COMMON ============
	COMPANIONS["rustys_rat"] = {
		"id":"rustys_rat","name":"Rusty's Rat","rarity":RARITY.COMMON,"role":ROLES.TRICKSTER,
		"sprite_key":"companion_rustys_rat",
		"base_stats":{"health":30,"damage":8,"attack_speed":1.5,"move_speed":120},
		"passive":{"name":"Scavenger","description":"Occasionally finds extra Silver Rounds from defeated enemies"},
		"active_ability":null,"personality":"Skittish but loyal","flavor_text":"Found in a scrapyard, now your trusty sidekick.",
		"lore":"This scrappy rodent survived the Great Dust Storm of '89. It learned to find value in what others throw away.","relationships":[]
	}
	COMPANIONS["billy_the_beetle"] = {
		"id":"billy_the_beetle","name":"Billy the Beetle","rarity":RARITY.COMMON,"role":ROLES.BRAWLER,
		"sprite_key":"companion_billy_beetle",
		"base_stats":{"health":45,"damage":6,"attack_speed":1.0,"move_speed":80},
		"passive":{"name":"Hard Shell","description":"Takes 10% less damage from all sources"},
		"active_ability":null,"personality":"Slow but determined","flavor_text":"A beetle with armor thicker than most outlaws.",
		"lore":"Desert beetles are known for their resilience. Billy is no exception.","relationships":[]
	}
	COMPANIONS["dust_bunny"] = {
		"id":"dust_bunny","name":"Dust Bunny","rarity":RARITY.COMMON,"role":ROLES.SUPPORT,
		"sprite_key":"companion_dust_bunny",
		"base_stats":{"health":25,"damage":4,"attack_speed":0.8,"move_speed":150},
		"passive":{"name":"Lucky Foot","description":"+5% chance for bonus loot drops"},
		"active_ability":null,"personality":"Jumpy and excitable","flavor_text":"Brings luck wherever it hops.",
		"lore":"Legend says petting a Dust Bunny before a duel brings good fortune.","relationships":[]
	}

	# ============ UNCOMMON ============
	COMPANIONS["cactus_carl"] = {
		"id":"cactus_carl","name":"Cactus Carl","rarity":RARITY.UNCOMMON,"role":ROLES.BRAWLER,
		"sprite_key":"companion_cactus_carl",
		"base_stats":{"health":60,"damage":12,"attack_speed":0.7,"move_speed":60},
		"passive":{"name":"Thorny Embrace","description":"Enemies that attack Carl take 5 damage back"},
		"active_ability":null,"personality":"Prickly exterior, soft heart","flavor_text":"Hugging not recommended.",
		"lore":"Carl was once a regular cactus until a wandering shaman gave him life. Now he protects those who water him.","relationships":["dust_bunny"]
	}
	COMPANIONS["copper_crow"] = {
		"id":"copper_crow","name":"Copper Crow","rarity":RARITY.UNCOMMON,"role":ROLES.SHARPSHOOTER,
		"sprite_key":"companion_copper_crow",
		"base_stats":{"health":35,"damage":15,"attack_speed":1.2,"move_speed":180},
		"passive":{"name":"Eagle Eye","description":"+8% critical hit chance for player"},
		"active_ability":null,"personality":"Silent and observant","flavor_text":"Sees everything, says nothing.",
		"lore":"This mechanical bird was crafted by a lonely inventor. Its copper eyes never blink.","relationships":["iron_hawk"]
	}
	COMPANIONS["whiskey_weasel"] = {
		"id":"whiskey_weasel","name":"Whiskey Weasel","rarity":RARITY.UNCOMMON,"role":ROLES.TRICKSTER,
		"sprite_key":"companion_whiskey_weasel",
		"base_stats":{"health":40,"damage":10,"attack_speed":2.0,"move_speed":200},
		"passive":{"name":"Slippery","description":"15% chance to dodge incoming attacks"},
		"active_ability":null,"personality":"Mischievous troublemaker","flavor_text":"Stole the sheriff's boots twice.",
		"lore":"Nobody knows where Whiskey came from, but everyone knows when he's been around - their pockets are lighter.","relationships":["silver_fox"]
	}
	COMPANIONS["tumble_tom"] = {
		"id":"tumble_tom","name":"Tumble Tom","rarity":RARITY.UNCOMMON,"role":ROLES.SUPPORT,
		"sprite_key":"companion_tumble_tom",
		"base_stats":{"health":30,"damage":5,"attack_speed":0.5,"move_speed":100},
		"passive":{"name":"Wanderer's Wind","description":"+10% movement speed for player"},
		"active_ability":null,"personality":"Goes with the flow","flavor_text":"A tumbleweed with places to be.",
		"lore":"Tom has rolled through every town in the territory. He's seen things... dusty, sandy things.","relationships":[]
	}

	# ============ RARE ============
	COMPANIONS["silver_fox"] = {
		"id":"silver_fox","name":"Silver Fox","rarity":RARITY.RARE,"role":ROLES.TRICKSTER,
		"sprite_key":"companion_silver_fox",
		"base_stats":{"health":55,"damage":18,"attack_speed":1.8,"move_speed":220},
		"passive":{"name":"Cunning","description":"Enemies have -10% accuracy when Silver Fox is active"},
		"active_ability":null,"personality":"Sly and calculating","flavor_text":"The smartest creature in any room.",
		"lore":"Once the companion of a legendary con artist, Silver Fox learned every trick in the book.","relationships":["whiskey_weasel","phantom_coyote"]
	}
	COMPANIONS["iron_hawk"] = {
		"id":"iron_hawk","name":"Iron Hawk","rarity":RARITY.RARE,"role":ROLES.SHARPSHOOTER,
		"sprite_key":"companion_iron_hawk",
		"base_stats":{"health":50,"damage":25,"attack_speed":1.0,"move_speed":250},
		"passive":{"name":"Aerial Assault","description":"Attacks from above, ignoring cover. +12% crit damage"},
		"active_ability":null,"personality":"Noble and fierce","flavor_text":"Death from above.",
		"lore":"Forged from the remains of a crashed airship, Iron Hawk patrols the skies with mechanical precision.","relationships":["copper_crow"]
	}
	COMPANIONS["prospector_pete"] = {
		"id":"prospector_pete","name":"Prospector Pete","rarity":RARITY.RARE,"role":ROLES.SUPPORT,
		"sprite_key":"companion_prospector_pete",
		"base_stats":{"health":70,"damage":12,"attack_speed":0.8,"move_speed":90},
		"passive":{"name":"Gold Nose","description":"+25% Golden Rounds from all sources"},
		"active_ability":null,"personality":"Obsessed with shiny things","flavor_text":"There's gold in them hills!",
		"lore":"Pete spent 40 years mining before he became... something else. His ghost still searches for the mother lode.","relationships":[]
	}
	COMPANIONS["rattlesnake_rita"] = {
		"id":"rattlesnake_rita","name":"Rattlesnake Rita","rarity":RARITY.RARE,"role":ROLES.BRAWLER,
		"sprite_key":"companion_rattlesnake_rita",
		"base_stats":{"health":65,"damage":20,"attack_speed":1.5,"move_speed":140},
		"passive":{"name":"Venom Strike","description":"Attacks apply poison, dealing 3 damage per second for 4 seconds"},
		"active_ability":null,"personality":"Cold and patient","flavor_text":"Don't step on her.",
		"lore":"Rita was a dancer in a saloon before she was cursed to take serpent form. She doesn't miss her old life.","relationships":["scorpion_sally"]
	}

	# ============ EPIC ============
	COMPANIONS["phantom_coyote"] = {
		"id":"phantom_coyote","name":"Phantom Coyote","rarity":RARITY.EPIC,"role":ROLES.TRICKSTER,
		"sprite_key":"companion_phantom_coyote",
		"base_stats":{"health":80,"damage":28,"attack_speed":1.6,"move_speed":260},
		"passive":{"name":"Spirit Walk","description":"Phases through enemies, cannot be targeted for 2 seconds after appearing"},
		"active_ability":{"name":"Howl of Confusion","description":"All enemies are disoriented for 3 seconds, reducing their accuracy by 50%","cooldown":20,"duration":3},
		"personality":"Ethereal trickster","flavor_text":"Is it there? Was it ever?","lore":"The Phantom Coyote appears only to those who walk between worlds. It is said to be the spirit of a trickster god.","relationships":["silver_fox","ghost_rider_rex"]
	}
	COMPANIONS["scorpion_sally"] = {
		"id":"scorpion_sally","name":"Scorpion Sally","rarity":RARITY.EPIC,"role":ROLES.BRAWLER,
		"sprite_key":"companion_scorpion_sally",
		"base_stats":{"health":100,"damage":32,"attack_speed":1.2,"move_speed":130},
		"passive":{"name":"Armored Carapace","description":"Takes 20% less damage. Immune to poison"},
		"active_ability":{"name":"Sting Barrage","description":"Rapidly attacks 5 times, each hit applying stacking poison","cooldown":15,"duration":2},
		"personality":"Aggressive protector","flavor_text":"Her sting is worse than her bite.","lore":"Sally was the bodyguard of a desert queen. When the kingdom fell, she continued her duty in spectral form.","relationships":["rattlesnake_rita"]
	}
	COMPANIONS["clockwork_deputy"] = {
		"id":"clockwork_deputy","name":"Clockwork Deputy","rarity":RARITY.EPIC,"role":ROLES.SHARPSHOOTER,
		"sprite_key":"companion_clockwork_deputy",
		"base_stats":{"health":75,"damage":35,"attack_speed":2.0,"move_speed":150},
		"passive":{"name":"Law and Order","description":"Marks enemies hit, marked enemies take 15% more damage from player"},
		"active_ability":{"name":"Fan the Hammer","description":"Fires 6 rapid shots at all nearby enemies","cooldown":18,"duration":1.5},
		"personality":"Lawful and precise","flavor_text":"The law never sleeps, and neither does he.","lore":"Built by a grieving father to continue his son's legacy as deputy. The clockwork lawman dispenses justice with mechanical efficiency.","relationships":["iron_hawk"]
	}
	COMPANIONS["medicine_mare"] = {
		"id":"medicine_mare","name":"Medicine Mare","rarity":RARITY.EPIC,"role":ROLES.SUPPORT,
		"sprite_key":"companion_medicine_mare",
		"base_stats":{"health":90,"damage":15,"attack_speed":0.8,"move_speed":200},
		"passive":{"name":"Healing Presence","description":"Player regenerates 2 health per second when near Medicine Mare"},
		"active_ability":{"name":"Emergency Care","description":"Instantly heals player for 40 health and cures all status effects","cooldown":25,"duration":0},
		"personality":"Gentle and nurturing","flavor_text":"A horse with a healing touch.","lore":"Medicine Mare was the mount of a traveling healer. When her rider passed, she inherited his gift.","relationships":["prospector_pete"]
	}
	COMPANIONS["dynamite_dave"] = {
		"id":"dynamite_dave","name":"Dynamite Dave","rarity":RARITY.EPIC,"role":ROLES.SUMMONER,
		"sprite_key":"companion_dynamite_dave",
		"base_stats":{"health":60,"damage":45,"attack_speed":0.5,"move_speed":100},
		"passive":{"name":"Explosive Expert","description":"All explosion damage increased by 25%"},
		"active_ability":{"name":"TNT Barrage","description":"Throws 3 sticks of dynamite that explode for massive area damage","cooldown":22,"duration":0},
		"personality":"Enthusiastically dangerous","flavor_text":"Loves his job a little too much.","lore":"Dave was a demolitions expert for the railroad. An accident left him somewhere between alive and dead, but his love for explosives remains.","relationships":[]
	}

	# ============ LEGENDARY ============
	COMPANIONS["ghost_rider_rex"] = {
		"id":"ghost_rider_rex","name":"Ghost Rider Rex","rarity":RARITY.LEGENDARY,"role":ROLES.BRAWLER,
		"sprite_key":"companion_ghost_rider_rex",
		"base_stats":{"health":150,"damage":50,"attack_speed":1.4,"move_speed":280},
		"passive":{"name":"Hellfire Trail","description":"Leaves a trail of fire that damages enemies for 10 damage per second"},
		"active_ability":{"name":"Penance Stare","description":"Stuns all enemies in view for 4 seconds and deals damage equal to 20% of their max health","cooldown":30,"duration":4},
		"personality":"Vengeful spirit of justice","flavor_text":"Guilty souls beware.","lore":"Rex was a bounty hunter who made a deal with dark forces. Now he rides eternally, hunting the wicked.","relationships":["phantom_coyote","the_undertaker"]
	}
	COMPANIONS["the_undertaker"] = {
		"id":"the_undertaker","name":"The Undertaker","rarity":RARITY.LEGENDARY,"role":ROLES.SUMMONER,
		"sprite_key":"companion_undertaker",
		"base_stats":{"health":120,"damage":40,"attack_speed":1.0,"move_speed":110},
		"passive":{"name":"Grave Matters","description":"Defeated enemies have a 30% chance to rise as allied skeletons"},
		"active_ability":{"name":"Call of the Grave","description":"Summons 4 skeleton gunfighters that last 15 seconds","cooldown":35,"duration":15},
		"personality":"Somber and inevitable","flavor_text":"Everyone meets him eventually.","lore":"The Undertaker has buried thousands. Some say he knows when your time will come. Others say he decides it.","relationships":["ghost_rider_rex"]
	}

	# ============ MYTHIC ============
	COMPANIONS["lady_lumina"] = {
		"id":"lady_lumina","name":"Lady Lumina","rarity":RARITY.MYTHIC,"role":ROLES.SUPPORT,
		"sprite_key":"companion_lady_lumina",
		"base_stats":{"health":200,"damage":60,"attack_speed":1.2,"move_speed":220},
		"passive":{"name":"Radiant Aura","description":"All allies gain +20% damage and +15% speed when nearby"},
		"active_ability":{"name":"Celestial Blessing","description":"Fully restores health of all allies and grants immunity to debuffs for 8 seconds","cooldown":60,"duration":8},
		"personality":"Wise, serene, almost divine","flavor_text":"Her presence turns the tide of battle.","lore":"Born from the stars, Lady Lumina descended to guide the lost and protect the innocent. Legends say she appears where hope is needed most.","relationships":["medicine_mare"]
	}
	COMPANIONS["ember_ignis"] = {
		"id":"ember_ignis","name":"Ember Ignis","rarity":RARITY.MYTHIC,"role":ROLES.BRAWLER,
		"sprite_key":"companion_ember_ignis",
		"base_stats":{"health":220,"damage":80,"attack_speed":1.6,"move_speed":240},
		"passive":{"name":"Flame Heart","description":"All attacks have a 25% chance to burn enemies for 15 damage over 5 seconds"},
		"active_ability":{"name":"Inferno Blast","description":"Deals massive area fire damage to all enemies in range","cooldown":50,"duration":0},
		"personality":"Fierce, unstoppable","flavor_text":"Burn everything, ask questions never.","lore":"Ember Ignis is said to have risen from the molten core of a volcano. His rage is the fury of fire incarnate.","relationships":["dynamite_dave"]
	}

