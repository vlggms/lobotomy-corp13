//This file is a disaster
//Might be better to not look at it


/obj/structure/lowfactory
	name = "low level factory"
	desc = "A machine used to craft items."
	icon = 'ModularTegustation/Teguicons/factory.dmi'
	icon_state = "lowfactory"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/unlocked = 1	//Did you buy it with techpoints?
	var/initialmaterial = 0	//Did you put materials in it at all?
	var/productiontime = 2 SECONDS

	var/gmaterial = 0
	var/rmaterial = 0
	var/gcost = 0
	var/rcost = 0

	var/obj/item = /obj/item/ksyringe	//What item you spawn
	var/itemnumber = 1				//How many you're spawning per cost paid
	var/bankeditems = 0				//How many items we're currently spawning

/obj/structure/lowfactory/examine(mob/user)
	. = ..()
	if(!unlocked)
		. += "This machine requires an upgrade chip to be used."
	if(gcost)
		. += "This machine requires [gcost]/[gmaterial] green materials to be used."
	if(rcost)
		. += "This machine requires [rcost]/[rmaterial] red materials to be used."
	if(item)
		. += "This machine will produce [itemnumber] [item.name] when the materials are given."

/obj/structure/lowfactory/Crossed(atom/movable/AM)
	. = ..()
	if(!unlocked)
		return

	if(istype(AM, /obj/item/factoryitem/green) && gcost)
		gmaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/red) && rcost)
		rmaterial+=1
		qdel(AM)

	if(!initialmaterial)
		initialmaterial=1
		addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)

/obj/structure/lowfactory/proc/spit_item()
	addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)
	if(bankeditems)
		bankeditems-=1
		new item(src.loc)

	if(gcost>gmaterial)
		return
	if(rcost>rmaterial)
		return

	gmaterial-=gcost
	rmaterial-=rcost
	bankeditems+=itemnumber

//The midfactory
/obj/structure/midfactory
	name = "mid level factory"
	desc = "A machine used to craft items."
	icon = 'ModularTegustation/Teguicons/factory.dmi'
	icon_state = "midfactory"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/unlocked = 1	//Did you buy it with techpoints?
	var/initialmaterial = 0	//Did you put materials in it at all?
	var/productiontime = 2 SECONDS

	var/bmaterial = 0
	var/pmaterial = 0
	var/bcost = 0
	var/pcost = 0

	var/obj/item = /obj/item/ksyringe	//What item you spawn
	var/itemnumber = 1				//How many you're spawning per cost paid
	var/bankeditems = 0				//How many items we're currently spawning

/obj/structure/midfactory/examine(mob/user)
	. = ..()
	if(!unlocked)
		. += "This machine requires an upgrade chip to be used."
	if(bcost)
		. += "This machine requires [bcost]/[bmaterial] blue materials to be used."
	if(pcost)
		. += "This machine requires [pcost]/[pmaterial] purple materials to be used."
	if(item)
		. += "This machine will produce [itemnumber] [item.name] when the materials are given."

/obj/structure/midfactory/Crossed(atom/movable/AM)
	. = ..()
	if(!unlocked)
		return

	if(istype(AM, /obj/item/factoryitem/blue) && bcost)
		bmaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/purple) && pcost)
		pmaterial+=1
		qdel(AM)

	if(!initialmaterial)
		initialmaterial=1
		addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)

/obj/structure/midfactory/proc/spit_item()
	addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)
	if(bankeditems)
		bankeditems-=1
		new item(src.loc)

	if(bcost>bmaterial)
		return
	if(pcost>pmaterial)
		return

	bmaterial-=bcost
	pmaterial-=pcost
	bankeditems+=itemnumber


//The highfactory
/obj/structure/highfactory
	name = "high level factory"
	desc = "A machine used to craft items."
	icon = 'ModularTegustation/Teguicons/factory.dmi'
	icon_state = "highfactory"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/unlocked = 1	//Did you buy it with techpoints?
	var/initialmaterial = 0	//Did you put materials in it at all?
	var/productiontime = 2 SECONDS

	var/omaterial = 0
	var/smaterial = 0
	var/ocost = 0
	var/scost = 0

	var/obj/item = /obj/item/ksyringe	//What item you spawn
	var/itemnumber = 1				//How many you're spawning per cost paid
	var/bankeditems = 0				//How many items we're currently spawning

/obj/structure/highfactory/examine(mob/user)
	. = ..()
	if(!unlocked)
		. += "This machine requires an upgrade chip to be used."
	if(ocost)
		. += "This machine requires [ocost]/[omaterial] orange materials to be used."
	if(scost)
		. += "This machine requires [scost]/[smaterial] silver materials to be used."
	if(item)
		. += "This machine will produce [itemnumber] [item.name] when the materials are given."

/obj/structure/highfactory/Crossed(atom/movable/AM)
	. = ..()
	if(!unlocked)
		return

	if(istype(AM, /obj/item/factoryitem/orange) && ocost)
		omaterial+=1
		qdel(AM)

	if(istype(AM, /obj/item/factoryitem/silver) && scost)
		smaterial+=1
		qdel(AM)

	if(!initialmaterial)
		initialmaterial=1
		addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)

/obj/structure/highfactory/proc/spit_item()
	addtimer(CALLBACK(src, PROC_REF(spit_item)), productiontime)
	if(bankeditems)
		bankeditems-=1
		new item(src.loc)

	if(ocost>omaterial)
		return
	if(scost>smaterial)
		return

	omaterial-=ocost
	smaterial-=scost
	bankeditems+=itemnumber

