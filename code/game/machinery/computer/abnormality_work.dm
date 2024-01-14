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
	/// Will works send signals and be logged?
	var/recorded = TRUE
	/// Special tutorial abnormality behaviors
	var/tutorial = FALSE
	/// Work types will instead redirect to those, if listed
	var/list/scramble_list = list()
	///Linked Panel
	var/obj/machinery/containment_panel/linked_panel
	/// Accumulated abnormality chemical.
	var/chem_charges = 0

/obj/machinery/computer/abnormality/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality/Destroy()
	GLOB.lobotomy_devices -= src
	..()

/obj/machinery/computer/abnormality/update_overlays()
	. = ..()
	if(meltdown)
		SSvis_overlays.add_vis_overlay(src, icon, "abnormality_meltdown[meltdown]", layer + 0.1, plane, dir)

/obj/machinery/computer/abnormality/examine(mob/user)
	. = ..()
	if(!datum_reference)
		return
	. += span_info("This console is connected to [datum_reference.GetName()]'s containment unit.")
	var/threat_level = "<span style='color: [THREAT_TO_COLOR[datum_reference.GetRiskLevel()]]'>[THREAT_TO_NAME[datum_reference.GetRiskLevel()]]</span>"
	. += span_info("Risk Level: ") + "[threat_level]" // Professionals have standards
	if(datum_reference.qliphoth_meter_max > 0)
		. += span_info("Current Qliphoth Counter: [datum_reference.qliphoth_meter].")
	if(datum_reference.overload_chance[user.ckey])
		. += span_warning("Current Personal Qliphoth Overload: [datum_reference.overload_chance[user.ckey]]%.")
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
			if(MELTDOWN_BLACK)
				melt_text = " of Lunacy. Failure to clear the meltdown will cause another abnormality to breach"
		. += span_warning("The containment unit is currently affected by a Qliphoth Meltdown[melt_text]. Time left: [meltdown_time].")

