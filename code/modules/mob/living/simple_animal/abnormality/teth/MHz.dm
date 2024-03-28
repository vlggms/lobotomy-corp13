/mob/living/simple_animal/hostile/abnormality/mhz
	name = "1.76 MHz"
	desc = "You can't see anything but static."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "mhz"
	icon_living = "mhz"
	portrait = "MHz"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	maxHealth = 400
	health = 400
	start_qliphoth = 4
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = list(40, 30, 20, 20, 20),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 10, 0, 0, 0),
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 60, 60, 60),
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/noise,
		/datum/ego_datum/armor/noise,
	)
	gift_type =  /datum/ego_gifts/noise
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/quiet_day = 1.5,
		/mob/living/simple_animal/hostile/abnormality/khz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/army = 1.5,
	)

	var/reset_time = 4 MINUTES //Qliphoth resets after this time. To prevent bugs

/mob/living/simple_animal/hostile/abnormality/mhz/WorkChance(mob/living/carbon/human/user, chance)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		return chance * 1.25
	return chance

/mob/living/simple_animal/hostile/abnormality/mhz/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	if(pe >= datum_reference.max_boxes)
		datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/mhz/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/mhz/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/mhz/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mhz/ZeroQliphoth(mob/living/carbon/human/user)
	var/rose_available
	for(var/mob/living/simple_animal/hostile/abnormality/staining_rose/J in GLOB.mob_list)
		rose_available = TRUE
		break

	addtimer(CALLBACK (datum_reference, TYPE_PROC_REF(/datum/abnormality, qliphoth_change), 4), reset_time)

	if(!rose_available)
		SSweather.run_weather(/datum/weather/mhz)
		return

	//Rose? Do a different, neutered effect
	for(var/mob/living/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.z != z || L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/dir_setting/ninja(get_turf(L))
		L.apply_damage(20, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)



//We're gonna make it a weather that affects all hallways.
//We've tried the spreading stuff effect with Snow White and it's super laggy. Having 2 at once would be horrible.
/datum/weather/mhz
	name = "static"
	immunity_type = "static"
	desc = "Static created by 1.76 MHz."
	telegraph_message = span_warning("You hear something in the distance.")
	telegraph_duration = 300
	weather_message = span_userdanger("<i>Are.... those the sounds of humans wailing? Are they suffering?</i>")
	weather_overlay = "mhz"
	weather_duration_lower = 1200		//2-3 minutes.
	weather_duration_upper = 1800
	end_duration = 100
	end_message = span_boldannounce("It's all calm once more. You feel at peace.")
	area_type = /area/facility_hallway
	target_trait = ZTRAIT_STATION

/datum/weather/mhz/weather_act(mob/living/carbon/human/L)
	if(ishuman(L))
		L.apply_damage(5, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
