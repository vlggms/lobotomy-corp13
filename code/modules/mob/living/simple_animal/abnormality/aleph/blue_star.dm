/mob/living/simple_animal/hostile/abnormality/bluestar
	name = "Blue Star"
	desc = "Floating heart-shaped object. It's alive, and soon you will become one with it."
	health = 4000
	maxHealth = 4000
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -16
	base_pixel_y = -16
	offsets_pixel_x = list("south" = -32, "north" = -32, "west" = -32, "east" = -32)
	offsets_pixel_y = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	occupied_tiles_up = 1
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "blue_star"
	icon_living = "blue_star"
	icon_dead = "blue_star_dead"
	portrait = "blue_star"
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
	is_flying_animal = TRUE
	del_on_death = FALSE
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_amount = 16
	work_damage_type = WHITE_DAMAGE
	can_patrol = FALSE

	wander = FALSE
	light_color = COLOR_BLUE_LIGHT
	light_range = 36
	light_power = 20

	del_on_death = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/star_sound,
		/datum/ego_datum/armor/star_sound,
	)
	gift_type =  /datum/ego_gifts/star
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "A group of employees worship this abnormality, despite the fact nothing can be sacred in this place. <br>\
		You recall how you pulled away one employee away from it in the past, even as she screamed and wailed that you were keeping her chained to this world. <br>You thought you were saving her. <br>\
		You can hear a distant howl emanating from the centre of the blue-coloured heart. <br>It's the sound of stars. <br>They're welcoming you, asking you to join them as a star."
	observation_choices = list(
		"Be pulled in" = list(TRUE, "You don't hesitate as you approach the centre of the void. <br>Sensation in your hands and legs are the first things to go, creeping up your body until you couldn't feel anything physical at all. <br>\
			Despite how scary it should have been, you feel at peace, <br>this isn't an end it's a new beginning - You're a martyr. <br>\
			Let's meet everyone again, as stars."),
		"Hold yourself tight" = list(FALSE, "You wrapped your arms around yourself and shut your eyes, turning your senses inward until the temptation passes and the sounds become distant howls again. <br>\
			You opened your eyes and looked again at the heart. <br>It remains in the air, floating towards a new beginning."),
	)

	var/pulse_cooldown
	var/pulse_cooldown_time = 12 SECONDS
	var/pulse_damage = 120 // Scales with distance; Ideally, you shouldn't be able to outheal it with white V armor or less

	var/datum/looping_sound/bluestar/soundloop

/mob/living/simple_animal/hostile/abnormality/bluestar/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/bluestar/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/bluestar/death(gibbed)
	QDEL_NULL(soundloop)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
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
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 100, FALSE, 40, falloff_distance = 10)
	var/matrix/init_transform = transform
	animate(src, transform = transform*1.5, time = 3, easing = BACK_EASING|EASE_OUT)
	for(var/mob/living/L in livinginrange(48, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		L.deal_damage((pulse_damage - get_dist(src, L)), WHITE_DAMAGE)
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

/mob/living/simple_animal/hostile/abnormality/bluestar/AttemptWork(mob/living/carbon/human/user, work_type)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
		playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 25, FALSE, 28)
		user.death()
		animate(user, transform = user.transform*0.01, time = 5)
		QDEL_IN(user, 5)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/bluestar/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 100)
		datum_reference.qliphoth_change(-1)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	if(work_time > 40 SECONDS)
		datum_reference.qliphoth_change(-1)
		playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 25, FALSE, 28)
		user.death()
		animate(user, transform = user.transform*0.01, time = 5)
		QDEL_IN(user, 5)
	return

/mob/living/simple_animal/hostile/abnormality/bluestar/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	soundloop.start()
	forceMove(T)
	BluePulse()
	return
