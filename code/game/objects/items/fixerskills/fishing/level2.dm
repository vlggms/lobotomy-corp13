/obj/item/book/granter/action/skill/smite
	name = "Level 2 Skill: Smite the Heretics"
	actionname = "Smite the Heretics"
	granted_action = /datum/action/cooldown/fishing/smite
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/smite
	name = "Smite the Heretics"
	button_icon_state = "smite"
	cooldown_time = 30 SECONDS
	devotion_cost = 7

/datum/action/cooldown/fishing/smite/FishEffect(mob/living/user)
	for(var/mob/living/sinner in view(4, get_turf(src)))
		if(user.god_aligned == sinner.god_aligned)
			continue

		var/damage = clamp(user.devotion, 1, 50)
		if(sinner.god_aligned == FISHGOD_NONE) //Deal a fuckload of damage to athiests
			damage *= 2

		sinner.deal_damage(damage, WHITE_DAMAGE) //KILL
		if(ishuman(user))
			to_chat(sinner, span_userdanger("[user.god_aligned] has punished you for your sins using [user] as a conduit!"))
		else
			to_chat(sinner, span_userdanger("The gods have punished you for your sins using [user] as a conduit!"))

/obj/item/book/granter/action/skill/might
	name = "Level 2 Skill: Lunar Might"
	actionname = "Lunar Might"
	granted_action = /datum/action/cooldown/fishing/might
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/might
	name = "Lunar Might"
	button_icon_state = "might"
	cooldown_time = 30 SECONDS
	devotion_cost = 7
	var/stat_hold = 0

/datum/action/cooldown/fishing/might/FishEffect(mob/living/user)
	var/mob/living/carbon/human/H = owner
	stat_hold = SSfishing.moonphase*10
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, stat_hold)
	addtimer(CALLBACK(src, PROC_REF(Recall),), 20 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/action/cooldown/fishing/might/proc/Recall(mob/living/carbon/human/user)
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -stat_hold)

/obj/item/book/granter/action/skill/awe
	name = "Level 2 Skill: Awe the Weak"
	actionname = "Awe the Weak"
	granted_action = /datum/action/cooldown/fishing/awe
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/awe
	name = "Awe the Weak"
	button_icon_state = "awe"
	cooldown_time = 30 SECONDS
	devotion_cost = 8

/datum/action/cooldown/fishing/awe/FishEffect(mob/living/user)
	for(var/mob/living/victim in view(5, get_turf(src)))
		if(victim == owner)
			continue
		if(victim.god_aligned == FISHGOD_NONE) // Stun the non-believers.
			to_chat(victim, span_userdanger("You are in awe of [user]'s devotion to [user.god_aligned]!"), confidential = TRUE)
			victim.Immobilize(1.5 SECONDS)

	StartCooldown()

/obj/item/book/granter/action/skill/chakra
	name = "Level 2 Skill: Chakra Misalignment"
	actionname = "Chakra Misalignment"
	granted_action = /datum/action/cooldown/fishing/chakra
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/chakra
	name = "Chakra Misalignment"
	button_icon_state = "chakra"
	cooldown_time = 30 SECONDS
	devotion_cost = 12

/datum/action/cooldown/fishing/chakra/FishEffect(mob/living/user)
	for(var/mob/living/victim in view(4, get_turf(user)))
		if(victim == owner)
			continue
		if(victim.god_aligned == FISHGOD_NONE)
			continue

		for(var/datum/planet/planet as anything in SSfishing.planets)
			if(victim.god_aligned != planet.god)
				continue

			if(planet.phase != 1)
				smite(victim, user)
			return

		obliterate(victim) // their planet is dead, and so will they be

/datum/action/cooldown/fishing/chakra/proc/smite(mob/living/carbon/asshole, mob/living/carbon/user)
	asshole.apply_damage(user.devotion * SSfishing.moonphase * 0.5, WHITE_DAMAGE, null, asshole.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)	//KILL
	if(ishuman(asshole))
		to_chat(asshole, span_userdanger("You feel your chakra rend itself!"), confidential = TRUE)

/datum/action/cooldown/fishing/chakra/proc/obliterate(mob/living/carbon/H)
	to_chat(H, span_userdanger("YOUR CHAKRA IS SPLITTING YOUR BODY!"), confidential = TRUE)
	new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
	H.set_lying_angle(NORTH) // gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
	H.gib()

/// Salmon Splitter
/// Explode someone dead into fish
/obj/item/book/granter/action/skill/splitter
	name = "Level 2 Skill: Greater Fish - Vertical"
	actionname = "Greater Fish - Vertical"
	granted_action = /datum/action/cooldown/fishing/splitter
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/splitter
	name = "Greater Fish - Vertical"
	button_icon_state = "splitter"
	cooldown_time = 10 SECONDS
	devotion_cost = 7

/datum/action/cooldown/fishing/splitter/FishEffect(mob/living/user)
	//Compile people around you in crit
	for(var/mob/living/future_fish in view(2, get_turf(src)))
		if(future_fish == owner)
			continue
		if(future_fish.stat >= SOFT_CRIT)
			to_chat(future_fish, span_userdanger("YOU'RE FIN-ISHED!"), confidential = TRUE)
			new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(future_fish))
			future_fish.set_lying_angle(NORTH)

			// Fesh
			new /obj/item/food/fish/fresh_water/salmon(get_turf(future_fish))
			future_fish.gib()
