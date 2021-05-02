/****** MINER KITS ******/
/obj/item/storage/backpack/duffelbag/space_exploration
	name = "space exploration kit"
	desc = "A kit containing everything a miner needs to qualify for space exploration."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/space_exploration/PopulateContents()
	new /obj/item/clothing/suit/space/hardsuit/mining/compact(src)
	new /obj/item/tank/jetpack/oxygen/harness(src)
	new /obj/item/tank/internals/oxygen(src)
	new /obj/item/binoculars(src)
	new /obj/item/gps/mining(src)

/obj/item/clothing/suit/space/hardsuit/mining/compact
	name = "compact mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Although similar to normal mining harsduit, this one seems to be much weaker."
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 100, RAD = 15, FIRE = 60, ACID = 30, WOUND = 5)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/mining/compact

/obj/item/clothing/head/helmet/space/hardsuit/mining/compact
	name = "compact mining hardsuit helmet"
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 100, RAD = 15, FIRE = 60, ACID = 30, WOUND = 5)

/****** SPACE LOOT ******/
/////// SPACE SUITS //////
// A variable for space loot, so these are less armored.
/obj/item/clothing/head/helmet/space
	var/frail = FALSE

/obj/item/clothing/head/helmet/space/Initialize()
	if(frail)
		name = "frail [name]"
		desc += " This one is rather frail."
		armor = list(MELEE = 25, BULLET = 35, LASER = 20, ENERGY = 25, BOMB = 20, BIO = 20, RAD = 30, FIRE = 50, ACID = 50)
	. = ..()

/obj/item/clothing/suit/space/syndicate
	var/frail = FALSE

/obj/item/clothing/suit/space/syndicate/Initialize()
	if(frail)
		name = "frail [name]"
		desc += " This one is rather frail."
		armor = list(MELEE = 25, BULLET = 35, LASER = 20, ENERGY = 25, BOMB = 20, BIO = 20, RAD = 30, FIRE = 50, ACID = 50)
		slowdown += 0.1
	. = ..()

/////// RESEARCH ///////
// Actual Research Stuff
/datum/techweb_node/anomaly_weaponry
	id = "anomaly_weaponry"
	display_name = "Anomalous Weaponry"
	description = "A highly advanced research, rumored to be of an alien origin."
	prereq_ids = list("anomaly_research", "adv_weaponry")
	design_ids = list("vortex_gun", "flux_sword")
	boost_item_paths = list(/obj/item/gun/energy/vortex_gun, /obj/item/melee/flux_sword, \
	/obj/item/clothing/suit/armor/abductor/vest, /obj/item/gun/energy/alien, /obj/item/gun/energy/shrink_ray, \
	/obj/item/assembly/signaler/anomaly/vortex, /obj/item/assembly/signaler/anomaly/flux)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
	hidden = TRUE

/datum/techweb_node/anomaly_tools
	id = "anomaly_tools"
	display_name = "Anomalous Tools Research"
	description = "Expensive tools that utilize anomalous properties to solve modern engineering problems."
	prereq_ids = list("anomaly_research", "exp_tools")
	design_ids = list("rcd_bluespace", "magboots_anomaly")
	boost_item_paths = list(/obj/item/construction/rcd/arcd/bluespace, /obj/item/clothing/shoes/magboots/noslow, \
	/obj/item/assembly/signaler/anomaly/bluespace, /obj/item/assembly/signaler/anomaly/grav)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	hidden = TRUE

// Items
/obj/item/research_notes/loot/Initialize()
	value = rand(500, 2500)
	origin_type = pick("syndicate research", "anomaly research", "galactic research", "cybersun research", "alien research")
	..()

// Lootdrop
/obj/effect/spawner/lootdrop/space/research
	name = "research space loot"
	lootcount = 1
	loot = list(
				/obj/item/research_notes/loot = 3,
				/obj/item/relic = 1
	)
