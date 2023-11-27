/mob/living/simple_animal/hostile/ordeal/jimbo
	name = "jimbo"
	desc = "''jimbo.''- Egor"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "jimbo"
	icon_living = "jimbo"
	icon_dead = "green_bot_dead"
	faction = list("green_ordeal")
	pixel_x = -8
	base_pixel_x = -8
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 9001
	health = 9001
	speed = 0.5
	rapid_melee = 12
	move_to_delay = 4
	melee_damage_lower = 10 // Full damage is done on the entire turf of target
	melee_damage_upper = 12
	attack_verb_continuous = "saws"
	attack_verb_simple = "saw"
	attack_sound = 'sound/effects/ordeals/green/saw.ogg'
	ranged = 1
	rapid = 25
	rapid_fire_delay = 0.25
	ranged_cooldown_time = 30
	check_friendly_fire = TRUE //stop shooting each other
	projectiletype = /obj/projectile/bullet/c9x19mm/greenbot
	projectilesound = 'sound/effects/ordeals/green/fire.ogg'
	deathsound = 'sound/effects/ordeals/green/noon_dead.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.29, BLACK_DAMAGE = 2, PALE_DAMAGE = -2)
	butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	silk_results = list(/obj/item/stack/sheet/silk/green_advanced = 1,
						/obj/item/stack/sheet/silk/green_simple = 2)

	/// Can't move/attack when it's TRUE
	var/reloading = FALSE
	/// When at 12 - it will start "reloading"
	var/fire_count = 0

	var/scream_cooldown
	var/scream_cooldown_time = 1 SECONDS
	var/scream_damage = 40
	var/slam_cooldown
	var/slam_cooldown_time = 0.2 SECONDS
	var/slam_damage = 30
	var/spit_cooldown
	var/spit_cooldown_time = 3 SECONDS
	/// Actually it fires this amount thrice, so, multiply it by 3 to get actual amount
	var/spit_amount = 24
	var/hello_cooldown
	var/hello_cooldown_time = 2 SECONDS
	var/hello_damage = 120
	var/goodbye_cooldown
	var/goodbye_cooldown_time = 1 SECONDS
	var/goodbye_damage = 500
	var/charging = FALSE
	var/serumW_cooldown = 0
	var/serumW_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/jimbo/CanAttack(atom/the_target)
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/jimbo/Life()
	. = ..()
	if(.) // Alive and well
		if(serumW_cooldown <= world.time)
			var/list/targets_in_view = list()
			for(var/mob/living/L in view(9, src))
				if(L.stat)
					continue
				if(faction_check_mob(L))
					continue
				targets_in_view += L
			if(length(targets_in_view) > 3)
				var/mob/living/L = pick(targets_in_view)
				INVOKE_ASYNC(src, .proc/SerumW, L) // Will do targeted serum W
				return
			INVOKE_ASYNC(src, .proc/SerumW) // So we don't get stuck


/mob/living/simple_animal/hostile/ordeal/jimbo/Move()
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/jimbo/Goto(target, delay, minimum_distance)
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/jimbo/DestroySurroundings()
	if(reloading)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/jimbo/OpenFire(atom/A)
	if(reloading)
		return
	if(scream_cooldown <= world.time)
		Scream()
	if(spit_cooldown <= world.time)
		Spit(target)
	if((slam_cooldown <= world.time) && (get_dist(src, target) < 3))
		Slam(3)
	if(hello_cooldown <= world.time)
		Hello(target)
	if((goodbye_cooldown <= world.time) && (get_dist(src, target) < 3))
		Goodbye()
	fire_count += 1
	if(fire_count >= 12)
		StartReloading()

