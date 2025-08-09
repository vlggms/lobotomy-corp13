//This file is a disaster
//Might be better to not look at it

/obj/structure/rcorp_factory
	name = "low level factory"
	desc = "A machine used to craft items."
	icon = 'ModularTegustation/Teguicons/factory.dmi'
	icon_state = "rcorp_factory"
	icon_state = "lowfactory"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/unlocked = 1	//Did you buy it with techpoints?
	var/initialmaterial = 0	//Did you put materials in it at all?
	var/productiontime = 2 SECONDS

	var/gmaterial = 0
	var/rmaterial = 0
	var/bmaterial = 0
	var/pmaterial = 0
	var/smaterial = 0
	var/omaterial = 0

	var/gcost = 0
	var/rcost = 0
	var/bcost = 0
	var/pcost = 0
	var/scost = 0
	var/ocost = 0

	var/obj/item = /obj/item/ksyringe	//What item you spawn
	var/itemnumber = 1				//How many you're spawning per cost paid
	var/bankeditems = 0				//How many items we're currently spawning
	var/chance_eat = 100			//What's the chance of eating materials
	var/max = 20

/obj/structure/rcorp_factory/examine(mob/user)
	. = ..()
	if(!unlocked)
		. += span_notice("This machine requires an upgrade chip to be used.")
	if(gcost)
		. += span_notice("This machine requires [gcost]/[gmaterial] green materials to be used.")
	if(rcost)
		. += span_notice("This machine requires [rcost]/[rmaterial] red materials to be used.")
	if(bcost)
		. += span_notice("This machine requires [bcost]/[bmaterial] blue materials to be used.")
	if(pcost)
		. += span_notice("This machine requires [pcost]/[pmaterial] purple materials to be used.")
	if(scost)
		. += span_notice("This machine requires [scost]/[smaterial] silver materials to be used.")
	if(ocost)
		. += span_notice("This machine requires [ocost]/[omaterial] orange materials to be used.")
	if(item)
		. += span_notice("This machine will produce [itemnumber] [item.name] when the materials are given.")
	. += span_notice("This machine will take a maximum of [max] of each material that pass over it. Use a wrench to change this.")


/obj/structure/rcorp_factory/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.tool_behaviour != TOOL_WRENCH)
		return

	var/set_max = input(user, "What is the max amount of materials that you want this to store (1-100)?", "Set Max") as null|num
	if(set_max && (set_max > 0 && set_max <= 100))
		max = set_max
		to_chat(user, "<span class='notice'>You set the factory to eat [max] of items.</span>")


/obj/structure/rcorp_factory/Crossed(atom/movable/AM)
	. = ..()
	if(!unlocked)
		return

	if(istype(AM, /obj/item/factoryitem/green) && gcost && gmaterial<=max)
		gmaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/red) && rcost && rmaterial<=max)
		rmaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/blue) && bcost && bmaterial<=max)
		bmaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/purple) && pcost && pmaterial<=max)
		pmaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/orange) && ocost && omaterial<=max)
		omaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/silver) && scost && smaterial<=max)
		smaterial+=1
		qdel(AM)

	if(!initialmaterial)
		initialmaterial=1
		addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)

/obj/structure/rcorp_factory/proc/spit_item()
	addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)
	if(bankeditems)
		bankeditems-=1
		new item(src.loc)

	if(gcost>gmaterial)
		return
	if(rcost>rmaterial)
		return
	if(bcost>bmaterial)
		return
	if(pcost>pmaterial)
		return
	if(ocost>omaterial)
		return
	if(scost>smaterial)
		return


	gmaterial-=gcost
	rmaterial-=rcost
	bmaterial-=bcost
	pmaterial-=pcost
	smaterial-=scost
	omaterial-=ocost
	bankeditems+=itemnumber
