/mob/living/simple_animal/hostile/abnormality/pygmalion
	name = "Pygmalion"
	desc = "A tall statue of a humanoid abnormality in a pink dress holding a bouquet of light blue flowers."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "pygmalion"
	icon_living = "pygmalion_breach"
	portrait = "pygmalion"

	pixel_x = -8
	base_pixel_x = -8

	maxHealth = 3000
	health = 3000
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)

	can_breach = TRUE
	del_on_death = TRUE

	move_to_delay = 4
	threat_level = WAW_LEVEL
	start_qliphoth = 2

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 30, 25),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 40, 45),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 45, 45, 50),
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust

	ego_list = list(
		/datum/ego_datum/weapon/my_own_bride,
		/datum/ego_datum/armor/my_own_bride,
	)
	gift_type =  /datum/ego_gifts/bride
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "The King Pygmalion prayed earnestly to the Goddess Aphrodite, wishing for the marble statue he had made and fallen in love to come to life. <br>\
		She answered his prayer, bringing Galatea to life and united them in matrinomy. <br>\
		What is the real name of the abnormality before you?"
	observation_choices = list(
		"Galatea" = list(TRUE, "Perhaps they sculpted each other."),
		"Pygmalion" = list(TRUE, "Perhaps they sculpted each other."),
	)

	var/last_worker = null
	var/teleport_cooldown
	var/teleport_cooldown_time = 20 SECONDS
	var/laser_cooldown
	var/laser_cooldown_time = 23 SECONDS
	var/list/lasers = list()
	var/list/beams = list()
	var/list/hit_line = list()
	/// Amount of white damage per damage tick dealt to all living enemies
	var/laser_damage = 10
	var/max_lasers = 4
	/// Amount of damage ticks laser will do
	var/max_laser_repeats = 20
	var/firing = FALSE
	var/laser_spawn_delay = 1 SECONDS
	var/laser_rotation_time = 2 SECONDS

/mob/living/simple_animal/hostile/abnormality/pygmalion/Move()
	if(IsCombatMap())
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/pygmalion/Destroy()
	for(var/atom/A in lasers)
		QDEL_NULL(A)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	last_worker = null
	..()

/mob/living/simple_animal/hostile/abnormality/pygmalion/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/pygmalion/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	last_worker = user
	return ..()

/mob/living/simple_animal/hostile/abnormality/pygmalion/WorkChance(mob/living/carbon/human/user, chance, work_type)
	chance = ..()
	if(user == last_worker)
		chance += 10
	return chance

/mob/living/simple_animal/hostile/abnormality/pygmalion/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(user == last_worker && prob(70))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/pygmalion/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(70))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/pygmalion/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = icon_living
	if(breach_type != BREACH_MINING)//in ER you get a few seconds to smack it down
		TeleportAway()

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/TeleportAway()
	if(IsCombatMap())
		return
	var/list/potential_turfs = list()
	for(var/turf/T in GLOB.xeno_spawn)
		if(get_dist(src, T) < 7)
			continue
		potential_turfs += T
	var/turf/T = pick(potential_turfs)
	if(!istype(T))
		return FALSE
	playsound(src, 'sound/abnormalities/alriune/curtain_out.ogg', 50, TRUE, 12)
	animate(src, alpha = 0, time = 15)
	SLEEP_CHECK_DEATH(15)
	forceMove(T)
	animate(src, alpha = 255, time = 15)
	playsound(src, 'sound/abnormalities/alriune/curtain_in.ogg', 50, TRUE, 12)
	SetupLaser()

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/SetupLaser()
	firing = TRUE
	SLEEP_CHECK_DEATH(2 SECONDS)
	if(!lasers.len)
		HandleLasers(TRUE)
	else
		HandleLasers(FALSE)
	SLEEP_CHECK_DEATH(laser_rotation_time)
	FireLaser()

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/HandleLasers(spawning)
	var/new_angle = rand(0, 360)
	if(spawning == TRUE)
		for(var/i = 1 to max_lasers)
			var/mob/living/simple_animal/pygmalion_finger/F = new(get_turf(src))
			lasers += F
	var/i = 0
	for(var/mob/living/simple_animal/pygmalion_finger/L in lasers)
		i++
		L.icon_state = "bride_finger[i]"
		L.alpha = 255
		L.mouse_opacity = 1
		L.Move(get_ranged_target_turf(src, rand(0, 12), 1))//src, dir, distance
		lasers[L] = get_turf_in_angle(new_angle, get_turf(L), 64)
		playsound(get_turf(src), 'sound/abnormalities/pygmalion/Pyg_Finger.ogg', 50 + 5 * (i - max_lasers), FALSE)
		addtimer(CALLBACK(src, PROC_REF(PrepareLaser), L), 0.5 SECONDS)
		var/old_angle = new_angle
		for(var/attempt = 1 to 3) // Just so that we don't get ourselves absolutely the same angle twice in a row
			new_angle = rand(0, 360)
			if((new_angle > old_angle + 15) || (new_angle < old_angle - 15))
				break
		SLEEP_CHECK_DEATH(laser_spawn_delay)

