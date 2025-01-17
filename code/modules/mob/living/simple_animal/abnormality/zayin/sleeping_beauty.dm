#define STATUS_EFFECT_RESTED /datum/status_effect/rested
/mob/living/simple_animal/hostile/abnormality/sleeping
	name = "Sleeping Beauty"
	desc = "A cushion with a tag that says \"F-04-36\"."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	density = FALSE
	icon_state = "sleeping_idle"
	icon_living = "sleeping_idle"
	icon_dead = "sleeping_dead"
	var/icon_active = "sleeping_active"
	can_buckle = TRUE
	buckle_lying = 90
	maxHealth = 450
	health = 450
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	del_on_death = FALSE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 70,
	)
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/doze,
		/datum/ego_datum/armor/doze,
	)
	max_boxes = 10
	gift_type =  /datum/ego_gifts/doze
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	move_to_delay = 2.5
	max_buckled_mobs = 10
	chem_type = /datum/reagent/abnormality/sleeping
	harvest_phrase = span_notice("You give %ABNO a small jostle, releasing some dreamy-looking clouds. You capture them in %VESSEL.")
	harvest_phrase_third = "%PERSON jostles %ABNO, then captures the resulting clouds with %VESSEL."

	observation_prompt = "The couch looks inviting, softer and plusher than anything you've ever known. <br>You've been working for so long, it couldn't hurt to take a break?"
	observation_choices = list(
		"Get back to work" = list(TRUE, "You shake your head. You'll have time to rest when you're dead."),
		"Lie down" = list(FALSE, "You lay your head down into your soft and comfy pillow. You can always try again tomorrow."),
	)

	var/grab_cooldown
	var/grab_cooldown_time = 20 SECONDS

//work code
/mob/living/simple_animal/hostile/abnormality/sleeping/WorkChance(mob/living/carbon/human/user, chance)
	if (istype(user.ego_gift_list[EYE], /datum/ego_gifts/doze))
		return chance + 5
	return chance

/mob/living/simple_animal/hostile/abnormality/sleeping/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	user.apply_status_effect(STATUS_EFFECT_RESTED)
	to_chat(user, span_notice("You feel refreshed!."))
	..()

/mob/living/simple_animal/hostile/abnormality/sleeping/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	user.Stun(5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		return
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		return
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		return
	to_chat(user, span_userdanger("That was tough work, time for a break."))
	buckle_mob(user)
	update_icon()
	return

/mob/living/simple_animal/hostile/abnormality/sleeping/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		can_breach = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/sleeping/Life()
	update_icon()
	..()

//chair code
/mob/living/simple_animal/hostile/abnormality/sleeping/post_buckle_mob(mob/living/M)
	..()
	icon_state = icon_active
	M.set_resting(TRUE, silent = TRUE)
	M.apply_status_effect(STATUS_EFFECT_RESTED)
	animate(M, pixel_y = -6, time = 3)

/mob/living/simple_animal/hostile/abnormality/sleeping/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message(span_notice("[user] tries to pull [M] free of [src]!"),\
				span_notice("[user] is trying to pull you off [src]!"),\
				span_hear("You hear tossing and turning..."))
			if(!do_after(user, 30, target = src))
				if(M?.buckled)
					M.visible_message(span_notice("[user] fails to free [M]!"),\
					span_notice("[user] fails to pull you off of [src]."))
				return

		else
			M.visible_message(span_warning("[M] looks like they might get up from [src]!"),\
			span_notice("You try to get up from [src]!"),\
			span_notice("You hear tossing and turning..."))
			if(!do_after(M, 10, target = src))
				to_chat(M, span_warning("There's no rush."))
				return
			if(prob(95))
				if(M?.buckled)
					to_chat(M, span_warning("Maybe just a few more minutes."))
					return
		if(!M.buckled)
			return
		Release_Mob(M)
		update_icon()

/mob/living/simple_animal/hostile/abnormality/sleeping/proc/Release_Mob(mob/living/M)
	unbuckle_mob(M,force=1)
	animate(M, pixel_y = 6, time = 3)
	icon_state = icon_living

//status effect - rested
/datum/status_effect/rested
	id = "rested"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 60 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/rested

/atom/movable/screen/alert/status_effect/rested
	name = "Well Rested"
	desc = "You are slowly recovering HP and SP. More effective when resting or sleeping."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "rest"

/datum/status_effect/rested/tick()
	. = ..()
	var/mob/living/carbon/human/status_holder = owner
	var/heal_amount = 3
	if(status_holder.stat == UNCONSCIOUS)
		heal_amount = 10 // Heals you really fast if you're actually sleeping
		duration += 10 // Does not tick down if you are asleep
	else if(status_holder.resting) // If you are at least sitting it helps
		heal_amount = 6
		duration += 5
	status_holder.adjustBruteLoss(-heal_amount)
	status_holder.adjustSanityLoss(-heal_amount)

//pink midnight code

/mob/living/simple_animal/hostile/abnormality/sleeping/AttackingTarget(atom/attacked_target)
	if(grab_cooldown < world.time)
		buckle_mob(attacked_target)
		grab_cooldown = world.time + grab_cooldown_time
	return ..()

/mob/living/simple_animal/hostile/abnormality/sleeping/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/sleeping/ListTargets()
	. = ..()
	. -= buckled_mobs

#undef STATUS_EFFECT_RESTED

/datum/reagent/abnormality/sleeping
	name = "Puffy clouds"
	description = "Looks like condensed clouds."
	color = "#759ad1"
	special_properties = list("substance may cause drowsiness")
	sanity_restore = 4 // Literally the only context in which this is safe to use is if you're perfectly safe or under attack from a solely white damage abnormality.

/datum/reagent/abnormality/sleeping/on_mob_metabolize(mob/living/L)
	if(!iscarbon(L))
		return
	var/mob/living/carbon/C = L
	to_chat(C, span_warning("You feel tired..."))
	C.blur_eyes(5)
	addtimer(CALLBACK (C, TYPE_PROC_REF(/mob/living, AdjustSleeping), 20), 2 SECONDS)
	return ..()

/datum/reagent/abnormality/sleeping/on_mob_life(mob/living/L)
	if(!iscarbon(L))
		return
	var/mob/living/carbon/C = L
	addtimer(CALLBACK (C, TYPE_PROC_REF(/mob/living, AdjustSleeping), 20), 2 SECONDS)
	return ..()