/obj/machinery/computer/abnormality/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	if(!istype(datum_reference))
		to_chat(user, span_boldannounce("The console has no information stored!"))
		return
	var/dat
	dat += "<b><span style='color: [THREAT_TO_COLOR[datum_reference.GetRiskLevel()]]'>\[[THREAT_TO_NAME[datum_reference.GetRiskLevel()]]\]</span> [datum_reference.GetName()]</b><br>"
	if(datum_reference.overload_chance[user.ckey])
		dat += "<span style='color: [COLOR_VERY_SOFT_YELLOW]'>Personal Work Success Rates are modified by [datum_reference.overload_chance[user.ckey]]%.</span><br>"
		if(datum_reference.overload_chance_limit < 0 && datum_reference.overload_chance[user.ckey] <= datum_reference.overload_chance_limit) // How the fuck did you hit the limit..?
			dat += "<span style='color: [COLOR_MOSTLY_PURE_RED]'>Work on other abnormalities, I beg you...</span><br>"
	if(datum_reference.understanding != 0)
		dat += "<span style='color: [COLOR_BLUE_LIGHT]'>Current Understanding is: [round((datum_reference.understanding/datum_reference.max_understanding)*100, 0.01)]%, granting a [datum_reference.understanding]% Work Success and Speed bonus.</span><br>"
	dat += "<br>"

	//Abnormality portraits
	var/list/paths = get_portrait_path()
	for(var/pahs in paths)
		user << browse_rsc(pahs)
	dat += {"<div style="float:right; width: 60%;">
	<img src='[datum_reference.GetPortrait()].png' class="fit-picture" width="192" height="192">
	</div>"}
	dat += "<br>"

	var/list/work_list = datum_reference.available_work
	if(!tutorial && istype(SSlobotomy_corp.core_suppression, /datum/suppression/information))
		work_list = shuffle(work_list) // A minor annoyance, at most
	for(var/wt in work_list)
		var/work_display = "[wt] Work"
		if(scramble_list[wt] != null)
			work_display += "?"
		var/datum/suppression/information/I = GetCoreSuppression(/datum/suppression/information)
		if(!tutorial && istype(I))
			work_display = Gibberish(work_display, TRUE, I.gibberish_value)
		if(HAS_TRAIT(user, TRAIT_WORK_KNOWLEDGE))
			dat += "<A href='byond://?src=[REF(src)];do_work=[wt]'>[work_display] \[[datum_reference.get_work_chance(wt, user)]%\]</A> <br>"
		else
			dat += "<A href='byond://?src=[REF(src)];do_work=[wt]'>[work_display]</A> <br>"

	var/datum/browser/popup = new(user, "abno_work", "Abnormality Work Console", 400, 350)
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
			if(HAS_TRAIT(usr, TRAIT_WORK_FORBIDDEN) && recorded) //let clerks work training rabbit
				to_chat(usr, span_warning("The console cannot be operated by [prob(0.1) ? "a filthy clerk" : "you"]!"))
				return
			if(datum_reference.working)
				to_chat(usr, span_warning("The console is currently being operated!"))
				return
			if(!istype(datum_reference.current) || (datum_reference.current.stat == DEAD))
				to_chat(usr, span_warning("The Abnormality is currently in the process of revival!"))
				return
			if(!(datum_reference.current.status_flags & GODMODE))
				to_chat(usr, span_warning("The Abnormality has breached containment!"))
				return
			var/work_attempt = datum_reference.current.AttemptWork(usr, href_list["do_work"])
			if(!work_attempt)
				if(work_attempt == FALSE)
					to_chat(usr, span_warning("This operation is currently unavailable."))
				return
			start_work(usr, href_list["do_work"])

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/abnormality/proc/start_work(mob/living/carbon/human/user, work_type)
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
	if(recorded)
		SEND_SIGNAL(user, COMSIG_WORK_STARTED, datum_reference, user, work_type)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WORK_STARTED, datum_reference, user, work_type)
	if(linked_panel)
		linked_panel.console_working()
	if(!HAS_TRAIT(user, TRAIT_WORKFEAR_IMMUNE))
		user.adjustSanityLoss(sanity_damage)
	if(user.stat == DEAD || user.sanity_lost)
		finish_work(user, work_type, 0) // Assume total failure
		return
	switch(sanity_result)
		if(-INFINITY to -1)
			to_chat(user, span_nicegreen("This assignment is too easy!"))
		if(0)
			to_chat(user, span_notice("I'll handle it as I always do."))
		if(1)
			to_chat(user, span_warning("Just follow standard procedures..."))
		if(2)
			to_chat(user, span_danger("Calm down... Calm down..."))
		if(3 to INFINITY)
			to_chat(user, span_userdanger("I'm not ready for this!"))
	var/was_melting = meltdown //to remember if it was melting down before the work started
	meltdown = FALSE // Reset meltdown
	if(was_melting)
		SEND_SIGNAL(src, COMSIG_MELTDOWN_FINISHED, datum_reference, TRUE)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MELTDOWN_FINISHED, datum_reference, TRUE)
	update_icon()
	datum_reference.working = TRUE
	var/work_chance = datum_reference.get_work_chance(work_type, user)
	if(was_melting == MELTDOWN_GRAY)
		work_chance -= 10
	if(was_melting == MELTDOWN_CYAN)
		work_chance -= 20
	var/work_speed = 2 SECONDS / (1 + ((get_modified_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
	work_speed /= user.physiology.work_speed_mod
	var/success_boxes = 0
	var/total_boxes = 0
	var/canceled = FALSE
	ADD_TRAIT(user, TRAIT_STUNIMMUNE, src)
	ADD_TRAIT(user, TRAIT_PUSHIMMUNE, src)
	user.density = FALSE // If they can be walked through they can't be switched! I didn't wanna add chairs because if there WAS it'd nullify the ability to DODGE issues that appear.
	user.set_anchored(TRUE)
	user.is_working = TRUE
	// Initial chance and speed values before work started, in case they get overriden by abnormality
	var/init_work_chance = work_chance
	var/init_work_speed = work_speed
	while(total_boxes < work_time)
		if(!CheckStatus(user))
			break
		work_speed = datum_reference.current.SpeedWorktickOverride(user, work_speed, init_work_speed, work_type)
		if(do_after(user, work_speed, src, IGNORE_HELD_ITEM))
			if(!CheckStatus(user))
				break
			for(var/shield_type in typesof(/datum/status_effect/interventionshield))
				user.remove_status_effect(shield_type)
			work_chance = datum_reference.current.ChanceWorktickOverride(user, work_chance, init_work_chance, work_type)
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
			to_chat(user, span_warning("The Abnormality grows frustrated as you cut your work short!"))
			success_boxes = 0
			canceled = TRUE
			break
	REMOVE_TRAIT(user, TRAIT_STUNIMMUNE, src)
	REMOVE_TRAIT(user, TRAIT_PUSHIMMUNE, src)
	user.density = TRUE
	user.set_anchored(FALSE)
	user.is_working = FALSE
	finish_work(user, work_type, success_boxes, work_speed, was_melting, canceled)

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

/obj/machinery/computer/abnormality/proc/finish_work(mob/living/carbon/human/user, work_type, pe = 0, work_speed = 2 SECONDS, was_melting, canceled = FALSE)
	if(recorded)
		SEND_SIGNAL(user, COMSIG_WORK_COMPLETED, datum_reference, user, work_type)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WORK_COMPLETED, datum_reference, user, work_type)
	if(linked_panel)
		linked_panel.console_status(src)
	if(!work_type)
		work_type = pick(datum_reference.available_work)
	if(datum_reference.max_boxes != 0) // All these messages should be visible (on the console) and audible (announced by machine)
		audible_message(span_notice("[work_type] work finished. [pe]/[datum_reference.max_boxes] PE acquired."),\
				span_notice("[work_type] work finished. [pe]/[datum_reference.max_boxes] PE acquired."))
		if(pe >= datum_reference.success_boxes)
			audible_message(span_notice("Work Result: Good"),\
				span_notice("Work Result: Good"))
		else if(pe >= datum_reference.neutral_boxes)
			audible_message(span_notice("Work Result: Normal"),\
				span_notice("Work Result: Normal"))
		else
			audible_message(span_notice("Work Result: Bad"),\
				span_notice("Work Result: Bad"))
	if(istype(user))
		datum_reference.work_complete(user, work_type, pe, work_speed*datum_reference.max_boxes, was_melting, canceled)
		if(recorded) //neither rabbit nor tutorial calls this
			SSlobotomy_corp.WorkComplete(pe, (meltdown_time <= 0))
	var/obj/item/chemical_extraction_attachment/attachment = locate() in src.contents
	if(attachment)
		chem_charges += 1
	else
		chem_charges = min(chem_charges + 0.2, 10)
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
	meltdown_time = rand(min_time, max_time) + (GetFacilityUpgradeValue(UPGRADE_ABNO_MELT_TIME) * \
					(GetCoreSuppression(/datum/suppression/command) ? 0.5 : 1))
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
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MELTDOWN_FINISHED, datum_reference, FALSE)
	return TRUE

// Scrambles work types for this specific console
/obj/machinery/computer/abnormality/proc/Scramble()
	var/list/normal_works = shuffle(list(
		ABNORMALITY_WORK_INSTINCT,
		ABNORMALITY_WORK_INSIGHT,
		ABNORMALITY_WORK_ATTACHMENT,
		ABNORMALITY_WORK_REPRESSION,
	))
	var/list/choose_from = normal_works.Copy()
	for(var/work in normal_works)
		scramble_list[work] = pick(choose_from - work)
		choose_from -= scramble_list[work]

//Links to containment panel
/obj/machinery/computer/abnormality/proc/LinkPanel(obj/machinery/panel)
	linked_panel = panel

//special console just for training rabbit
/obj/machinery/computer/abnormality/training_rabbit
	can_meltdown = FALSE
	recorded = FALSE

//special tutorial console: similar to training rabbit but actually give stats and not affected by suppressions
/obj/machinery/computer/abnormality/tutorial
	can_meltdown = FALSE
	recorded = FALSE
	tutorial = TRUE

//Don't add tutorial consoles to global list, prevents them from being affected by Control suppression or other effects
/obj/machinery/computer/abnormality/tutorial/Initialize()
	. = ..()
	GLOB.lobotomy_devices -= src

//don't scramble our poor interns
/obj/machinery/computer/abnormality/tutorial/Scramble()
	return
