//A subtype of hostile intended primarily for citymaps.
//It has a few things that abnormalities usually have, which lets admins and mappers use them in similar fashion.
/mob/living/simple_animal/hostile/distortion
	name = "Distortion"
	desc = "A distortion..? You should report this to the Head!"
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
	move_resist = MOVE_FORCE_STRONG // They kept stealing my distortions
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	blood_volume = BLOOD_VOLUME_NORMAL // THERE WILL BE BLOOD. SHED.
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	can_patrol = TRUE
	/// Can this thing spawn?
	var/can_spawn = 0
	/// Copy-pasted from megafauna.dm: This allows player controlled mobs to use abilities
	var/chosen_attack = 1
	/// Attack actions, sets chosen_attack to the number in the action
	var/list/attack_action_types = list()
	/// If there is a small sprite icon for players controlling the mob to use
	var/small_sprite_type = /datum/action/small_sprite/abnormality
	/// List of humans already affected by fear
	var/list/breach_affected = list()
	/// Level of fear, should be used sparingly.
	var/fear_level = ZAYIN_LEVEL
	/// List of ego equipment drops, if used.
	var/list/ego_list = list()
	/// Variable holding the egoist, for use in PostManifest()
	var/mob/living/carbon/human/egoist = null
	/// Variable determining whether or not a new egoist needs to be made. The following variables are irrelevant if this variable is true.
	var/new_egoist = FALSE
	/// Variable to determine starting stats of the egoist. You MUST have the minimum required to meet the E.G.O. stat requirement.
	var/egoist_attributes = 0
	/// Default visual effect for a successful unmanifest
	var/unmanifest_effect = /obj/effect/temp_visual/beam_in
	/// Specific names for distortions when unmanifested
	var/list/egoist_names = list()
	/// Specific outfit datum for the unmanifested to spawn with; civilian by default.
	var/egoist_outfit = /datum/outfit/job/civilian
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. When if null, they are unaffected by it.
	var/monolith_abnormality

/mob/living/simple_animal/hostile/distortion/Initialize(mapload)
	. = ..()
	UpdateSpeed()

/mob/living/simple_animal/hostile/distortion/add_to_mob_list()
	. = ..()
	GLOB.distortion_mob_list |= src

/mob/living/simple_animal/hostile/distortion/remove_from_mob_list()
	. = ..()
	GLOB.distortion_mob_list -= src

/mob/living/simple_animal/hostile/distortion/CanStartPatrol()
	return (AIStatus == AI_IDLE) && !(status_flags & GODMODE)

/mob/living/simple_animal/hostile/distortion/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	FearEffect()

// Implants the mob with a slime radio implant, only really relevant during admeme or sentient abno rounds
/mob/living/simple_animal/hostile/distortion/proc/AbnoRadio()
	var/obj/item/implant/radio/slime/imp = new(src)
	imp.implant(src, src) //acts as if the abno is both the implanter and the one being implanted, which is technically true I guess?

// Applies fear damage to everyone in range
/mob/living/simple_animal/hostile/distortion/proc/FearEffect()
	if(fear_level <= 0)
		return
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in breach_affected)
			continue
		if(H.stat == DEAD)
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

/mob/living/simple_animal/hostile/distortion/proc/FearEffectText(mob/affected_mob, level = 0)
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

//Unmanifesting
/mob/living/simple_animal/hostile/distortion/proc/Unmanifest()
	if(QDELETED(src))
		return
	for(var/mob/living/carbon/human/person in src)
		if(person)
			egoist = person
			REMOVE_TRAIT(person, TRAIT_NOBREATH, MAGIC_TRAIT) //Since they're free now they have to breathe again
			REMOVE_TRAIT(person, TRAIT_COMBATFEAR_IMMUNE, MAGIC_TRAIT) //We don't want the player suffocating inside
			break
	if(!egoist)
		egoist = new(get_turf(src))
		new_egoist = TRUE
		forceMove(egoist) //Hide the distortion inside of the spawned human in case of shinanigains
	can_patrol = FALSE
	patrol_reset()
	density = FALSE
	AIStatus = AI_OFF
	ChangeResistances(list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)) // Prevent death jank
	if(unmanifest_effect)
		new unmanifest_effect(get_turf(src))
	if(new_egoist)
		var/newname
		if(!LAZYLEN(egoist_names))
			newname = random_unique_name(gender, attempts_to_find_unique_name=10)
		else
			newname = pick(egoist_names)
		egoist.name = newname
		egoist.real_name = newname
		egoist.gender = gender
		if(egoist_outfit)
			egoist.equipOutfit(egoist_outfit)
	if(egoist_attributes)
		if(new_egoist)
			egoist.adjust_all_attribute_levels(egoist_attributes)
		else
			for(var/attribute in egoist.attributes)
				var/datum/attribute/the_attribute = attribute
				var/attribute_level = get_raw_level(egoist, the_attribute)
				if(attribute_level >= egoist_attributes)
					continue
				egoist.adjust_attribute_level(the_attribute, egoist_attributes - attribute_level)
	for(var/gear in ego_list)
		if(ispath(gear, /obj/item/clothing/suit/armor/ego_gear))
			var/suit_slot_item = egoist.get_item_by_slot(ITEM_SLOT_OCLOTHING)//Replace the old suit slot item with ego, if applicable
			if(suit_slot_item)
				qdel(suit_slot_item)
			var/obj/item/clothing/suit/armor/ego_gear/equippable_gear = new gear(get_turf(src))
			equippable_gear.equip_slowdown = 0
			egoist.equip_to_slot(equippable_gear,ITEM_SLOT_OCLOTHING, TRUE)
			equippable_gear.equip_slowdown = 3
		else
			egoist.put_in_hands(new gear(egoist))

	PostUnmanifest(egoist)
	PollGhosts(egoist)
	egoist.forceMove(get_turf(src))
	qdel(src)
	return

