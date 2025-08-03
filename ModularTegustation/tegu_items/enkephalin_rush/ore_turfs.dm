//path is closed/minerals.dm
//'icons/turf/mining.dmi'
//FIXME: destroys tile decals
//TODO: add a rock scanner
/turf/closed/mineral/facility//wall piece
	name = "rubble"
	icon = 'icons/turf/mining.dmi'
	smooth_icon = 'icons/turf/walls/rock_wall.dmi'
	icon_state = "rock2"
	base_icon_state = "rock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)
	baseturfs = /turf/open/floor/plating
	//initial_gas_mix = OPENTURF_DEFAULT_ATMOS
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
	//initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	var/risk_level = 1
	var/mining_time = 20
	var/list/chem_list
	var/event_chance = 25
	var/abnospawner = FALSE
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
	if(prob(30) && (istype(baseturfs, /turf/open/floor/plating)))
		baseturfs = /turf/open/floor/plating/rust
	if(prob(30))
		risk_level += 1
		mining_time *= 1.5
	..()
	return INITIALIZE_HINT_NORMAL

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
		/obj/item/stack/ore/ironscrap = 20, /obj/item/stack/ore/glassrubble = 40, /obj/item/stack/ore/plastic = 40, /obj/item/stack/ore/plasteel = 5)

/turf/closed/mineral/random/facility/briah//HE-WAW level
	mineralChance = 15
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 3, /obj/item/stack/ore/diamond = 2, /obj/item/stack/ore/gold = 3, /obj/item/stack/ore/silver = 5,
		/obj/item/stack/ore/ironscrap = 20, /obj/item/stack/ore/glassrubble = 30, /obj/item/stack/ore/plastic = 30, /obj/item/stack/ore/plasteel = 15)
	risk_level = 3
	mining_time = 120

/turf/closed/mineral/random/facility/atzliuth//WAW-ALEPH level
	mineralChance = 20
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 5, /obj/item/stack/ore/diamond = 10, /obj/item/stack/ore/gold = 5, /obj/item/stack/ore/silver = 5,
		/obj/item/stack/ore/ironscrap = 10, /obj/item/stack/ore/glassrubble = 5, /obj/item/stack/ore/plastic = 15, /obj/item/stack/ore/plasteel = 30)
	risk_level = 4
	mining_time = 240

/turf/closed/mineral/random/facility/attackby(obj/item/I, mob/user, params)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	if(I.tool_behaviour == TOOL_MINING)
		var/turf/T = user.loc
		if (!isturf(T))
			return
		if(istype(I, /obj/item/ego_weapon))//stat check for ego
			var/obj/item/ego_weapon/M = I
			if(M.tool_behaviour != TOOL_MINING)
				return
			if(!M.CanUseEgo(user))
				return
		var/mine_mod = mining_time
		if(ishuman(user))//fortitude lowers the initial mining time by a bit over half at 130
			var/userfort = (get_modified_attribute_level(user, FORTITUDE_ATTRIBUTE))
			var/fortmod = 1 + userfort/100
			mine_mod /= fortmod
		if(mine_mod * I.toolspeed >= 50)//would it take longer than 5 seconds?
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
	if(abnospawner)
		AbnoEvent()
	if(prob(event_chance))
		PickEvents(user)
	ScrapeAway(null, flags)
	addtimer(CALLBACK(src, PROC_REF(AfterChange)), 1, TIMER_UNIQUE)
	playsound(get_turf(src), 'sound/effects/break_stone.ogg', 50, TRUE) //beautiful destruction

/turf/closed/mineral/random/facility/proc/PickEvents(user)
	if(prob(80))
		MiningEvent()
		return
	if(prob(5))
		LootEvent()
		return
	if(prob(70))
		SummonMobs()
		return
	else
		AbnoEvent()

/turf/closed/mineral/random/facility/proc/LootEvent(user)
	/*if(prob(30))//runtimes
		var/obj/effect/mob_spawn/human/agent/randomloot/R//completely random corpses from wishing well's pool
		R.risk_level = risk_level
		R = new(get_turf(src))
		return*/
	var/obj/effect/mob_spawn/human/agent/loot/A//these are based on abnos in the facility, with proper defaults for when no corresponding abnos exist.)
	switch(risk_level)
		if(1)
			A = /obj/effect/mob_spawn/human/agent/loot//zayin
		if(2)
			A = /obj/effect/mob_spawn/human/agent/loot/teth
		if(3)
			A = /obj/effect/mob_spawn/human/agent/loot/he
		if(4)
			A = /obj/effect/mob_spawn/human/agent/loot/waw
		else
			A = /obj/effect/mob_spawn/human/agent/loot/aleph
	new A(get_turf(src))

