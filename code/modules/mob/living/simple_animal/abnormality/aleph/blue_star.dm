/mob/living/simple_animal/hostile/abnormality/bluestar
	name = "Blue star"
	desc = "Floating heart-shaped object. It's alive, and soon you will become one with it."
	health = 4000
	maxHealth = 4000
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
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
	work_damage_amount = 18
	work_damage_type = WHITE_DAMAGE

	wander = FALSE
	light_system = MOVABLE_LIGHT
	light_color = COLOR_BLUE_LIGHT
	light_range = 24
	light_power = 7

	var/pulse_cooldown
	var/pulse_cooldown_time = 10 SECONDS
	var/pulse_damage = 40 // Scales with distance

	var/datum/looping_sound/bluestar/soundloop

/mob/living/simple_animal/hostile/abnormality/bluestar/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/bluestar/Destroy()
	QDEL_NULL(soundloop)
	..()

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
	for(var/mob/living/carbon/human/H in range(48, src))
		H.apply_damage((pulse_damage - round(get_dist(src, H) * 0.5)), WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE, forced = TRUE)
		flash_color(H, flash_color = COLOR_BLUE_LIGHT, flash_time = 70)
		if(H.sanity_lost) // TODO: TEMPORARY AS HELL
			H.dust()

/mob/living/simple_animal/hostile/abnormality/bluestar/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
	if(work_time > 40 SECONDS)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/bluestar/breach_effect(mob/living/carbon/human/user)
	..()
	var/X = pick(GLOB.xeno_spawn) // Temporary?
	var/turf/T = get_turf(X)
	light_range = 14
	light_power = 20
	soundloop.start()
	forceMove(T)
	BluePulse()
	return
