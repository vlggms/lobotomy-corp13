/// X-Corp Grunt
/mob/living/simple_animal/hostile/xcorp
	name = "X-Corp Laute"
	desc = "A grotesque mockery of biology, the sin of opulence."
	icon_state = "blank-body"
	maxHealth = 220
	health = 220
	vision_range = 8
	move_to_delay = 1
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 13
	attack_verb_continuous = "scratches"
	attack_verb_simple = "scratch"
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	see_in_dark = 8
	stat_attack = HARD_CRIT

/mob/living/simple_animal/hostile/xcorp/Life()
	. = ..()
	if(health <= maxHealth*0.2 && stat != DEAD)
		adjustBruteLoss(-4)
		if(!target)
			adjustBruteLoss(-16)

/// X-Corp DPS
/mob/living/simple_animal/hostile/xcorp/dps
	name = "X-Corp Studiose"
	desc = "A writhing mass of edges, the sin of sophistication."
	icon = 'icons/mob/eldritch_mobs.dmi'
	icon_state = "ash_walker"
	maxHealth = 100
	health = 100
	melee_damage_type = BLACK_DAMAGE
	footstep_type = FOOTSTEP_OBJ_MACHINE
	rapid_melee = 2
	melee_damage_lower = 3
	melee_damage_upper = 10
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/ego/sword1.ogg'
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.8)
	ranged = TRUE
	var/charging = FALSE
	var/dash_num = 25
	var/extra_dash_distance = 3
	var/dash_cooldown = 0
	var/dash_cooldown_time = 6 SECONDS
	var/dash_damage = 40
	var/dash_range = 1
	var/list/been_hit = list() // Don't get hit twice.

/mob/living/simple_animal/hostile/xcorp/dps/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/xcorp/dps/AttackingTarget(atom/attacked_target)
	if(charging)
		return
	if(dash_cooldown <= world.time && prob(10) && !client)
		PrepCharge(attacked_target)
		return
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.health < 0)
		playsound(src, 'sound/weapons/fixer/generic/blade4.ogg', 75, 1)
	return

/mob/living/simple_animal/hostile/xcorp/dps/OpenFire()
	if(dash_cooldown <= world.time)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			PrepCharge(target)

/mob/living/simple_animal/hostile/xcorp/dps/proc/PrepCharge(target)
	if(charging || dash_cooldown > world.time)
		return
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	SpinAnimation(3, 20)
	dash_num = (get_dist(src, target) + extra_dash_distance)
	addtimer(CALLBACK(src, PROC_REF(Charge), dir_to_target, 0), 2 SECONDS)
	playsound(src, 'sound/effects/ordeals/brown/pridespin.ogg', 125, FALSE)

