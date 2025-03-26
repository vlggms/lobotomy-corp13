/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony
	name = "Ascension Ceremony"
	desc = "An empty space suit. The inside and outside have become one."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "spaceman"
	icon_living = "spaceman"
	threat_level = WAW_LEVEL
	can_breach = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 50, 60, 60),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 40, 50),
		ABNORMALITY_WORK_ATTACHMENT = 10,
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 40, 50),
	)
	work_damage_amount = 8
	work_damage_type = PALE_DAMAGE
	del_on_death = TRUE
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	maxHealth = 1800
	health = 1800
	move_to_delay = 8
	can_patrol = TRUE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 0.5)
	is_flying_animal = TRUE
	faction = list("hostile", "neutral")
	start_qliphoth = 2

	var/datum/looping_sound/bluestar/soundloop
	var/list/spaceturfs = list()

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/WorktickFailure(mob/living/carbon/human/user)
	user.apply_damage(9, OXY, null, user.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	..()

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/Life()
	..()
	for(var/turf/T in view(12,src))
		spaceturfs |= T
		T.AddElement(/datum/element/forced_gravity, 0)
	if(!IsContained())
		for(var/mob/living/carbon/H in view(12,src))
			H.apply_damage(9, OXY, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/mermaid_drowning(get_turf(H))


/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/death()
	..()
	for(var/turf/T in spaceturfs)
		addtimer(CALLBACK(T, TYPE_PROC_REF(/datum, _RemoveElement), list(0)), 20)
	QDEL_NULL(soundloop)

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	user.adjustOxyLoss(-100)

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	soundloop.start()

