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
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	melee_damage_lower = 16
	melee_damage_upper = 20			//He doesn't really attack but I guess if he does he would deal this kind of damage
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
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
						ABNORMALITY_WORK_REPRESSION = 10
						)
	work_damage_amount = 7
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/alleyway,
		/datum/ego_datum/armor/alleyway
		)
//	gift_type =  /datum/ego_gifts/alleyway
	light_color = "FFFFFFF"
	light_power = -10

/mob/living/simple_animal/hostile/abnormality/watchman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/watchman/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
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


/mob/living/simple_animal/hostile/abnormality/watchman/BreachEffect(mob/living/carbon/human/user)
	..()
	set_light(30)	//Makes everything around it really dark, That's all it does lol
