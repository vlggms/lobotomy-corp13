/obj/structure/resourcepoint
	name = "green resource point"
	desc = "A machine that when used, spits out green resources."
	icon = 'ModularTegustation/Teguicons/factory.dmi'
	icon_state = "resource_green"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/obj/item = /obj/item/factoryitem/green	//What item you spawn
	var/active = 0	//What level you have

/obj/structure/resourcepoint/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.tool_behaviour != TOOL_WRENCH)
		return
	if(!do_after(user, 7 SECONDS, src))
		return
	active = 1
	addtimer(CALLBACK(src, PROC_REF(spit_item)), 600/active)

/obj/structure/resourcepoint/proc/spit_item()
	if(!active)
		return
	if(prob(20) && active<=6)	//To do: make this less random.
		active+=1
	addtimer(CALLBACK(src, PROC_REF(spit_item)), 600/active)
	new item(src.loc)

/obj/structure/resourcepoint/red
	name = "red resource point"
	desc = "A machine that when used, spits out red resources."
	icon_state = "resource_red"
	item = /obj/item/factoryitem/red	//What item you spawn

/obj/structure/resourcepoint/blue
	name = "blue resource point"
	desc = "A machine that when used, spits out blue resources."
	icon_state = "resource_blue"
	item = /obj/item/factoryitem/blue	//What item you spawn

/obj/structure/resourcepoint/purple
	name = "purple resource point"
	desc = "A machine that when used, spits out purple resources."
	icon_state = "resource_purple"
	item = /obj/item/factoryitem/purple	//What item you spawn

/obj/structure/resourcepoint/orange
	name = "orange resource point"
	desc = "A machine that when used, spits out orange resources."
	icon_state = "resource_orange"
	item = /obj/item/factoryitem/orange	//What item you spawn

/obj/structure/resourcepoint/silver
	name = "silver resource point"
	desc = "A machine that when used, spits out silver resources."
	icon_state = "resource_silver"
	item = /obj/item/factoryitem/silver	//What item you spawn
