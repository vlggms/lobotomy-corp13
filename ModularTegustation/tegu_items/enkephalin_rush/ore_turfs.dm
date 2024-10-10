//path is closed/minerals.dm
//'icons/turf/mining.dmi'
//FIXME: destroys tile decals and grants 4 experience by default
/turf/closed/mineral/facility//wall piece
	name = "rubble"
	icon = 'icons/turf/mining.dmi'
	smooth_icon = 'icons/turf/walls/rock_wall.dmi'
	icon_state = "rock2"
	base_icon_state = "rock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)
	baseturfs = /turf/open/floor/plating
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	environment_type = "waste"
	turf_type = /turf/open/floor/plating/asteroid
	defer_change = TRUE

/turf/closed/mineral/random/facility
	name = "rubble"
	icon = 'icons/turf/mining.dmi'
	smooth_icon = 'icons/turf/walls/rock_wall.dmi'
	icon_state = "rock2"
	base_icon_state = "rock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)
	defer_change = TRUE
	environment_type = "waste"
	turf_type = /turf/open/floor/plating
	baseturfs = /turf/open/floor/plating
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	var/risk_level = 1
	var/mining_time = 40
	var/list/chem_list
	/*
	Tool speeds for pickaxes are the following:
	improvised pick: 3
	pickaxe: 1
	drill: 0.6
	silver p: 0.5
	diamond p: 0.3
	diamond drill: 0.2
	jackhammer: 0.1
	*/

/turf/closed/mineral/random/facility/Initialize()
	if(prob(30))
		baseturfs = /turf/open/floor/plating/rust
	if(prob(30))
		risk_level += 1
	..()

/turf/closed/mineral/random/facility/Change_Ore(ore_type, random = 0)
	. = ..()
	if(mineralType)
		smooth_icon = 'icons/turf/walls/rock_wall.dmi'
		icon = 'icons/turf/walls/rock_wall.dmi'
		icon_state = "rock_wall-0"
		base_icon_state = "rock_wall"
		smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER

/turf/closed/mineral/random/facility//assiyah, ZAYIN-TETH level
	mineralChance = 10
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 1, /obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 2, /obj/item/stack/ore/silver = 3,
		/obj/item/stack/ore/ironscrap = 20, /obj/item/stack/ore/glassrubble = 40, /obj/item/stack/ore/plasteel = 5)

/turf/closed/mineral/random/facility/briah//HE-WAW level
	mineralChance = 15
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 3, /obj/item/stack/ore/diamond = 2, /obj/item/stack/ore/gold = 3, /obj/item/stack/ore/silver = 5,
		/obj/item/stack/ore/ironscrap = 40, /obj/item/stack/ore/glassrubble = 20, /obj/item/stack/ore/plasteel = 10)
	risk_level = 3
	mining_time = 120

/turf/closed/mineral/random/facility/atzliuth//WAW-ALEPH level
	mineralChance = 20
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 5, /obj/item/stack/ore/diamond = 10, /obj/item/stack/ore/gold = 5, /obj/item/stack/ore/silver = 5,
		/obj/item/stack/ore/ironscrap = 5, /obj/item/stack/ore/glassrubble = 10, /obj/item/stack/ore/plasteel = 30)
	risk_level = 4
	mining_time = 300

/turf/closed/mineral/random/facility/attackby(obj/item/I, mob/user, params)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	if(I.tool_behaviour == TOOL_MINING)
		var/turf/T = user.loc
		if (!isturf(T))
			return
		if(mining_time * I.toolspeed >= 100)
			to_chat(user, "<span class='notice'>Your [I] barely chips the rock!</span>")
			return

		if(last_act + (mining_time * I.toolspeed) > world.time)//prevents message spam
			return
		last_act = world.time
		to_chat(user, "<span class='notice'>You start picking...</span>")
		if(I.use_tool(src, user, mining_time, volume=50))
			if(ismineralturf(src))
				to_chat(user, "<span class='notice'>You finish cutting into the rock.</span>")
				gets_drilled(user, TRUE)
				SSblackbox.record_feedback("tally", "pick_used_mining", 1, I.type)
	else
		return attack_hand(user)

/turf/closed/mineral/random/facility/gets_drilled(user)//no experience
	if(mineralType && (mineralAmt > 0))
		new mineralType(src, mineralAmt)
		SSblackbox.record_feedback("tally", "ore_mined", mineralAmt, mineralType)

	for(var/obj/effect/temp_visual/mining_overlay/M in src)
		qdel(M)
	var/flags = NONE
	if(defer_change) // TODO: make the defer change var a var for any changeturf flag
		flags = CHANGETURF_DEFER_CHANGE
	if(prob(10))
		PickEvents(user)
	ScrapeAway(null, flags)
	addtimer(CALLBACK(src, PROC_REF(AfterChange)), 1, TIMER_UNIQUE)
	playsound(get_turf(src), 'sound/effects/break_stone.ogg', 50, TRUE) //beautiful destruction

