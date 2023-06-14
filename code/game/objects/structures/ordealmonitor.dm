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
	if(SSticker.mode != "suppression")
		if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
			. += "<span class='warning'>[SSlobotomy_corp.next_ordeal.name] will trigger on the next meltdown.</span>"
	else
		var/next_time = round((SSlobotomy_corp.ordeal_timelock[SSlobotomy_corp.next_ordeal_level] - world.time) / 600) + 1
		. += "<span class='warning'>[SSlobotomy_corp.next_ordeal.name] will occur in [next_time] minutes.</span>"

/obj/structure/sign/ordealmonitor/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time) || GLOB.master_mode == "suppression")
		var/level_text = lowertext(SSlobotomy_corp.next_ordeal.ReturnSecretName())
		var/obj/effect/overlay/vis/OV = SSvis_overlays.add_vis_overlay(src, icon, level_text, layer + 0.1, plane, dir)
		OV.add_atom_colour(SSlobotomy_corp.next_ordeal.color, FIXED_COLOUR_PRIORITY)
