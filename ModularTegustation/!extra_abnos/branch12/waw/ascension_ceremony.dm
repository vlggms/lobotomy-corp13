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

	ego_list = list(
		/datum/ego_datum/weapon/branch12/plasmacoree6,
		/datum/ego_datum/weapon/branch12/antique,
		/datum/ego_datum/armor/branch12/plasmacoree6,
	)

	var/datum/looping_sound/bluestar/soundloop
	var/list/spaceturfs = list()
	var/list/spaceeffects = list()
	patrol_cooldown_time = 5 SECONDS	//Tends to get stuck

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	soundloop = new(list(src), FALSE)
	if(prob(30))
		icon_state = "void"

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/Destroy()
	QDEL_NULL(soundloop)
	for(var/turf/T in spaceturfs)
		T.AddElement(/datum/element/forced_gravity, 1, TRUE)
	for(var/V in spaceeffects)
		qdel(V)
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
		if(T in spaceturfs)
			continue
		spaceturfs += T
		T.AddElement(/datum/element/forced_gravity, 0)

		var/obj/effect/ascensionsparkles/S = new (get_turf(T))
		spaceeffects+=S
	if(!IsContained())
		for(var/mob/living/carbon/H in view(12,src))
			H.apply_damage(9, OXY, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/mermaid_drowning(get_turf(H))


/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	user.adjustOxyLoss(-100)

/mob/living/simple_animal/hostile/abnormality/branch12/ascension_ceremony/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	soundloop.start()

/obj/effect/ascensionsparkles
	gender = PLURAL
	name = "sparkles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	anchored = TRUE
	alpha = 50
