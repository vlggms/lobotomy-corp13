#define STATUS_EFFECT_REDSTRING /datum/status_effect/stacking/red_string
/obj/structure/toolabnormality/fateloom
	name = "third fate's loom"
	desc = "It is surrounded by spools of red thread."
	icon_state = "loom"
	var/usage_cooldown
	var/usage_cooldown_time = 5 SECONDS

	ego_list = list(
		/datum/ego_datum/weapon/destiny,
		/datum/ego_datum/armor/destiny,
	)

/obj/structure/toolabnormality/fateloom/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 10))
		return
	if(usage_cooldown > world.time) //just to prevent sfx spam
		to_chat(user, span_warning("The loom is already spinning!"))
		return
	usage_cooldown = world.time + usage_cooldown_time

	var/datum/status_effect/stacking/red_string/S = user.has_status_effect(/datum/status_effect/stacking/red_string)
	if(!S)
		to_chat(user, span_userdanger("As you touch the loom, threads are sewn into your flesh."))
		user.apply_status_effect(STATUS_EFFECT_REDSTRING)
	else if (S.stacks == 4)
		to_chat(user, span_warning("You don't need to use this."))
		return
	else
		to_chat(user, span_userdanger("The threads which were once sparse are now reinforced."))
		to_chat(user, span_userdanger("You feel weaker."))
		S.add_stacks(4)
		user.adjust_attribute_level(FORTITUDE_ATTRIBUTE, -15)
	playsound(src, 'sound/abnormalities/fateloom/garrote_bloody.ogg', 80, TRUE, -3)

// Status Effect
/datum/status_effect/stacking/red_string
	id = "stacking_red_string"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	stack_decay = 0
	stacks = 4 //was 3, until I figured out that 0 stacks causes stacking status effects to forcibly qdel
	max_stacks = 4
	consumed_on_threshold = FALSE

/datum/status_effect/stacking/red_string/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(heal))
	return ..()

/datum/status_effect/stacking/red_string/proc/heal()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(QDELETED(H) || H.stat == DEAD)
		return
	if(H.health > H.maxHealth * 0.5)
		return
	if(stacks > 1)
		playsound(H, 'sound/abnormalities/fateloom/garrote.ogg', 80, TRUE, -3)
		H.adjustBruteLoss(-(H.maxHealth * 0.5))
		H.adjustSanityLoss(H.maxHealth * 0.5) // lose sanity by how much health you gain
		if(stacks > 2)
			to_chat(H, span_userdanger("You lose some of your threads!"))
		else if (stacks == 2)
			to_chat(H, span_userdanger("You are running low on threads!"))
	else
		to_chat(H, span_userdanger("Your entire body falls apart!"))
		for(var/X in H.bodyparts)
			var/obj/item/bodypart/BP = X
			if(BP.body_part && BP.body_part != CHEST)
				if(BP.dismemberable)
					BP.dismember()
		playsound(H, 'sound/abnormalities/fateloom/garrote_bloody.ogg', 80, TRUE, -3)
		new /obj/effect/gibspawner/generic/silent(get_turf(H))
		H.regenerate_icons()
	add_stacks(-1)

#undef STATUS_EFFECT_REDSTRING
