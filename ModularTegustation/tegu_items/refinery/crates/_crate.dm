/obj/structure/lootcrate
	name = "Crate"
	desc = "A crate recieved from a company"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "crate_lcb"
	anchored = FALSE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/lootlist =	list(
		/obj/item/toy/plush/blank,
		/obj/item/toy/plush/yisang,
		/obj/item/toy/plush/faust,
		/obj/item/toy/plush/don,
		/obj/item/toy/plush/ryoshu,
		/obj/item/toy/plush/meursault,
		/obj/item/toy/plush/honglu,
		/obj/item/toy/plush/heathcliff,
		/obj/item/toy/plush/ishmael,
		/obj/item/toy/plush/rodion,
		/obj/item/toy/plush/sinclair,
		/obj/item/toy/plush/outis,
		/obj/item/toy/plush/gregor,
		/obj/item/toy/plush/yuri,
	)

	var/rareloot =	list(/obj/item/toy/plush/dante)
	var/veryrareloot =	list()
	var/rarechance = 20
	var/veryrarechance
	var/cosmeticloot = list()
	var/cosmeticchance = 0 //These do not count on the total odds of a crate

/obj/structure/lootcrate/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)	//Also can't drag it out to open it. Open it on spot, bitch
		anchored = TRUE

/obj/structure/lootcrate/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	var/loot
	var/cloot
	if(I.tool_behaviour != TOOL_CROWBAR)
		return

	if(SSmaptype.maptype in SSmaptype.citymaps)	//Fuckers shouldn't loot like this
		if(!do_after(user, 7 SECONDS, src))
			return

	if(veryrarechance && prob(veryrarechance))
		loot = pick(veryrareloot)

	else if(prob(rarechance))
		loot = pick(rareloot)

	else
		loot = pick(lootlist)

	if(cosmeticchance && prob(cosmeticchance))
		cloot = pick(cosmeticloot)
		new cloot(get_turf(src))

	to_chat(user, span_notice("You open the crate!"))
	new loot(get_turf(src))
	qdel(src)
