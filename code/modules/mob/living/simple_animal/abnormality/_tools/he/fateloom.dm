#define STATUS_EFFECT_REDSTRING /datum/status_effect/stacking/red_string
/obj/structure/toolabnormality/fateloom
	name = "third fate's loom"
	desc = "It is surrounded by spools of red thread."
	icon_state = "loom"

	ego_list = list(
		/datum/ego_datum/weapon/destiny,
		/datum/ego_datum/armor/destiny,
	)

/obj/structure/toolabnormality/fateloom/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 10))
		return

	var/datum/status_effect/stacking/red_string/S = user.has_status_effect(/datum/status_effect/stacking/red_string)
	if(!S)
		to_chat(user, span_userdanger("As you touch the loom, threads are sewn into your flesh."))
		user.apply_status_effect(STATUS_EFFECT_REDSTRING)
	else
		to_chat(user, span_notice("You touch the loom, and the threads return to it."))
		user.remove_status_effect(STATUS_EFFECT_REDSTRING)
		return
	user.playsound_local(src, 'sound/abnormalities/fateloom/garrote_bloody.ogg', 60, TRUE)

// Status Effect
/datum/status_effect/stacking/red_string
	id = "stacking_red_string"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 120 SECONDS //2 minutes
	alert_type = null
	stack_decay = -1
	stacks = 4 //was 3, until I figured out that 0 stacks causes stacking status effects to forcibly qdel
	max_stacks = 4
	consumed_on_threshold = FALSE
	overlay_file = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	overlay_state = "fateloom"

/datum/status_effect/stacking/red_string/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(heal))
	return ..()

/datum/status_effect/stacking/red_string/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
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

/datum/status_effect/stacking/red_string/tick()
	if(!can_have_status())
		qdel(src)
	else
		stack_decay_effect()
		add_stacks(-stack_decay)

/datum/status_effect/stacking/red_string/stack_decay_effect()
	if(stacks < max_stacks)
		to_chat(owner, span_nicegreen("The threads have been reinforced."))
		playsound(owner, 'sound/weapons/cablecuff.ogg', 15, TRUE, -2)

#undef STATUS_EFFECT_REDSTRING
