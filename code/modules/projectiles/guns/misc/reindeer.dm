/obj/item/gun/mindwhip
	name = "r-corp mindwhip"
	desc = "Warning: Crossing ANY streams will result in detonation and death. This medibeam should be attached to the enemy, and heals everyone around you"
	icon = 'icons/obj/chronos.dmi'
	icon_state = "rcorp_staff"
	inhand_icon_state = "godstaff-red"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	damtype = BLACK_DAMAGE

	var/mob/living/current_target
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 8
	var/active = FALSE
	var/datum/beam/current_beam = null
	var/mounted = 0 //Denotes if this is a handheld or mounted version
	var/beam_damage = 50

	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/mindwhip/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/gun/mindwhip/Destroy(mob/user)
	STOP_PROCESSING(SSobj, src)
	LoseTarget()
	return ..()

/obj/item/gun/mindwhip/dropped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/mindwhip/equipped(mob/user)
	..()
	LoseTarget()

//Damagetype stuff
/obj/item/gun/mindwhip/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
		if(WHITE_DAMAGE)
			damtype = BLACK_DAMAGE
		if(BLACK_DAMAGE)
			damtype = RED_DAMAGE
	to_chat(user, "<span class='notice'>[src] will now deal [force] [damtype] damage.</span>")
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

/**
 * Proc that always is called when we want to end the beam and makes sure things are cleaned up, see beam_died()
 */
/obj/item/gun/mindwhip/proc/LoseTarget()
	if(active)
		qdel(current_beam)
		current_beam = null
		active = FALSE
		on_beam_release(current_target)
	current_target = null

/**
 * Proc that is only called when the beam fails due to something, so not when manually ended.
 * manual disconnection = LoseTarget, so it can silently end
 * automatic disconnection = beam_died, so we can give a warning message first
 */
/obj/item/gun/mindwhip/proc/beam_died()
	active = FALSE //skip qdelling the beam again if we're doing this proc, because
	if(isliving(loc))
		to_chat(loc, "<span class='warning'>You lose control of the beam!</span>")
	LoseTarget()

/obj/item/gun/mindwhip/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/list/banned_roles = list("R-Corp Scout Raven", "R-Corp Support Raven", "Raven Squad Captain", "R-Corp Suppressive Rabbit", "R-Corp Assault Rabbit", "R-Corp Suppressive Rabbit", "R-Corp Medical Reindeer")
	if(istype(user) && (user?.mind?.assigned_role in banned_roles))
		to_chat(user, "<span class='notice'>You don't know how to use this.</span>")
		return

	if(isliving(user))
		add_fingerprint(user)

	if(current_target)
		LoseTarget()
	if(!isliving(target))
		return

	current_target = target
	active = TRUE
	current_beam = user.Beam(current_target, icon_state="drainbeam", time = 10 MINUTES, maxdistance = max_range, beam_type = /obj/effect/ebeam/medical)
	RegisterSignal(current_beam, COMSIG_PARENT_QDELETING, PROC_REF(beam_died))//this is a WAY better rangecheck than what was done before (process check)

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

/obj/item/gun/mindwhip/process()
	if(!mounted && !isliving(loc))
		LoseTarget()
		return

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

/obj/item/gun/mindwhip/proc/los_check(atom/movable/user, mob/target)
	var/turf/user_turf = user.loc
	if(mounted)
		user_turf = get_turf(user)
	else if(!istype(user_turf))
		return FALSE
	var/obj/dummy = new(user_turf)
	dummy.pass_flags |= PASSTABLE|PASSGLASS|PASSGRILLE //Grille/Glass so it can be used through common windows
	for(var/turf/turf in getline(user_turf,target))
		if(mounted && turf == user_turf)
			continue //Mechs are dense and thus fail the check
		if(turf.density)
			qdel(dummy)
			return FALSE
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return FALSE
		for(var/obj/effect/ebeam/medical/B in turf)// Don't cross the str-beams!
			if(B.owner.origin != current_beam.origin)
				explosion(B.loc,0,0,5,8)
				qdel(dummy)
				return FALSE

		for(var/obj/effect/ebeam/mindwhip/B in turf)// Don't cross the str-beams!
			if(B.owner.origin != current_beam.origin)
				explosion(B.loc,0,0,5,8)
				qdel(dummy)
				return FALSE
	qdel(dummy)
	return TRUE

/obj/item/gun/mindwhip/proc/on_beam_hit(mob/living/target)
	return

/obj/item/gun/mindwhip/proc/on_beam_tick(mob/living/target)
	target.apply_damage(beam_damage, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	for(var/mob/living/carbon/human/L in range(5, get_turf(src)))
		L.adjustSanityLoss(-1)	//Sanity healing for those around, but heals less than the healbeam
		new /obj/effect/temp_visual/heal(get_turf(L), "#80F5FF")
	return

/obj/item/gun/mindwhip/proc/on_beam_release(mob/living/target)
	return

/obj/effect/ebeam/mindwhip
	name = "medical beam"

//////////////////////////////Mech Version///////////////////////////////
/obj/item/gun/mindwhip/mech
	mounted = TRUE

/obj/item/gun/mindwhip/mech/Initialize()
	. = ..()
	STOP_PROCESSING(SSobj, src) //Mech mediguns do not process until installed, and are controlled by the holder obj
