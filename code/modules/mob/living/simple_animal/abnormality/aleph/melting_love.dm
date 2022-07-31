
/mob/living/simple_animal/hostile/abnormality/melting_love
	name = "Melting Love"
	desc = "A pink slime creature, resembling a female humanoid."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "melting_love"
	icon_living = "melting_love"
	faction = list("slime")
	speak_emote = list("gurgle")
	health = 1500
	maxHealth = 1500
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	speed = 2
	move_to_delay = 5
	melee_damage_type = BLACK_DAMAGE
	attack_sound = 'sound/effects/footstep/slime1.ogg'
	damage_coeff = list(BRUTE = -1, RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.8)
	obj_damage = 600
	threat_level = ALEPH_LEVEL
	can_breach = TRUE
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(20, 20, 30, 40, 40),
						ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 45, 45),
						ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 40, 50, 55),
						ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 0, 0),
						)
	work_damage_amount = 14
	work_damage_type = BLACK_DAMAGE
	ranged = TRUE
	minimum_distance = 1
	ranged_cooldown_time = 30
	projectilesound = 'sound/effects/footstep/slime1.ogg'
	var/mob/living/carbon/human/gifted_human = null
	ego_list = list()

//If you kill big slime first oh boy good luck
/mob/living/simple_animal/hostile/abnormality/melting_love/Life()
	if(bigslime_num == 0)
		melee_damage_lower = 62
		melee_damage_upper = 80
		health = 1500
		projectiletype = /obj/projectile/melting_blob/enraged
	else
		melee_damage_lower = 32
		melee_damage_upper = 40
		projectiletype = /obj/projectile/melting_blob

//Attacks
/mob/living/simple_animal/hostile/abnormality/melting_love/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/H = target
		if(H.stat != DEAD)
			if(H.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(H, TRAIT_NODEATH))
				slimeconv(H)
		else
			slimeconv(H)

//Slime Conversion
/mob/living/simple_animal/hostile/proc/slimeconv(mob/living/H)
	if(ishuman(H))
		var/turf/T = get_turf(H)
		visible_message("<span class='danger'>[src] bites hard on \the [H] as another Slime Pawn appears!</span>")
		H.emote("scream")
		H.gib()
		new /mob/living/simple_animal/hostile/slime(T)

/mob/living/simple_animal/hostile/abnormality/melting_love/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

//Qliphoth things
/mob/living/simple_animal/hostile/abnormality/melting_love/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(66))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/zero_qliphoth(mob/living/carbon/human/user)
	if(gifted_human)
		gifted_human.gib()
	else
		breach_effect()
	return

/* Gift */
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/GiftedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	breach_effect()
	var/turf/T = get_turf(gifted_human)
	gifted_human.emote("scream")
	new /mob/living/simple_animal/hostile/slime/big(T)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/melting_love/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		if(!gifted_human && istype(user))
			gifted_human = user
			RegisterSignal(user, COMSIG_LIVING_DEATH, .proc/GiftedDeath)
			to_chat(user, "<span class='nicegreen'>You feel protected.</span>")
			user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 30)
			user.adjustSanityLoss(3)
			user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "gift", -MUTATIONS_LAYER))
			playsound(get_turf(user), 'sound/abnormalities/despairknight/gift.ogg', 50, 0, 2)
			return
		if(gifted_human && istype(user))
			user.adjustSanityLoss(10)
		return
	else
		if(gifted_human && istype(user))
			datum_reference.qliphoth_change(-1)
		return
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/breach_effect(mob/living/carbon/human/user)
	..()
	//icon_living = "melting_breach" TO DO
	//icon_state = icon_living
	return

/* Slimes */
/mob/living/simple_animal/hostile/slime
	name = "Slime Pawn"
	desc = "The skeletal remains of a former employee is floating in it..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "melting_slime"
	icon_living = "melting_slime"
	faction = list("slime")
	speak_emote = list("gurgle")
	health = 400
	maxHealth = 400
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	melee_damage_lower = 20
	melee_damage_upper = 24
	rapid_melee = 2
	obj_damage = 200
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	deathsound = 'sound/abnormalities/bee/death.ogg'
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"
	attack_sound = 'sound/effects/footstep/slime1.ogg'
	speak_emote = list("gurgle")

/mob/living/simple_animal/hostile/slime/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/bee/birth.ogg', 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/slime/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/H = target
		if(H.stat != DEAD)
			if(H.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(H, TRAIT_NODEATH))
				slimeconv(H)
		else
			slimeconv(H)

/mob/living/simple_animal/hostile/slime/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/* Big Slimes */
/mob/living/simple_animal/hostile/slime/big
	name = "Big Slime"
	desc = "The skeletal remains of the former gifted employee is floating in it..."
	health = 800
	maxHealth = 800
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2.0, PALE_DAMAGE = 0.8)
	melee_damage_lower = 34
	melee_damage_upper = 38
	rapid_melee = 2
	obj_damage = 200

/mob/living/simple_animal/hostile/slime/big/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/bee/birth.ogg', 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)
	resize = 1.5
	update_transform()

/mob/living/simple_animal/hostile/slime/big/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/H = target
		if(H.stat != DEAD)
			if(H.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(H, TRAIT_NODEATH))
				slimeconv(H)
		else
			slimeconv(H)
/mob/living/simple_animal/hostile/slime/big/Life()
	bigslime_num = 1

/mob/living/simple_animal/hostile/slime/big/death(gibbed)
	bigslime_num = 0
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()
