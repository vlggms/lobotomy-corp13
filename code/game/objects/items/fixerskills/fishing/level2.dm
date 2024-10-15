//Smite the Heretic
/obj/item/book/granter/action/skill/smite
	granted_action = /datum/action/cooldown/fishing/smite
	actionname = "Smite the Heretics"
	name = "Level 2 Skill: Smite the Heretics"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/fishing/smite
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "smite"
	name = "smite"
	cooldown_time = 300
	devotion_cost = 7

/datum/action/cooldown/fishing/smite/FishEffect(mob/living/user)
	//Compile people around you
	for(var/mob/living/M in view(4, get_turf(src)))
		if(M.god_aligned != M.god_aligned)
			//Deal a fuckload of damage to athiests
			if(M.god_aligned == FISHGOD_NONE)
				var/damagedealing = clamp(user.devotion, 1, 50)
				M.deal_damage(damagedealing*2, WHITE_DAMAGE)	//KILL
				if(ishuman(M))
					to_chat(target, span_userdanger("The gods have punished you for your sins!"), confidential = TRUE)
				return

			//Deal some damage if they don't share the same god
			if(M.god_aligned != M.god_aligned)
				var/damagedealing = clamp(user.devotion, 1, 50)
				M.deal_damage(damagedealing, WHITE_DAMAGE)	//KILL
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
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "might"
	name = "might"
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
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "awe"
	name = "awe"
	cooldown_time = 300
	devotion_cost = 8

/datum/action/cooldown/fishing/awe/FishEffect(mob/living/user)
	//Compile people around you
	for(var/mob/living/M in view(5, get_turf(src)))
		if(M == owner)
			continue
		if(M.god_aligned == FISHGOD_NONE)
			//Stun the non-believers.
			to_chat(target, span_userdanger("You are in awe of [user]'s devotion to [user.god_aligned]!"), confidential = TRUE)
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
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "chakra"
	name = "chakra"
	cooldown_time = 300
	devotion_cost = 12

/datum/action/cooldown/fishing/chakra/FishEffect(mob/living/user)
	//Compile people around you
	for(var/mob/living/M in view(4, get_turf(src)))
		if(M == owner)
			continue

			//Atheists have no chakra
		switch(M.god_aligned)
			if(FISHGOD_MERCURY)
				if(SSfishing.Mercury <0)	//If your planet is below 0, it was blown out of the sky, and you will die.
					obliterate(M)
				if(SSfishing.Mercury != 2)
					smite(M, user)

			if(FISHGOD_VENUS)
				if(SSfishing.Venus <0)	//If your planet is below 0, it was blown out of the sky, and you will die.
					obliterate(M)
				if(SSfishing.Venus != 3)
					smite(M, user)

			if(FISHGOD_MARS)
				if(SSfishing.Mars <0)	//If your planet is below 0, it was blown out of the sky, and you will die.
					obliterate(M)
				if(SSfishing.Mars != 4)
					smite(M, user)

			if(FISHGOD_JUPITER)
				if(SSfishing.Jupiter <0)	//If your planet is below 0, it was blown out of the sky, and you will die.
					obliterate(M)
				if(SSfishing.Jupiter != 5)
					smite(M, user)

			if(FISHGOD_SATURN)
				if(SSfishing.Saturn <0)	//If your planet is below 0, it was blown out of the sky, and you will die.
					obliterate(M)
				if(SSfishing.Saturn != 6)
					smite(M, user)

			if(FISHGOD_URANUS)
				if(SSfishing.Uranus <0)	//If your planet is below 0, it was blown out of the sky, and you will die.
					obliterate(M)
				if(SSfishing.Uranus != 7)
					smite(M, user)

			if(FISHGOD_NEPTUNE)
				if(SSfishing.Neptune <0)	//If your planet is below 0, it was blown out of the sky, and you will die.
					obliterate(M)
				if(SSfishing.Neptune != 8)
					smite(M, user)


/datum/action/cooldown/fishing/chakra/proc/smite(mob/living/carbon/asshole, mob/living/carbon/user)
	asshole.deal_damage(user.devotion*SSfishing.moonphase*0.5, WHITE_DAMAGE)	//KILL
	if(ishuman(asshole))
		to_chat(asshole, span_userdanger("You feel your chakra rend itself!"), confidential = TRUE)

/datum/action/cooldown/fishing/chakra/proc/obliterate(mob/living/carbon/H)
	to_chat(H, span_userdanger("YOUR CHAKRA IS SPLITTING YOUR BODY!"), confidential = TRUE)
	new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
	H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
	H.gib()
