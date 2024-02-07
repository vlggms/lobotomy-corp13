
//Gadgets that require batteries or fuel to function!
/obj/item/powered_gadget
	name = "gadget template"
	desc = "A template for a battery powered tool, the battery compartment is screwed shut in order to prevent people from eating the batteries."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget1"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	//roundabout way of making update item easily changed. Used in updateicon proc.
	var/default_icon
	//maxcharge = 10000
	var/cell_type = /obj/item/stock_parts/cell/high
	var/obj/item/stock_parts/cell/cell
	//5 uses before requires recharge
	var/batterycost = 2000
	var/turned_on = 0
	var/chosen_target_type = 1
	//unique overlays for powered state. This is so that a overlay can be put on instead of changing the entire sprite.
	var/powered_overlay = null

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

/obj/item/powered_gadget/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(cell)
			W.play_tool_sound(src)
			to_chat(user, span_notice("You undo the safety lock and remove the [cell]."))
			user.put_in_hands(cell)
			ReplacePowerCell()
	if(istype(W, /obj/item/stock_parts/cell))
		if(!cell)
			if(ReplacePowerCell(W, user))
				to_chat(user, span_notice("You insert [W] into [src]."))
			return
		else
			user.dropItemToGround(cell)
			if(ReplacePowerCell(W, user))
				to_chat(user, span_notice("You preform what could be called a tactical reload on the [src]."))
			return

	if(cantbeused(user))
		return

	return ..()

/obj/item/powered_gadget/examine(mob/living/M)
	. = ..()
	if(cell)
		. += span_notice("Its display shows: [DisplayEnergy(cell.charge)].")
	else
		. += span_notice("Its display is dark.")

/obj/item/powered_gadget/update_icon_state()
	if(default_icon)
		if(!cell)
			icon_state = "[default_icon]-nobat"
		else
			icon_state = "[default_icon]"

/obj/item/powered_gadget/update_overlays()
	. = ..()
	if(powered_overlay)
		. += "[powered_overlay]"

//replaces battery and defines cell as battery so that you wont end up having the battery be outside the thing that it is powering.
/obj/item/powered_gadget/proc/ReplacePowerCell(obj/item/stock_parts/cell/power_cell = null, mob/user)
	if(!isnull(power_cell))
		//Also functions as a way to define battery as null when removed
		//if there is no battery replacing it. However if the replacement battery is not put inside it will fail.
		if(user)
			if(!user.transferItemToLoc(power_cell, src))
				return FALSE
	cell = power_cell
	update_icon_state()
	update_icon()
	return TRUE

/obj/item/powered_gadget/proc/toggle_on(mob/user)
	if(cell && cell.charge >= batterycost)
		turned_on = !turned_on
		to_chat(user, span_notice("[src] is now [turned_on ? "on" : "off"]."))
	else
		turned_on = FALSE
		if(!cell)
			to_chat(user, span_warning("[src] does not have a power source!"))
		else
			to_chat(user, span_warning("[src] is out of charge."))
	update_icon()
	add_fingerprint(user)

/obj/item/powered_gadget/proc/cantbeused(mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("You don't have the dexterity to use [src]!"))
		return TRUE

	if(!cell)
		to_chat(user, span_warning("[src] doesn't have a power cell installed!"))
		return TRUE

	if(!cell.charge)
		to_chat(user, span_warning("[src]'s battery is dead!"))
		return TRUE
	return FALSE

/obj/item/powered_gadget/proc/target_check(target)
	switch(chosen_target_type)
		if(1)
			if(ishuman(target))
				return TRUE
		if(2)
			if(istype(target, /mob/living/simple_animal/hostile/ordeal))
				return TRUE
		if(3)
			if(isabnormalitymob(target))
				return TRUE
	return FALSE


	//Trapspawner
/obj/item/powered_gadget/slowingtrapmk1
	name = "Qliphoth Field Projector"
	desc = "This device places traps that reduces the mobility of Abnormalities for a limited time when used in hand. The Movement Speed of an Abnormality will be reduced via overloading the Qliphoth control"
	default_icon = "gadget1"
	var/placed_structure = /obj/structure/slowingmk1

/obj/item/powered_gadget/slowingtrapmk1/attack_self(mob/user)
	..()
	if(cell && cell.charge >= batterycost)
		for(var/obj/structure/slowingmk1/T in range(0, get_turf(user)))
			if(T)
				return
		cell.charge = cell.charge - batterycost
		return new placed_structure(get_turf(src))

/obj/structure/slowingmk1
	name = "qliphoth overloader mk1"//very placeholder name
	desc = "A device that delivers a burst of energy designed to overload the Qliphoth Control of abnormalities."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity2"
	anchored = TRUE

/obj/structure/slowingmk1/Initialize()
	. = ..()
	playsound(src, 'sound/machines/terminal_processing.ogg', 20, TRUE)
	for(var/obj/structure/slowingmk1/trap in view(1, get_turf(src)))
		if(trap != src)
			qdel(src)

