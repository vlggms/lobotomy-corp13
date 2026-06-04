// Enhanced information printer tool

// Virtually identical to the information tool used by agents, but instant and allows for printouts.
// This effectively replaces the old workrate predicter because that feature was moved to abnormality understanding.
/obj/item/info_printer/records
	name = "Abnormality Information Display Plus"
	desc = "A temporally enhanced abnormality information printer that draws power from the records officer's 25 hour days."
	use_time = 0
	var/print_cooldown_time = 30 SECONDS // We don't want them spamming printouts
	var/print_cooldown

// We're just gonna override these procs but give the player the option to not delete the info

/obj/item/info_printer/records/Scan(atom/A, mob/living/user)
	if(!isabnormalitymob(A))
		return FALSE
	var/list/information = GenerateInfo(A, user)
	if(information)
		var/datum/browser/popup = new(user, "information", FALSE, 300, 350)
		popup.set_content(information)
		popup.open(FALSE)
	return TRUE

/obj/item/info_printer/records/GenerateInfo(mob/living/simple_animal/hostile/abnormality/abno_mob, mob/living/user)
	var/obj/item/paper/fluff/info/info_paper
	for(var/path in subtypesof(/obj/item/paper/fluff/info))
		info_paper = path
		if(abno_mob.type == initial(info_paper.abno_type))
			info_paper = new path(src)
			break

	if(tgalert(user, "Would you like to print this information?", "Print info?", "Yes", "No") != "Yes")
		stoplag(1)
		. = info_paper.info
		QDEL_NULL(info_paper)
		return
	else if(info_paper)
		stoplag(1)
		if(world.time < print_cooldown)
			QDEL_NULL(info_paper)
			to_chat(user, span_warning("You need to wait a bit before you can print again."))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			. = info_paper.info
			return
		info_paper.forceMove(get_turf(src))
		print_cooldown = world.time + print_cooldown_time
		return
	return FALSE
