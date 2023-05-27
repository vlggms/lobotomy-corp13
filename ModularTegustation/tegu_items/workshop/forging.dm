/obj/item/forginghammer
	name = "forging hammer"
	desc = "Metal used for forging into workshop weapons. Use on hot tresmetal resting on an anvil to work it"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "hammer"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/tresmetal
	name = "tres metal"
	desc = "Metal used for forging into workshop weapons. Put into the forge to heat it"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "tresmetal"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/hot_tresmetal
	name = "heated tres metal"
	desc = "Metal used for forging workshop weapons. Put it on an anvil and hit with a hammer to work it"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "tresmetal_hot"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/hot_tresmetal/Initialize()
	addtimer(CALLBACK(src, .proc/cooling), 5 MINUTES)
	..()

/obj/item/hot_tresmetal/proc/cooling()
	new /obj/item/tresmetal(get_turf(src))
	visible_message("<span class='notice'>The tresmetal cooled down to it's original form.</span>")
	qdel(src)

/obj/item/hot_tresmetal/attackby(obj/item/I, mob/living/user, params)
	..()
	if(istype(I, /obj/item/forginghammer))
		if(!(locate(/obj/structure/table/anvil) in loc))
			to_chat(user, "<span class='warning'>You need this to be on an anvil to work it.</span>")
			return

		if(!do_after(user, 10 SECONDS))
			return

		var/list/display_names = generate_display_names()
		if(!display_names.len)
			return
		var/choice = input(user,"Which item would you like to make?","Select an Item") as null|anything in sortList(display_names)
		if(!choice || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
			return
		spawn_option(display_names[choice])

/obj/item/hot_tresmetal/proc/generate_display_names()
	var/static/list/template_types
	if(!template_types)
		template_types = list()
		var/list/templist = subtypesof(/obj/item/ego_weapon/template) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			template_types[initial(A.name)] = A
	return template_types

/obj/item/hot_tresmetal/proc/spawn_option(obj/item/choice)
	new choice(get_turf(src))
	visible_message("<span class='notice'>The tresmetal is worked into a [choice.name].</span>")
	qdel(src)

/obj/structure/table/anvil
	name = "workshop anvil"
	desc = "An anvil used by workshop offices. Put hot tresmetal on it and hit with a hammer to make a weapon."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "anvil"
	resistance_flags = INDESTRUCTIBLE
	smoothing_flags = null
	smoothing_groups = list()
	canSmoothWith = list()


/obj/structure/forge
	name = "workshop forge"
	desc = "A machine used to refine tres metal into templates."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "furnace_on"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/heat_timer = 60 SECONDS

	//The loaded of things.
	//FALSE is for not busy
	//TRUE is for loaded
	var/loaded = FALSE

/obj/structure/forge/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tresmetal))
		if(!loaded)
			loaded = TRUE
			to_chat(user, "<span class='notice'>You load a bar of tresmetal into the machine.</span>")
			qdel(I)
			addtimer(CALLBACK(src, .proc/finish), heat_timer)

			playsound(get_turf(src), 'sound/items/welder.ogg', 100, 0)
		else
			to_chat(user, "<span class='notice'>Something is already heating.</span>")
	..()

/obj/structure/forge/proc/finish()
	loaded = FALSE
	new /obj/item/hot_tresmetal(get_turf(src))
	visible_message("<span class='notice'>The tresmetal is done heating, and will start cooling...</span>")
