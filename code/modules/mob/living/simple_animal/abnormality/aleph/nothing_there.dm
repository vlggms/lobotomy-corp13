/mob/living/simple_animal/hostile/abnormality/nothing_there
	name = "Nothing There"
	desc = "A wicked creature that consists of various human body parts and organs."
	health = 4000
	maxHealth = 4000
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "nothing"
	icon_living = "nothing"
	icon_dead = "nothing_dead"
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
	melee_damage_lower = 45
	melee_damage_upper = 55
	speed = 2
	move_to_delay = 3
	ranged = TRUE
	pixel_x = -8
	base_pixel_x = -8
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 40, 45),
						ABNORMALITY_WORK_INSIGHT = 0,
						ABNORMALITY_WORK_ATTACHMENT = 50,
						ABNORMALITY_WORK_REPRESSION = 0
						)
	work_damage_amount = 16
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/mimicry,
		/datum/ego_datum/armor/mimicry
		)

	var/mob/living/disguise = null
	var/saved_appearance
	var/can_act = TRUE
	var/current_stage = 1
	var/next_transform = null

	var/hello_cooldown
	var/hello_cooldown_time = 8 SECONDS
	var/hello_damage = 80
	var/goodbye_cooldown
	var/goodbye_cooldown_time = 20 SECONDS
	var/goodbye_damage = 500

/mob/living/simple_animal/hostile/abnormality/nothing_there/Initialize()
	. = ..()
	saved_appearance = appearance

/mob/living/simple_animal/hostile/abnormality/nothing_there/examine(mob/user)
	if(istype(disguise))
		return disguise.examine(user)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Moved()
	if(current_stage == 3)
		playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if((current_stage == 3) && (goodbye_cooldown <= world.time) && prob(35))
		return Goodbye()
	if((current_stage == 3) && (hello_cooldown <= world.time) && prob(35))
		var/turf/target_turf = get_turf(target)
		for(var/i = 1 to 3)
			target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
		return Hello(target_turf)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/OpenFire()
	if(!can_act)
		return

	if(current_stage == 3)
		if(hello_cooldown <= world.time)
			Hello(target)
		if((goodbye_cooldown <= world.time) && (get_dist(src, target) < 3))
			Goodbye()

	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/ListTargets()
	if(istype(disguise))
		return list()
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(istype(disguise) && (health < maxHealth * 0.95))
		drop_disguise()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Life()
	. = ..()
	if(status_flags & GODMODE) // Contained
		return
	if(.)
		if(next_transform && (world.time > next_transform))
			next_stage()

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/disguise_as(mob/living/M)
	if(!(status_flags & GODMODE)) // Already breaching
		return
	if(!istype(M))
		return
	for(var/turf/open/T in view(4, src))
		new /obj/effect/temp_visual/flesh(T)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/disguise.ogg', 75, 0, 5)
	new /obj/effect/gibspawner/generic(get_turf(M))
	to_chat(M, "<span class='userdanger'>Oh no...</span>")
	disguise = M
	appearance = M.appearance
	M.death()
	M.forceMove(src) // Hide them for examine message to work
	addtimer(CALLBACK(src, .proc/zero_qliphoth), rand(20 SECONDS, 50 SECONDS))

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/drop_disguise()
	next_transform = world.time + rand(30 SECONDS, 40 SECONDS)
	if(istype(disguise))
		appearance = saved_appearance
		disguise.forceMove(get_turf(src))
		disguise.gib()
		disguise = null
		fear_level = ALEPH_LEVEL

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/next_stage()
	next_transform = null
	switch(current_stage)
		if(1)
			icon_state = "nothing_egg"
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1)
			can_act = FALSE
			next_transform = world.time + rand(10 SECONDS, 25 SECONDS)
		if(2)
			breach_affected = list() // Too spooky
			FearEffect()
			attack_verb_continuous = "strikes"
			attack_verb_simple = "strike"
			attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
			icon = 'ModularTegustation/Teguicons/64x96.dmi'
			icon_state = icon_living
			pixel_x = -16
			base_pixel_x = -16
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)
			can_act = TRUE
			melee_damage_lower = 65
			melee_damage_upper = 75
			move_to_delay = 5
	adjustBruteLoss(-maxHealth)
	current_stage = clamp(current_stage + 1, 1, 3)

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/Hello(target)
	if(hello_cooldown > world.time)
		return
	hello_cooldown = world.time + hello_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_cast.ogg', 75, 0, 3)
	icon_state = "nothing_ranged"
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 2)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	SLEEP_CHECK_DEATH(5)
	var/list/been_hit = list()
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			break
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			new /obj/effect/temp_visual/smash_effect(TF)
			for(var/mob/living/L in TF)
				if(faction_check_mob(L))
					continue
				if(L in been_hit)
					continue
				been_hit += L
				L.apply_damage(hello_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				if(L.health < 0)
					L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/Goodbye()
	if(goodbye_cooldown > world.time)
		return
	goodbye_cooldown = world.time + goodbye_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, 0, 5)
	icon_state = "nothing_blade"
	SLEEP_CHECK_DEATH(8)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(goodbye_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			if(L.health < 0)
				L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(3)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nothing_there/attempt_work(mob/living/carbon/human/user, work_type)
	if(istype(disguise))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/nothing_there/work_chance(mob/living/carbon/human/user, chance)
	var/adjusted_chance = chance
	var/fort = get_attribute_level(user, FORTITUDE_ATTRIBUTE)
	if(fort < 100)
		adjusted_chance -= (100 - fort) * 0.5
	return adjusted_chance

/mob/living/simple_animal/hostile/abnormality/nothing_there/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	. = ..()
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80)
		if(!istype(disguise)) // Not work failure
			datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if (GODMODE in user.status_flags)
		return
	disguise_as(user)
	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/breach_effect(mob/living/carbon/human/user)
	if(!(status_flags & GODMODE)) // Already breaching
		return
	..()
	if(istype(disguise)) // Teleport us somewhere where nobody will see us at first
		fear_level = 0 // So it doesn't inflict fear to those around them
		var/list/priority_list = list()
		for(var/turf/T in GLOB.xeno_spawn)
			var/people_in_range = 0
			for(var/mob/living/L in view(9, T))
				if(L.client && L.stat < UNCONSCIOUS)
					people_in_range += 1
					continue
			if(people_in_range > 0)
				continue
			priority_list += T
		var/turf/target_turf = pick(GLOB.xeno_spawn)
		if(LAZYLEN(priority_list))
			target_turf = pick(priority_list)
		for(var/turf/open/T in view(3, src))
			new /obj/effect/temp_visual/flesh(T)
		forceMove(target_turf)
	addtimer(CALLBACK(src, .proc/drop_disguise), rand(30 SECONDS, 40 SECONDS))
