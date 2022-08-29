GLOBAL_LIST_EMPTY(apostles)

/mob/living/simple_animal/hostile/abnormality/white_night
	name = "White night"
	desc = "The heavens' wrath. Say your prayers, heretic, the day has come."
	health = 15000
	maxHealth = 15000
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "white_night"
	icon_living = "white_night"
	health_doll_icon = "white_night"
	faction = list("apostle")
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("proclaims")
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = -2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.2)
	is_flying_animal = TRUE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	loot = list(/obj/item/ego_weapon/paradise)
	deathmessage = "evaporates in a moment, leaving heavenly light and feathers behind."
	deathsound = 'sound/abnormalities/whitenight/apostle_death.ogg'
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL + 1
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = list(0, 0, 30, 30, 40),
						ABNORMALITY_WORK_ATTACHMENT = list(30, 30, 35, 40, 45),
						ABNORMALITY_WORK_REPRESSION = list(30, 30, 35, 40, 45)
						)
	work_damage_amount = 14
	work_damage_type = PALE_DAMAGE

	light_system = MOVABLE_LIGHT
	light_color = COLOR_VERY_SOFT_YELLOW
	light_range = 7
	light_power = 3

	ego_list = list(
		/datum/ego_datum/armor/paradise
		)
	gift_type =  /datum/ego_gifts/paradise

	var/holy_revival_cooldown
	var/holy_revival_cooldown_base = 75 SECONDS
	var/holy_revival_damage = 80 // Pale damage, scales with distance
	var/holy_revival_range = 64
	/// List of mobs that have been hit by the revival field to avoid double effect
	var/list/been_hit = list()
	/// Currently spawned apostles by this mob
	var/list/apostles = list()

/mob/living/simple_animal/hostile/abnormality/white_night/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/white_night/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/white_night/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		if(holy_revival_cooldown < world.time)
			for(var/mob/living/simple_animal/hostile/apostle/scythe/guardian/G in apostles)
				if(G in view(10, src)) // Only teleport them if they are not in view.
					continue
				var/turf/T = get_step(src, pick(NORTH,SOUTH,WEST,EAST))
				G.forceMove(T)
			revive_humans()

