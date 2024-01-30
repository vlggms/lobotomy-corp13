/mob/living/simple_animal/hostile/abnormality/queen_bee
	name = "Queen Bee"
	desc = "A disfigured creature resembling a bee queen."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "queen_bee"
	icon_living = "queen_bee"
	portrait = "queen_bee"
	faction = list("hostile")
	speak_emote = list("buzzes")

	pixel_x = -8
	base_pixel_x = -8

	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 45, 45, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 55, 55, 60),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/hornet,
		/datum/ego_datum/weapon/tattered_kingdom,
		/datum/ego_datum/armor/hornet,
	)
	gift_type =  /datum/ego_gifts/hornet
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/general_b = 5,
	)

	var/datum/looping_sound/queenbee/soundloop
	var/breached_others = FALSE

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
		for(var/mob/living/simple_animal/hostile/abnormality/general_b/Y in T.contents)
			if(breached_others == FALSE)
				Y.BreachEffect()
				breached_others = TRUE

/mob/living/simple_animal/hostile/abnormality/queen_bee/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/queen_bee/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/queen_bee/ZeroQliphoth(mob/living/carbon/human/user)
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
	base_pixel_x = -8
	health = 450
	maxHealth = 450
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 14
	melee_damage_upper = 18
	rapid_melee = 2
	obj_damage = 200
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	death_sound = 'sound/abnormalities/bee/death.ogg'
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
		visible_message(span_danger("[src] bites hard on \the [H] as another bee appears!"))
		H.emote("scream")
		H.gib()
		new /mob/living/simple_animal/hostile/worker_bee(T)
