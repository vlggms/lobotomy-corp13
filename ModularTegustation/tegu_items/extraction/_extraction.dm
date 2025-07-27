//Extraction tool base item
/obj/item/extraction
	name = "degraded block"
	desc = "This item shouldn't exist, report this to a coder!"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity7"

//This is when a player clicks the tool in hand
/obj/item/extraction/attack_self(mob/user)
	//We ask if are user is infact able to use the tool
	if(tool_checks(user))
		//We now do the tool action, as we are able to use this tool
		tool_action(user)


//This is used to make sure that are extraction tool is able to be used by the player
/obj/item/extraction/proc/tool_checks(mob/user)
	//First we check if they are a extraction Officer
	if(user?.mind?.assigned_role != "Extraction Officer")
		//We were not the EO so give feedback and fail the check
		to_chat(user, span_warning("You cannot use this!"))
		return FALSE
	//We passed the checks thus we return true
	return TRUE

//Base proc for tool actions, this is also where we display the cooldown
/obj/item/extraction/proc/tool_action(mob/user)
	return
