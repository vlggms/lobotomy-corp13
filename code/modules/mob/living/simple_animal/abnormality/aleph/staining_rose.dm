// Re-coded by Coxswain, finally off fraud watch. The flower that kills you.
/mob/living/simple_animal/hostile/abnormality/staining_rose
	name = "Staining Rose"
	desc = "A tiny, wilting rose."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "rose_inactive"
	portrait = "staining_rose"
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 30, 40),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 45, 50),
	)
	start_qliphoth = 1
	work_damage_upper = 7
	work_damage_lower = 6
	work_damage_type = PALE_DAMAGE
	max_boxes = 33
	chem_type = /datum/reagent/abnormality/sin/pride
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -8
	base_pixel_y = -8

	ego_list = list(
		/datum/ego_datum/weapon/blooming,
		/datum/ego_datum/armor/blooming,
		/datum/ego_datum/armor/flowering,
	)
	gift_type = /datum/ego_gifts/blossoming
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "This isn't worth being called a sacrifice, is it? <br>I've always wanted to be a hero, but... <br>Even when I'm ordered forth to die a worthless death... <br>\
		I find myself laughable for deciding to do it still. <br>I joined this company to save people. <br>If I can save the lives of those I love, I have no regrets."
	observation_choices = list(
		"100 paper roses" = list(TRUE, "I was the only one who could do it... <br>\
			... <br>That's all."),
	)

	var/mob/living/carbon/human/chosen = null
	var/safe = FALSE //work on it and you're safe for 15 minutes
	var/check_timer
	var/stain_progress = 100 // Counts down from 100 to 0
	var/bloom_threshold = 0
	var/blooming = FALSE
	var/safework = FALSE
	var/extra_damage_min = 0
	var/extra_damage_max = 0
	var/free_work_override = FALSE
	var/silent_work = FALSE
	var/worse_breach = FALSE


/mob/living/simple_animal/hostile/abnormality/staining_rose/Initialize()
	. = ..()
	check_timer = addtimer(CALLBACK(src, PROC_REF(ChosenCheck)), 1 MINUTES, TIMER_STOPPABLE)
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath)) // Hell


// Work
/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/ChosenCheck() // All code shamelessly ripped off nobody is
	if(datum_reference.working)
		deltimer(check_timer)
		check_timer = addtimer(CALLBACK(src, PROC_REF(ChosenCheck)), 30 SECONDS, TIMER_STOPPABLE)
		return
	if(chosen) // Somehow, this was called when we alrady have someone chosen.
		return
	FindChosen()

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/FindChosen()
	var/list/potentialmarked = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(CheckAttributes(L))
			potentialmarked += L
	if(LAZYLEN(potentialmarked)) //It's fine if no one got picked. Probably.
		SelectChosen(pick(potentialmarked))
	else
		SelectChosen(null)

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/SelectChosen(mob/living/carbon/human/mychosen)
	chosen = mychosen
	if(!chosen)
		deltimer(check_timer)
		check_timer = addtimer(CALLBACK(src, PROC_REF(ChosenCheck)), 3 MINUTES, TIMER_STOPPABLE)
		return
	mychosen.apply_status_effect(/datum/status_effect/stained, datum_reference)
	to_chat(mychosen, span_warning("You are now Staining Rose's Chosen."))
	icon_state = "rose"
	deltimer(check_timer)
	check_timer = null

// Does this guy qualify as a chosen?
/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/CheckAttributes(mob/living/carbon/human/human_to_check)
	if(!human_to_check)
		return FALSE
	if(HAS_TRAIT(human_to_check, TRAIT_WORK_FORBIDDEN))
		return FALSE
	if(get_user_level(human_to_check) >= 4)	// We check for 2 things - level 4 agent or level 5 in at least one attribute
		return TRUE
	for(var/datum/attribute/A in human_to_check.attributes)
		if(A.get_level() <= 5)
			continue
		return TRUE
	return FALSE

// Work Procs
/mob/living/simple_animal/hostile/abnormality/staining_rose/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	safe = TRUE
	if(!chosen)
		if(CheckAttributes(user))
			SelectChosen(user)
		safework = FALSE
		return

	if((user != chosen) && !safework)
		user.visible_message(span_warning("Staining Rose already has a Chosen named [chosen]!"))
		var/datum/disease/staining_rose/D = new()
		user.ForceContractDisease(D, FALSE, TRUE)
		Shed()
		return
	safework = FALSE

