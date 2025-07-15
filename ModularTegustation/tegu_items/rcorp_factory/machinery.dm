/*
* WARNING THIS CODE IS VERY SLOPPY AND UNOPTIMIZED -IP
* Ideally none of these machines exist on roundstart so that they can be
* freely edited in the code whenever.
*/
#define FACTORY_INPUT_HAND 1
#define FACTORY_INPUT_CONVEYOR 2
/obj/machinery/factory_machine
	name = "factory prototype"
	icon = 'ModularTegustation/Teguicons/expedition_32x32.dmi'
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	processing_flags = START_PROCESSING_MANUALLY
	//Very fragile machinery
	max_integrity = 50
	//Max amount of resources stored in this object
	var/storage_max = 70
	//Resources converted into number. Value of resources.
	var/current_storage = 0
	//Item that can be fed into this machine.
	var/storage_type
	//Direction that the machine outputs when OutputItem(). If null drops onto loc.
	var/output_dir
	//Delay in process() effect.
	var/output_cooldown = 0
	var/output_delay = 2 SECONDS
	//Delay in InputItem() effect.
	var/input_cooldown = 0
	var/input_delay
	//Item dropped by machine when crowbarred. If null will not be crowbarable.
	var/dropped_item
	//If the object can be rotated with a wrench.
	var/wrench_rotatable = FALSE

/obj/machinery/factory_machine/update_overlays()
	. = ..()
	. += FormatFillOverlay()

/obj/machinery/factory_machine/examine(mob/user)
	. = ..()
	var/tool_info
	if(wrench_rotatable)
		tool_info += "Can be wrenched to rotate. "
	if(dropped_item)
		tool_info += "Can be dissasembled with a crowbar. "
	if(tool_info)
		. += tool_info

//Do not allow items to pass unless InputItem returns True
/obj/machinery/factory_machine/CanAllowThrough(atom/movable/mover, turf/target)
	if(InputItem(mover, FACTORY_INPUT_CONVEYOR))
		return TRUE
	return ..()

//If attacked with a item assume we are being fed it as a resource
/obj/machinery/factory_machine/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_CROWBAR && dropped_item)
		Dissasemble(user, I)
		return
	if(I.tool_behaviour == TOOL_WRENCH && wrench_rotatable)
		if(!(machine_stat & BROKEN))
			I.play_tool_sound(src)
			setDir(turn(dir,-90))
			to_chat(user, "<span class='notice'>You rotate [src].</span>")
			return
	if(InputItem(I, FACTORY_INPUT_HAND))
		return
	return ..()

//If cooldown is more than world.time do not process TRUE.
/obj/machinery/factory_machine/process(delta_time)
	if(world.time <= output_cooldown)
		return FALSE
	output_cooldown = world.time + output_delay
	return TRUE

//For deconstructing the machinery
/obj/machinery/factory_machine/proc/Dissasemble(mob/living/user, obj/item/I)
	user.visible_message(span_notice("[user] struggles to pry up \the [src] with \the [I]."),
	span_notice("You struggle to pry up \the [src] with \the [I]."))
	if(I.use_tool(src, user, 40, volume=40))
		if(!(machine_stat & BROKEN))
			new dropped_item(get_turf(src))
		to_chat(user, span_notice("You dissasemble the [src]."))
		qdel(src)

//If the item is deleted do not return TRUE on InputItem
/obj/machinery/factory_machine/proc/InputItem(atom/movable/target, input_method)
	. = TRUE
	if(QDELETED(target))
		return FALSE
	//Okay you will need to override the proc to make a body grinder
	if(!isitem(target))
		return FALSE
	//For staggering the constant flow of material into the machine.
	if(input_delay && input_method != FACTORY_INPUT_HAND)
		if(input_cooldown > world.time)
			return FALSE
		input_cooldown = world.time + input_delay
	if(current_storage >= storage_max)
		return FALSE
	if(storage_type && !istype(target, storage_type))
		return FALSE

