	//Plushie Gatcha
/obj/item/plushgacha //would of made players also have to find keys to open these but im not that cruel... as of today. - IP
	name = "extraction plush lootbox"
	desc = "Theres a thank you note attached from J corp for your patronage."
	icon = 'icons/obj/storage.dmi'
	icon_state = "brassbox"
	var/rewards = list(
		/obj/item/toy/plush/beeplushie = 25, //higher values are more common
		/obj/item/toy/plush/blank = 20,
		/obj/item/toy/plush/yisang = 10,
		/obj/item/toy/plush/faust = 10,
		/obj/item/toy/plush/don = 10,
		/obj/item/toy/plush/ryoshu = 10,
		/obj/item/toy/plush/meursault = 10,
		/obj/item/toy/plush/honglu = 10,
		/obj/item/toy/plush/heathcliff = 10,
		/obj/item/toy/plush/ishmael = 10,
		/obj/item/toy/plush/rodion = 10,
		/obj/item/toy/plush/sinclair = 10,
		/obj/item/toy/plush/outis = 10,
		/obj/item/toy/plush/gregor = 10,
		/obj/item/toy/plush/dante = 5,
		/obj/item/toy/plush/yuri = 1)

/obj/item/plushgacha/attack_self(mob/user)
	var/obj/item/toy/plush/reward = pickweight(rewards)
	to_chat(user, "<span class='notice'>You got a prize!</span>")
	new reward(get_turf(src))
	qdel(src)

	//Admin Quick Leveler
/obj/item/attribute_tester
	name = "attribute injector"
	desc = "A fluid used to drastically change an employee for tests. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity7"

/obj/item/attribute_tester/attack_self(mob/living/carbon/human/user)
	to_chat(user, "<span class='nicegreen'>You suddenly feel different.</span>")
	user.adjust_all_attribute_levels(100)
	qdel(src)

/obj/item/easygift_tester
	name = "gift extractor"
	desc = "Unpopular due to its excessive energy use, this device extracts gifts from an entity on demand."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "hammeroff"

/obj/item/easygift_tester/attack(mob/living/simple_animal/hostile/abnormality/M, mob/living/carbon/human/user)
	if(!isabnormalitymob(M))
		to_chat(user, "<span class='warning'>Error: Entity doesnt classify as an L Corp Abnormality.</span>")
		playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
		return
	if(!M.gift_type)
		to_chat(user, "<span class='notice'>[src] has no gift type.</span>")
		playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
		return
	var/datum/ego_gifts/EG = new M.gift_type
	EG.datum_reference = M.datum_reference
	user.Apply_Gift(EG)
	to_chat(user, "<span class='nicegreen'>[M.gift_message]</span>")
	playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
	to_chat(user, "<span class='nicegreen'>You bonk the abnormality with the [src].</span>")
	qdel(src)

	//abnos spawn slower
/obj/item/lc13_abnospawn
	name = "Lobotomy Corporation Radio"
	desc = "A device to call HQ and slow down abnormality arrival rate. Use in hand to activate."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-yellow"

/obj/item/lc13_abnospawn/attack_self(mob/living/carbon/human/user)
	to_chat(user, "<span class='nicegreen'>You feel that you now have more time.</span>")
	SSabnormality_queue.next_abno_spawn_time *= 1.5
	qdel(src)


	//Defective Manager Bullet PLACEHOLDER OR PROTOTYPE SHIELDS
/obj/item/managerbullet
	name = "prototype manager bullet"
	desc = "Welfare put out a notice that they lost a bunch of manager bullets. This must be one of them."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	var/bullettype = 1

/obj/item/managerbullet/attack(mob/living/M, mob/user)
	M.visible_message("<span class='notice'>[user] smashes [src] against [M].</span>")
	playsound(get_turf(M), 'sound/effects/pop_expl.ogg', 5, 0, 3)
	bulletshatter(M)
	qdel(src)

/obj/item/managerbullet/attack_self(mob/living/carbon/user) //shields from basegame are Physical Intervention Shield, Trauma Shield, Erosion Shield, Pale Shield
	user.visible_message("<span class='notice'>[user] smashes [src] against their chest.</span>")
	playsound(get_turf(user), 'sound/effects/pop_expl.ogg', 5, 0, 3)
	bulletshatter(user)
	qdel(src)

