/mob/living/simple_animal/hostile/abnormality/voiddream
	name = "Void Dream"
	desc = "A very fluffy floating sheep.."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "void_dream"
	icon_living = "void_dream"
	is_flying_animal = TRUE
	del_on_death = TRUE
	maxHealth = 600
	health = 600
	rapid_melee = 2
	move_to_delay = 6
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)

	melee_damage_lower = 0
	melee_damage_upper = 0
	melee_damage_type = PALE_DAMAGE		//It doesn't attack so it doesn't matter if it does pale honestly
	armortype = PALE_DAMAGE
	stat_attack = HARD_CRIT

	attack_verb_continuous = "nuzzles"
	attack_verb_simple = "nuzzles"
	faction = list("neutral", "hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 45,
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = 60,
						ABNORMALITY_WORK_REPRESSION = 20
						)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/dream,
		/datum/ego_datum/armor/dream
		)
	gift_type =  /datum/ego_gifts/dream
	var/punched = FALSE
	var/pulse_damage = 25

/mob/living/simple_animal/hostile/abnormality/voiddream/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/voiddream/OpenFire()
	if(!punched)
		SleepyDart()
		addtimer(CALLBACK (src, .proc/OpenFire), 12 SECONDS)
	else
		Crow()
		addtimer(CALLBACK (src, .proc/OpenFire), 8 SECONDS)


/mob/living/simple_animal/hostile/abnormality/voiddream/proc/SleepyDart()
	var/list/possibletargets = list()
	for(var/mob/living/carbon/human/L in view(10, src))
		possibletargets += L

	if(!LAZYLEN(possibletargets))
		return
	playsound(get_turf(src), 'sound/magic/staff_change.ogg', 100, 0, 12)
	var/obj/projectile/P = new /obj/projectile/sleepdart(get_turf(src))
	P.firer = src
	target = pick(possibletargets)
	P.original = target
	P.fire(Get_Angle(src, target))
	target = null

/mob/living/simple_animal/hostile/abnormality/voiddream/proc/Crow()
	playsound(get_turf(src), 'sound/magic/staff_change.ogg', 100, 0, 12)
	for(var/mob/living/carbon/human/L in range(10, src))
		if(L.has_status_effect(STATUS_EFFECT_SLEEPING))
			L.adjustSanityLoss(-1000)	//Die.
			L.SetSleeping(0)
		L.apply_damage(pulse_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)


/mob/living/simple_animal/hostile/abnormality/voiddream/proc/die()
	QDEL_NULL(src)

//Getting hit
/mob/living/simple_animal/hostile/abnormality/voiddream/attackby(obj/item/I, mob/living/user, params)
	..()
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	punched = TRUE

/mob/living/simple_animal/hostile/abnormality/voiddream/bullet_act(obj/projectile/P)
	..()
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	punched = TRUE

//Work stuff
/mob/living/simple_animal/hostile/abnormality/voiddream/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/voiddream/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40)
		user.drowsyness += 4
		user.Sleeping(60 SECONDS)	//Not a big fan of killing you, take a little nap.
	return

/mob/living/simple_animal/hostile/abnormality/voiddream/BreachEffect(mob/living/carbon/human/user)
	..()
	addtimer(CALLBACK (src, .proc/OpenFire), 2 SECONDS)
	addtimer(CALLBACK (src, .proc/die), 5 MINUTES)

//Projectile code
/obj/projectile/sleepdart
	name = "void dream"
	icon_state = "antimagic"
	color = "#FCF344"
	damage = 0
	speed = 3
	homing = TRUE
	homing_turn_speed = 30		//Angle per tick.
	var/homing_range = 9

/obj/projectile/sleepdart/Initialize()
	..()
	var/list/targetslist = list()
	for(var/mob/living/L in livinginrange(homing_range, src))
		if(ishuman(L))
			targetslist+=L
	if(!LAZYLEN(targetslist))
		return
	homing_target = pick(targetslist)

/obj/projectile/sleepdart/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/sleepyman = target
		sleepyman.SetSleeping(60 SECONDS)
