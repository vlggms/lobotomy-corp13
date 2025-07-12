//--------------------------------------
// The Augment Fabricator Machine
//--------------------------------------

#define AUGMENT_ICON_FILE 'icons/effects/augment_fab.dmi' // CHANGE THIS to your actual DMI file path

/obj/machinery/augment_fabricator
	name = "Augment Fabricator"
	desc = "A machine used to design and fabricate custom augments. Requires proper clearance."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "protolathe"
	var/icon_state_animation = "protolathe_n"
	anchored = TRUE
	density = TRUE

	// --- TGUI Handler ---
	/// Manages the TGUI interactions for this machine.
	var/datum/tgui_handler/augment_fabricator/ui_handler = null

	var/const/ui_key = "AugmentFabricator"
	var/list/roles = list("Prosthetics Surgeon", "Office Director", "Office Fixer", "Doctor")

	var/market_change_interval = 20 * 60 * 10 // 20 minutes in deciseconds
	var/list/sale_percentages = list(25, 33, 40, 66)
	var/list/markup_percentages = list(25, 33, 40)
	var/max_66_sales = 2
	var/on_sale_pct = 0.2
	var/markup_pct = 0.1

	// --- Data (Same as before) ---
	var/list/available_forms = list(
		"Internal Prosthetic" = list(
			"id" = "prosthetic",
			"name" = "Internal Prosthetic",
			"base_cost" = 200,
			"base_ep" = 2,
			"desc" = "A standard internal augmentation base.",
			"icon_file" = AUGMENT_ICON_FILE, // Store the file path
			"icon_preview" = "prosthetic", // Base icon state
			"primary_overlay_state" = "prosthetic_prim", // State for primary color mask
			"secondary_overlay_state" = "prosthetic_secon" // State for secondary color mask
			),
		"Tattoo" = list(
			"id" = "tattoo",
			"name" = "Tattoo",
			"base_cost" = 50,
			"base_ep" = 4,
			"negative_immune" = 1,
			"desc" = "An augment woven into the skin. Unable to have negative effects and causes the user to grow physically weaker, then higher the rank of the tattoo.",
			"icon_file" = AUGMENT_ICON_FILE, // Store the file path
			"icon_preview" = "tattoo", // Base icon state
			"primary_overlay_state" = "tattoo_prim", // State for primary color mask
			"secondary_overlay_state" = "tattoo_secon" // State for secondary color mask
		)
		// Add other forms here
	)

	// --- Data accessible to the UI ---
	// ... available_forms list would be here ...

	var/list/available_effects = list(
		// --- Reactive Damage Effects ---
		list(
			"id" = "struggling_defense",
			"name" = "Struggling Defense",
			"ahn_cost" = 25,
			"ep_cost" = 2, // Positive EP cost
			"desc" = "For every 12.5% of HP lost, take 5%*X less damage.",
			"repeatable" = 3, // Max 3 times
			"component" = /datum/component/augment/resisting_augment/struggling_defense
		),
		list(
			"id" = "ES_red",
			"name" = "Emergency Shields, RED",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take brute damage while under 50% HP, gain 8 RED Protection. This has a cooldown of 1 minute.",
			"component" = /datum/component/augment/ES_red
		),
		list(
			"id" = "ES_black",
			"name" = "Emergency Shields, BLACK",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take brute damage while under 50% HP, gain 8 BLACK Protection. This has a cooldown of 1 minute.",
			"component" = /datum/component/augment/ES_black
		),
		list(
			"id" = "ES_white",
			"name" = "Emergency Shields, WHITE",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "When you take sanity damage while under 50% SP, gain 8 WHITE Protection. This has a cooldown of 1 minute.",
			"component" = /datum/component/augment/ES_white
		),
		list(
			"id" = "defensive_preparations",
			"name" = "Defensive Preparations",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When taking brute damage, give yourself and all humans within 4 sqrs of you 4 Protection. This has a cooldown of 1.5 minutes.",
			"repeatable" = 3,
			"component" = /datum/component/augment/defensive_preparations
		),
		list(
			"id" = "reinforcement_nanties",
			"name" = "Reinforcement Nanties",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "When you take damage, you will take 5*X% less damage per human you can see. (Max of 40%).",
			"repeatable" = 3,
			"component" = /datum/component/augment/resisting_augment/reinforcement_nanties
		),
		list(
			"id" = "cooling_systems",
			"name" = "Cooling Systems",
			"ahn_cost" = 100,
			"ep_cost" = 4,
			"desc" = "Take 75% less damage from OVERHEAT, however take 25% more damage from RED attacks.",
			"component" = /datum/component/augment/cooling_systems
		),
		list(
			"id" = "stalwart_form",
			"name" = "Stalwart Form",
			"ahn_cost" = 100,
			"ep_cost" = 4,
			"desc" = "Stuns/Knockdowns are 90% less effective on you. However, you will take 15% extra RED and BLACK damage.",
			"component" = /datum/component/augment/stalwart_form
		),
		list(
			"id" = "fireproof",
			"name" = "Fireproof",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "Under 15% HP, you become immune to OVERHEAT damage.",
			"component" = /datum/component/augment/fireproof
		),
		// --- Attacking Effects ---
		list(
			"id" = "regeneration",
			"name" = "Regeneration",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a RED weapon, heal a flat 2*X HP (Has a cooldown of half a second)",
			"repeatable" = 3,
			"component" = /datum/component/augment/regeneration
		),
		list(
			"id" = "tranquility",
			"name" = "Tranquility",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a WHITE weapon, heal a flat 2*X SP (Has a cooldown of half a second)",
			"repeatable" = 3,
			"component" = /datum/component/augment/tranquility
		),
		list(
			"id" = "struggling_strength",
			"name" = "Struggling Strength",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 12.5% of HP lost, deal 5%*X more damage.",
			"component" = /datum/component/augment/struggling_strength
		),
		list(
			"id" = "ar_red",
			"name" = "Armor Rend, RED",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit with a RED weapon, inflict 3 BLACK fragility.",
			"component" = /datum/component/augment/ar_red
		),
		list(
			"id" = "ar_black",
			"name" = "Armor Rend, BLACK",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit with a BLACK weapon, inflict 3 RED fragility.",
			"component" = /datum/component/augment/ar_black
		),
		list(
			"id" = "dual_wield",
			"name" = "Strong Arms",
			"ahn_cost" = 200,
			"ep_cost" = 8,
			"desc" = "When you perform a melee attack, if you are holding another weapon in your other hand, attack the same target with your other weapon. This has a cooldown of the other weapons attack speed *4",
			"component" = /datum/component/augment/dual_wield
		),
		list(
			"id" = "unstable",
			"name" = "Unstable",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "While at 50% or higher SP, you BLACK melee attacks deal 20% more damage, but you also take SP damage equal to 5% of your Max SP per hit.",
			"component" = /datum/component/augment/unstable
		),
		list(
			"id" = "shattering_mind_red",
			"name" = "Shattering Mind, RED",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 25% of your missing SP, deal an extra 10*X% RED damage.",
			"component" = /datum/component/augment/shattering_mind_red
		),
		list(
			"id" = "shattering_mind_white",
			"name" = "Shattering Mind, WHITE",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 25% of your missing SP, deal an extra 10*X% WHITE damage.",
			"component" = /datum/component/augment/shattering_mind_white
		),
		list(
			"id" = "shattering_mind_black",
			"name" = "Shattering Mind, BLACK",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 25% of your missing SP, deal an extra 10*X% BLACK damage.",
			"component" = /datum/component/augment/shattering_mind_black
		),
		list(
			"id" = "gashing_wounds",
			"name" = "Gashing Wounds",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a RED weapon, inflict 2 BLEED (Cooldown of half a second)",
			"component" = /datum/component/augment/gashing_wounds
		),
		list(
			"id" = "scorching_mind",
			"name" = "Scorching Mind",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a WHITE weapon, inflict 3 OVERHEAT (Cooldown of 1 second.)",
			"component" = /datum/component/augment/scorching_mind
		),
		list(
			"id" = "slothful_decay",
			"name" = "Slothful Decay",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "On hit with a BLACK weapon, inflict 2 TREMOR. If the weapon has an attack speed greater than 1.5 second, Inflict an extra 2 TREMOR. (Cooldown of 1.5 seconds.)",
			"component" = /datum/component/augment/slothful_decay
		),
		list(
			"id" = "strong_grip",
			"name" = "Strong Grip",
			"ahn_cost" = 100,
			"ep_cost" = 4,
			"desc" = "If you attack while you have HARM intent, your weapon will become unable to be dropped. This effect is removed when you attack in any other intent.",
			"component" = /datum/component/augment/strong_grip
		),
		// --- Execution Effects ---
		list(
			"id" = "absorption",
			"name" = "Absorption",
			"ahn_cost" = 100,
			"ep_cost" = 6,
			"desc" = "On kill, regenerate as much HP as the amount of damage you dealt. (Max of 50 HP healing)",
			"component" = /datum/component/augment/absorption
		),
		list(
			"id" = "brutalize",
			"name" = "Brutalize",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "On kill, deal 15*X WHITE damage to all simple mobs within 2 sqrs of you.",
			"component" = /datum/component/augment/brutalize
		),
		list(
			"id" = "flesh_morphing",
			"name" = "Flesh-Morphing",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"repeatable" = 3,
			"desc" = "On kill, One human within 4 sqrs of you (not including you), Heals 10% * X of your target max HP.",
			"component" = /datum/component/augment/flesh_morphing
		),
		list(
			"id" = "reclaimed_flame",
			"name" = "Reclaimed Flame",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"repeatable" = 3,
			"desc" = "On kill, heal 20 * X OVERHEAT damage.",
			"component" = /datum/component/augment/reclaimed_flame
		),
		// --- Status Effects ---
		list(
			"id" = "burn_vigor",
			"name" = "OVERHEAT Vigor",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "When making a melee attack, deal an extra 10*X% more damage for every 5 OVERHEAT on self.",
			"component" = /datum/component/augment/burn_vigor
		),
		list(
			"id" = "bleed_vigor",
			"name" = "BLEED Vigor",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "When making a melee attack, deal an extra 10*X% more damage for every 5 BLEED on self.",
			"component" = /datum/component/augment/bleed_vigor
		),
		list(
			"id" = "tremor_defense",
			"name" = "TREMOR Defense",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "For every 10 TREMOR on self, take 5*X% less damage from RED/BLACK attacks. (Max of 30% + (X - 1) * 20%)",
			"component" = /datum/component/augment/resisting_augment/tremor_defense
		),
		list(
			"id" = "earthquake",
			"name" = "Earthquake",
			"ahn_cost" = 100,
			"ep_cost" = 8,
			"desc" = "When attacking a target with 20+ TREMOR, trigger a TREMOR burst on target and deal (TREMOR on target * 6) RED damage to all mobs within 3 sqrs of the target. This has a cooldown of 30 seconds.",
			"component" = /datum/component/augment/earthquake
		),
		list(
			"id" = "tremor_break",
			"name" = "TREMOR Break",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When attacking a target with 15+ TREMOR, trigger a TREMOR Burst on the target and inflict (TREMOR on Target / 5) Feeble to the target. This has a cooldown of 30 seconds.",
			"component" = /datum/component/augment/tremor_break
		),
		list(
			"id" = "tremor_burst",
			"name" = "TREMOR Burst",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"desc" = "When attacking a target with 10+ TREMOR, trigger a TREMOR Burst on the target. This has a cooldown of 10 seconds.",
			"component" = /datum/component/augment/tremor_burst
		),
		list(
			"id" = "reflective_tremor",
			"name" = "Reflective TREMOR",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 4,
			"desc" = "When taking RED/BLACK damage from a melee attack, inflict 2*X TREMOR to the target and X TREMOR to self. (This has a cooldown of 1 second)",
			"component" = /datum/component/augment/reflective_tremor
		),
		list(
			"id" = "blood_jaunt",
			"name" = "Blood Jaunt",
			"ahn_cost" = 200,
			"ep_cost" = 8,
			"desc" = "When you click on a tile outside your melee range and within 3 sqrs, You will teleport to that tile and will inflict 10 BLEED to all foes within 2 sqrs, and yourself. (Has a cooldown of 1 minute) (You need to be in harm intent in order to trigger this.)",
			"component" = /datum/component/augment/blood_jaunt
		),
		list(
			"id" = "sanguine_desire",
			"name" = "Sanguine Desire",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack to a target with BLEED, heal 3 SP and an extra 2 SP for every status effect they have. (Has a cooldown of 1 second).",
			"component" = /datum/component/augment/sanguine_desire
		),
		list(
			"id" = "pyromaniac",
			"name" = "Pyromaniac",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack, while having 5+ OVERHEAT on self, transfer 2 OVERHEAT on self to the target.",
			"component" = /datum/component/augment/pyromaniac
		),
		list(
			"id" = "hemomaniac",
			"name" = "Hemomaniac",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack, while having 5+ BLEED on self, transfer 2 BLEED on self to the target.",
			"component" = /datum/component/augment/hemomaniac
		),
		list(
			"id" = "spreading_embers",
			"name" = "Spreading Embers",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When attacking a target with 10+ OVERHEAT, inflict 10 OVERHEAT to all foes within 3 sqrs of the target, and inflict 15 OVERHEAT to self. (This has a cooldown of 30 seconds).",
			"component" = /datum/component/augment/spreading_embers
		),
		list(
			"id" = "regenerative_warmth",
			"name" = "Regenerative Warmth",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "Taking OVERHEAT damage heals BRUTE and OVERHEAT damage equal to 50% of OVERHEAT damage taken.",
			"component" = /datum/component/augment/regenerative_warmth
		),
		list(
			"id" = "stoneward_form",
			"name" = "Stoneward Form",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When you take damage, spawn a Stoneward Statue which every 5 seconds heals all humans near it and gives them 3 TREMOR. (Spawning has a cooldown of 30 seconds)",
			"component" = /datum/component/augment/stoneward_form
		),
		list(
			"id" = "ink_over",
			"name" = "Ink Over",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "When making a melee attack to a target with BLEED, deal 20% more damage, and deal an additional 10% for each status effect they have.",
			"component" = /datum/component/augment/ink_over
		),
		list(
			"id" = "blood_rush",
			"name" = "Blood Rush",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On Kill, Gain a 50% speed boost for 5 seconds and gain 5 BLEED.",
			"component" = /datum/component/augment/blood_rush
		),
		list(
			"id" = "time_moratorium",
			"name" = "Time Moratorium",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit against a target with 15+ TREMOR, consume 10 TREMOR from the target to trigger the timestop effect around them, with an AoE of 2 and duration of 4 seconds. (Has a cooldown of 30 seconds.)",
			"component" = /datum/component/augment/time_moratorium
		),
		list(
			"id" = "tremor_everlasting",
			"name" = "TREMOR Everlasting",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit against a target with 10+ TREMOR, preform a TREMOR Burst and inflict TREMOR equal to half of their current TREMOR. (Has a cooldown of 30 seconds.)",
			"component" = /datum/component/augment/tremor_everlasting
		),
		list(
			"id" = "tremor_deterioration",
			"name" = "TREMOR Deterioration",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "On hit against a target with 4+ TREMOR on self, consume 3 TREMOR on self to trigger an 3x3 AoE centered around the target, which deals half damage of your weapon and inflicts X TREMOR. (Has a cooldown of 2.5 seconds.)",
			"component" = /datum/component/augment/tremor_deterioration
		),
		list(
			"id" = "vibroweld_morph_combat_effect",
			"name" = "Vibroweld Morph-combat effect",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit against a target with 16+ TREMOR on self, consume 15 TREMOR on self to trigger 3 TREMOR Bursts on target. (Has a cooldown of 30 seconds.)",
			"component" = /datum/component/augment/vibroweld_morph_combat_effect
		),
		list(
			"id" = "tremor_ruin",
			"name" = "TREMOR Ruin",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "On hit against a target with 10+ TREMOR, Prefrom a TREMOR Burst and inflict BLACK fragility equal to (targets TREMOR/5). (Has a cooldown of 15 seconds.)",
			"component" = /datum/component/augment/tremor_ruin
		),
		list(
			"id" = "rekindled_flame",
			"name" = "Rekindled Flame",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "When attacking a target, inflict 1*X OVERHEAT for every 25% of your missing HP.",
			"component" = /datum/component/augment/rekindled_flame
		),
		list(
			"id" = "force_of_a_wildfire ",
			"name" = "Force of a Wildfire ",
			"ahn_cost" = 100,
			"ep_cost" = 6,
			"desc" = "On kill, All foes who are within 3 sqrs of the user, get inflicted with OVERHEAT equal to the executed target’s OVERHEAT.",
			"component" = /datum/component/augment/force_of_a_wildfire
		),
		list(
			"id" = "unstable_inertia",
			"name" = "Unstable Inertia",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "When you take damage, inflict 1*X TREMOR for every 25% of your missing HP.",
			"component" = /datum/component/augment/unstable_inertia
		),
		list(
			"id" = "blood_cycler",
			"name" = "Blood Cycler",
			"ahn_cost" = 50,
			"ep_cost" = 4,
			"desc" = "Any time a mob/human within 3 sqrs of you takes BLEED damage, heal HP equal to 50% of the BLEED damage they have taken. (Max of 100).",
			"component" = /datum/component/augment/blood_cycler
		),

		list(
			"id" = "acidic_blood",
			"name" = "Acidic Blood",
			"ahn_cost" = 25,
			"ep_cost" = 2,
			"repeatable" = 3,
			"desc" = "When you take BLEED damage, Deal BLACK damage equal to the amount of BLEED you have *2X, to all simple mobs within 3 sqrs of you..",
			"component" = /datum/component/augment/acidic_blood
		),

		// --- Negative Effects ---
		list(
			"id" = "paranoid",
			"name" = "Paranoid ",
			"ahn_cost" = 50,
			"ep_cost" = -2, // Negative EP cost signifies a downside, grants EP
			"desc" = "Whenever you take damage, you take an extra 10 WHITE damage if you don’t have any human insight.",
			"component" = /datum/component/augment/paranoid
		),
		list(
			"id" = "bus",
			"name" = "Boot Up Sequence",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "When you make an attack, gain 3 Feeble. This has a cooldown of 70 seconds.",
			"component" = /datum/component/augment/bus
		),
		list(
			"id" = "overheated",
			"name" = "Overheated",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you make an attack, for the next 10 seconds each time you attack you gain 2*X OVERHEAT. This has a cooldown of 1.5 minutes.",
			"repeatable" = 3,
			"component" = /datum/component/augment/overheated
		),
		list(
			"id" = "mental_corrosion",
			"name" = "Mental Corrosion",
			"ahn_cost" = 0,
			"ep_cost" = -6,
			"desc" = "Your mind slowly corrodes over time. Being near other humans slows the process, but something calls you to the water...",
			"component" = /datum/component/augment/mental_corrosion
		),
		list(
			"id" = "thanatophobia",
			"name" = "Thanatophobia",
			"ahn_cost" = 25,
			"ep_cost" = -2,
			"desc" = "When you take damage while under 50% HP, take an extra 10 WHITE damage. Has a cooldown of 1 second.",
			"component" = /datum/component/augment/thanatophobia
		),
		list(
			"id" = "pacifist",
			"name" = "Pacifist",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "On kill, gain 3 Feeble",
			"component" = /datum/component/augment/pacifist
		),
		list(
			"id" = "struggling_weakness",
			"name" = "Struggling Weakness",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "For every 25% of HP lost, deal 20%*X less damage..",
			"repeatable" = 3,
			"component" = /datum/component/augment/struggling_weakness
		),
		list(
			"id" = "struggling_fragility",
			"name" = "Struggling Fragility",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "For every 25% of HP lost, take 20%*X more damage..",
			"repeatable" = 3,
			"component" = /datum/component/augment/struggling_fragility
		),
		list(
			"id" = "algophobia",
			"name" = "Algophobia",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you take RED damage, take an extra (RED damage) * X WHITE damage. This has a cooldown of 1 second.",
			"repeatable" = 3,
			"component" = /datum/component/augment/algophobia
		),
		list(
			"id" = "weak_arms",
			"name" = "Weak Arms",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "Your melee attacks have their attack speed decreased by half.",
			"component" = /datum/component/augment/weak_arms
		),
		list(
			"id" = "annoyance",
			"name" = "Annoyance",
			"ahn_cost" = 25,
			"ep_cost" = -4,
			"desc" = "After every 8 attacks, all foes within 3 sqrs will start targeting you and you gain 2 Fragile.",
			"component" = /datum/component/augment/annoyance
		),
		list(
			"id" = "allodynia",
			"name" = "Allodynia",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you take damage, you gain 2 * X BLEED. (Has a cooldown of 1 second). Also, you take BLEED damage each time you attack. (That has a cooldown of 3 seconds)",
			"repeatable" = 3,
			"component" = /datum/component/augment/allodynia
		),
		list(
			"id" = "internal_vibrations",
			"name" = "Internal Vibrations",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you take damage, gain 2 * X TREMOR. Gain double the amount of TREMOR if the damage type was WHITE. If you have 50 TREMOR, TREMOR BURST yourself. (Has a cooldown of 0.5 second)",
			"repeatable" = 3,
			"component" = /datum/component/augment/internal_vibrations
		),
		list(
			"id" = "scalding_skin",
			"name" = "Scalding Skin",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "When you take damage, you will gain OVERHEAT equal to the (damage taken)  / 5. If the damage type was RED, double the gained OVERHEAT. (This has a cooldown of 30 / X seconds)",
			"repeatable" = 3,
			"component" = /datum/component/augment/scalding_skin
		),
		list(
			"id" = "open_wound",
			"name" = "Open Wound",
			"ahn_cost" = 10,
			"ep_cost" = -2,
			"desc" = "After taking BLACK damage, for the next 10 seconds all of your attacks will inflict 2 * X BLEED to self. (Has a cooldown of 20 seconds.)",
			"repeatable" = 3,
			"component" = /datum/component/augment/open_wound
		),
		// Add other effects following this structure
	)

	var/maxRank = 5
	var/list/rankAttributeReqs = list(20, 40, 60, 80, 100)
	var/currencySymbol = "ahn"