/mob/living/simple_animal/hostile/abnormality/staining_rose/Worktick(mob/living/carbon/human/user)
	. = ..()
	if(user != chosen)
		return
	if(stain_progress <= bloom_threshold)
		if(!blooming)
			Bloom(TRUE)

// Additional effect on each individual work tick success
/mob/living/simple_animal/hostile/abnormality/staining_rose/WorktickSuccess(mob/living/carbon/human/user)
	if(!silent_work)
		playsound(datum_reference.console, 'sound/machines/synth_yes.ogg', 25, FALSE, -4)
	if(user != chosen)
		return
	Stain(-1)
	if(free_work_override)
		return
	if(extra_damage_max)
		new /obj/effect/temp_visual/petals(get_turf(user))
		user.deal_damage(rand(extra_damage_min, extra_damage_max), PALE_DAMAGE)

// Additional effect on each individual work tick failure
/mob/living/simple_animal/hostile/abnormality/staining_rose/WorktickFailure(mob/living/carbon/human/user)
	if(!silent_work)
		playsound(datum_reference.console, 'sound/machines/synth_no.ogg', 25, FALSE, -4)
	user.deal_damage(rand(work_damage_lower,work_damage_upper), work_damage_type)
	WorkDamageEffect()
	if(user != chosen)
		return
	Stain(-2)

/mob/living/simple_animal/hostile/abnormality/staining_rose/SpeedWorktickOverride(mob/living/carbon/human/user, work_speed, init_work_speed, work_type)
	if(free_work_override)
		return 0
	return init_work_speed

/mob/living/simple_animal/hostile/abnormality/staining_rose/ChanceWorktickOverride(mob/living/carbon/human/user, work_chance, init_work_chance, work_type)
	if(free_work_override)
		return 999
	return init_work_chance

/mob/living/simple_animal/hostile/abnormality/staining_rose/AttemptWork(mob/living/carbon/human/user, work_type)
	silent_work = FALSE
	if(blooming)
		to_chat(user, span_warning("It isn't safe to work on the staining rose right now!"))
		return FALSE
	if(datum_reference.console.meltdown && !chosen)
		safework = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/Stain(value, forced = FALSE)
// Staining rose will stain every work tick, dealing unavoidable damage at a high stain value. The amount of stain added depends on the work tick. Failed ticks build it up faster.
	if(!chosen && !forced)
		return
	if(blooming) // We should already be at 0
		return
	stain_progress = clamp(stain_progress + value, 0, 100)
	switch(stain_progress)
		if(75 to INFINITY)
			if(chosen)
				icon_state = "rose"
		if(-INFINITY to 74)
			icon_state = "rose_activated"
			extra_damage_min = round((100 - stain_progress) / 25)
			extra_damage_max = round((100 - stain_progress) / 15)
			max_boxes = 28

// There's a lot going on with this proc, but basically it's a good(ish) thing when handled properly, and a very, very bad breach when mishandled.
// Bloom occurs when the rose is fully stained, or a melt is missed while a chosen is alive.
// The former is good, the latter is bad. That's all you really need to know.
/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/Bloom(working = FALSE)
	blooming = TRUE // Prevents a work from starting.
	icon_state = "rose_pissed"
	var/matrix/init_transform = transform
	animate(src, transform = transform*1.2, time = 20, easing = BACK_EASING|EASE_OUT)
	playsound(get_turf(src), 'sound/abnormalities/spiral_contempt/spiral_bleed.ogg', 50, 0, 5)
	SLEEP_CHECK_DEATH(20)
	animate(src, transform = init_transform, time = 5)
	icon_state = "rose_activated"
	if(!chosen)
		Shed()
	else if(chosen.stat == DEAD)
		Shed()
	else
		chosen.remove_status_effect(/datum/status_effect/stained)
		var/target_turf = get_turf(chosen)
		playsound(get_turf(src),'sound/effects/limbus_death.ogg', 50, 1)
		var/mult = 1
		switch(stain_progress)
			if(75 to 100) // Yeah you're gonna die. 800-999 Pale
				mult = 10
			if(50 to 74) // Probably survivable? 400-518 Pale
				mult = 7
			if(25 to 49) // Survivable. 175-295 Pale
				mult = 5
		var/damagetodo = (50 + clamp((stain_progress * mult),0, 999))
		if(damagetodo >= 75)
			for(var/turf/T in view(1, target_turf))
				new /obj/effect/temp_visual/petals/disease(T) // further punishment for ignoring mechanics
		else
			for(var/turf/T in view(1, target_turf))
				new /obj/effect/temp_visual/petals(T) // We still need some sort of visual that something happened
		chosen.deal_damage(damagetodo, PALE_DAMAGE)
	if(chosen.is_working && working) // finish our work for free
		silent_work = TRUE
		free_work_override = TRUE
	addtimer(CALLBACK(src, PROC_REF(Reset)), 20) //It wilts away. The timer is to give the work code time to do its thing.

