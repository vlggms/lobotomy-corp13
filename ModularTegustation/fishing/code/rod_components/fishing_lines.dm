
/**
 *
 * Modular file containing: fishing reels
 * fishing reels can be put on a rod to enhance its fishing value
 *
 */

/obj/item/fishing_component/line
	name = "fishing line reel"
	desc = "Simple fishing line."
	icon = 'ModularTegustation/fishing/icons/fishing_lines.dmi'
	icon_state = "blue"
	var/line_color = "#808080"

/obj/item/fishing_component/line/sinew
	name = "fishing sinew line"
	desc = "An all-natural fishing line made of stretched out sinew."
	icon_state = "sinew"
	fishing_value = 0.3
	line_color = "#d1cca3"

/datum/crafting_recipe/sinew_line
	name = "Sinew Fishing Line Reel"
	result = /obj/item/fishing_component/line/sinew
	reqs = list(/obj/item/stack/sheet/sinew = 2)
	time = 2 SECONDS
	category = CAT_MISC

/obj/item/fishing_component/line/reinforced
	name = "reinforced fishing line reel"
	desc = "Essential for fishing in extreme environments."
	icon_state = "green"
	fishing_value = 0.4
	line_color = "#2b9c2b"
