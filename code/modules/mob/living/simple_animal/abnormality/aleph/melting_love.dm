
/mob/living/simple_animal/hostile/abnormality/melting_love
	name = "Melting Love"
	desc = "A pink slime creature, resembling a female humanoid."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "melting_love"
	icon_living = "melting_love"
	pixel_x = -16
	base_pixel_x = -16
	faction = list("slime")
	speak_emote = list("gurgle")
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"
	/* Stats */
	threat_level = ALEPH_LEVEL
	health = 3500
	maxHealth = 3500
	obj_damage = 600
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.8)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 32
	melee_damage_upper = 40
	projectiletype = /obj/projectile/melting_blob
	ranged = TRUE
	minimum_distance = 1
	ranged_cooldown_time = 30
	speed = 2
	move_to_delay = 5
	/* Works */
	start_qliphoth = 3
	can_breach = TRUE
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(20, 20, 30, 40, 40),
						ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 45, 45),
						ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 40, 50, 55),
						ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 0, 0),
						)
	work_damage_amount = 14
	work_damage_type = BLACK_DAMAGE
	/* Sounds */
	projectilesound = 'sound/effects/attackblob.ogg'
	attack_sound = 'sound/effects/attackblob.ogg'
	deathsound = 'sound/effects/blobattack.ogg'
	/*Vars and others */
	loot = list(/obj/item/reagent_containers/glass/bucket/melting)
	del_on_death = FALSE
	var/mob/living/carbon/human/gifted_human = null
	var/sanityheal_cooldown = 15 SECONDS
	var/sanityheal_cooldown_base = 15 SECONDS
	ego_list = list(/datum/ego_datum/weapon/adoration, /datum/ego_datum/armor/adoration)

/mob/living/simple_animal/hostile/abnormality/melting_love/Life()
	. = ..()
	if(gifted_human)
		sanityheal()

/mob/living/simple_animal/hostile/abnormality/melting_love/breach_effect(mob/living/carbon/human/user)
	..()
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_living = "melting_breach"
	icon_state = icon_living
	icon_dead = "melting_breach_dead"
	pixel_x = -32
	base_pixel_x = -32
	desc = "A pink hunched creature with long arms, there are also visible bones coming from insides of the slime."
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/* Attacks */
/mob/living/simple_animal/hostile/abnormality/melting_love/CanAttack(atom/the_target)
	if(isliving(target) && !ishuman(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/AttackingTarget()
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.stat != DEAD)
		if(H.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(H, TRAIT_NODEATH))
			slimeconv(H)
	else
		slimeconv(H)

/* Slime Conversion */
/mob/living/simple_animal/hostile/proc/slimeconv(mob/living/H)
	if(!H)
		return FALSE
	var/turf/T = get_turf(H)
	visible_message("<span class='danger'>[src] glomp on \the [H] as another Slime Pawn appears!</span>")
	H.gib()
	new /mob/living/simple_animal/hostile/slime(T)
	return TRUE

/* Qliphoth things */
/mob/living/simple_animal/hostile/abnormality/melting_love/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/zero_qliphoth(mob/living/carbon/human/user)
	if(gifted_human)
		to_chat(gifted_human, "<span class='userdanger'>You feel like you are about to burst !</span>")
		gifted_human.emote("scream")
		gifted_human.gib()
	breach_effect()
	return

/* Gift */
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/GiftedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	SpawnBigSlime()
	datum_reference.qliphoth_change(-9)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/melting_love/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		if(!gifted_human && istype(user))
			gifted_human = user
			RegisterSignal(user, COMSIG_LIVING_DEATH, .proc/GiftedDeath)
			to_chat(user, "<span class='nicegreen'>You feel like you received a gift...</span>")
			user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 30)
			user.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "gift", -HALO_LAYER))
			playsound(get_turf(user), 'sound/effects/footstep/slime1.ogg', 50, 0, 2)
			return
		if(user == gifted_human)
			to_chat(gifted_human, "<span class='nicegreen'>Melting Love is happy to see you !</span>")
			gifted_human.adjustSanityLoss(25)
		return

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/sanityheal()
	if(sanityheal_cooldown <= world.time)
		gifted_human.adjustSanityLoss(30)
		sanityheal_cooldown = (world.time + sanityheal_cooldown_base)

/* Checking if bigslime is dead or not and apply a damage buff if yes */
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SlimeDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	melee_damage_lower = 62
	melee_damage_upper = 80
	adjustBruteLoss(-maxHealth)
	projectiletype = /obj/projectile/melting_blob/enraged
	return TRUE

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SpawnBigSlime()
	var/turf/T = get_turf(gifted_human)
	gifted_human.gib()
	var /mob/living/simple_animal/hostile/slime/big/S = new(T)
	RegisterSignal(S, COMSIG_LIVING_DEATH, .proc/SlimeDeath)

/* Slimes */
/mob/living/simple_animal/hostile/slime
	name = "Slime Pawn"
	desc = "The skeletal remains of a former employee is floating in it..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "little_slime"
	icon_living = "little_slime"
	faction = list("slime")
	speak_emote = list("gurgle")
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"
	/* Stats */
	health = 800
	maxHealth = 800
	obj_damage = 200
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 24
	rapid_melee = 2
	/* Sounds */
	deathsound = 'sound/effects/blobattack.ogg'
	attack_sound = 'sound/effects/attackblob.ogg'
	/* Vars and others */
	robust_searching = TRUE
	stat_attack = DEAD
	del_on_death = TRUE

/mob/living/simple_animal/hostile/slime/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/effects/footstep/slime1.ogg', 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/slime/CanAttack(atom/the_target)
	if(isliving(target) && !ishuman(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/slime/AttackingTarget()
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.stat != DEAD)
		if(H.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(H, TRAIT_NODEATH))
			slimeconv(H)
	else
		slimeconv(H)

/* Big Slimes */
/mob/living/simple_animal/hostile/slime/big
	name = "Big Slime"
	desc = "The skeletal remains of the former gifted employee is floating in it..."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "big_slime"
	icon_living = "big_slime"
	pixel_x = -8
	base_pixel_x = -8
	/* Stats */
	health = 2000
	maxHealth = 2000
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2.0, PALE_DAMAGE = 0.8)
	melee_damage_lower = 34
	melee_damage_upper = 38

/mob/living/simple_animal/hostile/slime/big/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/effects/footstep/slime1.ogg', 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)
