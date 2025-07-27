/mob/living/simple_animal/hostile/megafauna/chaos_marine
	name = "chaos marine"
	desc = "Forever a servant of the dark gods, a chaos marine is always in state of eternal battle."
	health = 3500
	maxHealth = 3500
	icon_state = "chaos_marine"
	icon_living = "chaos_marine"
	icon = 'ModularTegustation/Teguicons/megafauna.dmi'
	faction = list("chaos")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_color = "#FFFFFF"
	movement_type = GROUND
	speak_emote = list("roars")
	speed = 4
	light_range = 6
	projectiletype = /obj/projectile/bullet/chaos_bomb
	projectilesound = 'sound/weapons/gun/l6/shot.ogg'
	ranged = TRUE
	ranged_cooldown_time = 20
	rapid_melee = 2
	vision_range = 10
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5)
	loot = list(/obj/item/nullrod/scythe/talking/chainsword/chaos, /obj/item/clothing/suit/space/hardsuit/ert/paranormal/berserker/chaos)
	crusher_loot = list(/obj/item/nullrod/scythe/talking/chainsword/chaos, /obj/item/clothing/suit/space/hardsuit/ert/paranormal/berserker/chaos, /obj/item/upgradescroll)
	wander = FALSE
	del_on_death = TRUE
	blood_volume = BLOOD_VOLUME_NORMAL
	gps_name = "Chaotic Signal"
	death_message = "falls to the ground, decaying into glowing particles."
	death_sound = "sound/magic/curse.ogg"
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(/datum/action/innate/megafauna_attack/blood_dash,
							   /datum/action/innate/megafauna_attack/teleport_b,
							   /datum/action/innate/megafauna_attack/runic_blast,
							   /datum/action/innate/megafauna_attack/infernal_summon,
							   /datum/action/innate/megafauna_attack/blast,
							   /datum/action/innate/megafauna_attack/rapid_fire)
	move_force = MOVE_FORCE_NORMAL
	var/turf/starting
	var/obj/item/nullrod/scythe/talking/chainsword/chaos/mob/weapon
	var/charging = FALSE
	var/dash_cooldown = 6 SECONDS
	var/runic_blast_cooldown = 14 SECONDS
	var/teleport_cooldown = 6 SECONDS
	var/infernal_summon_cooldown = 30 SECONDS
	var/dash_mod = 0.9
	var/dash_num = 3
	var/newcolor = rgb(149, 10, 10)

/obj/item/nullrod/scythe/talking/chainsword/chaos
	name = "chainsaw sword"
	desc = "Blood for the blood god!"
	throwforce = 25
	block_chance = 35
	armour_penetration = 50
	wound_bonus = 15
	bare_wound_bonus = 30
	sharpness = SHARP_EDGED

/obj/item/nullrod/scythe/talking/chainsword/chaos/mob
	wound_bonus = -100
	bare_wound_bonus = -100
	block_chance = 0
	force = 16

/mob/living/simple_animal/hostile/megafauna/chaos_marine/Initialize()
	. = ..()
	starting = get_turf(src)
	weapon = new(src)

/turf/closed/indestructible/cult
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult"

/turf/open/indestructible/cult
	icon = 'icons/turf/floors.dmi'
	icon_state = "cult"
	initial_gas_mix = OPENTURF_LOW_PRESSURE

/datum/action/innate/megafauna_attack/blood_dash
	name = "Blood Dash"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = span_colossus("You are now dashing through your enemies, piercing everyone caught in your path.")
	chosen_attack_num = 1

/datum/action/innate/megafauna_attack/runic_blast
	name = "Runic Blast"
	icon_icon = 'icons/obj/rune.dmi'
	button_icon_state = "4"
	chosen_message = span_colossus("You are now setting up a big explosion, with a delay.")
	chosen_attack_num = 2

/datum/action/innate/megafauna_attack/blast
	name = "Blast"
	icon_icon = 'icons/obj/guns/projectile.dmi'
	button_icon_state = "arg"
	chosen_message = span_colossus("You are now shooting at your enemy with explosive bullets.")
	chosen_attack_num = 3

/datum/action/innate/megafauna_attack/infernal_summon
	name = "Infernal Summon"
	icon_icon = 'icons/mob/mob.dmi'
	button_icon_state = "imp"
	chosen_message = span_colossus("You will now summon demons to assist you.")
	chosen_attack_num = 4

/datum/action/innate/megafauna_attack/teleport_b
	name = "Teleport"
	icon_icon = 'icons/obj/projectiles.dmi'
	button_icon_state = "bluespace"
	chosen_message = span_colossus("You will now teleport next to your target.")
	chosen_attack_num = 5

