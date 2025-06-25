/obj/structure/altrefiner/quick
	name = "Quick Refinery"
	desc = "A machine used by the Extraction Officer to ship PE to command to refine."
	icon_state = "dominator-yellow"
	requires_item = TRUE

/obj/structure/altrefiner/quick/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "This machine seems to be upgraded, reducing the time to refine by 12 seconds.")

/obj/structure/altrefiner/quick/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!.)
		return
	var/time_mult = 1
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		time_mult = 2/3
	if(I.type != /obj/item/rawpe)
		to_chat(user, span_warning("Only Raw PE is accepted by this machine"))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	if(!do_after(user, (10 * time_mult) SECONDS, src))
		to_chat(user, span_warning("Failed to insert into the engine. Please make sure to fully insert the box"))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	to_chat(user, span_notice("Request accepted. PE launching soon."))
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	qdel(I)
	addtimer(CALLBACK(src, PROC_REF(launch)), (30 * time_mult) SECONDS)


/obj/structure/altrefiner/quick/proc/launch()
	//Pick a landmark
	var/landmark = pick(GLOB.xeno_spawn)
	//Ship it down
	var/obj/structure/closet/supplypod/centcompod/pod = new()
	new /obj/item/refinedpe(pod)
	pod.explosionSize = list(0,0,0,0)
	new /obj/effect/pod_landingzone(get_turf(landmark), pod)
