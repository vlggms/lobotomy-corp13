/mob/living/simple_animal/hostile/clan/engineer
	name = "Clan Engineer"
	desc = "A construction-specialized machine with building tools... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_citzen_1"
	icon_living = "clan_citzen_1"
	icon_dead = "clan_citzen_dead"
	health = 400
	maxHealth = 400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	attack_sound = 'sound/items/welder.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 2)
	melee_damage_lower = 5
	melee_damage_upper = 10
	robust_searching = TRUE
	stat_attack = CONSCIOUS
	vision_range = 8
	aggro_vision_range = 8
	move_to_delay = 3.5
	charge = 0
	max_charge = 5
	clan_charge_cooldown = 4 SECONDS
	teleport_away = TRUE
	search_objects = 3
	wanted_objects = list(/obj/structure/barricade/clan/blueprint, /obj/structure/clan_factory/blueprint)

	// Engineer specific vars
	var/can_build_factory = TRUE
	var/building = FALSE
	var/build_time = 5 SECONDS
	var/barricade_build_time = 2 SECONDS

/mob/living/simple_animal/hostile/clan/engineer/examine(mob/user)
	. = ..()
	if(commander)
		. += span_notice("Controlled by [commander].")
	if(can_build_factory)
		. += span_notice("Ready to construct a factory at a resource point.")

/mob/living/simple_animal/hostile/clan/engineer/AttackingTarget(atom/attacked_target)
	if(!attacked_target)
		attacked_target = target

	// Check if targeting a resource point to build factory
	if(istype(attacked_target, /obj/structure/resource_point) && can_build_factory && commander)
		StartFactoryConstruction(attacked_target)
		return
	
	// Check if targeting a construction point object
	if(can_build_factory && commander && isobj(attacked_target))
		var/obj/O = attacked_target
		// Check if our commander (who must be a tinkerer) recognizes this as a construction point
		if(istype(commander, /mob/living/simple_animal/hostile/clan/tinkerer))
			var/mob/living/simple_animal/hostile/clan/tinkerer/T = commander
			if(T.IsConstructionPoint(O))
				StartFactoryConstructionOnObject(O)
				return
	
	// Check if targeting a barricade blueprint
	if(istype(attacked_target, /obj/structure/barricade/clan/blueprint) && !building)
		BuildBarricade(attacked_target)
		return
	
	// Check if targeting a factory blueprint
	if(istype(attacked_target, /obj/structure/clan_factory/blueprint) && !building && commander)
		BuildFactoryFromBlueprint(attacked_target)
		return

	return ..()

/mob/living/simple_animal/hostile/clan/engineer/proc/StartFactoryConstruction(obj/structure/resource_point/R)
	if(!R || !can_build_factory || building || !commander)
		return

	// Check if there's already a factory here
	for(var/obj/structure/clan_factory/F in R.loc)
		to_chat(commander, span_warning("There is already a factory at this location!"))
		return

	building = TRUE
	can_build_factory = FALSE
	visible_message(span_notice("[src] begins constructing a factory..."))
	playsound(src, 'sound/items/welder2.ogg', 50, TRUE)

	if(do_after(src, build_time, target = R))
		var/obj/structure/clan_factory/F = new(R.loc)
		F.owner = commander
		commander.owned_factories += F
		visible_message(span_notice("[src] completes the factory construction!"))
		playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	else
		visible_message(span_warning("[src] fails to complete the construction."))
		can_build_factory = TRUE

	building = FALSE

/mob/living/simple_animal/hostile/clan/engineer/proc/StartFactoryConstructionOnObject(obj/O)
	if(!O || !can_build_factory || building || !commander)
		return

	var/turf/T = get_turf(O)
	if(!T)
		return

	// Check if there's already a factory here
	for(var/obj/structure/clan_factory/F in T)
		to_chat(commander, span_warning("There is already a factory at this location!"))
		return

	building = TRUE
	can_build_factory = FALSE
	visible_message(span_notice("[src] begins constructing a factory on [O]..."))
	playsound(src, 'sound/items/welder2.ogg', 50, TRUE)

	if(do_after(src, build_time, target = O))
		var/obj/structure/clan_factory/F = new(T)
		F.owner = commander
		commander.owned_factories += F
		visible_message(span_notice("[src] completes the factory construction on [O]!"))
		playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
		// Delete the construction point object
		qdel(O)
	else
		visible_message(span_warning("[src] fails to complete the construction."))
		can_build_factory = TRUE

	building = FALSE

/mob/living/simple_animal/hostile/clan/engineer/proc/BuildBarricade(obj/structure/barricade/clan/blueprint/B)
	if(!B || building || B.loc == null)
		return
	
	building = TRUE
	visible_message(span_notice("[src] begins constructing a barricade..."))
	playsound(src, 'sound/items/welder.ogg', 50, TRUE)
	
	if(do_after(src, barricade_build_time, target = B))
		if(!QDELETED(B) && B.loc)
			new /obj/structure/barricade/clan(B.loc)
			qdel(B)
			visible_message(span_notice("[src] completes the barricade construction!"))
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	else
		visible_message(span_warning("[src] fails to complete the barricade construction."))
	
	building = FALSE

/mob/living/simple_animal/hostile/clan/engineer/proc/BuildFactoryFromBlueprint(obj/structure/clan_factory/blueprint/B)
	if(!B || building || B.loc == null || !commander)
		return
	
	// Check if this engineer can build factories
	if(!can_build_factory)
		visible_message(span_warning("[src] has already built a factory and cannot build another!"))
		return
	
	building = TRUE
	can_build_factory = FALSE
	visible_message(span_notice("[src] begins constructing a factory from the blueprint..."))
	playsound(src, 'sound/items/welder2.ogg', 50, TRUE)
	
	if(do_after(src, B.build_time, target = B))
		if(!QDELETED(B) && B.loc)
			var/obj/structure/clan_factory/F = new(B.loc)
			F.owner = commander
			if(istype(commander, /mob/living/simple_animal/hostile/clan/tinkerer))
				var/mob/living/simple_animal/hostile/clan/tinkerer/T = commander
				T.owned_factories += F
			qdel(B)
			visible_message(span_notice("[src] completes the factory construction!"))
			playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	else
		visible_message(span_warning("[src] fails to complete the factory construction."))
		can_build_factory = TRUE
	
	building = FALSE

// Override to handle attack orders on construction points
/mob/living/simple_animal/hostile/clan/engineer/ReceiveAttackOrder(atom/target, is_hard_lock = FALSE)
	// Check if we're ordered to attack a construction point
	if(can_build_factory && commander && isobj(target))
		var/obj/O = target
		// Check if our commander recognizes this as a construction point
		if(istype(commander, /mob/living/simple_animal/hostile/clan/tinkerer))
			var/mob/living/simple_animal/hostile/clan/tinkerer/T = commander
			if(T.IsConstructionPoint(O))
				// Add it to our wanted objects temporarily
				if(!wanted_objects)
					wanted_objects = list()
				wanted_objects += O.type
				addtimer(CALLBACK(src, PROC_REF(RemoveWantedObject), O.type), 30 SECONDS)
				// Enable object searching
				search_objects = 3
	
	// Call parent to handle the rest
	return ..()

// Resource point structure
/obj/structure/resource_point
	name = "Resource Point"
	desc = "A strategic location suitable for construction."
	icon = 'icons/obj/structures.dmi'
	icon_state = "x4"
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	alpha = 128
