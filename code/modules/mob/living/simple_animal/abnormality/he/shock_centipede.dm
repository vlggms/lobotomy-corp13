/mob/living/simple_animal/hostile/abnormality/shock_centipede
	name = "Shock Centipede"
	desc = "A enormous blue Centipede with electricity sparking around it."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "shock_centipede"
	icon_living = "shock_centipede"
	maxHealth = 1700
	health = 1700
	rapid_melee = 3
	ranged = TRUE
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/abnormalities/laetitia/spider_attack.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 3
	melee_damage_upper = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	speak_emote = list("screechs")
	vision_range = 14
	melee_reach = 2
	pixel_x = -32
	base_pixel_x = -32
	aggro_vision_range = 20
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 55,
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = 10,
						ABNORMALITY_WORK_REPRESSION = list(75, 75, 95, 95, 95)
						)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/aedd,
		/datum/ego_datum/armor/aedd
		)
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	var/self_charge_counter = 0
	var/self_charge_health = 0

	var/shield = 0
	var/currentShieldTimerID = 0
	var/coil_cooldown = 0
	var/tail_attack_cooldown = 0
	var/stunned = FALSE
	var/immortal = FALSE



	var/bonus_pe = 6
	var/self_charge_threshold = 350
	var/coil_timer_decisec = 100
	var/coil_max_shield = 500
	var/max_charge = 20
	var/coil_start_charge = 12
	var/coil_cooldown_decisec = 100
	var/coil_discharge_aoe_damage = 35
	var/coil_discharge_aoe_damagetype = BLACK_DAMAGE
	var/coil_discharge_aoe_stun_duration_decisec = 50
	var/coil_discharge_aoe_missed_charge_loss = 3
	var/coil_shield_broken_charge_loss = 6
	var/coil_shield_broken_selfstun_duration_decisec = 40

	var/immortal_damagetype = BLACK_DAMAGE
	var/immortal_melee_damage_upper = 6
	var/immortal_melee_damage_lower = 5

	var/immortal_countdown_duration_decisec = 30

	var/tailattack_cooldown_decisec = 80
	var/tailattack_damage = 20
	var/tailattack_damagetype = BLACK_DAMAGE
	var/tailattack_windup_decisec = 15
	var/tailattack_charge_per_target = 3

	var/tailattack_range = 5

	var/repression_change_qlip_1 = 30


/* Work effects */

/* Attempt Work */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/AttemptWork(mob/living/carbon/human/user, work_type)
	//Temp too high, random damage type time.
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) <= 60)
		work_damage_amount = 14
	if(datum_reference?.qliphoth_meter == 1 && work_type == ABNORMALITY_WORK_REPRESSION)
		work_damage_type = BLACK_DAMAGE
	return ..()

/mob/living/simple_animal/hostile/abnormality/shock_centipede/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE

