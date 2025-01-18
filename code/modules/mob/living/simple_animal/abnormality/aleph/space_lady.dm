/mob/living/simple_animal/hostile/abnormality/space_lady
	name = "Lady out of Space"
	desc = "A humanoid abnormality. It looks extremely pale."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "space"
	icon_living = "space"
	portrait = "space"
	del_on_death = TRUE
	maxHealth = 3200
	health = 3200
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 1)
	faction = list("hostile")
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	retreat_distance = 3
	minimum_distance = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 40, 50, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 40, 45, 45),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 30, 30, 30),
	)
	work_damage_amount = 16	//Half white, half black damage
	work_damage_type = list(WHITE_DAMAGE, BLACK_DAMAGE)

	ego_list = list(
		/datum/ego_datum/weapon/space,
		/datum/ego_datum/armor/space,
	)
	gift_type =  /datum/ego_gifts/space
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK
	ranged = TRUE
	minimum_distance = 3
	retreat_distance = 3
	ranged_cooldown_time = 3 SECONDS

	observation_prompt = "What touched this place cannot be quantified or understood by human science. <br>It was just a color out of space. <br>\
		It exists on the border of our waking minds, where darkness and light are one, and time and space do not intersect. <br>She has a message, from another place, another time."
	observation_choices = list(
		"Hear the past" = list(TRUE, "What I learned and saw during those two hideous days and nights, it is better not to tell."),
		"Hear the present" = list(TRUE, "A thousand years compressed into a day, a countably infinite number of people work, die and live in its corridors; <br>\
			the line between them and the monsters they keep gets blurrier and blurrier. <br>\
			A seed is about to sprout..."),
		"Hear the future" = list(TRUE, "The Library is what the Bookhunters call it, a mystical place of life and death. <br>\
			Should you conquer its trials, they say, you can find the book that will grant the answers to whatever it is you seek. <br>\
			Black feathers and regret..."),
	)

	var/explosion_timer = 2 SECONDS
	var/explosion_state = 3
	var/explosion_damage = 100
	var/can_act = TRUE
	var/negative_range = 10

//She can't move or attack.
/mob/living/simple_animal/hostile/abnormality/space_lady/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/space_lady/AttackingTarget(atom/attacked_target)
	OpenFire()
	return

/mob/living/simple_animal/hostile/abnormality/space_lady/OpenFire()
	if(!can_act)
		return

	switch(rand(1, 100))
		if(1 to 10)
			SpellBinder()

		if(10 to 20)
			addtimer(CALLBACK(src, PROC_REF(ExplodeTimer)), explosion_timer*2)
			can_act = FALSE

		if(20 to 30)
			NegativeField()

		if(30 to 40)
			Timestop()

		if(40 to 50)
			BulletTime()

		else
			if(prob(50))
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
			L.deal_damage(explosion_damage, BLACK_DAMAGE)
	SLEEP_CHECK_DEATH(10)	//I kinda want it to be a bit of a delay but not too much

	//White Hole effect
	for(var/mob/living/carbon/human/L in view(14, src))
		L.deal_damage(explosion_damage, WHITE_DAMAGE)
	goonchem_vortex(get_turf(src), 1, 13)
	can_act = TRUE
	Teleport()

/mob/living/simple_animal/hostile/abnormality/space_lady/proc/Teleport()
	icon_state = "space_teleport"
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)

//Inverts Sanity, kills the insane
/mob/living/simple_animal/hostile/abnormality/space_lady/proc/NegativeField()
	say("Ashes to ashes...")
	can_act = FALSE
	SLEEP_CHECK_DEATH(25)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(negative_range, orgin)
	for(var/i = 0 to negative_range)
		playsound(src, 'sound/weapons/guillotine.ogg', 75, FALSE, 4)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			new /obj/effect/temp_visual/negativelook(T)
			for(var/mob/living/carbon/human/L in T)
				if(L.sanity_lost)					//DIE FOOL. LADY BLAST
					L.death()
				var/sanity_holder = L.sanityhealth	//Hold your current sanity
				L.adjustSanityLoss(-20000) 			//bring you back to full sanity
				L.adjustSanityLoss(sanity_holder)	//and then deal damage equal to your sanity before this attack

			all_turfs -= T
		SLEEP_CHECK_DEATH(3)
	can_act = TRUE

