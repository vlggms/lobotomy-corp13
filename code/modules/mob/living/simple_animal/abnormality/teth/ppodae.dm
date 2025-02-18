/mob/living/simple_animal/hostile/abnormality/ppodae
	name = "Ppodae"
	desc = "The Goodest Boy in the World"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "ppodae"
	icon_living = "ppodae"
	portrait = "ppodae"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 550 //fast but low hp abno
	health = 550
	threat_level = TETH_LEVEL
	move_to_delay = 1
	faction = list("hostile")
	response_help_continuous = "pet"
	response_help_simple = "pet"
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 30, 30, 30),
	)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	can_breach = TRUE
	start_qliphoth = 2
	vision_range = 14
	aggro_vision_range = 20
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/cute,
		/datum/ego_datum/armor/cute,
	)
	gift_type =  /datum/ego_gifts/cute
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	attack_action_types = list(/datum/action/cooldown/ppodae_transform)

	observation_prompt = "Before me stands a creature, eagerly awaiting its next meal. The creature is..."
	observation_choices = list(
		"A monster" = list(TRUE, "I don't know how I didn't see it before, I rushed out to warn the others. I was fired the next day."),
		"A puppy" = list(FALSE, "It's the cutest puppy I've ever seen."),
	)

	var/smash_damage_low = 16
	var/smash_damage_high = 28
	var/smash_length = 2
	var/smash_width = 1
	var/can_act = TRUE
	var/buff_form = TRUE
	//Buff Form stuff
	var/buff_resist_red = 0.5
	var/buff_resist_white = 0.5
	var/buff_resist_black = 0.5
	var/buff_resist_pale = 0.5
	var/buff_speed = 2
	var/can_slam = TRUE
	//Cute Form stuff
	var/cute_resist_red = 1.5
	var/cute_resist_white = 0.8
	var/cute_resist_black = 1
	var/cute_resist_pale = 2
	var/cute_speed = 1
	//Other Stuff
	var/limb_heal = 0.1


/mob/living/simple_animal/hostile/abnormality/ppodae/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<h1>You are Ppodae, A Support/Combat Role Abnormality.</h1><br>\
		<b>|How adorable!|: You are able to switch between a 'Cute' and 'Buff' form. \
		Switching between forms has a 5 second cooldown and each time you switch forms you create smoke which lasts for 9 seconds.<br>\
		<br>\
		|Cute!|: While you are in your 'Cute' form, you have a MASSIVE speed boost and if you try to melee attack mechs or living mobs, you will crawl under them.<br>\
		<br>\
		|Strong!|: While you are in your 'Buff' form, you take 50% less damage from all attacks and you prefrom a 3x3 AoE attack when you try to melee attack, (Really good at breaking down Structures)<br>\
		<br>\
		|He's just Playing|: When you melee attack a unconscious or dead human body, you are able to tear off a limb, which heals you 10% of your max HP. (You can do this 4 time per body)</b>")

/datum/action/cooldown/ppodae_transform
	name = "Transform!"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "ppodae_transform"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/ppodae_transform/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/ppodae))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/ppodae/ppodae = owner
	if(ppodae.IsContained()) // No more using cooldowns while contained
		return FALSE
	StartCooldown()
	if(ppodae.buff_form)
		ppodae.buff_form = FALSE
		ppodae.UpdateForm()
	else
		ppodae.buff_form = TRUE
		ppodae.UpdateForm()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/ppodae/proc/UpdateForm()
	if(buff_form)
		ChangeResistances(list(RED_DAMAGE = buff_resist_red, WHITE_DAMAGE = buff_resist_white, BLACK_DAMAGE = buff_resist_black, PALE_DAMAGE = buff_resist_pale))
		move_to_delay = buff_speed
		icon_state = "ppodae_active"
		can_slam = TRUE
	else
		ChangeResistances(list(RED_DAMAGE = cute_resist_red, WHITE_DAMAGE = cute_resist_white, BLACK_DAMAGE = cute_resist_black, PALE_DAMAGE = cute_resist_pale))
		move_to_delay = cute_speed
		icon_state = "ppodae"
		can_slam = FALSE
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, src)
	smoke.start()
	qdel(smoke)
	UpdateSpeed()
	playsound(get_turf(src), 'sound/abnormalities/scaredycat/cateleport.ogg', 50, 0, 5)

/mob/living/simple_animal/hostile/abnormality/ppodae/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/ppodae/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	var/mob/living/carbon/L = target
	if(IsCombatMap())
		if(iscarbon(target) && (L.stat == DEAD))
			LimbSteal(L)
			return
	else
		if(iscarbon(target) && (L.health < 0 || L.stat == DEAD))
			LimbSteal(L)
			return

			// Taken from eldritch_demons.dm
	if(IsCombatMap())
		if(can_slam)
			return Smash(target)
		else if(isvehicle(target))
			var/obj/vehicle/V = target
			var/turf/target_turf = get_turf(V)
			forceMove(target_turf)
			manual_emote("crawls under [V]!")
		else if (istype(target, /mob/living))
			if (target != src)
				var/turf/target_turf = get_turf(target)
				forceMove(target_turf)
				manual_emote("crawls under [target]!")
	else
		return Smash(target)

/mob/living/simple_animal/hostile/abnormality/ppodae/proc/LimbSteal(mob/living/carbon/L)
	if(HAS_TRAIT(L, TRAIT_NODISMEMBER))
		return
	var/list/parts = list()
	for(var/X in L.bodyparts)
		var/obj/item/bodypart/bp = X
		if(bp.body_part != HEAD && bp.body_part != CHEST)
			if(bp.dismemberable)
				parts += bp
	if(length(parts))
		var/obj/item/bodypart/bp = pick(parts)
		bp.dismember()
		if(IsCombatMap())
			adjustHealth(-(maxHealth * limb_heal))
		bp.forceMove(get_turf(datum_reference.landmark)) // Teleports limb to containment
		QDEL_NULL(src)

//AoE attack taken from woodsman
/mob/living/simple_animal/hostile/abnormality/ppodae/proc/Smash(target)
	if (get_dist(src, target) > 1)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, EAST, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, WEST, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, SOUTH, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, NORTH, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	var/smash_damage = rand(smash_damage_low, smash_damage_high)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), smash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE)
	playsound(get_turf(src), 'sound/abnormalities/ppodae/bark.wav', 100, 0, 5)
	playsound(get_turf(src), 'sound/abnormalities/ppodae/attack.wav', 50, 0, 5)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ppodae/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type != ABNORMALITY_WORK_INSTINCT && prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = "ppodae_active"
	GiveTarget(user)
	if(IsCombatMap())
		UpdateForm()
