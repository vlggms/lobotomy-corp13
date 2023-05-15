/obj/machinery/computer/abnormality_archive
	name = "abnormality archive"
	desc = "A secure terminal connected to the Lobotomy Corp archive."
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	icon_keyboard = "tech_key"
	icon_screen = "forensic"
	var/printfile
	var/note
	var/linecount
	var/paper = 1 //You get one paper
	var/papermax = 10 //Recycle more paper
	var/list/note_list
	var/list/abno_data = list()

/obj/machinery/computer/abnormality_archive/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LC13AbnormalityArchive", name) //apparently connected to .Js which is invisable to dreammaker but not to Visual Studio Code.
		ui.open()

/obj/machinery/computer/abnormality_archive/ui_static_data(mob/user) //list is created the moment a person boots up the UI and inherited by future iterations of this object
	. = ..()
	//if the abnormality info is already made do not make a new one.
	if(abno_data.len <= 0)
		for(var/record in subtypesof(/obj/item/paper/fluff/info)) //consists of all threat levels and their branches
			var/obj/item/paper/fluff/info/record_detail = new record(src)
			if(record_detail.name == "paper" || record_detail.no_archive) //removes template papers and allows for secret files
				continue
			var/list/record_data = list()
			note_list = splittext(record_detail.info, "<br>") //splits text into a list by making <br> into a break,
			popleft(note_list) //Remove first line since it is the name
			while(note_list.Remove("")) // Removes all empty strings, if there are any.
			linecount = note_list.len //Doing it seperately results in only half of the lines being given a value. A single variable seems to keep it stable.
			record_data["linecount"] = linecount //len is list length
			record_data["type"] = record_detail.type //gives the typepath of the file we are reading
			if(record_detail.abno_code)
				record_data["name"] = remove_paper_commands(record_detail.abno_code) // Abnos
			else
				record_data["name"] = remove_paper_commands(record_detail.name) // Non-Abnos
			for(var/i=0 to (linecount-1)) //loop until we reach the same length as the linecount
				record_data["line[i]"] += remove_paper_commands(popleft(note_list))
			abno_data += list(record_data)
			qdel(record_detail)

	.["abnormality_info"] = abno_data

/obj/machinery/computer/abnormality_archive/ui_act(action, params) //Basically catches signals caused by the Javascript act('print_file', { ref: currentAbnormality.type })
	. = ..()
	if(.)
		return
	switch(action)
		if("print_file")
			if(paper <= 0)
				return
			printfile = params["ref"]
			print_file(printfile)

/obj/machinery/computer/abnormality_archive/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/paper) && paper <= papermax)
		qdel(O)
		paper = paper + 1
	..()

/obj/machinery/computer/abnormality_archive/proc/print_file(file)
	paper = paper - 1
	visible_message("<span class='notice'>[src] begins to print a file.</span>")
	playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 30, TRUE)
	new file(get_turf(src))

//Sanitize code did not work.
//Sanitize code uses both sanitize_simple and HTML_encode.
/obj/machinery/computer/abnormality_archive/proc/remove_paper_commands(paper) //Removes all command code. WILL cause problems for abnormality documents later. I am sorry about this.
	note = replacetext(paper, "<br>", "")
	note = replacetext(note, "<li>", "")
	note = replacetext(note, "'", "")
	note = replacetext(note, "<ul>", "")
	note = replacetext(note, "</ul>", "")
	note = replacetext(note, "<center>", "")
	note = replacetext(note, "</center>", "")
	note = replacetext(note, "<strong>", "")
	note = replacetext(note, "</strong>", "")
	note = replacetext(note, "<h1>", "")
	note = replacetext(note, "</h1>", "")
	note = replacetext(note, "<h2>", "")
	note = replacetext(note, "</h2>", "")
	note = replacetext(note, "<h3>", "")
	note = replacetext(note, "</h3>", "")
	note = replacetext(note, "<h4>", "")
	note = replacetext(note, "</h4>", "")
	note = html_encode(note)
	return note
