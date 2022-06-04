/obj/machinery/computer/abnormality
	name = "abnormality work console"
	desc = "Used to perform various tasks with the abnormalities."

	var/datum/abnormality/datum_reference = null
	var/working = FALSE

/obj/machinery/computer/abnormality/examine(mob/user)
	. = ..()
	if(!datum_reference)
		return
	. += "<span class='notice'>This console is connected to [datum_reference.name] containment zone.</span>"
	var/threat_level = "<span style='color: [THREAT_TO_COLOR[datum_reference.threat_level]]'>[THREAT_TO_NAME[datum_reference.threat_level]]</span>"
	. += "<span class='notice'>Threat level:</span> [threat_level]<span class='notice'>.</span>" // Professionals have standards
	if(datum_reference.qliphoth_meter_max > 0)
		. += "<span class='notice'>Current qliphoth level: [datum_reference.qliphoth_meter].</span>"

/obj/machinery/computer/abnormality/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	if(!istype(datum_reference))
		to_chat(user, "<span class='boldannounce'>The console has no information stored!</span>")
		return
	var/dat
	for(var/wt in datum_reference.available_work)
		dat += "<A href='?src=[REF(src)];do_work=[wt]'>[wt] Work</A> <br>"
	var/datum/browser/popup = new(user, "abno_work", "Abnormality Work Console", 600, 400)
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
			if(!istype(datum_reference.current))
				to_chat(usr, "<span class='warning'>Abnormality is currently in the process of revival!</span>")
				return
			if(datum_reference.current.AIStatus == TRUE)
				to_chat(usr, "<span class='warning'>Abnormality has escaped containment!</span>")
				return
			start_work(usr, href_list["do_work"])

/obj/machinery/computer/abnormality/proc/start_work(mob/living/carbon/human/user, work_type)
	var/sanity_result = round(datum_reference.threat_level - get_user_level(user))
	var/sanity_damage = -(max(((user.maxSanity * 0.2) * (sanity_result-1)), 0)) // Maximum damage being 80% of max sanity
	var/work_time = datum_reference.max_boxes
	user.adjustSanityLoss(sanity_damage)
	if(user.sanity_lost)
		to_chat(user, "<span class='userdanger'>I DON'T WANT TO DIE!")
		finish_work(user, work_type, 0, work_time) // Assume total failure
		return
	switch(sanity_result)
		if(-INFINITY to -1)
			to_chat(user, "<span class='nicegreen'>This assignment is too easy!")
		if(0)
			to_chat(user, "<span class='nicegreen'>I'll handle it as I always do.")
		if(1)
			to_chat(user, "<span class='notice'>Nothing too serious.")
		if(2)
			to_chat(user, "<span class='warning'>Just follow standard procedures...")
		if(3)
			to_chat(user, "<span class='danger'>Calm down... Calm down...")
		if(4 to INFINITY)
			to_chat(user, "<span class='userdanger'>I'm not ready for this!")
	working = TRUE
	var/needed_attribute = WORK_TO_ATTRIBUTE[work_type]
	var/work_chance = datum_reference.available_work[work_type]
	work_chance *= 1 + (get_attribute_level(user, needed_attribute) / 180)
	work_chance *= 1 + (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) / 240) // Minor boost from temperance
	work_chance = datum_reference.current.work_chance(user, work_chance)
	var/work_speed = 2 SECONDS / (1 + (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) / 100))
	var/success_boxes = 0
	for(var/i = 1 to work_time)
		sleep(work_speed)
		if(do_work(work_chance))
			success_boxes += 1
	finish_work(user, work_type, success_boxes, work_time)

/obj/machinery/computer/abnormality/proc/do_work(chance)
	if(prob(chance))
		playsound(src, 'sound/machines/synth_yes.ogg', 25, FALSE)
		return TRUE
	playsound(src, 'sound/machines/synth_no.ogg', 25, FALSE)
	return FALSE

/obj/machinery/computer/abnormality/proc/finish_work(mob/living/carbon/human/user, work_type, pe, max_pe)
	working = FALSE
	visible_message("<span class='notice'>Work finished. [pe]/[max_pe] PE acquired.")
	datum_reference.work_complete(user, work_type, pe)
	if((datum_reference.qliphoth_meter_max > 0) && (datum_reference.qliphoth_meter <= 0))
		visible_message("<span class='danger'>Warning! Qliphoth level reduced to 0!")
		playsound(src, 'sound/effects/alertbeep.ogg', 50, FALSE)
