/**
 * This proc gets called when a ghost drags themselfes onto an abnormality and passess several checks to make sure they can do that
 * This proc allows a ghost to take over an abnormality, mainly used in the playables events
 * Its called AFTER the admin proc to force ghosts into mobs, so admins will need to dead-min to access this like a player would
 *
 * Called by /mob/dead/observer/MouseDrop(atom/over)
 */

/datum/proc/try_take_abnormality(mob/dead/observer/possessing_player, mob/abnormality)
	if(!SSlobotomy_corp.enable_possession) // uhhhh, how did you even access this proc?
		to_chat(usr, span_userdanger("Abnormality possession is not enabled!"))
		message_admins(span_adminnotice("[possessing_player.key] has accessed the try_take_abnormality proc whilst possession is disabled."))
		return

	if(!possessing_player.ckey) // safety check
		to_chat(possessing_player, span_userdanger("You dont have a valid ckey, this should not show up!"))
		return

	if(abnormality.ckey)
		to_chat(possessing_player, span_userdanger("This abnormality already has a ghost in control of it, you can't possess it!"))
		return

	var/title = "Do you wish to possess this abnormality?"
	var/message = "Are you sure you want to possess [abnormality.name]?"

	var/ask = tgui_alert(usr, message, title, list("Yes", "No"))
	if(ask != "Yes")
		return

	if(!possessing_player || !abnormality) //make sure the mobs didnt get deleted while we waited for a response, else this could end badly
		return

	if(abnormality.ckey) // and then make sure someone wasnt faster than you
		to_chat(possessing_player, span_userdanger("This abnormality already has a ghost in control of it, seems like you were too slow!"))
		return

	message_admins(span_adminnotice("[possessing_player.key] has possessed [abnormality.name]."))
	log_admin("[possessing_player.key] has possessed [abnormality.name].")

	abnormality.key = possessing_player.key
	abnormality.client?.init_verbs()
	qdel(possessing_player)
