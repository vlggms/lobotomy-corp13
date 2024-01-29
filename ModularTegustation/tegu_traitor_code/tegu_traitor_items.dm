// Advanced mulligan. Basically, a device that acts just like changeling's sting and transformation ability.
// Only one use to mutate, but can be reused unlimited amount of times to store another DNA before transformation.

/obj/item/adv_mulligan
	name = "advanced mulligan"
	desc = "Toxin that permanently changes your DNA into the one of last injected person."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "dnainjector0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/used = FALSE
	var/mob/living/carbon/human/stored

/obj/item/adv_mulligan/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	return //Stealth

/obj/item/adv_mulligan/afterattack(atom/movable/AM, mob/living/carbon/human/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!istype(user))
		return
	if(used)
		to_chat(user, span_warning("[src] has been already used, you can't activate it again!"))
		return
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(user.real_name != H.dna.real_name)
			stored = H
			to_chat(user, span_notice("You stealthly stab [H.name] with [src]."))
			desc = "Toxin that permanently changes your DNA into the one of last injected person. It has DNA of <span class='blue'>[stored.dna.real_name]</span> inside."
			icon_state = "dnainjector"
		else
			if(stored)
				mutate(user)
			else
				to_chat(user, span_warning("You can't stab yourself with [src]!"))

/obj/item/adv_mulligan/attack_self(mob/living/carbon/user)
	mutate(user)

/obj/item/adv_mulligan/proc/mutate(mob/living/carbon/user)
	if(used)
		to_chat(user, span_warning("[src] has been already used, you can't activate it again!"))
		return
	if(!used)
		if(stored)
			user.visible_message(span_warning("[user.name] shivers in pain and soon transform into [stored.dna.real_name]!"), \
			span_notice("You inject yourself with [src] and suddenly become a copy of [stored.dna.real_name]."))

			user.real_name = stored.real_name
			stored.dna.transfer_identity(user, transfer_SE=1)
			user.updateappearance(mutcolor_update=1)
			user.domutcheck()
			used = TRUE

			icon_state = "dnainjector0"
			desc = "Toxin that permanently changes your DNA into the one of last injected person. This one is used up."

		else
			to_chat(user, span_warning("[src] doesn't have any DNA loaded in it!"))

// A "nuke op" kit for Gorlex Infiltrators, available for 15 TC.
/obj/item/storage/backpack/duffelbag/syndie/flukeop/PopulateContents()
	new /obj/item/clothing/suit/space/hardsuit/syndi(src) //8 TC
	new /obj/item/storage/box/syndie_kit/imp_microbomb(src) //2 TC
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/clothing/gloves/combat(src) //1 TC?
	new /obj/item/gun/ballistic/automatic/pistol(src) //7 TC
	new /obj/item/ammo_box/magazine/m9mm(src) //1TC

// A kit for LUFR operatives. Available only to lizard infiltrators that got lucky enough to get this faction.
// Costs 14 TC.
/obj/item/storage/backpack/duffelbag/syndie/lufr/PopulateContents()
	new /obj/item/clothing/head/hos/beret/syndicate(src) //1 TC
	new /obj/item/clothing/mask/balaclava(src) //0 TC, haha
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/clothing/gloves/combat(src) //1 TC?
	new /obj/item/clothing/under/mercenary/coldres(src) //2-3 TC?
	new /obj/item/clothing/shoes/combat(src) //Free, idk
	new /obj/item/gun/ballistic/automatic/pistol(src) //7 TC
	new /obj/item/ammo_box/magazine/m9mm(src) //1TC
	new /obj/item/grenade/chem_grenade/clf3(src) //1 TC, I suppose
	new /obj/item/grenade/frag(src) //3 TC

// Advanced hypno-flash. For psychologists.
/obj/item/assembly/flash/hypnotic/adv
	desc = "A modified flash device, used to beam preprogrammed orders directly into the target's mind."
	light_color = COLOR_RED_LIGHT
	var/hypno_cooldown = 59 SECONDS // Big damn cooldown
	var/hypno_cooldown_current
	var/hypno_message // User can change it by alt-clicking the flash.

/obj/item/assembly/flash/hypnotic/adv/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, span_notice("[src] emits a red, sharp light!"))
	if(targeted)
		if(M.flash_act(1, 1))
			if(user)
				user.visible_message(span_danger("[user] blinds [M] with the flash!"), span_danger("You hypno-flash [M]!"))

			if(hypno_cooldown_current > world.time) // Still on cooldown
				to_chat(M, span_hypnophrase("The light makes you feel oddly relaxed..."))
				M.add_confusion(min(M.get_confusion() + 10, 20))
				M.dizziness += min(M.dizziness + 10, 20)
				M.drowsyness += min(M.drowsyness + 10, 20)
				M.apply_status_effect(STATUS_EFFECT_PACIFY, 100)
			else
				if(!hypno_message || !length(hypno_message)) // Aka default settings
					hypno_message = "You are a secret agent, working for [user.real_name]. \
					You must do anything they ask of you, and you must never attempt to harm them, nor allow harm to come to them."
				hypno_cooldown_current = world.time + hypno_cooldown
				M.apply_status_effect(STATUS_EFFECT_PACIFY, 30)
				M.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY) //clear previous hypnosis
				var/datum/brain_trauma/trauma = new /datum/brain_trauma/hypnosis(hypno_message)
				M.gain_trauma(trauma, TRAUMA_RESILIENCE_SURGERY)
				M.Stun(60, TRUE, TRUE)

		else if(user)
			user.visible_message(span_warning("[user] fails to blind [M] with the flash!"), span_warning("You fail to hypno-flash [M]!"))
		else
			to_chat(M, span_danger("[src] fails to blind you!"))

	else if(M.flash_act())
		to_chat(M, span_notice("Such a pretty light..."))
		M.add_confusion(min(M.get_confusion() + 4, 20))
		M.dizziness += min(M.dizziness + 4, 20)
		M.drowsyness += min(M.drowsyness + 4, 20)
		M.apply_status_effect(STATUS_EFFECT_PACIFY, 40)

