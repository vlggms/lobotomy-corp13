//Copied off of the tgui_modal of tgui_alert - Used for html elements for the final observations
/proc/final_observation_alert(mob/user, message, title, list/buttons, timeout = 60 SECONDS)
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	var/datum/final_observation_modal/alert = new(user, message, title, buttons, timeout)
	alert.ui_interact(user)
	alert.wait()
	if(alert)
		if(!alert.choice)
			alert.choice = "timed out"
		. = alert.choice
		qdel(alert)

/datum/final_observation_modal
	var/title
	var/message
	var/list/buttons
	var/choice
	var/start_time
	var/timeout
	var/closed
	var/saved_user
	var/datum/browser/popup

/datum/final_observation_modal/New(mob/user, message, title, list/buttons, timeout)
	src.title = title
	src.message = message
	src.buttons = buttons.Copy()
	src.saved_user = user
	if(timeout)
		src.timeout = timeout
		start_time = world.time
		addtimer(CALLBACK(src, PROC_REF(Closeup), TRUE), timeout) //Qdel and clean up menus

/datum/final_observation_modal/Destroy(force, ...)
	SStgui.close_uis(src)
	QDEL_NULL(buttons)
	. = ..()

/datum/final_observation_modal/proc/wait()
	while(!choice && !closed)
		stoplag(1)
	Closeup()

/datum/final_observation_modal/proc/Closeup(delete = FALSE) //Proc that cleans up the menu properly
	if(popup)
		popup.close()
		qdel(popup)
	if(delete)
		closed = TRUE

/datum/final_observation_modal/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat = {"<div style=text-align:center;" valign="top">[message]<BR><BR></div>"}
	var/menu_width = 200
	for(var/i in 1 to length(buttons))
		menu_width += 150
		switch(length(buttons))
			if(1)
				dat += {"<a style="font-size:large;float:center" href="?src=[REF(src)];button=[i]">[buttons[i]]</a>"}
			if(2)
				dat += {"<a style="font-size:large;[( i == 1 ? "float:left" : "float:right" )]" href="?src=[REF(src)];button=[i]">[buttons[i]]</a>"}
			if(3)
				dat += {"<a style="font-size:large;[( i == 1 ? "float:left" : (i == 2 ? "float:center" : "float:right") )]" href="?src=[REF(src)];button=[i]">[buttons[i]]</a>"}
			else
				if(i > 3)
					dat += "<BR><BR>"
				dat += {"<a style="font-size:large;[( i == 2 ? "float:center" : (i == 3 ? "float:right" : "float:left") )])]" href="?src=[REF(src)];button=[i]">[buttons[i]]</a>"}

	if(!popup)
		popup = new(user, "final_observation", "[title]", menu_width, 350)
		popup.set_window_options("can_close=0")
		popup.set_content(dat)
		popup.open(TRUE)
	return

/datum/final_observation_modal/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		if(HAS_TRAIT(usr, TRAIT_WORK_FORBIDDEN)) //gifts are only for agents
			to_chat(usr, span_warning("You cannot perform this operation!"))
			return
		if(href_list["button"])
			var/button = text2num(href_list["button"])
			if(button <= 3 && button >= 1)
				choice = buttons[button]
		closed = TRUE

/datum/final_observation_modal/ui_state(mob/user)
	return GLOB.always_state

/datum/final_observation_modal/ui_data(mob/user)
	. = list(
		"title" = title,
		"message" = message,
		"buttons" = buttons
	)
	if(timeout)
		.["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))

/datum/final_observation_modal/ui_act(action, list/params)
	. = ..()
	if (.)
		return
	switch(action)
		if("choose")
			if (!(params["choice"] in buttons))
				return
			choice = params["choice"]
			SStgui.close_uis(src)
			Closeup()
			return TRUE

