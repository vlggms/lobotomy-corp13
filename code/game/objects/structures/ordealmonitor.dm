/obj/structure/sign/ordealmonitor
	name = "ordeal monitor"
	desc = "A screen with information regarding qliphoth meltdowns and ordeals that will happen soon."
	icon = 'icons/obj/ordeal_monitor.dmi'
	icon_state = "ordeal_monitor"
	buildable_sign = FALSE

/obj/structure/sign/ordealmonitor/Initialize()
	. = ..()
	GLOB.ordeal_monitors += src

/obj/structure/sign/ordealmonitor/Destroy()
	GLOB.ordeal_monitors -= src
	return ..()

/obj/structure/sign/ordealmonitor/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Current qliphoth meter: [SSlobotomy_corp.qliphoth_meter] / [SSlobotomy_corp.qliphoth_max].</span>"
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
		. += "<span class='warning'>[SSlobotomy_corp.next_ordeal.name] will trigger on the next meltdown.</span>"

/obj/structure/sign/ordealmonitor/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
		var/level_text = "dawn"
		switch(SSlobotomy_corp.next_ordeal.level)
			if(2)
				level_text = "noon"
			if(3)
				level_text = "dusk"
			if(4 to INFINITY)
				level_text = "midnight"
		var/obj/effect/overlay/vis/OV = SSvis_overlays.add_vis_overlay(src, icon, level_text, layer + 0.1, plane, dir)
		OV.add_atom_colour(SSlobotomy_corp.next_ordeal.color, FIXED_COLOUR_PRIORITY)
