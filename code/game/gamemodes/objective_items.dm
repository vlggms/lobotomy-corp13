//Contains the target item datums for Steal objectives.

/datum/objective_item
	var/name = "A silly bike horn! Honk!"
	var/targetitem = /obj/item/bikehorn		//typepath of the objective item
	var/difficulty = 9001							//vaguely how hard it is to do this objective
	var/list/excludefromjob = list()				//If you don't want a job to get a certain objective (no captain stealing his own medal, etcetc)
	var/list/altitems = list()				//Items which can serve as an alternative to the objective (darn you blueprints)
	var/list/special_equipment = list()

/datum/objective_item/proc/check_special_completion() //for objectives with special checks (is that slime extract unused? does that intellicard have an ai in it? etcetc)
	return 1

/datum/objective_item/proc/TargetExists()
	return TRUE

/datum/objective_item/steal/New()
	..()
	if(TargetExists())
		GLOB.possible_items += src
	else
		qdel(src)

/datum/objective_item/steal/Destroy()
	GLOB.possible_items -= src
	return ..()

/datum/objective_item/steal/manager_docs
	name = "The manager's Highly Confidential Folder"
	targetitem = /obj/item/folder/syndicate/blue
	difficulty = 5
	excludefromjob = list("Manager")

/datum/objective_item/steal/ro_watch
	name = "one of the Record Officer's watches"
	targetitem = /obj/item/records
	difficulty = 5
	excludefromjob = list("Records Officer")

/datum/objective_item/steal/medal
	name = "one of the manager's medals"
	targetitem = /obj/item/clothing/accessory/medal
	difficulty = 3 //Almost no manager actually uses these anyways
	excludefromjob = list("Manager")

/datum/objective_item/steal/skub
	name = "skub"
	targetitem = /obj/item/skub
	difficulty = 2 //Skub can be gotten from the Seph vendors or EO console
	excludefromjob = list("Extraction Officer")

/datum/objective_item/steal/cactus
	name = "the manager's cactus"
	targetitem = /obj/item/food/grown/star_cactus
	difficulty = 5
	excludefromjob = list("Manager")

//Unique Objectives
/datum/objective_item/special/New()
	..()
	if(TargetExists())
		GLOB.possible_items_special += src
	else
		qdel(src)

/datum/objective_item/special/Destroy()
	GLOB.possible_items_special -= src
	return ..()

//Old ninja objectives.
/datum/objective_item/special/pinpointer
	name = "the captain's pinpointer."
	targetitem = /obj/item/pinpointer/nuke
	difficulty = 10

/datum/objective_item/special/aegun
	name = "an advanced energy gun."
	targetitem = /obj/item/gun/energy/e_gun/nuclear
	difficulty = 10

/datum/objective_item/special/ddrill
	name = "a diamond drill."
	targetitem = /obj/item/pickaxe/drill/diamonddrill
	difficulty = 10

/datum/objective_item/special/boh
	name = "a bag of holding."
	targetitem = /obj/item/storage/backpack/holding
	difficulty = 10

/datum/objective_item/special/hypercell
	name = "a hyper-capacity power cell."
	targetitem = /obj/item/stock_parts/cell/hyper
	difficulty = 5

/datum/objective_item/special/laserpointer
	name = "a laser pointer."
	targetitem = /obj/item/laser_pointer
	difficulty = 5

/datum/objective_item/special/corgimeat
	name = "a piece of corgi meat."
	targetitem = /obj/item/food/meat/slab/corgi
	difficulty = 5

/datum/objective_item/stack/New()
	..()
	if(TargetExists())
		GLOB.possible_items_special += src
	else
		qdel(src)

/datum/objective_item/stack/Destroy()
	GLOB.possible_items_special -= src
	return ..()

//Stack objectives get their own subtype
/datum/objective_item/stack
	name = "5 cardboard."
	targetitem = /obj/item/stack/sheet/cardboard
	difficulty = 9001

/datum/objective_item/stack/check_special_completion(obj/item/stack/S)
	var/target_amount = text2num(name)
	var/found_amount = 0

	if(istype(S, targetitem))
		found_amount = S.amount
	return found_amount>=target_amount
