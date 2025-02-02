//Very simple, funny little guy.
/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost
	name = "Ghost of Misfortune"
	desc = "What the fuck is that thing!?"
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "neko_horizon"		//Temporary sprite
	icon_living = "neko_horizon"
	del_on_death = TRUE
	maxHealth = 300	//should be a weak little shitter
	health = 300
	rapid_melee = 2
	move_to_delay = 1.2
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)	//It's a ghost you dipshit how are you supposed to punch it
	melee_damage_lower = 2
	melee_damage_upper = 2
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/abnormalities/cleave.ogg'
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1

	ranged = 1
	retreat_distance = 3
	minimum_distance = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/acupuncture,
		/datum/ego_datum/armor/branch12/acupuncture,
	)
	//gift_type =  /datum/ego_gifts/acupuncture
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/Initialize(atom/attacked_target)
	.=..()
	var/breachtime = 5 MINUTES + rand(1, 10 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(BreachMe)), breachtime)

/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/proc/BreachMe(atom/attacked_target)
	datum_reference.qliphoth_change(-99)

/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/Life(atom/attacked_target)
	..()
	for(var/mob/living/simple_animal/hostile/abnormality/branch12/moon_rabbit/A in GLOB.abnormality_mob_list)
		if(!A.IsContained())
			BreachMe()

/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target))
		return
	if(prob(60))
		var/mob/living/carbon/dude = target
		var/obj/item/clothing/shoes/sick_kicks = dude.shoes
		if (!sick_kicks?.can_be_tied)
			return
		sick_kicks.adjust_laces(SHOES_KNOTTED)


/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/BreachEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	pixel_x = 0
	base_pixel_x = 0
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'

/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	say("Don't worry, you want it, I got it.")
	to_chat(user, span_notice("You feel a tiny prick."))

	//Always give you drugs but like it's funny
	user.set_drugginess(15)

/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	user.adjustBruteLoss(-40)

/mob/living/simple_animal/hostile/abnormality/branch12/misfortune_ghost/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	user.adjustToxLoss(15)	//Rare damage type