//Time stop
/mob/living/simple_animal/hostile/abnormality/space_lady/proc/Timestop()
	say("Stop...")
	can_act = FALSE
	SLEEP_CHECK_DEATH(12)
	new /obj/effect/timestop(get_turf(src), 3, 40, list(src))
	can_act = TRUE

//Bouncing bullets
/mob/living/simple_animal/hostile/abnormality/space_lady/proc/BulletTime()
	say("Hold it...")
	can_act = FALSE
	SLEEP_CHECK_DEATH(6)

	//Will look into giving it a unique attack
	var/turf/startloc = get_turf(targets_from)
	for(var/i = 1 to 15)
		var/obj/projectile/loos_bullet/black/P = new(get_turf(src))
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.yo = target.y - startloc.y
		P.xo = target.x - startloc.x
		P.original = target
		P.preparePixelProjectile(target, src)
		P.fire()

	SLEEP_CHECK_DEATH(10)
	can_act = TRUE

//based off a touhou attack of the same name, I need to actually finish it.
/mob/living/simple_animal/hostile/abnormality/space_lady/proc/SpellBinder()
	say("Spellbinding circle...")
	can_act = FALSE
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(negative_range, orgin)
	playsound(src, 'sound/weapons/guillotine.ogg', 75, FALSE, 4)
	for(var/turf/T in all_turfs)
		if(get_dist(orgin, T) != 6)
			continue
		new /obj/effect/temp_visual/negativelook/spellbinder(T)
		all_turfs -= T
	SLEEP_CHECK_DEATH(3)

	//Will look into giving it a unique attack
	var/turf/startloc = get_turf(targets_from)
	for(var/i = 1 to 15)
		var/obj/projectile/loos_bullet/P = new(get_turf(src))
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.yo = target.y - startloc.y
		P.xo = target.x - startloc.x
		P.original = target
		P.preparePixelProjectile(target, src)
		P.fire()

	SLEEP_CHECK_DEATH(10)

	for(var/turf/T in all_turfs)
		if(get_dist(orgin, T) != 3)
			continue
		new /obj/effect/temp_visual/negativelook/spellbinder(T)

	SLEEP_CHECK_DEATH(20)

	can_act = TRUE

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
	//two chances to lower by 1
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	if(prob(50))
		datum_reference.qliphoth_change(-1)

	return

/mob/living/simple_animal/hostile/abnormality/space_lady/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/space_lady/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(breach_type != BREACH_MINING)
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
			L.deal_damage(100, WHITE_DAMAGE)


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
			L.deal_damage(100, BLACK_DAMAGE)

/obj/projectile/loos_bullet
	name = "white beam"
	icon_state = "whitelaser"
	desc = "A beam of white light."
	hitsound = "sound/effects/footstep/slime1.ogg"
	speed = 5		//very slow bullets
	damage = 40		//She fires a lot of them
	damage_type = WHITE_DAMAGE
	spread = 360	//Fires in a 360 Degree radius
	white_healing = FALSE

	//Grabbed from Harmony, I do want it to act the same
	projectile_piercing  = ALL
	ricochets_max = 3
	ricochet_chance = 100 // JUST FUCKING DO IT
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1.5 // Does MORE per bounce
	ricochet_auto_aim_range = 3
	ricochet_incidence_leeway = 0

/obj/projectile/loos_bullet/check_ricochet_flag(atom/A)
	if(istype(A, /obj/effect/temp_visual/negativelook/spellbinder))
		return TRUE
	return FALSE


/obj/projectile/loos_bullet/black
	name = "black beam"
	icon_state = "purplelaser"
	desc = "A beam of black light."
	damage_type = BLACK_DAMAGE

//Visual effects
/obj/effect/temp_visual/negativelook
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "antinoblium"
	duration = 6

/obj/effect/temp_visual/negativelook/spellbinder
	density = TRUE
	icon_state = "halon"
	duration = 20
