/mob/living/simple_animal/hostile/megafauna/Erlking
	name = "Erlking"
	desc = "A strange homeless looking man full of intent to behead you."
	health = 10000
	maxHealth = 10000
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.8)
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'ModularTegustation/Tegusounds/Erlking/Erlkinghit.ogg'
	icon_state = "Erlking"
	icon_living = "Erlking"
	icon_dead = "Erlking"
	icon = 'ModularTegustation/Teguicons/WildHuntBoss.dmi'
	faction = list("hostile")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_range = 3
	movement_type = GROUND
	is_flying_animal = FALSE
	speak_emote = list("says")
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 75 // Assuming everyone has at least 0.5 red armor
	melee_damage_upper = 85
	stat_attack = HARD_CRIT
	rapid_melee = 2
	ranged = TRUE
	ranged_cooldown_time = 5
	speed = 2
	move_to_delay = 3
	pixel_x = -8
	base_pixel_x = -1
	blood_volume = BLOOD_VOLUME_NORMAL
	gps_name = "NTAF-V"
	del_on_death = FALSE
	death_message = "falls to the ground, decaying into glowing particles."
	death_sound = 'ModularTegustation/Tegusounds/claw/death.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	del_on_death = TRUE

	var/special_attacking = FALSE // Are you currently performing a special attack
	var/special_windup = 8 // How many deciseconds between showing a tell for a special attack and using it
	var/dullahan_speed = 1.75
	var/current_stage = 1 //changes behaviour slightly on phase 2
	var/stage_threshold = 5000 // enters stage 2 at or below this threshold
	var/slam_cooldown
	var/slam_cooldown_time = 20 SECONDS
	var/slam_damage = 250
	var/can_act = TRUE
	var/charging = FALSE
	var/dash_num = 10//the length of the dash, in tiles
	var/dash_cooldown = 0
	var/dash_cooldown_time = 4 SECONDS
	var/list/been_hit = list() // Don't get hit twice.
	var/throw_timer = 0
	var/throw_cooldown = 11 SECONDS
	var/throw_amount = 10 // How many blades to throw at once
	var/throw_cone = 25 // Total firing angle of all red's projectiles.
	var/throw_damage = 80 // Damage of each thrown blade
	var/nightmare_mode = FALSE
	var/pulse_cooldown
	var/pulse_cooldown_time = 200 SECONDS
	var/spawn_time
	var/spawn_cooldown
	var/spawn_cooldown_time = 60 SECONDS
	var/spawn_time_cooldown
	var/list/spawned_mobs = list()

/mob/living/simple_animal/hostile/megafauna/Erlking/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/Catherine = 1
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 1, TRUE, TRUE)



/mob/living/simple_animal/hostile/megafauna/Erlking/OpenFire()
	if(!can_act)
		return FALSE

	if(dash_cooldown <= world.time)
		var/chance_to_dash = 50
		if(prob(chance_to_dash))
			Erlking_dash(target)

	if((slam_cooldown <= world.time))
		CoffinSlam(target)
		return

	if(((throw_timer <= world.time)))
		switch(current_stage)
			if(2)
				if(isliving(target))
					return BladeThrow(target)
		return
	return

