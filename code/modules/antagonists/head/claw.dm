/datum/antagonist/claw
	name = "The Claw"
	roundend_category = "claws"
	antagpanel_category = "The Head"
	job_rank = ROLE_WIZARD
	antag_hud_type = ANTAG_HUD_WIZ
	antag_hud_name = "wizard"
	hijack_speed = 0.5
	var/strip = TRUE //Born anew
	var/outfit_type = /datum/outfit/claw
	show_to_ghosts = TRUE
	antag_attributes = list(
		FORTITUDE_ATTRIBUTE = 130,
		PRUDENCE_ATTRIBUTE = 130,
		TEMPERANCE_ATTRIBUTE = 130,
		JUSTICE_ATTRIBUTE = 130
		)

/datum/antagonist/claw/on_gain()
	equip_claw()
	. = ..()
	rename_claw()

/datum/antagonist/claw/greet()
	to_chat(owner, span_boldannounce("You are the Claw!"))

/datum/antagonist/claw/farewell()
	to_chat(owner, span_boldannounce("You have been fired from The Head. Your services are no longer needed."))

/datum/antagonist/claw/proc/equip_claw()
	if(!owner)
		CRASH("Antag datum with no owner.")
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	if(strip)
		H.delete_equipment()
	H.equipOutfit(outfit_type)

/datum/antagonist/claw/proc/rename_claw() // Copypasted from wiz, arbiter has it why not claw.
	set waitfor = FALSE

	var/randomname = "The Claw"
	var/mob/living/wiz_mob = owner.current
	var/newname = sanitize_name(reject_bad_text(stripped_input(wiz_mob, "You are the [name]. Would you like to change your name to something else?", "Name change", randomname, MAX_NAME_LEN)))

	if (!newname)
		newname = randomname

	wiz_mob.fully_replace_character_name(wiz_mob.real_name, newname)

/datum/antagonist/claw/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)
	M.faction |= "Head"
	M.faction |= "hostile"
	M.faction -= "neutral"
	ADD_TRAIT(M, TRAIT_BOMBIMMUNE, "Claw")
	ADD_TRAIT(M, TRAIT_STUNIMMUNE, "Claw")
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, "Claw")
	ADD_TRAIT(M, TRAIT_PUSHIMMUNE, "Claw")
	ADD_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN, "Claw")
	ADD_TRAIT(M, TRAIT_NOFIRE, "Claw")
	ADD_TRAIT(M, TRAIT_NODISMEMBER, "Claw")
	ADD_TRAIT(M, TRAIT_SANITYIMMUNE, "Claw")
	ADD_TRAIT(M, TRAIT_BRUTEPALE, "Claw")
	ADD_TRAIT(M, TRAIT_TRUE_NIGHT_VISION, "Claw")
	M.update_sight() //Nightvision trait wont matter without it
	M.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 250) // Half of Arbiter, you're the claw not getting hit is part of your training

/datum/antagonist/claw/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)
	M.faction -= "Head"
	M.faction -= "hostile"
	M.faction += "neutral"
	REMOVE_TRAIT(M, TRAIT_BOMBIMMUNE, "Claw")
	REMOVE_TRAIT(M, TRAIT_STUNIMMUNE, "Claw")
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, "Claw")
	REMOVE_TRAIT(M, TRAIT_PUSHIMMUNE, "Claw")
	REMOVE_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN, "Claw")
	REMOVE_TRAIT(M, TRAIT_NOFIRE, "Claw")
	REMOVE_TRAIT(M, TRAIT_NODISMEMBER, "Claw")
	REMOVE_TRAIT(M, TRAIT_SANITYIMMUNE, "Claw")
	REMOVE_TRAIT(M, TRAIT_BRUTEPALE, "Claw")
	REMOVE_TRAIT(M, TRAIT_TRUE_NIGHT_VISION, "Claw")
	M.update_sight() //Removing nightvision wont matter without it
	M.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -250)

/datum/outfit/claw
	name = "Claw"

	uniform = /obj/item/clothing/under/suit/lobotomy/claw
	suit = /obj/item/clothing/suit/armor/ego_gear/claw
	gloves = /obj/item/clothing/gloves/color/black
	l_hand = /obj/item/ego_weapon/the_claw
	shoes = /obj/item/clothing/shoes/combat
	ears = /obj/item/radio/headset/headset_head/alt
	id = /obj/item/card/id

/datum/outfit/claw/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Claw"
	W.registered_name = H.real_name
	W.update_label()
	..()