/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/CheckQliphoth(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(datum_reference?.qliphoth_meter == 3 && work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
		return FALSE
	else
		if(datum_reference?.qliphoth_meter == 1 && work_type != ABNORMALITY_WORK_REPRESSION)
			datum_reference.qliphoth_change(-1)
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/shock_centipede/ChanceWorktickOverride(mob/living/carbon/human/user, work_chance, init_work_chance, work_type)
	if((datum_reference?.qliphoth_meter == 1 || datum_reference?.qliphoth_meter == 2) && work_type != ABNORMALITY_WORK_REPRESSION)
		return repression_change_qlip_1
	else
		return work_chance

/* Success Effect */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	if (!CheckQliphoth(user, work_type, pe))
		return
	if(datum_reference?.qliphoth_meter == 2)
		datum_reference.qliphoth_change(1)
	if(datum_reference?.qliphoth_meter == 1 && work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(2)
		datum_reference.stored_boxes += bonus_pe
		to_chat(user, "<span class='nicegreen'>[bonus_pe] extra PE Boxes have been generated!</span>")

/* Neutral Effect */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if (!CheckQliphoth(user, work_type, pe))
		return
	if(datum_reference?.qliphoth_meter == 2)
		if(prob(50))
			datum_reference.qliphoth_change(-1)
		else
			datum_reference.qliphoth_change(1)
	else
		if(datum_reference?.qliphoth_meter == 1 && work_type == ABNORMALITY_WORK_REPRESSION)
			datum_reference.qliphoth_change(1)

/* Failure Effect */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if (!CheckQliphoth(user, work_type, pe))
		return
	datum_reference.qliphoth_change(-1)

/* Breach Effects*/
/mob/living/simple_animal/hostile/abnormality/shock_centipede/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if (amount >= 0 && shield > 0) // actual damage
		amount = UpdateShield(amount)
	if (amount >= 0)
		UpdateCharge(amount)

	if (immortal && amount >= 0)
		if (self_charge_counter == 0)
			amount = health
		else
			return FALSE
	. = ..()


/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/UpdateCharge(amount)
	self_charge_health += amount
	self_charge_counter -= self_charge_health / self_charge_threshold
	if (self_charge_counter < 0)
		self_charge_counter = 0
	self_charge_health %= self_charge_threshold



/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/UpdateShield(amount)
	var/remainder = amount - shield
	shield -= amount
	if (remainder >= 0)
		shield = 0
		if (currentShieldTimerID  != 0) //stop coil timer
			// stop coiling animation
			deltimer(currentShieldTimerID)
			currentShieldTimerID = 0
		manual_emote("crumbles to the ground...")
		// stun
		icon_state = "shock_centipede"
		stunned = TRUE
		addtimer(CALLBACK(src, PROC_REF(StunEnd)), coil_shield_broken_selfstun_duration_decisec)
		self_charge_counter -= coil_shield_broken_charge_loss
		return remainder
	else
		var/obj/effect/temp_visual/shock_shield/AT = new /obj/effect/temp_visual/shock_shield(loc, src)
		var/random_x = rand(-16, 16)
		AT.pixel_x += random_x

		var/random_y = rand(5, 32)
		AT.pixel_y += random_y
		return 0

/obj/effect/temp_visual/shock_shield
	name = "shock_sheild"
	desc = "A shimmering forcefield protecting the shock centipede."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield"
	layer = FLY_LAYER
	light_system = MOVABLE_LIGHT
	light_range = 2
	duration = 8
	var/target

/obj/effect/temp_visual/at_shield/Initialize(mapload, new_target)
	. = ..()
	target = new_target
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, orbit), target, 0, FALSE, 0, 0, FALSE, TRUE)


/mob/living/simple_animal/hostile/abnormality/shock_centipede/AttackingTarget()
	if (shield > 0 || stunned)  // dont attack if coiled or stunned
		return FALSE
	if(!client)
		CheckCharge()
		if(tail_attack_cooldown < world.time)
			var/turf/target_turf = get_turf(target)
			for(var/i = 1 to tailattack_range - 2)
				target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
			TailAttack(target_turf)
			return FALSE
	. = ..()
	if (!immortal)
		self_charge_counter += 1
	if (self_charge_counter > max_charge)
		self_charge_counter = max_charge
	CheckCharge()

/mob/living/simple_animal/hostile/abnormality/shock_centipede/OpenFire()
	if(stunned || shield > 0)
		return

	if(tail_attack_cooldown < world.time)
		TailAttack(target)

/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/CheckCharge()
	if (self_charge_counter >= coil_start_charge && world.time > coil_cooldown && !immortal)
		coil_cooldown = world.time + coil_cooldown_decisec + coil_timer_decisec
		shield = coil_max_shield
		// icon_state end chage
		icon_state = "shock_centipede_coil"
		currentShieldTimerID = addtimer(CALLBACK(src, PROC_REF(CoilEnd)), coil_cooldown_decisec, TIMER_STOPPABLE)
		manual_emote("starts coiling up...")

/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/CoilEnd()
	currentShieldTimerID = 0
	if (shield > 0)
		manual_emote("electricity escapes from it's body...")
		//start AoE
		CoilDischargeAoe()
		coil_cooldown = world.time + coil_cooldown_decisec


/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/StunEnd()
	// icon_state
	stunned = FALSE
	coil_cooldown = world.time + coil_cooldown_decisec

// dont move when coiled or stunned
/mob/living/simple_animal/hostile/abnormality/shock_centipede/Move()
	if (shield > 0 || stunned)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/CoilDischargeAoe()
	if(stat == DEAD)
		return
	icon_state = "shock_centipede"
	for(var/turf/T in view(4, src))
		new /obj/effect/temp_visual/blubbering_smash(get_turf(T))
	var/count = 0
	for(var/mob/living/L in view(4, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage(coil_discharge_aoe_damage, coil_discharge_aoe_damagetype, null, L.run_armor_check(null, coil_discharge_aoe_damagetype), spread_damage = TRUE)
		L.Stun(coil_discharge_aoe_stun_duration_decisec)
		count ++
	playsound(get_turf(src), 'sound/abnormalities/kqe/hitsound2.ogg', 100, 0, 8)
	shield = 0
	if (count == 0)
		self_charge_counter -= coil_discharge_aoe_missed_charge_loss

/mob/living/simple_animal/hostile/abnormality/shock_centipede/Life()
	CheckCharge()
	..()

/mob/living/simple_animal/hostile/abnormality/shock_centipede/death()
	if(health > 0)
		return
	if (!immortal)
		manual_emote("rises back up...")
		immortal = TRUE
		icon_state = "shock_centipede_broken"
		melee_damage_type = immortal_damagetype
		melee_damage_upper = immortal_melee_damage_upper
		melee_damage_lower = immortal_melee_damage_lower
		adjustHealth(maxHealth * -1)
		SpeedChange(-1)
		// i don't know what this does. copied from mountain
		UpdateSpeed()
		update_simplemob_varspeed()
		addtimer(CALLBACK(src, PROC_REF(ChargeCountDown)), immortal_countdown_duration_decisec)
		return FALSE
	else
		animate(src, alpha = 0, time = 10 SECONDS)
		QDEL_IN(src, 10 SECONDS)
		icon_state = "shock_centipede"
		return ..()

/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/ChargeCountDown()
	if (self_charge_counter > 1)
		self_charge_counter--
		addtimer(CALLBACK(src, PROC_REF(ChargeCountDown)), immortal_countdown_duration_decisec)
	else
		adjustHealth(health)

/mob/living/simple_animal/hostile/abnormality/shock_centipede/proc/TailAttack(target)
	manual_emote("pulls it's tail back...")
	tail_attack_cooldown = world.time + tailattack_cooldown_decisec
	stunned = TRUE
	face_atom(target)
	//icon_state windup
	var/turf/target_turf = get_turf(target)
	// warning animation
	var/broken = FALSE
	var/distance = tailattack_range

	for(var/turf/T in getline(get_turf(src), target_turf))
		if (distance < 0)
			break
		distance--
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T))
			if(TF.density)
				continue
			TF.add_overlay(icon('icons/effects/effects.dmi', "galaxy_aura"))
			addtimer(CALLBACK(TF, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('icons/effects/effects.dmi', "galaxy_aura")), tailattack_windup_decisec)

	SLEEP_CHECK_DEATH(tailattack_windup_decisec)
	distance = tailattack_range
	broken = FALSE
	var/been_hit = list()
	for(var/turf/T in getline(get_turf(src), target_turf))
		if (distance < 0)
			break
		distance--
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, tailattack_damage, tailattack_damagetype, null, null, TRUE, FALSE, TRUE, TRUE)
	self_charge_counter += length(been_hit) * tailattack_charge_per_target
	//playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	//current_icon = icon_state
	//icon_state = current_icon
	stunned = FALSE
