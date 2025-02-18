
/**
 *
 * Modular file containing: Freshwater fish that are added by our codebase
 *
 */

/obj/item/food/fish/fresh_water/waterflea
	name = "water flea"
	desc = "Water Fleas are sometimes used in scientific studies to test the \
		effects of toxins due to their transparency and easily identifiable organs."
	habitat = "Freshwater Ponds"
	icon_state = "waterflea"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/slime
	sprite_width = 2
	sprite_height = 2
	average_size = 1
	average_weight = 1
	stable_population = 2
	microwaved_type = null
	fillet_type = /obj/item/food/canned
	food_reagents = list(
		/datum/reagent/consumable/nutriment/organ_tissue = 3,
		/datum/reagent/consumable/nutriment/vile_fluid = 1,
		/datum/reagent/abnormality/bittersyrup = 1,
	)

/obj/item/food/fish/fresh_water/northernpike
	name = "northern pike"
	desc = "Northern pike are territorial predators that ambush prey with a burst \
		of speed, pikes can move upto ten miles per hour while ambushing prey."
	icon_state = "northernpike"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 4
	average_size = 91
	average_weight = 9071

/obj/item/food/fish/fresh_water/salmon
	name = "atlantic salmon"
	desc = " Atlantic salmon are anadromous fish known for their silver-blue coloration \
		and are native to rivers and oceans along the North Atlantic coast, valued for \
		their delicate taste and texture in culinary preparations."
	icon_state = "salmon_sockeye"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 4
	average_size = 175
	average_weight = 3175

/obj/item/food/fish/fresh_water/eel
	name = "freshwater eel"
	desc = "Eels hunt during the night and sleep in the mud near the shoreline during the day."
	icon_state = "eel_fresh"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 4
	average_size = 175
	average_weight = 3175

/// Abnormalities

/obj/item/food/fish/fresh_water/yang
	name = "yang carp"
	desc = "A unique breed of carp that is themed around yang. The philosophical \
		concept of yang is characterized by masculinity, the sun, light, and activity."
	icon_state = "yangfish"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fillet_type = /obj/item/food/freshfish/white
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 6803
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/consumable/nutriment/vile_fluid = 2,
		/datum/reagent/abnormality/bittersyrup = 4,
	)

/obj/item/food/fish/fresh_water/yin
	name = "yin carp"
	desc = "A unique breed of carp that is themed around yin. The philosophical \
		concept of yin is characterized by femininity, the moon, darkness, and disintigration."
	icon_state = "yinfish"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 6803
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/consumable/nutriment/vile_fluid = 2,
		/datum/reagent/abnormality/tastesyrup = 4,
	)

/obj/item/food/fish/fresh_water/mosb
	name = "mountain of smiling fish"
	desc = "This mass attempts to bite onto detris and living organisms in order to increase \
		its size. If it wasnt for the uncanny resemblence to T-01-75 this would be written off \
		as a product of nature, but this is clearly a mutation brought upon by exposure."
	icon_state = "mosb"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	fillet_type = /obj/item/food/freshfish/rotten
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 16000
	food_reagents = list(
		/datum/reagent/medicine/mental_stabilizator = 2,
		/datum/reagent/abnormality/heartysyrup = 4,
		/datum/reagent/consumable/nutriment/vile_fluid = 6,
	)

/obj/item/food/fish/fresh_water/unidentifiedfishobject
	name = "Unidentified Fish Object"
	desc = "What the Fuck."
	icon_state = "unidentified-fish-object"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fillet_type = /obj/item/food/freshfish/rotten
	sprite_width = 8
	sprite_height = 8
	average_size = 40
	average_weight = 5000

/obj/item/food/fish/fresh_water/ufo
	name = "Ufo"
	desc = "The object hums at a low frequency, seemingly defying all laws of physics."
	icon_state = "ufo"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fillet_type = /obj/item/food/freshfish/slime
	sprite_width = 8
	sprite_height = 8
	average_size = 40
	average_weight = 7000

/obj/item/food/fish/fresh_water/walkin_man
	name = "Walkin Man"
	desc = "I'm walkin' here!"
	icon_state = "walkin_man"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fillet_type = /obj/item/food/freshfish/white
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 5600

/obj/item/food/fish/fresh_water/boxin_man
	name = "Boxin Man"
	desc = "I'm boxin' here!"
	icon_state = "boxin_man"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fillet_type = /obj/item/food/freshfish/white
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 5600

/obj/item/food/fish/fresh_water/weever_blue_album
	name = "Weever Blue Album"
	desc = "Only in Dreams!"
	icon_state = "weever_blue_album"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fillet_type = /obj/item/food/freshfish/slime
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 10000
