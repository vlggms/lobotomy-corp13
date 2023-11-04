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
	maxHealth = 10
	health = 10
	del_on_death = FALSE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 70
		)
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/doze,
		/datum/ego_datum/armor/doze
		)
	max_boxes = 10
	gift_type =  /datum/ego_gifts/doze
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	var/grab_cooldown
	var/grab_cooldown_time = 20 SECONDS
	chem_type = /datum/reagent/abnormality/sleeping
	harvest_phrase = span_notice("You give %ABNO a small jostle, releasing some dreamy-looking clouds. You capture them in %VESSEL.")
	harvest_phrase_third = "%PERSON jostles %ABNO, then captures the resulting clouds with %VESSEL."

//work code
/mob/living/simple_animal/hostile/abnormality/sleeping/WorkChance(mob/living/carbon/human/user, chance)
	. = ..()
	if (istype(user.ego_gift_list[EYE], /datum/ego_gifts/doze))
		return chance + 5

/mob/living/simple_animal/hostile/abnormality/sleeping/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	user.apply_status_effect(STATUS_EFFECT_RESTED)
	to_chat(user, span_notice("You feel refreshed!."))
	..()

/mob/living/simple_animal/hostile/abnormality/sleeping/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	user.Stun(5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	to_chat(user, span_userdanger("That was tough work, time for a break."))
	buckle_mob(user)
	update_icon()
	return

/mob/living/simple_animal/hostile/abnormality/sleeping/Life()
	update_icon()
	..()

//chair code
/mob/living/simple_animal/hostile/abnormality/sleeping/post_buckle_mob(mob/living/M)
	..()
	icon_state = icon_active
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
	duration = 600		//Lasts 60 seconds
	alert_type = /atom/movable/screen/alert/status_effect/rested

/atom/movable/screen/alert/status_effect/rested
	name = "Well Rested"
	desc = "You are slowly recovering HP and SP."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "rest"

/datum/status_effect/rested/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(prob(50))
		H.adjustBruteLoss(-1)
		H.adjustSanityLoss(-1)

//pink midnight code

/mob/living/simple_animal/hostile/abnormality/sleeping/AttackingTarget()
	if(grab_cooldown < world.time)
		buckle_mob(target)
		grab_cooldown = world.time + grab_cooldown_time
	return ..()

/mob/living/simple_animal/hostile/abnormality/sleeping/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

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
	addtimer(CALLBACK (C, .mob/living/proc/AdjustSleeping, 20), 2 SECONDS)
	return ..()

/datum/reagent/abnormality/sleeping/on_mob_life(mob/living/L)
	if(!iscarbon(L))
		return
	var/mob/living/carbon/C = L
	addtimer(CALLBACK (C, .mob/living/proc/AdjustSleeping, 20), 2 SECONDS)
	return ..()
