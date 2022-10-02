#define MEAT /obj/item/food/meat/slab/human

/obj/structure/corpse_eater
	name = "Femur eater 9000"
	desc = "This takes corpses and strenghens those who recive their gifts."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "smoke0"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	//thickness = 90000

	var/list/allowed_items = list(
		MEAT
	)

	var/list/to_process = list()

	var/processing_time_base = 20
	var/processing_timer
	var/processing = FALSE

