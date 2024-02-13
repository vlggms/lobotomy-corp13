#define STATUS_EFFECT_OVERWHELMING_FEAR /datum/status_effect/overwhelming_fear
/mob/living/simple_animal/hostile/abnormality/censored
	name = "CENSORED"
	desc = "What is this... It's too disgusting to even look at..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "censored"
	icon_living = "censored"
	portrait = "censored"
	pixel_x = -16
	base_pixel_x = -16
	speak_emote = list("screeches")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/censored/attack.ogg'
	/* Stats */
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL + 3
	health = 4000
	maxHealth = 4000
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 75
	melee_damage_upper = 85
	move_to_delay = 3
	ranged = TRUE
	/* Works */
	start_qliphoth = 2
	can_breach = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(80, 70, 60, 55, 50),
		ABNORMALITY_WORK_INSIGHT = list(90, 80, 70, 65, 60),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 45, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
		"Sacrifice" = 999,
	)
	work_damage_amount = 14
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/censored,
		/datum/ego_datum/armor/censored,
	)

	gift_type =  /datum/ego_gifts/censored
	gift_message = "You feel disgusted just looking at it."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	var/can_act = TRUE
	var/ability_damage = 150
	var/ability_cooldown
	var/ability_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/abnormality/censored/Life()
	. = ..()
	if(!.)
		return
	// Apply and refresh status effect to all humans nearby
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H.stat == DEAD)
			continue
		if(faction_check_mob(H))
			continue
		H.apply_status_effect(STATUS_EFFECT_OVERWHELMING_FEAR)

/mob/living/simple_animal/hostile/abnormality/censored/FearEffectText(mob/affected_mob, level = 0)
	level = num2text(clamp(level, 3, 5))
	var/list/result_text_list = list(
		"3" = list("GODDAMN IT!!!!", "H-Help...", "I don't want to die!"),
		"4" = list("What am I seeing...?", "I-I can't take it...", "I can't understand..."),
		"5" = list("It's all over...", "What..."),
	)
	return pick(result_text_list[level])

/* Combat */
/mob/living/simple_animal/hostile/abnormality/censored/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/Moved()
	. = ..()
	if(!(status_flags & GODMODE))
		for(var/mob/living/carbon/human/H in view(1, src))
			if(H.stat >= SOFT_CRIT || H.health < 0)
				Convert(H)
				break

/mob/living/simple_animal/hostile/abnormality/censored/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/AttackingTarget()
	. = ..()
	if(!can_act)
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		return Convert(H)

	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				RangedAbility(target)
		return

	if(ability_cooldown <= world.time && prob(50))
		RangedAbility(target)

	return

