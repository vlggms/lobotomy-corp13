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

/obj/item/managerbullet/proc/bulletshatter(mob/living/L)
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

//Gadgets require batteries or fuel to function!
/obj/item/powered_gadget
	name = "gadget template"
	desc = "A template for a battery powered tool, the battery compartment is screwed shut in order to prevent people from eating the batteries."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget1"
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
				to_chat(user, "<span class='warning'>[src] already has \a [cell] installed!</span>")
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
		update_icon()
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
	//Detector
/obj/item/powered_gadget/abnormalitydetector
	name = "Enkaphlin Drain Monitor"
	desc = "This device detects abnormalities by taking advantage of their siphon of Enkaphlin."
	icon_state = "gadget2_low"
	default_icon = "gadget2" //roundabout way of making update item easily changed. Used in updateicon proc.
	batterycost = 1000 //10 uses

/obj/item/powered_gadget/abnormalitydetector/attack_self(mob/user)
	..()
	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		var/turf/my_loc = get_turf(src)
		var/list/mob/living/simple_animal/hostile/abnormality/nearbyentities = list()
		for(var/mob/living/simple_animal/hostile/abnormality/ABNO in livinginrange(21, get_turf(src)))
			if(!(ABNO.status_flags & GODMODE))
				var/their_loc = get_turf(ABNO)
				var/distance = get_dist_euclidian(my_loc, their_loc)
				nearbyentities[ABNO] = (20 ** 1) - (distance ** 1)
		var/nearestentity = pickweight(nearbyentities)
		var/target_loc = get_turf(nearestentity)
		var/abnodistance = get_dist_euclidian(my_loc, target_loc)
		calcdistance(abnodistance)
	if(cell && cell.charge <= batterycost)
		icon_state = "gadget2-nobat"

/obj/item/powered_gadget/abnormalitydetector/proc/calcdistance(distance)
	switch(distance)
		if(0 to 10) // the abnormality is within your sight or 10 tiles away from you
			icon_state = "gadget2_high"
			playsound(src, 'sound/machines/beep.ogg', 20, TRUE)
		if(11 to 20) //the abnormality is one screen away
			icon_state = "gadget2_mid"
			playsound(src, 'sound/machines/beep.ogg', 10, TRUE)
		if(21) //the abnormality is too far away to be registered.
			icon_state = "gadget2_low"
			playsound(src, 'sound/machines/beep.ogg', 4, TRUE)

	//Ordeal detector
/obj/item/powered_gadget/ordealdetector
	name = "R-corp Keen Sense Rangefinder" //placeholder name
	desc = "Through the joint research of L and R corp this device can detect the proximity of hostile creatures without having employees or abnormalities caught in its range."
	icon_state = "gadget2r-low"
	default_icon = "gadget2r" //roundabout way of making update item easily changed. Used in updateicon proc.
	batterycost = 1000  // 10 uses

/obj/item/powered_gadget/ordealdetector/Initialize()
	..()
	if(prob(2))
		name = "R-corp Peen Sense Rangefinder"

/obj/item/powered_gadget/ordealdetector/attack_self(mob/user)
	..()
	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		var/turf/my_loc = get_turf(src)
		var/list/mob/living/simple_animal/hostile/ordeal/nearbyentities = list()
		for(var/mob/living/simple_animal/hostile/ordeal/MON in livinginrange(21, get_turf(src)))
			if(!(MON.status_flags & GODMODE))
				var/their_loc = get_turf(MON)
				var/distance = get_dist_euclidian(my_loc, their_loc)
				nearbyentities[MON] = (20 ** 1) - (distance ** 1)
		var/nearestentity = pickweight(nearbyentities)
		var/target_loc = get_turf(nearestentity)
		var/entitydistance = get_dist_euclidian(my_loc, target_loc)
		calcdistance(entitydistance)
	if(cell && cell.charge <= batterycost)
		icon_state = "gadget2r-nobat"

/obj/item/powered_gadget/ordealdetector/proc/calcdistance(distance)
	switch(distance)
		if(0 to 5)
			icon_state = "gadget2r-max"
			playsound(src, 'sound/machines/beep.ogg', 20, TRUE)
		if(6 to 10)
			icon_state = "gadget2r-high"
			playsound(src, 'sound/machines/beep.ogg', 20, TRUE)
		if(11 to 20) //the entity is one screen away
			icon_state = "gadget2r-mid"
			playsound(src, 'sound/machines/beep.ogg', 10, TRUE)
		if(21) //the entity is too far away to be registered.
			icon_state = "gadget2r-low"
			playsound(src, 'sound/machines/beep.ogg', 4, TRUE)

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

/obj/item/deepscanner //intended for ordeals
	name = "deep scan kit"
	desc = "A collection of tools used for scanning the physical form of an entity."
	icon = 'icons/obj/storage.dmi'
	icon_state = "maint_kit"
	color = "gold"
	var/check1a
	var/check1b
	var/check1c
	var/check1d

/obj/item/deepscanner/attack(mob/living/M, mob/user)
	if(ishuman(M))
		return
	else
		var/mob/living/simple_animal/hostile/mon = M
		if((mon.status_flags & GODMODE))
			return
		check1a = measuredamage(mon.damage_coeff[RED_DAMAGE])
		check1b = measuredamage(mon.damage_coeff[WHITE_DAMAGE])
		check1c = measuredamage(mon.damage_coeff[BLACK_DAMAGE])
		check1d = measuredamage(mon.damage_coeff[PALE_DAMAGE])
		M.visible_message("<span class='notice'>[mon] [mon.maxHealth] [check1a] [check1b] [check1c] [check1d].</span>")
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