/mob/living/simple_animal/hostile/xcorp/dps/proc/Charge(move_dir, times_ran)
	if(health <= 0)
		return
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
	for(var/obj/machinery/door/poddoor/P in T.contents)//FIXME: Still opens the "poddoor" secure shutters
		stop_charge = TRUE
		continue
	if(stop_charge)
		charging = FALSE
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			D.open(2)
	forceMove(T)
	playsound(src, 'sound/weapons/fixer/generic/blade1.ogg', 100, 1)
	for(var/turf/TF in range(dash_range, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(dash_range, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		L.visible_message(span_warning("[src] shreds [L] as it passes by!"), span_boldwarning("[src] shreds you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		L.apply_damage(dash_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		been_hit += L
		playsound(L, 'sound/weapons/fixer/generic/sword4.ogg', 75, 1)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.health < 0)
			playsound(src, 'sound/weapons/fixer/generic/blade4.ogg', 75, 1)
	addtimer(CALLBACK(src, PROC_REF(Charge), move_dir, (times_ran + 1)), 1)

/// X-Corp Tank
/mob/living/simple_animal/hostile/xcorp/tank
	name = "X-Corp Nimis"
	desc = "A blob of hardened muscle, the sin of gorging."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blobbernaut"
	color = "#550e0e"
	maxHealth = 450
	health = 450
	speed = 2
	move_to_delay = 4
	melee_damage_lower = 12
	melee_damage_upper = 18
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	attack_vis_effect = ATTACK_EFFECT_SMASH
	footstep_type = FOOTSTEP_MOB_HEAVY
	ranged = 1
	rapid = 3
	rapid_fire_delay = 2
	ranged_cooldown_time = 15
	check_friendly_fire = TRUE
	projectiletype = /obj/projectile/xcorp_bone
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)

/obj/projectile/xcorp_bone
	name = "sans undertale reference"
	icon_state = "bonebullet"
	damage_type = RED_DAMAGE
	damage = 4
	spread = 12
	embedding = null

/// X-Corp Scout
/mob/living/simple_animal/hostile/xcorp/scout
	name = "X-Corp Praepropere"
	desc = "A floating eyeball, the sin of alacrity."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blobpod"
	color = "#e65454"
	maxHealth = 500
	health = 500
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.3)
	environment_smash = FALSE
	is_flying_animal = TRUE
	footstep_type = null
	rapid_melee = 1
	ranged = TRUE
	ranged_cooldown_time = 7 SECONDS
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	buffed = FALSE
	move_to_delay = 3
	var/charging = FALSE

/mob/living/simple_animal/hostile/xcorp/scout/Move()
	if(buffed && !charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/xcorp/scout/AttackingTarget(atom/attacked_target)
	if(ranged_cooldown <= world.time && prob(30))
		if(!target)
			GiveTarget(attacked_target)
		OpenFire()
		return
	return ..()

/mob/living/simple_animal/hostile/xcorp/scout/CanAllowThrough(atom/movable/mover, turf/target)
	if(charging && isliving(mover))
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/xcorp/scout/Shoot(atom/A)
	if(buffed || !isliving(A))
		return FALSE
	animate(src, alpha = alpha - 50, pixel_y = base_pixel_y + 25, layer = 6, time = 10)
	buffed = TRUE
	density = FALSE
	if(do_after(src, 2 SECONDS, target = src))
		ArialSupport()
	else
		visible_message(span_notice("[src] crashes to the ground."))
		apply_damage(100, RED_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	//return to the ground
	density = TRUE
	layer = initial(layer)
	buffed = FALSE
	alpha = initial(alpha)
	pixel_y = initial(pixel_y)
	base_pixel_y = initial(base_pixel_y)

/mob/living/simple_animal/hostile/xcorp/scout/proc/ArialSupport()
	charging = TRUE
	var/turf/target_turf = get_turf(target)
	for(var/i=0 to 7)
		var/turf/wallcheck = get_step(src, get_dir(src, target_turf))
		if(!ClearSky(wallcheck))
			break
		var/mob/living/sweeptarget = locate(target) in wallcheck
		if(sweeptarget)
			SweepAttack(sweeptarget)
			break
		forceMove(wallcheck)
		SLEEP_CHECK_DEATH(0.5)
	charging = FALSE

/mob/living/simple_animal/hostile/xcorp/scout/proc/SweepAttack(mob/living/sweeptarget)
	sweeptarget.visible_message(span_danger("[src] slams into [sweeptarget]!"), span_userdanger("[src] slams into you!"))
	sweeptarget.apply_damage(20, RED_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 50, TRUE)
	if(sweeptarget.mob_size <= MOB_SIZE_HUMAN)
		DoKnockback(sweeptarget, src, get_dir(src, sweeptarget))
		shake_camera(sweeptarget, 4, 3)
		shake_camera(src, 2, 3)

/mob/living/simple_animal/hostile/xcorp/scout/proc/DoKnockback(atom/target, mob/thrower, throw_dir) //stolen from the knockback component since this happens only once
	if(!ismovable(target) || throw_dir == null)
		return
	var/atom/movable/throwee = target
	if(throwee.anchored)
		return
	if(QDELETED(throwee))
		return
	var/atom/throw_target = get_edge_target_turf(throwee, throw_dir)
	throwee.safe_throw_at(throw_target, 1, 1, thrower, gentle = TRUE)

/// X-Corp Sapper
/mob/living/simple_animal/hostile/xcorp/sapper
	name = "X-Corp Ardenter"
	desc = "A creature hellbent on consumption, the sin of insatiability."
	speak_emote = list("wretches")
	health = 500
	maxHealth = 500
	obj_damage = 50
	icon_state = "mi-go"
	icon_living = "mi-go"
	icon_dead = "mi-go-dead"
	attack_verb_continuous = "lacerates"
	attack_verb_simple = "lacerate"
	speed = -0.3
	rapid_melee = 5
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 1
	melee_damage_upper = 3
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	death_message = "wails as its form turns into a pulpy mush."
	death_sound = 'sound/voice/hiss6.ogg'
	var/scream_damage = 20
	search_objects = 1
	wanted_objects = list(/obj/structure/barricade/sandbags, /obj/machinery/manned_turret/rcorp, /obj/machinery/conveyor)
	see_in_dark = 8

/mob/living/simple_animal/hostile/xcorp/sapper/AttackingTarget(atom/attacked_target)
	. = ..()
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/L = attacked_target
		if(L.sanity_lost && L.stat != DEAD)
			L.apply_damage(scream_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
	return ..()

/mob/living/simple_animal/hostile/xcorp/sapper/toggle_ai(togglestatus)
	if(togglestatus != AI_ON && togglestatus != AI_IDLE)
		..()

/mob/living/simple_animal/hostile/xcorp/sapper/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	..()
	if(stat)
		return
	manual_emote("twitches unnaturally...")
	for(var/mob/living/L in view(7, src))
		if(!faction_check_mob(L))
			L.apply_damage(scream_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))

/mob/living/simple_animal/hostile/xcorp/sapper/Life()
	..()
	if(stat)
		return
	if(prob(10))
		manual_emote("twitches unnaturally...")
		for(var/mob/living/L in view(7, src))
			if(!faction_check_mob(L))
				L.apply_damage(scream_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))

/// X-Corp Heart Grunt
/mob/living/simple_animal/hostile/xcorp/heart
	name = "Accumulatio"
	desc = "The sin of hoarding."
	icon = 'icons/mob/vatgrowing.dmi'
	icon_state = "grapes"
	color = "#dd4400"
	vision_range = 12
	maxHealth = 660
	health = 660
	move_to_delay = 1
	melee_damage_type = RED_DAMAGE
	melee_damage_upper = 15
	melee_damage_lower = 25
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 2)

/mob/living/simple_animal/hostile/xcorp/heart/Life()
	. = ..()
	if(health <= maxHealth*0.5 && stat != DEAD)
		adjustBruteLoss(-16)
		if(!target)
			adjustBruteLoss(-32)

/mob/living/simple_animal/hostile/xcorp/heart/dps
	name = "Sumptus Excessivi"
	desc = "The sin of squandering."
	icon = 'icons/mob/32x64.dmi'
	icon_state = "arch_devil"
	maxHealth = 1200
	health = 1200
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 16
	melee_damage_upper = 25
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	speed = 0.8
	footstep_type = FOOTSTEP_HARD_CLAW
	damage_coeff = list(RED_DAMAGE = 0.9,  WHITE_DAMAGE = 2, BLACK_DAMAGE = 3, PALE_DAMAGE = 0.1)


/mob/living/simple_animal/hostile/xcorp/heart/ranged
	name = "Sicarius"
	desc = "The sin of vying."
	icon = 'icons/mob/eldritch_mobs.dmi'
	icon_state = "stalker"
	maxHealth = 650
	health = 650
	speed = 1.5
	move_to_delay = 2
	melee_damage_lower = 2
	melee_damage_upper = 4
	melee_damage_type = PALE_DAMAGE
	ranged = 1
	rapid = 4
	rapid_fire_delay = 2
	ranged_cooldown_time = 11
	check_friendly_fire = TRUE
	projectiletype = /obj/projectile/xcorp_bone2
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)

/obj/projectile/xcorp_bone2
	name = "bad to the bone"
	icon_state = "bonebullet"
	damage_type = BLACK_DAMAGE
	damage = 5
	spread = 16
	embedding = null

/mob/living/simple_animal/hostile/xcorp/heart/pylon
	name = "Expectatio"
	desc = "The sin of entitlement."
