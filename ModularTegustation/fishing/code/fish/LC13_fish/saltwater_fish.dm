
/**
 *
 * Modular file containing: Saltwater fish that are added by our codebase
 *
 */

/obj/item/food/fish/salt_water/sheephead
	name = "california sheephead"
	desc = "California Sheepheads are unique in the fact that they are protogynous hermaphrodites, born female and become male as they mature."
	icon_state = "sheephead"
	random_case_rarity = FISH_RARITY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 91
	average_weight = 16000

/obj/item/food/fish/salt_water/bluefintuna
	name = "bluefin tuna"
	desc = "Bluefins are the largest type of tuna and migrate across all oceans."
	icon_state = "bluefintuna"
	random_case_rarity = FISH_RARITY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 149.86
	average_weight = 226796

/obj/item/food/fish/salt_water/marine_shrimp
	name = "marine shrimp"
	desc = "Shrimp are omnivores and act as primary consumers, mostly consisting off of algae, plankten, and whatever organic material they can scavenge."
	icon_state = "shrimp"
	dedicated_in_aquarium_icon_state = "shrimp_fish"
	average_size = 2
	average_weight = 2
	stable_population = 5
	feeding_frequency = 25 MINUTES
	microwaved_type = /obj/item/food/meat/crab
	fillet_type = /obj/item/food/meat/rawcrab
	food_reagents = list(
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/consumable/nutriment/vile_fluid = 1,
	)

/// Abnormalities

/obj/item/food/fish/salt_water/piscine_mermaid
	name = "lovestruck fish"
	desc = "A carp that seems to have survived exposure to Piscene Mermaids water. It seems to have consumed its own pectoral fins."
	habitat = "Saltwater"
	icon_state = "mermaid"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 16000
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/consumable/salt = 8,
	)