/obj/item/managerbullet/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		playsound(get_turf(M), 'sound/effects/pop_expl.ogg', 5, 0, 3)
		bulletshatter(M)
		qdel(src)
	..()

/obj/item/managerbullet/proc/bulletshatter(mob/living/L) //apply effect slot
	return


/datum/status_effect/interventionshield
	id = "physical intervention shield"
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/inherentarmorcheck
	var/statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "red_shield")
	var/shieldhealth = 100
	var/damagetaken = 0
	var/respectivedamage = RED_DAMAGE
	var/faltering = 0

/datum/status_effect/interventionshield/on_apply()
	. = ..()
	owner.add_overlay(statuseffectvisual)
	var/mob/living/carbon/human/L = owner
	switch(respectivedamage)
		if(RED_DAMAGE)
			inherentarmorcheck = L.physiology.red_mod
			L.physiology.red_mod *= 0.0001
		if(WHITE_DAMAGE)
			inherentarmorcheck = L.physiology.white_mod
			L.physiology.white_mod *= 0.0001
		if(BLACK_DAMAGE)
			inherentarmorcheck = L.physiology.black_mod
			L.physiology.black_mod *= 0.0001
		if(PALE_DAMAGE)
			inherentarmorcheck = L.physiology.pale_mod
			L.physiology.pale_mod *= 0.0001
	owner.visible_message("<span class='notice'>[owner]s shield activates!</span>")
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, .proc/OnApplyDamage) //stolen from caluan
	RegisterSignal(owner, COMSIG_WORK_STARTED, .proc/Destroy)

/datum/status_effect/interventionshield/proc/OnApplyDamage(datum_source, amount, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damagetype != respectivedamage)
		return
	var/mob/living/carbon/human/H = owner
	var/suitarmor = H.getarmor(null, respectivedamage) / 100
	var/suit = owner.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	damagetaken = amount * (1 - suitarmor)
	if(damagetaken <= 0)
		return
	if(!suit)
		damagetaken = amount
	if(damagetaken <= shieldhealth)
		shieldhealth = shieldhealth - damagetaken
		amount = 0
		var/shielddiagnostics = shieldhealth / 100
		if(shielddiagnostics < 0.95 && faltering != 1)
			faltering = 1
		return
	if(damagetaken >= shieldhealth && faltering != 1) //When you prep a shield before a big attack.
		amount = 0
		owner.visible_message("<span class='warning'>The shield around [owner] focuses all its energy on absorbing the damage.</span>")
		duration = 1 SECONDS
	else
		qdel(src)
	return

/datum/status_effect/interventionshield/be_replaced()
	var/mob/living/carbon/human/L = owner
	switch(respectivedamage)
		if(RED_DAMAGE)
			L.physiology.red_mod /= 0.0001
		if(WHITE_DAMAGE)
			L.physiology.white_mod /= 0.0001
		if(BLACK_DAMAGE)
			L.physiology.black_mod /= 0.0001
		if(PALE_DAMAGE)
			L.physiology.pale_mod /= 0.0001
	playsound(get_turf(owner), 'sound/effects/glassbr1.ogg', 50, 0, 10)
	..()

/datum/status_effect/interventionshield/on_remove()
	var/mob/living/carbon/human/L = owner
	switch(respectivedamage)
		if(RED_DAMAGE)
			L.physiology.red_mod /= 0.0001
		if(WHITE_DAMAGE)
			L.physiology.white_mod /= 0.0001
		if(BLACK_DAMAGE)
			L.physiology.black_mod /= 0.0001
		if(PALE_DAMAGE)
			L.physiology.pale_mod /= 0.0001
	owner.cut_overlay(statuseffectvisual)
	owner.visible_message("<span class='warning'>The shield around [owner] shatters!</span>")
	playsound(get_turf(owner), 'sound/effects/glassbr1.ogg', 50, 0, 10)
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	return ..()

/datum/status_effect/interventionshield/white
	id = "trauma shield"
	statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "white_shield")
	respectivedamage = WHITE_DAMAGE

/datum/status_effect/interventionshield/black
	id = "erosion shield"
	statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "black_shield")
	respectivedamage = BLACK_DAMAGE

/datum/status_effect/interventionshield/pale
	id = "pale shield"
	statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "pale_shield")
	respectivedamage = PALE_DAMAGE

	//other bullets
