
/mob/living/simple_animal/hostile/abnormality/branch12/long_bird
	name = "Long Bird"
	desc = "Jesus what the fuck man, how did it's legs get so big?"
	icon = 'ModularTegustation/Teguicons/branch12/32x64.dmi'
	icon_state = "long_bird"
	icon_living = "long_bird"
	del_on_death = TRUE
	maxHealth = 2100	//should be a little tankier as it's a bit slow
	health = 2100
	rapid_melee = 2
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 14
	melee_damage_upper = 14
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bites"
	response_help_continuous = "pets"		//Some guy recommended I do this
	response_help_simple = "pet"
	attack_sound = 'sound/abnormalities/cleave.ogg'
	faction = list("hostile", "neutral")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 25, 30, 30),
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 55, 60),
	)
	work_damage_amount = 8
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/egoification,
	//	/datum/ego_datum/armor/legs
	)
	//gift_type =  /datum/ego_gifts/departure
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	patrol_cooldown_time = 3 SECONDS

/mob/living/simple_animal/hostile/abnormality/branch12/long_bird/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/long_bird/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/long_bird/Moved()
	. = ..()
	if(!(status_flags & GODMODE))
		playsound(get_turf(src), 'sound/abnormalities/bigbird/step.ogg', 50, 1)
		for(var/mob/living/carbon/human/H in range(5,src))
			shake_camera(H, 4, 3)
		for(var/mob/living/carbon/human/H in range(1,src))
			H.Stun(20, ignore_canstun = TRUE) // Here we go.
			H.Knockdown(20)
			H.deal_damage((30), RED_DAMAGE)
			if(prob(30))
				H.emote("scream")

			if(H.stat == DEAD)
				H.gib()