/obj/structure/slowingmk1/Crossed(atom/movable/AM)
	. = ..()
	if(ishostile(AM))
		var/mob/living/simple_animal/hostile/L = AM
		L.apply_status_effect(/datum/status_effect/qliphothoverload)
		QDEL_IN(src, 2)
		return

/obj/item/powered_gadget/teleporter
	name = "W-Corp instant transmission device"
	desc = "A battery powered tool that can be used to jump between departments."
	icon_state = "teleporter"
	batterycost = 500 //20 uses before requires recharge
	var/inuse
	default_icon = "teleporter"

/obj/item/powered_gadget/teleporter/update_icon_state()
	if(cell && cell.charge >= batterycost)
		icon_state = default_icon
	else if (cell && cell.charge < batterycost)
		icon_state = "[default_icon]-empty"
	else if (!cell)
		icon_state = "[default_icon]-nobat"

/obj/item/powered_gadget/teleporter/attack_self(mob/user)
	..()
	var/area/turf_area = get_area(get_turf(user))
	if(istype(turf_area, /area/fishboat))
		to_chat(user, span_warning("The machine won't work, it's too damp!."))
		return
	if(cell && cell.charge >= batterycost)
		cell.charge = cell.charge - batterycost
		icon_state = default_icon
	else if (cell && cell.charge < batterycost)
		to_chat(user, span_notice("The batteries are dead."))
		update_icon()
		return
	else if (!cell)
		update_icon()
		return

	if(inuse)
		return
	inuse = TRUE
	to_chat(user, span_notice("You press the button and begin to teleport."))
	if(do_after(user, 100))	//Ten seconds of not doing anything, then teleport.
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(user))

		//teleporting half
		var/turf/T = pick(GLOB.department_centers)
		user.forceMove(T)
		new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(user))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
	inuse = FALSE
	update_icon()

//The taser
/obj/item/powered_gadget/handheld_taser
	name = "Handheld Taser"
	desc = "A portable electricution device. Two settings, stun and slow. Automatically slows abnormalities instead of stunning them."
	icon_state = "taser"
	default_icon = "taser"
	batterycost = 1500
	var/batterycost_stun = 3000
	var/batterycost_slow = 1500
	var/hit_message= null

/obj/item/powered_gadget/handheld_taser/attack_self(mob/user)
	if(!cell || cell.charge < batterycost_slow)
		to_chat(user, span_notice("The Gadget buzzes. Battery charge too low."))
		return
	if(batterycost == batterycost_slow)
		if(cell.charge < batterycost_stun)
			to_chat(user, span_notice("The Gadget buzzes. Battery charge too low."))
			return
		batterycost = batterycost_stun
		to_chat(user, span_nicegreen("The Gadget's light burns orange before clicking ready to Stun."))
		return
	batterycost = batterycost_slow
	to_chat(user, span_nicegreen("The Gadget's light blinks yellow before clicking ready to Slow."))

/obj/item/powered_gadget/handheld_taser/attack(var/mob/living/T, mob/living/user)
	if(user.a_intent != INTENT_HARM)
		hit_message = span_notice("[user] lightly pokes [T] with the taser.")
		user.visible_message(hit_message)
		return
	hit_message = span_userdanger("[user] smashes the taser into [T].")
	if(ishostile(T) && cell.charge >= batterycost_slow)
		cell.charge = cell.charge - batterycost_slow
		user.visible_message(hit_message)
		T.apply_status_effect(/datum/status_effect/qliphothoverload)
		return
	if (!cell || cell.charge < batterycost || isabnormalitymob(T))
		to_chat(user, span_notice("The Gadget buzzes. Battery charge too low."))
		return
	if (batterycost == batterycost_stun)
		T.apply_status_effect(/datum/status_effect/qliphothoverload)
		T.Knockdown(1)
	else
		T.Stun(10)
	cell.charge = cell.charge - batterycost
	user.visible_message(hit_message)


	//Vitals Projector
/obj/item/powered_gadget/vitals_projector
	name = "vitals projector"
	desc = "Point this device at a enemy and use it to project the current vitals of its target. A wrench can change its target type."
	icon_state = "gadgetmod"
	 //roundabout way of making update item easily changed. Used in updateicon proc.
	default_icon = "gadgetmod"
	force = 0

/obj/item/powered_gadget/vitals_projector/Initialize()
	. = ..()
	batterycost = round(cell.maxcharge * 0.10)

