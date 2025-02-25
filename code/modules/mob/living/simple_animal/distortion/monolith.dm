/obj/machinery/monolith
	name = "monolith"
	desc = "A large, cubical black box."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "monolith"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -8
	base_pixel_x = -8
	var/mob/living/current_target
	var/convert_humans = FALSE
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 8
	var/active = FALSE
	var/target_path
	var/datum/beam/current_beam = null
	var/conversion_progress = 0

/obj/machinery/monolith/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/machinery/monolith/Destroy()
	STOP_PROCESSING(SSobj, src)
	LoseTarget()
	return ..()

/obj/machinery/monolith/attack_hand(mob/living/user)
	if(!ishuman(user))
		return
	if(current_target)
		return
	var/target_list = list()
	for(var/mob/living/L in view(8))
		if(ishuman(L) && convert_humans)
			target_list += L
			continue
		var/mob/living/simple_animal/hostile/distortion/D = L
		if(!istype(D, /mob/living/simple_animal/hostile/distortion))
			continue
		target_list += L
	current_target = input(user, "Whom will you synchronize the monolith with?") as null|anything in target_list
	if(current_beam)
		return
	if(do_after(user, 10, src))
		Fire(current_target)

/obj/machinery/monolith/process()
	if(!current_target)
		LoseTarget()
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(!los_check(loc, current_target))
		qdel(current_beam)//this will give the target lost message
		return

	if(current_target)
		on_beam_tick(current_target)

/obj/machinery/monolith/proc/LoseTarget()
	if(active)
		qdel(current_beam)
		current_beam = null
		active = FALSE
		on_beam_release(current_target)
	current_target = null

/obj/machinery/monolith/proc/Fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!current_target)
		LoseTarget()
	if(!isliving(target))//target is dead
		return
	current_target = target
	active = TRUE
	current_beam = Beam(current_target, icon_state="drainbeam", time = 10 MINUTES, maxdistance = max_range, beam_type = /obj/effect/ebeam/medical)
	RegisterSignal(current_beam, COMSIG_PARENT_QDELETING, PROC_REF(beam_died))//this is a WAY better rangecheck than what was done before (process check)

/obj/machinery/monolith/proc/los_check(mob/target)//copypasted mind whip code
	var/turf/user_turf = loc
	var/obj/dummy = new(user_turf)
	dummy.pass_flags |= PASSTABLE|PASSGLASS|PASSGRILLE //Grille/Glass so it can be used through common windows
	for(var/turf/turf in getline(user_turf,target))
		if(turf.density)
			qdel(dummy)
			return FALSE
			/*
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				say("failed Los check, line 81")
				return FALSE
			*/
	qdel(dummy)
	return TRUE

/obj/machinery/monolith/proc/on_beam_hit(mob/living/target)
	return

/obj/machinery/monolith/proc/on_beam_tick(mob/living/target)
	var/mob/living/carbon/human/H = target
	conversion_progress += 5
	if(conversion_progress >= 100)//arbitrary amount for progression
		Convert(target)
		LoseTarget(target)
	else if(ishuman(H) && convert_humans)
		if(H.sanity_lost)
			Convert(target)
	return

/obj/machinery/monolith/proc/beam_died()
	conversion_progress = 0
	active = FALSE
	LoseTarget()

/obj/machinery/monolith/proc/on_beam_release(mob/living/target)
	return

/obj/machinery/monolith/proc/Convert(mob/living/current_target)
	conversion_progress = 0
	var/mob/living/target = current_target//keep a proper reference here since LoseTarget() can fuck things up
	LoseTarget()
	if(ishuman(target) && convert_humans)
		target.BecomeDistortion()
		return TRUE
	if(istype(target, /mob/living/simple_animal/hostile/distortion))
		var/mob/living/simple_animal/hostile/distortion/D = target
		if(D.monolith_abnormality)
			var/mob/living/simple_animal/hostile/abnormality/myAbno = new D.monolith_abnormality(get_turf(target))
			myAbno.BreachEffect(null, BREACH_MINING)
			qdel(target)
			return TRUE
	return FALSE

/obj/machinery/monolith/admin//you should NEVER map this. Probably.
	desc = "A large, cubical black box. You feel extremely uneasy just by looking at it."
	convert_humans = TRUE