/mob/living/simple_animal/hostile/ordeal/jimbo/AttackingTarget()
	. = ..()
	if(.)
		SerumW(target)
		if(scream_cooldown <= world.time)
			Scream()
		if(spit_cooldown <= world.time)
			Spit(target)
		if((slam_cooldown <= world.time) && (get_dist(src, target) < 3))
			Slam(3)
		if(hello_cooldown <= world.time)
			Hello(target)
		if((goodbye_cooldown <= world.time) && (get_dist(src, target) < 3))
			Goodbye()
		if(!istype(target, /mob/living))
			return
		var/turf/T = get_turf(target)
		if(!T)
			return
		for(var/i = 1 to 4)
			if(!T)
				return
			new /obj/effect/temp_visual/saw_effect(T)
			HurtInTurf(T, list(), 8, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
			SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/ordeal/jimbo/spawn_gibs()
	new /obj/effect/gibspawner/scrap_metal(drop_location(), src)

/mob/living/simple_animal/hostile/ordeal/jimbo/spawn_dust()
	return

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/StartReloading()
	reloading = TRUE
	icon_state = "jimbo_reload"
	playsound(get_turf(src), 'sound/effects/ordeals/green/cooldown.ogg', 50, FALSE)
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/green_noon_reload(get_turf(src))
		SLEEP_CHECK_DEATH(8)
	fire_count = 0
	reloading = FALSE
	icon_state = icon_living

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/Scream()
	if(scream_cooldown > world.time)
		return
	scream_cooldown = world.time + scream_cooldown_time
	visible_message(span_danger("[src] screams wildly!"))
	new /obj/effect/temp_visual/voidout(get_turf(src))
	playsound(get_turf(src), 'sound/abnormalities/mountain/scream.ogg', 75, 1, 5)
	var/list/been_hit = list()
	for(var/turf/T in view(7, src))
		HurtInTurf(T, been_hit, scream_damage, BLACK_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/Slam(range)
	if(slam_cooldown > world.time)
		return
	slam_cooldown = world.time + slam_cooldown_time
	visible_message(span_danger("[src] slams on the ground!"))
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, 1)
	var/list/been_hit = list()
	for(var/turf/open/T in view(2, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		HurtInTurf(T, been_hit, slam_damage, BLACK_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/Spit(atom/target)
	if(spit_cooldown > world.time)
		return
	visible_message(span_danger("[src] prepares to spit an acidic substance at [target]!"))
	SLEEP_CHECK_DEATH(4)
	spit_cooldown = world.time + spit_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/mountain/spit.ogg', 75, 1, 3)
	for(var/k = 1 to 6)
		var/turf/startloc = get_turf(targets_from)
		for(var/i = 1 to spit_amount)
			var/obj/projectile/mountain_spit/P = new(get_turf(src))
			P.starting = startloc
			P.firer = src
			P.fired_from = src
			P.yo = target.y - startloc.y
			P.xo = target.x - startloc.x
			P.original = target
			P.preparePixelProjectile(target, src)
			P.fire()
		SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/Hello(target)
	if(hello_cooldown > world.time)
		return
	hello_cooldown = world.time + hello_cooldown_time
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_cast.ogg', 75, 0, 3)
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/hello_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(hello_delay)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, hello_damage, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/Goodbye()
	if(goodbye_cooldown > world.time)
		return
	goodbye_cooldown = world.time + goodbye_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(8)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/nt_goodbye(T)
		for(var/mob/living/L in HurtInTurf(T, list(), goodbye_damage, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE))
			if(L.health < 0)
				L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 7)
	SLEEP_CHECK_DEATH(3)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/TargetSerumW(mob/living/L)
	if(!istype(L) || QDELETED(L))
		return FALSE
	charging = TRUE
	var/obj/effect/temp_visual/target_field/uhoh = new /obj/effect/temp_visual/target_field(L.loc)
	uhoh.orbit(L, 0)
	playsound(L, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 1, 1)
	icon_state = "claw_prepare"
	to_chat(L, "<span class='danger'>The [src] is going to hunt you down!</span>")
	addtimer(CALLBACK(src, .proc/TargetEviscerate, L, uhoh), 15)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/SerumW(target)
	if(serumW_cooldown > world.time)
		return
	serumW_cooldown = world.time + serumW_cooldown_time
	if(isliving(target))
		var/mob/living/L = target
		if(!L.stat)
			return TargetSerumW(L)
	var/list/mob/living/carbon/human/death_candidates = list()
	for(var/mob/living/carbon/human/maybe_victim in GLOB.player_list)
		if(faction_check_mob(maybe_victim))
			continue
		if((maybe_victim.stat != DEAD) && maybe_victim.z == z)
			death_candidates += maybe_victim
	if(!LAZYLEN(death_candidates)) // If there is 0 candidates - stop the spell.
		to_chat(src, "<span class='notice'>There is no more human survivors in the facility.</span>")
		return
	if(length(death_candidates) == 1) // Exactly one? Do targeted thing for lulz
		return TargetSerumW(death_candidates[1])
	for(var/i in 1 to 5)
		if(!LAZYLEN(death_candidates)) // No more candidates left? Let's stop picking through the list.
			break
		var/mob/living/carbon/human/H = pick(death_candidates)
		death_candidates.Remove(H)
		if(!istype(H) || QDELETED(H)) // Shouldn't be possible, but here we are
			continue
		addtimer(CALLBACK(src, .proc/eviscerate, H), i*4)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/TargetEviscerate(mob/living/L, obj/effect/eff)
	if(!istype(L) || QDELETED(L))
		charging = FALSE
		return FALSE
	new /obj/effect/temp_visual/emp/pulse(src.loc)
	icon_state = icon_living
	visible_message("<span class='warning'>[src] blinks away!</span>")
	var/turf/tp_loc = get_step(L, pick(GLOB.alldirs))
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	forceMove(tp_loc)
	face_atom(L)
	playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	L.Stun(12, TRUE, TRUE)
	SLEEP_CHECK_DEATH(6)
	qdel(eff)
	if(!istype(L) || QDELETED(L))
		charging = FALSE
		return FALSE
	L.visible_message(
		"<span class='warning'>[src] disappears, taking [L] with them!</span>",
		"<span class='userdanger'>[src] teleports with you through the entire facility!</span>"
		)
	var/list/teleport_turfs = list()
	for(var/turf/T in shuffle(GLOB.department_centers))
		if(T in range(12, src))
			continue
		teleport_turfs += T
	for(var/i = 1 to 5)
		if(!LAZYLEN(teleport_turfs))
			break
		if(!istype(L) || QDELETED(L))
			charging = FALSE
			break
		var/turf/target_turf = pick(teleport_turfs)
		playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		tp_loc.Beam(target_turf, "nzcrentrs_power", time=15)
		playsound(target_turf, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc, src)
		D.color = COLOR_BRIGHT_BLUE
		animate(D, alpha = 0, time = 5)
		forceMove(target_turf)
		for(var/mob/living/LL in range(1, target_turf)) // Attacks everyone around.
			if(faction_check_mob(LL))
				continue
			if(LL == L)
				continue
			to_chat(LL, "<span class='userdanger'>\The [src] slashes you!</span>")
			LL.apply_damage(15, BLACK_DAMAGE, null, LL.run_armor_check(null, BLACK_DAMAGE))
			new /obj/effect/temp_visual/cleave(get_turf(LL))
		tp_loc = get_step(src, pick(1,2,4,5,6,8,9,10))
		for(var/obj/item/I in get_turf(L)) // We take all dropped items with us, just to be fair, you know
			if(I.anchored)
				continue
			I.forceMove(tp_loc)
		var/obj/effect/temp_visual/decoy/DL = new /obj/effect/temp_visual/decoy(L.loc, L)
		DL.color = COLOR_BRIGHT_BLUE
		animate(DL, alpha = 0, time = 5)
		L.forceMove(tp_loc)
		if(i < 5)
			SLEEP_CHECK_DEATH(4)
	if(istype(L) && !QDELETED(L))
		to_chat(L, "<span class='userdanger'>\The [src] slashes you, finally releasing you from his grasp!</span>")
		L.apply_damage(50, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		GiveTarget(L)
	charging = FALSE

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/eviscerate(mob/living/carbon/human/target)
	if(!istype(target) || QDELETED(target))
		return
	var/obj/effect/temp_visual/target_field/uhoh = new /obj/effect/temp_visual/target_field(target.loc)
	uhoh.orbit(target, 0)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
	playsound(src, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 1, 1)
	to_chat(target, "<span class='danger'>The [src] is going to hunt you down!</span>")
	addtimer(CALLBACK(src, .proc/eviscerate2, target, uhoh), 30)

/mob/living/simple_animal/hostile/ordeal/jimbo/proc/eviscerate2(mob/living/carbon/human/target, obj/effect/eff)
	if(!istype(target) || QDELETED(target) || !target.loc)
		qdel(eff)
		return
	if(prob(2) || target.z != z || !target.loc.AllowClick()) // Be happy, mortal. Did you just hide in a locker?
		to_chat(src, "<span class='notice'>Your teleportation device malfunctions!</span>")
		to_chat(target, "<span class='notice'>It seems you are safe. For now...</span>")
		playsound(src.loc, 'ModularTegustation/Tegusounds/claw/error.ogg', 50, 1)
		qdel(eff)
		return
	new /obj/effect/temp_visual/emp/pulse(loc)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc, src)
	D.color = COLOR_BRIGHT_BLUE
	animate(D, alpha = 0, time = 5)
	visible_message("<span class='warning'>[src] blinks away!</span>")
	var/turf/tp_loc = get_step(target.loc, pick(0,1,2,4,5,6,8,9,10))
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	forceMove(tp_loc)
	qdel(eff)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
	GiveTarget(target)
	for(var/mob/living/L in range(1, get_turf(src))) // Attacks everyone around.
		if(faction_check_mob(L))
			continue
		to_chat(target, "<span class='userdanger'>\The [src] eviscerates you!</span>")
		L.apply_damage(75, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		new /obj/effect/temp_visual/cleave(get_turf(L))

