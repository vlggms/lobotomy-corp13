/mob/living/simple_animal/hostile/abnormality/woodsman
	name = "Warm-Hearted Woodsman"
	desc = "A mossy old robot that reeks of iron..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "woodsman"
	icon_living = "woodsman_breach"
	portrait = "woodsman"
	layer = BELOW_OBJ_LAYER
	maxHealth = 1433
	health = 1433
	ranged = TRUE
	attack_verb_continuous = "chops"
	attack_verb_simple = "chop"
	attack_sound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	melee_damage_lower = 15
	melee_damage_upper = 30
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	vision_range = 14
	aggro_vision_range = 20
	can_buckle = TRUE
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 60, 70, 80, 90),
		ABNORMALITY_WORK_REPRESSION = 45,
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	move_to_delay = 4
	base_pixel_x = -16
	pixel_x = -16

	ego_list = list(
		/datum/ego_datum/weapon/logging,
		/datum/ego_datum/armor/logging,
	)
	gift_type =  /datum/ego_gifts/loggging
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/scarecrow = 2,
		/mob/living/simple_animal/hostile/abnormality/road_home = 2,
		/mob/living/simple_animal/hostile/abnormality/scaredy_cat = 2,
		// Ozma = 2,
		/mob/living/simple_animal/hostile/abnormality/pinocchio = 1.5,
	)

	observation_prompt = "Tin-cold woodsman. <br>I’ll give you the heart to forgive and love anyone. <br>The wizard grants you..."
	observation_choices = list(
		"A heart of lead" = list(TRUE, "Who do you possibly expect to understand with that ice-cold heart of yours?"),
		"A warm heart" = list(FALSE, "You’re a machine, aren’t you? A heart is unnecessary for a machine."),
	)

	// Flurry Vars
	var/flurry_cooldown = 0
	var/flurry_cooldown_time = 15 SECONDS
	var/flurry_delay = 1.5 SECONDS
	var/flurry_pause = 0.25 SECONDS
	var/flurry_count = 7
	var/flurry_small = 12
	var/flurry_big = 60 // It was requested that he beats their ass harder
	var/flurry_length = 3
	var/flurry_width = 2
	var/can_act = TRUE

	// Combat map check
	var/combat_map = FALSE

	// Ramping Vars
	var/ramping = 0
	var/ramping_max = 10
	var/ramping_decay
	var/ramping_decay_time = 1 MINUTES
	var/initial_melee_damage_lower
	var/initial_melee_damage_upper
	var/initial_move_to_delay
	var/initial_flurry_delay
	var/initial_flurry_pause
	// Looping Sound for max ramping
	var/datum/looping_sound/woodsman/soundloop

	// chain stuff
	var/mob/living/carbon/human/chained_target = null
	var/chain_pull_count = 0
	var/active_pull_timer
	var/NORMAL_PULL_DISTANCE = 1
	var/HEAVY_PULL_DISTANCE = 2
	var/NORMAL_PULL_DELAY = 10 // 1 second in deciseconds
	var/HEAVY_PULL_DELAY = 15 // 1.5 seconds in deciseconds

	// Chain beam
	var/datum/beam/chain_beam

	//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/woodsman_flurry_toggle)

/mob/living/simple_animal/hostile/abnormality/woodsman/Login()
	. = ..()
	to_chat(src, "<h1>You are Warm Hearted Woodsman, A Combat Role Abnormality.</h1><br>\
		<b>|Seeking Hearts...|:</b> When you attack dead bodies, you will extract their heart.<br>\
		Extracting their heart will cause you to heal and cause you to deal more damage with all of your attacks for short time.<br>\
		<br>\
		<b>|Heart Ripper|:</b> After you press your 'Axe Throw' ability, You will throw your axe towards the next tile you click on.<br>\
		Any human hit by your axe, will become chained to you, making them unable to run away. You will also start reeling them to yourself.<br>\
		If you pull them all the way next to you, they will be released and knocked down for 3 seconds. They will also be released if they break line of sight with you.<br>\
		<br>\
		<b>|Chopping Down|:</b> When you attack, if your flurry attack is off cooldown you will use it.<br>\
		Your flurry attack is a 3x2 AoE in front of you, which deals RED damage, which will repeat 7 times in a row before end with a extra strong final hit.<br>\
		You are able to toggle your flurry attack on and off with your ability.")

