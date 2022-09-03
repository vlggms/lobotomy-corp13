/mob/living/simple_animal/hostile/megafauna/apocalypse_bird
	name = "Apocalypse bird"
	desc = "A terrifying giant beast that lives in the black forest. It's constantly looking for a monster \
	that terrorizes the forest, without realizing that it is looking for itself."
	health = 600000
	maxHealth = 600000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	icon_state = "apocalypse"
	icon_living = "apocalypse"
	//icon_dead = "apocalypse_dead"
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	faction = list("Apocalypse", "hostile")
	light_color = COLOR_RED
	light_range = 24
	light_power = 12 // Spooky
	movement_type = GROUND
	speak_emote = list("says")
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 75 // Assuming everyone has at least 0.5 red armor
	melee_damage_upper = 85
	pixel_x = -96
	base_pixel_x = -96
	blood_volume = BLOOD_VOLUME_NORMAL
	del_on_death = TRUE
	deathmessage = "finally stops moving, falling to the ground."
	deathsound = 'sound/abnormalities/apocalypse/dead.ogg'

	var/list/eggs = list()
	var/list/egg_types = list(
						/mob/living/simple_animal/apocalypse_egg/beak,
						/mob/living/simple_animal/apocalypse_egg/arm,
						/mob/living/simple_animal/apocalypse_egg/eyes,
						)
	var/list/birds = list()
	/// If TRUE - will prevent abilities from activating
	var/attacking = FALSE
	var/slam_cooldown
	var/slam_cooldown_time = 7 SECONDS
	/// Amount of black damage done on the slam attack.
	var/slam_damage = 120
	/// List of locations we'll go through first when teleporting
	var/list/teleport_priority = list()
	var/teleport_cooldown
	var/teleport_cooldown_time = 15 SECONDS
	/// Amount of pale damage done on the judgement attack.
	var/judge_damage = 35
	var/judge_cooldown
	var/judge_cooldown_time = 25 SECONDS
	/// How many projectiles are created on the light-fire attack.
	var/light_amount = 36
	var/light_cooldown
	var/light_cooldown_time = 15 SECONDS

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/Initialize()
	. = ..()
	var/list/potential_locs = shuffle(GLOB.department_centers)
	for(var/E in egg_types)
		if(!ispath(E, /mob/living/simple_animal/apocalypse_egg))
			continue
		var/turf/T = pick(potential_locs)
		var/mob/living/simple_animal/apocalypse_egg/EGG = new E(T)
		EGG.bird = src
		eggs += EGG
		potential_locs -= T
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT)

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/death(gibbed)
	for(var/atom/e in eggs)
		QDEL_NULL(e)
	for(var/mob/m in birds)
		QDEL_NULL(m)
	var/blurb_text = "Three birds, now as one, looked around to find the monster but couldn't find it.\
	There were no creatures, no sun and moon, and no monsters. All that is left is just a bird, and the black forest."
	addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 10 SECONDS, blurb_text, 25), 5 SECONDS)
	for(var/mob/living/carbon/human/M in GLOB.player_list)
		if(M.stat != DEAD && M.client)
			M.Apply_Gift(new /datum/ego_gifts/twilight)
	..()

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/ListTargets()
	return list() // We don't attack anyone like that

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/Move()
	return FALSE

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/Life()
	. = ..()
	if(.)
		if((slam_cooldown <= world.time) && prob(75))
			Slam()
		else if((judge_cooldown <= world.time) && prob(50))
			Judge()
		else if((light_cooldown <= world.time) && prob(50))
			LightFire()
		else if((teleport_cooldown <= world.time) && prob(50))
			Teleport()

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/proc/EggDeath(mob/living/egg)
	adjustBruteLoss(maxHealth*0.35)
	return TRUE

