//Generic fish cooker
/obj/structure/fishcooker
	name = "fish cooker"
	desc = "A machine to cook fish. You shouldn't see this."
	icon = 'ModularTegustation/fishing/icons/fishmachines.dmi'
	icon_state = "sushi"
	anchored = TRUE
	density = TRUE
	var/list/cookables = list(
		/obj/item/food/freshfish/white 			= /obj/item/food/sashimi/white,
		/obj/item/food/freshfish/salmon 		= /obj/item/food/sashimi,
		/obj/item/food/fish/salt_water/marine_shrimp 		= /obj/item/food/sashimi,
		)
	var/failed = FALSE
	var/cook_time = 12 SECONDS
	var/on_icon = "sushi"
	var/busy

/obj/structure/fishcooker/attackby(obj/item/I, mob/living/carbon/human/user)
	if(busy)
		to_chat(user, span_warning("This machine is busy."))
		return
	var/atom/item_out = cookables[I.type]
	if(!(I.type in cookables))
		item_out = /obj/item/food/freshfish/slime
	else
		item_out = cookables[I.type]

	to_chat(user, span_notice("You insert the [I]."))
	addtimer(CALLBACK(src, PROC_REF(finish_cook), item_out), cook_time)
	icon_state = on_icon
	busy = TRUE
	qdel(I)

/obj/structure/fishcooker/proc/finish_cook(obj/item/I)
	new I(get_turf(src))
	icon_state = initial(icon_state)
	busy = FALSE

