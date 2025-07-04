/obj/item/clothing/suit/armor/ego_gear/city/insurgence_transport
	flags_inv = HIDEJUMPSUIT | HIDEGLOVES
	name = "grade 1 transport armor"
	desc = "Armor worn by insurgence clan transport agents."
	icon_state = "transport"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 0)
	hat = /obj/item/clothing/head/ego_hat/helmet/insurgence_transport
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/head/ego_hat/helmet/insurgence_transport
	name = "grade 1 transport helmet"
	desc = "A helmet worn by insurgence clan transport agents."
	icon_state = "transport"

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch
	name = "grade 1 nightwatch armor"
	desc = "Armor worn by insurgence clan nightwatch agents."
	icon_state = "nightwatch"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 70, BLACK_DAMAGE = 70, PALE_DAMAGE = 30)
	hat = /obj/item/clothing/head/ego_hat/helmet/insurgence_nightwatch
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/cloak_active = FALSE
	var/cloak_alpha = 255
	var/damage_modifier = 1
	actions_types = list(/datum/action/item_action/nightwatch_cloak)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/ToggleCloak(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(!H.mind || H.mind.assigned_role != "Insurgence Nightwatch Agent")
		to_chat(user, span_warning("This armor's systems do not recognize you."))
		return

	if(!cloak_active)
		ActivateCloak(user)
	else
		DeactivateCloak(user)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/ActivateCloak(mob/living/user)
	cloak_active = TRUE
	to_chat(user, span_notice("You activate the cloaking field."))
	playsound(user, 'sound/effects/stealthoff.ogg', 30, TRUE)
	damage_modifier = 0.5
	animate(user, alpha = 0, time = 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(FullCloak), user), 5 SECONDS)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/FullCloak(mob/living/user)
	if(!cloak_active || user.loc != loc)
		return
	user.density = FALSE
	user.invisibility = INVISIBILITY_OBSERVER
	to_chat(user, span_notice("You are now fully cloaked."))

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/DeactivateCloak(mob/living/user)
	cloak_active = FALSE
	to_chat(user, span_warning("Your cloaking field deactivates!"))
	playsound(user, 'sound/effects/stealthoff.ogg', 30, TRUE)
	damage_modifier = 1
	user.density = TRUE
	user.invisibility = initial(user.invisibility)
	animate(user, alpha = 255, time = 2 SECONDS)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/equipped(mob/living/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_OCLOTHING)
		return
	RegisterSignal(user, COMSIG_MOB_ITEM_ATTACK, PROC_REF(OnAttack))

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_ITEM_ATTACK)
	if(cloak_active)
		DeactivateCloak(user)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/OnAttack(mob/living/user)
	SIGNAL_HANDLER
	if(cloak_active)
		DeactivateCloak(user)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/GetDamageModifier()
	return damage_modifier

/datum/action/item_action/nightwatch_cloak
	name = "Toggle Cloak"
	desc = "Activate or deactivate your cloaking field."
	button_icon_state = "sniper_zoom"
	icon_icon = 'icons/mob/actions/actions_items.dmi'

/datum/action/item_action/nightwatch_cloak/Trigger()
	if(!istype(target, /obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch))
		return
	var/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/N = target
	N.ToggleCloak(owner)

/obj/item/clothing/head/ego_hat/helmet/insurgence_nightwatch
	name = "grade 1 nightwatch helmet"
	desc = "A helmet worn by insurgence clan nightwatch agents."
	icon_state = "nightwatch"