/datum/action/innate/megafauna_attack/rapid_fire
	name = "Rapid Fire"
	icon_icon = 'icons/obj/guns/projectile.dmi'
	button_icon_state = "arg"
	chosen_message = span_colossus("You are now rapidly shooting at your enemy with explosive bullets (5).")
	chosen_attack_num = 6

/mob/living/simple_animal/hostile/megafauna/chaos_marine/AttackingTarget()
	if(charging)
		return
	face_atom(target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.health <= HEALTH_THRESHOLD_DEAD || L.stat == DEAD) //To prevent memento mori limbo
			visible_message(span_danger("[src] butchers [L]!"),
			span_userdanger("You butcher [L], restoring your health!"))
			if(!is_station_level(z) || client) //NPC monsters won't heal while on station
				adjustHealth(-(L.maxHealth * 0.5))
			L.gib()
			if(ishuman(L)) // If target is a human - yell some funny shit.
				telegraph()
				say(pick("Blood for the blood god!!", "Skulls for the skull throne!!", "Blood, blood!!", "Die! Die! Die!!", "You will be a fine offering!!", "Chaos!!"))
			return TRUE
	weapon.melee_attack_chain(src, target)
	return TRUE

/mob/living/simple_animal/hostile/megafauna/chaos_marine/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/adjustCMspeed()
	if(health <= maxHealth*0.25)
		speed = 2
		dash_mod = 0.4
		dash_num = 5
		rapid_melee = 3.5
	else if(health <= maxHealth*0.5)
		speed = 2.4
		dash_mod = 0.5
		dash_num = 4
		rapid_melee = 3
	else if(health <= maxHealth*0.75)
		speed = 2.8
		dash_mod = 0.7
		dash_num = initial(dash_num)
		rapid_melee = 2
	else if(health > maxHealth*0.75)
		speed = initial(speed)
		dash_mod = initial(dash_mod)
		dash_num = initial(dash_num)
		rapid_melee = initial(rapid_melee)

/mob/living/simple_animal/hostile/megafauna/chaos_marine/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!used_item && !isturf(A))
		used_item = weapon
	..()

/mob/living/simple_animal/hostile/megafauna/chaos_marine/OpenFire()
	adjustCMspeed()

	if(client)
		switch(chosen_attack)
			if(1)
				blood_dash(target)
			if(2)
				runic_blast()
			if(3)
				blast()
			if(4)
				infernal_summon()
			if(5)
				teleport_b(target)
			if(6)
				rapid_fire()
		return

	Goto(target, move_to_delay, minimum_distance)
	if(get_dist(src, target) >= 1 && dash_cooldown <= world.time && !charging)
		blood_dash(target)
	if(get_dist(src, target) > round(5*dash_mod) && teleport_cooldown <= world.time && !charging)
		teleport_b(target)
	if(get_dist(src, target) > 4 && ranged_cooldown <= world.time && !charging)
		if(health <= maxHealth*0.5)
			rapid_fire()
		else
			blast()
	if(get_dist(src, target) <= 3 && runic_blast_cooldown <= world.time && !charging)
		runic_blast()
	if(infernal_summon_cooldown <= world.time && !charging)
		infernal_summon()

/obj/projectile/bullet/chaos_bomb
	name ="bolter bullet"
	desc = "Oh god oh fu..."
	icon_state = "bolter"
	damage = 60

/obj/projectile/bullet/chaos_bomb/blood
	name = "blood bolt"
	icon_state = "mini_leaper"
	damage = 75
	nondirectional_sprite = TRUE
	impact_effect_type = /obj/effect/temp_visual/dir_setting/bloodsplatter

/mob/living/simple_animal/hostile/megafauna/chaos_marine/ex_act(severity, target)
	return //Resistant to explosions