// --- Initialization ---
/obj/machinery/augment_fabricator/Initialize(mapload) // Use Initialize if available, otherwise New()
	. = ..()
	// Create and assign the UI handler, passing this machine instance
	ui_handler = new(src)
	if(!ui_handler)
		log_admin("Failed to initialize tgui_handler for [src]")

	// --- Initialize Market State for Effects ---
	// Ensure all effects have the market keys, prevents runtime errors later
	for(var/list/effect_data in available_effects)
		if(!isnull(effect_data["ahn_cost"])) // Only process if it has a base cost
			effect_data["current_ahn_cost"] = effect_data["ahn_cost"] // Initialize current cost
		else // Handle cases where ahn_cost might be missing (though it shouldn't be)
			effect_data["ahn_cost"] = 0
			effect_data["current_ahn_cost"] = 0
		effect_data["sale_percent"] = 0
		effect_data["markup_percent"] = 0
	// --- End Initialization ---

	// --- Schedule First Market Change Immediately ---
	ApplyMarketChange() // Run it once at startup
	// Schedule the next one
	ScheduleNextMarketChange()

/// Schedules the next market change event.
/obj/machinery/augment_fabricator/proc/ScheduleNextMarketChange()
	// Use addtimer with a CALLBACK to call ApplyMarketChange on this specific instance later
	addtimer(CALLBACK(src, PROC_REF(ApplyMarketChange)), market_change_interval, TIMER_UNIQUE) // TIMER_UNIQUE prevents duplicate timers

