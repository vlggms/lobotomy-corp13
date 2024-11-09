/mob/living/simple_animal/hostile/humanoid/blood
	faction = list("hostile")

/mob/living/simple_animal/hostile/humanoid/blood/fiend
	name = "bloodfiend"
	desc = "Desc"
	icon = 'ModularTegustation/Teguicons/blood_fiends_32x48.dmi'
	icon_state = "Fashionista_Bloodfiend"
	icon_living = "Fashionista_Bloodfiend"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.3)
	melee_damage_lower = 13
	melee_damage_upper = 15
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/abnormalities/nosferatu/attack.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	maxHealth = 1000
	health = 1000
	ranged = TRUE
	var/leap_sound = 'sound/abnormalities/nosferatu/attack_special.ogg'
	var/blood_feast = 400
	var/max_blood_feast = 400
	var/can_act = TRUE
	var/leap_damage = 50
	var/slash_damage = 25
	var/drain_cooldown = 0
	var/drain_cooldown_time = 50
	var/bleed_stacks = 3
	var/leap_bleed_stacks = 10
	var/boss = FALSE

/mob/living/simple_animal/hostile/humanoid/blood/fiend/proc/AdjustBloodFeast(amount)
	adjustBruteLoss(-amount/2)
	blood_feast += amount
	if (blood_feast > max_blood_feast)
		blood_feast = max_blood_feast

/mob/living/simple_animal/hostile/humanoid/blood/fiend/proc/Drain()
	var/turf/T = get_turf(src)
	if(!T)
		return
	if (health != maxHealth || blood_feast != max_blood_feast)
		for(var/obj/effect/decal/cleanable/blood/B in view(T, 2)) //will clean up any blood, but only heals from human blood
			if (health != maxHealth || blood_feast != max_blood_feast)
				if(B.blood_state == BLOOD_STATE_HUMAN)
					playsound(T, 'sound/abnormalities/nosferatu/bloodcollect.ogg', 25, 3)
					if(B.bloodiness == 100) //Bonus for "pristine" bloodpools, also to prevent footprint spam
						AdjustBloodFeast(30)
					else
						AdjustBloodFeast(max((B.bloodiness**2)/800,1))
				qdel(B)

/mob/living/simple_animal/hostile/humanoid/blood/fiend/proc/Dash(target_turf)
	target_turf = get_turf(target)
	var/list/hit_mob = list()
	do_shaky_animation(1)
	if(do_after(src, 0.5 SECONDS, target = src))
		var/turf/wallcheck = get_turf(src)
		var/enemy_direction = get_dir(src, target_turf)
		for(var/i = 0 to 4)
			if(get_turf(src) != wallcheck || stat == DEAD)
				break
			wallcheck = get_step(src, enemy_direction)
			if(!ClearSky(wallcheck))
				break
			sleep(0.25)//without this the attack happens instantly
			forceMove(wallcheck)
			playsound(wallcheck, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 20, 0, 4)
			for(var/turf/T in orange(get_turf(src), 1))
				if(isclosedturf(T))
					continue
				var/obj/effect/temp_visual/slice/blood = new(T)
				blood.color = "#b52e19"
				hit_mob = HurtInTurf(T, hit_mob, slash_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)

