/obj/machinery/computer/abnormality
	name = "abnormality work console"
	desc = "Used to perform various tasks with the abnormalities."
	resistance_flags = INDESTRUCTIBLE

	/// Datum reference of the abnormality this console is related to
	var/datum/abnormality/datum_reference = null
	/// Is someone currently using it?
	var/working = FALSE
	/// Is the abnormality in process of qliphoth meltdown?
	var/meltdown = FALSE
	/// How much ticks left to pass before the effect of meltdown occurs?
	var/meltdown_time = 0

/obj/machinery/computer/abnormality/Initialize()
	..()
	GLOB.abnormality_consoles += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality/Destroy()
	GLOB.abnormality_consoles -= src
	..()

/obj/machinery/computer/abnormality/update_overlays()
	. = ..()
	if(meltdown)
		. += "abnormality_meltdown"

/obj/machinery/computer/abnormality/examine(mob/user)
	. = ..()
	if(!datum_reference)
		return
	. += "<span class='notice'>This console is connected to [datum_reference.name] containment zone.</span>"
	var/threat_level = "<span style='color: [THREAT_TO_COLOR[datum_reference.threat_level]]'>[THREAT_TO_NAME[datum_reference.threat_level]]</span>"
	. += "<span class='notice'>Threat level:</span> [threat_level]<span class='notice'>.</span>" // Professionals have standards
	if(datum_reference.qliphoth_meter_max > 0)
		. += "<span class='notice'>Current qliphoth level: [datum_reference.qliphoth_meter].</span>"
	if(datum_reference.overload_chance != 0)
		. += "<span class='warning'>Current success chance modifier: [datum_reference.overload_chance]%.</span>"
	if(meltdown)
		. += "<span class='warning'>The chamber is currently in the process of meltdown. Time left: [meltdown_time].</span>"

/obj/machinery/computer/abnormality/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	if(!istype(datum_reference))
		to_chat(user, "<span class='boldannounce'>The console has no information stored!</span>")
		return
	var/dat
	dat += "<b><span style='color: [THREAT_TO_COLOR[datum_reference.threat_level]]'>\[[THREAT_TO_NAME[datum_reference.threat_level]]\]</span> [datum_reference.name]</b><br>"
	if(datum_reference.overload_chance != 0)
		dat += "<span style='color: [COLOR_VERY_SOFT_YELLOW]'>Current success chance is modified by [datum_reference.overload_chance]%</span><br>"
	dat += "<br>"
	for(var/wt in datum_reference.available_work)
		dat += "<A href='byond://?src=[REF(src)];do_work=[wt]'>[wt] Work</A> <br>"
	var/datum/browser/popup = new(user, "abno_work", "Abnormality Work Console", 400, 300)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/abnormality/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		if(href_list["do_work"] in datum_reference.available_work)
			if(working)
				to_chat(usr, "<span class='warning'>Console is currently being operated!</span>")
				return
			if(!istype(datum_reference.current) || (datum_reference.current.stat == DEAD))
				to_chat(usr, "<span class='warning'>Abnormality is currently in the process of revival!</span>")
				return
			if(datum_reference.current.AIStatus == TRUE)
				to_chat(usr, "<span class='warning'>Abnormality has escaped containment!</span>")
				return
			if(!datum_reference.current.attempt_work(usr, href_list["do_work"]))
				to_chat(usr, "<span class='warning'>This operation is currently unavailable.</span>")
				return
			start_work(usr, href_list["do_work"])

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/abnormality/proc/start_work(mob/living/carbon/human/user, work_type)
	var/sanity_result = round(datum_reference.current.fear_level - get_user_level(user))
	var/sanity_damage = -(max(((user.maxSanity * 0.26) * (sanity_result)), 0))
	var/work_time = datum_reference.max_boxes
	user.adjustSanityLoss(sanity_damage)
	if(user.sanity_lost)
		finish_work(user, work_type, 0, work_time) // Assume total failure
		return
	switch(sanity_result)
		if(-INFINITY to -1)
			to_chat(user, "<span class='nicegreen'>This assignment is too easy!")
		if(0)
			to_chat(user, "<span class='notice'>I'll handle it as I always do.")
		if(1)
			to_chat(user, "<span class='warning'>Just follow standard procedures...")
		if(2)
			to_chat(user, "<span class='danger'>Calm down... Calm down...")
		if(3 to INFINITY)
			to_chat(user, "<span class='userdanger'>I'm not ready for this!")
	meltdown = FALSE // Reset meltdown
	update_icon()
	working = TRUE
	var/work_chance = datum_reference.get_work_chance(work_type, user)
	work_chance *= 1 + (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) / 180)
	work_chance = datum_reference.current.work_chance(user, work_chance)
	var/work_speed = 2 SECONDS / (1 + (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) / 100))
	var/success_boxes = 0
	for(var/i = 1 to work_time)
		user.Stun(work_speed) // TODO: Probably temporary
		sleep(work_speed)
		if(do_work(work_chance))
			success_boxes += 1
		else
			datum_reference.current.worktick_failure(user)
		if(user.sanity_lost)
			break // Lost sanity
		if(user.health < 0)
			break // Dying
		if(datum_reference.current.AIStatus == TRUE)
			break // Somehow it escaped
	finish_work(user, work_type, success_boxes, work_time, work_speed)

/obj/machinery/computer/abnormality/proc/do_work(chance)
	if(prob(chance))
		playsound(src, 'sound/machines/synth_yes.ogg', 25, FALSE, -3)
		return TRUE
	playsound(src, 'sound/machines/synth_no.ogg', 25, FALSE, -3)
	return FALSE

/obj/machinery/computer/abnormality/proc/finish_work(mob/living/carbon/human/user, work_type, pe = 0, max_pe = 0, work_speed = 2 SECONDS)
	working = FALSE
	if(max_pe != 0)
		visible_message("<span class='notice'>Work finished. [pe]/[max_pe] PE acquired.")
	if(!work_type)
		work_type = pick(datum_reference.available_work)
	if(istype(user))
		datum_reference.work_complete(user, work_type, pe, max_pe, work_speed*max_pe)
	if((datum_reference.qliphoth_meter_max > 0) && (datum_reference.qliphoth_meter <= 0))
		visible_message("<span class='danger'>Warning! Qliphoth level reduced to 0!")
		playsound(src, 'sound/effects/alertbeep.ogg', 50, FALSE)
		return FALSE
	return TRUE

/obj/machinery/computer/abnormality/process()
	if(..())
		if(meltdown)
			meltdown_time -= 1
			if(meltdown_time <= 0)
				qliphoth_meltdown_effect()

/obj/machinery/computer/abnormality/proc/start_meltdown()
	meltdown_time = rand(60, 90)
	meltdown = TRUE
	datum_reference.current.meltdown_start()
	update_icon()
	playsound(src, 'sound/machines/warning-buzzer.ogg', 75, FALSE, 3)
	return TRUE

/obj/machinery/computer/abnormality/proc/qliphoth_meltdown_effect()
	meltdown = FALSE
	update_icon()
	datum_reference.qliphoth_change(-9)
	if((datum_reference.qliphoth_meter_max > 0) && (datum_reference.qliphoth_meter <= 0))
		visible_message("<span class='danger'>Warning! Qliphoth level reduced to 0!")
		playsound(src, 'sound/effects/alertbeep.ogg', 50, FALSE)
	return TRUE