/obj/item/managerbullet/red
	name = "red manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "red"

/obj/item/managerbullet/red/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield)

/obj/item/managerbullet/white
	name = "white manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "grey"

/obj/item/managerbullet/white/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield/white)

/obj/item/managerbullet/black
	name = "black manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "black"

/obj/item/managerbullet/black/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield/black)

/obj/item/managerbullet/pale
	name = "pale manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "blue"

/obj/item/managerbullet/pale/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield/pale)

/obj/item/managerbullet/slowdown
	name = "yellow manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "yellow"

/obj/item/managerbullet/slowdown/bulletshatter(mob/living/L)
	L.apply_status_effect(/datum/status_effect/qliphothoverload)

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
			to_chat(user, "<span class='notice'>GAURD IMAGE INITIALIZED.</span>")
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
		to_chat(M, "<span class='notice'>Previous Scan:[deep_scan_log].</span>")

/obj/item/deepscanner/attack(mob/living/M, mob/user)
	user.visible_message("<span class='notice'>[user] takes a tool out of [src] and begins scanning [M].</span>", "<span class='notice'>You set down the deep scanner and begin scanning [M].</span>")
	playsound(get_turf(M), 'sound/misc/box_deploy.ogg', 5, 0, 3)
	if(!do_after(user, 2 SECONDS, target = user))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/suit = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		check1a = measuredamage(H.physiology.red_mod)
		check1b = measuredamage(H.physiology.white_mod)
		check1c = measuredamage(H.physiology.black_mod)
		check1d = measuredamage(H.physiology.pale_mod)
		check1e = "Unknown"
		if(suit)
			check1a = measuredamage(1 - (H.getarmor(null, RED_DAMAGE) / 100))
			check1b = measuredamage(1 - (H.getarmor(null, WHITE_DAMAGE) / 100))
			check1c = measuredamage(1 - (H.getarmor(null, BLACK_DAMAGE) / 100))
			check1d = measuredamage(1 - (H.getarmor(null, PALE_DAMAGE) / 100))
		if(H.job)
			check1e = H.job
		to_chat(user, "<span class='notice'>[check1e] [H] [H.maxHealth] [check1a] [check1b] [check1c] [check1d].</span>")
	else
		var/mob/living/simple_animal/hostile/mon = M
		if((mon.status_flags & GODMODE))
			return
		check1a = measuredamage(mon.damage_coeff[RED_DAMAGE])
		check1b = measuredamage(mon.damage_coeff[WHITE_DAMAGE])
		check1c = measuredamage(mon.damage_coeff[BLACK_DAMAGE])
		check1d = measuredamage(mon.damage_coeff[PALE_DAMAGE])
		to_chat(user, "<span class='notice'>[mon] [mon.maxHealth] [check1a] [check1b] [check1c] [check1d].</span>")
		deep_scan_log = "[mon] [mon.maxHealth] [check1a] [check1b] [check1c] [check1d]"
	playsound(get_turf(M), 'sound/misc/box_deploy.ogg', 5, 0, 3)

/obj/item/deepscanner/proc/measuredamage(amount)
	switch(amount)
		if(0)
			return "IMMUNE"
		if(0.1 to 0.4)
			return "INEFFECTIVE"
		if(0.5 to 0.9)
			return "ENDURED"
		if(1)
			return "NORMAL"
		if(1.1 to 1.5)
			return "WEAK"
		if(1.6 to 2)
			return "FATAL"
		else
			return "ERROR"

//Gadgets that require batteries or fuel to function!
/obj/item/powered_gadget
	name = "gadget template"
	desc = "A template for a battery powered tool, the battery compartment is screwed shut in order to prevent people from eating the batteries."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget1"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	var/default_icon = "gadget1" //roundabout way of making update item easily changed. Used in updateicon proc.
	var/opened = FALSE
	var/cell_type = /obj/item/stock_parts/cell/high //maxcharge = 10000
	var/obj/item/stock_parts/cell/cell
	var/batterycost = 2000 //5 uses before requires recharge
	var/turned_on = 0

/obj/item/powered_gadget/Initialize()
	. = ..()
	if(!cell && cell_type)
		cell = new cell_type

/obj/item/powered_gadget/get_cell()
	return cell