// Death and Meltdown
/mob/living/simple_animal/hostile/abnormality/staining_rose/ZeroQliphoth(mob/living/carbon/human/user)
	Shed(TRUE)

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/Shed(qliphoth_lost = FALSE)
	if(!IsContained())
		return
	playsound(get_turf(src), 'sound/abnormalities/rose/flower1.ogg', 50, FALSE, 5)
	var/list/turfs = list()
	var/turf/self_turf = src.loc
	var/turf/inside = locate(self_turf.x+1, self_turf.y, self_turf.z)
	var/turf/outside = locate(self_turf.x+3, self_turf.y-4, self_turf.z)
	if(inside)
		for(var/turf/T in range(inside, 2))
			if(!T || isclosedturf(T))
				continue
			if(locate(/obj/structure/window) in T.contents)
				continue
			if(locate(/obj/structure/table) in T.contents)
				continue
			if(locate(/obj/structure/railing) in T.contents)
				continue
			turfs += T
	if(outside)
		var/area/place = get_area(outside)
		for(var/turf/T in place)
			var/dense = FALSE
			if(!T || isclosedturf(T))
				continue
			if(locate(/obj/structure/window) in T.contents)
				continue
			if(locate(/obj/structure/table) in T.contents)
				continue
			if(locate(/obj/structure/railing) in T.contents)
				continue
			for(var/obj/machinery/door/D in T.contents)
				if(D.density)
					dense = TRUE
			if(dense)
				continue
			turfs += T
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/petals/disease(T) // Disease-spreading petals.
	if(qliphoth_lost) // Even more punishing if it was ignored.
		if(chosen)
			Bloom() // Bozo let us melt. You were the chosen one!
			return
		else
			var/max_distance = 15
			if(worse_breach)
				max_distance = 200 // Spans across most of a facility
			var/list/potentialmarked = list()
			var/mob/living/Y
			var/list/pickable_sounds = list('sound/abnormalities/rose/flower2.ogg', 'sound/abnormalities/rose/flower3.ogg') // some freaky sounds
			for(var/mob/living/carbon/human/L in GLOB.player_list)
				if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
					continue
				if(get_dist(src,L) >= max_distance)
					continue
				potentialmarked += L
			var/numbermarked
			if(worse_breach)
				numbermarked = 1 + round(LAZYLEN(potentialmarked) / 2, 1) // Half of all players +1
			else
				numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
			for(var/i = numbermarked, i>=1, i--)
				if(potentialmarked.len <= 0)
					break
				Y = pick(potentialmarked)
				potentialmarked -= Y
				for(var/turf/T in view(1, get_turf(Y)))
					new /obj/effect/temp_visual/petals/disease(T)
				var/thesound = pick(pickable_sounds)
				playsound(get_turf(Y), thesound, 30, FALSE)
				Y.deal_damage(25, PALE_DAMAGE)
			worse_breach = FALSE

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/Reset()
	icon_state = "rose_inactive"
	deltimer(check_timer)
	check_timer = null
	addtimer(CALLBACK(src, PROC_REF(ChosenCheck)), 3 MINUTES, TIMER_STOPPABLE) // Players are free for 3 minutes
	free_work_override = FALSE
	blooming = FALSE
	chosen = null
	Stain(100, TRUE) // reset stain progress