// Slams the area with the sleigh, doing heavy damage
/mob/living/simple_animal/hostile/megafauna/Erlking/proc/CoffinSlam(atom/target)
	if(!can_act || slam_cooldown > world.time)
		return

	can_act = FALSE
	slam_cooldown = world.time + slam_cooldown_time

	var/turf/T = get_turf(target)
	playsound(src, 'sound/abnormalities/apocalypse/swing.ogg', 75, TRUE)
	say("Remain buried in your regrets!")
	playsound(get_turf(src), 'ModularTegustation/Tegusounds/Erlking/ErlkingCoffin.ogg', 75, 0, 3)
	var/obj/effect/coffin/S = new (T) //Maybe later.
	S.alpha = 0
	S.pixel_y = 128
	animate(S, alpha = 255, pixel_y = 0, time = 3)
	var/datum/beam/B = src.Beam(S, "chain", time = 10)
	animate(B.visuals, alpha = 0, time = 10)

	SLEEP_CHECK_DEATH(5)

	var/list/been_hit = list()
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, TRUE, 7)
	for(var/turf/TF in range(3, T))
		if(TF.density)
			continue
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
	for(var/turf/TF in range(9, T))
		if(TF.density)
			continue
		new /obj/effect/thunderbolt(TF)
		been_hit = HurtInTurf(TF, been_hit, slam_damage, PALE_DAMAGE, null, TRUE, FALSE, TRUE, TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()

	SLEEP_CHECK_DEATH(3)

	can_act = TRUE


/mob/living/simple_animal/hostile/megafauna/Erlking/proc/Erlking_dash(target)
	if(charging || dash_cooldown > world.time)
		return
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	addtimer(CALLBACK(src, PROC_REF(do_dash), dir_to_target, 0), 0.5 SECONDS)//how long it takes for the dash to initiate. Set it back to 1 second when thunderbird gets directional sprites
	playsound(src, 'ModularTegustation/Tegusounds/Erlking/Erlkinghit.ogg', 100, 1)

/mob/living/simple_animal/hostile/megafauna/Erlking/proc/do_dash(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
		break
	for(var/obj/machinery/door/D in T.contents)
		if(!D.CanAStarPass(null))
			stop_charge = TRUE
			break
		if(D.density)
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open), 2)
	if(stop_charge)
		playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 75, 1)
		charging = FALSE
		return
	forceMove(T)
	playsound(src,"sound/abnormalities/thunderbird/tbird_peck.ogg", rand(50, 70), 1)
	var/list/turfs_to_hit = range(1, T)
	for(var/turf/TF in turfs_to_hit)//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in turfs_to_hit)//damage applied to targets in range
		if(!faction_check_mob(L))
			if(L in been_hit)
				continue
			visible_message(span_boldwarning("[src] runs through [L]!"))
			to_chat(L, span_userdanger("[src] rushes past you, slashing through you on the way!"))
			playsound(L, attack_sound, 75, 1)
			var/turf/LT = get_turf(L)
			new /obj/effect/temp_visual/kinetic_blast(LT)
			L.deal_damage(400, BLACK_DAMAGE)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.electrocute_act(1, src, flags = SHOCK_NOSTUN)
			if(!(L in been_hit))
				been_hit += L
	for(var/obj/vehicle/sealed/mecha/V in turfs_to_hit)
		if(V in been_hit)
			continue
		visible_message(span_boldwarning("[src] runs through [V]!"))
		to_chat(V.occupants, span_userdanger("[src] rushes past you, slashing through you on the way!"))
		playsound(V, attack_sound, 75, 1)
		V.take_damage(800, BLACK_DAMAGE, attack_dir = get_dir(V, src))
		been_hit += V
	addtimer(CALLBACK(src, PROC_REF(do_dash), move_dir, (times_ran + 1)), 1)

/mob/living/simple_animal/hostile/megafauna/Erlking/proc/SpecialReset()
	pixel_x = initial(pixel_x)
	base_pixel_x = initial(base_pixel_x)
	return


/mob/living/simple_animal/hostile/megafauna/Erlking/proc/BladeThrow(atom/target) // Dullahan afterimages spam
	special_attacking = TRUE
	addtimer(CALLBACK(src, PROC_REF(SpecialReset)), 5)
	throw_timer = world.time + throw_cooldown
	say("Tear them to shreds, Dullahan!")
	addtimer(CALLBACK(src, PROC_REF(GetThrown), target), special_windup)
	return

/mob/living/simple_animal/hostile/megafauna/Erlking/proc/GetThrown(atom/target)
	playsound(src, 'ModularTegustation/Tegusounds/Erlking/ErlkingDullahan.ogg', 50, FALSE, 4)
	var/turf/startloc = get_turf(src)
	var/angle_to_target = Get_Angle(src, target)
	var/projectile_angle_difference = (throw_cone / (throw_amount - 1))
	for(var/i = 0 to throw_amount - 1) // Create throw_amount projectiles evenly spaced across an arc of throw_cone degrees centered aiming at enemy, and fire them.
		var/obj/projectile/Erlking/P = new(get_turf(src))
		P.nondirectional_sprite = FALSE
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.original = target
		P.preparePixelProjectile(target, src)
		P.damage = throw_damage
		P.fire(angle_to_target - (throw_cone / 2) + projectile_angle_difference * i)