/datum/action/spell_action/spell/axe_throw/IsAvailable()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/woodsman))
		var/mob/living/simple_animal/hostile/abnormality/woodsman/W = owner
		if (W.chained_target)
			return FALSE
	. = ..()


/obj/effect/proc_holder/spell/pointed/axe_throw
	name = "Chain Axe throw"
	desc = "Throw your axe, and any human hit by hit will be chained to you making them unable to run away."
	has_action = TRUE
	action_icon = 'icons/mob/actions/actions_abnormality.dmi'
	action_icon_state = "wood_axe"
	clothes_req = FALSE
	charge_max = 150
	range = 10
	selection_type = "range"
	active_msg = "You prepare to throw your axe..."
	deactive_msg = "You put away your axe..."
	base_action = /datum/action/spell_action/spell/axe_throw


/obj/effect/proc_holder/spell/pointed/axe_throw/cast(list/targets, mob/user)
	var/target = targets[1]

	if (istype(user, /mob/living/simple_animal/hostile/abnormality/woodsman))
		var/mob/living/simple_animal/hostile/abnormality/woodsman/W = user
		if (W.chained_target)
			return FALSE

	var/obj/projectile/chainedaxe/P = new(get_turf(user))
	P.firer = user
	P.preparePixelProjectile(target, user)
	P.fire()

/obj/projectile/chainedaxe
	name = "chained axe"
	icon_state = "wood_axe_animated"
	damage_type = RED_DAMAGE
	damage = 30
	hitsound = 'sound/effects/splat.ogg'
	var/chain

/obj/projectile/chainedaxe/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "chain")
	..()

/obj/projectile/chainedaxe/Destroy()
	qdel(chain)
	return ..()

/obj/projectile/chainedaxe/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		var/mob/living/simple_animal/hostile/abnormality/woodsman/W = firer
		if(istype(W) && get_dist(get_turf(target), get_turf(firer)) < 12)
			W.begin_chain_pull(H)

/datum/action/innate/abnormality_attack/toggle/woodsman_flurry_toggle
	name = "Toggle Deforestation"
	desc = "Toggle your ability to perform a multi-hitting attack that hits a wide area in front of you."
	button_icon_state = "woodsman_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't fell hearts anymore.")
	button_icon_toggle_activated = "woodsman_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now attempt to fell all hearts in your path.")
	button_icon_toggle_deactivated = "woodsman_toggle0"

/mob/living/simple_animal/hostile/abnormality/woodsman/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)
	if(IsCombatMap())
		combat_map = TRUE
		initial_melee_damage_lower = melee_damage_lower
		initial_melee_damage_upper = melee_damage_upper
		initial_flurry_delay = flurry_delay
		initial_flurry_pause = flurry_pause
		initial_move_to_delay = move_to_delay
		var/obj/effect/proc_holder/spell/pointed/axe_throw/AS = new /obj/effect/proc_holder/spell/pointed/axe_throw(src)
		AddSpell(AS)

/mob/living/simple_animal/hostile/abnormality/woodsman/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/begin_chain_pull(mob/living/carbon/human/target)
	chained_target = target
	chain_pull_count = 0
	var/datum/status_effect/chained/C = chained_target.has_status_effect(/datum/status_effect/chained)
	if(!C)
		C = chained_target.apply_status_effect(/datum/status_effect/chained)
		C.W = src

	update_chain_visuals()
	pull_loop()


/mob/living/simple_animal/hostile/abnormality/woodsman/proc/pull_loop()
	if(!chained_target || !can_see(src, chained_target, 14))
		release_target()
		return

	if(IsKnockdown(chained_target))
		release_target()

	var/current_dist = get_dist(get_turf(chained_target), get_turf(src))
	if (current_dist < 2)
		chained_target.Knockdown(3 SECONDS)
		release_target()
		return

	chain_pull_count++

	var/pull_distance = NORMAL_PULL_DISTANCE
	if (chain_pull_count % 3 == 0)
		pull_distance = HEAVY_PULL_DISTANCE

	var/delay = NORMAL_PULL_DELAY
	if (chain_pull_count % 3 == 2)
		delay = HEAVY_PULL_DELAY

	pull_target(pull_distance)
	update_chain_visuals()

	active_pull_timer = addtimer(CALLBACK(src, PROC_REF(pull_loop)), delay, TIMER_STOPPABLE)