/obj/item/powered_gadget/attack_obj(obj/O, mob/living/carbon/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(cantbeused(user))
		return

	return ..()

/obj/item/powered_gadget/proc/toggle_on(mob/user)
	if(cell && cell.charge >= batterycost)
		turned_on = !turned_on
		to_chat(user, "<span class='notice'>[src] is now [turned_on ? "on" : "off"].</span>")
	else
		turned_on = FALSE
		if(!cell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	update_icon()
	add_fingerprint(user)

/obj/item/powered_gadget/proc/cantbeused(mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, "<span class='warning'>You don't have the dexterity to use [src]!</span>")
		return TRUE

	if(!cell)
		to_chat(user, "<span class='warning'>[src] doesn't have a power cell installed!</span>")
		return TRUE

	if(!cell.charge)
		to_chat(user, "<span class='warning'>[src]'s battery is dead!</span>")
		return TRUE
	return FALSE


/obj/item/powered_gadget/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		W.play_tool_sound(src)
		if(!opened)
			to_chat(user, "<span class='notice'>You unscrew the battery compartment.</span>")
			opened = TRUE
			update_icon()
			return
		else
			to_chat(user, "<span class='notice'>You close the battery compartment.</span>")
			opened = FALSE
			update_icon()
			return
	if(istype(W, /obj/item/stock_parts/cell))
		if(opened)
			if(!cell)
				if(!user.transferItemToLoc(W, src))
					return
				to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
				cell = W
				update_icon()
				return
			else
				to_chat(user, "<span class='warning'>[src] already has a [cell] installed!</span>")
				return

	if(cantbeused(user))
		return

	return ..()

/obj/item/powered_gadget/attack_self(mob/user)
	if(opened && cell)
		user.visible_message("<span class='notice'>[user] removes [cell] from [src]!</span>", "<span class='notice'>You remove [cell].</span>")
		cell.update_icon()
		user.put_in_hands(cell)
		cell = null
	playsound(src, 'sound/machines/pda_button1.ogg', 20, TRUE)


/obj/item/powered_gadget/examine(mob/living/M)
	. = ..()
	if(cell)
		. += "<span class='notice'>Its display shows: [DisplayEnergy(cell.charge)].</span>"
	else
		. += "<span class='notice'>Its display is dark.</span>"
	if(opened)
		. += "<span class='notice'>Its battery compartment is open.</span>"

/obj/item/powered_gadget/update_overlays()
	. = ..()
	if(opened)
		if(!cell)
			. += "[default_icon]-nobat"
		else
			. += "[default_icon]"

	//Trapspawner
/obj/item/powered_gadget/slowingtrapmk1
	name = "Qliphoth Field Projector"
	desc = "This device places traps that reduces the mobility of Abnormalities for a limited time. The Movement Speed of an Abnormality will be reduced via overloading the Qliphoth control"
	var/placed_structure = /obj/structure/trap/slowingmk1

/obj/item/powered_gadget/slowingtrapmk1/attack_self(mob/user)
	..()
	if(cell && cell.charge >= batterycost)
		for(var/obj/structure/trap/slowingmk1/T in range(0, get_turf(user)))
			if(T)
				return
		cell.charge = cell.charge - batterycost
		return new placed_structure(get_turf(src))

/obj/structure/trap/slowingmk1
	name = "qliphoth overloader mk1"//very placeholder name
	desc = "A device that delivers a burst of energy designed to overload the Qliphoth Control of abnormalities."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity2"
	time_between_triggers = 100
	charges = 1

/obj/structure/trap/slowingmk1/Initialize()
	..()
	playsound(src, 'sound/machines/terminal_processing.ogg', 20, TRUE)

/obj/structure/trap/slowingmk1/Crossed(atom/movable/AM)
	if(last_trigger + time_between_triggers > world.time)
		return
	// Don't want the traps triggered by sparks, ghosts or projectiles.
	if(is_type_in_typecache(AM, ignore_typecache))
		return
	if(charges <= 0)
		return
	if(isliving(AM))
		if(!istype(AM, /mob/living/simple_animal/hostile/abnormality))
			return
		if(istype(AM, /mob/living/simple_animal/hostile/abnormality))
			trap_effect(AM)
			return
	. = ..()


/obj/structure/trap/slowingmk1/trap_effect(mob/living/L)
	L.apply_status_effect(/datum/status_effect/qliphothoverload)
	flare()

/obj/structure/trap/slowingmk1/flare()
	// Makes the trap visible, and starts the cooldown until it's
	// able to be triggered again.
	alpha = 200
	last_trigger = world.time
	charges--
	if(charges <= 0)
		animate(src, alpha = 0, time = 10)
		QDEL_IN(src, 10)
	else
		animate(src, alpha = initial(alpha), time = time_between_triggers)

/mob/living/simple_animal/proc/adjustStaminaRecovery(amount, updating_health = TRUE, forced = FALSE) //abnormalities automatically restore their stamina by 10 due to the variable in simple_animal
	stamina_recovery = (initial(stamina_recovery) + (amount))
	return

/datum/status_effect/qliphothoverload
	id = "qliphoth intervention field"
	duration = 10 SECONDS
	alert_type = null
	status_type = STATUS_EFFECT_REFRESH
	var/statuseffectvisual

/datum/status_effect/qliphothoverload/on_apply()
	. = ..()
	var/mob/living/simple_animal/hostile/L = owner
//	L.add_movespeed_modifier(QLIPHOTH_SLOWDOWN)
	L.adjustStaminaLoss(167, TRUE, TRUE)
	L.adjustStaminaRecovery(-10) //anything with below 10 stamina recovery will continue to lose stamina
	L.update_stamina()
	statuseffectvisual = icon('icons/obj/clockwork_objects.dmi', "vanguard")
	owner.add_overlay(statuseffectvisual)

/datum/status_effect/qliphothoverload/on_remove()
	var/mob/living/simple_animal/hostile/L = owner
//	L.remove_movespeed_modifier(QLIPHOTH_SLOWDOWN)
	L.adjustStaminaLoss(-167, TRUE, TRUE)
	L.adjustStaminaRecovery(0)
	L.update_stamina()
	owner.cut_overlay(statuseffectvisual)
	return ..()

//update_stamina() is move_to_delay = (initial(move_to_delay) + (staminaloss * 0.06))
// 100 stamina damage equals 6 additional move_to_delay. So 167*0.06 = 10.02

	//improved detector code WARNING USES PROCESS

/obj/item/powered_gadget/detector_gadget
	name = "incomplete detector"
	desc = "This is the incomplete assembly of a detector gadget."
	icon_state = "gadget2_low"
	default_icon = "gadget2" //roundabout way of making update item easily changed. Used in updateicon proc.
	batterycost = 40 // 1 minute
	var/on = 0
	var/entitydistance
	var/nearestentity
	var/their_loc
	var/distance

/obj/item/powered_gadget/detector_gadget/attack_self(mob/user)
	..()
	if(on == 1)
		on = 0
		STOP_PROCESSING(SSobj, src)
		return
	if(cell && cell.charge >= batterycost)
		if(on == 0)
			on = 1
			START_PROCESSING(SSobj, src)
			return
	if(cell && cell.charge < batterycost)
		icon_state = "[default_icon]-nobat"

/obj/item/powered_gadget/detector_gadget/proc/calcdistance(distance)
	switch(distance)
		if(0 to 9) // the abnormality is within your sight or 10 tiles away from you
			icon_state = "[default_icon]_high"
			playsound(src, 'sound/machines/beep.ogg', 20, TRUE)
		if(10 to 20) //the abnormality is one screen away
			icon_state = "[default_icon]_mid"
			playsound(src, 'sound/machines/beep.ogg', 10, TRUE)
		else //the abnormality is too far away to be registered.
			icon_state = "[default_icon]_low"

/obj/item/powered_gadget/detector_gadget/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/powered_gadget/detector_gadget/process(delta_time)
	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		var/turf/my_loc = get_turf(src)
		detectthing()
		var/target_loc = get_turf(nearestentity)
		var/entitydistance = get_dist_euclidian(my_loc, target_loc)
		calcdistance(entitydistance)
		return
	on = 0
	icon_state = "[default_icon]-nobat"
	STOP_PROCESSING(SSobj, src)

/obj/item/powered_gadget/detector_gadget/proc/detectthing(mob/user)
	src.visible_message("<span class='notice'>The [src] falls apart.</span>", "<span class='notice'>You press a button and the [src] starts whirring before falling apart.</span>")
	qdel(src)
	return

	//Abnormality Detector
/obj/item/powered_gadget/detector_gadget/abnormality
	name = "Enkaphlin Drain Monitor"
	desc = "This device detects abnormalities by taking advantage of their siphon of Enkaphlin. Use in hand to activate."
	icon_state = "gadget2_low"
	default_icon = "gadget2" //roundabout way of making update item easily changed. Used in updateicon proc.

/obj/item/powered_gadget/detector_gadget/abnormality/calcdistance(distance)
	switch(distance)
		if(0 to 9) // the abnormality is within your sight or 10 tiles away from you
			icon_state = "[default_icon]_high"
			playsound(src, 'sound/machines/beep.ogg', 8, TRUE)
		if(10 to 20) //the abnormality is one screen away
			icon_state = "[default_icon]_mid"
			playsound(src, 'sound/machines/beep.ogg', 5, TRUE)
		else //the abnormality is too far away to be registered.
			icon_state = "[default_icon]_low"
			return
	if(nearestentity)
		var/mob/living/simple_animal/hostile/abnormality/THREAT = nearestentity
		if(THREAT.threat_level == ALEPH_LEVEL)
			if(prob(25))
				playsound(src, 'sound/hallucinations/over_here1.ogg', 5, TRUE)
			playsound(src, 'sound/magic/voidblink.ogg', 12, TRUE)
			return

/obj/item/powered_gadget/detector_gadget/abnormality/detectthing()
	var/turf/my_loc = get_turf(src)
	var/list/mob/living/simple_animal/hostile/abnormality/nearbyentities = list()
	for(var/mob/living/simple_animal/hostile/abnormality/ABNO in livinginrange(21, get_turf(src)))
		if(!(ABNO.status_flags & GODMODE))
			their_loc = get_turf(ABNO)
			var/distance = get_dist_euclidian(my_loc, their_loc)
			nearbyentities[ABNO] = (20 ** 1) - (distance ** 1)
			nearestentity = pickweight(nearbyentities)

	//Ordeal Detector
/obj/item/powered_gadget/detector_gadget/ordeal
	name = "R-corp Keen Sense Rangefinder" //placeholder name
	desc = "Through the joint research of L and R corp this device can detect the proximity of hostile creatures without having employees or abnormalities caught in its range. Use in hand to activate."
	icon_state = "gadget2r-low"
	default_icon = "gadget2r" //roundabout way of making update item easily changed. Used in updateicon proc.

/obj/item/powered_gadget/detector_gadget/ordeal/Initialize()
	..()
	if(prob(2))
		name = "R-corp Peen Sense Rangefinder"

/obj/item/powered_gadget/detector_gadget/ordeal/calcdistance(distance)
	switch(distance)
		if(0 to 5)
			icon_state = "[default_icon]-max"
			playsound(src, 'sound/machines/beep.ogg', 14, TRUE)
		if(6 to 9)
			icon_state = "[default_icon]-high"
			playsound(src, 'sound/machines/beep.ogg', 8, TRUE)
		if(10 to 20) //the entity is one screen away
			icon_state = "[default_icon]-mid"
			playsound(src, 'sound/machines/beep.ogg', 5, TRUE)
		else //the entity is too far away to be registered.
			icon_state = "[default_icon]-low"

/obj/item/powered_gadget/detector_gadget/ordeal/detectthing()
	var/turf/my_loc = get_turf(src)
	var/list/mob/living/simple_animal/hostile/ordeal/nearbyentities = list()
	if(nearestentity)
		var/mob/living/simple_animal/hostile/ordeal/M = nearestentity
		if(M.stat == DEAD)
			nearbyentities -= nearestentity
			nearestentity = null
	for(var/mob/living/simple_animal/hostile/ordeal/MON in livinginrange(21, get_turf(src)))
		if(!(MON.status_flags & GODMODE) && MON.stat != DEAD)
			their_loc = get_turf(MON)
			distance = get_dist_euclidian(my_loc, their_loc)
			nearbyentities[MON] = (20 ** 1) - (distance ** 1)
			nearestentity = pickweight(nearbyentities)

/obj/item/powered_gadget/teleporter
	name = "W-Corp instant transmission device"
	desc = "A battery powered tool that can be used to jump between departments."
	icon_state = "teleporter"
	batterycost = 500 //20 uses before requires recharge
	var/inuse
	default_icon = "teleporter"

/obj/item/powered_gadget/teleporter/attack_self(mob/user)
	..()

	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		icon_state = default_icon
	else if (cell && cell.charge < batterycost)
		icon_state = "[default_icon]-empty"
		to_chat(user, "<span class='notice'>The batteries are dead.</span>")
		return
	else if (!cell)
		icon_state = "[default_icon]-nobat"
		return

	if(inuse)
		return
	inuse = TRUE
	to_chat(user, "<span class='notice'>You press the button and begin to teleport.</span>")
	if(do_after(user, 100))	//Ten seconds of not doing anything, then teleport.
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(user))

		//teleporting half
		var/turf/T = pick(GLOB.department_centers)
		user.forceMove(T)
		new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(user))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
	inuse = FALSE

