/mob/living/simple_animal/hostile/abnormality/carrey
	name = "A Song For A Season"
	desc = span_userdanger("The ice is melting...")
	health = 1000 // Dummy
	maxHealth = 1000 // Dummy
	pixel_x = -16
	pixel_y = -32
	base_pixel_x = -16
	base_pixel_y = -32
	icon = 'ModularTegustation/Teguicons/64x128.dmi'
	icon_state = "carrey"
	icon_living = "carrey"
	portrait = "carrey"
	del_on_death = FALSE
	can_breach = FALSE // Not... yet
	start_qliphoth = 1337 // Dummy
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 1,
		ABNORMALITY_WORK_INSIGHT = 1,
		ABNORMALITY_WORK_ATTACHMENT = 1,
		ABNORMALITY_WORK_REPRESSION = 1,
		"Request Concert" = 999,
	)
	work_damage_amount = 1
	work_damage_type = WHITE_DAMAGE
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

/mob/living/simple_animal/hostile/abnormality/carrey/Initialize(mapload)
	. = ..()
	start_qliphoth = days_until_christmas()
	if(start_qliphoth > 0)
		icon_state = "contained_greyscale"
		if(start_qliphoth < 24)
			add_overlay(mutable_appearance('ModularTegustation/Teguicons/64x128.dmi', "containmentice[round((start_qliphoth / 4), 1)]"))

/mob/living/simple_animal/hostile/abnormality/carrey/PostSpawn()
	. = ..()
	for(var/turf/open/O in range(1, src))
		new /obj/effect/snow_storm(O)

/mob/living/simple_animal/hostile/abnormality/carrey/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "Request Concert")
		to_chat(user, span_bolddanger("Not yet... I will show you my... grand performance in [start_qliphoth] days."))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/carrey/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	to_chat(user, span_userdanger("You can't take it anymore!"))
	user.spew_organ(10, 5)
	return ..()

/mob/living/simple_animal/hostile/abnormality/carrey/proc/days_until_christmas()
	var/list/dayspermonth = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
	var/MM = text2num(time2text(world.timeofday, "MM"))
	var/DD = text2num(time2text(world.timeofday, "DD"))
	var/goal_month = 12
	var/goal_day = 24
	. = 0

	for(var/i = MM, i < goal_month, i++)
		. += dayspermonth[i]

	if(DD < goal_day)
		. += goal_day - DD
	else
		. += DD - goal_day

/obj/effect/snow_storm
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "snow_storm"
