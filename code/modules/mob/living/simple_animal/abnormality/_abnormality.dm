/mob/living/simple_animal/hostile/abnormality
	name = "Abnormality"
	desc = "An abnormality..? You should report this to the Head!"
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = DEAD
	layer = LARGE_MOB_LAYER
	a_intent = INTENT_HARM
	del_on_death = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	move_resist = MOVE_FORCE_STRONG // They kept stealing my abnormalities
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	blood_volume = BLOOD_VOLUME_NORMAL // THERE WILL BE BLOOD. SHED.
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	/// Can this abnormality spawn normally during the round?
	var/can_spawn = TRUE
	/// Reference to the datum we use
	var/datum/abnormality/datum_reference = null
	/// The threat level of the abnormality. It is passed to the datum on spawn
	var/threat_level = ZAYIN_LEVEL
	/// Separate level of fear. If null - will use threat level.
	var/fear_level = null
	/// Maximum qliphoth level, passed to datum
	var/start_qliphoth = 0
	/// Can it breach? If TRUE - zero_qliphoth() calls breach_effect()
	var/can_breach = FALSE
	/// List of humans that witnessed the abnormality breaching
	var/list/breach_affected = list()
	/// Copy-pasted from megafauna.dm: This allows player controlled mobs to use abilities
	var/chosen_attack = 1
	/// Attack actions, sets chosen_attack to the number in the action
	var/list/attack_action_types = list()
	/// If there is a small sprite icon for players controlling the mob to use
	var/small_sprite_type
	/// Work types and chances
	var/list/work_chances = list(
							ABNORMALITY_WORK_INSTINCT = list(50, 55, 60, 65, 70),
							ABNORMALITY_WORK_INSIGHT = list(50, 55, 60, 65, 70),
							ABNORMALITY_WORK_ATTACHMENT = list(50, 55, 60, 65, 70),
							ABNORMALITY_WORK_REPRESSION = list(50, 55, 60, 65, 70)
							)
	/// How much damage is dealt to user on each work failure
	var/work_damage_amount = 2
	/// What damage type is used for work failures
	var/work_damage_type = RED_DAMAGE
	/// Maximum amount of PE someone can obtain per work procedure, if not null or 0.
	var/max_boxes = null
	/// List of ego equipment datums
	var/list/ego_list = list()
	/// EGO Gifts
	var/datum/ego_gifts/gift_type = null
	var/gift_chance = null
	var/gift_message = null
	/// Patrol Code
	var/can_patrol = TRUE
	var/patrol_cooldown
	var/patrol_cooldown_time = 30 SECONDS
	var/list/patrol_path = list()
	var/patrol_tries = 0 //max of 5

/mob/living/simple_animal/hostile/abnormality/Initialize(mapload)
	. = ..()
	for(var/action_type in attack_action_types)
		var/datum/action/innate/abnormality_attack/attack_action = new action_type()
		attack_action.Grant(src)
	if(small_sprite_type)
		var/datum/action/small_sprite/small_action = new small_sprite_type()
		small_action.Grant(src)
	if(fear_level == null)
		fear_level = threat_level
	if (isnull(gift_chance))
		switch(threat_level)
			if(ZAYIN_LEVEL)
				gift_chance = 5
			if(TETH_LEVEL)
				gift_chance = 4
			if(HE_LEVEL)
				gift_chance = 3
			if(WAW_LEVEL)
				gift_chance = 2
			if(ALEPH_LEVEL)
				gift_chance = 1
			else
				gift_chance = 0
	if(isnull(gift_message))
		gift_message = "You are granted a gift by [src]!"

