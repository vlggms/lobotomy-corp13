/datum/tgui_keybind_modal
	var/client/holder
	var/datum/action/target_action
	var/atom/movable/screen/movable/action_button/target_button

/datum/tgui_keybind_modal/New(client/C, datum/action/action, atom/movable/screen/movable/action_button/button)
	holder = C
	target_action = action
	target_button = button

/datum/tgui_keybind_modal/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_keybind_modal/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "KeyComboModal")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/tgui_keybind_modal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	
	switch(action)
		if("set_keybind")
			var/key = params["key"]
			if(key && target_action)
				target_action.bind_to_key(key)
				to_chat(holder, span_notice("Action '[target_action.name]' bound to [key]."))
			qdel(src)
			return TRUE
		if("cancel")
			qdel(src)
			return TRUE

/datum/tgui_keybind_modal/ui_close(mob/user)
	qdel(src)
