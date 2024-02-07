/mob/living/simple_animal/hostile/abnormality/space_lady
	name = "Lady out of Space"
	desc = "A humanoid abnormality. It looks extremely pale."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "space"
	icon_living = "space"
	del_on_death = TRUE
	maxHealth = 3200
	health = 3200
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 1)
	faction = list("hostile")
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	ranged = 1
	retreat_distance = 3
	minimum_distance = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 40, 50, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 40, 45, 45),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 30, 30, 30),
	)
	work_damage_amount = 8	//Half white, half black damage
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/space,
		/datum/ego_datum/armor/space,
	)
	gift_type =  /datum/ego_gifts/space
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK
	ranged = TRUE
	minimum_distance = 0
	ranged_cooldown_time = 3 SECONDS

	var/explosion_timer = 2 SECONDS
	var/explosion_state = 3
	var/explosion_damage = 100
	var/can_act = TRUE

//She can't move or attack.
/mob/living/simple_animal/hostile/abnormality/space_lady/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/space_lady/AttackingTarget(atom/attacked_target)
	return OpenFire()


/mob/living/simple_animal/hostile/abnormality/space_lady/OpenFire()
	if(!can_act)
		return

	if(prob(10))
		addtimer(CALLBACK(src, PROC_REF(ExplodeTimer)), explosion_timer*2)
		can_act = FALSE

	else if(prob(50))
		projectiletype = /obj/projectile/white_hole

	else
		projectiletype = /obj/projectile/black_hole

	..()

//Teleporting and exploding
/mob/living/simple_animal/hostile/abnormality/space_lady/proc/ExplodeTimer()
	say("[explosion_state]...")
	explosion_state -=1

	if (explosion_state == 0)
		explosion_state = initial(explosion_state)
		icon_state = "space_attack"
		addtimer(CALLBACK(src, PROC_REF(Explode)), 15)
	else
		addtimer(CALLBACK(src, PROC_REF(ExplodeTimer)), explosion_timer)

/mob/living/simple_animal/hostile/abnormality/space_lady/proc/Explode()
	//Black hole effect
	goonchem_vortex(get_turf(src), 0, 13)
	for(var/turf/T in view(14, src))
		if(T.density)
			continue
		new /obj/effect/temp_visual/revenant(T)
		for(var/mob/living/carbon/human/L in T)
			L.apply_damage(explosion_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	SLEEP_CHECK_DEATH(10)	//I kinda want it to be a bit of a delay but not too much

	//White Hole effect
	for(var/mob/living/carbon/human/L in view(14, src))
		L.apply_damage(explosion_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	goonchem_vortex(get_turf(src), 1, 13)
	can_act = TRUE
	Teleport()

/mob/living/simple_animal/hostile/abnormality/space_lady/proc/Teleport()
	icon_state = "space_teleport"
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)




//work stuff
/mob/living/simple_animal/hostile/abnormality/space_lady/WorktickFailure(mob/living/carbon/human/user)
	var/list/damtypes = list(WHITE_DAMAGE, BLACK_DAMAGE)
	for(var/damagetype in damtypes) // take 8 of both damage types every failed tick
		user.apply_damage(work_damage_amount, damagetype, null, user.run_armor_check(null, damagetype))
	work_damage_type = pick(damtypes) //Displays either work damage type every tick
	WorkDamageEffect()
	return

/mob/living/simple_animal/hostile/abnormality/space_lady/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_user_level(user) < 5)
		datum_reference.qliphoth_change(-1)
	if(get_user_level(user) < 4)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/space_lady/AttemptWork(mob/living/carbon/human/user, work_type)
	if(get_user_level(user) < 3)
		datum_reference.qliphoth_change(-1)
		animate(user, transform = user.transform*0.01, time = 5)
		QDEL_IN(user, 5)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/space_lady/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)
	return

/mob/living/simple_animal/hostile/abnormality/space_lady/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/space_lady/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	Teleport()


//Bullets
/obj/projectile/white_hole
	name = "miniature white hole"
	icon_state = "antimagic"
	desc = "A mini white hole."
	nodamage = TRUE
	hitsound = "sound/effects/footstep/slime1.ogg"
	speed = 3

/obj/projectile/white_hole/on_hit(target)
	goonchem_vortex(get_turf(src), 1, 5)
	for(var/turf/T in view(3, src))
		if(T.density)
			continue
		new /obj/effect/temp_visual/revenant(T)
		for(var/mob/living/carbon/human/L in T)
			L.apply_damage(100, WHITE_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)


/obj/projectile/black_hole
	name = "miniature black hole"
	icon_state = "antimagic"
	desc = "A mini black hole."
	nodamage = TRUE
	hitsound = "sound/effects/footstep/slime1.ogg"
	color = COLOR_PURPLE
	speed = 3

/obj/projectile/black_hole/on_hit(target)
	goonchem_vortex(get_turf(src), 0, 5)
	for(var/turf/T in view(3, src))
		if(T.density)
			continue
		new /obj/effect/temp_visual/revenant(T)
		for(var/mob/living/carbon/human/L in T)
			L.apply_damage(100, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)