/mob/living/simple_animal/hostile/abnormality/Destroy()
	if(istype(datum_reference)) // Respawn the mob on death
		datum_reference.current = null
		addtimer(CALLBACK (datum_reference, .datum/abnormality/proc/RespawnAbno), 30 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/Move()
	if(status_flags & GODMODE) // STOP STEALING MY FREAKING ABNORMALITIES
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	FearEffect()
	if(!can_patrol || client)
		return
	if(target && patrol_path) //if AI has acquired a target while on patrol, stop patrol
		patrol_reset()
		return
	if(AIStatus == AI_IDLE) //if AI is idle, begin checking for patrol
		if(patrol_cooldown <= world.time)
			if(!patrol_path || !patrol_path.len)
				patrol_select()
				if(patrol_path.len)
					patrol_move(patrol_path[patrol_path.len])

/mob/living/simple_animal/hostile/abnormality/proc/patrol_select()
	var/turf/target_center
	var/list/potential_centers = list()
	for(var/pos_targ in GLOB.department_centers)
		var/possible_center_distance = get_dist(src, pos_targ)
		if(possible_center_distance > 4 && possible_center_distance < 46)
			potential_centers += pos_targ
	if(LAZYLEN(potential_centers))
		target_center = pick(potential_centers)
	else
		target_center = pick(GLOB.department_centers)
	patrol_path = get_path_to(src, target_center, /turf/proc/Distance_cardinal, 0, 200)

/mob/living/simple_animal/hostile/abnormality/proc/patrol_reset()
	patrol_path = null
	patrol_tries = 0
	stop_automated_movement = 0
	patrol_cooldown = world.time + patrol_cooldown_time

/mob/living/simple_animal/hostile/abnormality/proc/patrol_move(dest)
	if(client || target || status_flags & GODMODE)
		return FALSE
	if(!dest || !patrol_path || !patrol_path.len) //A-star failed or a path/destination was not set.
		return FALSE
	stop_automated_movement = 1
	dest = get_turf(dest) //We must always compare turfs, so get the turf of the dest var if dest was originally something else.
	var/turf/last_node = get_turf(patrol_path[patrol_path.len]) //This is the turf at the end of the path, it should be equal to dest.
	if(get_turf(src) == dest) //We have arrived, no need to move again.
		return TRUE
	else if(dest != last_node) //The path should lead us to our given destination. If this is not true, we must stop.
		patrol_reset()
		return FALSE
	if(patrol_tries < 5)
		patrol_step(dest)
	else
		patrol_reset()
		return FALSE
	addtimer(CALLBACK(src, .proc/patrol_move, dest), (move_to_delay+speed))
	return TRUE

/mob/living/simple_animal/hostile/abnormality/proc/patrol_step(dest)
	if(client || target  || status_flags & GODMODE || !patrol_path || !patrol_path.len)
		return FALSE
	if(patrol_path.len > 1)
		step_towards(src, patrol_path[1])
		if(get_turf(src) == patrol_path[1]) //Successful move
			if(!patrol_path || !patrol_path.len)
				return
			patrol_path.Cut(1, 2)
			patrol_tries = 0
		else
			patrol_tries++
			return FALSE
	else if(patrol_path.len == 1)
		step_to(src, dest)
		patrol_reset()
	return TRUE

// Applies fear damage to everyone in range
/mob/living/simple_animal/hostile/abnormality/proc/FearEffect()
	if(fear_level <= 0)
		return
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in breach_affected)
			continue
		breach_affected += H
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			to_chat(H, "<span class='notice'>This again...?")
			H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
			continue
		var/sanity_result = clamp(fear_level - get_user_level(H), -1, 5)
		var/sanity_damage = 0
		var/result_text = FearEffectText(H, sanity_result)
		switch(sanity_result)
			if(-INFINITY to 0)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
				to_chat(H, "<span class='notice'>[result_text]</span>")
				continue
			if(1)
				sanity_damage = -(H.maxSanity*0.1)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_1)
				to_chat(H, "<span class='warning'>[result_text]</span>")
			if(2)
				sanity_damage = -(H.maxSanity*0.3)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_2)
				to_chat(H, "<span class='danger'>[result_text]</span>")
			if(3)
				sanity_damage = -(H.maxSanity*0.6)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_3)
				to_chat(H, "<span class='userdanger'>[result_text]</span>")
			if(4)
				sanity_damage = -(H.maxSanity*0.95)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
				to_chat(H, "<span class='userdanger'><b>[result_text]</b></span>")
			if(5)
				sanity_damage = -(H.maxSanity)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
		H.adjustSanityLoss(sanity_damage)
	return

/mob/living/simple_animal/hostile/abnormality/proc/FearEffectText(mob/affected_mob, level = 0)
	level = num2text(clamp(level, -1, 5))
	var/list/result_text_list = list(
		"-1" = list("I've got this.", "How boring.", "Doesn't even phase me."),
		"0" = list("Just calm down, do what we always do.", "Just don't lose your head and stick to the manual.", "Focus..."),
		"1" = list("Hah, I'm getting nervous.", "Breathe in, breathe out...", "It'll be fine if we focus, I think..."),
		"2" = list("There's no room for error here.", "My legs are trembling...", "Damn, it's scary."),
		"3" = list("GODDAMN IT!!!!", "H-Help...", "I don't want to die!"),
		"4" = list("What am I seeing...?", "I-I can't take it...", "I can't understand..."),
		"5" = list("......")
		)
	return pick(result_text_list[level])

