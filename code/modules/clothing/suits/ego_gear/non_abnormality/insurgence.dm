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
	var/cloak_cooldown = 0
	var/cloak_cooldown_time = 30 SECONDS
	actions_types = list(/datum/action/item_action/nightwatch_cloak, /datum/action/item_action/corrupted_whisper)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/ToggleCloak(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(!H.mind || H.mind.assigned_role != "Insurgence Nightwatch Agent")
		to_chat(user, span_warning("This armor's systems do not recognize you."))
		return

	if(!cloak_active)
		if(world.time < cloak_cooldown)
			var/remaining = round((cloak_cooldown - world.time) / 10)
			to_chat(user, span_warning("Cloaking systems recharging. Ready in [remaining] seconds."))
			return
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
	if(!cloak_active)
		return
	user.density = FALSE
	user.invisibility = INVISIBILITY_OBSERVER
	to_chat(user, span_notice("You are now fully cloaked."))

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/DeactivateCloak(mob/living/user)
	cloak_active = FALSE
	cloak_cooldown = world.time + cloak_cooldown_time
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
	RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, PROC_REF(OnDamage))

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	if(cloak_active)
		DeactivateCloak(user)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/OnAttack(mob/living/user)
	SIGNAL_HANDLER
	if(cloak_active)
		DeactivateCloak(user)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/OnDamage(mob/living/user, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(cloak_active && damage > 0)
		to_chat(user, span_warning("Your cloak flickers and fails as you take damage!"))
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

/datum/action/item_action/corrupted_whisper
	name = "Corrupted Whisper"
	desc = "Send a telepathic message to those touched by the Elder One's corruption."
	button_icon_state = "r_transmit"
	icon_icon = 'icons/mob/actions/actions_revenant.dmi'

/datum/action/item_action/corrupted_whisper/Trigger()
	if(!istype(target, /obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch))
		return
	var/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/N = target
	N.CorruptedWhisper(owner)

/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/proc/CorruptedWhisper(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(!H.mind || H.mind.assigned_role != "Insurgence Nightwatch Agent")
		to_chat(user, span_warning("This armor's systems do not recognize you."))
		return

	// Find all humans with mental corrosion within range
	var/list/possible_targets = list()
	for(var/mob/living/carbon/human/target in view(7, user))
		if(target == user || target.stat == DEAD)
			continue

		// Check if they have mental corrosion
		var/has_corrosion = FALSE
		for(var/datum/component/augment/mental_corrosion/MC in target.GetComponents(/datum/component/augment/mental_corrosion))
			has_corrosion = TRUE
			break

		if(has_corrosion)
			possible_targets += target

	if(!length(possible_targets))
		to_chat(user, span_warning("There are no corrupted minds within range."))
		return

	// Select target
	var/mob/living/carbon/human/chosen_target = input(user, "Choose a corrupted mind to whisper to:", "Corrupted Whisper") as null|anything in possible_targets
	if(!chosen_target || get_dist(user, chosen_target) > 7)
		return

	// Get message
	var/msg = stripped_input(user, "What corruption do you wish to whisper to [chosen_target]?", "Corrupted Whisper", "")
	if(!msg)
		return

	// Log the communication
	log_directed_talk(user, chosen_target, msg, LOG_SAY, "Corrupted Whisper")

	// Send to user
	to_chat(user, span_boldnotice("You send a corrupted whisper to [chosen_target]:") + span_notice(" [msg]"))

	// Send to target using show_blurb like mental corrosion
	if(chosen_target.client)
		// Random position matching mental_corrosion style
		var/tile_x = rand(3, 11)
		var/tile_y = rand(3, 11)
		var/pixel_x = rand(-16, 16)
		var/pixel_y = rand(-16, 16)
		show_blurb(chosen_target.client, 50, msg, 10, "#ff4848", "black", "center", "[tile_x]:[pixel_x],[tile_y]:[pixel_y]")
		chosen_target.playsound_local(chosen_target, 'sound/abnormalities/whitenight/whisper.ogg', 25, TRUE)

	// Notify ghosts
	for(var/mob/dead/observer/ghost in GLOB.dead_mob_list)
		var/follow_insurgent = FOLLOW_LINK(ghost, user)
		var/follow_target = FOLLOW_LINK(ghost, chosen_target)
		to_chat(ghost, "[follow_insurgent] <span class='boldnotice'>[user] Corrupted Whisper:</span> <span class='notice'>\"[msg]\" to</span> [follow_target] [span_name("[chosen_target]")]")
