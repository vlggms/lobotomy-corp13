
//Prayer
/obj/item/book/granter/action/skill/prayer
	name = "Level 1 Skill: Lunar Prayer"
	actionname = "Lunar Prayer"
	granted_action = /datum/action/cooldown/fishing/prayer
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/prayer
	name = "Lunar Prayer"
	button_icon_state = "lunar"
	cooldown_time = 30 SECONDS
	devotion_cost = 3

/datum/action/cooldown/fishing/prayer/FishEffect(mob/living/user)
	var/healamount = 5
	healamount *= SSfishing.moonphase
	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustSanityLoss(-healamount)	//Healing for those around.
		H.adjustBruteLoss(-healamount)
		new /obj/effect/temp_visual/heal(get_turf(H), "#CCCCCC")


//God's love
/obj/item/book/granter/action/skill/love
	name = "Level 1 Skill: The God's Love"
	actionname = "God's Love"
	granted_action = /datum/action/cooldown/fishing/love
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/love
	name = "God's Love"
	button_icon_state = "love"
	cooldown_time = 30 SECONDS
	devotion_cost = 3
	var/healamount = 1

/datum/action/cooldown/fishing/love/FishEffect(mob/living/user)
	healamount++
	var/givehealing = TOUGHER_TIMES_SPECIFIC(healamount,0.02)
	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustSanityLoss(-givehealing)	//Healing for those around.
		H.adjustBruteLoss(-givehealing)
		new /obj/effect/temp_visual/heal(get_turf(H), "#CCCCCC")


