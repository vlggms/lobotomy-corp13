// Freshwater fish

/obj/item/fish/goldfish
	name = "goldfish"
	desc = "Despite common belief, goldfish do not have three-second memories. They can actually remember things that happened up to three months ago."
	icon_state = "goldfish"
	sprite_width = 8
	sprite_height = 8
	stable_population = 3
	average_size = 30
	average_weight = 500
	favorite_bait = list(/obj/item/food/bait/worm)

/obj/item/fish/angelfish
	name = "angelfish"
	desc = "Young Angelfish often live in groups, while adults prefer solitary life. They become territorial and aggressive toward other fish when they reach adulthood."
	icon_state = "angelfish"
	dedicated_in_aquarium_icon_state = "bigfish"
	sprite_height = 7
	source_height = 7
	average_size = 30
	average_weight = 500
	stable_population = 3

/obj/item/fish/guppy
	name = "guppy"
	desc = "Guppy is also known as rainbow fish because of the brightly colored body and fins."
	icon_state = "guppy"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#91AE64"
	sprite_width = 8
	sprite_height = 5
	average_size = 30
	average_weight = 500
	stable_population = 6

/obj/item/fish/plasmatetra
	name = "plasma tetra"
	desc = "Due to their small size, tetras are prey to many predators in their watery world, including eels, crustaceans, and invertebrates."
	icon_state = "plastetra"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#D30EB0"
	average_size = 30
	average_weight = 500
	stable_population = 3

/obj/item/fish/catfish
	name = "cory catfish"
	desc = "A catfish has about 100,000 taste buds, and their bodies are covered with them to help detect chemicals present in the water and also to respond to touch."
	icon_state = "catfish"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#907420"
	average_size = 100
	average_weight = 2000
	stable_population = 3
	favorite_bait = list(
		list(
			"Type" = "Foodtype",
			"Value" = JUNKFOOD
		)
	)

/obj/item/fish/yang
	name = "yang carp"
	desc = "A unique breed of carp that is themed around yang. The philosophical concept of yang is characterized by masculinity, the sun, light, and activity."
	icon_state = "yangfish"
	sprite_width = 8
	sprite_height = 8
	average_size = 30
	average_weight = 500
	stable_population = 3

/obj/item/fish/yin
	name = "yin carp"
	desc = "A unique breed of carp that is themed around yin. The philosophical concept of yin is characterized by femininity, the moon, darkness, and disintigration."
	icon_state = "yinfish"
	sprite_width = 8
	sprite_height = 8
	average_size = 30
	average_weight = 500
	stable_population = 3

/obj/item/fish/waterflea
	name = "water flea"
	desc = "Water Fleas are sometimes used in scientific studies to test the effects of toxins due to their transparency and easily identifiable organs."
	icon_state = "waterflea"
	sprite_width = 8
	sprite_height = 8
	average_size = 1
	average_weight = 1
	stable_population = 3
	fillet_type = /obj/item/food/canned


// Saltwater fish below

/obj/item/fish/clownfish
	name = "clownfish"
	desc = "Clownfish catch prey by swimming onto the reef, attracting larger fish, and luring them back to the anemone. The anemone will sting and eat the larger fish, leaving the remains for the clownfish."
	icon_state = "clownfish"
	dedicated_in_aquarium_icon_state = "clownfish_small"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 5
	average_size = 30
	average_weight = 500
	stable_population = 4

	fishing_traits = list(/datum/fishing_trait/picky_eater)

/obj/item/fish/cardinal
	name = "cardinalfish"
	desc = "Cardinalfish are often found near sea urchins, where the fish hide when threatened."
	icon_state = "cardinalfish"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 4
	fishing_traits = list(/datum/fishing_trait/vegan)

/obj/item/fish/greenchromis
	name = "green chromis"
	desc = "The Chromis can vary in color from blue to green depending on the lighting and distance from the lights."
	icon_state = "greenchromis"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#00ff00"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 5

	fishing_difficulty_modifier = 5 // Bit harder

/obj/item/fish/firefish
	name = "firefish goby"
	desc = "To communicate in the wild, the firefish uses its dorsal fin to alert others of potential danger."
	icon_state = "firefish"
	sprite_width = 6
	sprite_height = 5
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 3
	disliked_bait = list(/obj/item/food/bait/worm, /obj/item/food/bait/doughball)
	fish_ai_type = FISH_AI_ZIPPY

/obj/item/fish/pufferfish
	name = "pufferfish"
	desc = "One Pufferfish contains enough toxins in its liver to kill 30 people."
	icon_state = "pufferfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 8
	average_size = 60
	average_weight = 1000
	stable_population = 3

	fishing_traits = list(/datum/fishing_trait/heavy)

/obj/item/fish/lanternfish
	name = "lanternfish"
	desc = "Typically found in areas below 6600 feet below the surface of the ocean, they live in complete darkness."
	icon_state = "lanternfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	random_case_rarity = FISH_RARITY_VERY_RARE
	source_width = 28
	source_height = 21
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 1500
	stable_population = 2

	fishing_traits = list(/datum/fishing_trait/nocturnal)

/datum/aquarium_behaviour/fish/sheephead
	name = "california sheephead"
	desc = "California Sheepheads are unique in the fact that they are protogynous hermaphrodites, born female and become male as they mature."
	icon_state = "sheephead"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 8
	average_size = 60
	average_weight = 1000
	stable_population = 3

	fishing_traits = list(/datum/fishing_trait/heavy)

/obj/item/fish/marine_shrimp
	name = "marine shrimp"
	desc = "Shrimp are omnivores and act as primary consumers, mostly consisting off of algae, plankten, and whatever organic material they can scavenge"
	icon_state = "shrimp"
	dedicated_in_aquarium_icon_state = "shrimp_fish"
	stable_population = 5
	feeding_frequency = 25 MINUTES
	fillet_type = /obj/item/food/meat/slab/rawcrab

//Chasm fish
/obj/item/fish/chasm_crab
	name = "chasm chrab"
	desc = "The young of the lobstrosity mature in pools below the earth, eating what falls in until large enough to clamber out. Those found near the station are well-fed."
	icon_state = "chrab"
	dedicated_in_aquarium_icon_state = "chrab_small"
	sprite_height = 9
	sprite_width = 8
	source_height = 9
	source_width = 8
	stable_population = 4
	feeding_frequency = 15 MINUTES
	random_case_rarity = FISH_RARITY_RARE
	fillet_type = /obj/item/food/meat/slab/rawcrab

/obj/item/storage/box/fish_debug
	name = "box full of fish"

/obj/item/storage/box/fish_debug/PopulateContents()
	for(var/fish_type in subtypesof(/obj/item/fish))
		new fish_type(src)

/obj/item/fish/emulsijack
	name = "toxic emulsijack"
	desc = "Ah, the terrifying emulsijack. Created in a laboratory, this slimey, scaleless fish emits an invisible toxin that emulsifies other fish for it to feed on. Its only real use is for completely ruining a tank."
	icon_state = "emulsijack"
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	stable_population = 3

/obj/item/fish/emulsijack/process(delta_time)
	var/emulsified = FALSE
	var/obj/structure/aquarium/aquarium = loc
	if(istype(aquarium))
		for(var/obj/item/fish/victim in aquarium)
			if(istype(victim, /obj/item/fish/emulsijack))
				continue //no team killing
			victim.adjust_health((victim.health - 3) * delta_time) //the victim may heal a bit but this will quickly kill
			emulsified = TRUE
	if(emulsified)
		adjust_health((health + 3) * delta_time)
		last_feeding = world.time //emulsijack feeds on the emulsion!
	..()
