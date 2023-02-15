/obj/machinery/computer/abnormality
	name = "abnormality work console"
	desc = "Used to perform various tasks with the abnormalities."
	resistance_flags = INDESTRUCTIBLE

	/// Datum reference of the abnormality this console is related to
	var/datum/abnormality/datum_reference = null
	/// Is the abnormality in process of qliphoth meltdown?
	var/meltdown = FALSE
	/// How much ticks left to pass before the effect of meltdown occurs?
	var/meltdown_time = 0
	/// Can the abnormality even meltdown?
	var/can_meltdown = TRUE
	/// Work types will instead redirect to those, if listed
	var/list/scramble_list = list()

/obj/machinery/computer/abnormality/Initialize()
	. = ..()
	GLOB.abnormality_consoles += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality/Destroy()
	GLOB.abnormality_consoles -= src
	..()

/obj/machinery/computer/abnormality/update_overlays()
	. = ..()
	if(meltdown)
		SSvis_overlays.add_vis_overlay(src, icon, "abnormality_meltdown[meltdown]", layer + 0.1, plane, dir)

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
		var/melt_text = ""
		switch(meltdown)
			if(MELTDOWN_GRAY)
				melt_text = " of Dark Fog. Success rates reduced by 10%"
			if(MELTDOWN_GOLD)
				melt_text = " of Gold. Failing to clear it will heal the Arbiter"
			if(MELTDOWN_PURPLE)
				melt_text = " of Waves. Upon clearing the meltdown the dark waves will disappear"
			if(MELTDOWN_CYAN)
				melt_text = " of Pillars. Success rates reduced by 20%. Failing to clear it will cause Arbiter to perform their deadly attack"
		. += "<span class='warning'>The chamber is currently in the process of meltdown[melt_text]. Time left: [meltdown_time].</span>"

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
	if(datum_reference.understanding != 0)
		dat += "<span style='color: [COLOR_BLUE_LIGHT]'>Current Understanding is: [round((datum_reference.understanding/datum_reference.max_understanding)*100, 0.01)]%, granting a [datum_reference.understanding]% Work Success and Speed bonus.</span><br>"
	dat += "<br>"
	var/list/work_list = datum_reference.available_work
	if(istype(SSlobotomy_corp.core_suppression, /datum/suppression/information))
		work_list = shuffle(work_list) // A minor annoyance, at most
	for(var/wt in work_list)
		var/work_display = "[wt] Work"
		if(scramble_list[wt] != null)
			work_display += "?"
		if(istype(SSlobotomy_corp.core_suppression, /datum/suppression/information))
			work_display = Gibberish(work_display, TRUE, 60)
		if(HAS_TRAIT(user, TRAIT_WORK_KNOWLEDGE)) // Might be temporary until we add upgrades
			dat += "<A href='byond://?src=[REF(src)];do_work=[wt]'>[work_display] \[[datum_reference.get_work_chance(wt, user)]%\]</A> <br>"
		else
			dat += "<A href='byond://?src=[REF(src)];do_work=[wt]'>[work_display]</A> <br>"
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
			if(datum_reference.working)
				to_chat(usr, "<span class='warning'>Console is currently being operated!</span>")
				return
			if(!istype(datum_reference.current) || (datum_reference.current.stat == DEAD))
				to_chat(usr, "<span class='warning'>Abnormality is currently in the process of revival!</span>")
				return
			if(!(datum_reference.current.status_flags & GODMODE))
				to_chat(usr, "<span class='warning'>Abnormality has escaped containment!</span>")
				return
			var/work_attempt = datum_reference.current.AttemptWork(usr, href_list["do_work"])
			if(!work_attempt)
				if(work_attempt == FALSE)
					to_chat(usr, "<span class='warning'>This operation is currently unavailable.</span>")
				return
			start_work(usr, href_list["do_work"])

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/abnormality/proc/start_work(mob/living/carbon/human/user, work_type, training = FALSE)
	var/sanity_result = round(datum_reference.current.fear_level - get_user_level(user))
	var/sanity_damage = 0
	switch(sanity_result)
		if(1)
			sanity_damage = user.maxSanity*0.1
		if(2)
			sanity_damage = user.maxSanity*0.3
		if(3)
			sanity_damage = user.maxSanity*0.6
		if(4 to INFINITY)
			sanity_damage = user.maxSanity
	var/work_time = datum_reference.max_boxes
	if(work_type in scramble_list)
		work_type = scramble_list[work_type]
	if(!training)
		SEND_SIGNAL(user, COMSIG_WORK_STARTED, datum_reference, user, work_type)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WORK_STARTED, datum_reference, user, work_type)
	if(!HAS_TRAIT(user, TRAIT_WORKFEAR_IMMUNE))
		user.adjustSanityLoss(sanity_damage)
	if(user.stat == DEAD || user.sanity_lost)
		finish_work(user, work_type, 0) // Assume total failure
		return
	switch(sanity_result)
		if(-INFINITY to -1)
			to_chat(user, "<span class='nicegreen'>This assignment is too easy!</span>")
		if(0)
			to_chat(user, "<span class='notice'>I'll handle it as I always do.</span>")
		if(1)
			to_chat(user, "<span class='warning'>Just follow standard procedures...</span>")
		if(2)
			to_chat(user, "<span class='danger'>Calm down... Calm down...</span>")
		if(3 to INFINITY)
			to_chat(user, "<span class='userdanger'>I'm not ready for this!</span>")
	var/was_melting = meltdown //to remember if it was melting down before the work started
	meltdown = FALSE // Reset meltdown
	SEND_SIGNAL(src, COMSIG_MELTDOWN_FINISHED, datum_reference, TRUE)
	update_icon()
	datum_reference.working = TRUE
	var/work_chance = datum_reference.get_work_chance(work_type, user)
	if(meltdown == MELTDOWN_GRAY)
		work_chance -= 10
	if(meltdown == MELTDOWN_CYAN)
		work_chance -= 20
	var/work_speed = 2 SECONDS / (1 + ((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
	var/success_boxes = 0
	var/total_boxes = 0
	var/canceled = FALSE
	ADD_TRAIT(user, TRAIT_STUNIMMUNE, src)
	ADD_TRAIT(user, TRAIT_PUSHIMMUNE, src)
	user.density = FALSE // If they can be walked through they can't be switched! I didn't wanna add chairs because if there WAS it'd nullify the ability to DODGE issues that appear.
	user.set_anchored(TRUE)
	user.is_working = TRUE
	while(total_boxes < work_time)
		if(!CheckStatus(user))
			break
		if(do_after(user, work_speed, src))
			if(!CheckStatus(user))
				break
			user.remove_status_effect(/datum/status_effect/interventionshield) //removing status effect doesnt seem to effect all of parent. -IP
			user.remove_status_effect(/datum/status_effect/interventionshield/white)
			user.remove_status_effect(/datum/status_effect/interventionshield/black)
			user.remove_status_effect(/datum/status_effect/interventionshield/pale)
			if(do_work(work_chance))
				success_boxes++
				datum_reference.current.WorktickSuccess(user)
			else
				datum_reference.current.WorktickFailure(user)
			total_boxes++
			datum_reference.current.Worktick(user)
		else
			if(!CheckStatus(user)) // No punishment if the thing is already breached or any other issue is prevelant.
				break
			for(var/i = 0 to round((work_time - total_boxes)*(1-((work_chance*0.5)/100)), 1)) // Take double of what you'd fail on average as NE box damage.
				datum_reference.current.WorktickFailure(user)
			playsound(src, 'sound/machines/synth_no.ogg', 75, FALSE, -4)
			to_chat(user, "<span class='warning'>The Abnormality grows frustrated as you cut your work short!")
			success_boxes = 0
			canceled = TRUE
			break
	REMOVE_TRAIT(user, TRAIT_STUNIMMUNE, src)
	REMOVE_TRAIT(user, TRAIT_PUSHIMMUNE, src)
	user.density = TRUE
	user.set_anchored(FALSE)
	user.is_working = FALSE
	finish_work(user, work_type, success_boxes, work_speed, training, was_melting, canceled)

/obj/machinery/computer/abnormality/proc/CheckStatus(mob/living/carbon/human/user)
	if(user.sanity_lost)
		return FALSE // Lost sanity
	if(user.health < 0)
		return FALSE // Dying
	if(!(datum_reference.current.status_flags & GODMODE))
		return FALSE // Somehow it escaped
	return TRUE

/obj/machinery/computer/abnormality/proc/do_work(chance)
	if(prob(chance))
		playsound(src, 'sound/machines/synth_yes.ogg', 25, FALSE, -4)
		return TRUE
	playsound(src, 'sound/machines/synth_no.ogg', 25, FALSE, -4)
	return FALSE

/obj/machinery/computer/abnormality/proc/finish_work(mob/living/carbon/human/user, work_type, pe = 0, work_speed = 2 SECONDS, training = FALSE, was_melting, canceled = FALSE)
	if(!training)
		SEND_SIGNAL(user, COMSIG_WORK_COMPLETED, datum_reference, user, work_type)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WORK_COMPLETED, datum_reference, user, work_type)
	if(!work_type)
		work_type = pick(datum_reference.available_work)
	if(datum_reference.max_boxes != 0)
		visible_message("<span class='notice'>[work_type] work finished. [pe]/[datum_reference.max_boxes] PE acquired.</span>")
		if(pe >= datum_reference.success_boxes)
			visible_message("<span class='notice'>Work Result: Good</span>")
		else if(pe >= datum_reference.neutral_boxes)
			visible_message("<span class='notice'>Work Result: Normal</span>")
		else
			visible_message("<span class='notice'>Work Result: Bad</span>")
	if(istype(user))
		if(!training)
			datum_reference.work_complete(user, work_type, pe, work_speed*datum_reference.max_boxes, was_melting, canceled)
			SSlobotomy_corp.WorkComplete(pe, (meltdown_time <= 0))
		else
			datum_reference.current.WorkComplete(user, work_type, pe, work_speed*datum_reference.max_boxes)
	meltdown_time = 0
	datum_reference.working = FALSE
	return TRUE

/obj/machinery/computer/abnormality/process()
	if(..())
		if(meltdown)
			meltdown_time -= 1
			if(meltdown_time <= 0)
				qliphoth_meltdown_effect()

/obj/machinery/computer/abnormality/proc/start_meltdown(melt_type = MELTDOWN_NORMAL, min_time = 60, max_time = 90)
	meltdown_time = rand(min_time, max_time)
	meltdown = melt_type
	datum_reference.current.MeltdownStart()
	update_icon()
	playsound(src, 'sound/machines/warning-buzzer.ogg', 75, FALSE, 3)
	return TRUE

/obj/machinery/computer/abnormality/proc/qliphoth_meltdown_effect()
	meltdown = FALSE
	update_icon()
	datum_reference.qliphoth_change(-999)
	SEND_SIGNAL(src, COMSIG_MELTDOWN_FINISHED, datum_reference, FALSE)
	return TRUE

// Scrambles work types for this specific console
/obj/machinery/computer/abnormality/proc/Scramble()
	var/list/normal_works = shuffle(list(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION))
	var/list/choose_from = normal_works.Copy()
	for(var/work in normal_works)
		scramble_list[work] = pick(choose_from - work)
		choose_from -= scramble_list[work]

//special console just for training rabbit
/obj/machinery/computer/abnormality/training_rabbit
	can_meltdown = FALSE

/obj/machinery/computer/abnormality/training_rabbit/start_work(mob/living/carbon/human/user, work_type, training = TRUE)
	..(user, work_type, training = training)

//No meltdown console for tutorials
/obj/machinery/computer/abnormality/tutorial
	can_meltdown = FALSE

/obj/machinery/computer/abnormality/tutorial/start_work(mob/living/carbon/human/user, work_type, training = TRUE)
	..(user, work_type, training = training)
