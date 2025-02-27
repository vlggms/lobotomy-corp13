/mob/living/simple_animal/hostile/abnormality
	name = "Abnormality"
	desc = "An abnormality..? You should report this to the Head!"
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = HARD_CRIT
	layer = LARGE_MOB_LAYER
	a_intent = INTENT_HARM
	del_on_death = TRUE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
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
	can_patrol = TRUE
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
	/// Can it breach? If TRUE - ZeroQliphoth() calls BreachEffect()
	var/can_breach = FALSE
	/// List of humans that witnessed the abnormality breaching
	var/list/breach_affected = list()
	/// Copy-pasted from megafauna.dm: This allows player controlled mobs to use abilities
	var/chosen_attack = 1
	/// Attack actions, sets chosen_attack to the number in the action
	var/list/attack_action_types = list()
	/// If there is a small sprite icon for players controlling the mob to use
	var/small_sprite_type = /datum/action/small_sprite/abnormality
	/// Work types and chances
	var/list/work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 55, 60, 65, 70),
		ABNORMALITY_WORK_INSIGHT = list(50, 55, 60, 65, 70),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 55, 60, 65, 70),
		ABNORMALITY_WORK_REPRESSION = list(50, 55, 60, 65, 70),
	)
	/// Work Types and corresponding their attributes
	var/list/work_attribute_types = WORK_TO_ATTRIBUTE
	/// How much damage is dealt to user on each work failure
	var/work_damage_amount = 2
	/// What damage type is used for work failures
	/// Can be a list, work_damage_amount in that case is divided by the objects in the list and visuals are chosen randomly
	var/work_damage_type = RED_DAMAGE
	/// Maximum amount of PE someone can obtain per work procedure, if not null or 0.
	var/max_boxes = null
	/// How much PE you have to produce for good result, if not null or 0.
	var/success_boxes = null
	/// How much PE you have to produce for neutral result, if not null or 0.
	var/neutral_boxes = null
	/// Check to see if the abnormality hates goods or can't get them.
	var/good_hater = FALSE
	/// List of ego equipment datums
	var/list/ego_list = list()
	/// EGO Gifts
	var/datum/ego_gifts/gift_type = null
	var/gift_chance = null
	var/gift_message = null
	var/abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL
	/// Abnormality Chemistry System
	// Typepath of the abnormality's chemical.
	var/chem_type
	// Amount of abnochem produced by one harvest. One harvest is prepared per work completed.
	var/chem_yield = 15
	// Time delay between harvests. Shouldn't need to be changed in most cases, since the amount of harvests available is gated by work.
	var/chem_cooldown = 5 SECONDS
	var/chem_cooldown_timer = 0
	// Harvest phrases.
	var/harvest_phrase = span_notice("You harvest... something... into %VESSEL.")
	var/harvest_phrase_third = "%PERSON harvests... something... into %VESSEL."
	// Dummy chemicals - called if chem_type is null.
	var/list/dummy_chems = list(
		/datum/reagent/abnormality/nutrition,
		/datum/reagent/abnormality/cleanliness,
		/datum/reagent/abnormality/consensus,
		/datum/reagent/abnormality/amusement,
		/datum/reagent/abnormality/violence,
	)
	// Increased Abno appearance chance
	/// Assoc list, you do [path] = [probability_multiplier] for each entry
	var/list/grouped_abnos = list()
	//Abnormaltiy portrait, updated on spawn if they have one.
	var/portrait = "UNKNOWN"
	var/core_icon = ""
	var/core_enabled = TRUE

	/// If an abnormality should not be possessed even if possessibles are enabled, mainly for admins.
	var/do_not_possess = FALSE

	// secret skin variables ahead

	/// Toggles if the abnormality has a secret form and can spawn naturally
	var/secret_chance = FALSE
	/// tracks if the current abnormality is in its secret form
	var/secret_abnormality = FALSE

	/// if assigned, this gift will be given instead of a normal one on a successfull gift aquisition whilst a secret skin is in effect
	var/secret_gift

	/// An icon state assigned to the abnormality in its secret form
	var/secret_icon_state
	/// An icon state assigned when an abnormality is alive
	var/secret_icon_living
	// An icon state assigned when an abnormality gets suppressed in its secret form
	var/secret_icon_dead
	/// An icon file assigned to the abnormality in its secret form, usually should not be needed to change
	var/secret_icon_file

	/// Offset for secret skins in the X axis
	var/secret_horizontal_offset = 0
	/// Offset for secret skins in the Y axis
	var/secret_vertical_offset = 0

	/// Final Observation stuffs
	/// The prompt we get alongside our choices for observing it
	var/observation_prompt = "The abnormality is watching you. What will you do?"
	/**
	 * observation_choices is made in the format of:
	 * "Choice" = list(TRUE or FALSE [depending on if the answer is correct], "Response"),
	 */
	var/list/observation_choices = list(
		"Approach" = list(TRUE, "You approach the abnormality... and obtain a gift from it."),
		"Leave" = list(TRUE, "You leave the abnormality... and before you notice a gift is in your hands."),
	)
	/// Is there a currently on-going observation?
	var/observation_in_progress = FALSE

	// rcorp stuff
	var/rcorp_team

