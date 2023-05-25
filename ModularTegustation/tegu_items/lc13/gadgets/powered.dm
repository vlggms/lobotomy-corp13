
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
	var/chosen_target_type = 1

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

/obj/structure/slowingmk1/Initialize()
	. = ..()
	playsound(src, 'sound/machines/terminal_processing.ogg', 20, TRUE)
	for(var/obj/structure/slowingmk1/trap in view(1, get_turf(src)))
		if(trap != src)
			qdel(src)

/obj/structure/slowingmk1/Crossed(atom/movable/AM)
	. = ..()
	if(isabnormalitymob(AM))
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

/obj/item/powered_gadget/clerkbot_gadget
	name = "Instant Clerkbot Constructor"
	desc = "An instant constructor for Clerkbots. Loyal little things that attack hostile creatures. Only for clerks."
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


	//Vitals Projector
/obj/item/powered_gadget/vitals_projector
	name = "vitals projector"
	desc = "Point this device at a enemy and use it to project the current vitals of its target. A wrench can change its target type."
	icon_state = "gadgetmod_projector"
	default_icon = "gadgetmod" //roundabout way of making update item easily changed. Used in updateicon proc.
	var/current_target_overlay

/obj/item/powered_gadget/vitals_projector/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_WRENCH)
		var/mod1_ask = alert("modify tool?", "Choose a target type.", "Human", "Ordeal", "Abnormality", "cancel")
		batterycost = initial(batterycost)
		if(do_after(user, 5 SECONDS, target = user))
			cut_overlay(current_target_overlay)
			switch(mod1_ask)
				if("cancel")
					return
				if("Human")
					chosen_target_type = 1
					current_target_overlay = mutable_appearance(icon, "gadgetmod_gadd")
				if("Ordeal")
					chosen_target_type = 2
					batterycost += round(cell.maxcharge * 0.15)
					current_target_overlay = mutable_appearance(icon, "gadgetmod_padd")
				if("Abnormality")
					chosen_target_type = 3
					batterycost += round(cell.maxcharge * 0.25)
					current_target_overlay = mutable_appearance(icon, "gadgetmod_radd")
			add_overlay(current_target_overlay)
			return
	return ..()

/obj/item/powered_gadget/vitals_projector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!chosen_target_type)
		to_chat(user, "<span class='warning'>A wrench is needed to set the target type!</span>")
	if(cell && cell.charge >= batterycost && target_check(target))
		cell.charge -= batterycost
		var/mob/living/L = target
		L.apply_status_effect(/datum/status_effect/visualize_vitals)

/obj/item/powered_gadget/vitals_projector/examine(mob/living/M)
	. = ..()
	switch(chosen_target_type)
		if(1)
			. += "<span class='notice'>Its currently set to Human.</span>"
		if(2)
			. += "<span class='notice'>Its currently set to Ordeal.</span>"
		if(3)
			. += "<span class='notice'>Its currently set to Abnormality.</span>"

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
