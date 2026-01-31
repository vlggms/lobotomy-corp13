/mob/living/simple_animal/hostile/ordeal/amber_midnight
	name = "eternal meal"
	desc = "A giant insect-like creature with a ton of sharp rocky teeth."
	health = 5000
	maxHealth = 5000
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8)
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "ambermidnight"
	icon_living = "ambermidnight"
	icon_dead = "ambermidnight_dead"
	faction = list("amber_ordeal")

	light_color = COLOR_YELLOW
	light_range = 4
	light_power = 1

	density = FALSE
	alpha = 0
	pixel_x = -96
	base_pixel_x = -96
	pixel_y = -16
	base_pixel_y = -16
	occupied_tiles_left = 1
	occupied_tiles_right = 1
	occupied_tiles_up = 2
	offsets_pixel_x = list("south" = -96, "north" = -96, "west" = -96, "east" = -96)
	offsets_pixel_y = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	damage_effect_scale = 1.25

	blood_volume = BLOOD_VOLUME_NORMAL
	death_sound = 'sound/effects/ordeals/amber/midnight_dead.ogg'

	var/burrowing = FALSE
	var/burrow_cooldown
	var/burrow_cooldown_time = 20 SECONDS
	var/list/spawned_mobs = list()

	var/datum/looping_sound/ambermidnight/soundloop

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Initialize()
	. = ..()
	burrow_cooldown = world.time + 20 SECONDS
	soundloop = new(list(src), TRUE)
	addtimer(CALLBACK(src, PROC_REF(BurrowOut)))

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Destroy()
	QDEL_NULL(soundloop)
	for(var/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/bug as anything in spawned_mobs)
		bug.bug_daddy = null
	spawned_mobs = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/death(gibbed)
	alpha = 255
	soundloop.stop()
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!burrowing && world.time > burrow_cooldown)
		AttemptBirth()
		BurrowIn()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/AttemptBirth()
	var/max_spawn = clamp(length(GLOB.clients) * 0.6, 2, 8)
	if(length(spawned_mobs) >= max_spawn)
		return FALSE

	burrowing = TRUE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_create.ogg', 50, FALSE)
	SLEEP_CHECK_DEATH(2 SECONDS)
	visible_message(span_danger("Two large bugs emerge from [src]!"))
	for(var/i = 1 to 2)
		var/turf/T = get_step(get_turf(src), pick(GLOB.alldirs))
		var/mob/living/simple_animal/hostile/ordeal/amber_dusk/spawned/bug = new(T)
		spawned_mobs += bug
		bug.bug_daddy = src
		if(ordeal_reference)
			bug.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += bug

	SLEEP_CHECK_DEATH(2 SECONDS)
	burrowing = FALSE

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/BurrowIn()
	burrowing = TRUE
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(src, 'sound/effects/ordeals/amber/midnight_in.ogg', 50, FALSE, 7)
	icon_state = "ambermidnight_leave"
	new /obj/effect/temp_visual/ambermidnight_hole(get_turf(src))
	var/list/centers = GLOB.department_centers.Copy()
	centers -= get_turf(src)
	for(var/turf/T in centers)
		if(locate(type) in T) // Found another amber midnight there
			centers -= T
	SLEEP_CHECK_DEATH(9)
	animate(src, alpha = 0, time = 1)
	density = FALSE
	for(var/turf/T in centers) // We do it twice in case something changed in that time
		if(locate(type) in T)
			centers -= T
	var/turf/T = get_turf(src)
	if(LAZYLEN(centers))
		T = pick(centers)
	SLEEP_CHECK_DEATH(1)
	forceMove(T)
	BurrowOut()

/mob/living/simple_animal/hostile/ordeal/amber_midnight/proc/BurrowOut()
	burrowing = TRUE
	alpha = 0
	density = FALSE
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out_far.ogg', 50, TRUE, 4)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out.ogg', 75, FALSE, 7)
	new /obj/effect/temp_visual/ambersmoke(get_turf(src))
	animate(src, pixel_z = 0, alpha = 255, time = 1)
	icon_state = "ambermidnight_bite"
	visible_message(span_danger("[src] burrows out from the ground!"))
	SLEEP_CHECK_DEATH(8)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out_far.ogg', 25, FALSE, 24, 2, falloff_distance = 9)
	SLEEP_CHECK_DEATH(2)
	density = TRUE
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*1.25, time = 3)
	SLEEP_CHECK_DEATH(2)
	var/alternate = TRUE // we dont need 50 smoke effects
	for(var/turf/open/T in view(7, src))
		if(alternate)
			var/obj/effect/temp_visual/small_smoke/halfsecond/SS = new(T)
			SS.color = LIGHT_COLOR_ORANGE
			alternate = FALSE
		else
			alternate = TRUE
	for(var/mob/living/L in view(7, src))
		if(faction_check_mob(L))
			continue
		var/distance_decrease = get_dist(src, L) * 40
		L.deal_damage((400 - distance_decrease), RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
		if(L.health < 0)
			L.gib()
	SLEEP_CHECK_DEATH(5)
	burrow_cooldown = world.time + burrow_cooldown_time
	burrowing = FALSE
	icon_state = icon_living

/obj/effect/temp_visual/ambersmoke
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke"
	duration = 1.5 SECONDS
	color = COLOR_ORANGE
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32

/obj/effect/temp_visual/ambermidnight_hole
	name = "hole"
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "ambermidnight_hole"
	duration = 10 SECONDS
	pixel_x = -96
	base_pixel_x = -96
	pixel_y = -16
	base_pixel_y = -16

/obj/effect/temp_visual/ambermidnight_hole/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)