/obj/item/powered_gadget/vitals_projector/attack_self(mob/user)
	var/mod1_ask = alert("modify tool?", "Choose a target type.", "Human", "Ordeal", "Abnormality", "cancel")
	if(do_after(user, 3 SECONDS, user, IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE))
		switch(mod1_ask)
			if("cancel")
				return
			if("Human")
				chosen_target_type = 1
				batterycost = round(cell.maxcharge * 0.10)
			if("Ordeal")
				chosen_target_type = 2
				batterycost = round(cell.maxcharge * 0.15)
			if("Abnormality")
				chosen_target_type = 3
				batterycost = round(cell.maxcharge * 0.20)
		update_icon()
	return

/obj/item/powered_gadget/vitals_projector/update_overlays()
	. = ..()
	switch(chosen_target_type)
		if(1)
			. += "gadgetmod_gadd"
		if(2)
			. += "gadgetmod_padd"
		if(3)
			. += "gadgetmod_radd"

/obj/item/powered_gadget/vitals_projector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!chosen_target_type)
		to_chat(user, span_warning("Use in-hand to set the target type!"))
		return
	if(cell && cell.charge >= batterycost)
		if(isliving(target))
			if(!target_check(target))
				to_chat(user, span_warning("The projector fails to scan [target] with its current setting."))
				return
			cell.charge -= batterycost
			var/mob/living/L = target
			to_chat(user, span_notice("Projection of [target] Vitals Initializing."))
			L.apply_status_effect(/datum/status_effect/visualize_vitals)
	else if(!cell || cell.charge <= batterycost)
		to_chat(user, span_warning("Insufficent Energy for Projection."))
		update_icon()

/obj/item/powered_gadget/vitals_projector/examine(mob/living/M)
	. = ..()
	switch(chosen_target_type)
		if(1)
			. += span_notice("Its currently set to Human.")
		if(2)
			. += span_notice("Its currently set to Ordeal.")
		if(3)
			. += span_notice("Its currently set to Abnormality.")

//status effects
/datum/status_effect/visualize_vitals
	id = "visualize vitals"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 400
	tick_interval = 20 //2seconds
	alert_type = null
	var/current_vitals = 0
	var/previous_overlay
	var/vitals
	var/vitals_icon
	var/vitals_color

/datum/status_effect/visualize_vitals/tick()
	if(!isliving(owner))
		qdel(src)
	if(owner.health != current_vitals)
		check_vitals(owner)
		current_vitals = owner.health
	. = ..()

/datum/status_effect/visualize_vitals/on_remove()
	owner.cut_overlay(previous_overlay)
	. = ..()

/datum/status_effect/visualize_vitals/proc/check_vitals(mob/living/L)
	L.cut_overlay(previous_overlay)
	vitals = round((owner.health / owner.maxHealth) * 100)
	switch(vitals)
		if(100 to INFINITY)
			vitals_color = "#008000"
			vitals_icon = "hp100"
		if(50 to 99)
			vitals_color = "#e6cc00"
			vitals_icon = "hp75"
		if(25 to 49)
			vitals_color = "#ffa500"
			vitals_icon = "hp50"
		if(1 to 24)
			vitals_color = "#FF0000"
			vitals_icon = "hp25"
		else
			vitals_color = "#808080"
			vitals_icon = "hp0"
	var/mutable_appearance/colored_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', vitals_icon)
	if(!ishuman(owner))
		colored_overlay.pixel_x = -owner.pixel_x
		colored_overlay.pixel_y = -owner.pixel_y
	previous_overlay = colored_overlay
	L.add_overlay(colored_overlay)

//Injector
/obj/item/powered_gadget/enkephalin_injector
	name = "Prototype Enkephalin Injector"
	desc = "A tool designed to inject raw enkephalin from our batteries to pacify hostile lifeforms. \
			However, the development was discontinued after the safety department abused it for... other purposes. \
			This version only makes the entities even more hostile towards you. Only for clerks"
	icon_state = "e_injector"
	default_icon = "e_injector"
	batterycost = 5000
	var/hit_message= null

/obj/item/powered_gadget/enkephalin_injector/attack(mob/living/T, mob/user)
	if(!istype(user) || !(user?.mind?.assigned_role in GLOB.service_positions))
		to_chat(user, span_notice("The Gadget's light flashes red. You aren't a clerk. Check the label before use."))
		return
	if(T.status_flags & GODMODE)
		to_chat(user, span_notice("[T] simply ignores you."))
		return
	if(cell.charge >= batterycost && ishostile(T) && T.stat != DEAD && !(T.status_flags & GODMODE) && !T.client)
		var/mob/living/simple_animal/hostile/H = T
		if(H.target != user)
			hit_message = span_warning("[user] injected some enkephalin into [T].")
			H.GiveTarget(user)
			user.visible_message(hit_message)
			cell.charge -= batterycost
			update_icon()
			return
		else
			to_chat(user, span_warning("[T] is already targetting you."))
			return
	if (!cell || cell.charge < batterycost)
		to_chat(user, span_notice("The Gadget buzzes. Battery charge too low."))
		update_icon()
		return
	to_chat(user, span_notice("You can't use this on [T]."))