/obj/item/assembly/flash/hypnotic/adv/AltClick(mob/user)
	hypno_message = stripped_input(user, "What order will be given to hypnotised people?", \
	"Hypnosis message", "You are a secret agent, working for [user.real_name]. You must do anything they ask of you, \
	and you must never attempt to harm them, nor allow harm to come to them.")
	to_chat(user, span_notice("New message is: [hypno_message]"))

// Virology bottles
/obj/item/reagent_containers/glass/bottle/accelerant_ts
	name = "Fast transmitability virus accelerant"
	desc = "A small bottle containing TCS-TSA strain."
	spawned_disease = /datum/disease/advance/adv_ts

/obj/item/reagent_containers/glass/bottle/accelerant_mp
	name = "Multi-purpose virus accelerant"
	desc = "A small bottle containing TCS-MPA strain."
	spawned_disease = /datum/disease/advance/adv_mp

/obj/item/reagent_containers/glass/bottle/accelerant_sr
	name = "Resistant stealth virus accelerant"
	desc = "A small bottle containing TCS-SRA strain."
	spawned_disease = /datum/disease/advance/adv_sr

/obj/item/reagent_containers/glass/bottle/fake_oxygen
	name = "Self-Respiratory Detonator bottle"
	desc = "A small bottle containing rare disease that tries to disguise as self-respiration strain."
	spawned_disease = /datum/disease/advance/fake_oxygen

// Syndi-kit
/obj/item/storage/box/syndie_kit/virology
	name = "virology kit"

/obj/item/storage/box/syndie_kit/virology/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10

/obj/item/storage/box/syndie_kit/virology/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/accelerant_ts(src)
	new /obj/item/reagent_containers/glass/bottle/accelerant_mp(src)
	new /obj/item/reagent_containers/glass/bottle/accelerant_sr(src)
	new /obj/item/reagent_containers/glass/bottle/fake_oxygen(src)
	new /obj/item/reagent_containers/glass/bottle/formaldehyde(src)
	new /obj/item/reagent_containers/glass/bottle/synaptizine(src)
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/dropper(src)
	new /obj/item/reagent_containers/syringe(src)

/obj/item/melee/sabre/breadstick
	name = "Breadstick"
	desc = "Listen never forget, when you’re here you’re family. Breadstick?"
	icon_state = "breadstick"
	icon = 'ModularTegustation/Teguicons/breadstick.dmi'
	lefthand_file = "icons/mob/inhands/misc/food_lefthand.dmi"
	righthand_file = "icons/mob/inhands/misc/food_righthand.dmi"
	inhand_icon_state = "baguette"
	force = 10

/obj/item/staff/roadsign
	name = "road sign"
	desc = "It obviously isn't supposed to be used like that, huh?"
	force = 15
	throwforce = 18
	sharpness = SHARP_EDGED
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/teguitems_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguitems_hold_right.dmi'
	icon_state = "roadsign"
	inhand_icon_state = "roadsign"
	armour_penetration = 20
	block_chance = 20
	attack_verb_continuous = list("bludgeons", "whacks", "slices", "impales")
	attack_verb_simple = list("bludgeon", "whack", "slice", "impale")
	w_class = WEIGHT_CLASS_BULKY
	var/attack_speed_mod = 0.4

/obj/item/staff/roadsign/melee_attack_chain(mob/living/user, atom/target, params)
	..()
	if(user.mad_shaking > 0)
		user.changeNext_move(CLICK_CD_MELEE * attack_speed_mod)
	else
		user.changeNext_move(CLICK_CD_MELEE * 2)

// A kit for clown
/obj/item/storage/box/hug/mad_clown
	name = "clown's box"

/obj/item/storage/box/hug/mad_clown/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 3

/obj/item/storage/box/hug/mad_clown/PopulateContents()
	new /obj/item/clothing/mask/gas/mad_clown(src)
	new /obj/item/staff/roadsign(src)

/* Fake Announcement Items */
/obj/item/item_announcer
	name = "FK-\"Deception\" Announcement Device"
	desc = "The FK-Deception Announcement Device allows an \
		enterprising syndicate agent to send a \
		faked message from a certain source."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	w_class = WEIGHT_CLASS_SMALL
	/// The amount of reports we can send before breaking.
	var/uses = 1

