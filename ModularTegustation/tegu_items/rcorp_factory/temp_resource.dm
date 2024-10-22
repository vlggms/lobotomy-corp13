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
	var/amount_left = 30	//What level you have

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