/mob/living/simple_animal/hostile/abnormality/Initialize(mapload)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(!(type in GLOB.cached_abno_work_rates))
		GLOB.cached_abno_work_rates[type] = work_chances.Copy()
	if(!(type in GLOB.cached_abno_resistances))
		GLOB.cached_abno_resistances[type] = damage_coeff.getList()
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
	else
		gift_message += "\nYou are granted a gift by [src]!"

	if(secret_chance && (prob(1)))
		InitializeSecretIcon()

	//Abnormalities have no name here. And we don't want nonsentient ones to breach
	if(SSmaptype.maptype == "limbus_labs")
		name = "Limbus Company Specimen"
		faction = list("neutral")

/mob/living/simple_animal/hostile/abnormality/proc/InitializeSecretIcon()
	SHOULD_CALL_PARENT(TRUE) // if you ever need to override this proc, consider adding onto it instead or not using all the variables given
	secret_abnormality = TRUE

	if(secret_icon_file)
		icon = secret_icon_file

	if(secret_icon_state)
		icon_state = secret_icon_state

	if(secret_icon_living)
		icon_living = secret_icon_living

	if(secret_horizontal_offset)
		base_pixel_x = secret_horizontal_offset

	if(secret_vertical_offset)
		base_pixel_y = secret_vertical_offset

	if(secret_icon_dead)
		icon_dead = secret_icon_dead

/mob/living/simple_animal/hostile/abnormality/Destroy()
	SHOULD_CALL_PARENT(TRUE)
	if(istype(datum_reference)) // Respawn the mob on death
		datum_reference.current = null
		addtimer(CALLBACK (datum_reference, TYPE_PROC_REF(/datum/abnormality, RespawnAbno)), 30 SECONDS)
	else if(core_enabled)//Abnormality Cores are spawned if there is no console tied to the abnormality
		CreateAbnoCore(name, core_icon)//If cores are manually disabled for any reason, they won't generate.
	. = ..()
	if(loc)
		if(isarea(loc))
			var/area/a = loc
			a.RefreshLights()

/mob/living/simple_animal/hostile/abnormality/add_to_mob_list()
	. = ..()
	GLOB.abnormality_mob_list |= src

/mob/living/simple_animal/hostile/abnormality/remove_from_mob_list()
	. = ..()
	GLOB.abnormality_mob_list -= src

/mob/living/simple_animal/hostile/abnormality/Move(turf/newloc, dir, step_x, step_y)
	if(IsContained()) // STOP STEALING MY FREAKING ABNORMALITIES
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/ClickOn( atom/A, params )
	if(IsContained())
		return
	..()

/mob/living/simple_animal/hostile/abnormality/Life()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	FearEffect()

/mob/living/simple_animal/hostile/abnormality/CanStartPatrol()
	return (AIStatus == AI_IDLE) && !(status_flags & GODMODE)