/mob/living/simple_animal/hostile/abnormality/censored/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!can_act)
		return
	can_act = FALSE
	forceMove(get_turf(H))
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	playsound(src, 'sound/abnormalities/censored/convert.ogg', 45, FALSE, 5)
	SLEEP_CHECK_DEATH(3)
	new /obj/effect/temp_visual/censored(get_turf(src))
	for(var/i = 1 to 3)
		new /obj/effect/gibspawner/generic/silent(get_turf(src))
		SLEEP_CHECK_DEATH(5.5)
	var/mob/living/simple_animal/hostile/mini_censored/C = new(get_turf(src))
	if(!QDELETED(H))
		C.desc = "What the hell is this? It shouldn't exist... On the second thought, it reminds you of [H.real_name]..."
		H.gib()
	ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1))
	adjustBruteLoss(-(maxHealth*0.1))
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/censored/proc/RangedAbility(atom/target)
	if(!can_act)
		return
	if(world.time < ability_cooldown)
		return
	can_act = FALSE
	ability_cooldown = world.time + ability_cooldown_time
	var/turf/T = get_ranged_target_turf_direct(src, get_turf(target), 10, rand(-10,10))
	var/list/turf_list = list()
	playsound(src, 'sound/abnormalities/censored/ability.ogg', 50, FALSE, 5)
	for(var/turf/TT in getline(src, T))
		if(TT.density)
			break
		new /obj/effect/temp_visual/cult/sparks(TT)
		turf_list += TT
		T = TT
	if(!LAZYLEN(turf_list))
		can_act = TRUE
		return
	for(var/i = 1 to 3)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		D.alpha = 100
		D.pixel_x = base_pixel_x + rand(-8, 8)
		D.pixel_y = base_pixel_y + rand(-8, 8)
		animate(D, alpha = 0, transform = matrix()*1.2, time = 8)
		SLEEP_CHECK_DEATH(0.15 SECONDS)
	SLEEP_CHECK_DEATH(0.3 SECONDS)
	Beam(T, "censored", time = 10)
	playsound(src, 'sound/weapons/ego/censored3.ogg', 75, FALSE, 5)
	for(var/turf/TT in turf_list)
		for(var/mob/living/L in TT)
			if(faction_check_mob(L))
				continue
			L.apply_damage(ability_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
	can_act = TRUE

/* Work */
/mob/living/simple_animal/hostile/abnormality/censored/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "Sacrifice")
		to_chat(user, span_warning("You hesitate for a moment..."))
		datum_reference.working = TRUE
		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("You decide it's not worth it."))
			datum_reference.working = FALSE
			return null
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.3 SECONDS)
		step_towards(user, src)
		new /obj/effect/temp_visual/censored(get_turf(src))
		sleep(0.3 SECONDS)
		playsound(src, 'sound/abnormalities/censored/sacrifice.ogg', 45, FALSE, 10)
		if(status_flags & GODMODE) //If CENSORED is still contained within this small time frame
			datum_reference.qliphoth_change(1)
			user.death()
			for(var/i = 1 to 3)
				new /obj/effect/gibspawner/generic/silent(get_turf(src))
				sleep(5.4)
			QDEL_NULL(user)
		else
			user.AdjustStun(-999) //run for your life
		datum_reference.working = FALSE
		return null
	return TRUE

/mob/living/simple_animal/hostile/abnormality/censored/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/censored/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/censored/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_living = "censored_breach"
	icon_state = icon_living
	return

/* The mini censoreds */
/mob/living/simple_animal/hostile/mini_censored
	name = "???"
	desc = "What the hell is this? It shouldn't exist..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "censored_mini"
	icon_living = "censored_mini"
	speak_emote = list("screeches")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/censored/mini_attack.ogg'
	/* Stats */
	health = 600
	maxHealth = 600
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 25
	melee_damage_upper = 30
	speed = 2
	move_to_delay = 2
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	density = FALSE
	var/list/breach_affected = list()

/mob/living/simple_animal/hostile/mini_censored/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/censored/mini_born.ogg', 50, 1, 4)
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/mini_censored/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	for(var/i = 1 to 2)
		addtimer(CALLBACK(src, PROC_REF(ShakePixels)), i*5 + rand(1, 4))
	ShakePixels()
	FearEffect()
	return

/mob/living/simple_animal/hostile/mini_censored/proc/ShakePixels()
	animate(src, pixel_x = base_pixel_x + rand(-3, 3), pixel_y = base_pixel_y + rand(-3, 3), time = 2)
	return

// Applies fear damage to everyone in range, copied from abnormalities
/mob/living/simple_animal/hostile/mini_censored/proc/FearEffect()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in breach_affected)
			continue
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			continue
		breach_affected += H
		H.adjustSanityLoss(20)
		if(H.sanity_lost)
			continue
		to_chat(H, span_warning("Damn, it's scary."))
	return

// Status effect applied by CENSORED
/datum/status_effect/overwhelming_fear
	id = "overwhelming_fear"
	status_type = STATUS_EFFECT_REFRESH
	duration = 20 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/overwhelming_fear
	/// The damage will not be done below that percentage of max sanity
	var/sanity_limit_percent = 0.3
	/// How much percents of max sanity is dealt as pure sanity damage each tick
	var/sanity_damage_percent = 0.05

/atom/movable/screen/alert/status_effect/overwhelming_fear
	name = "Overwhelming Fear"
	desc = "You find it difficult to recollect yourself. Your sanity will be slowly lowering to 20%."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "overwhelming_fear"

/datum/status_effect/overwhelming_fear/on_apply()
	if(!ishuman(owner))
		return FALSE
	return ..()

/datum/status_effect/overwhelming_fear/tick()
	. = ..()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.getSanityLoss() >= status_holder.getMaxSanity() * sanity_limit_percent)
		return
	status_holder.adjustSanityLoss(status_holder.getMaxSanity() * sanity_damage_percent)
