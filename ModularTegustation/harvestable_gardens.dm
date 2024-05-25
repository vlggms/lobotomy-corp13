//Gardens//
//these guys spawn a variety of seeds at random, slightly weighted. Intended as a stopgap until we can add more custom flora.
/obj/structure/flora/ash/garden
	name = "lush garden"
	gender = NEUTER
	desc = "In the soil and shade, something softly grows."
	icon_state = "garden"
	harvested_name = "lush garden"
	harvested_desc = "In the soil and shade, something softly grew. It seems some industrious scavenger already passed by."
	harvest = /obj/effect/spawner/lootdrop/garden
	harvest_amount_high = 1
	harvest_amount_low = 1
	harvest_message_low = "You discover something nestled away in the growing bough."
	harvest_message_med = "You discover something nestled away in the growing bough."
	harvest_message_high = "You discover something nestled away in the growing bough."
	regrowth_time_low = 20 MINUTES
	regrowth_time_high = 40 MINUTES
	num_sprites = 1
	light_power = 0.5
	light_range = 1
	needs_sharp_harvest = FALSE

/obj/structure/flora/ash/garden/arid
	name = "sandy garden"
	desc = "Beneath a bluff of soft silicate, a sheltered grove slumbers."
	icon_state = "gardenarid"
	harvested_name = "sandy garden"
	harvested_desc = "Beneath a bluff of soft silicate, a sheltered grove slumbered. Some desert wanderer seems to have picked it clean."
	harvest = /obj/effect/spawner/lootdrop/garden/arid
	harvest_amount_high = 1
	harvest_amount_low = 1
	harvest_message_low = "You brush sand away from a verdant prize, nestled in the leaves."
	harvest_message_med = "You brush sand away from a verdant prize, nestled in the leaves."
	harvest_message_high = "You brush sand away from a verdant prize, nestled in the leaves."

/obj/structure/flora/ash/garden/frigid
	name = "chilly garden"
	desc = "A delicate layer of frost covers hardy brush."
	icon_state = "gardencold"
	harvested_name = "chilly garden"
	harvested_desc = "A delicate layer of frost covers hardy brush. Someone came with the blizzard, and left with any prize this might contain."
	harvest = /obj/effect/spawner/lootdrop/garden/cold
	harvest_amount_high = 1
	harvest_amount_low = 1
	harvest_message_low = "You unearth a snow-covered treat."
	harvest_message_med = "You unearth a snow-covered treat."
	harvest_message_high = "You unearth a snow-covered treat."

/obj/structure/flora/ash/garden/waste
	name = "sickly garden"
	desc = "Polluted water wells up from the cracked earth, feeding a patch of something curious."
	icon_state = "gardensick"
	harvested_name = "sickly garden"
	harvested_desc = "Polluted water wells up from the cracked earth, where it once fed a patch of something curious. Now only wilted leaves remain."
	harvest = /obj/effect/spawner/lootdrop/garden/sick
	harvest_amount_high = 1
	harvest_amount_low = 1
	harvest_message_low = "You pry something odd from the poisoned soil."
	harvest_message_med = "You pry something odd from the poisoned soil."
	harvest_message_high = "You pry something odd from the poisoned soil."

/obj/structure/flora/ash/garden/seaweed //yea, i code :)
	name = "seaweed patch"
	gender = NEUTER
	desc = "A patch of seaweed, floating on the surface of the water"
	icon_state = "seaweed"
	harvested_name = "seaweed patch"
	harvested_desc = "A patch of seaweed, floating on the surface of the water. It seems someone has already searched through this"
	harvest = /obj/item/food/seaweed
	harvest_amount_high = 2
	harvest_amount_low = 1
	harvest_message_low = "You discover some edible weeds within the patch."
	harvest_message_med = "You discover some edible weeds within the patch."
	harvest_message_high = "You discover some edible weeds within the patch."

/obj/effect/spawner/lootdrop/garden
	name = "lush garden seeder"
	lootcount = 3
	var/list/plant = list(
		/obj/item/food/grown/citrus/lemon = 2,
		/obj/item/food/grown/citrus/lime = 2,
		/obj/item/food/grown/vanillapod = 2,
		/obj/item/food/grown/cocoapod = 2,
		/obj/item/food/grown/pineapple = 2,
		/obj/item/food/grown/poppy/lily = 2,
		/obj/item/food/grown/poppy/geranium = 2,
		/obj/item/food/grown/sugarcane = 2,
		/obj/item/food/grown/tea = 2,
		/obj/item/food/grown/tobacco = 2,
		/obj/item/food/grown/watermelon = 4,
		/obj/item/grown/sunflower = 4,
		/obj/item/food/grown/banana = 4,
		/obj/item/food/grown/apple = 4,
		/obj/item/food/grown/berries = 5,
		/obj/item/food/grown/cherries = 4,
		/obj/item/food/grown/garlic = 4,
		/obj/item/food/grown/grapes = 4,
		/obj/item/food/grown/grass = 5,
		/obj/item/food/grown/pumpkin = 4,
		/obj/item/food/grown/rainbow_flower = 4,
		/obj/item/food/grown/wheat = 4,
		/obj/item/food/grown/parsnip = 4,
		/obj/item/food/grown/peas = 4,
		/obj/item/food/grown/rice = 4,
		/obj/item/food/grown/soybeans = 4,
		/obj/item/food/grown/tomato = 4,
		/obj/item/food/grown/cabbage = 4,
		/obj/item/food/grown/onion = 4,
		/obj/item/food/grown/carrot = 4,
		)

/obj/effect/spawner/lootdrop/garden/Initialize(mapload)
	loot = plant
	return ..()

/obj/effect/spawner/lootdrop/garden/arid
	name = "arid garden seeder"
	lootcount = 2
	plant = list(
		/obj/item/food/grown/nettle = 1,
		/obj/item/seeds/random = 1,
		/obj/item/food/grown/redbeet = 1,
		/obj/item/food/grown/aloe = 2,
		/obj/item/grown/cotton = 2,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/grown/whitebeet = 5,
		/obj/item/food/grown/potato = 4,
		/obj/item/food/grown/potato/sweet = 4,
		/obj/item/food/grown/mushroom/chanterelle = 4,
		/obj/item/food/grown/mushroom/plumphelmet = 4,
		/obj/item/food/grown/corn = 4,
		)

/obj/effect/spawner/lootdrop/garden/cold
	name = "frigid garden seeder"
	lootcount = 2
	plant = list(
		/obj/item/food/grown/bluecherries = 1,
		/obj/item/food/grown/poppy = 2,
		/obj/item/food/grown/berries = 4,
		/obj/item/food/grown/mushroom/chanterelle = 4,
		/obj/item/food/grown/oat = 4,
		/obj/item/food/grown/grapes/green = 4,
		/obj/item/food/grown/grass = 4,
		/obj/item/food/grown/harebell = 5,
		/obj/item/seeds/starthistle = 5,
		)

/obj/effect/spawner/lootdrop/garden/sick
	name = "sickly garden seeder"
	lootcount = 1
	plant = list(
		/obj/item/food/grown/mushroom/amanita = 4,
		/obj/item/food/grown/mushroom/reishi = 4,
		/obj/item/stack/sheet/cardboard = 4,
		/obj/item/stack/sheet/bone = 1,
		)

/obj/item/food/seaweed
	name = "seaweed"
	desc = "It's so rubbery... is this safe to eat?"
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "seaweed"
	foodtypes = VEGETABLES
	food_reagents = list(/datum/reagent/water = 0.5, /datum/reagent/consumable/salt = 0.4, /datum/reagent/consumable/nutriment = 2)