/obj/effect/thunderbolt
	name = "thunder bolt"
	desc = "LOOK OUT!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "tbird_bolt"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/lightning_damage = 500
	layer = POINT_LAYER	//Sprite should always be visible
	var/mob/living/simple_animal/hostile/megafauna/Erlking/Wildhunt

/obj/effect/thunderbolt/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(exploding)), 3 SECONDS)


//Smaller Scorched Girl bomb
/obj/effect/thunderbolt/proc/exploding()
	playsound(get_turf(src), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 20, 0, 8)
	var/list/turfs_to_check = view(1, src)
	for(var/mob/living/carbon/human/H in turfs_to_check)
		H.deal_damage(boom_damage, BLACK_DAMAGE)
		H.electrocute_act(1, src, flags = SHOCK_NOSTUN)
		if(H.health < 0)
			Convert(H)
	for(var/obj/vehicle/V in turfs_to_check)
		V.take_damage(boom_damage, BLACK_DAMAGE)
	new /obj/effect/temp_visual/tbirdlightning(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(0, get_turf(src))	//Smoke shouldn't really obstruct your vision
	S.start()
	qdel(src)

/mob/living/simple_animal/hostile/megafauna/Erlking/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if((health <= stage_threshold) && (current_stage == 1))
		StageTransition()

/mob/living/simple_animal/hostile/megafauna/Erlking/proc/StageTransition()
	icon = 'ModularTegustation/Teguicons/WildhuntDullahan.dmi'
	icon_living = "ErlkingDullahan"
	icon_state = "ErlkingDullahan"
	current_stage = 2
	//Speed changed from 3 to 1
	ChangeMoveToDelayBy(-dullahan_speed)
	say("Ride Forth, Dullahan!")
	playsound(get_turf(src), 'ModularTegustation/Tegusounds/Erlking/DullahanMount.ogg', 75, 0, 3)

/datum/weather/thunderstorm //Spring weather, might want to add thunder strikes or make it a bit more dangerous overall.
	name = "thunderstorm"
	immunity_type = "rain"
	desc = "Extreme thunderstorms "
	telegraph_message = span_warning("It has begun to rain.")
	telegraph_duration = 300
	telegraph_overlay = "light_rain"
	weather_message = span_userdanger("<i>The rain starts coming down hard!</i>")
	weather_overlay = "rain_storm"
	weather_duration_lower = 5000
	weather_duration_upper = 6000
	perpetual = TRUE //should make it last forever
	end_duration = 100
	end_message = span_boldannounce("The rain starts to let up.")
	end_overlay = "light_rain"
	area_type = /area
	target_trait = ZTRAIT_STATION


/datum/weather/thunderstorm/weather_act(mob/living/carbon/human/L)
	if(!ishuman(L))
		return
	if(prob(1))
		var/turf/open/OT = get_turf(L)
		if(isopenturf(OT))
			OT.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)
	if(prob(1))
		new /obj/effect/thunderbolt/seasons(get_turf(L)) //Thunder!

/mob/living/simple_animal/hostile/megafauna/Erlking/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown > world.time))
		return
	pulse_cooldown = world.time + pulse_cooldown_time



/mob/living/simple_animal/hostile/megafauna/Erlking/proc/StartWeather()
	SSweather.run_weather(/datum/weather/thunderstorm)

//Needs more mobs, please add Distorted Hindley but nerfed here if he ever gets made, probably gonna be made by me in future.



/mob/living/simple_animal/hostile/Catherine
	name = "Every Catherine"
	desc = "A ghostly woman with tears in her eyes."
	icon = 'ModularTegustation/Teguicons/WildHuntBoss.dmi'
	icon_state = "Catherine"
	icon_living = "Catherine"
	is_flying_animal = TRUE
	density = TRUE
	a_intent = INTENT_HARM
	health = 99999
	maxHealth = 99999
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	melee_damage_lower = 0
	melee_damage_upper = 0
	pixel_x = -10
	faction = list("hostile")
	rapid_melee = 3
	melee_damage_type = RED_DAMAGE
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	retreat_distance = 2
	minimum_distance = 3

	var/list/hands = list()
	var/holy_revival_cooldown
	var/holy_revival_cooldown_base = 75 SECONDS
	var/holy_revival_damage = 80 // Pale damage, scales with distance
	var/holy_revival_range = 80
	/// List of mobs that have been hit by the revival field to avoid double effect
	var/list/been_hit = list()
	var/datum/reusable_visual_pool/RVP = new(1420)
	var/spawn_time
	var/spawn_time_cooldown = 28.5 SECONDS
	var/list/spawned_mobs = list()