/mob/living/simple_animal/hostile/abnormality/staining_rose/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	if(died.z != z)
		return FALSE
	if(died == chosen)
		chosen.remove_status_effect(/datum/status_effect/stained)
		Reset()
		worse_breach = TRUE
		datum_reference.qliphoth_change(-1)
	return

// Effects and such
/obj/effect/temp_visual/petals
	name = "rose petals"
	desc = "Petals shed by the Staining Rose."
	icon_state = "petal"
	icon = 'icons/effects/weather_effects.dmi'
	duration = 5
	var/damaging = FALSE

/obj/effect/temp_visual/petals/disease
	duration = 20 SECONDS
	var/active = FALSE

/obj/effect/temp_visual/petals/disease/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(BecomeActive)), 5 SECONDS)

/obj/effect/temp_visual/petals/disease/proc/BecomeActive()
	icon_state = "petal_harsh"
	active = TRUE
	for(var/mob/living/L in get_turf(src))
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		var/datum/disease/staining_rose/D = new()
		H.ForceContractDisease(D, FALSE, TRUE)

/obj/effect/temp_visual/petals/disease/Crossed(atom/movable/AM)
	. = ..()
	if(!active)
		return
	if(ishuman(AM))
		var/mob/living/carbon/human/thehuman = AM
		var/datum/disease/staining_rose/D = new()
		thehuman.ForceContractDisease(D, FALSE, TRUE)

// Status Effect visual for the chosen
/datum/status_effect/stained
	id = "stained"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1		//Lasts until the rose dies
	alert_type = /atom/movable/screen/alert/status_effect/stained
	var/datum/abnormality/datum_reference = null // refer to the datum for staining rose
	var/other_works_count = 0

/atom/movable/screen/alert/status_effect/stained
	name = "Rose-stained"
	desc = "The staining rose has chosen you. It wishes to resonate with you."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "sacrifice"

/datum/status_effect/stained/on_creation(mob/living/new_owner, new_datum)
	if(!new_datum)
		return
	datum_reference = new_datum
	return ..()

/datum/status_effect/stained/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED, PROC_REF(OnAbnoWork))

/datum/status_effect/stained/on_remove()
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED)

/datum/status_effect/stained/proc/DealDamage()
	var/damage_dealt = 0
	var/breachtime = FALSE
	switch(other_works_count)
		if(-INFINITY to 0) // HOW??
			return
		if(1)
			damage_dealt = (owner.maxHealth * (0.05))
		if(2)
			damage_dealt = (owner.maxHealth * (0.10))
		if(3)
			damage_dealt = (owner.maxHealth * (0.25))
		if(4 to INFINITY)
			damage_dealt = (owner.maxHealth * (0.50))
			breachtime = TRUE
	owner.apply_damage(damage_dealt, BRUTE)
	owner.manual_emote("[owner] coughs up petals!")
	to_chat(owner, span_warning("You are being penalized by the Staining Rose for working on another abnormality!"))
	owner.add_splatter_floor()
	if(prob(10))
		new /obj/item/rose(get_turf(owner))
	if(breachtime)
		addtimer(CALLBACK(src, PROC_REF(CauseBreach)), 5) // Needs a timer because this proc should not sleep

/datum/status_effect/stained/proc/OnAbnoWork(datum/source, datum/abnormality/abno_datum, mob/user, work_type)
	SIGNAL_HANDLER
	if(user != owner)
		return
	if(abno_datum == datum_reference)//If working on this abnormality
		other_works_count = 0
		return FALSE
	if(datum_reference.working)//If the abnormality is being worked on, may invalidate the previous conditional statement
		return FALSE
	++other_works_count
	DealDamage()

/datum/status_effect/stained/proc/CauseBreach()
	datum_reference.qliphoth_change(-1)

/obj/item/rose // It's more of an effect that you can pick up.
	name = "rose"
	desc = "Listen here - Every night has its dawn..."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "rose"
	var/timerid

/obj/item/rose/Initialize()
	. = ..()
	timerid = QDEL_IN(src, 30 SECONDS)

/obj/item/rose/Destroy()
	. = ..()
	deltimer(timerid)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