/mob/living/simple_animal/hostile/megafauna/chaos_marine/death(gibbed)
	if(health > 0)
		return
	var/obj/effect/portal/permanent/one_way/exit = new /obj/effect/portal/permanent/one_way(starting)
	exit.id = "chaos_marine_exit"
	exit.add_atom_colour(COLOR_RED_LIGHT, ADMIN_COLOUR_PRIORITY)
	exit.set_light(15, 1, COLOR_RED)
	return ..()

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/blood_dash(target)
	if(charging || dash_cooldown > world.time)
		return
	dash_cooldown = world.time + (initial(dash_cooldown) * dash_mod)
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	var/turf/T = get_step(get_turf(src), dir_to_target)
	for(var/i in 1 to dash_num)
		new /obj/effect/temp_visual/dragon_swoop/legionnaire(T)
		T = get_step(T, dir_to_target)
	addtimer(CALLBACK(src, PROC_REF(blood_dash_2), dir_to_target, 0), (5 * dash_mod))
	playsound(src,'sound/effects/meteorimpact.ogg', 200, 1)

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/blood_dash_2(move_dir, times_ran)
	if(times_ran >= dash_num)
		charging = FALSE
		return
	var/turf/T = get_step(get_turf(src), move_dir)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	if(T.density)
		charging = FALSE
		return
	for(var/obj/structure/window/W in T.contents)
		charging = FALSE
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			charging = FALSE
			return
	forceMove(T)
	playsound(src,"sound/effects/footstep/heavy[pick(1,2)].ogg", 200, 1)
	for(var/mob/living/L in T.contents - src)
		if(!faction_check_mob(L))
			visible_message(span_boldwarning("[src] runs through [L]!"))
			to_chat(L, span_userdanger("[src] pierces you with a chain-sword!"))
			shake_camera(L, 2, 1)
			L.apply_damage(75, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			playsound(L,"sound/effects/wounds/pierce[pick(1,2,3)].ogg", 200, 1)
	addtimer(CALLBACK(src, PROC_REF(blood_dash_2), move_dir, (times_ran + 1)), (1.5 * dash_mod))

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/teleport_b(target)
	if(charging || teleport_cooldown > world.time)
		return
	charging = TRUE
	telegraph()
	cmempower()
	var/turf/T = get_step(target, pick(1,2,4,8))
	var/turf/S = get_turf(src)
	if(T.density)
		T = get_turf(target)
	layer = 3
	SLEEP_CHECK_DEATH(3)
	new /obj/effect/temp_visual/cult/blood(S)
	new /obj/effect/temp_visual/cult/blood/out(T)
	SLEEP_CHECK_DEATH(2)
	forceMove(T)
	playsound(T,'sound/magic/exit_blood.ogg', 200, 1)
	if(health <= maxHealth*0.5)
		layer = initial(layer)
		cmdepower()
		teleport_cooldown = world.time + (initial(teleport_cooldown) * dash_mod)
		charging = FALSE
		blood_dash(target)
	else
		SLEEP_CHECK_DEATH(5 * dash_mod)
		layer = initial(layer)
		cmdepower()
		teleport_cooldown = world.time + (initial(teleport_cooldown) * dash_mod)
		charging = FALSE

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/blast()
	if(ranged_cooldown <= world.time && !Adjacent(target) && !charging)
		ranged_cooldown = world.time + ranged_cooldown_time
		visible_message(span_danger("[src] fires with bolter gun!"))
		face_atom(target)
		new /obj/effect/temp_visual/dir_setting/firing_effect(loc, dir)
		Shoot(target)
		changeNext_move(CLICK_CD_RANGE)

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/rapid_fire()
	if(ranged_cooldown <= world.time && !Adjacent(target) && !charging)
		ranged_cooldown = world.time + ranged_cooldown_time
		charging = TRUE
		visible_message(span_danger("[src] rapidly fires with bolter gun!"))
		face_atom(target)
		for(var/i = 1 to 5)
			new /obj/effect/temp_visual/dir_setting/firing_effect(loc, dir)
			Shoot(target)
			SLEEP_CHECK_DEATH(3)
		changeNext_move(CLICK_CD_RANGE)
		charging = FALSE

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/runic_blast()
	if(runic_blast_cooldown > world.time || charging)
		return
	var/turf/T = get_turf(src)
	var/dir_mod = pick(-1,1)
	charging = TRUE
	telegraph()
	cmempower()
	new /obj/effect/temp_visual/dragon_swoop/bubblegum(T)
	SLEEP_CHECK_DEATH(10)
	explosion(src, -1, 0, 3, 0, 0, flame_range = 4)
	SLEEP_CHECK_DEATH(5 * dash_mod)
	for(var/i = 1 to 8)
		shoot_projectile(T, (i*dir_mod*45))
		if(src.health > src.maxHealth*0.5)
			SLEEP_CHECK_DEATH(3)
	SLEEP_CHECK_DEATH(15 * dash_mod)
	cmdepower()
	runic_blast_cooldown = (world.time + initial(runic_blast_cooldown))
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/infernal_summon()
	if(infernal_summon_cooldown > world.time || charging)
		return
	charging = TRUE
	cmempower()
	var/turf/T = get_turf(src)
	var/turf/X1 = get_step(T, pick(1,2))
	var/turf/X2 = get_step(T, pick(4,8))
	telegraph()
	new /obj/effect/temp_visual/cult/sparks(X1)
	new /obj/effect/temp_visual/cult/sparks(X2)
	SLEEP_CHECK_DEATH(25 * dash_mod)
	telegraph()
	new /obj/effect/temp_visual/cult/sparks(X1)
	new /obj/effect/temp_visual/cult/sparks(X2)
	SLEEP_CHECK_DEATH(25 * dash_mod)
	new /obj/effect/temp_visual/cult/blood/out(X1)
	new /obj/effect/temp_visual/cult/blood/out(X2)
	playsound(src,'sound/magic/exit_blood.ogg', 200, 1)
	if(src.health <= src.maxHealth*0.5)
		new /mob/living/simple_animal/hostile/chaos/greater(X1)
		new /mob/living/simple_animal/hostile/chaos/greater(X2)
	else
		new /mob/living/simple_animal/hostile/chaos(X1)
		new /mob/living/simple_animal/hostile/chaos(X2)
	SLEEP_CHECK_DEATH(20 * dash_mod)
	remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, newcolor)
	cmdepower()
	infernal_summon_cooldown = (world.time + initial(infernal_summon_cooldown))
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/bullet/chaos_bomb/blood(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	if(target)
		P.original = target
	P.fire(set_angle)

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/telegraph()
	for(var/mob/M in range(10,src))
		if(M.client)
			flash_color(M.client, "#FF0000", 2)
			shake_camera(M, 2, 1)
	playsound(src, 'sound/magic/clockwork/narsie_attack.ogg', 200, TRUE)

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/cmempower()
	ChangeResistances(list(RED_DAMAGE = 0.25, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.1))
	add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	new /obj/effect/temp_visual/cult/sparks(get_turf(src))

/mob/living/simple_animal/hostile/megafauna/chaos_marine/proc/cmdepower()
	ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.2))
	remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, newcolor)
	new /obj/effect/temp_visual/cult/sparks(get_turf(src))

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/berserker/chaos
	name = "berserker's hardsuit"
	allowed = list(/obj/item/gun, /obj/item/nullrod, /obj/item/tank/internals)
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = -50, BLACK_DAMAGE = 35, PALE_DAMAGE = 60)
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	cell = /obj/item/stock_parts/cell/hyper
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/berserker/chaos
	icon_state = "hardsuit-chaos"
	icon = 'ModularTegustation/Teguicons/teguclothing_worn.dmi'
	worn_icon = 'ModularTegustation/Teguicons/teguclothing_worn.dmi'

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/berserker/chaos
	name = "berserker's helmet"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = -50, BLACK_DAMAGE = 35, PALE_DAMAGE = 60)
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	icon_state = "hardsuit0-chaos"
	icon = 'ModularTegustation/Teguicons/teguclothing_worn.dmi'
	worn_icon = 'ModularTegustation/Teguicons/teguclothing_worn.dmi'

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/berserker/chaos/process()
	. = ..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && prob(5))
		if(prob(25))
			H.adjustSanityLoss(-20)
			to_chat(H, span_danger("[pick("Voices... Voices everywhere", "Your mind shatters.", "Voices echo inside your head.")]."))
		SEND_SOUND(H, sound(pick('sound/hallucinations/over_here3.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/magic/exit_blood.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg')))

