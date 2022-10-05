/mob/living/simple_animal/hostile/abnormality/fragment
	name = "Fragment of the Universe"
	desc = "An abnormality taking form of a black ball covered by 'hearts' of different colors."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fragment"
	icon_living = "fragment"
	maxHealth = 800
	health = 800
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	ranged = TRUE
	melee_damage_lower = 8
	melee_damage_upper = 12
	rapid_melee = 2
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
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
						ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40)
						)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE

	attack_action_types = list(/datum/action/innate/abnormality_attack/fragment_song)

	ego_list = list(
		/datum/ego_datum/weapon/fragment,
		/datum/ego_datum/armor/fragment
		)
	gift_type =  /datum/ego_gifts/fragments
	var/song_cooldown
	var/song_cooldown_time = 10 SECONDS
	var/song_damage = 4 // Dealt 8 times
	var/can_act = TRUE

/datum/action/innate/abnormality_attack/fragment_song
	name = "An Echo From Beyond"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will now deal white damage to all enemies around you.</span>"
	chosen_attack_num = 1

/mob/living/simple_animal/hostile/abnormality/fragment/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fragment/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				song()
		return

	if(song_cooldown <= world.time)
		song()

/mob/living/simple_animal/hostile/abnormality/fragment/proc/song()
	if(song_cooldown > world.time)
		return
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/fragment/sing.ogg', 50, 0, 4)
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
		for(var/mob/living/L in view(8, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(song_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		SLEEP_CHECK_DEATH(3)
	can_act = TRUE
	song_cooldown = world.time + song_cooldown_time

/mob/living/simple_animal/hostile/abnormality/fragment/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fragment/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fragment/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/fragment/breach_effect(mob/living/carbon/human/user)
	..()
	update_icon()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/fragment/update_icon_state()
	if(status_flags & GODMODE) // Not breaching
		icon_state = initial(icon)
	else // Breaching
		icon_state = "fragment_breach"
	icon_living = icon_state
