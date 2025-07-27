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

	// Engineer specific vars
	var/can_build_factory = TRUE
	var/building = FALSE
	var/build_time = 5 SECONDS

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
