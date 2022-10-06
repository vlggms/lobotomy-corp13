/mob/living/simple_animal/hostile/abnormality/old_lady
	name = "Old Lady"
	desc = "An old, decrepit lady sitting in a worn-out rocking chair"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "old_lady"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	faction = list("hostile")
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 0.8)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(65, 65, 60, 60, 60),
		ABNORMALITY_WORK_REPRESSION = 30,
		"Clear Solitude" = -100)
	start_qliphoth = 4
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/solitude,
		/datum/ego_datum/armor/solitude
		)
//	gift_type =  /datum/ego_gifts/solitude
	var/meltdown_cooldown_time = 120 SECONDS
	var/meltdown_cooldown
//for solitude effects
	var/solitude_cooldown_time = 1 SECONDS
	var/solitude_cooldown
//for breach effects... wait what
	var/old_cooldown_time = 3 SECONDS
	var/old_cooldown
	var/old_damage = 10

/mob/living/simple_animal/hostile/abnormality/old_lady/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/old_lady/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/old_lady/Life()
	. = ..()
	if(status_flags & GODMODE) // Contained
		if(meltdown_cooldown < world.time && !datum_reference.working) // Doesn't decrease while working but will afterwards
			meltdown_cooldown = world.time + meltdown_cooldown_time
			datum_reference.qliphoth_change(-1)

		if(solitude_cooldown < world.time && datum_reference.qliphoth_meter == 0)
			solitude_cooldown = world.time + solitude_cooldown_time
			for(var/turf/open/T in range(2 , src))
				if(prob(70))
					new /obj/effect/solitude (T)
	else
		if(old_cooldown < world.time)
			old_cooldown = world.time + old_cooldown_time
			BeOld()
			for(var/turf/open/T in oview(6, src))
				if(prob(75))
					new /obj/effect/solitude (T)

/mob/living/simple_animal/hostile/abnormality/old_lady/attempt_work(mob/living/carbon/human/user, work_type)
	if(work_type == "Clear Solitude" && datum_reference.qliphoth_meter == 0)
		return TRUE
	else if(datum_reference.qliphoth_meter == 0 || work_type == "Clear Solitude")
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/old_lady/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(work_type == "Clear Solitude")
		datum_reference.qliphoth_change(4)
		icon_state = "old_lady"
	return ..()

/mob/living/simple_animal/hostile/abnormality/old_lady/breach_effect()
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	old_cooldown = world.time

/mob/living/simple_animal/hostile/abnormality/old_lady/proc/BeOld()
	for(var/mob/living/target in view(7, src))
		if(faction_check_mob(target))
			continue
		target.apply_damage(old_damage, WHITE_DAMAGE, null, target.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)

//The Effect
/obj/effect/solitude
	name = "solitude gas"
	desc = "You can hardly see through this."
	icon = 'icons/effects/effects.dmi'
	icon_state = "solitude1"
	move_force = INFINITY
	pull_force = INFINITY
	layer = ABOVE_MOB_LAYER

/obj/effect/solitude/Initialize()
	..()
	icon_state = "solitude[pick(1,2,3,4)]"
	animate(src, alpha = 0, time = 3 SECONDS)
	QDEL_IN(src, 3 SECONDS)
