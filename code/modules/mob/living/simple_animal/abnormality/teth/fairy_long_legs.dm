/mob/living/simple_animal/hostile/abnormality/fairy_longlegs
	name = "Fairy-Long-Legs"
	desc = "An tall fairy-like abnormality with an arm resembling a paddle, it never stops holding a clover as if it was an umbrella. The leaves seem damp."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "fairy_longlegs"
	icon_living = "fairy_longlegs"
	icon_dead = "fairy_longlegs_dead"
	del_on_death = FALSE
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 900
	health = 900
	rapid_melee = 0.5
	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 12
	melee_damage_upper = 16
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/fairy_longlegs/attack.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(90, 60, 55, 50, 45),
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = 30,
						ABNORMALITY_WORK_REPRESSION = 0,
						"Take cover" = 0,
						)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE
	deathmessage = "coalesces into a primordial egg."
	deathsound = 'sound/abnormalities/fairy_longlegs/death.ogg'
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/finishing = FALSE //cant move/attack when it's TRUE
	var/work_count = 0
	var/raining = FALSE
	var/covering = 0 //stores the agent's choice: 0 - disabled/1- taking cover/2- refused cover

	ego_list = list(
		/datum/ego_datum/weapon/fourleaf_clover,
		/datum/ego_datum/armor/fourleaf_clover
		)
	gift_type =  /datum/ego_gifts/fourleaf_clover

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/Move()
	if(finishing)
		return FALSE
	return ..()

/*** Work Proc ***/
/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/WorkComplete(user, work_type, pe, work_time, canceled)
	. = ..()
	work_count++
	if(work_count < 3)
		return
	say("Oh dear, i'd advise against being hit by this rain.") //tries to trick people into getting cover
	sleep(1 SECONDS)
	say("Care to join me under my umbrella?")
	raining = TRUE
	to_chat(user, "<span class='notice'>You feel the rain seep into your clothes, perhaps it would be best to find shelter....</span>")
	return

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/AttemptWork(mob/living/carbon/human/user, work_type)
	if((work_type != "Take cover")&& !raining)
		return TRUE
	if((work_type == "Take cover") && !raining) //dumbass
		to_chat(user, "<span class='notice'>There's no reason, the skies are clear.</span>")
		return FALSE
	if((work_type == "Take cover") && raining) //Uh oh, you goofed up
		to_chat(user, "<span class='danger'>You take cover under the fairy's clover.</span>")
		work_count = 0
		covering = 1 //user is taking cover
		return FALSE
	if((work_type != "Take cover") && raining)
		if (covering == 1) //if you already chose to take cover
			say ("What do you say, it's so cozy under this umbrella, isn't it?")
			raining = FALSE
			return TRUE
		to_chat(user, "<span class='notice'>The rain is oddly reinvigorating.</span>")
		user.adjustBruteLoss(-80) //The rain actually heals you, lying bastard...
		work_count = 0
		covering = 2 //[[FAIRY-LONG-LEGS WILL REMEMBER THIS]]
		raining = FALSE
		return TRUE


/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		datum_reference.qliphoth_change(-2)
	if (covering == 2) //refused his offer to take cover
		say("Tch, this damn rain robs me of my food all the time.")
		covering = 0
		datum_reference.qliphoth_change(-2)
	if (covering == 1) //taking cover under the clover with the long legs (bad idea!)
		covering = 0
		user.visible_message("<span class='warning'>You feel a stinging pain in your chest, is that...blood?!</span>")
		playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/attack.ogg', 50, 1)
		user.apply_damage(80, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/AttackingTarget()
	if(finishing)
		return FALSE
	if(!istype(target, /mob/living/carbon/human))
		return
	finishing = TRUE
	icon_state = "fairy_longlegs_healing"
	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/heal.ogg', 50, 1)
	adjustBruteLoss(-(maxHealth*0.04)) //recovers 38 health per hit
	..()
	SLEEP_CHECK_DEATH(15)
	icon_state = "fairy_longlegs"
	finishing = FALSE
