/mob/living/simple_animal/hostile/abnormality/branch12/rock
	name = "Remnant of the Forest"
	desc = "A little rock with a smiley face on it."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "rock_contained"
	icon_living = "rock_contained"
	maxHealth = 999999
	health = 999999
	blood_volume = 0
	threat_level = TETH_LEVEL
	max_boxes = 1
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 1
	work_damage_type = WHITE_DAMAGE
	can_breach = TRUE
	density = FALSE

	ego_list = list(
		//	There is no EGO
	)
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/rock/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	var/turf/W = pick(GLOB.xeno_spawn)
	new /obj/item/ego_weapon/rock (get_turf(W))
	ZeroQliphoth()

/mob/living/simple_animal/hostile/abnormality/branch12/rock/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/rock/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/rock/AttemptWork(mob/living/carbon/human/user, work_type)
	if(!icon_state)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/rock/BreachEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	//make it invisible
	icon_state = null
	name = ""
	desc = ""

	//make it invincible again
	status_flags &= GODMODE

//The item rock that spawns in
/obj/item/ego_weapon/rock
	name = "The Remnant of the Forest"
	desc = "A little rock with a smiley face on it."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "rock"
	force = 80
	throwforce = 150		//It's funny but very slow
	throw_speed = 1
	throw_range = 3
	stuntime = 12	//Longer reach, gives you a short stun.
	attack_speed = 1.2
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes")
	attack_verb_simple = list("bash")
	w_class = WEIGHT_CLASS_HUGE

	slowdown = 5
	item_flags = SLOWS_WHILE_IN_HAND
	drag_slowdown = 5

/obj/item/ego_weapon/rock/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(!ishuman(hit_atom))
		return
	var/mob/living/carbon/human/H = hit_atom
	if(H.stat == DEAD)
		H.gib()	//It's funny
	else
		H.Stun(20)
		H.Knockdown(20)