/mob/living/simple_animal/hostile/humanoid/blood/fiend/proc/Leap(mob/living/target)
	if(!isliving(target) && !ismecha(target) || !can_act)
		return
	blood_feast = 0
	can_act = FALSE
	SLEEP_CHECK_DEATH(0.25 SECONDS)
	animate(src, alpha = 1,pixel_x = 16, pixel_z = 0, time = 0.1 SECONDS)
	src.pixel_x = 16
	playsound(src, 'sound/abnormalities/ichthys/jump.ogg', 50, FALSE, 4)
	var/turf/target_turf = get_turf(target)
	SLEEP_CHECK_DEATH(1 SECONDS)
	if(target_turf)
		forceMove(target_turf) //look out, someone is rushing you!
	playsound(src, leap_sound, 50, FALSE, 4)
	animate(src, alpha = 255,pixel_x = -16, pixel_z = 0, time = 0.1 SECONDS)
	src.pixel_x = 0
	SLEEP_CHECK_DEATH(0.1 SECONDS)
	for(var/turf/T in view(1, src))
		var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
		FX.color = "#b52e19"
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_lc_bleed(leap_bleed_stacks)
			L.deal_damage(leap_damage, RED_DAMAGE)
		for(var/obj/vehicle/sealed/mecha/V in T)
			V.take_damage(leap_damage, RED_DAMAGE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	say("No... I NEED MORE!!!")
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	Dash(target_turf)
	Dash(target_turf)
	can_act = TRUE

/mob/living/simple_animal/hostile/humanoid/blood/fiend/ClearSky(turf/T)
	. = ..()
	if(.)
		if(locate(/obj/structure/table) in T.contents)
			return FALSE
		if(locate(/obj/structure/railing) in T.contents)
			return FALSE

/mob/living/simple_animal/hostile/humanoid/blood/fiend/Life()
	. = ..()
	if(drain_cooldown > world.time)
		return FALSE
	if(stat == DEAD)
		return FALSE
	drain_cooldown = world.time + drain_cooldown_time
	Drain()

/mob/living/simple_animal/hostile/humanoid/blood/fiend/AttackingTarget()
	if(!can_act)
		return
	if(blood_feast == max_blood_feast && !client)
		Leap(target)
		return
	. = ..()
	if (istype(target, /mob/living))
		var/mob/living/L = target
		L.apply_lc_bleed(bleed_stacks)

/mob/living/simple_animal/hostile/humanoid/blood/fiend/OpenFire()
	if(!can_act)
		return FALSE
	if(max_blood_feast == blood_feast)
		Leap(target)
		return

/mob/living/simple_animal/hostile/humanoid/blood/fiend/Move()
	if(!can_act)
		return FALSE
	Drain()
	..()

/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss
	name = "bloodfiendboss"
	desc = "Desc"
	icon = 'ModularTegustation/Teguicons/blood_fiends_32x48.dmi'
	icon_state = "Fashionista_Bloodfiend"
	icon_living = "Fashionista_Bloodfiend"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.3)
	melee_damage_lower = 13
	melee_damage_upper = 15
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/abnormalities/nosferatu/attack.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	maxHealth = 1000
	health = 1000
	ranged = TRUE
	var/cutter_bleed_stacks = 15
	var/readyToSpawn75 = TRUE
	var/timeToSpawn75
	var/readyToSpawn25 = TRUE
	var/timeToSpawn25
	var/cooldownToSpawn = 10 SECONDS

