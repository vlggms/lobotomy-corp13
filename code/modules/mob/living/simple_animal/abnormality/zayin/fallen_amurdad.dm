//Coded and sprited by Coxswain
/mob/living/simple_animal/hostile/abnormality/fallen_amurdad
	name = "Fallen Amurdad"
	desc = "This person is unresponsive, bleeding, and covered in plants."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "amurdad"
	icon_living = "amurdad"
	threat_level = ZAYIN_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
						ABNORMALITY_WORK_INSIGHT = 70,
						ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
						ABNORMALITY_WORK_REPRESSION = list(70, 60, 50, 50, 50)
						)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/nightshade,
		/datum/ego_datum/armor/nightshade
		)
	gift_type = /datum/ego_gifts/nightshade
	gift_message = "The lifeless body of amurdad hands you a flower."
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	var/seed_list = list(
		/obj/item/seeds/grass/fairy/amurdad,
		/obj/item/seeds/apple/gold/amurdad,
		/obj/item/seeds/ambrosia/gaia/amurdad,
		/obj/item/seeds/wheat/meat,
		/obj/item/seeds/cherry/bulb/amurdad,
		/obj/item/seeds/corn/snapcorn,
		/obj/item/seeds/cocoapod/bungotree/amurdad,
		/obj/item/seeds/cocoapod/vanillapod/amurdad,
		/obj/item/seeds/tobacco/space,
		/obj/item/seeds/berry/glow/amurdad,
		/obj/item/seeds/cannabis/white/amurdad,
		/obj/item/seeds/harebell,
		/obj/item/seeds/amanita/amurdad,
		/obj/item/seeds/starthistle/amurdad,
		/obj/item/seeds/galaxythistle/amurdad,
		/obj/item/seeds/peas/worldpeas,
		/obj/item/seeds/corpseflower,
		/obj/item/seeds/jupitercup
		)

//Start us off with some soil trays and grass
/mob/living/simple_animal/hostile/abnormality/fallen_amurdad/PostSpawn()
	..()
	var/list/soil_area = range(1, src)
	if((locate(/obj/machinery/hydroponics/soil/amurdad) in soil_area))
		return
	for(var/turf/open/O in soil_area)
		new /obj/effect/amurdad_grass(O)
	for(var/dir in GLOB.alldirs)
		var/turf/T = get_step(src, dir)
		new /obj/machinery/hydroponics/soil/amurdad(T)

//Work-related code
/mob/living/simple_animal/hostile/abnormality/fallen_amurdad/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	..()
	if(canceled)
		return
	for(var/obj/machinery/hydroponics/soil/amurdad/S in range(1, src))
		if(S.myseed)
			continue
		S.Fill(pick(seed_list))
		if(prob(30))
			break

//Magic bullshit amurdad soil
/obj/machinery/hydroponics/soil/amurdad
	self_sustaining = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/hydroponics/soil/amurdad/proc/Fill(seed) //abnormality plants seeds for you
	myseed = new seed
	dead = FALSE
	age = 1
	plant_health = myseed.endurance
	lastcycle = world.time
	update_icon()
	TRAY_NAME_UPDATE
	return

/obj/machinery/hydroponics/soil/amurdad/adjustWeeds(adjustamt) //no weeds!
	return

/obj/machinery/hydroponics/soil/amurdad/attackby(obj/item/O, mob/user, params) //no manual planting
	if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/sample))
		return
	if(O.tool_behaviour == TOOL_SHOVEL && !istype(O, /obj/item/shovel/spade)) //no digging it up either
		return
	..()

/obj/effect/amurdad_grass
	name = "grass"
	desc = "A thick layer of foilage that never seems to die down."
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass0"
	layer = TURF_LAYER
	anchored = TRUE

/obj/effect/amurdad_grass/Initialize()
	. = ..()
	icon_state = "grass[rand(0,3)]"

//Special seeds, no repeat harvest
/obj/item/seeds/grass/fairy/amurdad
	genes = list(/datum/plant_gene/trait/glow/blue)

/obj/item/seeds/apple/gold/amurdad
	genes = list(/datum/plant_gene/trait/glow/yellow)