/turf/closed/mineral/random/facility/proc/PickEvents(user)
	if(prob(100))
		MiningEvent()
	if(prob(30))
		SummonMobs()
		return
	else
		AbnoEvent()

/turf/closed/mineral/random/facility/proc/MiningEvent(user)
	if(prob(50))//explosion
		var/explosion_damage = (risk_level * 20)
		if(prob(risk_level * 10))//explode
			visible_message(span_danger("[src] suddenly explodes!"))
			new /obj/effect/temp_visual/explosion(get_turf(src))
			playsound(get_turf(src), 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
			for(var/mob/living/L in view(3, src))
				L.apply_damage(explosion_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			return
	else
		visible_message(span_danger("You feel a sudden rush of air as [src] crumbles down!"))
		var/datum/effect_system/smoke_spread/chem/S = new
		var/turf/location = get_turf(src)
		// Create the reagents to put into the air
		create_reagents(100)
		PickChems(risk_level)
		S.attach(location)
		S.set_up(reagents, 2, location, silent = FALSE)
		S.start()

/turf/closed/mineral/random/facility/proc/PickChems(risk_level)//TODO: make sure these are actually dangerous
	switch(risk_level)
		if(1)
			chem_list = list(
			/datum/reagent/toxin/mutagen = 1,
			/datum/reagent/toxin/minttoxin = 10,//fatties get ownzoned
			/datum/reagent/toxin/mutetoxin = 15,
			/datum/reagent/drug/space_drugs = 30,
			/datum/reagent/toxin/chloralhydrate = 30,
			/datum/reagent/toxin/staminatoxin = 50,
			)
		if(2)
			chem_list = list(
			/datum/reagent/toxin/acid = 5,
			/datum/reagent/toxin/minttoxin = 10,
			/datum/reagent/toxin/mutetoxin = 30,
			/datum/reagent/drug/space_drugs = 15,
			/datum/reagent/toxin/chloralhydrate = 20,
			/datum/reagent/toxin/staminatoxin = 30,
			)
		if(3)
			chem_list = list(
			/datum/reagent/toxin/cyanide = 1,
			/datum/reagent/toxin = 10,
			/datum/reagent/toxin/mutagen = 5,
			/datum/reagent/toxin/acid = 10,
			/datum/reagent/toxin/minttoxin = 10,
			/datum/reagent/toxin/mutetoxin = 10,
			/datum/reagent/toxin/mindbreaker = 10,
			/datum/reagent/toxin/chloralhydrate = 10,
			/datum/reagent/toxin/staminatoxin = 10,
			)
		if(4)
			chem_list = list(
			/datum/reagent/toxin/cyanide = 1,
			/datum/reagent/toxin = 20,
			/datum/reagent/toxin/mutagen = 10,
			/datum/reagent/toxin/acid = 20,
			/datum/reagent/toxin/minttoxin = 5,
			/datum/reagent/toxin/mutetoxin = 5,
			/datum/reagent/toxin/mindbreaker = 15,
			/datum/reagent/toxin/chloralhydrate = 20,
			/datum/reagent/toxin/staminatoxin = 5,
			)
		else//5, or 6 if it somehow appears
			chem_list = list(
			/datum/reagent/toxin/cyanide = 1,
			/datum/reagent/toxin = 30,
			/datum/reagent/toxin/mutagen = 10,
			/datum/reagent/toxin/acid = 30,
			/datum/reagent/toxin/minttoxin = 1,
			/datum/reagent/toxin/mutetoxin = 1,
			/datum/reagent/toxin/mindbreaker = 10,
			/datum/reagent/toxin/chloralhydrate = 30,
			/datum/reagent/toxin/staminatoxin = 1,
			)

	var/chosen_reagent = pickweight(chem_list)
	reagents.add_reagent(chosen_reagent, (risk_level * 20))

/turf/closed/mineral/random/facility/proc/SummonMobs(user)

/turf/closed/mineral/random/facility/proc/AbnoEvent(user)


/turf/closed/mineral/random/facility/abnospawner
	name = "shifty rubble"//you need to varedit the threat levels

/turf/closed/mineral/random/facility/abnospawner/gets_drilled(user)
	AbnoEvent()
	..()
