
/**
 *
 * Modular file containing: Saltwater fish that are added by our codebase
 *
 */

/obj/item/food/fish/salt_water/sheephead
	name = "california sheephead"
	desc = "California Sheepheads are unique in the fact that they are protogynous \
		hermaphrodites, born female and become male as they mature."
	icon_state = "sheephead"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 8
	average_size = 91
	average_weight = 16000

/obj/item/food/fish/salt_water/bluefintuna
	name = "bluefin tuna"
	desc = "Bluefins are the largest type of tuna and migrate across all oceans."
	icon_state = "bluefintuna"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 8
	average_size = 149.86
	average_weight = 60464

/obj/item/food/fish/salt_water/salmon
	name = "sockeye salmon"
	desc = "Sockeye salmon, also known as red salmon, are a species prized for their \
		vibrant red flesh and rich, distinct flavor, typically found in Pacific Ocean waters."
	icon_state = "salmon_sockeye"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 4
	average_size = 71
	average_weight = 4082

/obj/item/food/fish/salt_water/squid
	name = "squid"
	// I couldnt find a good squid fact -IP
	desc = "Cephelopods are the only type of molluscs that have a closed circulatory \
		system where their vital fluids are transported through veins rather than \
		sloshing around inside of them."
	icon_state = "squid"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 8
	average_size = 160
	average_weight = 600

/obj/item/food/fish/salt_water/smolshark
	name = "small shark"
	desc = "Shark eggs come in various forms such as mermaid purses or corkscrews."
	icon_state = "shark_smol"
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 8
	average_size = 149.86
	average_weight = 60464

/obj/item/food/fish/salt_water/marine_shrimp
	name = "marine shrimp"
	desc = "Shrimp are omnivores and act as primary consumers, mostly consisting off of algae, \
		plankten, and whatever organic material they can scavenge."
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

/obj/item/food/fish/salt_water/lobster
	name = "lobster"
	desc = "Lobsters do not weaken as they age, instead they die when the stress of moulting \
		their ever growing shells becomes too great or they dont moult and their shell collapses \
		in on themselves."
	icon_state = "lobster"
	microwaved_type = /obj/item/food/meat/crab
	fillet_type = /obj/item/food/meat/rawcrab
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 6803

/obj/item/food/fish/salt_water/blue_tang
	name = "blue tang"
	desc = "Regal blue tangs have spines on the bottom and top of the area where their \
		tail meets their body that they use to protect themselves."
	icon_state = "blue_tang"
	fillet_type = /obj/item/food/freshfish/white
	average_size = 30
	average_weight = 500
	stable_population = 4

/obj/item/food/fish/salt_water/deep_fry
	name = "deep fry"
	desc = "We shall dive down through black abysses... and in that lair of the Deep Ones we \
		shall dwell amidst wonder and glory forever."
	habitat = "Unknown"
	icon_state = "deep_fry"
	fillet_type = /obj/item/food/freshfish/pink
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 16000
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/abnormality/heartysyrup = 4,
		/datum/reagent/consumable/salt = 4,
	)

/obj/item/food/fish/salt_water/pigfish
	name = "mini pigfish"
	desc = "Almost identical to a boss from a popular videogame."
	icon_state = "pigfish"
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	fillet_type = /obj/item/food/freshfish/pink
	sprite_width = 8
	sprite_height = 8
	average_size = 149.86
	average_weight = 60464

/// Abnormalities

/obj/item/food/fish/salt_water/piscine_mermaid
	name = "lovestruck fish"
	desc = "A carp that seems to have survived exposure to Piscene Mermaid's water. \
		It seems to have consumed its own pectoral fins."
	habitat = "Saltwater"
	icon_state = "mermaid"
	fillet_type = /obj/item/food/freshfish/white
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
		/datum/reagent/abnormality/bittersyrup = 4,
		/datum/reagent/consumable/salt = 4,
	)

/obj/item/food/fish/salt_water/tuna_pallid//TODO: make it unsafe to eat somehow. Apply pallid noise to the consumer
	name = "pallidified tuna"
	desc = "A tuna that was swallowed and corrupted by a great whale. Yuck."
	icon_state = "pallid_tuna"
	habitat = "Great Lake"
	random_case_rarity = FISH_RARITY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 149.86
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/consumable/salt = 8,
		/datum/reagent/toxin = 3,
		/datum/reagent/toxin/mindbreaker = 5,
		/datum/reagent/toxin/pallidwaste = 15,//this is defined in toxin_reagents.dm
	)

/obj/item/food/fish/salt_water/fishmael
	name = "Fishmael"
	desc = "If you please, call me Fishmael."
	icon_state = "fishmael"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/white
	sprite_width = 8
	sprite_height = 8
	average_size = 30
	average_weight = 500

/obj/item/food/fish/salt_water/seabunny
	name = "Sea Bunny"
	desc = "This creature resembles a small white bunny. They are incredibly toxic however."
	icon_state = "seabunny"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/fugu
	sprite_width = 8
	sprite_height = 8
	average_size = 30
	average_weight = 300
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/organ_tissue = 1,
		/datum/reagent/abnormality/focussyrup = 4,
		/datum/reagent/consumable/salt = 4,
	)


/obj/item/food/fish/salt_water/searabbit
	name = "Sea Rabbit"
	desc = "This creature resembles a small R-Corp Rabbit. They aren't incredibly toxic...however."
	icon_state = "searabbit"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/freshfish/slime
	sprite_width = 8
	sprite_height = 8
	average_size = 30
	average_weight = 300
