
/*------------\
|Raw Resources|
\------------*/
/obj/item/lignite
	name = "lignite coal"
	desc = "A low grade form of coal that is usually formed by peat bogs."
	icon = 'icons/obj/mining.dmi'
	icon_state = "slag"
	grind_results = list(/datum/reagent/carbon = 20)

/obj/item/comp_carbon
	name = "compressed carbon"
	desc = "Self explanitory."
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore"
	grind_results = list(/datum/reagent/carbon = 35)

/*-------------\
|Item Machinery|
\-------------*/
/obj/item/tunnel_deployer
	name = "tunnel deployer"
	desc = "A device for constructing subterranian conveyor belt tunnels. Attack turf to place a tunnel mark. Use in hand to finalize. Tunnels must be within 5 tiles  and in a direct line of eachother."
	icon = 'ModularTegustation/Teguicons/expedition_32x32.dmi'
	icon_state = "tunneler"
	var/step_level = 1
	var/step_cooldown = 0
	var/obj/effect/temp_visual/simple_constructing_effect/step_one_tunnel
	var/obj/effect/temp_visual/simple_constructing_effect/step_two_tunnel

/obj/item/tunnel_deployer/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity || user.stat || !isfloorturf(A) || istype(A, /area/shuttle))
		return
	if(A == user.loc)
		to_chat(user, span_warning("You cannot place a tunnel under yourself!"))
		return
	if(locate(/obj/machinery/factory_machine) in range(1, get_turf(src)))
		to_chat(user, span_warning("Too close to another factory machine!"))
		return
	PlaceTunnelPlan(A)

/obj/item/tunnel_deployer/attack_self(mob/user)
	if(!step_one_tunnel || !step_two_tunnel)
		to_chat(user, span_warning("Tunnel mark missing, use item on turf to deploy tunnel!"))
		return
	var/tunnel_distence = get_dist(step_one_tunnel, step_two_tunnel)
	if(tunnel_distence > 5 || tunnel_distence < 1)
		to_chat(user, span_warning("Tunnel length is more than 5 or less than 1 tiles!"))
		return
	var/tunnel_direction = get_dir(step_one_tunnel, step_two_tunnel)
	if(!(tunnel_direction in GLOB.cardinals))
		to_chat(user, span_warning("Tunnel is not a direct line!"))
		return
	LinkTunnels()

/obj/item/tunnel_deployer/proc/PlaceTunnelPlan(turf/plan_turf)
	switch(step_level)
		if(1)
			if(step_one_tunnel)
				step_one_tunnel.end()
			step_one_tunnel = new /obj/effect/temp_visual/simple_constructing_effect(plan_turf)
			step_level = 2
			return
		if(2)
			if(step_two_tunnel)
				step_two_tunnel.end()
			step_two_tunnel = new /obj/effect/temp_visual/simple_constructing_effect(plan_turf)
			step_level = 1
			return

/obj/item/tunnel_deployer/proc/LinkTunnels()
	var/obj/machinery/factory_machine/a_tunnel/C = new/obj/machinery/factory_machine/a_tunnel(get_turf(step_one_tunnel))
	var/obj/machinery/factory_machine/a_tunnel/B = new/obj/machinery/factory_machine/a_tunnel(get_turf(step_two_tunnel))
	step_one_tunnel.end()
	step_two_tunnel.end()
	C.linked_tunnel = B
	B.linked_tunnel = C
	qdel(src)
