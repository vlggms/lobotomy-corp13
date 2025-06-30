/mob/living/simple_animal/hostile/abnormality/branch12/veil
	name = "Beyond the Veil"
	desc = "A figure in a long cloak."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "veil"
	icon_living = "veil"
	del_on_death = TRUE
	maxHealth = 2100
	health = 2100
	rapid_melee = 2
	ranged = 1
	retreat_distance = 3
	minimum_distance = 1
	damage_coeff = list(RED_DAMAGE = 1.3, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0, PALE_DAMAGE = 1)
	melee_damage_lower = 14
	melee_damage_upper = 14
	melee_damage_type = RED_DAMAGE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cuts"
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/cleave.ogg'
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 25, 30, 30),
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 55, 60),
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
	//	/datum/ego_datum/weapon/branch12/egoification,
	//	/datum/ego_datum/armor/legs
	)
	//gift_type =  /datum/ego_gifts/departure
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/list/spawnables = list()


/mob/living/simple_animal/hostile/abnormality/branch12/veil/Initialize()
	..()
	//We need a list of all abnormalities that are TETH to Waw level and Can breach.
	var/list/queue = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in queue)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(!(initial(abno.can_spawn)) || !(initial(abno.can_breach)))
			continue

		if((initial(abno.threat_level)) <= WAW_LEVEL)
			spawnables += abno

/mob/living/simple_animal/hostile/abnormality/branch12/veil/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <80)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/veil/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/veil/AttackingTarget(atom/attacked_target)
	. = ..()
	if(prob(10))
		Teleport()
	if(prob(5))
		Spawn_Abno()

/mob/living/simple_animal/hostile/abnormality/branch12/veil/proc/Teleport()
	say("You're coming with me.")
	SLEEP_CHECK_DEATH(20)
	var/chosen_centre = pick(GLOB.department_centers)
	var/list/to_teleport = list()
	for(var/mob/living/L in view(5, src))
		if(L.status_flags & GODMODE)
			continue
		to_teleport+=L
	forceMove(chosen_centre)

	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(3, orgin)

	for(var/mob/living/L in to_teleport)
		var/teleport_loc = pick(all_turfs)
		L.forceMove(teleport_loc)


/mob/living/simple_animal/hostile/abnormality/branch12/veil/proc/Spawn_Abno()
	say("From another time and another place...")
	SLEEP_CHECK_DEATH(50)
	var/mob/living/simple_animal/hostile/abnormality/spawning = pick(spawnables)
	var/mob/living/simple_animal/hostile/abnormality/spawned = new spawning(get_turf(src))
	spawned.BreachEffect()
	spawned.name = "Unknown Hostile"
	spawned.desc = "What is that thing?"
	spawned.faction = list("hostile")
	spawned.core_enabled = FALSE

