	//Pet Whistle
/obj/item/pet_whistle
	name = "Galtons whistle"
	desc = "A common dog whistle. When used in hand, any nearby creature that is tamed will follow you."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "dogwhistle"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	var/mode = 1

/obj/item/pet_whistle/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You blow the [src]."))
	playsound(get_turf(user), 'sound/effects/whistlereset.ogg', 10, 3, 3)
	for(var/mob/living/simple_animal/SA in oview(get_turf(user), 7))
		if(!SA.client && SA.stat != DEAD && !anchored)
			BlowWhistle(user, SA)

	if(mode != 1)
		mode = 1
	else if(mode == 1)
		mode = 0

/obj/item/pet_whistle/proc/BlowWhistle(mob/living/carbon/human/user, mob/living/simple_animal/SA)
	if(ishostile(SA))
		var/mob/living/simple_animal/hostile/bud = SA
		if(bud.tame) //isnt based on faction since this would result in the abnormality Yang and large shrimp gangs following the user.
			switch(mode)
				if(1)
					bud.Goto(user, bud.move_to_delay, 2)
				else
					bud.LoseTarget()
	else if(istype(SA, /mob/living/simple_animal/pet) && !SA.resting)
		switch(mode)
			if(1)
				walk_to(SA, user, 2, SA.turns_per_move)
			else
				walk_to(SA, 0)

	//abnos spawn slower, for maps that suck lol
/obj/item/lc13_abnospawn
	name = "Lobotomy Corporation Radio"
	desc = "A device that can call L Corp HQ and slow down the Abnormality arrival rate. Use in hand to activate."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-yellow"

/obj/item/lc13_abnospawn/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You feel that you now have more time."))
	SSabnormality_queue.next_abno_spawn_time *= 1.5
	qdel(src)

//Command projector
/obj/item/commandprojector
	name = "handheld command projector"
	desc = "A device that projects holographic images from a distance."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget3"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/commandtype = 1
	var/commanddelay = 1.5 SECONDS
	var/cooldown = 0
	//Used for limiting the amount of commands that can exist.
	var/current_commands = 0
	var/max_commands = 5
	//Command Types that can be deployed. Listed in order of commandtype.
	var/list/commandtypes = list(
		/obj/effect/temp_visual/holo_command/command_move,
		/obj/effect/temp_visual/holo_command/command_warn,
		/obj/effect/temp_visual/holo_command/command_guard,
		/obj/effect/temp_visual/holo_command/command_heal,
		/obj/effect/temp_visual/holo_command/command_fight_a,
		/obj/effect/temp_visual/holo_command/command_fight_b,
	)

/obj/item/commandprojector/attack_self(mob/user)
	..()
	switch(commandtype)
		if(0) //if 0 change to 1
			to_chat(user, span_robot("MOVE IMAGE INITIALIZED."))
			commandtype += 1
		if(1)
			to_chat(user, span_robot("WARN IMAGE INITIALIZED."))
			commandtype += 1
		if(2)
			to_chat(user, span_robot("GUARD IMAGE INITIALIZED."))
			commandtype += 1
		if(3)
			to_chat(user, span_robot("HEAL IMAGE INITIALIZED."))
			commandtype += 1
		if(4)
			to_chat(user, span_robot("LIGHT FIGHTING IMAGE INITIALIZED."))
			commandtype += 1
		if(5)
			to_chat(user, span_robot("HEAVY FIGHTING IMAGE INITIALIZED."))
			commandtype += 1
		else
			commandtype -= 5
			to_chat(user, span_robot("MOVE IMAGE INITIALIZED."))
	playsound(src, 'sound/machines/pda_button1.ogg', 20, TRUE)