/// Applies the random market changes to the effects list.
/obj/machinery/augment_fabricator/proc/ApplyMarketChange()
	if(QDELETED(src))
		return // Don't run if machine is being deleted

	log_game("[src] Applying market change at world time [world.time]")

	// 1. Reset all effects to base price and clear flags
	for(var/list/effect_data in available_effects)
		effect_data["current_ahn_cost"] = effect_data["ahn_cost"]
		effect_data["sale_percent"] = 0
		effect_data["markup_percent"] = 0

	// 2. Prepare for selection
	var/list/effect_indices = list()
	for(var/i = 1 to available_effects.len)
		effect_indices += i // Store indices

	effect_indices = shuffle(effect_indices) // Randomize the order

	// 3. Calculate number of sales and markups
	var/total_effects = effect_indices.len
	var/num_on_sale = round(total_effects * on_sale_pct)
	var/num_marked_up = round(total_effects * markup_pct)

	// Ensure we don't try to select more than available
	num_on_sale = min(num_on_sale, total_effects)
	num_marked_up = min(num_marked_up, total_effects - num_on_sale) // Markups come from remaining pool

	// 4. Apply Sales
	var/num_66_applied = 0
	var/list/applied_indices = list() // Track which indices are already modified

	for(var/i = 1 to num_on_sale)
		if(effect_indices.len == 0)
			break // Should not happen if counts are correct, but safety first
		var/effect_index = effect_indices[1] // Pick the first from shuffled list
		effect_indices -= effect_index      // Remove it from the pool
		applied_indices += effect_index     // Mark as processed

		var/list/effect_data = available_effects[effect_index]
		if(effect_data["ahn_cost"] <= 0)
			continue // Don't put free things on sale

		// Determine available sale percentages
		var/list/possible_sales = sale_percentages.Copy() // Work on a copy
		if(num_66_applied >= max_66_sales)
			possible_sales -= 66 // Remove 66% if limit reached

		if(possible_sales.len == 0)
			continue // Should not happen unless only 66% was left

		var/sale_percent = pick(possible_sales)
		if(sale_percent == 66)
			num_66_applied++

		effect_data["sale_percent"] = sale_percent
		effect_data["current_ahn_cost"] = round(effect_data["ahn_cost"] * (1 - sale_percent / 100.0))
		effect_data["current_ahn_cost"] = max(1, effect_data["current_ahn_cost"]) // Ensure cost is at least 1
		log_game("[src] Effect '[effect_data["name"]]' now on sale: [sale_percent]% off. New cost: [effect_data["current_ahn_cost"]]")


	// 5. Apply Markups (from the remaining pool)
	for(var/i = 1 to num_marked_up)
		if(effect_indices.len == 0)
			break // Ran out of effects to mark up
		var/effect_index = effect_indices[1] // Pick the first from remaining shuffled list
		effect_indices -= effect_index      // Remove it
		applied_indices += effect_index     // Mark as processed

		var/list/effect_data = available_effects[effect_index]
		if(effect_data["ahn_cost"] <= 0)
			continue // Don't mark up free things (or apply logic if desired)

		var/markup_percent = pick(markup_percentages)

		effect_data["markup_percent"] = markup_percent
		effect_data["current_ahn_cost"] = round(effect_data["ahn_cost"] * (1 + markup_percent / 100.0))
		log_game("[src] Effect '[effect_data["name"]]' now marked up: [markup_percent]%. New cost: [effect_data["current_ahn_cost"]]")


	// 6. Update UI for anyone viewing
	ui_handler.update_uis()

	// 7. Schedule the *next* market change
	ScheduleNextMarketChange()

