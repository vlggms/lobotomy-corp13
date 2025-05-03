#define STATUS_EFFECT_DRAGON_COURAGE /datum/status_effect/display/dragon_courage
/obj/structure/toolabnormality/dragonskull
	name = "the dragon skull"
	desc = "A formation of wood twisted into the shape of a skull. It feels oddly warm to the touch."
	icon_state = "dragon_skull"
	var/list/active_users = list()

	ego_list = list(
		/obj/item/ego_weapon/support/dragon_staff,
		/obj/item/clothing/suit/armor/ego_gear/zayin/dragon_staff,
	)

/obj/structure/toolabnormality/dragonskull/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	if(user in active_users)
		active_users -= user
		user.remove_status_effect(STATUS_EFFECT_DRAGON_COURAGE)
		to_chat(user, span_userdanger("Your greatest fears return to the fringes of your mind."))
	else
		active_users += user
		user.apply_status_effect(STATUS_EFFECT_DRAGON_COURAGE)
		to_chat(user, span_userdanger("You tap [src] and peer into the dark eyes that litter its surface. Fascinated, you experience a childlike desire for adventure."))

// Status Effect
/datum/status_effect/display/dragon_courage
	id = "dragon courage"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "dragon"

/datum/status_effect/display/dragon_courage/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		RegisterSignal(H, COMSIG_HUMAN_INSANE, PROC_REF(UserInsane))
		H.physiology.fear_mod += 1

/datum/status_effect/display/dragon_courage/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		UnregisterSignal(H, COMSIG_HUMAN_INSANE)
		H.physiology.fear_mod -= 1

/datum/status_effect/display/dragon_courage/proc/UserInsane()
	var/mob/living/carbon/human/H = owner
	H.visible_message(span_danger("[H]'s scream is quickly silenced as wooden tendrils emerge from [H.p_their(FALSE)] scalp!"))
	playsound(get_turf(H), 'sound/abnormalities/faelantern/faelantern_breach.ogg', 200, 1)
	H.petrify(480, list(rgb(145,116,60)), "A distorted and screaming wooden statue.")
	H.remove_status_effect(src)

#undef STATUS_EFFECT_DRAGON_COURAGE