/obj/item/commandprojector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(cooldown <= world.time)
		for(var/obj/effect/temp_visual/holo_command/V in get_turf(target))
			qdel(V)
			return
		if(current_commands >= max_commands)
			to_chat(user, span_warning("COMMAND CAPACITY REACHED."))
			return
		if(commandtype > 0 && commandtype <= 6)
			var/thing_to_spawn = commandtypes[commandtype]
			var/thing_spawned = new thing_to_spawn(get_turf(target))
			current_commands++
			RegisterSignal(thing_spawned, COMSIG_PARENT_QDELETING, PROC_REF(ReduceCommandAmount))
		else
			to_chat(user, span_warning("CALIBRATION ERROR."))
		cooldown = world.time + commanddelay
	playsound(src, 'sound/machines/pda_button1.ogg', 20, TRUE)

/obj/item/commandprojector/proc/ReduceCommandAmount()
	SIGNAL_HANDLER
	current_commands--

//Deepscanner
/obj/item/deepscanner //intended for ordeals
	name = "deep scan kit"
	desc = "A contraption of various tools capable of scanning the interior form of an entity.\n\
			Scanning nonhuman entities will make it 10% weaker to all damage types."
	icon = 'icons/obj/storage.dmi'
	icon_state = "maint_kit"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	color = "gold"
	var/check1a
	var/check1b
	var/check1c
	var/check1d
	var/check1e
	var/deep_scan_log

/obj/item/deepscanner/examine(mob/living/M)
	. = ..()
	if(deep_scan_log)
		to_chat(M, span_notice("Previous Scan:\n[deep_scan_log]"))

/obj/item/deepscanner/attack(mob/living/M, mob/user)
	return

/obj/item/deepscanner/afterattack(mob/living/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!istype(target))
		return
	Scan(target, user)

/obj/item/deepscanner/proc/Scan(mob/living/target, mob/user)
	if(!isanimal(target) && !ishuman(target))
		return
	user.visible_message(span_notice("[user] takes a tool out of [src] and begins scanning [target]."), span_notice("You begin scanning [target]."))
	playsound(get_turf(target), 'sound/misc/box_deploy.ogg', 5, 0, 3)
	if(!do_after(user, 2 SECONDS, target, IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE, TRUE, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(can_see), user, target, 7)))
		return
	check1e = FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/suit = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		check1a = H.physiology.red_mod
		check1b = H.physiology.white_mod
		check1c = H.physiology.black_mod
		check1d = H.physiology.pale_mod
		if(suit)
			check1a = 1 - (H.getarmor(null, RED_DAMAGE) / 100)
			check1b = 1 - (H.getarmor(null, WHITE_DAMAGE) / 100)
			check1c = 1 - (H.getarmor(null, BLACK_DAMAGE) / 100)
			check1d = 1 - (H.getarmor(null, PALE_DAMAGE) / 100)
		if(H.job)
			check1e = H.job
	else
		var/mob/living/simple_animal/mon = target
		if(!(mon.status_flags & GODMODE))
			if(!mon.HasDamageMod(/datum/dc_change/scanned))
				mon.AddModifier(/datum/dc_change/scanned)
				to_chat(user, span_nicegreen("[mon]'s weakness was analyzed!"))
		check1a = mon.damage_coeff.getCoeff(RED_DAMAGE)
		check1b = mon.damage_coeff.getCoeff(WHITE_DAMAGE)
		check1c = mon.damage_coeff.getCoeff(BLACK_DAMAGE)
		check1d = mon.damage_coeff.getCoeff(PALE_DAMAGE)
		if(isabnormalitymob(mon))
			var/mob/living/simple_animal/hostile/abnormality/abno = mon
			check1e = THREAT_TO_NAME[abno.threat_level]

	var/output = "--------------------\n[check1e ? check1e+" [target]" : "[target]"]\nHP [target.health]/[target.maxHealth]\nR [check1a] W [check1b] B [check1c] P [check1d]\n--------------------"
	to_chat(user, span_notice("[output]"))
	deep_scan_log = output
	playsound(get_turf(target), 'sound/misc/box_deploy.ogg', 5, 0, 3)


