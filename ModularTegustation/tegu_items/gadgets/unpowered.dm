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
	to_chat(user, "<span class='nicegreen'>You blow the [src].</span>")
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
	desc = "A device to call HQ and slow down abnormality arrival rate. Use in hand to activate."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-yellow"

/obj/item/lc13_abnospawn/attack_self(mob/living/carbon/human/user)
	to_chat(user, "<span class='nicegreen'>You feel that you now have more time.</span>")
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
	var/static/list/commandtypes = typecacheof(list(
		/obj/effect/temp_visual/commandMove,
		/obj/effect/temp_visual/commandWarn,
		/obj/effect/temp_visual/commandGaurd,
		/obj/effect/temp_visual/commandHeal,
		/obj/effect/temp_visual/commandFightA,
		/obj/effect/temp_visual/commandFightB
		))

/obj/item/commandprojector/attack_self(mob/user)
	..()
	switch(commandtype)
		if(0) //if 0 change to 1
			to_chat(user, "<span class='notice'>MOVE IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(1)
			to_chat(user, "<span class='notice'>WARN IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(2)
			to_chat(user, "<span class='notice'>GUARD IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(3)
			to_chat(user, "<span class='notice'>HEAL IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(4)
			to_chat(user, "<span class='notice'>FIGHT_LIGHT IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(5)
			to_chat(user, "<span class='notice'>FIGHT_HEAVY IMAGE INITIALIZED.</span>")
			commandtype += 1
		else
			commandtype -= 5
			to_chat(user, "<span class='notice'>MOVE IMAGE INITIALIZED.</span>")
	playsound(src, 'sound/machines/pda_button1.ogg', 20, TRUE)

/obj/item/commandprojector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(cooldown <= world.time)
		for(var/obj/effect/temp_visual/V in range(get_turf(target), 0))
			if(is_type_in_typecache(V, commandtypes))
				qdel(V)
				return
		switch(commandtype)
			if(1)
				new /obj/effect/temp_visual/commandMove(get_turf(target))
			if(2)
				new /obj/effect/temp_visual/commandWarn(get_turf(target))
			if(3)
				new /obj/effect/temp_visual/commandGaurd(get_turf(target))
			if(4)
				new /obj/effect/temp_visual/commandHeal(get_turf(target))
			if(5)
				new /obj/effect/temp_visual/commandFightA(get_turf(target))
			if(6)
				new /obj/effect/temp_visual/commandFightB(get_turf(target))
			else
				to_chat(user, "<span class='warning'>CALIBRATION ERROR.</span>")
		cooldown = world.time + commanddelay
	playsound(src, 'sound/machines/pda_button1.ogg', 20, TRUE)




//Deepscanner
/obj/item/deepscanner //intended for ordeals
	name = "deep scan kit"
	desc = "A collection of tools used for scanning the physical form of an entity."
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
		to_chat(M, "<span class='notice'>Previous Scan:[deep_scan_log]</span>")

/obj/item/deepscanner/attack(mob/living/M, mob/user)
	user.visible_message("<span class='notice'>[user] takes a tool out of [src] and begins scanning [M].</span>", "<span class='notice'>You set down the deep scanner and begin scanning [M].</span>")
	playsound(get_turf(M), 'sound/misc/box_deploy.ogg', 5, 0, 3)
	if(!do_after(user, 2 SECONDS, target = user))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/suit = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		check1a = H.physiology.red_mod
		check1b = H.physiology.white_mod
		check1c = H.physiology.black_mod
		check1d = H.physiology.pale_mod
		check1e = "Unknown"
		if(suit)
			check1a = 1 - (H.getarmor(null, RED_DAMAGE) / 100)
			check1b = 1 - (H.getarmor(null, WHITE_DAMAGE) / 100)
			check1c = 1 - (H.getarmor(null, BLACK_DAMAGE) / 100)
			check1d = 1 - (H.getarmor(null, PALE_DAMAGE) / 100)
		if(H.job)
			check1e = H.job
	else
		var/mob/living/simple_animal/hostile/mon = M
		if((mon.status_flags & GODMODE))
			return
		check1a = mon.damage_coeff.getCoeff(RED_DAMAGE)
		check1b = mon.damage_coeff.getCoeff(WHITE_DAMAGE)
		check1c = mon.damage_coeff.getCoeff(BLACK_DAMAGE)
		check1d = mon.damage_coeff.getCoeff(PALE_DAMAGE)
		if(isabnormalitymob(mon))
			var/mob/living/simple_animal/hostile/abnormality/abno = mon
			check1e = THREAT_TO_NAME[abno.threat_level]
		else
			check1e = FALSE
	var/output = "----------\n[check1e ? check1e+" " : ""][M]\nHP [M.health]/[M.maxHealth]\nR [check1a] W [check1b] B [check1c] P [check1d]\n----------"
	to_chat(user, "<span class='notice'>[output]</span>")
	deep_scan_log = output
	playsound(get_turf(M), 'sound/misc/box_deploy.ogg', 5, 0, 3)


//Kcorp Syringes
/obj/item/ksyringe
	name = "k-corp nanomachine ampule"
	desc = "A syringe of kcorp healing nanobots."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "kcorp_syringe"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ksyringe/attack_self(mob/living/user)
	..()
	to_chat(user, "<span class='notice'>You inject the syringe and instantly feel better.</span>")
	user.adjustBruteLoss(-40)
	qdel(src)

/obj/item/krevive
	name = "k-corp nanomachine ampule"
	desc = "A syringe of kcorp healing nanobots."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "kcorp_syringe"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/krevive/attack(mob/living/M, mob/user)
	to_chat(user, "<span class='notice'>You inject the syringe.</span>")
	if(M.revive(full_heal = TRUE, admin_revive = TRUE))
		M.revive(full_heal = TRUE, admin_revive = TRUE)
		M.grab_ghost(force = TRUE) // even suicides
		to_chat(M, "<span class='notice'>You rise with a start, you're alive!!!</span>")
	qdel(src)


//General Invitation
/obj/item/invitation //intended for ordeals
	name = "General Invitation"
	desc = "A mysterious invitation to a certain library. Using this on an abnormality seems to teleport them away when they die, leaving an incomplete book on the spot."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "invitation"

/obj/item/invitation/attack(mob/living/M, mob/user)
	if(isabnormalitymob(M) && !(M.status_flags & GODMODE) && !(M.has_status_effect(/datum/status_effect/invitation)))
		to_chat(user, "<span class='nicegreen'>You blow the [src].</span>")
		M.visible_message("<span class='notice'>[user] sticks a general invitation on [M]!</span>")
		M.apply_status_effect(/datum/status_effect/invitation)
		playsound(get_turf(M), 'sound/abnormalities/book/scribble.ogg', 50, TRUE)
		qdel(src)
	else
		M.visible_message("<span class='warning'>[M] refuses to sign the general invitation!</span>")

/datum/status_effect/invitation
	id = "general invitation"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/invitation/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, .proc/invite)

/datum/status_effect/invitation/proc/invite()
	SIGNAL_HANDLER
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	var/mob/living/O = owner
	O.turn_book()




//**RAK Regenerator Augmentation Kit.**
/obj/item/safety_kit
	name = "Safety Department Regenerator Augmentation Kit"
	desc = "R.A.K. for short, it's utilized to enhance and modify regenerators for short periods of time."
	icon = 'icons/obj/tools.dmi'
	icon_state = "sdrak"
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
	var/mode = 1

/obj/item/safety_kit/attack_self(mob/user)
	if(!clerk_check(user))
		to_chat(user,"<span class='warning'>You don't know how to use this.</span>")
		return
	switch(mode)
		if(1)
			mode = 2
			to_chat(user, "<span class='notice'>You will now improve the SP Regeneration of the Regenerator at the cost of the HP Regeneration.</span>")
		if(2)
			mode = 3
			to_chat(user, "<span class='notice'>You will now slightly improve the overall performance of the Regenerator.</span>")
		if(3)
			mode = 4
			to_chat(user, "<span class='notice'>You will now enable the Regenerator to heal those in critical conditions at the cost of overall performance.</span>")
		if(4)
			mode = 5
			to_chat(user, "<span class='notice'>You will now cause the Regenerator to heal a large burst of HP and SP.</span>")
			to_chat(user, "<span class='warning'>This will cause the Regenerator to go on a cooldown period afterwards.</span>")
		if(5)
			mode = 1
			to_chat(user, "<span class='notice'>You will now improve the HP Regeneration of the Regenerator at the cost of the SP Regeneration.</span>")
	return

/obj/item/safety_kit/examine(mob/user)
	. = ..()
	switch(mode)
		if(1)
			. += "Currently set to sacrifice SP Regeneration for HP Regeneration."
		if(2)
			. += "Currently set to sacrifice HP Regeneration for SP Regeneration."
		if(3)
			. += "Currently set to improve overall Regenerator functions."
		if(4)
			. += "Currently set to allow healing of those in Critical Condition."
		if(5)
			. += "Currently set to cause the Regenerator to burst recovery."
			. += "<span class='warning'>This will cause the Regenerator to go on a cooldown period afterwards.</span>"

/obj/item/safety_kit/proc/clerk_check(mob/living/carbon/human/H)
	if(istype(H) && (H?.mind?.assigned_role == "Clerk"))
		return TRUE
	return FALSE




//Tool E.G.O extractor
/obj/item/tool_extractor
	name = "Enkephalin Resonance Unit"
	desc = "A specialized set of tools that allows E.G.O extraction from tool abnormalities."
	icon = 'icons/obj/storage.dmi'
	icon_state = "RPED"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	var/stored_enkephalin = 0
	var/maximum_enkephalin = 250
	var/drawn_amount = 50
	var/list/possible_drawn_amounts = list(5,10,15,20,25,50)
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
	to_chat(user, "<span class='notice'>[src]'s transfer rate is now [drawn_amount] enkephalin.</span>")
	return


/obj/item/tool_extractor/attack_obj(obj/O, mob/living/carbon/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(O ,/obj/machinery/computer/extraction_cargo))//console stuff here
		if(stored_enkephalin + drawn_amount > maximum_enkephalin)
			var/drawn_total = (maximum_enkephalin - stored_enkephalin)//top off without going over the max
			if(drawn_total == 0)//if the stored enkephalin is already at max
				to_chat(usr, "<span class='warning'>[src] is at full capacity.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return
			stored_enkephalin += drawn_total
			SSlobotomy_corp.AdjustAvailableBoxes(-1 * drawn_total)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)//bit of duplicate code but it doesn't change the drawn_amount selection
			to_chat(usr, "Transferred [drawn_total] enkephalin into [src].")
			return
		if(SSlobotomy_corp.available_box < drawn_amount)
			to_chat(usr, "<span class='warning'>There is not enough enkephalin stored for this operation.</span>")
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
		to_chat(usr, "<span class='warning'>There is not enough enkephalin in the device for this operation.</span>")
		return
	new loot(get_turf(src))
	stored_enkephalin -= enkephalin_cost
	to_chat(usr, "<span class='notice'>E.G.O extracted successfully!</span>")
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
		to_chat(user, "<span class='warning'>The lobotomizer completely ignores you.</span>")
		return
	user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "lobotomizer", -HALO_LAYER))
	ADD_TRAIT(user, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	soundloop = new(list(src), FALSE)
	soundloop.start()
	lobotomizing = TRUE
	for(var/i = 1 to 20) //2 minutes to clear severe traumas
		if(user.is_working) // No, you can't just cheese this process
			to_chat(user, "<span class='warning'>The lobotomizer seems to be more interested in the abnormality.</span>")
			EndLoop(user)
			return
		if(do_after(user, 6 SECONDS, src))
			user.visible_message("<span class='warning'>The lobotomizer viciously probes [user]'s brain!</span>")
			user.adjustOrganLoss(ORGAN_SLOT_BRAIN, -10)
			user.adjustSanityLoss(5)
			user.adjustBruteLoss(5)
			user.emote("scream")
			user.Jitter(5)
		else
			to_chat(user, "<span class='warning'>The process was stopped midway, you can feel dissapointment emanating from the lobotomizer.</span>")
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
		'sound/weapons/bite.ogg'
	)
	mid_length = 2 SECONDS
	volume = 20
