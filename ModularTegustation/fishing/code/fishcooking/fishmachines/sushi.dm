//The Sushi Mat
/obj/structure/sushimat
	name = "sushi mat"
	desc = "A mat to cut and clean fish."
	icon = 'ModularTegustation/fishing/icons/fishmachines.dmi'
	icon_state = "sushi"
	anchored = TRUE
	var/list/cookables = list(
		/obj/item/food/freshfish/white 						= /obj/item/food/sashimi/white,
		/obj/item/food/fish/salt_water/salmon 				= /obj/item/food/sashimi,
		/obj/item/food/fish/fresh_water/salmon 				= /obj/item/food/sashimi,
		/obj/item/food/fish/salt_water/marine_shrimp 		= /obj/item/food/sashimi/shrimp,
		)
	var/failed = FALSE

/obj/structure/sushimat/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	var/atom/item_out = cookables[I.type]
	if(!(I.type in cookables))
		item_out = /obj/item/food/freshfish/slime
	else
		item_out = cookables[I.type]
	to_chat(user, span_notice("You begin chopping the [I] "))
	if(!do_after(user, 7 SECONDS))
		return

	qdel(I)
	var/atom/new_item = new item_out(get_turf(user))
	user.put_in_hands(new_item)
	to_chat(user, span_nicegreen("You finish your prep!"))
