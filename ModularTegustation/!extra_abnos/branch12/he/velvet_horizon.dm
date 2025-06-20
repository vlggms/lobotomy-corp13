//This is KINDA like Scorched Girl, which is why the code is so similar. Teh only
/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon
	name = "Fire on the Velvet Horizon"
	desc = "An abnormality resembling a ghost in a purple kimono."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "horizon"
	icon_living = "horizon"
	maxHealth = 1200
	health = 1200
	threat_level = HE_LEVEL
	stat_attack = HARD_CRIT
	move_to_delay = 5
	vision_range = 12
	aggro_vision_range = 24
	melee_damage_lower = 15
	melee_damage_upper = 21
	melee_damage_type = RED_DAMAGE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = list(60, 60, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 15,
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40),
	)
	attack_sound = 'sound/abnormalities/redhood/attack_1.ogg'
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.2)
	faction = list("hostile")
	can_breach = TRUE
	start_qliphoth = 3
	del_on_death = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/memorable,
		/datum/ego_datum/weapon/branch12/big_day,
		/datum/ego_datum/armor/branch12/memorable,
	)
	//gift_type =  /datum/ego_gifts/match
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	//Amount of damage you do constantly.
	var/constant_damage = 3

	/// Restrict movement when this is set to TRUE
	var/exploding = FALSE
	/// Current cooldown for the players
	var/boom_cooldown
	/// Amount of RED damage done on explosion
	var/boom_damage = 250
	patrol_cooldown_time = 10 SECONDS //Scorched be zooming


/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon/Move()
	if(exploding)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon/Worktick(mob/living/carbon/human/user)
	user.deal_damage(constant_damage, RED_DAMAGE)
	WorkDamageEffect()
	..()

//"death"
/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon/death()
	if(!exploding)
		explode()

/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon/proc/explode()
	if(boom_cooldown > world.time) // That's only for players
		return
	boom_cooldown = world.time + 3 SECONDS
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/pre_ability.ogg', 50, 0, 2)
	if(client)
		if(!do_after(src, 1.5 SECONDS, target = src))
			return
	else
		SLEEP_CHECK_DEATH(1.5 SECONDS)
	exploding = TRUE
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/ability.ogg', 60, 0, 4)
	SLEEP_CHECK_DEATH(3 SECONDS)
	// Ka-boom
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/explosion.ogg', 125, 0, 8)
	for(var/mob/living/carbon/human/H in view(7, src))
		H.deal_damage(boom_damage, RED_DAMAGE)
		if(H.health < 0)
			H.gib()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(7, get_turf(src))
	S.start()
	qdel(src)

/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/velvet_horizon/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return
