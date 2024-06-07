#define STATUS_EFFECT_ASPIRATION /datum/status_effect/display/aspiration
/obj/structure/toolabnormality/aspiration
	name = "heart of aspiration"
	desc = "A giant red heart."
	icon_state = "heart"
	var/list/active_users = list()

	ego_list = list(
		/datum/ego_datum/weapon/aspiration,
		/datum/ego_datum/armor/aspiration,
	)

/obj/structure/toolabnormality/aspiration/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_ASPIRATION)
		to_chat(user, span_notice("You feel your heart slow again."))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_ASPIRATION)
		to_chat(user, span_userdanger("You feel your blood pumping faster."))

// Status Effect
/datum/status_effect/display/aspiration
	id = "heart_aspiration"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "heart"
	var/panic_override = FALSE
	var/stat_bonus
	var/stat_bonus2
	var/ferventbeats = FALSE
	var/raging = FALSE

/datum/status_effect/display/aspiration/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		stat_bonus = (0.1 * get_attribute_level(owner, JUSTICE_ATTRIBUTE)) //10 + 10% of the user's justice is added as a bonus
		stat_bonus2 = (0.15 * get_attribute_level(owner, FORTITUDE_ATTRIBUTE)) //15 + 15% of the user's fortitude is added as a bonus
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10 + stat_bonus)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 15 + stat_bonus2)

/datum/status_effect/display/aspiration/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(ferventbeats)
		H.adjustBruteLoss(H.maxHealth * (1/100)) //Roughly standard regenerator healing
	if(raging)
		H.adjustBruteLoss(H.maxHealth * (2/100)) //You are most likely going to die, and very soon.
	HealthCheck()

/datum/status_effect/display/aspiration/proc/HealthCheck()
	var/mob/living/carbon/human/H = owner
	if(raging && (H.health > H.maxHealth * 0.25))
		SuperRageDisable()
	if(H.health > H.maxHealth * 0.5)
		if(ferventbeats)
			RageDisable()
		return
	if(!ferventbeats)
		RageEnable()
	if(H.health < H.maxHealth * 0.25)
		if(!raging)
			SuperRageEnable()
	if(H.stat == DEAD)
		var/obj/item/organ/heart/heart = H.getorganslot(ORGAN_SLOT_HEART)
		if(istype(heart))
			QDEL_NULL(heart)
			return
		H.visible_message(span_danger("[H]'s heart explodes!"))
		new /obj/effect/gibspawner/generic(get_turf(H))
		H.remove_status_effect(src)

/datum/status_effect/display/aspiration/proc/RageEnable()
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_userdanger("You feel your blood running wild!"))
	H.playsound_local(get_turf(H), 'sound/abnormalities/nothingthere/heartbeat.ogg', 50, 0, 3)
	ferventbeats = TRUE
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOHARDCRIT, STATUS_EFFECT_TRAIT)
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 20 + (2 * stat_bonus)) //total of 3 times the original bonus

/datum/status_effect/display/aspiration/proc/SuperRageEnable()
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_userdanger("Your heart... It's too much!"))
	H.playsound_local(get_turf(H), 'sound/abnormalities/nothingthere/heartbeat2.ogg', 50, 0, 3)
	raging = TRUE
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 20 + (2 * stat_bonus)) //total of 5 times the original bonus

/datum/status_effect/display/aspiration/proc/RageDisable()
	var/mob/living/carbon/human/H = owner
	ferventbeats = FALSE
	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOHARDCRIT, STATUS_EFFECT_TRAIT)
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -20 - (2 * stat_bonus))

/datum/status_effect/display/aspiration/proc/SuperRageDisable()
	var/mob/living/carbon/human/H = owner
	raging = FALSE
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -20 - (2 * stat_bonus))

/datum/status_effect/display/aspiration/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10 - stat_bonus)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -15 - stat_bonus2)
	if(ferventbeats)
		RageDisable()
	if(raging)
		SuperRageDisable()

#undef STATUS_EFFECT_ASPIRATION