/mob/living/simple_animal/hostile/distortion/proc/PollGhosts(mob/living/carbon/human/egoist)
	if(!new_egoist || mind) //A player unmanifested somehow
		egoist.key = key
		mind.transfer_to(egoist)
		return
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [egoist.real_name]?", ROLE_PAI, null, FALSE, 100, egoist)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		egoist.key = C.key
		if(C.mind)
			C.mind.transfer_to(egoist)
			egoist.mind.assigned_role = "Civilian"
			return

/mob/living/simple_animal/hostile/distortion/proc/PostUnmanifest(mob/living/carbon/human/egoist)
	return

//Turn into a distortion
/mob/proc/BecomeDistortion(mob/living/simple_animal/hostile/distortion/chosenmob = null, instant = FALSE, forced = FALSE)
	var/mob/themob = null
	var/list/message_list = list(
		"Tell me. Why is it that you have given up?",
		"So, what will you do now?",
		"What do you think of yourself, [src.name]?",
		"That's the shape of your heart and desire, isn't it?",
	)
	if(!chosenmob)
		chosenmob = pick(subtypesof(/mob/living/simple_animal/hostile/distortion))
	src.playsound_local(src, 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 15, FALSE)
	if(!instant)
		playsound(src, 'sound/distortions/distortion_bell.ogg', 50, FALSE)
		for(var/i in 1 to 4)
			if(src.client)
				Distortionblurb(src.client, "[message_list[i]]")
			SLEEP_CHECK_DEATH(80)
			playsound(src, 'sound/distortions/distortion_bell.ogg', 50, FALSE)
			if(stat >= UNCONSCIOUS) //YOU GOT KNOCKED TF OUT! YOUR ASS IS GRASS
				return FALSE
	themob = new chosenmob(get_turf(src))
	if(client)
		themob.key = key
	if(!ishuman(src))
		qdel(src)
		return
	var/mob/living/carbon/human/egoist = src
	ADD_TRAIT(egoist, TRAIT_NOBREATH, MAGIC_TRAIT) //We don't want the player suffocating inside
	ADD_TRAIT(egoist, TRAIT_COMBATFEAR_IMMUNE, MAGIC_TRAIT) //We don't want the player suffocating inside
	if(egoist.sanity_lost) //If they panicked already we just top them off
		egoist.adjustWhiteLoss(99999, updating_health = TRUE, forced = TRUE, white_healable = TRUE)
	forceMove(themob)

/mob/proc/Distortionblurb(client/C, text)
	if(!C)
		return
	var/style = "font-family: 'Baskerville'; text-align: center; color: #DC143C; font-size:14pt;"
	var/obj/effect/overlay/T = new()
	T.alpha = 0
	T.maptext_height = 120
	T.maptext_width = 424
	T.layer = FLOAT_LAYER
	T.plane = HUD_PLANE
	T.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	T.screen_loc = "Center-6,Center+3"
	C.screen += T
	animate(T, alpha = 255, time = 10)
	var/display_text = text
	T.maptext = "<br><span style=\"[style]\">[display_text]</span><br>"
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_blurb), C, T, 25), 40) //fade_blurb qdels the object

/mob/living/simple_animal/hostile/distortion/BecomeDistortion(mob/living/simple_animal/hostile/distortion/chosenmob = null, instant = FALSE, forced = FALSE)
	if(!forced)
		return FALSE //Already a distortion
	return ..()

// Actions
/datum/action/innate/distortion_attack
	name = "distortion Attack"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = ""
	background_icon_state = "bg_abnormality"
	var/mob/living/simple_animal/hostile/distortion/A
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/distortion_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/distortion))
		A = L
		return ..()
	return FALSE

/datum/action/innate/distortion_attack/Activate()
	A.chosen_attack = chosen_attack_num
	to_chat(A, chosen_message)

/datum/action/innate/distortion_attack/toggle
	name = "Toggle Attack"
	var/toggle_message
	var/toggle_attack_num = 1
	var/button_icon_toggle_activated = ""
	var/button_icon_toggle_deactivated = ""

/datum/action/innate/distortion_attack/toggle/Activate()
	. = ..()
	button_icon_state = button_icon_toggle_activated
	UpdateButtonIcon()
	active = TRUE


/datum/action/innate/distortion_attack/toggle/Deactivate()
	A.chosen_attack = toggle_attack_num
	to_chat(A, toggle_message)
	button_icon_state = button_icon_toggle_deactivated
	UpdateButtonIcon()
	active = FALSE
