/mob/living/simple_animal/hostile/abnormality/dreaming_current
	name = "\proper The Dreaming Current"
	desc = "An abnormality resembling a cobalt blue shark with legs. \
	There's a syringe embedded in a side of its body, and there are multiple injection holes on its lower body."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "current"
	icon_living = "current"
	portrait = "dreaming_current"
	pixel_x = -16
	base_pixel_x = -16

	ranged = TRUE
	maxHealth = 2000
	health = 2000
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	stat_attack = HARD_CRIT
	death_sound = 'sound/abnormalities/dreamingcurrent/dead.ogg'

	threat_level = WAW_LEVEL

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 60, 55, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(45, 45, 45, 50, 55),
		ABNORMALITY_WORK_REPRESSION = 45,
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	can_breach = TRUE
	start_qliphoth = 2
	can_patrol = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/ecstasy,
		/datum/ego_datum/armor/ecstasy,
	)
	gift_type = /datum/ego_gifts/ecstasy
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/siltcurrent = 2
	)

	var/list/movement_path = list()
	var/list/been_hit = list()
	var/charging = FALSE
	var/dash_cooldown
	var/dash_cooldown_time = 8 SECONDS
	var/dash_damage = 200
	/// Delay between each subsequent move when charging
	var/dash_speed = 0.8
	/// How many paths do we create between several landmarks?
	var/dash_nodes = 6
	/// Maximum AStar pathfinding distances from one point to another
	var/dash_max_distance = 40
	var/datum/looping_sound/dreamingcurrent/soundloop
	var/alt_icon = FALSE

/mob/living/simple_animal/hostile/abnormality/dreaming_current/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)
	if(prob(1))
		icon_state = "blahaj"
		icon_living = "blahaj"
		alt_icon = TRUE
		pixel_x = -16
		gift_type =  /datum/ego_gifts/blahaj

/mob/living/simple_animal/hostile/abnormality/dreaming_current/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/abnormality/dreaming_current/AttackingTarget()
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/dreaming_current/Move()
	return FALSE // Can only forceMove

/mob/living/simple_animal/hostile/abnormality/dreaming_current/OpenFire()
	ChargeStart(target)
	return

/mob/living/simple_animal/hostile/abnormality/dreaming_current/Life()
	. = ..()
	if((status_flags & GODMODE) && prob(2)) // Contained
		if(!alt_icon)
			icon_state = "current_bubble"
		playsound(src, "sound/effects/bubbles.ogg", 30, TRUE)
		SLEEP_CHECK_DEATH(12)
		icon_state = icon_living
	if(.)
		if((dash_cooldown <= world.time) && prob(15))
			ChargeStart()

/mob/living/simple_animal/hostile/abnormality/dreaming_current/proc/ChargeStart(target)
	if(charging || dash_cooldown > world.time)
		return
	charging = TRUE
	movement_path = list()
	var/list/initial_turfs = GLOB.xeno_spawn.Copy() + GLOB.department_centers.Copy()
	var/list/potential_turfs = list()
	for(var/turf/open/T in initial_turfs)
		if(get_dist(src, T) > 3)
			potential_turfs += T
	for(var/mob/living/L in livinginrange(32, src))
		if(prob(50))
			continue
		if((L.status_flags & GODMODE) || faction_check_mob(L))
			continue
		if(L.stat == DEAD)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.is_working)
				continue
		potential_turfs += get_turf(L)
	var/turf/picking_from = get_turf(src)
	var/turf/path_start = get_turf(src)
	if(target)
		var/turf/open/target_turf = get_turf(target)
		if(istype(target_turf))
			picking_from = target_turf
			potential_turfs |= target_turf
		face_atom(target)
	for(var/i = 1 to dash_nodes)
		if(!LAZYLEN(potential_turfs))
			break
		var/turf/T = get_closest_atom(/turf/open, potential_turfs, picking_from)
		if(!T)
			break
		var/list/our_path = list()
		for(var/o = 1 to 3) // Grand total of 3 retries
			our_path = get_path_to(path_start, T, TYPE_PROC_REF(/turf, Distance_cardinal), dash_max_distance)
			if(islist(our_path) && LAZYLEN(our_path))
				break
			potential_turfs -= T // Couldn't find path to it, don't try again
			if(!LAZYLEN(potential_turfs))
				break
			T = get_closest_atom(/turf/open, potential_turfs, picking_from)
		if(!islist(our_path) || !LAZYLEN(our_path))
			continue
		movement_path += our_path
		picking_from = T
		path_start = T
		potential_turfs -= T
	if(!LAZYLEN(movement_path))
		return FALSE
	if(!alt_icon)
		icon_state = "current_prepare"
	playsound(src, "sound/effects/bubbles.ogg", 50, TRUE, 7)
	for(var/turf/T in movement_path) // Warning before charging
		new /obj/effect/temp_visual/sparks/quantum(T)
	SLEEP_CHECK_DEATH(18)
	been_hit = list()
	if(!alt_icon)
		icon_state = "current_attack"
	for(var/turf/T in movement_path)
		if(QDELETED(T))
			break
		if(!Adjacent(T))
			break
		ChargeAt(T)
		SLEEP_CHECK_DEATH(dash_speed)
	charging = FALSE
	icon_state = icon_living
	dash_cooldown = world.time + dash_cooldown_time

/mob/living/simple_animal/hostile/abnormality/dreaming_current/proc/ChargeAt(turf/T)
	face_atom(T)
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("teeth")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK (D, TYPE_PROC_REF(/obj/machinery/door, open)))
	forceMove(T)
	if(prob(33))
		playsound(T, "sound/abnormalities/dreamingcurrent/move.ogg", 10, TRUE, 3)
	for(var/turf/TF in view(1, T))
		var/obj/effect/temp_visual/small_smoke/halfsecond/S = new(TF)
		var/list/potential_colors = list(
			COLOR_LIGHT_GRAYISH_RED,
			COLOR_SOFT_RED,
			COLOR_YELLOW,
			COLOR_VIBRANT_LIME,
			COLOR_GREEN,
			COLOR_CYAN,
			COLOR_BLUE,
			COLOR_PINK,
			COLOR_PURPLE,
		)
		S.add_atom_colour(pick(potential_colors), FIXED_COLOUR_PRIORITY)
		var/list/new_hits = HurtInTurf(TF, been_hit, dash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			visible_message(span_boldwarning("[src] bites [L]!"))
			new /obj/effect/temp_visual/cleave(get_turf(L))
			playsound(L, "sound/abnormalities/dreamingcurrent/bite.ogg", 50, TRUE)
			if(L.health < 0)
				L.gib()

/mob/living/simple_animal/hostile/abnormality/dreaming_current/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/dreaming_current/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/dreaming_current/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT) // Floating
	if(!alt_icon)
		icon_living = "current_breach"
		icon_state = icon_living
