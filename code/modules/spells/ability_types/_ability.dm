/obj/effect/proc_holder/ability
	name = "ability"
	desc = "An ability."
	panel = "Abilities"
	anchored = TRUE
	pass_flags = PASSTABLE
	density = FALSE
	opacity = FALSE

	action_icon = 'icons/mob/actions/actions_ability.dmi'
	action_icon_state = "default"
	action_background_icon_state = "bg_spell"
	base_action = /datum/action/spell_action/ability/item

	var/stat_allowed = FALSE
	/// Current cooldown.
	var/cooldown = 0
	/// Time added to cooldown on use.
	var/cooldown_time = 0

/obj/effect/proc_holder/ability/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/ability/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	qdel(action)
	return ..()

/obj/effect/proc_holder/ability/process(delta_time)
	if(action && world.time > cooldown)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/ability/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		return
	Perform(null, user)

/obj/effect/proc_holder/ability/update_icon()
	if(!action)
		return
	action.UpdateButtonIcon()

/obj/effect/proc_holder/ability/proc/can_cast(mob/user = usr)
	if(cooldown > world.time)
		return FALSE

	if(!action || action.owner != user)
		return FALSE

	if(user.stat && !stat_allowed)
		return FALSE

	if(user.incapacitated())
		return FALSE

	return TRUE

/obj/effect/proc_holder/ability/proc/Perform(target, user)
	cooldown = world.time + cooldown_time
	if(cooldown_time > 0)
		remove_ranged_ability()
	return

/obj/effect/proc_holder/ability/aimed/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	var/msg
	if(!can_cast(user))
		remove_ranged_ability()
		return
	if(active)
		msg = "<span class='notice'>You decide not to use [src].</span>"
		remove_ranged_ability(msg)
		on_deactivation(user)
	else
		msg = "<span class='notice'><B>Left-click to perform the ability!</B></span>"
		add_ranged_ability(user, msg, TRUE)
		on_activation(user)

/obj/effect/proc_holder/ability/aimed/proc/on_activation(mob/user)
	return

/obj/effect/proc_holder/ability/aimed/proc/on_deactivation(mob/user)
	return

/obj/effect/proc_holder/ability/aimed/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	action.UpdateButtonIcon()

/obj/effect/proc_holder/ability/aimed/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return FALSE
	if(!can_cast())
		remove_ranged_ability()
		return FALSE
	Perform(target, user = ranged_ability_user)
	return TRUE