// --- Core Interaction ---
/obj/machinery/augment_fabricator/attack_hand(mob/user)
	if(!Adjacent(user, src))
		return ..()

	// Allow ghosts to view the UI
	if(isobserver(user))
		if(ui_handler)
			return ui_handler.ui_interact(user)
		else
			log_admin("Missing ui_handler on [src] during attack_hand by [user]")
			to_chat(user, "<span class='warning'>Machine interface error. Please report this.</span>")
			return TRUE

	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, "<span class='warning'>You lack the dexterity to operate this machine.</span>")
		return TRUE

	// --- Access Check ---
	if(!(user?.mind?.assigned_role in roles))
		if(SSmaptype.maptype != "office")
			to_chat(user, "<span class='notice'>You need to be a surgeon to use this machine!</span>")
			return TRUE

	// --- Delegate UI Interaction to the Handler ---
	if(ui_handler)
		return ui_handler.ui_interact(user)
	else
		log_admin("Missing ui_handler on [src] during attack_hand by [user]")
		to_chat(user, "<span class='warning'>Machine interface error. Please report this.</span>")
		return TRUE


/// Placeholder for deducting the cost.
/obj/machinery/augment_fabricator/proc/deduct_cost(mob/user, amount)
	var/obj/item/card/id/C
	if(isliving(user))
		var/mob/living/L = user
		C = L.get_idcard(TRUE)
		if(!C)
			return FALSE
		else if(!C.registered_account)
			return FALSE

		var/datum/bank_account/account = C.registered_account
		if(amount && !account.adjust_money(-amount))
			return FALSE
		else
			L.playsound_local(get_turf(src), 'sound/effects/cashregister.ogg', 25, 3, 3)
			return TRUE
	return FALSE


