GLOBAL_LIST_EMPTY(attunedsinners)
GLOBAL_VAR_INIT(hatspawned, FALSE)//So two of these cannot be created

/obj/item/clothing/head/helmet/danteh
	name = "Burning Clock"
	desc = "A helmet of some sort resembling a burning clock."
	icon_state = "dantehead"
	inhand_icon_state = "dantehead"
	flags_inv = HIDEHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/helmet/danteh/Initialize()
	. = ..()

	if(GLOB.hatspawned)
		qdel(src)

	//Causes bugs if a second one is created
	GLOB.hatspawned = TRUE

/obj/item/clothing/head/helmet/danteh/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot != ITEM_SLOT_HEAD)
		return

	ADD_TRAIT(src, TRAIT_NODROP, GENERIC_ITEM_TRAIT)
	user.grant_language(/datum/language/clockhead, TRUE, TRUE, LANGUAGE_CLOCKHEAD)
	user.remove_language(/datum/language/common)
	user.grant_language(/datum/language/common, TRUE, FALSE, LANGUAGE_MIND)

	var/datum/action/G = new /datum/action/cooldown/dantehadd
	G.Grant(user)

	if(SSmaptype.maptype in SSmaptype.citymaps)
		G = new /datum/action/cooldown/dantehrevive
		G.Grant(user)


/obj/item/clothing/head/helmet/danteh/dropped(mob/living/carbon/human/user)
	..()
	if(!length(GLOB.attunedsinners))
		return

//No idea how you dropped this off your head but dust you if you try
	user.dust()



/datum/language/clockhead
	name = "Clockhead"
	desc = "A language that is only spoken by clockheads and the people they're attuned to."
	key = "p"
	syllables = list("tick","tock")
	space_chance = 30
	flags = LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	flags = TONGUELESS_SPEECH
	default_priority = 120
	icon_state = "clockhead"


/datum/action/cooldown/dantehadd
	name = "Attune Sinner"
	desc = "An ability that allows its user to attune to a sinner for later revives."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "dantehadd"
	cooldown_time = 5 SECONDS

/datum/action/cooldown/dantehadd/Trigger()
	if(length(GLOB.attunedsinners)>=12)
		to_chat(owner, span_warning("You are already attuned to 12 sinners!"))
		return

	var/list/livingplayers = list()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H in GLOB.attunedsinners)
			continue
		livingplayers+=H

	if(!length(livingplayers))
		return

	var/choice = input(owner, "Which Sinner would you like to attune to?", "Select a sinner") as null|anything in livingplayers
	if(!choice)
		to_chat(owner, span_notice("You decide not to attune to anyone at the moment."))
		return

	if(choice == owner)
		to_chat(owner, span_warning("You cannot attune to yourself!"))
		return

	GLOB.attunedsinners += choice
	var/mob/living/carbon/human/chosen_human = choice
	chosen_human.grant_language(/datum/language/clockhead, TRUE, FALSE, LANGUAGE_MIND)
	to_chat(owner, span_notice("You attune [choice] to yourself."))
	to_chat(choice, span_warning("You feel [owner]'s warmth on you!"))

	return ..()


/datum/action/cooldown/dantehrevive
	name = "Revive Sinners"
	desc = "An ability that allows its user to revive nearby sinners"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "dantehrevive"
	cooldown_time = 2 MINUTES

/datum/action/cooldown/dantehrevive/Trigger()
	if(isdead(owner))
		return
	if(SSmaptype.maptype in SSmaptype.citymaps)
		for(var/mob/living/carbon/human/H in range(7, get_turf(src)))
			if(H in GLOB.attunedsinners)
				H.revive(full_heal = TRUE, admin_revive = TRUE)
				H.grab_ghost(force = TRUE) // even suicides
				to_chat(H, span_notice("You rise with a start, you're alive!!!"))
	else
		for(var/mob/living/carbon/human/H in range(7, get_turf(src)))
			if(H in GLOB.attunedsinners)
				H.adjustSanityLoss(-40)	//Healing for those around.
				H.adjustBruteLoss(-40)
				new /obj/effect/temp_visual/heal(get_turf(H), "#E2ED4A")

	var/mob/living/carbon/human/M = owner

	M.Knockdown(10 SECONDS)
	M.Stun(10 SECONDS)
	return ..()