//If no direction stated, drop output item at location.
/obj/machinery/factory_machine/proc/OutputItem(atom/movable/product, direction)
	product.forceMove(drop_location())
	if(direction)
		var/turf/T = get_step(src,direction)
		if(T)
			product.forceMove(T)

//If item can be stored in materials check to make sure it is in materials. If not make a entry for it.
/obj/machinery/factory_machine/proc/StoreItem(atom/movable/target, special_data)
	current_storage += 1
	update_icon()
	qdel(target)

/obj/machinery/factory_machine/proc/FormatFillOverlay()
	return

/*-------\
|Recycler|
\-------*/
/obj/machinery/factory_machine/recycler
	name = "recycler"
	desc = "A machine that converts discarded items into green resource. Outputs items east of its position."
	icon_state = "recycler"
	storage_type = null
	output_dir = SOUTH
	var/conversion_cost = 10

/obj/machinery/factory_machine/recycler/StoreItem(atom/movable/target)
	. = ..()
	if(current_storage >= conversion_cost)
		var/I = new /obj/item/factoryitem/green(src)
		OutputItem(I, output_dir)

/obj/machinery/factory_machine/recycler/InputItem(atom/movable/target)
	. = ..()
	if(!.)
		return
	if(isitem(target))
		StoreItem(target)
		return TRUE
	return FALSE

/*---\
|SILO|
\---*/
/obj/machinery/factory_machine/silo
	name = "material silo"
	desc = "A container used to hold above average amounts of material \
		in a controlled enviorment."
	icon = 'ModularTegustation/Teguicons/lc13_structures_32x48.dmi'
	icon_state = "silo"
	storage_max = 80
	storage_type = null
	output_dir = SOUTH
	dropped_item = /obj/item/structureconstruction/silo
	var/output_amt = 3
	var/unloading = FALSE
	var/userface_color = COLOR_BUBBLEGUM_RED

/obj/machinery/factory_machine/silo/examine(mob/user)
	. = ..()
	. += "Wrench to open output. When the silo is empty you can input a new item type to change its storage. Screwdriver to adjust output amount and userface color."
	. += "Current Storage:[storage_type]|Storage Max:[storage_max]|Output Amt:[output_amt]|"

/obj/machinery/factory_machine/silo/InputItem(atom/movable/target)
	. = ..()
	//If no current storage and not unloading and target is a item change storage to that target
	if(!current_storage && !unloading)
		if(isitem(target))
			ChangeStorage(target.type)
			. = TRUE
	//If still false do not keep running.
	if(!.)
		return FALSE
	//Check type again but with the new type.
	if(!istype(target, storage_type))
		return FALSE
	StoreItem(target)

/obj/machinery/factory_machine/silo/OutputItem(atom/movable/product, direction)
	if(!current_storage)
		return
	current_storage -= 1
	update_icon()
	return ..()

/obj/machinery/factory_machine/silo/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		if(!unloading)
			Open()
		else
			Close()
		return
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/new_output_amt = input(user, "Adjust Max Output?", "Output Maxxed at 10") as num|null
		if(output_amt)
			output_amt = clamp(new_output_amt,1,10)
		var/list/new_color_list = list("NONE","white","black","grey","brown","red","darkred","crimson","orange","yellow","green","lime","darkgreen","cyan","blue","navy","teal","purple","indigo")
		var/new_color = input(user, "New Userface Color?", "Please Select from List") as text|anything in new_color_list
		if(new_color && new_color != "NONE")
			userface_color = color2hex(new_color)
			update_icon()
		return
	return ..()

/obj/machinery/factory_machine/silo/update_overlays()
	. = ..()
	if(unloading)
		. += "silo_overlayunloading"

/obj/machinery/factory_machine/silo/process(delta_time)
	. = ..()
	if(!.)
		return

	if(!storage_type)
		Close()
		return
	for(var/cycle = 1 to output_amt)
		var/I = new storage_type(src)
		OutputItem(I, output_dir)
		if(!current_storage)
			Close()
			break
	update_icon()