/mob/living/simple_animal/hostile/Catherine/proc/SpawnHands()
	for(var/i = 1 to 2)
		/mob/living/simple_animal/hostile/CatherineHandRight
		for(var/mob/living/simple_animal/hostile/CatherineHandRight/A in hands)
			var/list/possible_locs = GLOB.xeno_spawn.Copy()
			var/turf/T = pick(possible_locs)
			A.forceMove(T)
			if(length(possible_locs) > 1)
				possible_locs -= T


		for(var/mob/living/simple_animal/hostile/CatherineHand/A in hands)
			var/list/possible_locs = GLOB.xeno_spawn.Copy()
			var/turf/T = pick(possible_locs)
			A.forceMove(T)
			if(length(possible_locs) > 1)
				possible_locs -= T

/mob/living/simple_animal/hostile/Catherine/Destroy()
	for(var/mob/living/simple_animal/hostile/CatherineHand/A in hands)
		A.death()
		QDEL_IN(A, 1.5 SECONDS)
	hands = null
	QDEL_NULL(particles)
	particles = null
	QDEL_NULL(RVP)
	return ..()

	for(var/mob/living/simple_animal/hostile/CatherineHandRight/A in hands)
		A.death()
		QDEL_IN(A, 1.5 SECONDS)
	hands = null
	QDEL_NULL(particles)
	particles = null
	QDEL_NULL(RVP)
	return ..()

/mob/living/simple_animal/hostile/Catherine/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/CatherineHand = 2
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 2, TRUE, TRUE)

/mob/living/simple_animal/hostile/Catherine/proc/revive_humans(range_override = null, faction_check = "hostile")
	if(holy_revival_cooldown > world.time)
		return
	if(range_override == null)
		range_override = holy_revival_range
	holy_revival_cooldown = (world.time + holy_revival_cooldown_base)
	been_hit = list()
	playsound(src, 'ModularTegustation/Tegusounds/Erlking/CathyScreaming.ogg', 50, range_override)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	for(var/i = 1 to range_override)
		turf_list = (target_c.y - i > 0 			? getline(locate(max(target_c.x - i, 1), target_c.y - i, target_c.z), locate(min(target_c.x + i - 1, world.maxx), target_c.y - i, target_c.z)) : list()) +\
					(target_c.x + i <= world.maxx ? getline(locate(target_c.x + i, max(target_c.y - i, 1), target_c.z), locate(target_c.x + i, min(target_c.y + i - 1, world.maxy), target_c.z)) : list()) +\
					(target_c.y + i <= world.maxy ? getline(locate(min(target_c.x + i, world.maxx), target_c.y + i, target_c.z), locate(max(target_c.x - i + 1, 1), target_c.y + i, target_c.z)) : list()) +\
					(target_c.x - i > 0 			? getline(locate(target_c.x - i, min(target_c.y + i, world.maxy), target_c.z), locate(target_c.x - i, max(target_c.y - i + 1, 1), target_c.z)) : list())
		for(var/turf/open/T in turf_list)
			CHECK_TICK
			if(faction_check != "hostile")
				RVP.NewSmoke(T, 10, "#AAFFAA") // Indicating that it's a good thing
			else
				RVP.NewSmoke(T, 10)
			for(var/mob/living/L in T)
				RVP.NewCultIn(T, L.dir)
				INVOKE_ASYNC(src, PROC_REF(revive_target), L, i, faction_check)
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/Catherine/proc/revive_target(mob/living/L, attack_range = 1, faction_check = "neutral")
	if(L in been_hit)
		return
	been_hit += L
	if(!(faction_check in L.faction))
		playsound(L.loc, 'sound/machines/clockcult/ark_damage.ogg', 50 - attack_range, TRUE, -1)
		// The farther you are from white night - the less damage it deals
		var/dealt_damage = max(5, holy_revival_damage - attack_range)
		L.deal_damage(dealt_damage, WHITE_DAMAGE)
		if(ishuman(L) && dealt_damage > 25)
			L.emote("scream")
		to_chat(L, span_userdanger("The scream is overwhelming!!"))
	else
		if(istype(L, /mob/living/simple_animal/hostile/CatherineHand) && L.stat == DEAD)
			L.revive(full_heal = TRUE, admin_revive = FALSE)
			L.grab_ghost(force = TRUE)
			to_chat(L, span_notice("Catherine compels you to live on!"))
		else if(L.stat != DEAD)
			L.adjustBruteLoss(-(holy_revival_damage * 0.05) * (L.maxHealth/100))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.adjustSanityLoss(-(holy_revival_damage * 0.45) * (H.maxSanity/100))
			L.regenerate_limbs()
			L.regenerate_organs()
			to_chat(L, span_notice("Catherines cries urge you to go on!"))

