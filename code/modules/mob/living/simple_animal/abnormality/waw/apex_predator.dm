/mob/living/simple_animal/hostile/abnormality/apex_predator
	name = "Apex Predator"
	desc = "An abnormality resembling a beaten up crash dummy."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "apex"
	icon_living = "apex"
	pixel_x = -16
	base_pixel_x = -16


	maxHealth = 1600
	health = 1600
	density = FALSE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	ranged = TRUE
	melee_damage_lower = 30
	melee_damage_upper = 40
	move_to_delay = 3

	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT

	fear_level = 0	//You should never notice it

	attack_sound = 'sound/abnormalities/fragment/attack.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 40, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(25, 20, 15, 10, 0),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 50, 55, 55),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/animalism,
		/datum/ego_datum/armor/animalism,
	)
//	gift_type =  /datum/ego_gifts/animalism

	var/revealed = TRUE
	var/can_act = TRUE
	var/backstab_damage = 200
	var/agent_status //Used for insanity

	var/jumping	//Used so it can only start one jump at once
	var/busy	//Can we move now?

	var/jump_cooldown
	var/jump_cooldown_time = 5 SECONDS
	var/jump_damage = 60



/mob/living/simple_animal/hostile/abnormality/apex_predator/Move()
	if(busy)
		return FALSE
	..()


/mob/living/simple_animal/hostile/abnormality/apex_predator/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/apex_predator/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/apex_predator/AttemptWork(mob/living/carbon/human/user, work_type)
	if(user.health != user.maxHealth)
		work_damage_amount = 20
	return TRUE

/mob/living/simple_animal/hostile/abnormality/apex_predator/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.health < 0)
		datum_reference.qliphoth_change(-1)

	work_damage_amount = initial(work_damage_amount)
	return

/mob/living/simple_animal/hostile/abnormality/apex_predator/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	Cloak()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/apex_predator/AttackingTarget()
	if(!can_act)
		return

	if(!revealed)
		//Will want this to be crazy
		say("Behind you.")

		SLEEP_CHECK_DEATH(7)
		Decloak()
		SLEEP_CHECK_DEATH(3)

		var/mob/living/V = target
		//Backstab
		if(target in range(1,src))
			visible_message(span_danger("\The [src] rips out [target]'s guts!"))
			new /obj/effect/gibspawner/generic(get_turf(V))
			V.apply_damage(backstab_damage, RED_DAMAGE, null, V.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			SLEEP_CHECK_DEATH(20)
			Cloak()
			//Remove target
			FindTarget()

		else
			if(!jumping)
				Jump()
		return
	..()


//Getting hit decloaks
/mob/living/simple_animal/hostile/abnormality/apex_predator/attackby(obj/item/I, mob/living/user, params)
	..()
	Decloak()

/mob/living/simple_animal/hostile/abnormality/apex_predator/bullet_act(obj/projectile/P)
	..()
	Decloak()

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Cloak()
	alpha = 10
	revealed = FALSE
	density = FALSE

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Decloak()
	alpha = 255
	revealed = TRUE
	density = TRUE

/mob/living/simple_animal/hostile/abnormality/apex_predator/OpenFire()
	if(!revealed)
		return

	//For readability
	if((jump_cooldown < world.time) && !(status_flags & GODMODE))
		Jump()

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Jump()
	jumping = TRUE
	busy = TRUE
	icon_state = "apex_crouch"
	addtimer(CALLBACK(src, PROC_REF(Leap)), 5)

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Leap()
	density = FALSE
	var/target_turf = get_turf(target)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	throw_at(target_turf, 7, 1, src, FALSE)
	icon_state = "apex_leap"

	addtimer(CALLBACK(src, PROC_REF(Slam)), 10)

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Slam()
	icon_state = "apex_crouch"
	playsound(src, 'sound/effects/meteorimpact.ogg', 300, FALSE, 9)
	for(var/turf/T in range(1, src))
		new /obj/effect/temp_visual/kinetic_blast(T)
	for(var/mob/living/L in range(1, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(jump_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	addtimer(CALLBACK(src, PROC_REF(Reset)), 12)

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Reset()
	density = TRUE
	busy = FALSE
	jumping = FALSE
	icon_state = "apex"
	jump_cooldown = world.time + jump_cooldown_time