//General Invitation
/obj/item/invitation //intended for ordeals
	name = "General Invitation"
	desc = "A mysterious invitation to a certain Library. Using this on an Abnormality will cause them to transform into an incomplete Book upon death."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "invitation"

/obj/item/invitation/attack(mob/living/M, mob/user)
	if(isabnormalitymob(M) && !(M.status_flags & GODMODE) && !(M.has_status_effect(/datum/status_effect/invitation)))
		to_chat(user, span_nicegreen("You blow the [src]."))
		M.visible_message(span_notice("[user] sticks a general invitation on [M]!"))
		M.apply_status_effect(/datum/status_effect/invitation)
		playsound(get_turf(M), 'sound/abnormalities/book/scribble.ogg', 50, TRUE)
		qdel(src)
	else
		M.visible_message(span_warning("[M] refuses to sign the general invitation!"))

/datum/status_effect/invitation
	id = "general invitation"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/invitation/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(invite))

/datum/status_effect/invitation/proc/invite()
	SIGNAL_HANDLER
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	var/mob/living/O = owner
	O.turn_book()




//**RAK Regenerator Augmentation Kit.**
#define RAK_HP_MODE "HP mode"
#define RAK_SP_MODE "SP mode"
#define RAK_DUAL_MODE "Dual mode"
#define RAK_CRIT_MODE "Crit mode"
#define RAK_BURST_MODE "Burst mode"
/obj/item/safety_kit
	name = "\improper Safety Department Regenerator Augmentation Kit"
	desc = "This gadget is necessary for making temporary modifications on regenerators."
	icon = 'icons/obj/tools.dmi'
	icon_state = "HP mode_rak"
	inhand_icon_state = "sdrak"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/crowbar.ogg'
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("attacks", "bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("attack", "bash", "batter", "bludgeon", "whack")
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	var/mode = RAK_HP_MODE

/obj/item/safety_kit/attack_self(mob/user)
	if(!clerk_check(user))
		to_chat(user, span_warning("You don't know how to use this."))
		return
	ChangeMode(user)
	return

/obj/item/safety_kit/attack_obj(obj/O, mob/living/user)
	if(!istype(O, /obj/machinery/regenerator))
		return ..()
	Augment(O, user)

/obj/item/safety_kit/proc/Augment(obj/machinery/regenerator/R, mob/living/user)
	. = FALSE
	if(!clerk_check(user))
		to_chat(user, span_warning("You don't know how to use this."))
		return
	if(R.modified)
		to_chat(user, span_notice("[R] is already modified."))
		return
	to_chat(user, span_notice("You begin tinkering with the [R]."))
	if(!do_after(user, 2.5 SECONDS, R, extra_checks = CALLBACK(src, .proc/ModifiedCheck, R)))
		to_chat(user, span_warning("Your work has been interrupted!"))
		return
	R.modified = TRUE
	switch(mode)
		if(RAK_HP_MODE)
			R.HpFocus(user)
		if(RAK_SP_MODE)
			R.SpFocus(user)
		if(RAK_DUAL_MODE)
			R.EqualFocus(user)
		if(RAK_CRIT_MODE)
			R.CriticalFocus(user)
		if(RAK_BURST_MODE)
			R.OverloadHeal(user)
	return TRUE

/obj/item/safety_kit/proc/ModifiedCheck(obj/machinery/regenerator/R)
	return !R.modified

/obj/item/safety_kit/proc/ChangeMode(mob/user)
	var/list/choice_list = list()
	for(var/modes in list(RAK_HP_MODE, RAK_SP_MODE, RAK_DUAL_MODE, RAK_CRIT_MODE, RAK_BURST_MODE))
		choice_list[modes] = image(icon = icon, icon_state = modes+"_rak")

	var/choice = show_radial_menu(user, src, choice_list, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(user))
		return

	mode = choice
	icon_state = mode+"_rak"

	switch(mode)
		if(RAK_HP_MODE)
			to_chat(user, span_notice("You will now greatly improve the HP Regeneration of regenerators at the cost of the SP Regeneration."))
		if(RAK_SP_MODE)
			to_chat(user, span_notice("You will now greatly improve the SP Regeneration of regenerators at the cost of the HP Regeneration."))
		if(RAK_DUAL_MODE)
			to_chat(user, span_notice("You will now slightly improve the overall performance of regenerators."))
		if(RAK_CRIT_MODE)
			to_chat(user, span_notice("You will now enable regenerators to heal those in critical conditions at the cost of overall performance."))
		if(RAK_BURST_MODE)
			to_chat(user, span_notice("You will now cause regenerators to provide a large burst of HP and SP recovery."))
			to_chat(user, span_warning("This will cause regenerators to go on a cooldown period afterwards."))


/obj/item/safety_kit/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/safety_kit/examine(mob/user)
	. = ..()
	switch(mode)
		if(RAK_HP_MODE)
			. += span_info("Currently set to increase HP regen by sacrificing SP regen.")
		if(RAK_SP_MODE)
			. += span_info("Currently set to increase SP regen by sacrificing HP regen.")
		if(RAK_DUAL_MODE)
			. += span_info("Currently set to slightly increase both HP and SP regen.")
		if(RAK_CRIT_MODE)
			. += span_info("Currently set to enable healing insane and crit people but reducing overall healing.")
		if(RAK_BURST_MODE)
			. += span_info("Currently set to cause regenerators to create a burst of healing.")
			. += span_warning("This will disable regenerators for a short period afterwards.")

/obj/item/safety_kit/proc/clerk_check(mob/living/carbon/human/H)
	if(istype(H) && (H?.mind?.assigned_role == "Clerk"))
		return TRUE
	return FALSE

#undef RAK_HP_MODE
#undef RAK_SP_MODE
#undef RAK_DUAL_MODE
#undef RAK_CRIT_MODE
#undef RAK_BURST_MODE

//Tool E.G.O extractor
/obj/item/tool_extractor
	name = "Enkephalin Resonance Unit"
	desc = "A specialized tool that allows E.G.O extraction from tool Abnormalities."
	icon = 'icons/obj/storage.dmi'
	icon_state = "RPED"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	var/stored_enkephalin = 0
	var/maximum_enkephalin = 250
	var/drawn_amount = 50
	var/list/possible_drawn_amounts = list(5, 10, 15, 20, 25, 50)
	var/ego_selection
	var/ego_array

/obj/item/tool_extractor/examine(mob/user)
	. = ..()
	. += "Currently storing [stored_enkephalin]/[maximum_enkephalin] enkephalin."

/obj/item/tool_extractor/attack_self(mob/user)
	var/drawn_selected = input(user, "How quick should the transfer rate be?") as null|anything in possible_drawn_amounts
	if(!drawn_selected)
		return
	drawn_amount = drawn_selected
	to_chat(user, span_notice("[src]'s transfer rate is now [drawn_amount] enkephalin."))
	return


/obj/item/tool_extractor/attack_obj(obj/O, mob/living/carbon/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(O ,/obj/machinery/computer/extraction_cargo))//console stuff here
		if(stored_enkephalin + drawn_amount > maximum_enkephalin)
			var/drawn_total = (maximum_enkephalin - stored_enkephalin)//top off without going over the max
			if(drawn_total == 0)//if the stored enkephalin is already at max
				to_chat(usr, span_warning("[src] is at full capacity."))
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return
			stored_enkephalin += drawn_total
			SSlobotomy_corp.AdjustAvailableBoxes(-1 * drawn_total)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)//bit of duplicate code but it doesn't change the drawn_amount selection
			to_chat(usr, "Transferred [drawn_total] enkephalin into [src].")
			return
		if(SSlobotomy_corp.available_box < drawn_amount)
			to_chat(usr, span_warning("There is not enough enkephalin stored for this operation."))
			playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
			return
		stored_enkephalin += drawn_amount
		SSlobotomy_corp.AdjustAvailableBoxes(-1 * drawn_amount)
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		to_chat(usr, "Transferred [drawn_amount] enkephalin into [src].")
		return
	if(!istype(O, /obj/structure/toolabnormality))//E.G.O stuff below here
		return
	var/obj/structure/toolabnormality/P = O
	ego_selection = input(user, "Which E.G.O will you extract?") as null|anything in P.ego_list
	if(!ego_selection)
		return
	var/datum/ego_datum/D = ego_selection
	var/enkephalin_cost = initial(D.cost)
	var/loot = initial(D.item_path)
	switch(enkephalin_cost)//might see some scrutiny in testmerges. Original cost formula is multiplied by risk level
		if(45 to 99)
			enkephalin_cost *= 1.5
		if(100 to INFINITY)//unobtainable
			enkephalin_cost *= 2
	if(enkephalin_cost > stored_enkephalin)
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(usr, span_warning("There is not enough enkephalin in the device for this operation."))
		return
	new loot(get_turf(src))
	stored_enkephalin -= enkephalin_cost
	to_chat(usr, span_notice("E.G.O extracted successfully!"))
	return