/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss/Leap(mob/living/target)
	if(!isliving(target) && !ismecha(target) || !can_act)
		return
	target.apply_status_effect(/datum/status_effect/bloodhold)
	blood_feast = 0
	can_act = FALSE
	var/list/dirs_to_land = shuffle(list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
	var/list/dir_overlays = list()
	for (var/i in 1 to 3)
		var/dir_to_land = dirs_to_land[i]
		// add overlay
		var/x
		var/y
		if (dir_to_land == NORTH)
			x = 0
			y = 32
		else if (dir_to_land == SOUTH)
			x = 0
			y = -32
		else if (dir_to_land == EAST)
			x = 32
			y = 0
		else if (dir_to_land == SOUTH)
			x = -32
			y = 0
		else if (dir_to_land == NORTHEAST)
			x = 32
			y = 32
		else if (dir_to_land == NORTHWEST)
			x = 32
			y = -32
		else if (dir_to_land == SOUTHEAST)
			x = 32
			y = -32
		else
			x = -32
			y = -32
		var/image/O = image(icon='icons/effects/cult_effects.dmi',icon_state="bloodsparkles", pixel_x = x, pixel_y = y)
		target.add_overlay(O)
		dir_overlays.Add(O)
		playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
		if (stat != DEAD)
			sleep(1 SECONDS)
		else
			break
	for (var/i in 1 to 3)
		target.cut_overlay(dir_overlays[i])
		if (stat == DEAD)
			continue
		animate(src, alpha = 1,pixel_x = 16, pixel_z = 0, time = 0.1 SECONDS)
		src.pixel_x = 16
		playsound(src, 'sound/abnormalities/ichthys/jump.ogg', 50, FALSE, 4)
		var/turf/target_turf = get_step(get_turf(target), dirs_to_land[i])
		if(target_turf)
			forceMove(target_turf) //look out, someone is rushing you!
		playsound(src, leap_sound, 50, FALSE, 4)
		animate(src, alpha = 255,pixel_x = -16, pixel_z = 0, time = 0.1 SECONDS)
		src.pixel_x = 0
		Dash(target)
		sleep(0.25 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss/Dash(target_turf)
	target_turf = get_turf(target)

	do_shaky_animation(1)
	var/dx = src.x - target.x
	var/dy = src.y - target.y
	var/turf/safe_turf = locate(target.x - dx, target.y - dy, target.z)
	var/list/warning_overlays = list()
	var/list/warning_turfs = list()
	for(var/turf/T in view(target_turf, 2))
		if (T == safe_turf)
			var/image/S = image(icon='icons/effects/eldritch.dmi',icon_state="cloud_swirl")
			T.add_overlay(S)
			warning_overlays.Add(S)
			warning_turfs.Add(T)
			continue;
		var/image/O = image(icon='icons/effects/eldritch.dmi',icon_state="blood_cloud_swirl")
		T.add_overlay(O)
		warning_overlays.Add(O)
		warning_turfs.Add(T)


	sleep(15)
	for (var/i in 1 to 25)
		var/turf/T = warning_turfs[i]
		T.cut_overlay(warning_overlays[i])

	if (stat == DEAD)
		return
	playsound(target, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 20, 0, 4)
	var/list/hit_list = list()
	for(var/turf/T in view(target_turf, 2))
		if (T == safe_turf)
			continue;
		var/obj/effect/temp_visual/slice/blood = new(T)
		blood.color = "#b52e19"
		hit_list = HurtInTurf(T, hit_list, slash_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)
	for (var/hit in hit_list)
		if (istype(hit, /mob/living))
			var/mob/living/L = hit
			L.apply_lc_bleed(cutter_bleed_stacks)

/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if (health/maxHealth > 0.75)
		readyToSpawn75 = TRUE
	if (health/maxHealth > 0.25)
		readyToSpawn25 = TRUE
	. = ..()
	if (health/maxHealth < 0.75 && readyToSpawn75 && world.time > timeToSpawn75)
		// spawn
		spawnbags()
		readyToSpawn75 = FALSE
		timeToSpawn75 = world.time + cooldownToSpawn
	if (health/maxHealth < 0.25 && readyToSpawn25 && world.time > timeToSpawn25)
		// spawn
		spawnbags()
		readyToSpawn25 = FALSE
		timeToSpawn25 = world.time + cooldownToSpawn

/mob/living/simple_animal/hostile/humanoid/blood/fiend/boss/proc/spawnbags()
	var/list/turfs = shuffle(orange(1, src))
	for(var/i in 1 to 3)
		new /obj/effect/sweeperspawn/bagspawn(turfs[i])

/obj/effect/sweeperspawn/bagspawn

/obj/effect/sweeperspawn/bagspawn/spawnscout()
	new /mob/living/simple_animal/hostile/humanoid/blood/bag(get_turf(src))
	qdel(src)


/mob/living/simple_animal/hostile/humanoid/blood/bag
	name = "bloodbag"
	desc = "Desc"
	icon = 'ModularTegustation/Teguicons/blood_fiends_32x32.dmi'
	icon_state = "BloodBag"
	icon_living = "BloodBag"
	icon_dead = "BloodBag"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 5
	melee_damage_upper = 6
	rapid_melee = 3
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/effects/ordeals/brown/flea_attack.ogg'
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	maxHealth = 260
	health = 260
	var/self_damage = 20
	var/self_damage_type = RED_DAMAGE
	var/blood_drop_cooldown = 0
	var/blood_drop_cooldown_time = 2
	var/bleed_stacks = 1
	var/explosion_damage = 10
	var/explosion_bleed = 5

/mob/living/simple_animal/hostile/humanoid/blood/bag/AttackingTarget(atom/attacked_target)
	. = ..()
	if (istype(target, /mob/living))
		var/mob/living/L = target
		L.apply_lc_bleed(bleed_stacks)
	deal_damage(self_damage, self_damage_type)

/mob/living/simple_animal/hostile/humanoid/blood/bag/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(blood_drop_cooldown > world.time)
		return FALSE
	blood_drop_cooldown = world.time + blood_drop_cooldown_time
	var/turf/origin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(1, origin)
	for(var/turf/T in shuffle(all_turfs))
		if (T.is_blocked_turf(exclude_mobs = TRUE))
			continue;
		var/obj/effect/decal/cleanable/blood/B = locate() in T
		if(!B)
			B = new /obj/effect/decal/cleanable/blood(T)
			B.bloodiness = 100
			break;

/mob/living/simple_animal/hostile/humanoid/blood/bag/death(gibbed)
	walk_to(src, 0)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	QDEL_IN(src, 15)
	..()

/mob/living/simple_animal/hostile/humanoid/blood/bag/proc/DeathExplosion()
	playsound(loc, 'sound/effects/ordeals/crimson/dusk_dead.ogg', 60, TRUE)
	for(var/mob/living/L in view(1, src))
		L.deal_damage(explosion_damage, RED_DAMAGE)
		L.apply_lc_bleed(explosion_bleed)
	var/turf/origin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(1, origin)
	for(var/turf/T in shuffle(all_turfs))
		if (T.is_blocked_turf(exclude_mobs = TRUE))
			continue;
		var/obj/effect/decal/cleanable/blood/B = locate() in T
		if(!B)
			B = new /obj/effect/decal/cleanable/blood(T)
			B.bloodiness = 100