/mob/living/simple_animal/hostile/abnormality/white_night/Destroy()
	for(var/mob/living/simple_animal/hostile/apostle/A in apostles)
		A.death()
		QDEL_IN(A, 1.5 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/abnormality/white_night/proc/revive_humans(range_override = null, faction_check = "apostle")
	if(holy_revival_cooldown > world.time)
		return
	if(range_override == null)
		range_override = holy_revival_range
	holy_revival_cooldown = (world.time + holy_revival_cooldown_base)
	been_hit = list()
	playsound(src, 'sound/abnormalities/whitenight/apostle_spell.ogg', 75, 1, range_override)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	for(var/i = 1 to range_override)
		turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/open/T in turf_list)
			var/obj/effect/temp_visual/cult/sparks/S = new(T)
			if(faction_check != "apostle")
				S.color = "#AAFFAA" // Indicating that it's a good thing
			for(var/mob/living/L in T)
				new /obj/effect/temp_visual/dir_setting/cult/phase(T, L.dir)
				addtimer(CALLBACK(src, .proc/revive_target, L, i, faction_check))
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/abnormality/white_night/proc/revive_target(mob/living/L, attack_range = 1, faction_check = "apostle")
	if(L in been_hit)
		return
	been_hit += L
	if(!(faction_check in L.faction))
		playsound(L.loc, 'sound/machines/clockcult/ark_damage.ogg', 50 - attack_range, TRUE, -1)
		// The farther you are from white night - the less damage it deals
		var/dealt_damage = max(5, holy_revival_damage - attack_range)
		L.apply_damage(dealt_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		if(ishuman(L) && dealt_damage > 25)
			L.emote("scream")
		to_chat(L, "<span class='userdanger'>The holy light... IT BURNS!!</span>")
	else
		if(istype(L, /mob/living/simple_animal/hostile/apostle) && L.stat == DEAD)
			L.revive(full_heal = TRUE, admin_revive = FALSE)
			L.grab_ghost(force = TRUE)
			to_chat(L, "<span class='notice'>The holy light compels you to live!</span>")
		else if(L.stat != DEAD)
			L.adjustBruteLoss(-(holy_revival_damage * 0.75) * (L.maxHealth/100))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.adjustSanityLoss((holy_revival_damage * 0.75) * (H.maxSanity/100)) // It actually heals, don't worry
			L.regenerate_limbs()
			L.regenerate_organs()
			to_chat(L, "<span class='notice'>The holy light heals you!</span>")

/mob/living/simple_animal/hostile/abnormality/white_night/proc/SpawnApostles()
	for(var/i = 1 to 11)
		var/apostle_type = /mob/living/simple_animal/hostile/apostle/scythe
		if(i in list(1,11))
			apostle_type = /mob/living/simple_animal/hostile/apostle/scythe/guardian
		if(i in list(4,5,6))
			apostle_type = /mob/living/simple_animal/hostile/apostle/staff
		if(i in list(7,8,9,10))
			apostle_type = /mob/living/simple_animal/hostile/apostle/spear
		apostles += new apostle_type(get_turf(src))
		var/list/possible_locs = GLOB.xeno_spawn.Copy()
		for(var/mob/living/simple_animal/hostile/apostle/A in apostles)
			if(istype(A, /mob/living/simple_animal/hostile/apostle/scythe/guardian))
				continue
			var/turf/T = pick(possible_locs)
			A.forceMove(T)
			if(length(possible_locs) > 1)
				possible_locs -= T

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/white_night/OnQliphothChange(mob/living/carbon/human/user)
	if(datum_reference.qliphoth_meter <= 0)
		return
	var/flashing_color = COLOR_ORANGE
	if(datum_reference.qliphoth_meter == 1)
		flashing_color = COLOR_SOFT_RED
	if(datum_reference.qliphoth_meter == 3)
		flashing_color = COLOR_GREEN
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color = flashing_color, flash_time = 25)
	sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg', (25 * (3 - datum_reference.qliphoth_meter)))
	return

/mob/living/simple_animal/hostile/abnormality/white_night/success_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(66))
		datum_reference.qliphoth_change(1)
		if(prob(66)) // Rare effect, mmmm
			revive_humans(48, "neutral") // Big heal
	return

/mob/living/simple_animal/hostile/abnormality/white_night/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/white_night/breach_effect(mob/living/carbon/human/user)
	holy_revival_cooldown = world.time + holy_revival_cooldown_base
	..()
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color = COLOR_RED, flash_time = 100)
	sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg')
	add_filter("apostle", 1, rays_filter(size = 64, color = "#FFFF00", offset = 6, density = 16, threshold = 0.05))
	if(LAZYLEN(GLOB.department_centers))
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)
	SpawnApostles()
	addtimer(CALLBACK(GLOBAL_PROC, .proc/sound_to_playing_players, 'sound/abnormalities/whitenight/rapture2.ogg', 50), 10 SECONDS)
	return

/* Apostles */

/mob/living/simple_animal/hostile/apostle
	name = "apostle"
	desc = "An apostle."
	health = 2000
	maxHealth = 2000
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/abnormalities/whitenight/scythe.ogg'
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "apostle_scythe"
	icon_living = "apostle_scythe"
	faction = list("apostle")
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("says")
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	melee_damage_lower = 35
	melee_damage_upper = 45
	obj_damage = 400
	ranged = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	speed = 4
	move_to_delay = 6
	pixel_x = -8
	base_pixel_x = -8
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	a_intent = INTENT_HARM
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE
	mob_size = MOB_SIZE_HUGE
	blood_volume = BLOOD_VOLUME_NORMAL
	var/can_act = TRUE

