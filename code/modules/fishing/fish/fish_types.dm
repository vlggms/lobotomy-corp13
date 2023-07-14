// Freshwater fish

/obj/item/food/fish/goldfish
	name = "goldfish"
	desc = "Despite common belief, goldfish do not have three-second memories. They can actually remember things that happened up to three months ago."
	habitat = "Bodies of Freshwater"
	icon_state = "goldfish"
	sprite_width = 8
	sprite_height = 8
	stable_population = 3
	average_size = 30
	average_weight = 500

/obj/item/food/fish/angelfish
	name = "angelfish"
	desc = "Young Angelfish often live in groups, while adults prefer solitary life. They become territorial and aggressive toward other fish when they reach adulthood."
	habitat = "Bodies of Freshwater"
	icon_state = "angelfish"
	dedicated_in_aquarium_icon_state = "bigfish"
	sprite_height = 7
	source_height = 7
	average_size = 30
	average_weight = 500
	stable_population = 3

/obj/item/food/fish/guppy
	name = "guppy"
	desc = "Guppy is also known as rainbow fish because of the brightly colored body and fins."
	habitat = "Bodies of Freshwater"
	icon_state = "guppy"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#91AE64"
	sprite_width = 8
	sprite_height = 5
	average_size = 30
	average_weight = 500
	stable_population = 6

/obj/item/food/fish/plasmatetra
	name = "plasma tetra"
	desc = "Due to their small size, tetras are prey to many predators in their watery world, including eels, crustaceans, and invertebrates."
	habitat = "Bodies of Freshwater"
	icon_state = "plastetra"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#D30EB0"
	average_size = 30
	average_weight = 500
	stable_population = 3

/obj/item/food/fish/catfish
	name = "cory catfish"
	desc = "A catfish has about 100,000 taste buds, and their bodies are covered with them to help detect chemicals present in the water and also to respond to touch."
	habitat = "Bodies of Freshwater"
	icon_state = "catfish"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#907420"
	average_size = 100
	average_weight = 2000
	stable_population = 3

// Saltwater fish below

/obj/item/food/fish/clownfish
	name = "clownfish"
	desc = "Clownfish catch prey by swimming onto the reef, attracting larger fish, and luring them back to the anemone. The anemone will sting and eat the larger fish, leaving the remains for the clownfish."
	habitat = "Ocean"
	icon_state = "clownfish"
	dedicated_in_aquarium_icon_state = "clownfish_small"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 5
	average_size = 30
	average_weight = 500
	stable_population = 4

/obj/item/food/fish/cardinal
	name = "cardinalfish"
	desc = "Cardinalfish are often found near sea urchins, where the fish hide when threatened."
	habitat = "Ocean"
	icon_state = "cardinalfish"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 4

/obj/item/food/fish/greenchromis
	name = "green chromis"
	desc = "The Chromis can vary in color from blue to green depending on the lighting and distance from the lights."
	habitat = "Ocean"
	icon_state = "greenchromis"
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#00ff00"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 5

/obj/item/food/fish/firefish
	name = "firefish goby"
	desc = "To communicate in the wild, the firefish uses its dorsal fin to alert others of potential danger."
	habitat = "Ocean"
	icon_state = "firefish"
	sprite_width = 6
	sprite_height = 5
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 3

/obj/item/food/fish/pufferfish
	name = "pufferfish"
	desc = "One Pufferfish contains enough toxins in its liver to kill 30 people."
	habitat = "Ocean"
	icon_state = "pufferfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 8
	average_size = 60
	average_weight = 1000
	stable_population = 3

/obj/item/food/fish/lanternfish
	name = "lanternfish"
	desc = "Typically found in areas below 6600 feet below the surface of the ocean, they live in complete darkness."
	habitat = "Ocean"
	icon_state = "lanternfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	random_case_rarity = FISH_RARITY_VERY_RARE
	source_width = 28
	source_height = 21
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 1500
	stable_population = 3

/obj/item/storage/box/fish_debug
	name = "box full of fish"

/obj/item/storage/box/fish_debug/PopulateContents()
	for(var/fish_type in subtypesof(/obj/item/food/fish))
		new fish_type(src)

/obj/item/food/fish/emulsijack
	name = "toxic emulsijack"
	desc = "Ah, the terrifying emulsijack. Created in a laboratory, this slimey, scaleless fish emits an invisible toxin that emulsifies other fish for it to feed on. Its only real use is for completely ruining a tank."
	habitat = "Invading Other Habitats"
	icon_state = "emulsijack"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	stable_population = 3

