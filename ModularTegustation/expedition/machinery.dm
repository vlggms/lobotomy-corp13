/*
* WARNING THIS CODE IS VERY SLOPPY AND UNOPTIMIZED -IP
*/

/obj/machinery/factory_machine
	name = "factory prototype"
	icon = 'ModularTegustation/Teguicons/expedition_32x32.dmi'
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	processing_flags = START_PROCESSING_MANUALLY
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
	var/output_delay = 15
	//Item dropped by machine when crowbarred. If null will not be crowbarable.
	var/dropped_item
	//Materials inputted list. Useful for refining or crafting machines.
	var/list/materials = list()

//Do not allow items to pass unless InputItem returns True
/obj/machinery/factory_machine/CanAllowThrough(atom/movable/mover, turf/target)
	if(InputItem(mover))
		return TRUE
	return ..()

//If attacked with a item assume we are being fed it as a resource
/obj/machinery/factory_machine/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_CROWBAR && dropped_item)
		Dissasemble(user, I)
		return
	if(InputItem(I))
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
/obj/machinery/factory_machine/proc/InputItem(atom/movable/target)
	. = TRUE
	if(QDELETED(target))
		return FALSE
	if(!isobj(target))
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
	if(!isnum(materials[target.type]))
		materials += target.type
		materials[target.type] = 0
	materials[target.type] += 1
	qdel(target)

/*----\
|REGEN|
\----*/
/obj/machinery/factory_machine/regen
	name = "Prototype R Gen"
	desc = "A machine made from reverse engineered L corp tech. \
		Occasionally heals an adjeacent individual if fed compressed carbon. \
		A label on the side warns not to rely on the machine in life or death situations."
	icon_state = "regen"
	storage_max = 70
	output_delay = 20
	//Storage type for the regen is actually fuel
	storage_type = /obj/item/comp_carbon

	//Each fuel item gives 5 ticks
/obj/machinery/factory_machine/regen/StoreItem(atom/movable/target)
	current_storage += 4
	qdel(target)

/obj/machinery/factory_machine/regen/InputItem(atom/movable/target)
	. = ..()
	if(!.)
		return
	if(!isitem(target))
		return FALSE
	//If not storage type, do not let pass.
	if(storage_type)
		if(!istype(target, storage_type))
			return FALSE

	if(current_storage < storage_max)
		StoreItem(target)
	else
		return FALSE
	//If we have any amount of fuel start processing.
	if(current_storage)
		begin_processing()
	return TRUE

/obj/machinery/factory_machine/regen/process(delta_time)
	//Remove one fuel
	current_storage -= 1
	. = ..()
	if(!.)
		return

	//Do power effect.
	PowerEffect()
	update_icon()

	//If no fuel turn off.
	if(!current_storage)
		end_processing()

/obj/machinery/factory_machine/regen/update_icon_state()
	if(current_storage)
		icon_state = "regen_on"
		return
	icon_state = "regen"

/obj/machinery/factory_machine/regen/proc/PowerEffect()
	for(var/mob/living/carbon/patient in view(1, get_turf(src)))
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

/*---\
|SILO|
\---*/
/obj/machinery/factory_machine/silo
	name = "material silo"
	desc = "A container used to hold above average amounts of material \
		in a controlled enviorment."
	icon = 'ModularTegustation/Teguicons/lc13_structures_32x48.dmi'
	icon_state = "silo"
	storage_max = 70
	storage_type = null
	output_dir = SOUTH
	var/output_amt = 3
	var/unloading = FALSE
	var/userface_color = COLOR_BUBBLEGUM_RED

/obj/machinery/factory_machine/silo/examine(mob/user)
	. = ..()
	. += "Wrench to open output. When the silo is empty you can input a new item type to change its storage. Screwdriver to adjust output amount and userface color."
	. += "Current Storage:[storage_type]|Storage Max:[storage_max]|Output Amt:[output_amt]|"

/obj/machinery/factory_machine/silo/StoreItem(atom/movable/target)
	current_storage += 1
	update_icon()
	qdel(target)

/obj/machinery/factory_machine/silo/InputItem(atom/movable/target)
	. = ..()
	if(!.)
		return
	//If no current storage and not unloading and target is a item change storage to that target
	if(!current_storage && !unloading)
		if(isitem(target))
			ChangeStorage(target.type)
	//If type matches storage type and not at max storage, store item.
	if(istype(target, storage_type) && current_storage < storage_max)
		StoreItem(target)
		return TRUE
	return FALSE

/obj/machinery/factory_machine/silo/OutputItem(atom/movable/product, direction)
	if(!current_storage)
		return
	current_storage -= 1
	update_icon()
	return ..()

/obj/machinery/factory_machine/silo/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		if(!unloading)
			Unload()
		else
			unloading = FALSE
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
	. += FormatFillOverlay()
	if(unloading)
		. += "silo_overlayunloading"

/obj/machinery/factory_machine/silo/process(delta_time)
	. = ..()
	if(!.)
		return

	if(!storage_type || !unloading)
		unloading = FALSE
		end_processing()
		return
	for(var/cycle = 1 to output_amt)
		var/I = new storage_type(src)
		OutputItem(I, output_dir)
		if(!current_storage)
			unloading = FALSE
			end_processing()
			break
	update_icon()

/obj/machinery/factory_machine/silo/proc/ChangeStorage(new_storage_type)
	if(current_storage)
		return FALSE
	storage_type = new_storage_type
	return TRUE

	//Made into a proc so that subtypes can override it.
/obj/machinery/factory_machine/silo/proc/Unload()
	if(!storage_type)
		return
	unloading = TRUE
	begin_processing()

/obj/machinery/factory_machine/silo/proc/FormatFillOverlay()
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

/*------------\
|CROSS SECTION|
\------------*/
/obj/machinery/factory_machine/cross
	name = "conveyor cross section"
	desc = "A structure used to ensure material entering from the north arrives in the south,\
		 while material entering from the east arrives in the west."
	icon_state = "crosssection"
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
/obj/machinery/factory_machine/a_tunnel
	name = "subterranian conveyor"
	desc = "entryway to a subterranian conveyor system"
	icon_state = "tunnel"
	output_delay = 3 SECONDS
	dropped_item = /obj/item/tunnel_deployer
	var/obj/machinery/factory_machine/a_tunnel/linked_tunnel

/obj/machinery/factory_machine/a_tunnel/examine(mob/user)
	. = ..()
	. += "Takes 3 seconds to transport 10 items."

/obj/machinery/factory_machine/a_tunnel/Destroy()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(T)
	qdel(linked_tunnel)
	return ..()

/obj/machinery/factory_machine/a_tunnel/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		if(!(machine_stat & BROKEN))
			I.play_tool_sound(src)
			setDir(turn(dir,-90))
			to_chat(user, "<span class='notice'>You rotate [src].</span>")
			return
	return ..()

/obj/machinery/factory_machine/a_tunnel/InputItem(atom/movable/target)
	. = ..()
	if(!.)
		return FALSE
	if(LAZYLEN(contents) > 10 || !linked_tunnel)
		return FALSE
	StoreItem(target)
	return FALSE
	// Okay so if this returns true and the item is allowed to pass into the object it cannot be forcemoved into the object?

/obj/machinery/factory_machine/a_tunnel/StoreItem(atom/movable/target)
	target.forceMove(src)
	begin_processing()
	return TRUE

/obj/machinery/factory_machine/a_tunnel/process(delta_time)
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

/obj/machinery/factory_machine/a_tunnel/proc/dumpAtOutput(atom/AM)
	linked_tunnel.OutputItem(AM,linked_tunnel.dir)
