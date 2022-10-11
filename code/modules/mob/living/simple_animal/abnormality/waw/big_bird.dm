/mob/living/simple_animal/hostile/abnormality/big_bird
	name = "Big bird"
	desc = "A large, many-eyed bird that patrols the dark forest with an everlasting lamp. \
	Unlike regular birds, it lacks wings and has long arms instead with which it can pick things up."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "big_bird"
	icon_living = "big_bird"
	faction = list("hostile", "Apocalypse")
	speak_emote = list("chirps")

	pixel_x = -16
	base_pixel_x = -16

	ranged = TRUE
	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	see_in_dark = 10
	stat_attack = HARD_CRIT

	speed = 4
	move_to_delay = 5
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 5
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(45, 45, 45, 50, 50),
						ABNORMALITY_WORK_INSIGHT = 35,
						ABNORMALITY_WORK_ATTACHMENT = list(40, 45, 50, 55, 55),
						ABNORMALITY_WORK_REPRESSION = list(25, 20, 15, 10, 0)
						)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE

	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7

	// This stuff is only done to non-humans and objects
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	melee_damage_lower = 100
	melee_damage_upper = 100

	attack_action_types = list(/datum/action/innate/abnormality_attack/hypnosis)

	ego_list = list(
		/datum/ego_datum/weapon/lamp,
		/datum/ego_datum/armor/lamp
		)
	gift_type =  /datum/ego_gifts/lamp

	var/bite_cooldown
	var/bite_cooldown_time = 8 SECONDS
	var/hypnosis_cooldown
	var/hypnosis_cooldown_time = 16 SECONDS
	/// How many people died at the moment? When it hits 3 - reduce qliphoth and reset counter to 0.
	var/death_counter = 0

/datum/action/innate/abnormality_attack/hypnosis
	name = "Hypnosis"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will now put random human near you to sleep.</span>"
	chosen_attack_num = 1

/mob/living/simple_animal/hostile/abnormality/big_bird/OpenFire()
	if(client)
		switch(chosen_attack)
			if(1)
				hypnotize()
		return

	if(get_dist(src, target) > 2 && hypnosis_cooldown <= world.time)
		hypnotize()

/mob/living/simple_animal/hostile/abnormality/big_bird/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/on_mob_death) // Hell

/mob/living/simple_animal/hostile/abnormality/big_bird/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/Moved()
	. = ..()
	if(!(status_flags & GODMODE)) // Whitaker nerf
		playsound(get_turf(src), 'sound/abnormalities/bigbird/step.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/big_bird/CanAttack(atom/the_target)
	if(ishuman(the_target))
		if(bite_cooldown > world.time)
			return FALSE
		var/mob/living/carbon/human/H = the_target
		var/obj/item/bodypart/head/head = H.get_bodypart("head")
		if(!istype(head)) // You, I'm afraid, are headless
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/AttackingTarget()
	if(ishuman(target))
		if(bite_cooldown > world.time)
			return FALSE
		var/mob/living/carbon/human/H = target
		var/obj/item/bodypart/head/head = H.get_bodypart("head")
		if(QDELETED(head))
			return
		head.dismember()
		QDEL_NULL(head)
		H.regenerate_icons()
		visible_message("<span class='danger'>\The [src] bites [H]'s head off!</span>")
		new /obj/effect/gibspawner/generic/silent(get_turf(H))
		playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
		bite_cooldown = world.time + bite_cooldown_time
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/hypnotize()
	if(hypnosis_cooldown > world.time)
		return
	hypnosis_cooldown = world.time + hypnosis_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/bigbird/hypnosis.ogg', 50, 1, 2)
	for(var/mob/living/carbon/C in view(7, src))
		if(faction_check_mob(C, FALSE))
			continue
		if(!CanAttack(C))
			continue
		if(prob(66))
			to_chat(C, "<span class='warning'>You feel sleepy...</span>")
			C.drowsyness += 4
			addtimer(CALLBACK (C, .mob/living/proc/AdjustSleeping, 2 SECONDS), 4 SECONDS)

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	death_counter += 1
	if(death_counter >= 2)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/big_bird/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/big_bird/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return