/obj/item/food/fish/emulsijack/process(seconds_per_tick)
	var/emulsified = FALSE
	var/obj/structure/aquarium/aquarium = loc
	if(istype(aquarium))
		for(var/obj/item/food/fish/victim in aquarium)
			if(istype(victim, /obj/item/food/fish/emulsijack))
				continue //no team killing
			victim.adjust_health((victim.health - 3) * seconds_per_tick) //the victim may heal a bit but this will quickly kill
			emulsified = TRUE
	if(emulsified)
		adjust_health((health + 3) * seconds_per_tick)
		last_feeding = world.time //emulsijack feeds on the emulsion!
	..()

/obj/item/food/fish/ratfish
	name = "ratfish"
	desc = "A rat exposed to the murky waters of maintenance too long. Any higher power, if it revealed itself, would state that the ratfish's continued existence is extremely unwelcome."
	habitat = "Filth, Rare in Freshwater"
	icon_state = "ratfish"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_RARE
	required_fluid_type = AQUARIUM_FLUID_FRESHWATER
	stable_population = 4 //set by New, but this is the default config value
	fillet_type = /obj/item/food/meat/slab/human/mutant/zombie //eww...

//LC13
	//FRESHWATER
/obj/item/food/fish/yang
	name = "yang carp"
	desc = "A unique breed of carp that is themed around yang. The philosophical concept of yang is characterized by masculinity, the sun, light, and activity."
	habitat = "Freshwater"
	icon_state = "yangfish"
	random_case_rarity = FISH_RARITY_VERY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 6803

/obj/item/food/fish/yin
	name = "yin carp"
	desc = "A unique breed of carp that is themed around yin. The philosophical concept of yin is characterized by femininity, the moon, darkness, and disintigration."
	habitat = "Freshwater"
	icon_state = "yinfish"
	random_case_rarity = FISH_RARITY_VERY_RARE
	sprite_width = 8
	sprite_height = 8
	average_size = 50
	average_weight = 6803

/obj/item/food/fish/waterflea
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

/obj/item/food/fish/northernpike
	name = "northern pike"
	desc = "Northern pike are territorial predators that ambush prey with a burst of speed, pikes can move upto ten miles per hour while ambushing prey."
	habitat = "Freshwater"
	icon_state = "northernpike"
	random_case_rarity = FISH_RARITY_VERY_RARE
	sprite_width = 8
	sprite_height = 4
	average_size = 91
	average_weight = 9071

	//SALTWATER
/obj/item/food/fish/sheephead
	name = "california sheephead"
	desc = "California Sheepheads are unique in the fact that they are protogynous hermaphrodites, born female and become male as they mature."
	habitat = "Ocean"
	icon_state = "sheephead"
	random_case_rarity = FISH_RARITY_RARE
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 8
	average_size = 91
	average_weight = 16000
	stable_population = 3

/obj/item/food/fish/bluefintuna
	name = "bluefin tuna"
	desc = "Bluefins are the largest type of tuna and migrate across all oceans."
	habitat = "Ocean"
	icon_state = "bluefintuna"
	random_case_rarity = FISH_RARITY_RARE
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 8
	average_size = 149.86
	average_weight = 226796
	stable_population = 3

/obj/item/food/fish/marine_shrimp
	name = "marine shrimp"
	desc = "Shrimp are omnivores and act as primary consumers, mostly consisting off of algae, plankten, and whatever organic material they can scavenge."
	habitat = "Ocean"
	icon_state = "shrimp"
	dedicated_in_aquarium_icon_state = "shrimp_fish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 2
	average_weight = 2
	stable_population = 5
	feeding_frequency = 25 MINUTES
	microwaved_type = /obj/item/food/meat/crab
	fillet_type = /obj/item/food/meat/rawcrab

//Mutations
/obj/item/food/fish/pmermaid
	name = "lovestruck fish"
	desc = "A carp that seems to have survived exposure to Picene Mermaids water. It seems to have consumed its own pectoral fins."
	habitat = "Saltwater"
	icon_state = "mermaid"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_VERY_RARE
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 16000
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/organ_tissue = 1, /datum/reagent/consumable/salt = 8)

/obj/item/food/fish/msob
	name = "mountain of smiling fish"
	desc = "This mass attempts to bite onto detris and living organisms in order to increase its size. If it wasnt for the uncanny resemblence to T-01-75 this would be written off as a product of nature, but this is clearly a mutation brought upon by exposure."
	habitat = "Freshwater"
	icon_state = "msob"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_VERY_RARE
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	sprite_width = 8
	sprite_height = 8
	average_size = 100
	average_weight = 16000
	food_reagents = list(/datum/reagent/medicine/mental_stabilizator = 2, /datum/reagent/consumable/nutriment/vile_fluid = 6)