/obj/item/trait_injector
	name = "Trait Injector"
	desc = "A blank trait injector that imbues certain roles with a specific trait."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity7_firewater"
	var/list/roles = list()
	var/trait
	var/error_message = ""
	var/success_message = ""

/obj/item/trait_injector/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !(user.mind?.assigned_role in roles))
		to_chat(user, "<span class='notice'>The injector light flashes red. [error_message] Check the label before use.</span>")
		return
	InjectTrait(user)

/obj/item/trait_injector/proc/InjectTrait(mob/living/carbon/human/user)
	to_chat(user, "<span class='nicegreen'>The injector blinks green before it disintegrates. [success_message]</span>")
	if(trait)
		ADD_TRAIT(user, trait, JOB_TRAIT)
	qdel(src)
	return

/obj/item/trait_injector/officer_upgrade_injector
	name = "Officer Upgrade Injector"
	desc = "A strange liquid used to improve an officer's skills. Use in hand to activate. A small note on the injector states that 'officer' means Extraction Officer and Records Officer."
	icon_state = "oddity7_gween"
	roles = list("Records Officer", "Extraction Officer")
	error_message = "You aren't an officer."
	success_message = "You feel vigourous and stronger."

/obj/item/trait_injector/officer_upgrade_injector/InjectTrait(mob/living/carbon/human/user)
	user.adjust_all_attribute_levels(20)
	..()
	return

