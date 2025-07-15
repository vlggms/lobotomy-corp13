/*------------ -\
|Item Machinery |
\------------ -*/
/obj/item/structureconstruction
	name = "structure deployer"
	icon = 'ModularTegustation/Teguicons/expedition_32x32.dmi'
	icon_state = "constructor_default"
	var/step_level = 1
	var/structure_type
	var/obj/effect/temp_visual/simple_constructing_effect/construction_zone_one
	var/obj/effect/temp_visual/simple_constructing_effect/construction_zone_two

/obj/item/structureconstruction/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(StructurePlacementReq(A, user, proximity))
		OverridableConstruction(A, user)

//Overridable Proc
/obj/item/structureconstruction/proc/StructurePlacementReq(atom/A, mob/user, proximity)
	. = TRUE
	if(!proximity || user.stat || !isfloorturf(A) || istype(A, /area/shuttle))
		return FALSE
	if(A == user.loc)
		to_chat(user, span_warning("You cannot place a structure under yourself!"))
		return FALSE
	var/area_check_fail = FALSE
	for(var/obj/O in range(1, A))
		if(istype(O, /obj/machinery/factory_machine) || istype(O, /obj/structure/resourcepoint))
			area_check_fail = TRUE
			break
	if(area_check_fail)
		to_chat(user, span_warning("Too close to another factory machine or resource well!"))
		return FALSE

/obj/item/structureconstruction/proc/OverridableConstruction(atom/A, mob/user)
	if(structure_type)
		new structure_type(A)
		qdel(src)
		return TRUE

/*-------------\
|Cross Conveyor|
\-------------*/
/obj/item/structureconstruction/cross
	name = "cross conveyor deployer"
	structure_type = /obj/machinery/factory_machine/cross
	//Placeholder until i make actual sprites
	color = COLOR_RED

/*---\
|Silo|
\---*/
/obj/item/structureconstruction/silo
	name = "silo deployer"
	desc = "Deploys a silo for storing items on mass."
	structure_type = /obj/machinery/factory_machine/silo
	//Placeholder until i make actual sprites
	color = COLOR_BLUE
/*----\
|Regen|
\----*/
/obj/item/structureconstruction/regen
	name = "regen deployer"
	desc = "Deploys a R corp brand regenerator that heals one person adjacent to it. Fueled by Red Resource."
	structure_type = /obj/machinery/factory_machine/fed_effect/regen
	//Placeholder until i make actual sprites
	color = COLOR_GREEN

/*---------\
|Floodlight|
\---------*/
/obj/item/structureconstruction/floodlight
	name = "floodlight deployer"
	desc = "Deploys a floodlight that produces a large area of light. Fueled by Green Resource"
	icon_state = "constructor_floodlight"
	structure_type = /obj/machinery/factory_machine/fed_effect/floodlight

/*--------\
|Artillery|
\--------*/
/obj/item/structureconstruction/artillery
	name = "cannon deployer"
	desc = "Deploys a artillery cannon that fires 6 tiles away from where its facing. Fueled by Red Resource"
	icon_state = "constructor_cannon"
	structure_type = /obj/machinery/factory_machine/artillery

/*--------------\
|Tunnel Deployer|
\--------------*/
/obj/item/structureconstruction/tunnel
	name = "tunnel deployer"
	desc = "A device for constructing subterranian conveyor belt tunnels. \
		It looks like someone tapped a small shovel to a bunch of metal. \
		Attack turf to place a tunnel mark. Use in hand to finalize. \
		Tunnels must be within 5 tiles  and in a direct line of eachother."
	icon_state = "tunneler"

/obj/item/structureconstruction/tunnel/attack_self(mob/user)
	if(!construction_zone_one || !construction_zone_two)
		to_chat(user, span_warning("Tunnel mark missing, use item on turf to deploy tunnel!"))
		return
	var/tunnel_distence = get_dist(construction_zone_one, construction_zone_two)
	if(tunnel_distence > 5 || tunnel_distence < 1)
		to_chat(user, span_warning("Tunnel length is more than 5 or less than 1 tiles!"))
		return
	var/tunnel_direction = get_dir(construction_zone_one, construction_zone_two)
	if(!(tunnel_direction in GLOB.cardinals))
		to_chat(user, span_warning("Tunnel is not a direct line!"))
		return
	LinkTunnels()

/obj/item/structureconstruction/tunnel/OverridableConstruction(atom/A, mob/user)
	var/turf/plan_turf = A
	switch(step_level)
		if(1)
			if(construction_zone_one)
				construction_zone_one.end()
			construction_zone_one = new /obj/effect/temp_visual/simple_constructing_effect(plan_turf)
			step_level = 2
			return
		if(2)
			if(construction_zone_two)
				construction_zone_two.end()
			construction_zone_two = new /obj/effect/temp_visual/simple_constructing_effect(plan_turf)
			step_level = 1
			return

/obj/item/structureconstruction/tunnel/proc/LinkTunnels()
	var/obj/machinery/factory_machine/tunnel/C = new(get_turf(construction_zone_one))
	var/obj/machinery/factory_machine/tunnel/B = new(get_turf(construction_zone_two))
	construction_zone_one.end()
	construction_zone_two.end()
	C.linked_tunnel = B
	B.linked_tunnel = C
	qdel(src)
