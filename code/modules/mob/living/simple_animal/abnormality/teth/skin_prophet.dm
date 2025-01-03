/mob/living/simple_animal/hostile/abnormality/skin_prophet
	name = "Skin Prophet"
	desc = "A little fleshy being reading a tiny book."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "skin_prophet"
	core_icon = "prophet_egg"
	portrait = "skin_prophet"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 60, 50, 50, 40),
		ABNORMALITY_WORK_INSIGHT = list(70, 60, 50, 50, 40),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 6	//Gets more later
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/visions,
		/datum/ego_datum/armor/visions,
	)
	gift_type = /datum/ego_gifts/visions
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "Candles quietly burn away. <br>\
		Scribbling sounds are all that fill the air. <br>\
		A trio of eyes takes turns glaring into a grand tome, bound in skin. <br>\
		You can’t tell what it’s referencing, <br>\
		or if there is any deliberation in its writing; <br>\
		hands are busy nonetheless. <br>\
		Yearning for destruction and doom, it writes and writes and writes. <br>\
		You feel the passages it’s writing may be prophecies for someplace and sometime."
	observation_choices = list(
		"Snuff out the candles" = list(TRUE, "You hushed the candles, one by one. <br>\
			The space grew darker, but its hands won’t stop. <br>\
			The only light left was on the quill it held. <br>\
			Even that was snuffed by our breaths. <br>\
			Then, the whole place went dark. <br>\
			All that’s left is the pen in its hand."),
		"Peek at the book" = list(FALSE, "!@)(!@&)&*%(%@!@#*(#)*(%&!@#$ <br>\
			@$*@)$ ? <br> @#$!!@#* ! <br> @*()!%&$(^!!!!@&(@)"),
	)

	var/list/speak_list = list(
		"!@)(!@&)&*%(%@!@#*(#)*(%&!@#$",
		"@$*@)$?",
		"@#$!!@#*!",
		"@*()!%&$(^!!!!@&(@)",
	)
	var/candles = 0

/mob/living/simple_animal/hostile/abnormality/skin_prophet/WorkChance(mob/living/carbon/human/user, chance)
	//work damage starts at 7, + candles stuffed
	work_damage_amount = initial(work_damage_amount) + candles

	//If you're doing rep or temeprance then your work chance is your total buffs combined, and damage is increased too
	if(chance == 0)
		var/totalbuff = get_level_buff(user, FORTITUDE_ATTRIBUTE) + get_level_buff(user, PRUDENCE_ATTRIBUTE) + get_level_buff(user, TEMPERANCE_ATTRIBUTE) + get_level_buff(user, JUSTICE_ATTRIBUTE)
		chance = totalbuff
		work_damage_amount += totalbuff/10
	return chance

/mob/living/simple_animal/hostile/abnormality/skin_prophet/WorktickFailure(mob/living/carbon/human/user)
	if(prob(30))
		say(pick(speak_list))
	..()

//If you success on temperance or repression, clear all your temperance/justice buffs and then add to your max stats.
//You're on the hook for any changes in your attribute
/mob/living/simple_animal/hostile/abnormality/skin_prophet/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		say(pick(speak_list))

		//Don't try it without any buffs.
		if(get_level_buff(user, TEMPERANCE_ATTRIBUTE) <=0)
			user.dust()
			return
		user.adjust_attribute_limit(get_level_buff(user, TEMPERANCE_ATTRIBUTE))
		user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -get_level_buff(user, TEMPERANCE_ATTRIBUTE))

	if(work_type == ABNORMALITY_WORK_REPRESSION)
		say(pick(speak_list))

		if(get_level_buff(user, JUSTICE_ATTRIBUTE) <=0)
			user.dust()
			return

		user.adjust_attribute_limit(get_level_buff(user, JUSTICE_ATTRIBUTE))
		user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -get_level_buff(user, JUSTICE_ATTRIBUTE))
	return

/mob/living/simple_animal/hostile/abnormality/skin_prophet/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	say(pick(speak_list))
	//He has 10 candles. Each snuffed candle deals more work damage
	if(candles != 10)
		candles += 1
	return