/obj/item/trait_injector/agent_workchance_trait_injector
	name = "Agent Work Chance Injector"
	desc = "An injector containing liquid that allows agents to view their chances before work. Use in hand to activate. A small note on the injector states that 'agent' means anyone under the security detail. Another note states that Officers aren't security detail."
	icon_state = "oddity7_orange"
	trait = TRAIT_WORK_KNOWLEDGE
	error_message = "You aren't an agent."
	success_message = "You feel enlightened and wiser."

/obj/item/trait_injector/agent_workchance_trait_injector/Initialize()
	. = ..()
	roles = GLOB.security_positions

/obj/item/trait_injector/clerk_fear_immunity_injector
	name = "C-Fear Protection Injector"
	desc = "Contains fire water that protects clerks from the downsides of witnessing dangerous abnormalities. Use in hand to activate. A small note on the injector states that 'clerk' means anyone with a job under service positions."
	icon_state = "oddity7_firewater"
	trait = TRAIT_COMBATFEAR_IMMUNE
	error_message = "You aren't a clerk."
	success_message = "You feel emboldened and braver."

/obj/item/trait_injector/clerk_fear_immunity_injector/Initialize()
	. = ..()
	roles = GLOB.service_positions

/obj/item/trait_injector/shrimp_injector
	name = "Shrimp Injector"
	desc = "The injector contains a pink substance, is this really worth it? Usable by only clerks. Use in hand to activate. A small note on the injector states that 'clerk' means anyone with a job under service positions."
	icon_state = "oddity7_pink"
	error_message = "You aren't a clerk."
	success_message = "You feel pink? A catchy song about shrimp comes to mind."