/* Attacks */

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/proc/Slam()
	if(attacking || slam_cooldown > world.time)
		return
	slam_cooldown = world.time + slam_cooldown_time
	attacking = TRUE
	playsound(src, 'sound/abnormalities/apocalypse/pre_attack.ogg', 125, FALSE, 4)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(src, 'sound/abnormalities/apocalypse/swing.ogg', 125, FALSE, 6)
	flick("apocalypse_slam", src)
	SLEEP_CHECK_DEATH(4)
	playsound(src, 'sound/abnormalities/apocalypse/slam.ogg', 100, FALSE, 12)
	visible_message("<span class='danger'>[src] slams at the floor with its talons!</span>")
	// Shake effect
	for(var/mob/living/M in livinginrange(20, get_turf(src)))
		shake_camera(M, 2, 3)
	// Actual stuff
	for(var/turf/open/T in view(8, src))
		new /obj/effect/temp_visual/small_smoke(T)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage(slam_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		if(L.health < 0)
			L.gib()
	SLEEP_CHECK_DEATH(3 SECONDS)
	attacking = FALSE

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/proc/Teleport()
	if(attacking || teleport_cooldown > world.time)
		return
	teleport_cooldown = world.time + teleport_cooldown_time
	attacking = TRUE
	var/turf/T
	if(LAZYLEN(teleport_priority))
		T = pick(teleport_priority)
		teleport_priority -= T
	else
		T = pick(GLOB.department_centers)
	if(!istype(T))
		return
	playsound(src, 'sound/abnormalities/apocalypse/teleport.ogg', 75, FALSE)
	playsound(T, 'sound/abnormalities/apocalypse/teleport.ogg', 75, FALSE)
	animate(src, alpha = 0, time = 15)
	SLEEP_CHECK_DEATH(1.8 SECONDS)
	animate(src, alpha = 255, time = 5)
	visible_message("<span class='danger'>[src] suddenly disappears!</span>")
	forceMove(T)
	visible_message("<span class='danger'>[src] suddenly appears in front of you!</span>")
	SLEEP_CHECK_DEATH(3 SECONDS)
	attacking = FALSE

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/proc/Judge()
	if(attacking || judge_cooldown > world.time)
		return
	judge_cooldown = world.time + judge_cooldown_time
	attacking = TRUE
	sound_to_playing_players_on_level('sound/abnormalities/apocalypse/judge.ogg', 75, zlevel = z)
	icon_state = "apocalypse_judge"
	SLEEP_CHECK_DEATH(5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/judgementbird/ability.ogg', 75, zlevel = z)
	for(var/mob/living/L in GLOB.mob_living_list)
		var/check_z = L.z
		if(isatom(L.loc))
			check_z = L.loc.z
		if(check_z != z)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/judgement(get_turf(L))
		L.apply_damage(judge_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	SLEEP_CHECK_DEATH(1 SECONDS)
	icon_state = icon_living
	SLEEP_CHECK_DEATH(2 SECONDS)
	attacking = FALSE

/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/proc/LightFire()
	if(attacking || light_cooldown > world.time)
		return
	light_cooldown = world.time + light_cooldown_time
	attacking = TRUE
	playsound(src, 'sound/abnormalities/apocalypse/prepare.ogg', 75, FALSE, 7)
	icon_state = "apocalypse_eyes"

	var/list/candidates = list()
	for(var/mob/living/L in range(14, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		candidates += L

	for(var/i = 1 to light_amount)
		var/atom/PT = src // Shoot it somewhere, idk
		if(LAZYLEN(candidates))
			PT = pick(candidates)
		var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
		if(T.density)
			i -= 1
			continue
		var/obj/projectile/apocalypse/P = new(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = PT.y - T.y
		P.xo = PT.x - T.x
		P.original = PT
		P.preparePixelProjectile(PT, T)
		addtimer(CALLBACK (P, .obj/projectile/proc/fire), 6.5 SECONDS)

	SLEEP_CHECK_DEATH(6.5 SECONDS)
	playsound(src, 'sound/abnormalities/apocalypse/fire.ogg', 75, FALSE, 12)
	SLEEP_CHECK_DEATH(1 SECONDS)
	icon_state = icon_living
	SLEEP_CHECK_DEATH(3 SECONDS)
	attacking = FALSE

/* Structures */
// I really love making "mob-structures", because I'm special
//													- Egor
/mob/living/simple_animal/apocalypse_egg
	name = "Egg"
	desc = "A mysterious entity..."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	pixel_x = -8
	base_pixel_x = -8
	faction = list("Apocalypse")
	maxHealth = 15000
	health = 15000
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	mob_size = MOB_SIZE_HUGE
	/// What icon_state it is using when below 50% health
	var/icon_damaged
	/// Reference to the bird itself
	var/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/bird
	/// Text shown to everyone on death
	var/blurb_text = "Guh?"

/mob/living/simple_animal/apocalypse_egg/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/apocalypse_egg/Move()
	return FALSE

/mob/living/simple_animal/apocalypse_egg/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if(istype(P, /obj/projectile/apocalypse))
		return BULLET_ACT_FORCE_PIERCE
	return ..()

/mob/living/simple_animal/apocalypse_egg/death(gibbed)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 5 SECONDS, blurb_text, 25))
	for(var/mob/M in GLOB.player_list)
		if(M.z == z && M.client)
			flash_color(M, flash_color = "#CCBBCC", flash_time = 50)
	if(istype(bird))
		bird.EggDeath(src)
	..()

/mob/living/simple_animal/apocalypse_egg/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	..()
	if(stat != DEAD)
		if(prob(3) && bird)
			bird.teleport_priority |= get_turf(src)
		if(health < maxHealth*0.5)
			icon_state = icon_damaged
		else // In case it healed up
			icon_state = icon_living

/mob/living/simple_animal/apocalypse_egg/beak
	name = "Small Beak"
	icon_state = "egg_beak"
	icon_living = "egg_beak"
	icon_damaged = "egg_beak_damaged"
	icon_dead = "egg_beak_dead"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = -2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5)
	blurb_text = "And Little Bird's mouth that devours everything has been shut."

/mob/living/simple_animal/apocalypse_egg/arm
	name = "Long Arm"
	icon_state = "egg_arm"
	icon_living = "egg_arm"
	icon_damaged = "egg_arm_damaged"
	icon_dead = "egg_arm_dead"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = -2)
	blurb_text = "A head that looked up to the cosmos has been lowered."

/mob/living/simple_animal/apocalypse_egg/arm/death(gibbed)
	if(istype(bird))
		bird.judge_cooldown = INFINITY
	..()

/mob/living/simple_animal/apocalypse_egg/eyes
	name = "Big Eyes"
	icon_state = "egg_eyes"
	icon_living = "egg_eyes"
	icon_damaged = "egg_eyes_damaged"
	icon_dead = "egg_eyes_dead"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = -2, PALE_DAMAGE = 0.5)
	blurb_text = "Far-sighted eyes of Big Bird have been blinded."

/mob/living/simple_animal/apocalypse_egg/eyes/death(gibbed)
	if(istype(bird))
		bird.light_cooldown = INFINITY
	..()

// Portal

/mob/living/simple_animal/forest_portal
	name = "Entrance to the Black Forest"
	desc = "A portal leading to a dark place, far worse than the one you're in right now..."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	pixel_x = -8
	base_pixel_x = -8
	layer = LARGE_MOB_LAYER
	faction = list("Apocalypse")
	maxHealth = 30000
	health = 30000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.3)
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	mob_size = MOB_SIZE_HUGE
	icon_state = "forest_portal"
	icon_living = "forest_portal"
	del_on_death = TRUE
	/// List of birds that entered it. We don't delete/kill them for the sake of abnormality respawn mechanics.
	var/list/stored_birds = list()