/obj/machinery/augment_fabricator/proc/make_new_augment()
	return new /obj/item/augment

/// Handles the actual creation of the augment item. Called by the UI handler.
/obj/machinery/augment_fabricator/proc/perform_fabrication(mob/user, datum/augment_design/design, creator_name, creator_desc, primary_color, secondary_color)
	if(!design || !user)
		log_admin("perform_fabrication called with invalid args for [user] at [src]")
		return null

	var/total_ahn_cost = design.total_ahn_cost

	// --- Final Checks & Payment ---
	if(!deduct_cost(user, total_ahn_cost))
		to_chat(user, "<span class='warning'>Failed to deduct [total_ahn_cost] [src.currencySymbol]. Payment cancelled.</span>")
		return null // Fabrication fails

	var/temp_icon_state = icon_state
	icon_state = icon_state_animation
	playsound(get_turf(src), 'sound/items/rped.ogg', 50, TRUE, -1)
	sleep(7)
	icon_state = temp_icon_state

	var/obj/item/augment/new_augment = make_new_augment() // Create item at machine's location
	new_augment.loc = get_turf(src)
	if(new_augment)
		new_augment.name = creator_name ? "[creator_name] ([design.form_data["name"]])" : "[design.form_data["name"]] Augment (Rank [design.rank])"
		new_augment.desc = creator_desc ? creator_desc : "A custom-fabricated augment using the '[design.form_data["name"]]' template at Rank [design.rank]."
		new_augment.apply_design(design, primary_color, secondary_color) // Apply the validated design

		log_game("[key_name(user)] fabricated '[new_augment.name]' using [src.name] at ([loc.x],[loc.y],[loc.z]). Design Cost: [total_ahn_cost].")
		return new_augment
	else
		log_runtime("Failed to create augment item at [src] for [user].")
		to_chat(user, "<span class='warning'>Critical fabrication failure! Please contact administration.</span>")
		// Attempt to refund the cost on critical failure
		// if(total_ahn_cost > 0) user.give_amount(total_ahn_cost) // Replace with refund logic
		log_runtime("Refunding [total_ahn_cost] [src.currencySymbol] to [user] due to creation failure.")
		// machine.refund_cost(user, total_ahn_cost) // Use a refund proc if available
		return null