/mob/living/simple_animal/hostile/abnormality/woodsman/proc/pull_target(distance)
	if(!chained_target)
		return
	if (chained_target.stat == DEAD)
		release_target()

	var/turf/T = get_turf(src)
	var/turf/target_turf = get_turf(chained_target)

	// Calculate throw speed based on distance
	var/throw_speed = 2
	if(distance >= HEAVY_PULL_DISTANCE)
		throw_speed = 3

	// Throw the target towards the woodsman
	chained_target.throw_at(T, distance, throw_speed, src)
	playsound(target_turf, 'sound/weapons/chainhit.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/update_chain_visuals()
	if(!chained_target)
		if(chain_beam)
			QDEL_NULL(chain_beam)
		return

	if(!chain_beam)
		chain_beam = Beam(chained_target, icon_state="chain")
	// Beam datum will handle updating the visuals automatically when either end moves

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/release_target()
	if(!chained_target)
		return

	chained_target.remove_status_effect(/datum/status_effect/chained)
	chained_target = null
	chain_pull_count = 0
	update_chain_visuals()
	deltimer(active_pull_timer)

// Status effect for chained targets
/datum/status_effect/chained
	id = "chained"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/chained
	var/mob/living/simple_animal/hostile/abnormality/woodsman/W
	var/view_range = 7

/atom/movable/screen/alert/status_effect/chained
	name = "Chained"
	desc = "You've been caught by the woodsman's chain!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "locked"

// Movement restriction for chained targets
/datum/status_effect/chained/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_movement))

/datum/status_effect/chained/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
	. = ..()

/datum/status_effect/chained/proc/check_movement(mob/living/carbon/human/H, turf/NewLoc)
	SIGNAL_HANDLER

	if(!istype(H))
		return

	if(!W || !(H in view(view_range, W)))
		H.remove_status_effect(/datum/status_effect/chained)
		return

	var/current_dist = get_dist(get_turf(W), get_turf(H))
	var/new_dist = get_dist(get_turf(W), NewLoc)

	if(new_dist > current_dist)
		to_chat(H, "<span class='warning'>The chain prevents you from moving further away!</span>")
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE


/mob/living/simple_animal/hostile/abnormality/woodsman/Life()
	. = ..()
	if((combat_map) && !(ramping == 0) && ramping_decay <= world.time)
		if(soundloop.timerid)
			soundloop.stop()
		ramping = 0
		to_chat(src, span_notice("You feel a cold emptyness in your chest... it's still not enough."))
		RampingUpdate()

/mob/living/simple_animal/hostile/abnormality/woodsman/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		if(H.stat == DEAD || (H.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(H, TRAIT_NODEATH)) || H.health <= -30)
			Heal(H)
			return ..()
		else
			if(combat_map)
				GainRamping(1)
	if(client)
		switch(chosen_attack)
			if(1)
				Woodsman_Flurry(attacked_target)
			if(2)
				return ..()
		return ..()
	if(isliving(attacked_target) && flurry_cooldown <= world.time && get_dist(src, attacked_target) <= 2 && prob(30))
		Woodsman_Flurry(attacked_target)
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/PickTarget(list/Targets) // We attack corpses first if there are any
	if (health > (maxHealth * 0.75))
		return ..()
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if((L.health < 0 || L.stat == DEAD) && ishuman(L))
			highest_priority += L
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/GainRamping(amount)
	ramping += amount
	ramping_decay = world.time + ramping_decay_time
	if(ramping >= ramping_max)
		ramping = ramping_max
		if(!soundloop.timerid)
			to_chat(src, span_warning("Your chest echoes loudly... is this how it feels to have a thumping heart?"))
			soundloop.start()
		return
	RampingUpdate()

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/RampingUpdate()
	melee_damage_lower = initial_melee_damage_lower + (ramping * 3)
	melee_damage_upper = initial_melee_damage_upper + (ramping * 3)
	flurry_delay = initial_flurry_delay - (ramping * 0.1) SECONDS
	flurry_pause = initial_flurry_pause - (ramping * 0.01) SECONDS
	ChangeMoveToDelay(initial_move_to_delay - (ramping * 0.22))

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/Heal(mob/living/carbon/human/body)
	src.visible_message(span_warning("[src] plunges their hand into [body]'s chest and rips out their heart!"), \
		span_notice("You plung your hand into the body of [body] and take their heart, placing it into your cold chest. It's not enough."), \
		span_hear("You hear a metal clange and squishing."))
	src.adjustBruteLoss(-666) // Actually just the conversion of health he heals scaled to equivalent health that Helper has.
	for(var/obj/item/organ/O in body.getorganszone(BODY_ZONE_CHEST, TRUE))
		if(istype(O,/obj/item/organ/heart))
			O.Remove(body)
			QDEL_NULL(O)
			break
	body.gib()
	if(combat_map)
		GainRamping(10)

