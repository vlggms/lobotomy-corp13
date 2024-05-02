
/**
 *
 * Modular file containing: Freshwater fish
 *
 */

/obj/item/food/fish/fresh_water
	name = "goldfish"
	desc = "Despite common belief, goldfish do not have three-second memories. They can actually remember things that happened up to three months ago."
	habitat = "Bodies of Freshwater"
	icon_state = "goldfish"
	fillet_type = /obj/item/food/freshfish/white
	sprite_width = 8
	sprite_height = 8
	stable_population = 3
	average_size = 30
	average_weight = 500

/obj/item/food/fish/fresh_water/bass
	name = "largemouth bass"
	desc = "A large, carnivorous freshwater fish known for thriving in most environments and being popular amongst sport fishers."
	icon_state = "bass"
	fillet_type = /obj/item/food/freshfish/white
	average_size = 40
	average_weight = 5000
	stable_population = 3

/obj/item/food/fish/trout
	name = "steelhead trout"
	desc = "A species of coastal trout closely related to salmon and with a deep history of being used as a source of food."
	icon_state = "trout"
	fillet_type = /obj/item/food/freshfish/white
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	average_size = 60
	average_weight = 12000
	stable_population = 3

/obj/item/food/fish/fresh_water/perch
	name = "perch"
	desc = "A relatively small, yet common, species of predatory fish."
	icon_state = "perch"
	fillet_type = /obj/item/food/freshfish/white
	average_size = 20
	average_weight = 900
	stable_population = 6

/obj/item/food/fish/fresh_water/angelfish
	name = "angelfish"
	desc = "Young Angelfish often live in groups, while adults prefer solitary life. They become territorial and aggressive toward other fish when they reach adulthood."
	icon_state = "angelfish"
	fillet_type = /obj/item/food/freshfish/white
	dedicated_in_aquarium_icon_state = "bigfish"
	sprite_height = 7
	source_height = 7

/obj/item/food/fish/fresh_water/guppy
	name = "guppy"
	desc = "Guppy is also known as rainbow fish because of their brightly colored body and fins."
	icon_state = "guppy"
	fillet_type = /obj/item/food/freshfish/white
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#91AE64"
	sprite_width = 8
	sprite_height = 5
	stable_population = 6

/obj/item/food/fish/fresh_water/plasmatetra
	name = "plasma tetra"
	desc = "Due to their small size, tetras are prey to many predators in their watery world, including eels, crustaceans, and invertebrates."
	icon_state = "plastetra"
	fillet_type = /obj/item/food/freshfish/white
	dedicated_in_aquarium_icon_state = "fish_greyscale"
	aquarium_vc_color = "#D30EB0"

/obj/item/food/fish/fresh_water/catfish
	name = "cory catfish"
	desc = "A catfish has about 100,000 taste buds, and their bodies are covered with them to help detect chemicals present in the water and also to respond to touch."
	icon_state = "catfish"
	fillet_type = /obj/item/food/freshfish/white
	average_size = 100
	average_weight = 2000

/obj/item/food/fish/fresh_water/ratfish
	name = "ratfish"
	desc = "A rat exposed to the murky waters of maintenance too long. Any higher power, if it revealed itself, would state that the ratfish's continued existence is extremely unwelcome."
	habitat = "Filth, Rare in Freshwater"
	icon_state = "ratfish"
	show_in_catalog = FALSE
	random_case_rarity = FISH_RARITY_RARE
	stable_population = 4 //set by New, but this is the default config value
	fillet_type = /obj/item/food/freshfish/rotten
