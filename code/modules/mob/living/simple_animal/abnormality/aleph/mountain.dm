/mob/living/simple_animal/hostile/abnormality/mountain
	name = "Mountain Of Smiling Bodies"
	desc = "The Mountain of Smiling Bodies is searching for the smell of a body, carrying the smiles of many."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "mosb"
	icon_living = "mosb"
	icon_dead = "mosb_dead"
	maxHealth = 800
	health = 800
	pixel_x = -16
	base_pixel_x = -16
	damage_coeff = list(BRUTE = 1.2, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)

	melee_damage_lower = 24
	melee_damage_upper = 24

	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	stat_attack = DEAD
	ranged = TRUE
	attack_sound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = "nips"
	attack_verb_simple = "nips"
	del_on_death = FALSE
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 50, 55),
						ABNORMALITY_WORK_INSIGHT = 0,
						ABNORMALITY_WORK_ATTACHMENT = 0,
						ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 50, 55)
						)
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
//		/datum/ego_datum/weapon/smile,
//		/datum/ego_datum/armor/smile
		)

	var/finishing = FALSE
	var/death_counter = 0
	var/belly = 0
	var/hurt = FALSE	//Are you hurt?
	var/phase = 1
	var/scream_cooldown
	var/scream_cooldown_time = 10 SECONDS
	var/scream_damage = 40

/mob/living/simple_animal/hostile/abnormality/mountain/Initialize()		//1 in 100 chance for amogus MOSB
	..()
	if(prob(1))
		icon_state = "amog"
	return ..()


/mob/living/simple_animal/hostile/abnormality/mountain/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/mountain/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.stat == DEAD)
		datum_reference.qliphoth_change(-1)

	if(hurt == TRUE)
		datum_reference.qliphoth_change(-1)
		hurt = FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/attempt_work(mob/living/carbon/human/user, work_type)
	if(user.health != user.maxHealth)
		hurt = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/mountain/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/breach_effect(mob/living/carbon/human/user)
	..()
	GiveTarget(user)
	icon_state = "mosb_breach"

/mob/living/simple_animal/hostile/abnormality/mountain/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//Nabbed from Big Bird
/mob/living/simple_animal/hostile/abnormality/mountain/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	death_counter += 1
	if(death_counter >= 10)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE


/mob/living/simple_animal/hostile/abnormality/mountain/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(health < (maxHealth/2.3) && phase >=2)		//I can't do fucking half or it shits out
		icon_state = "mosb_breach"
		playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 50, 1)
		maxHealth *= 0.50
		adjustBruteLoss(-maxHealth)
		phase -= 1

		if(phase == 1)
			icon = 'ModularTegustation/Teguicons/64x64.dmi'
			pixel_x = -16
			base_pixel_x = -16


/mob/living/simple_animal/hostile/abnormality/mountain/AttackingTarget()
	. = ..()
	if(.)
		if(finishing)
			return FALSE

		var/mob/living/H = target
		if(H.health < 0)

			finishing = TRUE
			icon_state = "mosb_bite"
			if(phase==3)					//FUCKING UGLY
				icon_state = "mosb_bite2"

			SLEEP_CHECK_DEATH(5)
			playsound('sound/magic/demon_consume.ogg', 50, TRUE)

			if(!targets_from.Adjacent(H) || QDELETED(H)) // They can still be saved if you move them away
				finishing = FALSE
				return

			belly +=1
			H.gib()

			if(belly >=	3)
				if(phase !=3)
					maxHealth *= 2
					phase +=1
				else
					icon_state = "mosb_breach2"

				adjustBruteLoss(-maxHealth)
				belly =0

				if(phase == 2)
					icon = 'ModularTegustation/Teguicons/96x96.dmi'
					pixel_x = -32
					base_pixel_x = -32

			finishing = FALSE
			icon_state = "mosb_breach"

	if(phase == 3)
		icon_state = "mosb_breach2"
		if(prob(10))
			slam(3,3)


/mob/living/simple_animal/hostile/abnormality/mountain/OpenFire()
	if(phase == 1 && prob(25))
		spit()
	if(phase == 2)
		if(scream_cooldown <= world.time)
			scream()
		else if (prob(20))
			spit()

	if(phase == 3)
		if(prob(30))//Prioritize Spit over scream
			heavyspit()

		else if(scream_cooldown <= world.time)
			scream()


/mob/living/simple_animal/hostile/abnormality/mountain/proc/scream()
	if(scream_cooldown > world.time)
		return
	scream_cooldown = world.time + scream_cooldown_time
	new /obj/effect/temp_visual/voidout(get_turf(src))
	playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 100, 1)
	for(var/mob/living/L in view(7, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(scream_damage, BLACK_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	SLEEP_CHECK_DEATH(3)

/// cannibalized from wendigo
/mob/living/simple_animal/hostile/abnormality/mountain/proc/slam(range, delay)
	new /obj/effect/temp_visual/voidin(get_turf(src))
	SLEEP_CHECK_DEATH(10)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(range, orgin)
	for(var/i = 0 to range)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			playsound(T,'sound/effects/bamf.ogg', 60, TRUE, 10)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/L in T)
				if(L == src || L.throwing)
					continue
				to_chat(L, "<span class='userdanger'>[src]'s ground slam shockwave sends you flying!</span>")
				var/turf/thrownat = get_ranged_target_turf_direct(src, L, 8, rand(-10, 10))
				L.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
				L.apply_damage(40, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				shake_camera(L, 2, 1)
			all_turfs -= T
		sleep(delay)

/mob/living/simple_animal/hostile/abnormality/mountain/proc/spit()
	finishing = TRUE
	SLEEP_CHECK_DEATH(7)
	var/turf/startloc = get_turf(src)
	var/turf/endloc = get_turf(target)
	if(endloc && finishing == TRUE)
		var/obj/projectile/P = new /obj/projectile/mountain(startloc)
		P.preparePixelProjectile(endloc, startloc, null, 0)
		P.firer = src
		if(target)
			P.original = target
		P.fire()
	finishing = FALSE


/mob/living/simple_animal/hostile/abnormality/mountain/proc/heavyspit()
	finishing = TRUE
	SLEEP_CHECK_DEATH(7)
	var/turf/startloc = get_turf(src)
	var/turf/endloc = get_turf(target)
	if(endloc && finishing == TRUE)
		var/obj/projectile/P = new /obj/projectile/mountain/big(startloc)
		P.preparePixelProjectile(endloc, startloc, null, 0)
		P.firer = src
		if(target)
			P.original = target
		P.fire()
	SLEEP_CHECK_DEATH(7)
	finishing = FALSE

