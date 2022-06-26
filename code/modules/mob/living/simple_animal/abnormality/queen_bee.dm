/mob/living/simple_animal/hostile/abnormality/queen_bee
	name = "queen bee"
	desc = "A disfigured creature resembling a bee queen."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "queen_bee"
	icon_living = "queen_bee"
	faction = list("hostile")
	speak_emote = list("buzzes")

	pixel_x = -8
	base_pixel_x = -8

	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 20,
						ABNORMALITY_WORK_INSIGHT = 25,
						ABNORMALITY_WORK_ATTACHMENT = 15,
						ABNORMALITY_WORK_REPRESSION = 0
						)
	work_damage_amount = 8
	work_damage_type = RED_DAMAGE

	var/datum/looping_sound/queenbee/soundloop

/mob/living/simple_animal/hostile/abnormality/queen_bee/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/queen_bee/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/abnormality/queen_bee/proc/emit_spores()
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	turf_list = spiral_range_turfs(36, target_c)
	playsound(target_c, 'sound/abnormalities/bee/spores.ogg', 50, 1, 5)
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/bee_gas(T)
		for(var/mob/living/carbon/human/H in T.contents)
			if(prob(90))
				var/datum/disease/bee_spawn/D = new()
				H.ForceContractDisease(D, FALSE, TRUE)

/mob/living/simple_animal/hostile/abnormality/queen_bee/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

// Additional effects on work failure
/mob/living/simple_animal/hostile/abnormality/queen_bee/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/queen_bee/zero_qliphoth(mob/living/carbon/human/user)
	emit_spores()
	datum_reference.qliphoth_change(1)
	return

/* Worker bees */
/mob/living/simple_animal/hostile/worker_bee
	name = "worker bee"
	desc = "A disfigured creature with nasty fangs."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "worker_bee"
	icon_living = "worker_bee"
	health = 400
	maxHealth = 400
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 14
	melee_damage_upper = 18
	obj_damage = 200
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	deathsound = 'sound/abnormalities/bee/death.ogg'
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("buzzes")

/mob/living/simple_animal/hostile/worker_bee/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/bee/birth.ogg', 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/worker_bee/AttackingTarget()
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.health <= 0)
		var/turf/T = get_turf(H)
		visible_message("<span class='danger'>[src] bites hard on \the [H] as another bee appears!</span>")
		H.emote("scream")
		H.gib()
		new /mob/living/simple_animal/hostile/worker_bee(T)