/mob/living/simple_animal/hostile/abnormality/attackby(obj/O, mob/user, params)
	if(!istype(O, /obj/item/reagent_containers))
		return ..()
	if(!(status_flags & GODMODE))
		to_chat(user, span_notice("Now isn't the time!"))
		return
	if(datum_reference.console.mechanical_upgrades["abnochem"] == 0)
		to_chat(user, span_notice("This abnormality's cell is not properly equipped for substance extraction."))
		return
	if(world.time < chem_cooldown_timer)
		to_chat(user, span_notice("You may need to wait a bit longer."))
		return
	if(datum_reference.console.chem_charges < 1)
		to_chat(user, span_notice("No chemicals are ready for harvest. More work must be completed."))
		return
	datum_reference.console.chem_charges -= 1
	var/obj/item/reagent_containers/my_container = O
	HarvestChem(my_container, user)

/mob/living/simple_animal/hostile/abnormality/can_track(mob/living/user)
	if((status_flags & GODMODE))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/proc/HarvestChem(obj/item/reagent_containers/C, mob/user)
	visible_message(HarvestMessageProcess(harvest_phrase_third, user, C), HarvestMessageProcess(harvest_phrase, user, C))
	if(chem_type)
		C.reagents.add_reagent(chem_type, chem_yield)
	else
		C.reagents.add_reagent(pick(dummy_chems), chem_yield)
	chem_cooldown_timer = world.time + chem_cooldown

/mob/living/simple_animal/hostile/abnormality/proc/HarvestMessageProcess(str, user, vessel) // Jacked from announcement_system.dm
	str = replacetext(str, "%PERSON", "[user]")
	str = replacetext(str, "%VESSEL", "[vessel]")
	str = replacetext(str, "%ABNO", "[src]")
	return str


// Applies fear damage to everyone in range
/mob/living/simple_animal/hostile/abnormality/proc/FearEffect()
	if(fear_level <= 0)
		return
	for(var/mob/living/carbon/human/H in ohearers(7, src))
		if(H in breach_affected)
			continue
		if(H.stat == DEAD)
			continue
		breach_affected += H
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			to_chat(H, span_notice("This again...?"))
			H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
			continue
		var/sanity_result = clamp(fear_level - get_user_level(H), -1, 5)
		var/sanity_damage = 0
		var/result_text = FearEffectText(H, sanity_result)
		switch(sanity_result)
			if(-INFINITY to 0)
				H.apply_status_effect(/datum/status_effect/panicked_lvl_0)
				to_chat(H, span_notice("[result_text]"))
				continue
			if(1)
				sanity_damage = H.maxSanity*0.1
				H.apply_status_effect(/datum/status_effect/panicked_lvl_1)
				to_chat(H, span_warning("[result_text]"))
			if(2)
				sanity_damage = H.maxSanity*0.3
				H.apply_status_effect(/datum/status_effect/panicked_lvl_2)
				to_chat(H, span_danger("[result_text]"))
			if(3)
				sanity_damage = H.maxSanity*0.6
				H.apply_status_effect(/datum/status_effect/panicked_lvl_3)
				to_chat(H, span_userdanger("[result_text]"))
			if(4)
				sanity_damage = H.maxSanity*0.95
				H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
				to_chat(H, span_userdanger("<b>[result_text]</b>"))
			if(5)
				sanity_damage = H.maxSanity
				H.apply_status_effect(/datum/status_effect/panicked_lvl_4)
		H.adjustSanityLoss(sanity_damage)
		SEND_SIGNAL(H, COMSIG_FEAR_EFFECT, fear_level, sanity_damage)
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
		"5" = list("......"),
	)
	return pick(result_text_list[level])

// Called by datum_reference when the abnormality has been fully spawned
/mob/living/simple_animal/hostile/abnormality/proc/PostSpawn()
	SHOULD_CALL_PARENT(TRUE)
	HandleStructures()

