/* FISHING ROD */

/obj/item/fishing_rod/debug
	name = "Debug fishing rod"
	desc = "A tool used to dredge up aquatic entities. Though this pole seems incredibly strong... and is that a diesel engine on it?"
	speed_override = 0.1 SECONDS
	w_class = WEIGHT_CLASS_TINY

/obj/item/fishing_rod/debug/examine(mob/user)
	. = ..()
	. += span_notice("you can click on this rod to set how fast it fishes, right now its [speed_override * 0.1] seconds.")

/obj/item/fishing_rod/debug/attack_self(mob/user, datum/source)
	speed_override = input(user, "How fast do you wish to fish in seconds?", "debug fishing speed") as num|null
	speed_override *= 10
	return	..()

/* FISHING BAG */

/obj/item/storage/bag/fish/debug
	name = "debug fish bag"
	desc = "A weird plastic bag that holds a pocket dimension, capable of holding a lot of fish."
	w_class = WEIGHT_CLASS_TINY

/obj/item/storage/bag/fish/debug/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 1000000
	STR.max_items = 1000000

/* FISHING WATER SPAWNER */

/obj/item/water_turf_spawner
	name = "debug water turf spawner"
	desc = "A device that is capable of spawning water anywhere, how convinient!"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "teleporter"
	w_class = WEIGHT_CLASS_TINY
	var/turf_type = /turf/open/water/deep/freshwater
	var/transform_string = "fresh water"
	var/reset_turf_type = /turf/open/floor/plating/asteroid/basalt
	var/reset_string = "literal fucking rock"

/obj/item/water_turf_spawner/afterattack(atom/target, mob/user, click_parameters)
	. = ..()
	var/turf/T = get_turf(target)
	if(!istype(T))
		return
	var/old_name = T.name
	if(!istype(T, turf_type))
		if(T.TerraformTurf(turf_type, flags = CHANGETURF_INHERIT_AIR))
			user.visible_message(span_danger("[user] turns \the [old_name] into [transform_string]!"))
			playsound(T, 'sound/machines/terminal_processing.ogg', 20, TRUE)
	else
		if(T.TerraformTurf(reset_turf_type, flags = CHANGETURF_INHERIT_AIR))
			user.visible_message(span_danger("[user] turns \the [old_name] into [reset_string]!"))
			playsound(T, 'sound/machines/terminal_processing.ogg', 20, TRUE)