/obj/machinery/factory_machine/silo/FormatFillOverlay()
	var/fill_percent = (current_storage / storage_max) * 100
	var/fill_text
	switch(fill_percent)
		if(-INFINITY to 0)
			return
		if(1 to 19)
			fill_text = 0
		if(20 to 39)
			fill_text = 20
		if(40 to 59)
			fill_text = 40
		if(60 to 79)
			fill_text = 60
		if(80 to 99)
			fill_text = 80
		if(100 to INFINITY)
			fill_text = 100
	var/mutable_appearance/percent_overlay = mutable_appearance(icon, "silo_overlay[fill_text]")
	percent_overlay.color = userface_color
	. += percent_overlay

/obj/machinery/factory_machine/silo/proc/ChangeStorage(new_storage_type)
	if(current_storage)
		return FALSE
	storage_type = new_storage_type
	return TRUE

	//Made into a proc so that subtypes can override it.
/obj/machinery/factory_machine/silo/proc/Open()
	if(!storage_type)
		return
	unloading = TRUE
	begin_processing()
	update_icon()

/obj/machinery/factory_machine/silo/proc/Close()
	unloading = FALSE
	end_processing()
	update_icon()

/obj/machinery/factory_machine/silo/indestructable
	dropped_item = null
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/*--------\
|Artillery|
\--------*/
/obj/machinery/factory_machine/artillery
	name = "R corp Scrap Cannon"
	desc = "When interacted with a empty hand the cannon will rain a 3x3 damaging area of superheated Red Resource 2-9 tiles away from the machine. \
		Requires Red Resource as ammo, each shot deals damaged based on the amount of resources inside it. \
		Firing distance can be changed with a screwdriver. \
		\"Point away from face.\" "
	storage_max = 5
	output_delay = 5 SECONDS
	input_delay = 5
	icon_state = "cannon"
	wrench_rotatable = TRUE
	dropped_item = /obj/item/structureconstruction/artillery
	storage_type = /obj/item/factoryitem/red
	var/artillery_range = 6
	var/artillery_damage = 30

/obj/machinery/factory_machine/artillery/examine(mob/user)
	. = ..()
	. += "Currently has [current_storage] which will output [current_storage * artillery_damage] red damage."

/obj/machinery/factory_machine/artillery/FormatFillOverlay()
	var/fill_percent = (current_storage / storage_max) * 100
	var/fill_text
	switch(fill_percent)
		if(-INFINITY to 0)
			return
		if(1 to 24)
			fill_text = 10
		if(25 to 49)
			fill_text = 25
		if(50 to 74)
			fill_text = 50
		if(75 to 84)
			fill_text = 75
		if(85 to 99)
			fill_text = 85
		if(100 to INFINITY)
			fill_text = 100
	var/mutable_appearance/percent_overlay = mutable_appearance(icon, "cannon[fill_text]")
	. += percent_overlay

/obj/machinery/factory_machine/artillery/InputItem(atom/movable/target)
	. = ..()
	if(!.)
		return
	StoreItem(target)

/obj/machinery/factory_machine/artillery/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/new_range = input(user, "Adjust Distance of Impact? Must be between 2 and 9", "Adjust Exposion Distance") as num|null
		if(new_range)
			var/new_range_formatted = clamp(new_range,2,9)
			ChangeRange(new_range_formatted)
			to_chat(user, span_notice("The cannon now aims [new_range_formatted] tiles away!"))
		return
	return ..()

/obj/machinery/factory_machine/artillery/interact(mob/user)
	. = ..()
	if(output_cooldown > world.time)
		to_chat(user, span_warning("The cannon needs 5 seconds to cool off!"))
		return
	if(!current_storage)
		to_chat(user, span_warning("The cannon has nothing loaded!"))
		return
	var/turf/targeted_turf = get_ranged_target_turf(src, dir, artillery_range)
	if(!isturf(targeted_turf))
		return
	FireCannon(targeted_turf)
	output_cooldown = world.time + output_delay