// /obj/machinery/augment_fabricator/proc/check_access(obj/item/card/id/id_card)
// 	// TODO: Implement actual access check logic (e.g., check for surgeon access bit)
// 	return id_card && id_card.access // Example: Check if any access exists on card

// Helper datum for validation (slightly improved)
/datum/augment_design
	var/list/form_data
	var/rank
	var/list/selected_effects_data = list()
	var/base_ep
	var/total_ep_cost
	var/remaining_ep
	var/base_ahn_cost
	var/effects_ahn_cost
	var/total_ahn_cost
	var/validation_error = "" // Store error message for user feedback

/datum/augment_design/proc/validate_and_calculate(form_name, rank_num, list/selected_effect_ids, obj/machinery/augment_fabricator/fabricator)
	src.validation_error = "" // Reset error

	// 1. Validate Form (No change)
	if(!fabricator || !fabricator.available_forms[form_name])
		src.validation_error = "Selected form ('[form_name]') is invalid or fabricator missing."
		log_admin("[src.validation_error]")
		return FALSE
	src.form_data = fabricator.available_forms[form_name]

	// 2. Validate Rank (No change)
	if(rank_num < 1 || rank_num > 5) // Assuming maxRank is still 5
		src.validation_error = "Selected rank ([rank_num]) is out of range (1-5)."
		log_admin("[src.validation_error]")
		return FALSE
	src.rank = rank_num

	// 3. Calculate Base Values (No change)
	src.base_ahn_cost = form_data["base_cost"] * src.rank
	src.base_ep = form_data["base_ep"] + ((src.rank - 1) * 2)

	// 4. Validate and Calculate Effects (UPDATED LOGIC)
	src.total_ep_cost = 0
	src.effects_ahn_cost = 0
	src.selected_effects_data = list() // Reset effect data list
	var/list/effect_counts = list() // Track counts of each effect ID

	for(var/effect_id in selected_effect_ids)
		var/list/effect_def = null // Initialize to null

		// --- Manual Search Loop ---
		for(var/list/possible_effect in fabricator.available_effects)
			if(possible_effect["id"] == effect_id)
				effect_def = possible_effect // Found it!
				break // Stop searching this inner loop
		// --- End Manual Search Loop ---

		if(!effect_def) // Check if we found it after the loop
			src.validation_error = "An invalid effect ID ('[effect_id]') was selected."
			log_admin("[src.validation_error]")
			return FALSE

		// Increment count for this effect ID
		effect_counts[effect_id] = (effect_counts[effect_id] || 0) + 1

		// Check repeatability
		var/max_repeats = text2num(effect_def["repeatable"]) // Convert to number, defaults to 0 if null/invalid
		if(max_repeats > 0) // If the effect is repeatable
			if(effect_counts[effect_id] > max_repeats)
				src.validation_error = "Effect '[effect_def["name"]]' can only be repeated [max_repeats] times (tried to add [effect_counts[effect_id]]).."
				log_admin("[src.validation_error]")
				return FALSE
		else // If the effect is NOT repeatable (max_repeats is 0 or less)
			if(effect_counts[effect_id] > 1)
				src.validation_error = "Non-repeatable effect '[effect_def["name"]]' added multiple times."
				log_admin("[src.validation_error]")
				return FALSE

		// TODO: Check for negative effects. Sum of all negative effect <= base EP

		// Check form restrictions (Example: Tattoo form immunity to negative effects)
		// Negative effect identified by ep_cost < 0
		if(form_data["negative_immune"] && effect_def["ep_cost"] < 0)
			src.validation_error = "The '[form_data["name"]]' form cannot accept negative effects like '[effect_def["name"]]'."
			log_admin("[src.validation_error]")
			return FALSE

		// Add validated effect data (only add the definition once, even if selected multiple times in input)
		// The final list of effects to apply should probably be reconstructed based on counts later
		// Let's keep adding the raw definition for now, apply_design might need counts
		src.selected_effects_data += list(effect_def) // Store the definition list for reference
		src.total_ep_cost += effect_def["ep_cost"]
		src.effects_ahn_cost += effect_def["current_ahn_cost"]

	// 5. Final Calculations & Checks (No change)
	src.remaining_ep = src.base_ep - src.total_ep_cost
	if(src.remaining_ep < 0)
		src.validation_error = "Total EP cost ([src.total_ep_cost]) exceeds base EP ([src.base_ep])."
		log_admin("[src.validation_error]")
		return FALSE

	// !!! TOTAL AHN COST NOW USES CURRENT EFFECT COSTS !!!
	src.total_ahn_cost = src.base_ahn_cost + src.effects_ahn_cost
	src.total_ahn_cost = max(0, src.total_ahn_cost) // Ensure non-negative

	// TODO: Add any other validation rules

	return TRUE // Validation successful

// Helper proc to find effect definition by ID within the list of lists
/proc/find_effect_by_id(list/effect_definition, effect_id_to_find)
	return effect_definition["id"] == effect_id_to_find

