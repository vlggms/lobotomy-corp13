/obj/structure/toolabnormality/shelter
	name = "shelter from the 27th of March"
	desc = "The safest place on earth."
	can_buckle = TRUE
	max_buckled_mobs = 1
	var/obj/structure/toolabnormality/shelter/linked_structure

/obj/structure/toolabnormality/shelter/proc/travel(mob/living/carbon/human/user)
	if(!linked_structure)	//Here we do nothing, just set it up for the substypes
		return
	var/turf/T = get_turf(linked_structure)
	var/atom/movable/AM
	if(user.pulling)
		AM = user.pulling
		if(ishuman(AM)) //We don't want players dragging the supplies in and out
			var/mob/living/carbon/human/Person = AM
			for(var/obj/item/storage/box/pcorp/foodbox in Person.GetAllContents())
				Person.dropItemToGround(foodbox, TRUE)
			for(var/obj/item/food/canned/pcorp/foodcan in Person.GetAllContents())
				Person.dropItemToGround(foodcan, TRUE)
			AM.forceMove(T)
		else
			user.stop_pulling()
	user.forceMove(T)
	if(AM)
		user.start_pulling(AM)

/obj/structure/toolabnormality/shelter/attack_hand(mob/living/carbon/human/user)
	travel_check(user)
	return

/obj/structure/toolabnormality/shelter/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("It doesn't look like I can't quite fit in."))
		return FALSE // Can only extract from humans.

	if(M != user)
		to_chat(user, span_warning("It's hard enough to get into the shelter on your own!"))
		return FALSE
	travel_check(M)
	return

/obj/structure/toolabnormality/shelter/proc/travel_check(mob/living/carbon/human/user)
	icon_state = "shelter_in_opening"
	if(!do_after(user, 30 SECONDS, user))
		to_chat(user, span_notice("You decide not to enter [src]."))
		icon_state = "shelter_in"
		return
	to_chat(user, span_warning("You open the hatch and climb inside."))
	travel(user)
	icon_state = "shelter_in"

/obj/structure/toolabnormality/shelter/entrance
	icon_state = "shelter_in"

/obj/structure/toolabnormality/shelter/entrance/travel(mob/living/carbon/human/user)
	if(!linked_structure)
		linked_structure = locate(/obj/structure/toolabnormality/shelter/exit) in world.contents
	playsound(src, 'sound/abnormalities/shelter/open.ogg', 80, TRUE, -3)
	..()

/obj/structure/toolabnormality/shelter/exit
	name = "exit"
	desc = "Probably doesn't lead to the safest place on earth."
	icon_state = "shelter_out"

/obj/structure/toolabnormality/shelter/exit/travel_check(mob/living/carbon/human/user)
	if(!do_after(user, 3 SECONDS, user))
		to_chat(user, span_notice("You decide it's safer in the shelter."))
		return
	to_chat(user, span_warning("You open the hatch and climb out."))
	for(var/obj/item/storage/box/pcorp/foodbox in user.GetAllContents())
		user.dropItemToGround(foodbox, TRUE)
	for(var/obj/item/food/canned/pcorp/foodcan in user.GetAllContents())
		user.dropItemToGround(foodcan, TRUE)
	travel(user)

/obj/structure/toolabnormality/shelter/exit/travel(mob/living/carbon/human/user)
	if(!linked_structure)
		linked_structure = locate(/obj/structure/toolabnormality/shelter/entrance) in world.contents
	..()
	user.Stun(15 SECONDS)
	to_chat(user, span_userdanger("You are suddenly overcome with fear and hesitation! What horrors could be lurking out here?"))

// Shelter contents
// Crate
/obj/structure/closet/crate/pcorp/shelter //Lots of storage but not normally accessible
	name = "P-Corp crate"
	desc = "A dark steel crate emblazoned with the symbol of P corp."
	storage_capacity = 10

// Food Box
/obj/item/storage/box/pcorp
	name = "box of p-corp canned rations"
	desc = "<B>Instructions:</B> <I>Open and serve immediately.</I>"
	icon_state = "pcorp_box"
	illustration=null
	var/foodtype = /obj/item/food/canned/pcorp

/obj/item/storage/box/pcorp/PopulateContents()
	for(var/i in 1 to 6)
		new foodtype(src)

/obj/item/storage/box/pcorp/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.set_holdable(list(/obj/item/food/canned/pcorp))

// Food
/obj/item/food/canned/pcorp
	name = "p-corp canned bread"
	desc = "P corp's specialty canned bread."
	icon_state = "pcorp_can"
	trash_type = /obj/item/trash/can/food/pcorp
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 9)
	tastes = list("waffles" = 7, "dough" = 2, "buttery sweetness" = 1)
	foodtypes = GRAIN

// Food Trash
/obj/item/trash/can/food/pcorp
	name = "canned bread"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "pcorp_can_empty"

// Tiles
/turf/open/floor/shelter
	name = "shelter floor"
	desc = "Extremely sturdy."
	icon_state = "engine"
	holodeck_compatible = TRUE
	thermal_conductivity = 0.025
	heat_capacity = INFINITY
	floor_tile = /obj/item/stack/rods
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/shelter/break_tile()
	return //unbreakable

/turf/open/floor/shelter/burn_tile()
	return //unburnable

/turf/open/floor/shelter/make_plating(force = FALSE)
	if(force)
		return ..()
	return //unplateable

/obj/effect/shelter_forcefield
	name = "forcefield"
	desc = "Keeps monsters out."
	icon = 'icons/turf/floors.dmi'
	icon_state = "transparent"
	layer = TURF_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/shelter_forcefield/Crossed(atom/movable/M)
	. = ..()
	if(!ishostile(M)) // kick out any hostile mobs
		return
	var/mob/living/simple_animal/hostile/G = M
	if("neutral" in G.faction) //This should prevent an exploit with clerkbots and any other friendly summon teleporting
		return
	var/list/potential_locs = shuffle(GLOB.department_centers)
	var/turf/T = pick(potential_locs)
	M.forceMove(T) //send them to brazil