/obj/machinery/factory_machine/artillery/proc/FireCannon(turf/target_turf)
	cut_overlays()
	sleep(1)
	flick("cannon_act", src)
	playsound(get_turf(src), 'sound/weapons/beam_sniper.ogg', 30, TRUE)
	var/total_damage = current_storage * artillery_damage
	/*
	* I unfortunately couldnt find a different method that worked.
	* I tried checking each turf but it made the proc not work sometimes.
	*/
	for(var/mob/living/L in range(1,target_turf))
		L.deal_damage(total_damage, RED_DAMAGE)
	for(var/obj/S in range(1,target_turf))
		S.take_damage(total_damage / 2, RED_DAMAGE)

	new /obj/effect/temp_visual/explosion/fast(target_turf)
	playsound(target_turf, 'sound/effects/explosion3.ogg', 30, TRUE)
	current_storage = 0
	return total_damage

/obj/machinery/factory_machine/artillery/proc/ChangeRange(number)
	artillery_range = number

/obj/machinery/factory_machine/artillery/preloaded
	current_storage = 5

/*------------\
|CROSS SECTION|
\------------*/
/obj/machinery/factory_machine/cross
	name = "conveyor cross section"
	desc = "A structure used to ensure material entering from the north arrives in the south,\
		 east arrives in the west, and vice versa."
	icon_state = "crosssection"
	dropped_item = /obj/item/structureconstruction/cross
	var/list/directional_storage = list()

/obj/machinery/factory_machine/cross/CanAllowThrough(atom/movable/mover, turf/target)
	var/direction = get_dir(target, src)
	if(StoreItem(mover, direction))
		return TRUE
	return ..()

/obj/machinery/factory_machine/cross/StoreItem(atom/movable/target, special_data)
	if(special_data in GLOB.cardinals)
		directional_storage += target
		directional_storage[target] = special_data
		begin_processing()
		return TRUE

/obj/machinery/factory_machine/cross/InputItem(atom/movable/target)
	return FALSE

/obj/machinery/factory_machine/cross/process(delta_time)
	. = ..()
	if(!.)
		return

	var/move_amt = 0
	for(var/obj/O in directional_storage)
		move_amt++
		if(!O)
			directional_storage -= O
			continue
		if(!directional_storage[O] || get_turf(O) != get_turf(src))
			directional_storage -= O
			continue
		OutputItem(O, directional_storage[O])
		if(move_amt > 10)
			break

	if(!LAZYLEN(directional_storage))
		end_processing()

/*-------\
|A TUNNEL|
\-------*/
/obj/machinery/factory_machine/tunnel
	name = "subterranian conveyor"
	desc = "entryway to a subterranian conveyor system"
	icon_state = "tunnel"
	output_delay = 3 SECONDS
	storage_max = 10
	wrench_rotatable = TRUE
	dropped_item = /obj/item/structureconstruction/tunnel
	var/obj/machinery/factory_machine/tunnel/linked_tunnel

/obj/machinery/factory_machine/tunnel/examine(mob/user)
	. = ..()
	. += "Takes 3 seconds to transport 10 items."

/obj/machinery/factory_machine/tunnel/Destroy()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(T)
	qdel(linked_tunnel)
	return ..()

/obj/machinery/factory_machine/tunnel/InputItem(atom/movable/target)
	. = ..()
	if(!.)
		return FALSE
	if(LAZYLEN(contents) > storage_max || !linked_tunnel)
		return FALSE
	StoreItem(target)
	return FALSE
	// Okay so if this returns true and the item is allowed to pass into the object it cannot be forcemoved into the object?

/obj/machinery/factory_machine/tunnel/StoreItem(atom/movable/target)
	target.forceMove(src)
	begin_processing()
	return TRUE

/obj/machinery/factory_machine/tunnel/process(delta_time)
	. = ..()
	if(!.)
		return

	var/move_amt = 0
	for(var/O in contents)
		move_amt++
		if(!O || O == src)
			continue
		dumpAtOutput(O)
		if(move_amt > 5)
			break

	if(!LAZYLEN(contents))
		end_processing()