// Augment Item definition (basic structure)
/obj/item/augment
	name = "Augment"
	icon = AUGMENT_ICON_FILE
	icon_state = "prosthetic"
	var/datum/augment_design/design_details // Store the applied design data
	var/primary_color = "#FFFFFF"
	var/secondary_color = "#CCCCCC"
	var/list/rankAttributeReqs = list(20, 40, 60, 80, 100)
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)
	var/list/roles = list("Prosthetics Surgeon", "Office Director", "Office Fixer", "Doctor")
	var/active_augment = FALSE
	// var/mutable_appearance/augment_overlay_prim
	// var/mutable_appearance/augment_overlay_second
	// var/overlay_icon_state = ""
	// var/overlay_layer = -ABOVE_MOB_LAYER

/obj/item/augment/attack(mob/M, mob/user)
	. = ..()
	if (!CanUseAugment(user))
		to_chat(user, span_warning("You don't have any expertise in attaching this augment."))
		return FALSE
	if (!ishuman(M))
		to_chat(user, span_warning("You are only able to attach this augment to humans!"))
		return FALSE
	var/mob/living/carbon/human/H = M
	var/stattotal
	for(var/attribute in stats)
		stattotal+=get_attribute_level(H, attribute)
	stattotal /= 4	//Potential is an average of stats
	if(stattotal < rankAttributeReqs[design_details.rank])
		to_chat(user, span_warning("[H.name] is too weak to use this augment!"))
		return FALSE

	var/obj/item/augment/A = null
	for(var/atom/movable/i in H.contents)
		if (istype(i, /obj/item/augment))
			if(i == src)
				continue
			else
				A = i
				if(!A.active_augment)
					A = null
	if (A)
		to_chat(user, span_warning("Augment already present within [H.name]!"))
		return FALSE

	to_chat(user, span_warning("Inserting [name]..."))
	if (!do_after(user, 10 SECONDS, H))
		return FALSE
	playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE, -1)
	to_chat(user, span_nicegreen("[name] has been successfully inserted into [H.name]."))
	src.forceMove(H)
	active_augment = TRUE
	if(design_details.form_data["id"] == "tattoo")
		H.adjust_all_attribute_buffs(design_details.rank * -4)
		// augment_overlay_prim = FormatOverlay(H)
		// H.add_overlay(augment_overlay_prim)
		// augment_overlay_second = FormatOverlay(H)
		// H.add_overlay(augment_overlay_second)
	ApplyEffects(H)

// /obj/item/augment/proc/FormatOverlay(mob/living/carbon/human/user)
// 	return mutable_appearance(src.icon, src.overlay_icon_state, src.overlay_layer)

/obj/item/augment/proc/CanUseAugment(mob/user)
	if(user?.mind?.assigned_role in roles || SSmaptype.maptype == "office")
		return TRUE
	return FALSE

/obj/item/augment/proc/ApplyEffects(mob/living/carbon/human/H)
	var/list/grouped_efects_list = new/list()
	for (var/list/effect in design_details.selected_effects_data)
		var/current_id = effect["id"]
		if (!islist(grouped_efects_list[current_id]))
			grouped_efects_list[current_id] = list(effect)
		else
			grouped_efects_list[current_id] += list(effect)

	for (var/id in grouped_efects_list)
		var/list/items_in_group = grouped_efects_list[id]
		var/effect = items_in_group[1]
		if (effect["component"])
			H.AddComponent(effect["component"], items_in_group.len)
	return

/obj/item/augment/proc/apply_design(datum/augment_design/applied_design, p_color, s_color)
	if(!applied_design)
		log_admin("Attempted to apply null design to [src]")
		return
	// It's often better to copy relevant data than hold a reference
	// to the temporary validation datum, unless the datum is designed
	// to be persistent. Let's assume we copy needed info.
	// src.design_details = applied_design // If keeping reference is okay

	// Example: Copying key details
	src.design_details = new /datum/augment_design() // Create persistent storage
	src.design_details.form_data = applied_design.form_data.Copy() // Copy lists/datums
	src.design_details.rank = applied_design.rank
	src.design_details.selected_effects_data = applied_design.selected_effects_data.Copy()
	src.design_details.base_ep = applied_design.base_ep
	src.design_details.total_ep_cost = applied_design.total_ep_cost
	// We don't usually need to store cost on the item itself

	src.primary_color = p_color
	src.secondary_color = s_color

	var/form_data = applied_design.form_data
	icon = generate_augment_preview_icon(form_data["icon_file"], form_data["icon_preview"], form_data["primary_overlay_state"],
		form_data["secondary_overlay_state"], p_color, s_color)

/proc/sanitize_hex_color(color_text, default_color = "#FFFFFF")
	if(!color_text) return default_color
	// Basic check for # followed by 3 or 6 hex chars
	if(length(color_text) == 4 || length(color_text) == 7)
		if(copytext(color_text, 1, 2) == "#")
			var/hex = copytext(color_text, 2)
			for(var/i=1 to length(hex))
				var/char_code = text2ascii(hex, i)
				// Check if 0-9, A-F, a-f
				if(!((char_code >= 48 && char_code <= 57) || (char_code >= 65 && char_code <= 70) || (char_code >= 97 && char_code <= 102)))
					return default_color // Invalid character
			return uppertext(color_text) // Return valid hex, uppercased for consistency
	return default_color // Failed validation

/obj/item/augment_tester
	name = "Augment Tester"
	desc = "A device that can check what types of augments the target can use."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "records_stats"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/augment_tester/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(ishuman(target))
		playsound(get_turf(src), 'sound/machines/cryo_warning.ogg', 50, TRUE, -1)
		var/mob/living/carbon/human/H = target

		var/obj/item/augment/A = null
		for(var/atom/movable/i in H.contents)
			if (istype(i, /obj/item/augment))
				A = i
		if(A)
			to_chat(user, span_notice("The target currently has the [A.name] augment."))
			// List the augment effects
			if(A.design_details && A.design_details.selected_effects_data && length(A.design_details.selected_effects_data))
				to_chat(user, span_notice("Augment Effects:"))
				var/list/effect_counts = list()
				for(var/list/effect in A.design_details.selected_effects_data)
					var/effect_id = effect["id"]
					effect_counts[effect_id] = (effect_counts[effect_id] || 0) + 1
				
				var/list/shown_effects = list()
				for(var/list/effect in A.design_details.selected_effects_data)
					var/effect_id = effect["id"]
					if(effect_id in shown_effects)
						continue
					shown_effects += effect_id
					var/count = effect_counts[effect_id]
					var/effect_name = effect["name"]
					var/effect_desc = effect["desc"]
					if(count > 1)
						to_chat(user, span_notice("• [effect_name] (x[count]): [effect_desc]"))
					else
						to_chat(user, span_notice("• [effect_name]: [effect_desc]"))

		var/stattotal
		for(var/attribute in stats)
			stattotal+=get_attribute_level(H, attribute)
		stattotal /= 4	//Potential is an average of stats
		var/best_augment = round(stattotal/20)
		if(best_augment > 5)
			best_augment = 5
		if(best_augment < 1)
			to_chat(user, span_notice("The target is unable to use any augments."))
			return
		to_chat(user, span_notice("The target is able to use rank [best_augment] or lower augments."))
		return

	to_chat(user, span_notice("No human identified."))

