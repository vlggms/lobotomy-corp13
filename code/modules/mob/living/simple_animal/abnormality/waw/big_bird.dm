#define BIGBIRD_HYPNOSIS_COOLDOWN (16 SECONDS)

/mob/living/simple_animal/hostile/abnormality/big_bird
	name = "Big Bird"
	desc = "A large, many-eyed bird that patrols the dark forest with an everlasting lamp. \
	Unlike regular birds, it lacks wings and instead has long arms with which it can pick things up."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "big_bird"
	icon_living = "big_bird"
	portrait = "big_bird"
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

	move_to_delay = 5
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 45, 45, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = list(40, 45, 50, 55, 55),
		ABNORMALITY_WORK_REPRESSION = list(25, 20, 15, 10, 0),
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE

	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7

	// This stuff is only done to non-humans and objects
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 100
	melee_damage_upper = 100

	ego_list = list(
		/datum/ego_datum/weapon/lamp,
		/datum/ego_datum/armor/lamp,
	)
	gift_type =  /datum/ego_gifts/lamp
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/judgement_bird = 3,
		/mob/living/simple_animal/hostile/abnormality/punishing_bird = 3,
	)

	var/bite_cooldown
	var/bite_cooldown_time = 8 SECONDS
	var/hypnosis_cooldown
	var/hypnosis_cooldown_time = 16 SECONDS

	//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/cooldown/big_bird_hypnosis)

/datum/action/cooldown/big_bird_hypnosis
	name = "Dazzle"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "big_bird"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = BIGBIRD_HYPNOSIS_COOLDOWN //16 seconds

/datum/action/cooldown/big_bird_hypnosis/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/big_bird))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/big_bird/big_bird = owner
	if(big_bird.IsContained()) // No more using cooldowns while contained
		return FALSE
	StartCooldown()
	big_bird.hypnotize()
	return TRUE


/mob/living/simple_animal/hostile/abnormality/big_bird/OpenFire()
	if(client)
		return

	if(get_dist(src, target) > 2 && hypnosis_cooldown <= world.time)
		hypnotize()

/mob/living/simple_animal/hostile/abnormality/big_bird/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

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
		visible_message(span_danger("\The [src] bites [H]'s head off!"))
		new /obj/effect/gibspawner/generic/silent(get_turf(H))
		playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
		flick("big_bird_chomp", src)
		bite_cooldown = world.time + bite_cooldown_time
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/hypnotize()
	if(hypnosis_cooldown > world.time)
		return
	hypnosis_cooldown = world.time + hypnosis_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/bigbird/hypnosis.ogg', 50, 1, 2)
	for(var/mob/living/carbon/C in view(8, src))
		if(faction_check_mob(C, FALSE))
			continue
		if(!CanAttack(C))
			continue
		if(ismoth(C))
			pick(C.emote("scream"), C.visible_message(span_boldwarning("[C] lunges for the light!")))
			C.throw_at((src), 10, 2)
		if(prob(66))
			to_chat(C, span_warning("You feel tired..."))
			C.blur_eyes(5)
			addtimer(CALLBACK (C, TYPE_PROC_REF(/mob, blind_eyes), 2), 2 SECONDS)
			addtimer(CALLBACK (C, TYPE_PROC_REF(/mob/living, Stun), 2 SECONDS), 2 SECONDS)
			var/new_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted", -HALO_LAYER)
			C.add_overlay(new_overlay)
			addtimer(CALLBACK (C, TYPE_PROC_REF(/atom, cut_overlay), new_overlay), 4 SECONDS)

/mob/living/simple_animal/hostile/abnormality/big_bird/proc/on_mob_death(datum/source, mob/living/died, gibbed)
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

/mob/living/simple_animal/hostile/abnormality/big_bird/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/big_bird/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

#undef BIGBIRD_HYPNOSIS_COOLDOWN