/mob/living/simple_animal/hostile/Catherine/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		if(holy_revival_cooldown < world.time)
			for(var/mob/living/simple_animal/hostile/CatherineHand/A in hands)
				if(A in ohearers(10, src)) // Only teleport them if they are not in view.
					continue
				var/turf/T = get_step(src, pick(NORTH,SOUTH,WEST,EAST))
				A.forceMove(T)
			revive_humans()

	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	update_icon()
	if(length(spawned_mobs) >= 2)
		return
	if((spawn_time > world.time))
		return
	spawn_time = world.time + spawn_time_cooldown
	visible_message(span_danger("\The [src] manifests ghostly hands!"))
	var/spawnchance = pick(1,2)
	for(var/i = 1 to spawnchance)
		var/turf/T = get_step(get_turf(src), pick(0, EAST))
		var/picked_mob = pick(/mob/living/simple_animal/hostile/CatherineHand, /mob/living/simple_animal/hostile/CatherineHandRight)
		var/mob/living/simple_animal/hostile/ordeal/nb = new picked_mob(T)
		spawned_mobs += nb

/mob/living/simple_animal/hostile/CatherineHand
	name = "Every Catherines Hand"
	desc = "A large ghostly hand."
	icon = 'ModularTegustation/Teguicons/WildHuntBoss.dmi'
	icon_state = "CathyHand"
	icon_living = "CathyHand"
	is_flying_animal = TRUE
	density = TRUE
	a_intent = INTENT_HARM
	health = 3000
	maxHealth = 3000
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	melee_damage_lower = 10
	melee_damage_upper = 15
	rapid_melee = 6
	pixel_x = -10
	faction = list("hostile")
	rapid_melee = 3
	melee_damage_type = WHITE_DAMAGE
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	del_on_death = TRUE


/mob/living/simple_animal/hostile/CatherineHandRight
	name = "Every Catherines Hand"
	desc = "A large ghostly hand."
	icon = 'ModularTegustation/Teguicons/WildHuntBoss.dmi'
	icon_state = "CathyHand2"
	icon_living = "CathyHand2"
	is_flying_animal = TRUE
	density = TRUE
	a_intent = INTENT_HARM
	health = 3000
	maxHealth = 3000
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	melee_damage_lower = 35
	melee_damage_upper = 50
	rapid_melee = 1
	pixel_x = -10
	faction = list("hostile")
	rapid_melee = 3
	melee_damage_type = WHITE_DAMAGE
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	del_on_death = TRUE

/mob/living/simple_animal/hostile/CatherineHandRight/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/knockback, 3, FALSE, FALSE)





//Use this to scare the fuck out of people, unaccessible outside admins
/mob/living/simple_animal/hostile/megafauna/Erlking/proc/Announce()
	send_to_playing_players(span_narsiesmall("Proelium Fatale."))
	SSweather.run_weather(/datum/weather/thunderstorm)
	sound_to_playing_players('ModularTegustation/Tegusounds/Erlking/ErlkingBoss.ogg', 25)
	var/mob/living/simple_animal/hostile/Catherine/T = new(get_turf(src))
	say("Where are you... Come to my embrace, Catherine!")
	SLEEP_CHECK_DEATH(4 SECONDS)
	T.say("Heathcliff!")
	SLEEP_CHECK_DEATH(3 SECONDS)
	say("Catherine! Where are... I can hear your voice. Oh, please...")