/mob/living/simple_animal/hostile/abnormality/woodsman/CanAttack(atom/the_target)
	if(iscarbon(the_target))
		var/mob/living/carbon/human/L = the_target
		if(L.stat == DEAD)
			return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/OpenFire()
	if(!can_act)
		return FALSE
	if(client)
		switch(chosen_attack)
			if(1)
				Woodsman_Flurry(target)
			if(2)
				return
		return

	if(flurry_cooldown <= world.time)
		if(prob(75))
			Woodsman_Flurry(target)

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/Woodsman_Flurry(target)
	if(flurry_cooldown > world.time)
		return
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step(source_turf, EAST), get_ranged_target_turf(source_turf, EAST, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step(source_turf, WEST), get_ranged_target_turf(source_turf, WEST, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step(source_turf, SOUTH), get_ranged_target_turf(source_turf, SOUTH, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step(source_turf, NORTH), get_ranged_target_turf(source_turf, NORTH, flurry_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, flurry_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, flurry_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			return
	if (!LAZYLEN(area_of_effect))
		return
	flurry_cooldown = world.time + flurry_cooldown_time
	can_act = FALSE
	dir = dir_to_target
	playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 75, 0, 5)
	icon_state = "woodsman_prepare"
	SLEEP_CHECK_DEATH(flurry_delay)
	for (var/i = 0; i < flurry_count; i++)
		icon_state = icon_living
		var/list/been_hit = list()
		for(var/turf/T in area_of_effect)
			new /obj/effect/temp_visual/smash_effect(T)
			been_hit = HurtInTurf(T, been_hit, i > 6 ? flurry_big : flurry_small, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
		if (i > 6)
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_strong.ogg', 100, 0, 8) // BAM
		else
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_attack.ogg', 75, 0, 5)
		SLEEP_CHECK_DEATH(flurry_pause)
		icon_state = "woodsman_prepare"
	icon_state = icon_living
	can_act = TRUE


/mob/living/simple_animal/hostile/abnormality/woodsman/WorkChance(mob/living/carbon/human/user, chance, work_type)
	var/newchance = chance
	if (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 60)
		newchance = chance-20
	return newchance

/mob/living/simple_animal/hostile/abnormality/woodsman/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 60)
		if(prob(40))
			datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/woodsman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/woodsman/OnQliphothChange(mob/living/carbon/human/user)
	. = ..()
	switch(datum_reference.qliphoth_meter)
		if(1)
			icon_state = "woodsman_prepare"
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 75, 0, 5)
		if(2)
			icon_state = "woodsman"

/mob/living/simple_animal/hostile/abnormality/woodsman/AttemptWork(mob/living/carbon/human/user, work_type)
	. = ..()
	if (GODMODE in user.status_flags)
		return
	if(datum_reference.qliphoth_meter == 1)
		to_chat(user, span_userdanger("The Woodsman swings his axe down!"))
		datum_reference.qliphoth_change(-1)
		user.gib()

/mob/living/simple_animal/hostile/abnormality/woodsman/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(!IsContained() || user == src || !ishuman(M) || (GODMODE in M.status_flags))
		return FALSE
	. = ..()
	to_chat(user, span_userdanger("The Woodsman swings his axe down and...!"))
	SLEEP_CHECK_DEATH(2 SECONDS)
	var/obj/item/organ/heart/O = M.getorgan(/obj/item/organ/heart)
	if(istype(O))
		O.Remove(M)
		QDEL_NULL(O)
	M.gib()
	if(datum_reference.qliphoth_meter == 1)
		to_chat(user, span_nicegreen("Rests it on the ground."))
		datum_reference.qliphoth_change(1)
		icon_state = "woodsman"
	else
		to_chat(user, span_userdanger("Stands up!"))
		datum_reference.qliphoth_change(-2)

/mob/living/simple_animal/hostile/abnormality/woodsman/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	layer = LARGE_MOB_LAYER
	icon_state = icon_living
	if (!isnull(user))
		GiveTarget(user)