// Moves structures already in its datum; Overrides can spawn structures here.
/mob/living/simple_animal/hostile/abnormality/proc/HandleStructures()
	SHOULD_CALL_PARENT(TRUE)
	if(!datum_reference)
		return FALSE
	// Ensures all structures are in their place after respawning
	for(var/atom/movable/A in datum_reference.connected_structures)
		A.forceMove(get_turf(datum_reference.landmark))
		A.x += datum_reference.connected_structures[A][1]
		A.y += datum_reference.connected_structures[A][2]
	return TRUE

// A little helper proc to spawn structures; Returns itself, so you can handle additional stuff later
/mob/living/simple_animal/hostile/abnormality/proc/SpawnConnectedStructure(atom/movable/A = null, x_offset = 0, y_offset = 0)
	if(!ispath(A))
		return
	if(!istype(datum_reference))
		return
	A = new A(get_turf(src))
	A.x += x_offset
	A.y += y_offset
	// We put it in datum ref for malicious purposes
	datum_reference.connected_structures[A] = list(x_offset, y_offset)
	return A

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
/mob/living/simple_animal/hostile/abnormality/proc/WorkChance(mob/living/carbon/human/user, chance, work_type)
	return chance

// Called by datum_reference when work is done
/mob/living/simple_animal/hostile/abnormality/proc/WorkComplete(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	SHOULD_CALL_PARENT(TRUE)
	if(pe >= datum_reference.success_boxes)
		SuccessEffect(user, work_type, pe, work_time, canceled)
	else if(pe >= datum_reference.neutral_boxes)
		NeutralEffect(user, work_type, pe, work_time, canceled)
	else
		FailureEffect(user, work_type, pe, work_time, canceled)
	PostWorkEffect(user, work_type, pe, work_time, canceled)
	GiftUser(user, pe)
	return

// Effects after work is done, regardless of result
/mob/living/simple_animal/hostile/abnormality/proc/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	return

// Additional effects on good work result, if any
/mob/living/simple_animal/hostile/abnormality/proc/SuccessEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	WorkCompleteEffect("good")
	return

// Additional effects on neutral work result, if any
/mob/living/simple_animal/hostile/abnormality/proc/NeutralEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	WorkCompleteEffect("normal")
	return

// Additional effects on work failure
/mob/living/simple_animal/hostile/abnormality/proc/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	WorkCompleteEffect("bad")
	return

// Visual effect for work completion
/mob/living/simple_animal/hostile/abnormality/proc/WorkCompleteEffect(state)
	var/turf/target_turf = get_ranged_target_turf(src, SOUTHWEST, 1)
	var/obj/effect/temp_visual/workcomplete/VFX = new(target_turf)
	VFX.icon_state = state
	return

// Giving an EGO gift to the user after work is complete
/mob/living/simple_animal/hostile/abnormality/proc/GiftUser(mob/living/carbon/human/user, pe, chance = gift_chance)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(user) || isnull(gift_type))
		return FALSE
	if(istype(user.ego_gift_list[initial(gift_type.slot)], gift_type)) // If we already have same gift - don't run the checks
		return FALSE
	if(pe <= 0 || !prob(chance))
		return FALSE
	var/datum/ego_gifts/EG
	if(secret_abnormality && secret_gift)
		EG = new secret_gift
	else
		EG = new gift_type
	EG.datum_reference = src.datum_reference
	user.Apply_Gift(EG)
	to_chat(user, span_nicegreen("[gift_message]"))
	return TRUE

// Additional effect on each work tick, whether successful or not
/mob/living/simple_animal/hostile/abnormality/proc/Worktick(mob/living/carbon/human/user)
	return

// Additional effect on each individual work tick success
/mob/living/simple_animal/hostile/abnormality/proc/WorktickSuccess(mob/living/carbon/human/user)
	return

// Additional effect on each individual work tick failure
/mob/living/simple_animal/hostile/abnormality/proc/WorktickFailure(mob/living/carbon/human/user)
	user.deal_damage(work_damage_amount, work_damage_type)
	WorkDamageEffect()
	return

// Visual effect for work damage
/mob/living/simple_animal/hostile/abnormality/proc/WorkDamageEffect()
	var/turf/target_turf = get_ranged_target_turf(src, SOUTHWEST, 1)
	var/obj/effect/temp_visual/roomdamage/damage = new(target_turf)
	if(!islist(work_damage_type))
		damage.icon_state = "[work_damage_type]"
	else // its a list, we gotta pick one
		var/list/damage_types = work_damage_type
		damage.icon_state = pick(damage_types)

