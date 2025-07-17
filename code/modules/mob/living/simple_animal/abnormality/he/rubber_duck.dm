//Idea by ArcAngela, strangely enough.
/mob/living/simple_animal/hostile/abnormality/rubber_duck
	name = "Interdimensional Rubber Duck"
	desc = "A small yellow duck."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "duckcontained"
	icon_living = "duckcontained"
	portrait = "rubber_duck"
	maxHealth = 50
	health = 50
	attack_verb_continuous = "quacks"
	attack_verb_simple = "quacks"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	speak_emote = list("quacks")
	density = FALSE	//So you can't hit it with a stray bullet

	can_breach = TRUE
	threat_level = HE_LEVEL
	faction = list("neutral", "hostile")
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 20, 10, 0, 0),
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/squeak,
		/datum/ego_datum/armor/squeak,
	)
//	gift_type =  /datum/ego_gifts/squeak
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL
	var/list/looking_players = list()
	var/list/ignore_abno_list = list(
		/mob/living/simple_animal/hostile/abnormality/training_rabbit,
	)

/mob/living/simple_animal/hostile/abnormality/rubber_duck/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/rubber_duck/Life()
	..()
	if(status_flags & GODMODE)
		return

	for(var/mob/living/carbon/human/H in looking_players)
		if(get_dist(src, H) > 7)	//You're now out of range.
			H.adjustSanityLoss(H.maxSanity * 0.3) // take 30% of your Sanity
			looking_players-=H
			to_chat(H, span_warning("Aren't you forgetting something?"))

	for(var/mob/living/carbon/human/H in view(6, src))
		looking_players |=H

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/rubber_duck/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()

	icon_state = "duck"
	QDEL_IN(src, 5 MINUTES)	//Softlock prevention

	var/turf/T = pick(GLOB.department_centers)
	var/list/tables = list()
	for(var/i=1, i<=3, i++)
		for(var/obj/structure/table/tablecheck in range(7, T))
			tables+=tablecheck
		if(length(tables))
			T = get_turf(pick(tables))
			forceMove(T)
			return
	var/list/all_turfs = RANGE_TURFS(5, src)
	T = get_turf(pick(all_turfs))
	forceMove(T)

/mob/living/simple_animal/hostile/abnormality/rubber_duck/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))


/mob/living/simple_animal/hostile/abnormality/rubber_duck/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if((abno.type in ignore_abno_list) || z != abno.z)
		return
	if(status_flags & GODMODE)
		datum_reference.qliphoth_change(-1)
