/mob/living/simple_animal/hostile/abnormality/bluestar
	name = "Blue star"
	desc = "Floating heart-shaped object. It's alive, and soon you will become one with it."
	health = 4000
	maxHealth = 4000
	pixel_x = -16
	base_pixel_x = -16
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "bluestar"
	icon_living = "bluestar"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.1)
	is_flying_animal = TRUE
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 30,
						ABNORMALITY_WORK_INSIGHT = 50,
						ABNORMALITY_WORK_ATTACHMENT = 0,
						ABNORMALITY_WORK_REPRESSION = 40
						)
	work_damage_amount = 16
	work_damage_type = WHITE_DAMAGE

	wander = FALSE
	light_system = MOVABLE_LIGHT
	light_color = COLOR_BLUE_LIGHT
	light_range = 24
	light_power = 14

	ego_list = list(
		/datum/ego_datum/weapon/star_sound,
		/datum/ego_datum/armor/star_sound
		)

	var/pulse_cooldown
	var/pulse_cooldown_time = 9 SECONDS
	var/pulse_damage = 36 // Scales with distance

	var/datum/looping_sound/bluestar/soundloop

/mob/living/simple_animal/hostile/abnormality/bluestar/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/bluestar/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/abnormality/bluestar/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bluestar/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		BluePulse()

/mob/living/simple_animal/hostile/abnormality/bluestar/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bluestar/proc/BluePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 100, FALSE, 28)
	var/matrix/init_transform = transform
	animate(src, transform = transform*2, time = 3, easing = BACK_EASING|EASE_OUT)
	for(var/mob/living/L in urange(48, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage((pulse_damage - round(get_dist(src, L) * 0.75)), WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		flash_color(L, flash_color = COLOR_BLUE_LIGHT, flash_time = 70)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.sanity_lost) // TODO: TEMPORARY AS HELL
			H.death()
			animate(H, transform = H.transform*0.01, time = 5)
			QDEL_IN(H, 5)
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/abnormality/bluestar/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
	if(work_time > 40 SECONDS)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/bluestar/breach_effect(mob/living/carbon/human/user)
	..()
	var/turf/T = pick(GLOB.department_centers)
	soundloop.start()
	forceMove(T)
	BluePulse()
	return
