//Dead burd, like Jbird and Pbird at once
/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird
	name = "Dead Bird"
	desc = "A fat bird that has stitched closed eyes."
	icon = 'ModularTegustation/Teguicons/branch12/48x48.dmi'
	icon_state = "dead_bird"
	icon_living = "dead_bird"
	pixel_x = -8
	base_pixel_x = -8
	del_on_death = TRUE
	maxHealth = 2700	//should be a little tankier as it's a bit slow
	health = 2700
	rapid_melee = 2
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.4, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 0.5)	//It is dead so
	melee_damage_lower = 14
	melee_damage_upper = 14
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bites"
	response_help_continuous = "pets"
	response_help_simple = "pet"
	attack_sound = 'sound/abnormalities/cleave.ogg'
	faction = list("hostile", "neutral")
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 1

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 35, 45, 45),
		ABNORMALITY_WORK_INSIGHT = list(20, 20, 40, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(20, 20, 35, 45, 45),
	)
	work_damage_amount = 13
	work_damage_type = RED_DAMAGE

	ego_list = list(
	//	/datum/ego_datum/weapon/branch12/egoification,
	//	/datum/ego_datum/armor/legs
	)
	//gift_type =  /datum/ego_gifts/departure
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	can_patrol = TRUE
	var/beenhit		//Have we been hit since last AOE?
	var/aoerange = 4

/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <80)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	datum_reference.qliphoth_change(-1)
	return


/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird/BreachEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	addtimer(CALLBACK(src, PROC_REF(aoe)), 8 SECONDS)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird/proc/aoe()
	addtimer(CALLBACK(src, PROC_REF(aoe)), 8 SECONDS)
	if(beenhit)
		beenhit = FALSE
		return

	beenhit = FALSE
	playsound(src, 'sound/weapons/fixer/hana_blunt.ogg', 75, FALSE, 4)
	for(var/turf/open/T in view(src,aoerange))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T.contents)
			if(L==src)
				continue
			L.deal_damage(40, RED_DAMAGE)
			L.apply_lc_bleed(60)

/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird/attackby(obj/item/C, mob/user)
	..()
	beenhit = TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/dead_bird/bullet_act(obj/projectile/P)
	..()
	beenhit = TRUE
