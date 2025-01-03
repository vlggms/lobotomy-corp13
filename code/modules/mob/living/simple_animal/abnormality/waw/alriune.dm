/mob/living/simple_animal/hostile/abnormality/alriune
	name = "Alriune"
	desc = "A tall, pink abnormality that looks similar to a horse. It has 6 pointed legs, an armless human-like upper \
	body covered in bright teal leaves, and a head with empty, flower-filled eye sockets and pink flowers coming out of her mouth."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "alriune"
	icon_living = "alriune"
	portrait = "alriune"

	pixel_x = -8
	base_pixel_x = -8

	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)

	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 2
	// Work chances were slightly changed for it to be possible to get neutral result
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 45, 40, 35),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 50, 45, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 35, 30),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 35, 30, 25),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	good_hater = TRUE

	light_color = COLOR_PINK
	light_range = 9
	light_power = 1

	observation_prompt = "You told me, shedding petals instead of tears. <br>\
		\"We were all nothing but soil once, so do not speak of an end here.\" <br>\
		You told me, blossoming flowers from body as if they are your last words. <br>\"Soon...\""
	observation_choices = list(
		"Spring will come" = list(TRUE, "Spring is coming. <br>Slowly, rapturously, my end began."),
		"Winter will come" = list(TRUE, "Winter is coming. <br>\
			Gradually, my exipation was drawing to an end hectically."),
	)

	/// Currently displayed petals. When value is at 3 - reset to 0 and perform attack
	var/petals_current = 0
	/// World time when petals_current will increase by 1
	var/petals_next = 0
	/// Delay used for petals_next
	var/petals_next_time = 5 SECONDS
	/// Amount of white damage done to everyone in view by the attack
	var/pulse_damage = 180

	ego_list = list(
		/datum/ego_datum/weapon/aroma,
		/datum/ego_datum/armor/aroma,
	)
	gift_type =  /datum/ego_gifts/aroma
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

/* Combat */

/mob/living/simple_animal/hostile/abnormality/alriune/Move()
	if(IsCombatMap())
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/alriune/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		CheckAndPulse()

/mob/living/simple_animal/hostile/abnormality/alriune/CanAttack(atom/the_target)
	return FALSE

/// Check for petals_next and then perform actions
/mob/living/simple_animal/hostile/abnormality/alriune/proc/CheckAndPulse()
	if(world.time >= petals_next)
		petals_next = world.time + petals_next_time
		petals_current += 1
		if(petals_current >= 3) // Attack
			petals_current = 0
			playsound(src, 'sound/abnormalities/alriune/damage.ogg', 75, TRUE, 12)
			// Attack visual effect, so to speak
			for(var/turf/T in view(7, get_turf(src)))
				animate(T, color = COLOR_PINK, time = 2)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(SetColorOverTime), T, initial(T.color), (2 SECONDS)), 4)
			for(var/mob/living/L in livinginview(7, get_turf(src)))
				if(faction_check_mob(L))
					continue
				if(L.stat == DEAD)
					continue
				L.deal_damage(pulse_damage, WHITE_DAMAGE)
				new /obj/effect/temp_visual/alriune_attack(get_turf(L))
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.sanity_lost)
						new /obj/effect/temp_visual/alriune_curtain(get_turf(H))
						addtimer(CALLBACK(H, TYPE_PROC_REF(/atom, add_overlay), \
							icon('ModularTegustation/Teguicons/tegu_effects.dmi', "alriune_kill")), 5)
						playsound(H, 'sound/abnormalities/alriune/kill.ogg', 75, TRUE)
						H.death()
			petals_next = world.time + (petals_next_time * 2)
			addtimer(CALLBACK(src, PROC_REF(TeleportAway)), 2 SECONDS)
		else
			playsound(src, 'sound/abnormalities/alriune/timer.ogg', 50, FALSE, 12)
		update_icon()


/mob/living/simple_animal/hostile/abnormality/alriune/proc/TeleportAway()
	if(IsCombatMap())
		return
	var/list/potential_turfs = list()
	for(var/turf/T in GLOB.xeno_spawn)
		if(get_dist(src, T) < 7)
			continue
		potential_turfs += T
	var/turf/T = pick(potential_turfs)
	if(!istype(T))
		return FALSE
	playsound(src, 'sound/abnormalities/alriune/curtain_out.ogg', 50, TRUE, 12)
	animate(src, alpha = 0, time = 15)
	SLEEP_CHECK_DEATH(15)
	forceMove(T)
	animate(src, alpha = 255, time = 15)
	playsound(src, 'sound/abnormalities/alriune/curtain_in.ogg', 50, TRUE, 12)

/* Overlays */
/mob/living/simple_animal/hostile/abnormality/alriune/update_overlays()
	. = ..()
	if(petals_current <= 0 || stat == DEAD || status_flags & GODMODE)
		cut_overlays()
		return

	var/mutable_appearance/petal_overlay = mutable_appearance(icon, "alriune_petal[petals_current]")
	. += petal_overlay

/* Work stuff */
/mob/living/simple_animal/hostile/abnormality/alriune/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(33))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/alriune/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/* Qliphoth/Breach effects */
/mob/living/simple_animal/hostile/abnormality/alriune/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	petals_next = world.time + petals_next_time + 30
	TeleportAway()
	icon_state = "alriune_active"
	return