/mob/living/simple_animal/hostile/apostle/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/apostle/death(gibbed)
	invisibility = 30 // So that other mobs cannot attack them
	return ..()

/mob/living/simple_animal/hostile/apostle/revive(full_heal = FALSE, admin_revive = FALSE, excess_healing = 0)
	invisibility = 0 // Visible again
	can_act = TRUE // In case we died while performing special attack
	return ..()

/mob/living/simple_animal/hostile/apostle/gib(no_brain, no_organs, no_bodyparts)
	return FALSE // Cannot be gibbed

/mob/living/simple_animal/hostile/apostle/AttackingTarget()
	if(!can_act)
		return

	if(isliving(target))
		var/mob/living/L = target
		if(faction_check_mob(L))
			return
	. = ..()
	if(. && isliving(target))
		if(!client && ranged && ranged_cooldown <= world.time)
			OpenFire()

/mob/living/simple_animal/hostile/apostle/scythe
	name = "scythe apostle"
	desc = "A disformed human wielding a terrifying scythe."
	var/scythe_cooldown
	var/scythe_cooldown_time = 10 SECONDS
	var/scythe_range = 2
	var/scythe_damage = 250
	var/scythe_damage_type = RED_DAMAGE

/mob/living/simple_animal/hostile/apostle/scythe/OpenFire()
	if(!can_act)
		return

	if(client)
		ScytheAttack()
		return

	if(get_dist(src, target) <= 3 && scythe_cooldown <= world.time)
		ScytheAttack()

/mob/living/simple_animal/hostile/apostle/scythe/proc/ScytheAttack()
	if(scythe_cooldown > world.time)
		return
	scythe_cooldown = world.time + scythe_cooldown_time
	can_act = FALSE
	//playsound(get_turf(src), 'sound/abnormalities/whitenight/delay.ogg', 75, 0, 2)
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(scythe_damage, scythe_damage_type, null, L.run_armor_check(null, scythe_damage_type), spread_damage = TRUE)
	playsound(get_turf(src), 'sound/abnormalities/whitenight/scythe_spell.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(5)
	can_act = TRUE

/mob/living/simple_animal/hostile/apostle/scythe/guardian
	name = "guardian apostle"
	health = 3000
	maxHealth = 3000
	speed = 5
	move_to_delay = 7
	melee_damage_type = PALE_DAMAGE
	armortype = PALE_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	scythe_range = 3
	scythe_damage_type = PALE_DAMAGE

/mob/living/simple_animal/hostile/apostle/spear
	name = "spear apostle"
	desc = "A disformed human wielding a spear."
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/abnormalities/whitenight/spear.ogg'
	icon_state = "apostle_spear"
	icon_living = "apostle_spear"
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.5)
	var/spear_cooldown
	var/spear_cooldown_time = 10 SECONDS
	var/spear_max = 50
	var/spear_damage = 300
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/apostle/spear/OpenFire()
	if(client)
		SpearAttack(target)
		return

	if(spear_cooldown <= world.time)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(src, target)
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			SpearAttack(target)

/mob/living/simple_animal/hostile/apostle/spear/proc/SpearAttack(target)
	if(spear_cooldown > world.time)
		return
	can_act = FALSE
	var/dir_to_target = get_dir(src, target)
	var/turf/T = get_turf(src)
	for(var/i = 1 to spear_max)
		T = get_step(T, dir_to_target)
		if(T.density)
			if(i < 4) // Mob attempted to dash into a wall too close, stop it
				can_act = TRUE
				return
			break
		new /obj/effect/temp_visual/cult/sparks(T)
	spear_cooldown = world.time + spear_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/whitenight/spear_charge.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(22)
	been_hit = list()
	playsound(get_turf(src), 'sound/abnormalities/whitenight/spear_dash.ogg', 100, 0, 20)
	do_dash(dir_to_target, 0)