/turf/closed/mineral/random/facility/proc/MiningEvent(user)
	if(prob(40))//damage events
		if(prob(40))//cave-in
			var/explosion_damage = (risk_level * 30)
			visible_message(span_danger("Chunks of rubble cave in around you!"))
			playsound(get_turf(src), 'sound/effects/lc13_environment/day_50/Shake_Start.ogg', 60, TRUE)
			for(var/turf/T in view(4, src))
				if(prob(80))
					continue
				var/obj/effect/rock_fall/R = new(T)
				R.boom_damage = explosion_damage
			return
		if(prob(20))//earthquake
			var/explosion_damage = (risk_level * 15)
			visible_message(span_danger("The ground starts shaking!"))
			playsound(get_turf(src), 'sound/effects/lc13_environment/day_50/Shake_Move.ogg', 60, TRUE)
			for(var/mob/living/L in view(12, src))
				L.apply_damage(explosion_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
				shake_camera(L, 20, 3)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					H.Knockdown(3 SECONDS)
					H.Stun(3 SECONDS)
			return
		if(prob(100 - (risk_level * 15)))//explode
			var/explosion_damage = (risk_level * 20)
			visible_message(span_danger("[src] suddenly explodes!"))
			new /obj/effect/temp_visual/explosion(get_turf(src))
			playsound(get_turf(src), 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
			for(var/mob/living/L in view(3, src))
				L.apply_damage(explosion_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
			return
		else//Qliphoth Meltdown
			if(risk_level >= 3)
				visible_message(span_danger("Damaged machinery in the [src] causes a qliphoth meltdown!"))
				SSlobotomy_corp.InitiateMeltdown(round(SSlobotomy_corp.qliphoth_meltdown_amount), TRUE)
	else
		visible_message(span_danger("You feel a sudden rush of air as [src] crumbles!"))
		var/mychem = PickChems(risk_level)
		var/obj/effect/gas_spawner/G
		G = new(get_turf(src))
		G.chem_type = mychem
		G.risk_level = risk_level

/turf/closed/mineral/random/facility/proc/PickChems(risk_level)//TODO: make sure these are actually dangerous
	switch(risk_level)
		if(1)
			chem_list = list(
			/datum/reagent/toxin/minttoxin = 10,//fatties get ownzoned
			/datum/reagent/drug/space_drugs = 30,
			/datum/reagent/toxin/chloralhydrate = 30,
			/datum/reagent/toxin/staminatoxin = 50,
			/datum/reagent/toxin/lc13_toxin/weak = 25,
			/datum/reagent/toxin/lc13_toxin/white/weak = 25,
			)
		if(2)
			chem_list = list(
			/datum/reagent/toxin/acid = 5,
			/datum/reagent/toxin/minttoxin = 10,
			/datum/reagent/drug/space_drugs = 15,
			/datum/reagent/toxin/chloralhydrate = 20,
			/datum/reagent/toxin/lc13_toxin/weak = 25,
			/datum/reagent/toxin/lc13_toxin/white/weak = 25,
			/datum/reagent/toxin/lc13_toxin/black/weak = 25,
			/datum/reagent/toxin/lc13_toxin/pale/weak = 12,
			)
		if(3)
			chem_list = list(
			/datum/reagent/toxin/cyanide = 1,
			/datum/reagent/toxin = 10,
			/datum/reagent/toxin/acid = 10,
			/datum/reagent/toxin/minttoxin = 10,
			/datum/reagent/toxin/mindbreaker = 10,
			/datum/reagent/toxin/chloralhydrate = 10,
			/datum/reagent/toxin/lc13_toxin = 25,
			/datum/reagent/toxin/lc13_toxin/white = 25,
			/datum/reagent/toxin/lc13_toxin/black = 25,
			/datum/reagent/toxin/lc13_toxin/pale = 12,
			)
		if(4)
			chem_list = list(
			/datum/reagent/toxin/cyanide = 1,
			/datum/reagent/toxin = 20,
			/datum/reagent/toxin/acid = 20,
			/datum/reagent/toxin/minttoxin = 5,
			/datum/reagent/toxin/mindbreaker = 15,
			/datum/reagent/toxin/chloralhydrate = 20,
			/datum/reagent/toxin/lc13_toxin = 50,
			/datum/reagent/toxin/lc13_toxin/white = 50,
			/datum/reagent/toxin/lc13_toxin/black = 50,
			/datum/reagent/toxin/lc13_toxin/pale = 25,
			)
		else//5, or 6 if it somehow appears
			chem_list = list(
			/datum/reagent/toxin/cyanide = 1,
			/datum/reagent/toxin/mutagen = 1,
			/datum/reagent/toxin = 30,
			/datum/reagent/toxin/acid = 30,
			/datum/reagent/toxin/minttoxin = 1,
			/datum/reagent/toxin/mindbreaker = 10,
			/datum/reagent/toxin/chloralhydrate = 30,
			/datum/reagent/toxin/lc13_toxin/strong = 25,
			/datum/reagent/toxin/lc13_toxin/white/strong = 25,
			/datum/reagent/toxin/lc13_toxin/black/strong = 25,
			/datum/reagent/toxin/lc13_toxin/pale/strong = 25,
			)

	var/chosen_reagent = pickweight(chem_list)
	return chosen_reagent

//for the poison gas event
/obj/effect/gas_spawner
	name = "gas spawner"
	desc = "CLEAR THE WAY!!"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/chem_type = /datum/reagent/toxin/lc13_toxin
	var/risk_level
	var/ignore_list = list(
		/datum/reagent/toxin/lc13_toxin/pale/weak,
		/datum/reagent/toxin/lc13_toxin,
		/datum/reagent/toxin/lc13_toxin/white,
		/datum/reagent/toxin/lc13_toxin/black,
		/datum/reagent/toxin/lc13_toxin/pale,
		/datum/reagent/toxin/lc13_toxin/strong,
		/datum/reagent/toxin/lc13_toxin/white/strong,
		/datum/reagent/toxin/lc13_toxin/black/strong,
		/datum/reagent/toxin/lc13_toxin/pale/strong,
		/datum/reagent/toxin,
		)

/obj/effect/gas_spawner/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 3 SECONDS)
	playsound(get_turf(src), 'sound/effects/refill.ogg', 50, FALSE, 8)

/obj/effect/gas_spawner/proc/explode()
	playsound(get_turf(src), 'sound/effects/smoke.ogg', 50, FALSE, 8)
	var/datum/effect_system/smoke_spread/chem/S = new
	// Create the reagents to put into the air
	create_reagents(100)
	reagents.add_reagent(chem_type, (risk_level * 20))
	if(chem_type in ignore_list)
		S.ignore_protection = TRUE
	S.attach(loc)
	S.set_up(reagents, 4, loc)
	S.start()
	qdel(src)

//Rockfall spawner
/obj/effect/rock_fall
	name = "falling rubble"
	desc = "LOOK OUT!"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "large1"
	alpha = 0
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/boom_damage = 50
	var/delay_time = 10
	layer = POINT_LAYER	//Sprite should always be visible

/obj/effect/rock_fall/Initialize()
	. = ..()
	delay_time = rand(20, 60)
	pixel_y = (delay_time * 5)
	animate(src, pixel_y = 0, alpha = 255, time = delay_time)
	addtimer(CALLBACK(src, PROC_REF(explode)), delay_time)

/obj/effect/rock_fall/proc/explode()
	playsound(get_turf(src), 'sound/effects/lc13_environment/day_50/Shake_End.ogg', 50, 0, 8)
	for(var/mob/living/L in view(1, src))
		L.apply_damage(boom_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
		shake_camera(L, 5, 3)
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(0, get_turf(src))	//Smoke shouldn't really obstruct your vision
	S.start()
	qdel(src)

/turf/closed/mineral/random/facility/proc/SummonMobs(user)
	visible_message(span_danger("Something violently emerges from [src]!"))
	var/threat_level = clamp((risk_level - 1), 1, 4)//ZAYIN and TETHs will spawn dawns, while only ALEPH will spawn midnights
	new /obj/effect/spawner/map_enemy(get_turf(src), threat_level)

/turf/closed/mineral/random/facility/proc/AbnoEvent(user)
	var/list/abnolevels = list(
			ZAYIN_LEVEL = 1,
			TETH_LEVEL = 2,
			HE_LEVEL = 3,
			WAW_LEVEL = 4,
			ALEPH_LEVEL = 5,
			)
	if(risk_level > 5)//don't go out of bounds!
		risk_level = 5
	var/abno_level = abnolevels[risk_level]
	SSabnormality_queue.SelectAvailableLevels()
	var/mob/living/simple_animal/hostile/abnormality/abno
	if(LAZYLEN(SSabnormality_queue.possible_abnormalities[abno_level]))
		abno = pick(SSabnormality_queue.possible_abnormalities[abno_level])
		SSabnormality_queue.possible_abnormalities[abno_level] -= abno
	if(abno)
		var/mob/living/simple_animal/hostile/abnormality/A = new abno(get_turf(src))
		if(prob(1))
			qdel(A)
			visible_message(span_nicegreen("The rubble reveals an abnormality core."))
			return
		visible_message(span_danger("[A] emerges from the rubble!"))
		addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality, BreachEffect), user, BREACH_MINING), 2 SECONDS)

/turf/closed/mineral/random/facility/abnormality
	name = "shifty rubble"//you need to varedit the threat levels
	desc = "This rubble produces strong enkephalin readings."
	abnospawner = TRUE
	event_chance = 0