//DEMONS
/mob/living/simple_animal/hostile/chaos
	name = "lesser daemon"
	real_name = "daemon"
	unique_name = TRUE
	desc = "A large, menacing creature covered in armored black scales."
	response_help_continuous = "thinks better of touching"
	response_help_simple = "think better of touching"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	icon = 'icons/mob/mob.dmi'
	icon_state = "imp"
	icon_living = "imp"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speed = 4
	a_intent = INTENT_HARM
	stop_automated_movement = 1
	status_flags = CANPUSH
	attack_sound = 'sound/magic/demon_attack1.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("chaos")
	maxHealth = 100
	health = 100
	vision_range = 16
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_HUGE
	melee_damage_lower = 16
	melee_damage_upper = 18
	see_in_dark = 8
	light_color = "#FF0000"
	light_range = 2
	move_to_delay = 3
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	del_on_death = TRUE
	death_message = "screams in agony as it sublimates into a sulfurous smoke."
	death_sound = 'sound/magic/demon_dies.ogg'

/mob/living/simple_animal/hostile/chaos/greater
	name = "daemon"
	icon_state = "daemon"
	icon_living = "daemon"
	desc = "A powerful creature that was brought here straight from a hellish realm."
	melee_damage_lower = 22
	melee_damage_upper = 28
	light_range = 4
	maxHealth = 180
	health = 180

/mob/living/simple_animal/hostile/chaos/ex_act(severity, target)
	return //Resistant to explosions

//RUIN DATUM
/datum/map_template/ruin/space/chaos_marine
	id = "chaosmarine"
	suffix = "chaosmarine.dmm"
	name = "Bloody Lair"
	description = "A seemingly abandoned blood cult base in space, but why was it abandoned?"
	always_place = TRUE
	cost = 0