//Lobotomizer
/obj/item/lobotomizer
	name = "Lobotomizer"
	desc = "An experimental tool designed to automatically excise damaged parts of one's brain. Due to its █████, the tool gained sentience and is only interested in brains with tumor."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "lobotomizer"
	var/lobotomizing = FALSE
	var/datum/looping_sound/lobotomizer/soundloop

/obj/item/lobotomizer/attack_self(mob/living/carbon/human/user)
	if(!(user.has_quirk(/datum/quirk/brainproblems)) || !(istype(user)) || lobotomizing)
		to_chat(user, span_warning("The lobotomizer completely ignores you."))
		return
	user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "lobotomizer", -HALO_LAYER))
	ADD_TRAIT(user, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	soundloop = new(list(src), FALSE)
	soundloop.start()
	lobotomizing = TRUE
	for(var/i = 1 to 20) //2 minutes to clear severe traumas
		if(user.is_working) // No, you can't just cheese this process
			to_chat(user, span_warning("The lobotomizer seems to be more interested in the abnormality."))
			EndLoop(user)
			return
		if(do_after(user, 6 SECONDS, src))
			user.visible_message(span_warning("The lobotomizer viciously probes [user]'s brain!"))
			user.adjustOrganLoss(ORGAN_SLOT_BRAIN, -10)
			user.adjustSanityLoss(5)
			user.adjustBruteLoss(5)
			user.emote("scream")
			user.Jitter(5)
		else
			to_chat(user, span_warning("The process was stopped midway, you can feel dissapointment emanating from the lobotomizer."))
			EndLoop(user)
			return
		if(i == 10) //Cures mild traumas in 1 minute
			user.cure_all_traumas(TRAUMA_RESILIENCE_BASIC)
	user.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
	EndLoop(user)

/obj/item/lobotomizer/proc/EndLoop(mob/living/user)
	user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "lobotomizer", -HALO_LAYER))
	REMOVE_TRAIT(user, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	lobotomizing = FALSE
	QDEL_NULL(soundloop)

/datum/looping_sound/lobotomizer
	mid_sounds = list(
		'sound/effects/wounds/blood3.ogg',
		'sound/weapons/circsawhit.ogg',
		'sound/weapons/bladeslice.ogg',
		'sound/weapons/bite.ogg',
	)
	mid_length = 2 SECONDS
	volume = 20

//Clerkbot Spawner
/obj/item/clerkbot_gadget
	name = "Instant Clerkbot Constructor"
	desc = "An instant constructor for Clerkbots. Loyal little things that attack hostile creatures. In order to prevent \
		unauthorized access, only those registered as a Lobotomy Corp clerk can activate them. Clerkbot \
		will last for 2 minutes before it automatically shuts down."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "clerkbot2_deactivated"

/obj/item/clerkbot_gadget/attack_self(mob/user)
	..()
	if(!istype(user) || !(user?.mind?.assigned_role in GLOB.service_positions))
		to_chat(user, span_notice("The Gadget's light flashes red. You aren't a clerk. Check the label before use."))
		return
	new /mob/living/simple_animal/hostile/clerkbot(get_turf(user))
	to_chat(user, span_nicegreen("The Gadget turns warm and sparks."))
	qdel(src)

	//Clerkbot spawned by the Clerkbot Spawner
/mob/living/simple_animal/hostile/clerkbot
	name = "A Well Rounded Clerkbot"
	desc = "Trusted and loyal best friend."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "clerkbot2"
	icon_living = "clerkbot2"
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	faction = list("neutral")
	health = 150
	maxHealth = 150
	healable = FALSE
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 0.9, BLACK_DAMAGE = 0.9, PALE_DAMAGE = 1.5)
	melee_damage_lower = 12
	melee_damage_upper = 14
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "buzzes"
	attack_verb_simple = "buzz"
	attack_sound = 'sound/weapons/etherealhit.ogg'
	verb_say = "states"
	verb_ask = "queries"
	verb_exclaim = "declares"
	verb_yell = "alarms"
	bubble_icon = "machine"
	speech_span = SPAN_ROBOT

