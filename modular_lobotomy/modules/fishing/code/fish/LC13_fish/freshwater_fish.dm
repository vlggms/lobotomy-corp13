
/**
 *
 * Modular file containing: Freshwater fish that are added by our codebase
 *
 */

/obj/item/food/fish/fresh_water/waterflea
	name = "water flea"
	desc = "Water Fleas are sometimes used in scientific studies to test the effects of toxins due to their transparency and easily identifiable organs."
	habitat = "Freshwater Ponds"
	icon_state = "waterflea"
	random_case_rarity = FISH_RARITY_RARE
	sprite_width = 2
	sprite_height = 2
	average_size = 1
	average_weight = 1
	stable_population = 2
	microwaved_type = null
	fillet_type = /obj/item/food/canned

/obj/item/food/fish/fresh_water/northernpike
	name = "northern pike"
	desc = "Northern pike are territorial predators that ambush prey with a burst of speed, pikes can move upto ten miles per hour while ambushing prey."
	icon_state = "northernpike"
	random_case_rarity = FISH_RARITY_VERY_RARE
	sprite_width = 8
	sprite_height = 4
	average_size = 91
	average_weight = 9071

/// Abnormalities

/obj/item/food/fish/fresh_water/yang
	name = "yang carp"
	desc = "A unique breed of carp that is themed around yang. The philosophical concept of yang is characterized by masculinity, the sun, light, and activity."
	icon_state = "yangfish"
	random_case_rarity = FISH_RARITY_VERY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 6803

/obj/item/food/fish/fresh_water/yin
	name = "yin carp"
	desc = "A unique breed of carp that is themed around yin. The philosophical concept of yin is characterized by femininity, the moon, darkness, and disintigration."
	icon_state = "yinfish"
	random_case_rarity = FISH_RARITY_VERY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 6803

/obj/item/food/fish/fresh_water/mosb
	name = "mountain of smiling fish"
	desc = "This mass attempts to bite onto detris and living organisms in order to increase its size. If it wasnt for the uncanny resemblence to T-01-75 this would be written off as a product of nature, but this is clearly a mutation brought upon by exposure."
	icon_state = "mosb"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 16000
	food_reagents = list(
		/datum/reagent/medicine/mental_stabilizator = 2,
		/datum/reagent/consumable/nutriment/vile_fluid = 6,
	)
	fillet_type = /obj/item/food/meat/slab/human/mutant/zombie //zombi meat
