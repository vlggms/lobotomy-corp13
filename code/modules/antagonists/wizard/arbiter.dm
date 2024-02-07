/datum/antagonist/wizard/arbiter
	name = "Incomplete Arbiter"
	roundend_category = "arbiters"
	antagpanel_category = "The Head"
	give_objectives = FALSE
	move_to_lair = FALSE
	outfit_type = /datum/outfit/arbiter
	antag_attributes = list(
		FORTITUDE_ATTRIBUTE = 130,
		PRUDENCE_ATTRIBUTE = 130,
		TEMPERANCE_ATTRIBUTE = 130,
		JUSTICE_ATTRIBUTE = 130
		)

	var/list/spell_types = list(
		/obj/effect/proc_holder/spell/aimed/fairy,
		/obj/effect/proc_holder/spell/aimed/pillar,
		/obj/effect/proc_holder/spell/aoe_turf/repulse/arbiter,
		/obj/effect/proc_holder/spell/aoe_turf/knock/arbiter
		)

/datum/antagonist/wizard/arbiter/greet()
	to_chat(owner, span_boldannounce("You are the Arbiter!"))

/datum/antagonist/wizard/arbiter/farewell()
	to_chat(owner, span_boldannounce("You have been fired from The Head. Your services are no longer needed."))

/datum/antagonist/wizard/arbiter/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)
	M.faction |= "Head"
	M.faction |= "hostile"
	M.faction -= "neutral"
	ADD_TRAIT(M, TRAIT_BOMBIMMUNE, "Arbiter") // We truly are the elite agent of the Head
	ADD_TRAIT(M, TRAIT_STUNIMMUNE, "Arbiter")
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, "Arbiter")
	ADD_TRAIT(M, TRAIT_PUSHIMMUNE, "Arbiter")
	ADD_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN, "Arbiter")
	ADD_TRAIT(M, TRAIT_NOFIRE, "Arbiter")
	ADD_TRAIT(M, TRAIT_NODISMEMBER, "Arbiter")
	ADD_TRAIT(M, TRAIT_SANITYIMMUNE, "Arbiter")
	M.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 500) // Obviously they are very tough
	for(var/spell_type in spell_types)
		var/obj/effect/proc_holder/spell/S = new spell_type
		M.mind?.AddSpell(S)

/datum/antagonist/wizard/arbiter/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)
	M.faction -= "Head"
	M.faction -= "hostile"
	M.faction += "neutral"
	REMOVE_TRAIT(M, TRAIT_BOMBIMMUNE, "Arbiter") // We truly are the elite agent of the Head
	REMOVE_TRAIT(M, TRAIT_STUNIMMUNE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_PUSHIMMUNE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_NOFIRE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_NODISMEMBER, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_SANITYIMMUNE, "Arbiter")
	M.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -500)

/datum/outfit/arbiter
	name = "Arbiter"

	uniform = /obj/item/clothing/under/suit/lobotomy/extraction/arbiter
	suit = /obj/item/clothing/suit/armor/extraction/arbiter
	neck = /obj/item/clothing/neck/cloak/arbiter
	shoes = /obj/item/clothing/shoes/combat
	ears = /obj/item/radio/headset/headset_head/alt
	id = /obj/item/card/id

/datum/outfit/arbiter/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Arbiter"
	W.registered_name = H.real_name
	W.update_label()
	..()

//Spawner
/obj/effect/mob_spawn/human/arbiter
	name = "The Arbiter"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	short_desc = "You are The Arbiter."
	important_info = "You are hostile to L-Corp. Assist abnormalities in killing them all."
	outfit = /datum/outfit/arbiter
	max_integrity = 9999999
	density = TRUE
	roundstart = FALSE
	death = FALSE

/obj/effect/mob_spawn/human/arbiter/special(mob/living/new_spawn)
	new_spawn.mind.add_antag_datum(/datum/antagonist/wizard/arbiter)

/obj/effect/mob_spawn/human/arbiter/complete

/obj/effect/mob_spawn/human/arbiter/complete/special(mob/living/new_spawn)
	new_spawn.mind.add_antag_datum(/datum/antagonist/wizard/arbiter/complete)

/datum/antagonist/wizard/arbiter/complete
	name = "Arbiter"
	spell_types = list(
		/obj/effect/proc_holder/spell/aimed/fairy,
		/obj/effect/proc_holder/spell/aimed/pillar,
		/obj/effect/proc_holder/spell/aoe_turf/repulse/arbiter,
		/obj/effect/proc_holder/spell/aoe_turf/knock/arbiter,
		/obj/effect/proc_holder/spell/aoe_turf/singularity,
	)

/obj/effect/proc_holder/spell/aoe_turf/singularity
	name = "Singularity Swap"
	desc = "Utilize a different singularity to deal a different damage type."
	school = SCHOOL_EVOCATION
	charge_max = 150
	range = 15
	clothes_req = FALSE
	antimagic_allowed = TRUE
	invocation_type = "none"
	base_icon_state = "singularity"
	action_icon_state = "singularity"
	sound = 'sound/magic/castsummon.ogg'
	var/damage_type = BLACK_DAMAGE
	var/list/damage_type_list = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	var/filter

/obj/effect/proc_holder/spell/aoe_turf/singularity/cast(list/targets,mob/user = usr)
	playMagSound()
	var/index = damage_type_list.Find(damage_type)
	index = (index % damage_type_list.len) + 1
	damage_type = damage_type_list[index]
	to_chat(usr, span_nicegreen("You are now dealing [damage_type] damage with your pillar and fairy attacks!"))
	for(var/thespell in usr.mind.spell_list)
		if(istype(thespell, /obj/effect/proc_holder/spell/aimed/fairy))
			var/obj/effect/proc_holder/spell/aimed/fairy/fairyspell = thespell
			fairyspell.damage_type = damage_type
		if(istype(thespell, /obj/effect/proc_holder/spell/aimed/pillar))
			var/obj/effect/proc_holder/spell/aimed/fairy/pillarspell = thespell
			pillarspell.damage_type = damage_type
	if(!filter)
		filter = TRUE
		usr.filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(128, 128, 128))
		return
	var/f1 = usr.filters[usr.filters.len]
	switch(damage_type)
		if(RED_DAMAGE)
			animate(f1,color = rgb(255, 0, 0),time=5)
		if(WHITE_DAMAGE)
			animate(f1,color = rgb(255,255,255),time=5)
		if(BLACK_DAMAGE)
			animate(f1,color = rgb(48, 25, 52),time=5)
		if(PALE_DAMAGE)
			animate(f1,color = rgb(128, 128, 128),time=5)
