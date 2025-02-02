/mob/living/simple_animal/hostile/abnormality/branch12/helios
	name = "Helios Effigy"
	desc = "A pedestal filled with water with a sun effigy in it."
	health = 1700
	maxHealth = 1700
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "sol_pedestal"
	icon_living = "sol_pedestal"

	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0)
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(80, 60, 45, 30, 30),
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 20,
	)

	light_color = COLOR_YELLOW
	light_range = 30
	light_power = 7

	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	can_patrol = FALSE
	wander = FALSE

	ego_list = list(
		//datum/ego_datum/weapon/branch12/solar_day,
		/datum/ego_datum/armor/branch12/solar_day,
	)
	//gift_type =  /datum/ego_gifts/insanity
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/pulse_cooldown
	var/pulse_cooldown_time = 17 SECONDS

/mob/living/simple_animal/hostile/abnormality/branch12/helios/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/helios/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/helios/Life()
	. = ..()
	if(!.) // Dead
		return FALSE

	//Pulse stuff
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		pulse_cooldown = world.time + pulse_cooldown_time
		Flashbang()

/mob/living/simple_animal/hostile/abnormality/branch12/helios/proc/Flashbang()
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color =  COLOR_VERY_SOFT_YELLOW, flash_time = 70)

	for(var/mob/living/L in GLOB.mob_list)
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		L.deal_damage((10), WHITE_DAMAGE)
		L.adjustFireLoss(3)

		if(!ishuman(L))
			continue

		//flashbang
		var/mob/living/carbon/human/H = L
		H.set_confusion(10)
		H.overlay_fullscreen("flash", type)
		addtimer(CALLBACK(H, PROC_REF(clear_fullscreen), "flash", 25), 25)


	SLEEP_CHECK_DEATH(3)


/mob/living/simple_animal/hostile/abnormality/branch12/helios/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	return


/mob/living/simple_animal/hostile/abnormality/branch12/helios/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

/mob/living/simple_animal/hostile/abnormality/branch12/helios/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/helios/proc/on_mob_death(datum/source, mob/living/died, gibbed)
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
