/obj/machinery/computer/roguelite_manager
	name = "manager interference console" // Give me better name
	desc = "A console used to interfere with the normal shift flow in various ways."
	resistance_flags = INDESTRUCTIBLE
	var/datum/manager_card/current_selection = null
	var/current_selection_tier = 1

/obj/machinery/computer/roguelite_manager/Initialize()
	. = ..()
	GLOB.roguelite_consoles += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/roguelite_manager/Destroy()
	GLOB.roguelite_consoles -= src
	..()

/obj/machinery/computer/roguelite_manager/examine(mob/user)
	. = ..()
	if(!LAZYLEN(SSlobotomy_corp.manager_cards_current))
		return
	var/list/ret_list = list()
	for(var/i = 1 to SSlobotomy_corp.manager_cards_current.len)
		if(!LAZYLEN(SSlobotomy_corp.manager_cards_current[i]))
			continue
		ret_list += i
	if(!LAZYLEN(ret_list))
		return
	var/ret_text
	for(var/i = 1 to ret_list.len)
		ret_text += "[ret_list[i]]"
		if(i != ret_list.len)
			ret_text += ", "
	. += "<span class='notice'>Currently available card tiers: [ret_text].</span>"

/obj/machinery/computer/roguelite_manager/ui_interact(mob/user)
	. = ..()
	if(!islist(SSlobotomy_corp.manager_cards_current[current_selection_tier]))
		return
	if(!LAZYLEN(SSlobotomy_corp.manager_cards_current[current_selection_tier]))
		var/list/possible_tiers = list()
		for(var/i = 1 to SSlobotomy_corp.manager_cards_current.len)
			if(LAZYLEN(SSlobotomy_corp.manager_cards_current[i]))
				possible_tiers += i
		if(!LAZYLEN(possible_tiers))
			return
		current_selection_tier = pick(possible_tiers)

	var/dat
	if(istype(current_selection))
		dat += "<b><u>[current_selection.name]:</u></b><br>"
		dat += "[current_selection.desc]<br>"
		dat += "<A href='byond://?src=[REF(src)];activate_card=1'><b>Activate</b></A><br><br>"
	dat += "<b>Tier [current_selection_tier] cards:</b><br>"
	var/list/card_list = SSlobotomy_corp.manager_cards_current[current_selection_tier]
	for(var/i = 1 to card_list.len)
		var/datum/manager_card/card = card_list[i]
		dat += "<A href='byond://?src=[REF(src)];choose_card=[i]'>[card.name]</A><br>"
	dat += "<br>"
	if(current_selection_tier > 1 && islist(SSlobotomy_corp.manager_cards_current[current_selection_tier - 1]) && LAZYLEN(SSlobotomy_corp.manager_cards_current[current_selection_tier - 1]))
		dat += "<A href='byond://?src=[REF(src)];change_tier=[current_selection_tier - 1]'>Switch to tier [current_selection_tier - 1]</A><br>"
	if(islist(SSlobotomy_corp.manager_cards_current[current_selection_tier + 1]) && LAZYLEN(SSlobotomy_corp.manager_cards_current[current_selection_tier + 1]))
		dat += "<A href='byond://?src=[REF(src)];change_tier=[current_selection_tier + 1]'>Switch to tier [current_selection_tier + 1]</A>"
	var/datum/browser/popup = new(user, "manager_cards", "Manager Interference Console", 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/roguelite_manager/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		if(href_list["choose_card"])
			var/card_place = text2num(href_list["choose_card"])
			var/list/card_list = SSlobotomy_corp.manager_cards_current[current_selection_tier]
			if(card_list[card_place] in card_list)
				current_selection = card_list[card_place]
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
		if(href_list["change_tier"])
			var/new_tier = text2num(href_list["change_tier"])
			if(islist(SSlobotomy_corp.manager_cards_current[new_tier]) && LAZYLEN(SSlobotomy_corp.manager_cards_current[new_tier]))
				current_selection_tier = new_tier
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
		if(href_list["activate_card"])
			if(istype(current_selection))
				for(var/i = 1 to SSlobotomy_corp.manager_cards_current.len)
					if(!islist(SSlobotomy_corp.manager_cards_current[i]) || !LAZYLEN(SSlobotomy_corp.manager_cards_current[i]))
						continue
					if(current_selection in SSlobotomy_corp.manager_cards_current[i]) // We have to make sure it is still in the list at all
						visible_message("<span class='notice'>\"[current_selection]\" card has been activated.</span>")
						current_selection.Activate(usr)
						SSlobotomy_corp.manager_cards[i] -= current_selection
						SSlobotomy_corp.manager_cards_current[i] = list() // See now they're gone
						current_selection = null // Forever gone
						QDEL_NULL(current_selection)
						playsound(src, 'sound/machines/manager_card_activate.ogg', 50, FALSE)
						break

	add_fingerprint(usr)
	updateUsrDialog()