/obj/item/trait_injector/shrimp_injector/Initialize()
	. = ..()
	roles = GLOB.service_positions

/obj/item/trait_injector/shrimp_injector/InjectTrait(mob/living/carbon/human/user)
	if(!faction_check(user.faction, list("shrimp")))
		user.faction |= "shrimp"
		..()
		return
	to_chat(user,"<span class='userdanger'>The injector burns red before switching to green and dissapearing. You feel uneasy.</span>")
	qdel(src)
	sleep(rand(20, 50)) // 2 to 5 seconds
	if(prob(70))
		new /mob/living/simple_animal/hostile/shrimp(get_turf(user))
	else
		new /mob/living/simple_animal/hostile/shrimp_soldier(get_turf(user))
	user.gib()

/obj/item/powered_gadget/clerkbot_gadget
	name = "Instant Clerkbot Constructor"
	desc = "An instant constructor for Clerkbots. Loyal little things that attack hostile creatures. Only for clerks."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "clerkbot2_deactivated"
	default_icon = "clerkbot2_deactivated"
	batterycost = 10000

/obj/item/powered_gadget/clerkbot_gadget/attack_self(mob/user)
	..()
	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		icon_state = default_icon
		if(!istype(user) || !(user?.mind?.assigned_role in GLOB.service_positions))
			to_chat(user, "<span class='notice'>The Gadget's light flashes red. You aren't a clerk. Check the label before use.</span>")
			return
		new /mob/living/simple_animal/hostile/clerkbot(get_turf(user))
		to_chat(user, "<span class='nicegreen'>The Gadget turns warm and sparks.</span>")