// Called by datum_reference when the abnormality has been fully spawned
/mob/living/simple_animal/hostile/abnormality/proc/PostSpawn()
	return

// transfers a var to the datum to be used later
/mob/living/simple_animal/hostile/abnormality/proc/TransferVar(index, value)
	if(isnull(datum_reference))
		return
	LAZYSET(datum_reference.transferable_var, value, index)

// Access an item in the "transferable_var" list of the abnormality's datum
/mob/living/simple_animal/hostile/abnormality/proc/RememberVar(index)
	if(isnull(datum_reference))
		return
	return LAZYACCESS(datum_reference.transferable_var, index)


// Modifiers for work chance
/mob/living/simple_animal/hostile/abnormality/proc/work_chance(mob/living/carbon/human/user, chance)
	return chance

// Called by datum_reference when work is done
/mob/living/simple_animal/hostile/abnormality/proc/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if (prob(gift_chance) && !isnull(gift_type))
		user.Apply_Gift(new gift_type)
		to_chat(user, "<span class='nicegreen'>[gift_message]</span>")
	if(pe >= datum_reference.success_boxes)
		success_effect(user, work_type, pe)
		return
	if(pe >= datum_reference.neutral_boxes)
		neutral_effect(user, work_type, pe)
		return
	failure_effect(user, work_type, pe)
	return

// Additional effects on good work result, if any
/mob/living/simple_animal/hostile/abnormality/proc/success_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Additional effects on neutral work result, if any
/mob/living/simple_animal/hostile/abnormality/proc/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Additional effects on work failure
/mob/living/simple_animal/hostile/abnormality/proc/failure_effect(mob/living/carbon/human/user, work_type, pe)
	return

// Additional effect on each individual work tick failure
/mob/living/simple_animal/hostile/abnormality/proc/worktick_failure(mob/living/carbon/human/user)
	user.apply_damage(work_damage_amount, work_damage_type, null, user.run_armor_check(null, work_damage_type), spread_damage = TRUE)
	return

// Dictates whereas this type of work can be performed at the moment or not
/mob/living/simple_animal/hostile/abnormality/proc/attempt_work(mob/living/carbon/human/user, work_type)
	return TRUE

// Effects when qliphoth reaches 0
/mob/living/simple_animal/hostile/abnormality/proc/zero_qliphoth(mob/living/carbon/human/user)
	if(can_breach)
		breach_effect(user)
	return

// Special breach effect for abnormalities with can_breach set to TRUE
/mob/living/simple_animal/hostile/abnormality/proc/breach_effect(mob/living/carbon/human/user)
	toggle_ai(AI_ON) // Run.
	status_flags &= ~GODMODE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ABNORMALITY_BREACH, src)

// On lobotomy_corp subsystem qliphoth event
/mob/living/simple_animal/hostile/abnormality/proc/OnQliphothEvent()
	if(istype(datum_reference)) // Reset chance debuff
		datum_reference.overload_chance = 0
	return

// When qliphoth meltdown begins
/mob/living/simple_animal/hostile/abnormality/proc/meltdown_start()
	return

/mob/living/simple_animal/hostile/abnormality/proc/OnQliphothChange(mob/living/carbon/human/user)
	return

///implants the abno with a slime radio implant, only really relevant during admeme or sentient abno rounds
/mob/living/simple_animal/hostile/abnormality/proc/AbnoRadio()
	var/obj/item/implant/radio/slime/imp = new(src)
	imp.implant(src, src) //acts as if the abno is both the implanter and the one being implanted, which is technically true I guess?
	datum_reference.abno_radio = TRUE

// Actions
/datum/action/innate/abnormality_attack
	name = "Megafauna Attack"
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = ""
	var/mob/living/simple_animal/hostile/abnormality/A
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/abnormality_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/abnormality))
		A = L
		return ..()
	return FALSE

/datum/action/innate/abnormality_attack/Activate()
	A.chosen_attack = chosen_attack_num
	to_chat(A, chosen_message)
