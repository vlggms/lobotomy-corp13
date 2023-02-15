/mob/living/simple_animal/hostile/abnormality/yang
	name = "Yang"
	desc = "A floating white fish that seems to help everyone near it."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "yang"
	icon_living = "yang"
	is_flying_animal = TRUE
	maxHealth = 800	//It is helpful and therefore weak.
	health = 800
	move_to_delay = 7
	speed = 7
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -8
	base_pixel_y = -8
	stat_attack = HARD_CRIT

	//work stuff
	can_breach = TRUE
	start_qliphoth = 2
	threat_level = WAW_LEVEL
	work_damage_amount = 11
	work_damage_type = WHITE_DAMAGE
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = list(0, 0, 45, 45, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 55, 55, 60),
						ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
						"Release" = 0
						)
	ego_list = list(
		/datum/ego_datum/weapon/assonance,
		/datum/ego_datum/armor/assonance
		)
//	gift_type = /datum/ego_gifts/assonance

	//Melee
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1.7, PALE_DAMAGE = 2)
	melee_damage_lower = 30
	melee_damage_upper = 30
	melee_damage_type = WHITE_DAMAGE
	faction = list("neutral")	//Doesn't attack until attacked.

	//Ranged. Simple AI to help it work
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	projectiletype = /obj/projectile/beam/yang
	projectilesound = 'sound/weapons/sear.ogg'

	var/explosion_damage = 150
	var/explosion_timer = 7 SECONDS
	var/explosion_range = 15
	var/exploding = FALSE

	//slowly heals sanity over time
	var/heal_cooldown
	var/heal_cooldown_time = 3 SECONDS
	var/heal_amount = 5


/mob/living/simple_animal/hostile/abnormality/yang/Move()
	if(exploding)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/yang/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((heal_cooldown < world.time) && !(status_flags & GODMODE))
		HealPulse()

/mob/living/simple_animal/hostile/abnormality/yang/death()
	//Make sure we didn't get cheesed, and blow up.
	if(health > 0)
		return
	icon_state = "yang_blow"
	exploding = TRUE
	addtimer(CALLBACK(src, .proc/explode), explosion_timer)


/mob/living/simple_animal/hostile/abnormality/yang/proc/explode()
	exploding = TRUE
	new /obj/effect/temp_visual/explosion/fast(get_turf(src))
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(explosion_range, orgin)
	alpha = 0

	for(var/i = 0 to explosion_range)
		for(var/turf/T in all_turfs)
			if(T.density)
				continue
			if(get_dist(src, T) > i)
				continue
			new /obj/effect/temp_visual/dir_setting/speedbike_trail(T)
			for(var/mob/living/L in T)
				if(L == src)
					continue
				L.apply_damage(explosion_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			all_turfs -= T
		SLEEP_CHECK_DEATH(1)

	QDEL_NULL(src)


/mob/living/simple_animal/hostile/abnormality/yang/proc/HealPulse()
	heal_cooldown = world.time + heal_cooldown_time

	for(var/mob/living/carbon/human/H in livinginview(15, src))
		if(H.stat == DEAD)
			continue
		H.adjustSanityLoss(-heal_amount) // It's healing
		new /obj/effect/temp_visual/emp/pulse(get_turf(H))


/obj/projectile/beam/yang
	name = "yang beam"
	icon_state = "omnilaser"
	hitscan = TRUE
	damage = 70
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
	muzzle_type = /obj/effect/projectile/muzzle/laser/white
	tracer_type = /obj/effect/projectile/tracer/laser/white
	impact_type = /obj/effect/projectile/impact/laser/white

/obj/effect/projectile/muzzle/laser/white
	name = "white flash"
	icon_state = "muzzle_white"

/obj/effect/projectile/tracer/laser/white
	name = "white beam"
	icon_state = "beam_white"

/obj/effect/projectile/impact/laser/white
	name = "white impact"
	icon_state = "impact_white"


/mob/living/simple_animal/hostile/abnormality/yang/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/yang/BreachEffect(mob/living/carbon/human/user)
	..()
	icon_state = "yang_breach"
	//So they can breach yin later

/mob/living/simple_animal/hostile/abnormality/yang/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == "Release")
		datum_reference.qliphoth_change(-2)
	return