/obj/item/insurgence_augment_tester
	name = "Insurgence Augment Tester"
	desc = "A device that can check what types of augments the target can use."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "records_stats"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/insurgence_augment_tester/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(ishuman(target))
		playsound(get_turf(src), 'sound/machines/cryo_warning.ogg', 50, TRUE, -1)
		var/mob/living/carbon/human/H = target

		var/obj/item/augment/A = null
		for(var/atom/movable/i in H.contents)
			if (istype(i, /obj/item/augment))
				A = i
		if(A)
			to_chat(user, span_notice("The target currently has the [A.name] augment."))
			// List the augment effects
			if(A.design_details && A.design_details.selected_effects_data && length(A.design_details.selected_effects_data))
				to_chat(user, span_notice("Augment Effects:"))
				var/list/effect_counts = list()
				for(var/list/effect in A.design_details.selected_effects_data)
					var/effect_id = effect["id"]
					effect_counts[effect_id] = (effect_counts[effect_id] || 0) + 1
				
				var/list/shown_effects = list()
				for(var/list/effect in A.design_details.selected_effects_data)
					var/effect_id = effect["id"]
					if(effect_id in shown_effects)
						continue
					shown_effects += effect_id
					var/count = effect_counts[effect_id]
					var/effect_name = effect["name"]
					var/effect_desc = effect["desc"]
					if(count > 1)
						to_chat(user, span_notice("• [effect_name] (x[count]): [effect_desc]"))
					else
						to_chat(user, span_notice("• [effect_name]: [effect_desc]"))

		var/stattotal
		for(var/attribute in stats)
			stattotal+=get_attribute_level(H, attribute)
		stattotal /= 4	//Potential is an average of stats
		var/best_augment = round(stattotal/20)
		best_augment += 1
		if(best_augment > 5)
			best_augment = 5
		if(best_augment < 1)
			to_chat(user, span_notice("The target is unable to use any augments."))
			return
		to_chat(user, span_notice("The target is able to use rank [best_augment] or lower augments."))
		return

	to_chat(user, span_notice("No human identified."))

/obj/item/ncorp_augment_tester
	name = "N-Corp Augment Tester"
	desc = "A device that can check if a target has an augment."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "disc_stats"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ncorp_augment_tester/attack(mob/M, mob/user)
	if(ishuman(M))
		to_chat(user, span_notice("Locating augments within [M.name]..."))
		playsound(get_turf(src), 'sound/machines/cryo_warning.ogg', 50, TRUE, -1)
		var/mob/living/carbon/human/H = M
		if (!do_after(user, 8 SECONDS, H))
			return FALSE

		var/obj/item/augment/A = null
		for(var/atom/movable/i in H.contents)
			if (istype(i, /obj/item/augment))
				A = i
		if(A)
			to_chat(user, span_boldwarning("[M.name] has an augment!"))
			playsound(get_turf(src), 'sound/machines/nuke/confirm_beep.ogg', 100, TRUE, -1)
		else
			to_chat(user, span_nicegreen("[M.name] doesn't have an augment!"))
			playsound(get_turf(src), 'sound/machines/nuke/angry_beep.ogg', 100, TRUE, -1)

/obj/item/augment_remover
	name = "Augment Remover"
	desc = "A device that can remove augments."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget1"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/list/roles = list("Prosthetics Surgeon", "Office Director", "Office Fixer", "Doctor", "Insurgence Transport Agent", "Insurgence Nightwatch Agent")

/obj/item/augment_remover/attack(mob/M, mob/user)
	if (!CanRemoveAugment(user))
		to_chat(user, span_warning("You don't have any expertise in using this tool."))
		return FALSE
	if (!ishuman(M))
		to_chat(user, span_warning("You are only able to use this tool on humans!"))
		return FALSE
	var/mob/living/carbon/human/H = M

	var/remove_turf = pick(get_adjacent_open_turfs(H))
	var/obj/item/augment/A = null
	for(var/atom/movable/i in H.contents)
		if (istype(i, /obj/item/augment))
			A = i

	if (A)
		playsound(get_turf(src), 'sound/items/drill_use.ogg', 50, TRUE, -1)
		to_chat(user, span_warning("Removing [A.name] from [H.name]..."))
		if (!do_after(user, 10 SECONDS, H))
			return FALSE
		for(var/list/effect in A.design_details.selected_effects_data)
			if (effect["component"])
				var/datum/component/augment/C = H.GetComponent(effect["component"])
				if (C)
					C.RemoveComponent()
		A.forceMove(remove_turf)
		playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, TRUE, -1)
		if(A.design_details.form_data["id"] == "tattoo")
			H.adjust_all_attribute_buffs(A.design_details.rank * 4)
			// H.cut_overlay(A.augment_overlay_prim)
			// H.cut_overlay(A.augment_overlay_second)
		A.active_augment = FALSE
		to_chat(user, span_nicegreen("Successfuly removed [A.name] from [H.name]!"))
	else
		to_chat(user, span_warning("No augment found within [H.name]!"))

/obj/item/augment_remover/proc/CanRemoveAugment(mob/user)
	if(user?.mind?.assigned_role in roles || SSmaptype.maptype == "office")
		return TRUE
	return FALSE
