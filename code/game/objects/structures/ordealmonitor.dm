/obj/structure/sign/ordealmonitor
	name = "ordeal monitor"
	desc = "A screen with information regarding Qliphoth Meltdowns and Ordeals that will happen soon."
	icon = 'icons/obj/ordeal_monitor.dmi'
	icon_state = "ordeal_monitor"
	buildable_sign = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/sign/ordealmonitor/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/sign/ordealmonitor/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

/obj/structure/sign/ordealmonitor/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Current Qliphoth Meter: [SSlobotomy_corp.qliphoth_meter] / [SSlobotomy_corp.qliphoth_max].</span>"
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
		. += "<span class='warning'>[SSlobotomy_corp.next_ordeal.name] will be summoned for the next Qliphoth Meltdown.</span>"

/obj/structure/sign/ordealmonitor/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
		var/level_text = lowertext(SSlobotomy_corp.next_ordeal.ReturnSecretName())
		var/obj/effect/overlay/vis/OV = SSvis_overlays.add_vis_overlay(src, icon, level_text, layer + 0.1, plane, dir)
		OV.add_atom_colour(SSlobotomy_corp.next_ordeal.color, FIXED_COLOUR_PRIORITY)
