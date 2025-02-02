/mob/living/simple_animal/hostile/abnormality/branch12/world_sage
	name = "Sage of The World"
	desc = "A 4-colored jester humanoid."
	health = 5000
	maxHealth = 5000
	icon = 'ModularTegustation/Teguicons/branch12/48x48.dmi'
	icon_state = "jester_of_aces"
	icon_living = "jester_of_aces"
	pixel_x = -8
	base_pixel_x = -8

	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 30, 35, 40, 45),
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 35, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 30, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
	)


	work_damage_amount = 15
	work_damage_type = WHITE_DAMAGE
	can_patrol = FALSE
	wander = FALSE

	ego_list = list(
		//datum/ego_datum/weapon/branch12/XXI,
		/datum/ego_datum/armor/branch12/XXI,
	)
	//gift_type =  /datum/ego_gifts/insanity
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/meltdown_cooldown_time = 10 MINUTES
	var/meltdown_cooldown
	var/pulse_cooldown
	var/pulse_cooldown_time = 8 SECONDS
	var/list/effect_tiles = list()
	var/worked

/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/AttackingTarget(atom/attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	worked = TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/WorktickFailure(mob/living/carbon/human/user)
	var/list/damtypes = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	var/damage = pick(damtypes)
	work_damage_type = damage
	user.deal_damage(work_damage_amount, damage)
	WorkDamageEffect()

/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/death()
	..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "Ciao ladies! Thank you for the show! 'Til we meet again!", 25))
	for(var/V in effect_tiles)
		qdel(V)
		effect_tiles-=V

/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/BreachEffect()
	..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "Hahaha! It's finally time to start the show!", 25))
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	TileSwap()
	return

/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/Life()
	. = ..()
	if(!.) // Dead
		return FALSE

	if(meltdown_cooldown < world.time && !datum_reference.working)
		if(worked)
			worked = FALSE
			return
		meltdown_cooldown = world.time + meltdown_cooldown_time
		datum_reference.qliphoth_change(-1)

	//Pulse stuff
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		pulse_cooldown = world.time + pulse_cooldown_time
		if(prob(40))
			TileSwap()
		else
			FireBalls()


//Unique attacks
/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/proc/TileSwap()
	for(var/V in effect_tiles)
		qdel(V)
		effect_tiles-=V

	emote("giggles")
	SLEEP_CHECK_DEATH(10)


	var/list/all_turfs = RANGE_TURFS(7, src)
	for(var/turf/open/F in all_turfs)
		if(prob(30))
			var/to_spawn = pick(/obj/structure/jester_tile/red,
					/obj/structure/jester_tile/white,
					/obj/structure/jester_tile/black,
					/obj/structure/jester_tile/pale,
					/obj/structure/jester_tile/stun,
					/obj/structure/jester_tile/drugs,
					/obj/structure/jester_tile/statdown,
					)
			new to_spawn(F)


/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/proc/FireBalls()
	emote("laughs")
	SLEEP_CHECK_DEATH(10)

	//small AOE pushback
	goonchem_vortex(get_turf(src), 0, 3)
	for(var/turf/T in view(3, src))
		if(T.density)
			continue
		new /obj/effect/temp_visual/revenant(T)

	//Bouncing balls
	if(!targets_from)
		return
	var/turf/startloc = get_turf(targets_from)
	for(var/i = 1 to 7)
		var/obj/projectile/sage_ball/P = new(get_turf(src))
		P.starting = startloc
		P.firer = src
		P.fired_from = src
		P.yo = 1 - startloc.y
		P.xo = 1 - startloc.x
		P.original = target
		P.preparePixelProjectile(src, src)
		P.fire()

/obj/projectile/sage_ball
	name = "sage ball"
	icon_state = "jester_ball"
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	desc = "A beam of black light."
	damage_type = RED_DAMAGE
	speed = 5
	damage = 40		//She fires a lot of them
	projectile_piercing = ALL
	ricochets_max = 3
	ricochet_chance = 100
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1 // Does MORE per bounce
	ricochet_auto_aim_range = 3
	ricochet_incidence_leeway = 0
	spread = 360	//Fires in a 360 Degree radius
	white_healing = FALSE

/obj/projectile/sage_ball/Initialize()
	..()
	damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/obj/projectile/sage_ball/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	if(istype(A, /obj/structure) && A.density)
		return TRUE
	return FALSE

// Jester Tiles
/obj/structure/jester_tile
	gender = PLURAL
	name = "Jester Tile"
	desc = "Don't step on me!"
	icon = 'ModularTegustation/Teguicons/branch12/sage_tiles.dmi'
	icon_state = "red"
	alpha = 180
	anchored = TRUE
	density = FALSE
	layer = SPACEVINE_LAYER
	plane = 4
	max_integrity = 100000
	base_icon_state = "red"
	var/mob/living/simple_animal/hostile/abnormality/branch12/world_sage/connected_abno

/obj/structure/jester_tile/Initialize()
	. = ..()
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/branch12/world_sage) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.effect_tiles += src

/obj/structure/jester_tile/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.deal_damage(RED_DAMAGE, 30)


// Jester Tiles
/obj/structure/jester_tile/red
	name = "Red Tile"
	icon_state = "red"

/obj/structure/jester_tile/red/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(50, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)


/obj/structure/jester_tile/white
	name = "White Tile"
	icon_state = "white"

/obj/structure/jester_tile/white/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(50, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)


/obj/structure/jester_tile/black
	name = "Black Tile"
	icon_state = "black"

/obj/structure/jester_tile/black/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(50, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)


/obj/structure/jester_tile/pale
	name = "Pale Tile"
	icon_state = "pale"

/obj/structure/jester_tile/pale/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(50, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)


/obj/structure/jester_tile/stun
	name = "Stun Tile"
	icon_state = "stun"

/obj/structure/jester_tile/stun/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.Stun(5, ignore_canstun = TRUE) // Here we go.
		H.Knockdown(5)


/obj/structure/jester_tile/drugs
	name = "Confusion Tile"
	icon_state = "confusion"

/obj/structure/jester_tile/drugs/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.set_drugginess(15)


/obj/structure/jester_tile/statdown
	name = "Stat Down Tile"
	icon_state = "statdown"

/obj/structure/jester_tile/statdown/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.adjust_all_attribute_levels(-1)