/obj/machinery/factory_machine/tunnel/proc/dumpAtOutput(atom/AM)
	linked_tunnel.OutputItem(AM,linked_tunnel.dir)

/*--------------------\
|Resource Fed Machines|
\--------------------*/
/obj/machinery/factory_machine/fed_effect
	name = "fed machine root"
	desc = "."
	icon_state = ""
	storage_max = 60
	//Storage type for the regen is actually fuel
	storage_type = /obj/item/factoryitem/red
	//For quickly changing the icon state
	var/skin = "regen"
	var/fuel_value = 10

/obj/machinery/factory_machine/fed_effect/examine(mob/user)
	. = ..()
	if(current_storage)
		. += "Has [current_storage * (output_delay / (1 SECONDS))] seconds left of fuel."

/obj/machinery/factory_machine/fed_effect/update_icon_state()
	if(current_storage)
		icon_state = "[skin]_on"
		return
	icon_state = skin

/obj/machinery/factory_machine/fed_effect/process(delta_time)
	. = ..()
	if(!.)
		return

	//Do power effect.
	PowerEffect()
	update_icon()

	//If no fuel turn off.
	if(!current_storage)
		end_processing()
		return

	//Each fuel item gives 5 ticks
/obj/machinery/factory_machine/fed_effect/StoreItem(atom/movable/target)
	current_storage += fuel_value
	qdel(target)

/obj/machinery/factory_machine/fed_effect/InputItem(atom/movable/target)
	. = ..()
	if(!.)
		return
	if(istype(target, storage_type))
		StoreItem(target)
	//If we have any amount of fuel start processing.
	if(current_storage)
		begin_processing()
	return TRUE

/obj/machinery/factory_machine/fed_effect/proc/PowerEffect()
	current_storage -= 1
	return

/*--------------\
|Effect Machines|
\--------------*/
/obj/machinery/factory_machine/fed_effect/regen
	name = "Prototype R Gen"
	desc = "A machine made from reverse engineered L corp tech. \
		Occasionally heals an adjeacent individual if fed Red Resource. \
		A label on the side warns not to rely on the machine in life or death situations."
	icon_state = "regen"
	output_delay = 10
	//Storage type for the regen is actually fuel
	storage_type = /obj/item/factoryitem/red

/obj/machinery/factory_machine/fed_effect/regen/PowerEffect()
	. = ..()
	for(var/mob/living/carbon/patient in oview(get_turf(src), 1))
		//Find a patient
		if(patient)
			//If patient is in hard crit do not attempt to sew them together.
			if(patient.stat >= HARD_CRIT)
				continue
			//If patient is damaged then restore 10 health.
			if(patient.getBruteLoss())
				patient.adjustBruteLoss(-10)
				new /obj/effect/temp_visual/heal(get_turf(patient), "#FF4444")
				break

/*---------\
|Floodlight|
\---------*/
/obj/machinery/factory_machine/fed_effect/floodlight
	name = "R corp Floodlight"
	desc = "R corp brand floodlight. Will illuminate the area it is facing when fed Green Resource. \
		\"My everlasting light\" is engraved on the side."
	icon_state = "floodlight"
	wrench_rotatable = TRUE
	storage_type = /obj/item/factoryitem/green
	skin = "floodlight"
	light_range = 6
	light_power = 3
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	//I couldnt tell if using machine.stat would cause issues here.
	var/on = FALSE

/obj/machinery/factory_machine/fed_effect/floodlight/Initialize()
	. = ..()
	set_light_on(on)

/obj/machinery/factory_machine/fed_effect/floodlight/PowerEffect()
	. = ..()
	if(!on)
		set_light_on(TRUE)
		on = TRUE

/obj/machinery/factory_machine/fed_effect/floodlight/end_processing()
	if(on)
		set_light_on(FALSE)
		on = FALSE
	return ..()

#undef FACTORY_INPUT_HAND
#undef FACTORY_INPUT_CONVEYOR
