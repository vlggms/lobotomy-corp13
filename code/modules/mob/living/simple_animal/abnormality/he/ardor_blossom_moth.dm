/mob/living/simple_animal/hostile/abnormality/ardor_moth
	name = "Ardor Blossom Moth"
	desc = "A moth seemingly made of fire."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	pixel_x = -8
	base_pixel_x = -8
	icon_state = "blossom_moth"
	icon_living = "blossom_moth"
	portrait = "blossom_moth"
	maxHealth = 1200
	health = 1200
	blood_volume = 0
	ranged = TRUE
	attack_verb_continuous = "sears"
	attack_verb_simple = "sear"
	is_flying_animal = TRUE
	stat_attack = HARD_CRIT
	melee_damage_lower = 11
	melee_damage_upper = 12
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2, FIRE = 0.2)
	speak_emote = list("flutters")
	vision_range = 14
	aggro_vision_range = 20

	can_breach = TRUE
	threat_level = HE_LEVEL
	faction = list("neutral", "hostile")
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = 20,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 7
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	patrol_cooldown_time = 3 SECONDS

	ego_list = list(
		/datum/ego_datum/weapon/ardor_star,
		/datum/ego_datum/armor/ardor_star,
	)
//	gift_type =  /datum/ego_gifts/ardor_moth
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "Orange circles float in the air before your eyes. <br>\
		The lights flutter and dance in the air, creating a haze. <br>\
		Something is burning to death within. <br>\
		Would you be scorched as well if the flames touched you?"
	observation_choices = list(
		"Reach out" = list(TRUE, "Enchanted by the haze, you extend a finger, <br>\
			waiting for one of the lights to land. <br>\
			A glimmering ball gently perches on your digit. <br>\
			Then, a fire engulfs it. <br>\
			Another glow attaches to your body, then four, then eight. <br>\
			They multiply until you have been entirely shrouded in light."),
		"Turn around" = list(FALSE, "Resisting the temptation to reach out, <br>\
			you decide it’s better to stay away from such dubious warmth. <br>\
			You feel a cold wave crawl up your spine in an instant, but it may be the right choice. <br>\
			Even children know not to play with fire."),
	)

	var/stoked

/mob/living/simple_animal/hostile/abnormality/ardor_moth/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(stoked)
		chance+=10
		datum_reference.qliphoth_change(1)
	return chance

/mob/living/simple_animal/hostile/abnormality/ardor_moth/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(!stoked && work_type != ABNORMALITY_WORK_ATTACHMENT)
		if(prob(30))
			datum_reference.qliphoth_change(-2)
	stoked = FALSE

	switch(work_type)
		if(ABNORMALITY_WORK_ATTACHMENT)
			stoked = TRUE
			to_chat(user, span_notice("You stoke the flames, and it burns hotter."))

/mob/living/simple_animal/hostile/abnormality/ardor_moth/Move()
	..()
	for(var/turf/open/T in range(1, src))
		if(locate(/obj/effect/turf_fire) in T)
			for(var/obj/effect/turf_fire/floor_fire in T)
				qdel(floor_fire)
		new /obj/effect/turf_fire(T)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/spawn_gibs()
	return new /obj/effect/decal/cleanable/ash(drop_location(), src)

// Turf Fire
/obj/effect/turf_fire
	gender = PLURAL
	name = "fire"
	desc = "a burning pyre."
	icon = 'icons/effects/effects.dmi'
	icon_state = "turf_fire"
	anchored = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	base_icon_state = "turf_fire"
	var/damaging = FALSE

/obj/effect/turf_fire/Initialize()
	. = ..()
	QDEL_IN(src, 30 SECONDS)

//Red and not burn, burn is a special damage type.
/obj/effect/turf_fire/Crossed(atom/movable/AM)
	. = ..()
	if(!damaging)
		damaging = TRUE
		DoDamage()

/obj/effect/turf_fire/proc/DoDamage()
	var/dealt_damage = FALSE
	for(var/mob/living/L in get_turf(src))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.deal_damage(4, FIRE)
			H.apply_lc_burn(2)
			dealt_damage = TRUE
	if(!dealt_damage)
		damaging = FALSE
		return
	addtimer(CALLBACK(src, PROC_REF(DoDamage)), 4)
