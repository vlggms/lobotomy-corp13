/* Fishing Boats for traversing deep water turf without sinking.
	Depends on the fishing deep water turfs code,
	riding_vehicle.dm, and lavaboat.dm. */

/datum/crafting_recipe/simple_boat
	name = "One Person Boat"
	result = /obj/vehicle/ridden/simple_boat
	reqs = list(/obj/item/stack/sheet/mineral/wood = 250)
	time = 50
	category = CAT_MISC
/* Honestly later on if we need boats for a larger amount of people we may have to go
	the same method that final fantasy games did and just have several people be able
	to sit in a 1 tile 48 or 64 pixel sized boat. -IP */
/obj/vehicle/ridden/simple_boat
	name = "dinghy"
	desc = "A one person boat for traversing the waters. Can be renamed with a pen. May require an oar to be installed into it for sailing."
	icon_state = "goliath_boat"
	icon = 'icons/obj/lavaland/dragonboat.dmi'
	//Set this and the component keytype to null to make it not require a key.
	key_type = /obj/item/boat_oar
	can_buckle = TRUE
	//People can rename it with a pen when it has this.
	obj_flags = UNIQUE_RENAME
	/* This variable is apparently used for a typecache on what
		types the boat can sail on. So all subtypes of water? -IP */
	var/allowed_turf = /turf/open/water

/obj/vehicle/ridden/simple_boat/Initialize()
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/lavaboat/simple_boat)

//Code Stolen from riding_vehicle.dm
/datum/component/riding/vehicle/lavaboat/simple_boat
	//Remove keytype from this and the simple boat to make it not require anything to move.
	keytype = /obj/item/boat_oar
	allowed_turf = /turf/open/water

//Stolen from lavalandboat.dm
/obj/item/boat_oar
	name = "dinghy oar"
	desc = "Used for sailing one person boats. Can be dissasembled back into wood using a knife."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "oar"
	inhand_icon_state = "oar"
	lefthand_file = 'icons/mob/inhands/misc/lavaland_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/lavaland_righthand.dmi'
	force = 12
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/boat_oar/attackby(obj/item/attacking_item, mob/user, params)
	var/sharpthing = attacking_item.get_sharpness()
	if(sharpthing == SHARP_EDGED && attacking_item.force >= 5)
		new /obj/item/stack/sheet/mineral/wood(get_turf(src))
		return qdel(src)
	return ..()

/datum/crafting_recipe/boat_oar
	name = "Boat Oar"
	result = /obj/item/boat_oar
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	time = 15
	category = CAT_MISC
