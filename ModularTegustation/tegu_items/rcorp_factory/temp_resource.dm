//This is a bitch to refactor into main resource points, so I'm not gonna try. Also less resource intensive
/obj/structure/limitedresourcepoint
	name = "limited green resource point"
	desc = "A machine that when used, spits out green resources."
	icon = 'ModularTegustation/Teguicons/factory.dmi'
	icon_state = "resourcemini_green"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/obj/item = /obj/item/factoryitem/green	//What item you spawn
	var/amount_left = 30	//How many you spawn

/obj/structure/limitedresourcepoint/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.tool_behaviour != TOOL_WRENCH)
		return
	if(!do_after(user, 7 SECONDS, src))
		return
	addtimer(CALLBACK(src, PROC_REF(spit_item)), 60)

/obj/structure/limitedresourcepoint/proc/spit_item()
	new item(src.loc)
	amount_left-=1
	if(amount_left ==0)
		qdel(src)
		new /obj/item/factoryitem/upgrade(src.loc)
	else
		addtimer(CALLBACK(src, PROC_REF(spit_item)), 60)

/obj/structure/limitedresourcepoint/red
	name = "limited red resource point"
	desc = "A machine that when used, spits out red resources."
	icon_state = "resourcemini_red"
	item = /obj/item/factoryitem/red

/obj/structure/limitedresourcepoint/blue
	name = "limited blue resource point"
	desc = "A machine that when used, spits out blue resources."
	icon_state = "resourcemini_blue"
	item = /obj/item/factoryitem/blue

/obj/structure/limitedresourcepoint/purple
	name = "limited purple resource point"
	desc = "A machine that when used, spits out purple resources."
	icon_state = "resourcemini_purple"
	item = /obj/item/factoryitem/purple

/obj/structure/limitedresourcepoint/orange
	name = "limited orange resource point"
	desc = "A machine that when used, spits out orange resources."
	icon_state = "resourcemini_orange"
	item = /obj/item/factoryitem/orange

/obj/structure/limitedresourcepoint/silver
	name = "limited silver resource point"
	desc = "A machine that when used, spits out silver resources."
	icon_state = "resourcemini_silver"
	item = /obj/item/factoryitem/silver