// Dictates whereas this type of work can be performed at the moment or not
/mob/living/simple_animal/hostile/abnormality/proc/AttemptWork(mob/living/carbon/human/user, work_type)
	return TRUE

// Overrides the normal work delay. Called in abnormality_work.dm each worktick.
// init_work_speed is the vanilla value, work_speed is the value as modified by any previous use of SpeedOverride.
// Remember, this is altering the FINAL value. Returning 0 makes an instant worktick, returning 20 makes a 2 second worktick.
/mob/living/simple_animal/hostile/abnormality/proc/SpeedWorktickOverride(mob/living/carbon/human/user, work_speed, init_work_speed, work_type)
	return work_speed

// Overrides the normal work chance. See SpeedWorktickOverride's comments; this behaves identically, but for work chance.
/mob/living/simple_animal/hostile/abnormality/proc/ChanceWorktickOverride(mob/living/carbon/human/user, work_chance, init_work_chance, work_type)
	return work_chance

// Effects when qliphoth reaches 0
/mob/living/simple_animal/hostile/abnormality/proc/ZeroQliphoth(mob/living/carbon/human/user)
	if(can_breach)
		BreachEffect(user)
	return

// Special breach effect for abnormalities with can_breach set to TRUE
/mob/living/simple_animal/hostile/abnormality/proc/BreachEffect(mob/living/carbon/human/user, breach_type = BREACH_NORMAL)
	if(breach_type != BREACH_NORMAL && !can_breach)
		// If a custom breach is called and the mob has no way of handling it, just ignore it.
		// Should follow normal behaviour with ..()
		return FALSE
	toggle_ai(AI_ON) // Run.
	status_flags &= ~GODMODE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ABNORMALITY_BREACH, src)
	if(istype(datum_reference))
		deadchat_broadcast(" has breached containment.", "<b>[src.name]</b>", src, get_turf(src))
	FearEffect()
	return TRUE

// On lobotomy_corp subsystem qliphoth event
/mob/living/simple_animal/hostile/abnormality/proc/OnQliphothEvent()
	if(istype(datum_reference)) // Reset chance debuff
		datum_reference.overload_chance = list()
	return

// When qliphoth meltdown begins
/mob/living/simple_animal/hostile/abnormality/proc/MeltdownStart()
	if(istype(datum_reference))
		datum_reference.overload_chance = list()
	return

/mob/living/simple_animal/hostile/abnormality/proc/OnQliphothChange(mob/living/carbon/human/user, amount = 0, pre_qlip = start_qliphoth)
	return

///implants the abno with a slime radio implant, only really relevant during admeme or sentient abno rounds
/mob/living/simple_animal/hostile/abnormality/proc/AbnoRadio()
	var/obj/item/implant/radio/slime/imp = new(src)
	imp.implant(src, src) //acts as if the abno is both the implanter and the one being implanted, which is technically true I guess?
	datum_reference.abno_radio = TRUE

/mob/living/simple_animal/hostile/abnormality/proc/IsContained() //Are you in a cell and currently contained?? If so stop.
//Contained checks for: If the abnorm is godmoded AND one of the following: It does not have a qliphoth meter OR has qliphoth remaining OR no qliphoth but can't breach
	if(!datum_reference) //They were never contained in the first place
		return FALSE
	if((status_flags & GODMODE) && (!datum_reference.qliphoth_meter_max || datum_reference.qliphoth_meter || (!datum_reference.qliphoth_meter && !can_breach)))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/proc/GetName()
	return name

/mob/living/simple_animal/hostile/abnormality/proc/GetRiskLevel()
	return threat_level

/mob/living/simple_animal/hostile/abnormality/proc/GetPortrait()
	return portrait

