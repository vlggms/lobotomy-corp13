//Smite the Heretic
/obj/item/book/granter/action/skill/smite
	granted_action = /datum/action/cooldown/fishing/smite
	actionname = "Smite the Heretics"
	name = "Level 2 Skill: Smite the Heretics"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/smite
	button_icon_state = "smite"
	name = "Smite the Heretics"
	cooldown_time = 300
	devotion_cost = 7

/datum/action/cooldown/fishing/smite/FishEffect(mob/living/user)
	//Compile people around you
	for(var/mob/living/M in view(4, get_turf(src)))
		if(M.god_aligned != M.god_aligned)
			//Deal a fuckload of damage to athiests
			if(M.god_aligned == FISHGOD_NONE)
				var/damagedealing = clamp(user.devotion, 1, 50)
				M.apply_damage(damagedealing*2, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)	//KILL
				if(ishuman(M))
					to_chat(target, span_userdanger("The gods have punished you for your sins!"), confidential = TRUE)
				return

			//Deal some damage if they don't share the same god
			if(M.god_aligned != user.god_aligned)
				var/damagedealing = clamp(user.devotion, 1, 50)
				M.apply_damage(damagedealing, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)	//KILL
				if(ishuman(M))
					to_chat(target, span_userdanger("[user.god_aligned] has punished you for your sins!"), confidential = TRUE)




//Lunar Might
/obj/item/book/granter/action/skill/might
	granted_action = /datum/action/cooldown/fishing/might
	actionname = "Lunar Might"
	name = "Level 2 Skill: Lunar Might"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/might
	button_icon_state = "might"
	name = "Lunar Might"
	cooldown_time = 300
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


//Awe the Weak
/obj/item/book/granter/action/skill/awe
	granted_action = /datum/action/cooldown/fishing/awe
	actionname = "Awe the Weak"
	name = "Level 2 Skill: Awe the Weak"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/awe
	button_icon_state = "awe"
	name = "Awe the Weak"
	cooldown_time = 300
	devotion_cost = 8

/datum/action/cooldown/fishing/awe/FishEffect(mob/living/user)
	//Compile people around you
	for(var/mob/living/M in view(5, get_turf(src)))
		if(M == owner)
			continue
		if(M.god_aligned == FISHGOD_NONE)
			//Stun the non-believers.
			to_chat(M, span_userdanger("You are in awe of [user]'s devotion to [user.god_aligned]!"), confidential = TRUE)
			M.Immobilize(15)
	StartCooldown()



//Chakra Misalignment
/obj/item/book/granter/action/skill/chakra
	granted_action = /datum/action/cooldown/fishing/chakra
	actionname = "Chakra Misalignment"
	name = "Level 2 Skill: Chakra Misalignment"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/chakra
	button_icon_state = "chakra"
	name = "Chakra Misalignment"
	cooldown_time = 300
	devotion_cost = 12

/datum/action/cooldown/fishing/chakra/FishEffect(mob/living/user)
	//Compile people around you
	for(var/mob/living/M in view(4, get_turf(src)))
		if(M == owner)
			continue
		if(M.god_aligned == initial(M.god_aligned))
			continue

		var/found_planet = FALSE
		for(var/datum/planet/planet as anything in SSfishing.planets)
			if(M.god_aligned != planet.god)
				continue

			found_planet = TRUE
			if(planet.phase != 1)
				smite(M, user)
			break

		if(!found_planet) // their planet is dead, and so will they be
			obliterate(M)

/datum/action/cooldown/fishing/chakra/proc/smite(mob/living/carbon/asshole, mob/living/carbon/user)
	asshole.apply_damage(user.devotion*SSfishing.moonphase*0.5, WHITE_DAMAGE, null, asshole.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)	//KILL
	if(ishuman(asshole))
		to_chat(asshole, span_userdanger("You feel your chakra rend itself!"), confidential = TRUE)

/datum/action/cooldown/fishing/chakra/proc/obliterate(mob/living/carbon/H)
	to_chat(H, span_userdanger("YOUR CHAKRA IS SPLITTING YOUR BODY!"), confidential = TRUE)
	new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
	H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
	H.gib()


//Salmon Splitter
//Explode someone into fish
/obj/item/book/granter/action/skill/splitter
	granted_action = /datum/action/cooldown/fishing/splitter
	actionname = "Greater Fish - Vertical"
	name = "Level 2 Skill: Greater Fish - Vertical"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/splitter
	button_icon_state = "splitter"
	name = "Greater Fish - Vertical"
	cooldown_time = 100
	devotion_cost = 7

/datum/action/cooldown/fishing/splitter/FishEffect(mob/living/user)
	//Compile people around you in crit
	for(var/mob/living/M in view(2, get_turf(src)))
		if(M == owner)
			continue
		if(M.stat >= SOFT_CRIT)
			to_chat(M, span_userdanger("YOU'RE FIN-ISHED!"), confidential = TRUE)
			new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(M))
			M.set_lying_angle(360)

			//Spawn salmon and toss it all over the place
			new /obj/item/food/fish/fresh_water/salmon(M.loc)
			M.gib()
