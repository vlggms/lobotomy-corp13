/mob/living/simple_animal/hostile/abnormality/watchman
	name = "The Watchman"
	desc = "A man holding a large lantern. The lantern, despite having a visible flame, gives off no light."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "watchman"
	icon_living = "watchman"
	del_on_death = TRUE
	maxHealth = 1200
	health = 1200
	rapid_melee = 2
	move_to_delay = 6
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	melee_damage_lower = 16
	melee_damage_upper = 20			//He doesn't really attack but I guess if he does he would deal this kind of damage
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = "swing_hit"
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	faction = list("neutral", "hostile")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 10,
	)
	work_damage_amount = 7
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/alleyway,
		/datum/ego_datum/armor/alleyway,
	)

	gift_type =  /datum/ego_gifts/alleyway
	light_color = "FFFFFFF"
	light_power = -10

	// Speech Lines
	speak_chance = 4
	var/speak_normal = list(
		"#The night is upon us, find somewhere safe.",
		"#Another night, another shift.",
		"#Stay safe out here.",
		"#It's not safe to roam the streets at night.",
		"#Be careful of what may lie in the dark.",
	)
	var/speak_alert = list(
		"Creatures roam the night, you should find shelter.",
		"The night has become home to many creatures of the dark, be careful.",
		"It's not safe out, return home.",
		"This darkness hides evil within it, stay safe.",
		"I pray the beings of the night return to their dens soon...",
	)
	var/speak_attacked_human = list(
		"#Nothing better to do than hit the Watchman..?",
		"#Kids these days...",
		"#The audacity of some people..!",
		"#May your woes be many and your days few.",
	)
	var/speak_attacked_monster = list(
		"Begone, foul creature of the night!",
		"Your kind are unwelcome here!",
		"Never should have come here!",
		"This darkness is not for you and you alone, monster!",
	)
	// Breached Abno tracker.
	var/list/dangers = list()

/mob/living/simple_animal/hostile/abnormality/watchman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/watchman/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/watchman/WorkChance(mob/living/carbon/human/user, chance)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 60)
		var/newchance = chance - 20 //You suck, die. I hate you
		return newchance
	return chance

/mob/living/simple_animal/hostile/abnormality/watchman/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	user.hallucination += 20	//You're gonna be hallucinating for a while


/mob/living/simple_animal/hostile/abnormality/watchman/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	set_light(30)	//Makes everything around it really dark, That's all it does lol


/// ======================SPEECH CODE======================
/mob/living/simple_animal/hostile/abnormality/watchman/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(speak_chance)
		if(prob(speak_chance*2))
			say(pick(speak_attacked_human))

/mob/living/simple_animal/hostile/abnormality/watchman/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(speak_chance)
		if(prob(speak_chance*2))
			say(pick(speak_attacked_human))

/mob/living/simple_animal/hostile/abnormality/watchman/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(speak_chance)
		if(prob(speak_chance*2))
			say(pick(speak_attacked_monster))

/mob/living/simple_animal/hostile/abnormality/watchman/proc/HandleSpeech()
	// Add new threats.
	for(var/mob/living/simple_animal/hostile/H in view(7, src))
		if(H == src)
			continue
		if(istype(H, /mob/living/simple_animal/hostile/abnormality))
			var/mob/living/simple_animal/hostile/abnormality/A = H
			if(A.IsContained())
				continue
		dangers |= H
	// Begin cleaning the list up.
	var/prune_list = dangers.Copy()
	for(var/mob/living/simple_animal/hostile/H in dangers)
		if(QDELETED(H) || H.stat == DEAD || !istype(H))
			prune_list -= H
	for(var/mob/living/simple_animal/hostile/abnormality/A in dangers)
		if(!A.IsContained())
			continue
		prune_list -= A
	dangers = prune_list
	// End cleaning up the list.
	if(speak_chance)
		if(prob(speak_chance))
			if(dangers.len)
				say(pick(speak_alert))
			else
				say(pick(speak_normal))

/mob/living/simple_animal/hostile/abnormality/watchman/handle_automated_action()
	. = ..()
	HandleSpeech()

/mob/living/simple_animal/hostile/abnormality/watchman/handle_automated_movement()
	. = ..()
	HandleSpeech()

/mob/living/simple_animal/hostile/abnormality/watchman/patrol_step(dest)
	. = ..()
	HandleSpeech()