// Rotate the laser and creates a warning beam
/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/PrepareLaser(obj/effect/greenmidnight_laser/L)
	if(stat == DEAD || QDELETED(L))
		return
	playsound(get_turf(src), 'sound/abnormalities/pygmalion/Pyg_BeamPrep.ogg', 15, TRUE)
	SLEEP_CHECK_DEATH(laser_rotation_time * 0.75)
	var/turf/T = get_turf(L)
	var/datum/beam/B = T.Beam(lasers[L], "magic_bullet")
	beams += B
	B.visuals.alpha = 0
	animate(B.visuals, alpha = 255, time = 3)

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/FireLaser()
	if(stat == DEAD)
		return
	for(var/datum/beam/B in beams)//elevate this y tiles
		B.visuals.icon_state = "light_beam" // WARNING, YOU ARE ABOUT TO DIE!!!
		var/matrix/M = matrix()
		M.Scale(9, 1)
		animate(B.visuals, transform = M, time = 15)
	playsound(get_turf(src), 'sound/abnormalities/alriune/damage.ogg', 75, FALSE, 14)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/pygmalion/Pyg_Warning.ogg', 75, zlevel = z)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/pygmalion/Pyg_Boom.ogg', 100, zlevel = z)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	hit_line = list()
	for(var/mob/living/simple_animal/pygmalion_finger/L in lasers)
		var/turf/T = get_turf(L)
		var/datum/beam/B = T.Beam(lasers[L], "bsa_beam")
		var/matrix/M = matrix()
		M.Scale(3, 1)
		B.visuals.transform = M
		beams += B
		hit_line |= getline(T, lasers[L])
	INVOKE_ASYNC(src, PROC_REF(LaserEffect))

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/LaserEffect()
	if(stat == DEAD)
		return
	for(var/i = 1 to max_laser_repeats)
		//There are 40 ticks in the laser phase. This following chunk of code basically fires a mini laser barrage on ticks 8, 16, 24 and 32. (4 barrages)
		var/list/already_hit = list()
		for(var/turf/T in hit_line)
			for(var/mob/living/L in range(1, T))
				if(L.status_flags & GODMODE)
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				if(faction_check_mob(L))
					continue
				already_hit += L
				L.apply_damage(laser_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
		SLEEP_CHECK_DEATH(0.25 SECONDS)
	StopLaser()

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/StopLaser()
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	laser_cooldown = world.time + laser_cooldown_time
	firing = FALSE
	SLEEP_CHECK_DEATH(5 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/alriune/curtain_out.ogg', 75, FALSE, 24)
	for(var/atom/A in lasers)
		A.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		animate(A, alpha = 0, time = 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(TeleportAway)),2 SECONDS)

//**FINGERS**//

/mob/living/simple_animal/pygmalion_finger
	name = "finger"
	desc = "A floating ceramic finger. There's a pink fluid seeping from the cracks."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bride_finger1"
	health = 200
	maxHealth = 200
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	gender = PLURAL
	density = FALSE
	layer = ABOVE_ALL_MOB_LAYER
	move_resist = MOVE_FORCE_OVERPOWERING
	alpha = 0
	pixel_y = 16
	base_pixel_y = 1
	is_flying_animal = TRUE
	del_on_death = TRUE
	AIStatus = AI_OFF
	var/mob/living/simple_animal/hostile/abnormality/pygmalion/master

/mob/living/simple_animal/pygmalion_finger/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 5)
	master = locate(/mob/living/simple_animal/hostile/abnormality/pygmalion) in GLOB.abnormality_mob_list

/mob/living/simple_animal/pygmalion_finger/Destroy()
	if(master)
		master.deal_damage(720)
		master.lasers -= src
	master = null
	..()