/mob/living/simple_animal/hostile/abnormality/proc/FinalObservation(mob/living/carbon/human/user)
	if(!datum_reference.observation_ready) //They didn't refresh the panel
		to_chat(user, span_notice("This final observation has already been completed."))
		return
	if(gift_type && !istype(user.ego_gift_list[gift_type.slot], /datum/ego_gifts/empty))
		if(istype(user.ego_gift_list[gift_type.slot], gift_type))
			to_chat(user, span_warning("You have already recieved a gift from this abnormality. Do not be greedy!"))
			return
		to_chat(user, span_warning("You already have a gift in the [gift_type.slot] slot, dissolve it first!"))
		return

	if(observation_in_progress)
		to_chat(user, span_notice("Someone is already observing [src]!"))
		return
	observation_in_progress = TRUE
	var/answer = final_observation_alert(user, "[observation_prompt]", "Final Observation of [src]", shuffle(observation_choices), timeout = 60 SECONDS)
	if(answer == "timed out")
		ObservationResult(user, reply = answer)
	else
		var/list/answer_vars = observation_choices[answer]
		ObservationResult(user, answer_vars[1], answer_vars[2])

	observation_in_progress = FALSE

/mob/living/simple_animal/hostile/abnormality/proc/ObservationResult(mob/living/carbon/human/user, success = FALSE, reply = "")
	if(success) //Successful, could override for longer observations as well.
		final_observation_alert(user, "[reply]", "OBSERVATION SUCCESS", list("Ok"), timeout = 20 SECONDS) //Some of these take a long time to read
		if(gift_type)
			user.Apply_Gift(new gift_type)
			playsound(get_turf(user), 'sound/machines/synth_yes.ogg', 30 , FALSE)
	else
		if(reply != "timed out")
			final_observation_alert(user, "[reply]", "OBSERVATION FAIL", list("Ok"), timeout = 20 SECONDS)
		playsound(get_turf(user), 'sound/machines/synth_no.ogg', 30 , FALSE)
	datum_reference.observation_ready = FALSE


/mob/living/simple_animal/hostile/abnormality/proc/CreateAbnoCore()//this is called by abnormalities on Destroy()
	var/obj/structure/abno_core/C = new(get_turf(src))
	C.name = initial(name) + " Core"
	C.desc = "The core of [initial(name)]"
	C.icon_state = core_icon
	C.contained_abno = src.type
	C.threat_level = threat_level
	switch(GetRiskLevel())
		if(1)
			return
		if(2)
			C.icon = 'ModularTegustation/Teguicons/abno_cores/teth.dmi'
		if(3)
			C.icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
		if(4)
			C.icon = 'ModularTegustation/Teguicons/abno_cores/waw.dmi'
		if(5)
			C.icon = 'ModularTegustation/Teguicons/abno_cores/aleph.dmi'

/mob/living/simple_animal/hostile/abnormality/spawn_gibs()
	if(blood_volume <= 0)
		return
	return new /obj/effect/gibspawner/generic(drop_location(), src, get_static_viruses())

// Actions
/datum/action/innate/abnormality_attack
	name = "Abnormality Attack"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = ""
	background_icon_state = "bg_abnormality"
	var/mob/living/simple_animal/hostile/abnormality/A
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/abnormality_attack/Destroy()
	A = null
	return ..()

/datum/action/innate/abnormality_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/abnormality))
		A = L
		return ..()
	return FALSE

/datum/action/innate/abnormality_attack/Activate()
	A.chosen_attack = chosen_attack_num
	to_chat(A, chosen_message)

/datum/action/innate/abnormality_attack/toggle
	name = "Toggle Attack"
	var/toggle_message
	var/toggle_attack_num = 1
	var/button_icon_toggle_activated = ""
	var/button_icon_toggle_deactivated = ""

/datum/action/innate/abnormality_attack/toggle/Activate()
	. = ..()
	button_icon_state = button_icon_toggle_activated
	UpdateButtonIcon()
	active = TRUE


/datum/action/innate/abnormality_attack/toggle/Deactivate()
	A.chosen_attack = toggle_attack_num
	to_chat(A, toggle_message)
	button_icon_state = button_icon_toggle_deactivated
	UpdateButtonIcon()
	active = FALSE