/mob/living/simple_animal/hostile/apostle/spear/proc/do_dash(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= spear_max)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		can_act = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("holy spear")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK (D, .obj/machinery/door/proc/open))
	if(stop_charge)
		can_act = TRUE
		return
	forceMove(T)
	for(var/turf/TF in view(1, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
		for(var/mob/living/L in TF)
			if(!faction_check_mob(L))
				if(L in been_hit)
					continue
				visible_message("<span class='boldwarning'>[src] runs through [L]!</span>")
				L.apply_damage(spear_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				new /obj/effect/temp_visual/cleave(get_turf(L))
				if(!(L in been_hit))
					been_hit += L
	addtimer(CALLBACK(src, .proc/do_dash, move_dir, (times_ran + 1)), 0.5) // SPEED

/mob/living/simple_animal/hostile/apostle/staff
	name = "staff apostle"
	desc = "A disformed human wielding a magic staff."
	icon_state = "apostle_staff"
	icon_living = "apostle_staff"
	attack_sound = 'sound/weapons/genhit1.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	minimum_distance = 4
	melee_damage_lower = 25
	melee_damage_upper = 35
	melee_damage_type = BLACK_DAMAGE // Okay, look, they aren't really meant to melee anyway
	armortype = BLACK_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	var/staff_cooldown
	var/staff_cooldown_time = 20 SECONDS
	var/staff_damage = 20
	var/hit_ticks = 60
	var/datum/looping_sound/apostle_beam/beamloop

/mob/living/simple_animal/hostile/apostle/staff/Initialize()
	. = ..()
	beamloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/apostle/staff/Destroy()
	QDEL_NULL(beamloop)
	..()

/mob/living/simple_animal/hostile/apostle/staff/death(gibbed)
	beamloop.stop()
	return ..()

/mob/living/simple_animal/hostile/apostle/staff/OpenFire()
	if(!can_act)
		return

	if(client)
		StaffAttack(target)
		return

	if(staff_cooldown <= world.time)
		StaffAttack(target)

/mob/living/simple_animal/hostile/apostle/staff/proc/StaffAttack(target)
	if(staff_cooldown > world.time)
		return
	staff_cooldown = world.time + staff_cooldown_time
	can_act = FALSE
	var/list/chosen_turfs = list()
	var/list/potential_dirs = GLOB.alldirs.Copy()
	potential_dirs -= get_dir(target, src)
	for(var/i = 1 to 3)
		if(!LAZYLEN(potential_dirs))
			break
		var/chosen_dir = pick(potential_dirs)
		potential_dirs -= chosen_dir
		var/turf/NT = get_turf(target)
		for(var/e = 1 to 4)
			var/turf/temp_turf = get_step(NT, chosen_dir)
			if(temp_turf.density)
				break
			NT = temp_turf
		chosen_turfs += NT
	if(!LAZYLEN(chosen_turfs))
		can_act = TRUE
		return FALSE
	for(var/turf/TT in chosen_turfs)
		addtimer(CALLBACK(src, .proc/HolyBeam, TT))
	playsound(get_turf(src), 'sound/abnormalities/whitenight/staff_prepare.ogg', 75, 0, 7)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	beamloop.start()
	SLEEP_CHECK_DEATH(hit_ticks * 2)
	beamloop.stop()
	can_act = TRUE

/mob/living/simple_animal/hostile/apostle/staff/proc/HolyBeam(turf/T)
	new /obj/effect/temp_visual/dir_setting/curse/grasp_portal/fading(T)
	var/turf/MT = get_turf(src)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	var/datum/beam/B = MT.Beam(T, "sm_arc_dbz_referance", time=hit_ticks*2)
	var/list/affected_turfs = getline(MT, T)
	for(var/i = 1 to hit_ticks)
		for(var/turf/AT in affected_turfs)
			for(var/mob/living/L in AT)
				if(faction_check_mob(L))
					continue
				L.apply_damage(staff_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.sanity_lost)
						H.gib() // lmao
		sleep(2)
	QDEL_NULL(B)
