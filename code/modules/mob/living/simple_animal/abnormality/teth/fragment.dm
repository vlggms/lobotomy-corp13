#define FRAGMENT_SONG_COOLDOWN (14 SECONDS)

/mob/living/simple_animal/hostile/abnormality/fragment
	name = "Fragment of the Universe"
	desc = "An abnormality taking form of a black ball covered by 'hearts' of different colors."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fragment"
	icon_living = "fragment"
	portrait = "fragment"
	maxHealth = 800
	health = 800
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	ranged = TRUE
	melee_damage_lower = 8
	melee_damage_upper = 12
	rapid_melee = 2
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/fragment/attack.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 30, 20, 20, 20),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 50, 50, 50),
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40),
	)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/fragment,
		/datum/ego_datum/armor/fragment,
	)
	gift_type =  /datum/ego_gifts/fragments
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	var/song_cooldown
	var/song_cooldown_time = 10 SECONDS
	var/song_damage = 5 // Dealt 8 times
	var/can_act = TRUE

	//Visual/Animation Vars
	var/obj/effect/fragment_legs/legs
	var/obj/particle_emitter/fragment_note/particle_note
	var/obj/particle_emitter/fragment_song/particle_song

	//PLAYABLES ACTIONS
	attack_action_types = list(/datum/action/cooldown/fragment_song)

/datum/action/cooldown/fragment_song
	name = "Sing"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "fragment"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = FRAGMENT_SONG_COOLDOWN //14 seconds

/datum/action/cooldown/fragment_song/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/fragment))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/fragment/fragment = owner
	if(fragment.IsContained()) // No more using cooldowns while contained
		return FALSE
	StartCooldown()
	fragment.song()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/fragment/Destroy()
	QDEL_NULL(legs)
	if(!particle_note)
		return ..()
	particle_note.fadeout()
	particle_song.fadeout()
	return ..()

/mob/living/simple_animal/hostile/abnormality/fragment/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fragment/OpenFire()
	if(!can_act || client)
		return

	if(song_cooldown <= world.time)
		song()

/mob/living/simple_animal/hostile/abnormality/fragment/proc/song()
	if(song_cooldown > world.time)
		return
	can_act = FALSE
	flick("fragment_song_transition" , src)
	SLEEP_CHECK_DEATH(5)

	legs = new(get_turf(src))
	icon_state = "fragment_song_head"
	pixel_y = 5
	particle_note = new(get_turf(src))
	particle_note.pixel_y = 26
	particle_song = new(get_turf(src))
	particle_song.pixel_y = 26
	playsound(get_turf(src), 'sound/abnormalities/fragment/sing.ogg', 50, 0, 4)
	for(var/i = 1 to 8)
		//Animation for bobbing the head left to right
		switch(i)
			if(1)
				animate(src, transform = turn(matrix(), -30), time = 6, flags = SINE_EASING | EASE_OUT )
			if(3)
				animate(src, transform = turn(matrix(), 0), time = 6, flags = SINE_EASING | EASE_IN | EASE_OUT )
			if(5)
				animate(src, transform = turn(matrix(), 30), time = 6, flags = SINE_EASING | EASE_IN | EASE_OUT )
			if(7)
				animate(src, transform = turn(matrix(), 0), time = 6, flags = SINE_EASING | EASE_IN )
		//Animation -END-

		for(var/mob/living/L in view(8, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(song_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		SLEEP_CHECK_DEATH(3)

	animate(src, pixel_y = 0, time = 0)
	QDEL_NULL(legs)
	flick("fragment_song_transition" , src)
	SLEEP_CHECK_DEATH(5)
	icon_state = "fragment_breach"
	pixel_y = 0
	can_act = TRUE
	song_cooldown = world.time + song_cooldown_time
	if(!particle_note)
		return
	particle_note.fadeout()
	particle_song.fadeout()

/mob/living/simple_animal/hostile/abnormality/fragment/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fragment/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fragment/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fragment/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/fragment/update_icon_state()
	if(status_flags & GODMODE) // Not breaching
		icon_state = initial(icon)
	else // Breaching
		icon_state = "fragment_breach"
	icon_living = icon_state

//Exists so the head can be animated separatedly from the legs when it sings
/obj/effect/fragment_legs
	name = "Fragment of the Universe"
	desc = "An abnormality taking form of a black ball covered by 'hearts' of different colors."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fragment_song_legs"
	move_force = INFINITY
	pull_force = INFINITY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

#undef FRAGMENT_SONG_COOLDOWN