/obj/item/seeds/ambrosia/gaia/amurdad
	genes = list()

/obj/item/seeds/cherry/bulb/amurdad
	genes = list()

/obj/item/seeds/cocoapod/bungotree/amurdad
	genes = list()

/obj/item/seeds/cocoapod/vanillapod/amurdad
	genes = list()

// Non-toxic varieties of normal plants
/obj/item/seeds/berry/glow/amurdad
	genes = list(/datum/plant_gene/trait/glow/white)
	reagents_add = list(/datum/reagent/iodine = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/cannabis/white/amurdad
	genes = list()
	reagents_add = list(/datum/reagent/drug/space_drugs = 0.15, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/amanita/amurdad
	reagents_add = list(/datum/reagent/drug/space_drugs = 0.15, /datum/reagent/consumable/nutriment = 0.04)

// Modified Weeds
/obj/item/seeds/starthistle/amurdad
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	product = /obj/item/food/grown/starthistle

/obj/item/food/grown/starthistle
	seed = /obj/item/seeds/starthistle/amurdad
	name = "starthistle flower head"
	desc = "This spiny cluster of florets reminds you of the backstreets."
	icon_state = "lily"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	wine_power = 35
	tastes = list("thistle" = 2, "artichoke" = 1)

/obj/item/seeds/galaxythistle/amurdad
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)

// Custom plants
/obj/item/seeds/peas/worldpeas
	name = "pack of world peas"
	desc = "These seeds look a bit odd, but they should grow into World Peas."
	icon_state = "seed-worldpeas"
	species = "worldpeas"
	plantname = "World Peas"
	product = /obj/item/food/grown/worldpeas
	maturation = 7
	potency = 10
	yield = 7
	production = 5
	growthstages = 3
	icon_grow = "worldpeas-grow"
	icon_dead = "worldpeas-dead"
	genes = list ()
	mutatelist = list ()
	reagents_add = list (/datum/reagent/consumable/sugar = 0.05, /datum/reagent/consumable/nutriment = 0.07, /datum/reagent/abnormality/wellcheers_zero = 0.07)
	rarity = 30

/obj/item/food/grown/worldpeas
	seed = /obj/item/seeds/peas/worldpeas
	name = "pod of world peas"
	desc = "They make the world go round. Not sure what sort of effects eating this might have..."
	icon_state = "worldpeas"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	tastes = list ("an oyster" = 1)
	wine_power = 90
	wine_flavor = "a drunken oyster... or maybe a clam?"

/obj/item/seeds/corpseflower
	name = "pack of corpseflower"
	desc = "These seeds grow into a big, smelly flower."
	icon_state = "seed-corpse-flower"
	species = "corpseflower"
	plantname = "Corpse Flower"
	product = /obj/item/food/grown/corpseflower
	lifespan = 100
	endurance = 20
	maturation = 7
	production = 1
	yield = 2
	potency = 30
	instability = 1
	growthstages = 4
	icon_grow = "corpse-flower-grow"
	icon_dead = "corpse-flower-dead"
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/abnormality/quiet_day = 0.07)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/food/grown/corpseflower
	seed = /obj/item/seeds/corpseflower
	name = "corpse flower pedal"
	desc = "A gigantic corpse flower pedal, it smells disgusting. Noticably used as a spice in district 23."
	icon_state = "corpseflower"
	bite_consumption_mod = 3
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth
	tastes = list ("a corpse" = 4, "long pig" = 2)
	wine_power = 90
	wine_flavor = "a corpse, or maybe a pile of them."

/obj/item/seeds/jupitercup
	name = "pack of jupiter-cup mycelium"
	desc = "This mycelium grows into jupiter-cup mushrooms."
	icon_state = "mycelium-jupitercup"
	species = "jupitercup"
	plantname = "Jupiter-Cups"
	product = /obj/item/food/grown/mushroom/jupitercup
	maturation = 7
	production = 1
	yield = 5
	potency = 15
	instability = 10
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07, /datum/reagent/abnormality/we_can_change_anything = 0.07)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/jupitercup
	seed = /obj/item/seeds/jupitercup
	name = "jupiter-cup"
	desc = "This has to be eaten carefully."
	icon_state = "jupitercup"