/obj/item/item_announcer/examine(mob/user)
	. = ..()
	. += span_notice("It has [uses] uses left.")

/// Deletes the item when it's used up.
/obj/item/item_announcer/proc/break_item(mob/user)
	to_chat(user, span_notice("The [src] breaks down into unrecognizable scrap and ash after being used."))
	var/obj/effect/decal/cleanable/ash/spawned_ash = new(drop_location())
	spawned_ash.desc = "Ashes to ashes, dust to dust. There's a few pieces of scrap in this pile."
	playsound(src, "sparks", 100, TRUE, 5)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, get_turf(src))
	s.start()
	qdel(src)

/// User sends a preset false alarm.
/obj/item/item_announcer/preset
	/// The name of the fake event, so we don't have to init it.
	var/fake_event_name = ""
	/// What false alarm this item triggers.
	var/fake_event = null

/obj/item/item_announcer/preset/Initialize()
	. = ..()
	if(fake_event)
		for(var/datum/round_event_control/init_event in SSevents.control)
			if(ispath(fake_event, init_event.type))
				fake_event = init_event
				break

/obj/item/item_announcer/preset/examine(mob/user)
	. = ..()
	. += span_notice("It causes a fake \"[fake_event_name]\" when used.")

/obj/item/item_announcer/preset/attack_self(mob/user)
	. = ..()
	if(trigger_announcement(user) && uses <= 0)
		break_item(user)

/obj/item/item_announcer/preset/proc/trigger_announcement(mob/user)
	var/datum/round_event_control/falsealarm/triggered_event = new()
	if(!fake_event)
		return FALSE
	triggered_event.forced_type = fake_event
	triggered_event.runEvent(FALSE)
	to_chat(user, span_notice("You press the [src], triggering a false alarm for [fake_event_name]."))
	message_admins("[ADMIN_LOOKUPFLW(user)] has triggered a false alarm using a syndicate device: \"[fake_event_name]\".")
	deadchat_broadcast(span_bold("Someone has triggered a false alarm using a syndicate device!"))
	log_game("[key_name(user)] has triggered a false alarm using a syndicate device: \"[fake_event_name]\".")
	uses--

	return TRUE

/obj/item/item_announcer/preset/ion
	fake_event_name = "Ion Storm"
	fake_event = /datum/round_event_control/ion_storm

/obj/item/item_announcer/preset/rad
	fake_event_name = "Radiation Storm"
	fake_event = /datum/round_event_control/radiation_storm

/// Allows users to input a custom announcement message.
/obj/item/item_announcer/input
	/// The name of central command that will accompany our fake report.
	var/fake_command_name = "God Hand"
	/// The actual contents of the report we're going to send.
	var/command_report_content
	/// Whether the report is an announced report or a classified report.
	var/announce_contents = TRUE

/obj/item/item_announcer/input/examine(mob/user)
	. = ..()
	. += span_notice("It sends messages from \"[fake_command_name]\".")

/obj/item/item_announcer/input/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/item_announcer/input/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FakeCommandReport")
		ui.open()

/obj/item/item_announcer/input/ui_data(mob/user)
	var/list/data = list()
	data["command_name"] = fake_command_name
	data["command_report_content"] = command_report_content
	data["announce_contents"] = announce_contents

	return data

/obj/item/item_announcer/input/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("update_report_contents")
			command_report_content = params["updated_contents"]
		if("toggle_announce")
			announce_contents = !announce_contents
		if("submit_report")
			if(!command_report_content)
				to_chat(usr, span_danger("You can't send a report with no contents."))
				return
			if(send_announcement(usr) && uses <= 0)
				break_item(usr)
				return

	return TRUE

/// Send our announcement from [user] and decrease the amount of uses.
/obj/item/item_announcer/input/proc/send_announcement(mob/user)
	/// Our current command name to swap back to after sending the report.
	var/original_command_name = command_name()
	change_command_name(fake_command_name)

	if(announce_contents)
		priority_announce(command_report_content, null, SSstation.announcer.get_rand_report_sound(), has_important_message = TRUE)
	print_command_report(command_report_content, "[announce_contents ? "" : "Classified "][fake_command_name] Update", !announce_contents)

	change_command_name(original_command_name)

	to_chat(user, span_notice("You tap on the [src], sending a [announce_contents ? "" : "classified "]report from [fake_command_name]."))
	message_admins("[ADMIN_LOOKUPFLW(user)] has sent a fake command report using a syndicate device: \"[command_report_content]\".")
	deadchat_broadcast(span_bold("Someone has sent a fake report using a syndicate device!"))
	log_game("[key_name(user)] has sent a fake command report using a syndicate device: \"[command_report_content]\", sent from \"[fake_command_name]\".")
	uses--

	return TRUE

/obj/item/item_announcer/input/syndicate
	fake_command_name = "The Syndicate"
	uses = 2

/obj/item/item_announcer/input/centcom
	fake_command_name = "Central Command"