/mob/living/simple_animal/hostile/clerkbot/Initialize()
	..()
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "clerkbot2"
	icon_living = "clerkbot2"
	if(prob(50))
		icon_state = "clerkbot1"
		icon_living = "clerkbot1"

/mob/living/simple_animal/hostile/clerkbot
	name = "A Well Rounded Clerkbot"
	desc = "Trusted and loyal best friend."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "clerkbot2"
	icon_living = "clerkbot2"
	faction = list("neutral")
	health = 150
	maxHealth = 150
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 0.9, BLACK_DAMAGE = 0.9, PALE_DAMAGE = 1.5)
	melee_damage_lower = 12
	melee_damage_upper = 14
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "buzzes"
	attack_verb_simple = "buzz"
	attack_sound = 'sound/weapons/bite.ogg'

/mob/living/simple_animal/hostile/clerkbot/Initialize()
	..()
	QDEL_IN(src, (120 SECONDS))

/obj/item/powered_gadget/handheld_taser
	name = "Handheld Taser"
	desc = "A portable electricution device. Two settings, stun and slow. Automatically slows abnormalities instead of stunning them."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget1"
	default_icon = "gadget1"
	batterycost = 1500
	var/batterycost_stun = 3000
	var/batterycost_slow = 1500
	var/hit_message= null

/obj/item/powered_gadget/handheld_taser/attack_self(mob/user)
	if(!cell || cell.charge < batterycost_slow)
		to_chat(user, "<span class='notice'>The Gadget buzzes. Battery charge too low.</span>")
		return
	if(batterycost == batterycost_slow)
		if(cell.charge < batterycost_stun)
			to_chat(user, "<span class='notice'>The Gadget buzzes. Battery charge too low.</span>")
			return
		batterycost = batterycost_stun
		to_chat(user, "<span class='nicegreen'>The Gadget's light burns orange before clicking ready to Stun.</span>")
		return
	batterycost = batterycost_slow
	to_chat(user, "<span class='nicegreen'>The Gadget's light blinks yellow before clicking ready to Slow.</span>")

/obj/item/powered_gadget/handheld_taser/attack(var/mob/living/T, mob/living/user)
	if(user.a_intent != INTENT_HARM)
		hit_message = "<span class='notice'>[user] lightly pokes [T] with the taser.</span>"
		user.visible_message(hit_message)
		return
	hit_message = "<span class='userdanger'>[user] smashes the taser into [T].</span>"
	if(isabnormalitymob(T) && cell.charge >= batterycost_slow)
		cell.charge = cell.charge - batterycost_slow
		user.visible_message(hit_message)
		T.apply_status_effect(/datum/status_effect/qliphothoverload)
		return
	if (!cell || cell.charge < batterycost || isabnormalitymob(T))
		to_chat(user, "<span class='notice'>The Gadget buzzes. Battery charge too low.</span>")
		return
	if (batterycost == batterycost_stun)
		T.apply_status_effect(/datum/status_effect/qliphothoverload)
		T.Knockdown(1)
	else
		T.Stun(10)
	cell.charge = cell.charge - batterycost
	user.visible_message(hit_message)
