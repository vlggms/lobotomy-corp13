/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon
	name = "Selene Effigy"	//Was Fly Me to the Moon but that was a lame name.
	desc = "A pedestal filled with water with a moon effigy in it."
	health = 4000
	maxHealth = 4000
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "moon_pedestal"
	icon_living = "moon_pedestal"

	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0)
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(80, 60, 45, 30, 30),
	)
	max_boxes = 22

	light_color = COLOR_WHITE
	light_range = 30
	light_power = 7

	work_damage_amount = 18
	work_damage_type = WHITE_DAMAGE
	can_patrol = FALSE
	wander = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/lunar_night,
		/datum/ego_datum/armor/branch12/lunar_night,
	)
	//gift_type =  /datum/ego_gifts/insanity
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/list/currently_insane = list()
	var/insanity_counter

	var/pulse_cooldown
	var/pulse_cooldown_time = 12 SECONDS
	var/pulse_damage = 150
	var/weak_pulse_damage = 20

/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/Life()
	. = ..()
	if(!.) // Dead
		return FALSE

	//Pulse stuff
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		pulse_cooldown = world.time + pulse_cooldown_time
		if(insanity_counter)
			insanity_counter--
			WhitePulse()
			return
		else
			BlackPulse()
		return


	//Count up insane people, add them to the insane list
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H in currently_insane)
			continue

		if(H.sanity_lost)
			insanity_counter++
			currently_insane|=H

	//Remove sane people from the insanity list so we can re-count them.
	for(var/mob/living/carbon/human/H in currently_insane)
		if(!H.sanity_lost)
			currently_insane -= H

/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/proc/WhitePulse()
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color =  COLOR_VERY_SOFT_YELLOW, flash_time = 70)

	for(var/mob/living/L in GLOB.mob_list)
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		L.deal_damage((pulse_damage), WHITE_DAMAGE)
	SLEEP_CHECK_DEATH(3)


/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/proc/BlackPulse()
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color =  COLOR_LOBOTOMY_BLACK, flash_time = 70)

	for(var/mob/living/L in GLOB.mob_list)
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		L.deal_damage((weak_pulse_damage), BLACK_DAMAGE)
	SLEEP_CHECK_DEATH(3)

/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	return


/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/fly_moon/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	return TRUE
