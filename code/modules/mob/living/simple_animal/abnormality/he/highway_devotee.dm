/mob/living/simple_animal/hostile/abnormality/highway_devotee
	name = "Highway Devotee"
	desc = "A giant form holding a 'road closed' sign."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "highway_devotee"
	icon_living = "highway_devotee"
	portrait = "highway_devotee"
	maxHealth = 1200
	health = 1200
	ranged = TRUE
	attack_verb_continuous = "scorns"
	attack_verb_simple = "scorn"
	damage_coeff = list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	speak_emote = list("rasps")
	pixel_x = -16

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
	work_damage_amount = 11
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/uturn,
		/datum/ego_datum/armor/uturn,
	)
	gift_type =  /datum/ego_gifts/uturn
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/talk = FALSE
	var/list/structures = list()

/mob/living/simple_animal/hostile/abnormality/highway_devotee/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/highway_devotee/Life()
	..()
	//Only say this once
	if(talk)
		return
	for(var/mob/living/carbon/human/H in view(5, src))
		say("If you take this road, it'll take ages to come back here.")
		talk = TRUE
		break

/mob/living/simple_animal/hostile/abnormality/highway_devotee/death(gibbed)
	for(var/obj/Y in structures)
		qdel(Y)
	..()

/mob/living/simple_animal/hostile/abnormality/highway_devotee/proc/KillYourself()
	for(var/obj/Y in structures)
		qdel(Y)
	QDEL_NULL(src)

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/highway_devotee/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/highway_devotee/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)
	return

/mob/living/simple_animal/hostile/abnormality/highway_devotee/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/turf/T = pick(GLOB.xeno_spawn)
	forceMove(T)
	addtimer(CALLBACK(src, PROC_REF(KillYourself)), 3 MINUTES)
	dir = pick(list(NORTH, SOUTH, WEST, EAST))
	for(var/turf/open/U in range(2, src))
		var/obj/structure/blockedpath/P = new(U)
		structures += P

/obj/structure/blockedpath
	name = "highway devotee"
	icon_state = "blank"
	max_integrity = 3000000
	density = 1

