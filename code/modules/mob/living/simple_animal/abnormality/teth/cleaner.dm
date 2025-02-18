/mob/living/simple_animal/hostile/abnormality/cleaner
	name = "All-Around Cleaner"
	desc = "A tiny robot with helpful intentions."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "cleaner"
	icon_living = "cleaner"
	portrait = "cleaner"
	maxHealth = 800
	health = 800
	ranged = TRUE
	attack_verb_continuous = "cleans"
	attack_verb_simple = "cleans"
	attack_sound = 'sound/abnormalities/helper/attack.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 11
	melee_damage_upper = 12
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	speak_emote = list("states")
	vision_range = 14
	aggro_vision_range = 20

	can_breach = TRUE
	threat_level = TETH_LEVEL
	faction = list("neutral", "hostile")
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 55, 55, 50, 45),
		ABNORMALITY_WORK_INSIGHT = list(35, 40, 40, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(35, 40, 40, 35, 35),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, -30, -60, -90),
	)
	work_damage_amount = 7
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/abno_oil

	ego_list = list(
		/datum/ego_datum/weapon/sanitizer,
		/datum/ego_datum/armor/sanitizer,
	)
	gift_type =  /datum/ego_gifts/sanitizer
	gift_message = "Contamination scan complete. Initiating cleaning protocol."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/helper = 1.5,
		/mob/living/simple_animal/hostile/abnormality/we_can_change_anything = 1.5,
	)

	observation_prompt = "I wipe everything. <br>\
		Cleaning is enjoyable. <br>\
		I like to be the same as others. <br>\
		... <br>\
		I am frankly troubled. <br>\
		The model next to mine boasted that it has multiple parts that others don't. <br>\
		Is that what makes one special? <br>\
		Am I special the way I am?"
	observation_choices = list(
		"You are not special" = list(TRUE, "\"Am I not special, not special, not special?\" <br>\
			After giving a lagged reply, it suddenly began tearing off all the cleaning gadgets from its body and crashing into walls. <br>\
			It rubbed its body on other objects while sparks flew off as if it was trying to attach things to it. <br>\
			It only stopped after a while. <br>\
			\"Maybe I wanted to be special.\""),
		"You are special" = list(FALSE, "\"No. I am not special.\" <br>\
			Disregarding the answer, it gives a stern reply. <br>\
			\"I will keep living an ordinary life, the same as now, just as assigned to me.\""),
	)

	var/bumpdamage = 10

/mob/living/simple_animal/hostile/abnormality/cleaner/Move()
	..()
	//Toss meatbags aside
	for(var/mob/living/carbon/human/H in range(1, src))
		if(H.stat >= SOFT_CRIT)
			continue
		visible_message("[src] tosses [H] out of the way!")
		H.deal_damage(bumpdamage, RED_DAMAGE)

		var/rand_dir = pick(NORTH, SOUTH, EAST, WEST)
		var/atom/throw_target = get_edge_target_turf(H, rand_dir)
		if(!H.anchored)
			H.throw_at(throw_target, rand(6, 10), 18, H)

		if(H.stat == DEAD)
			H.gib(FALSE, FALSE, FALSE)

	//destroy blood
	for(var/obj/effect/decal/cleanable/blood/B in view(src, 2))
		qdel(B)

/mob/living/simple_animal/hostile/abnormality/cleaner/update_icon_state()
	if(status_flags & GODMODE)
		icon = initial(icon)
		pixel_x = initial(pixel_x)
		base_pixel_x = initial(base_pixel_x)
		pixel_y = initial(pixel_y)
		base_pixel_y = initial(base_pixel_y)
	else
		icon = 'ModularTegustation/Teguicons/48x48.dmi'
		pixel_x = -8
		base_pixel_x = -8
		pixel_y = -8
		base_pixel_y = -8

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/cleaner/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/cleaner/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/cleaner/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()
	GiveTarget(user)