/mob/living/simple_animal/forest_portal/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/forest_portal/Move()
	return FALSE

/mob/living/simple_animal/forest_portal/Initialize()
	. = ..()
	for(var/mob/M in GLOB.player_list)
		if(M.z == z && M.client)
			flash_color(M, flash_color = "#CCBBBB", flash_time = 50)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 5 SECONDS, "A long time ago, in a warm and dense forest lived three happy birds.", 25))

/mob/living/simple_animal/forest_portal/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return ..()

	var/mob/living/L = AM
	var/blurb_text
	if(istype(L, /mob/living/simple_animal/hostile/abnormality/punishing_bird))
		blurb_text = "Little bird decided to punish bad creatures with his beak."
	else if(istype(L, /mob/living/simple_animal/hostile/abnormality/big_bird))
		blurb_text = "Big bird, with his many eyes, watched over the forest to seek trespassers."
	else if(istype(L, /mob/living/simple_animal/hostile/abnormality/judgement_bird))
		blurb_text = "Long bird weighed the sins of creatures that enter the forest to keep peace."
	else
		return ..()
	L.forceMove(src)
	L.status_flags |= GODMODE
	stored_birds += L
	update_icon()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 5 SECONDS, blurb_text, 25))
	for(var/mob/M in GLOB.player_list)
		if(M.z == z && M.client)
			flash_color(M, flash_color = "#CCBBBB", flash_time = 50)
	SLEEP_CHECK_DEATH(5 SECONDS)
	if(stored_birds.len >= 3)
		var/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/AB = new(get_turf(src))
		for(var/mob/living/B in stored_birds)
			B.forceMove(AB)
			AB.birds += B
		var/final_text = "In chaotic cries, somebody shouted: \"It's the monster! Big terrible monster lives in the dark, black forest!\""
		addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 10 SECONDS, final_text, 50))
		sound_to_playing_players_on_level('sound/abnormalities/apocalypse/appear.ogg', 100, zlevel = z)
		for(var/mob/M in GLOB.player_list)
			if(M.z == z && M.client)
				flash_color(M, flash_color = "#FF0000", flash_time = 250)
		qdel(src)
	return

/mob/living/simple_animal/forest_portal/update_overlays()
	. = ..()
	var/bird_len = stored_birds.len
	if(bird_len <= 0)
		cut_overlays()
		return

	var/mutable_appearance/bird_overlay = mutable_appearance(icon, "forest_portal1")
	switch(bird_len)
		if(1)
			bird_overlay.icon_state = "forest_portal1"
		if(2, 3)
			bird_overlay.icon_state = "forest_portal2"

	. += bird_overlay