/mob/living/simple_animal/hostile/clerkbot/Initialize()
	..()
	QDEL_IN(src, (120 SECONDS))
	if(prob(50))
		icon_state = "clerkbot1"
		icon_living = "clerkbot1"

/mob/living/simple_animal/hostile/clerkbot/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>WARNING:THIS CREATURE IS TEMPORARY AND WILL DELETE ITSELF AFTER A GIVEN TIME!</b>")

/mob/living/simple_animal/hostile/clerkbot/Destroy()
	new /obj/item/clerkbot_gadget(get_turf(src))
	return ..()

/mob/living/simple_animal/hostile/clerkbot/spawn_gibs()
	new /obj/effect/gibspawner/robot(drop_location(), src)


/// Info Page Printer (Does not print info sheets)

/obj/item/info_printer
	name = "Abnormality Information Display System"
	desc = "" // Done later
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "aids"
	var/use_time = 150 // For future mods, maybe? :shrug:

/obj/item/info_printer/examine(mob/user)
	. = ..()
	. += "Use on an Abnormality to display its information on screen after [use_time/10] seconds."

/obj/item/info_printer/pre_attack(atom/A, mob/living/user, params)
	if(Scan(A, user))
		return TRUE
	return ..()

/obj/item/info_printer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(Scan(target, user))
		return TRUE
	return ..()

/obj/item/info_printer/proc/Scan(atom/A, mob/living/user)
	if(!isabnormalitymob(A))
		return FALSE
	if(do_after(user, max(use_time-1, 0), A, IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE, TRUE, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(can_see), user, A, 7)))
		var/list/information = GenerateInfo(A)
		if(information)
			var/datum/browser/popup = new(user, "information", FALSE, 300, 350)
			popup.set_content(information)
			popup.open(FALSE)
	return TRUE

/obj/item/info_printer/proc/GenerateInfo(mob/living/simple_animal/hostile/abnormality/abno_mob)
	for(var/path in subtypesof(/obj/item/paper/fluff/info))
		var/obj/item/paper/fluff/info/info_paper = path
		if(abno_mob.type == initial(info_paper.abno_type))
			info_paper = new path(src)
			stoplag(1)
			. = info_paper.info
			QDEL_NULL(info_paper)
			return
	return FALSE

