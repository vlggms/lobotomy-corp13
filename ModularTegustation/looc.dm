//looc ported from citadel and fulp
GLOBAL_VAR_INIT(LOOC_COLOR, "#e597e8")//If this is null, use the CSS for OOC. Otherwise, use a custom colour.
GLOBAL_VAR_INIT(normal_looc_colour, "#e597e8")

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger(" Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger(" You have OOC muted."))
		return

	if(!holder)
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger(" You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(mob.stat)
			to_chat(src, span_danger("You cannot use LOOC while unconscious or dead."))
			return
		if(isdead(mob))
			to_chat(src, span_danger("You cannot use LOOC while ghosting."))
			return
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger("You have been banned from OOC."))
		return
	if(QDELETED(src))
		return

	msg = emoji_parse(msg)

	if(SSticker.HasRoundStarted() && (msg[1] in list(".",";",":","#") || findtext_char(msg, "say", 1, 5)))
		if(alert("Your message \"[msg]\" looks like it was meant for in game communication, say it in LOOC?", "Meant for LOOC?", "Yes", "No") != "Yes")
			return

	mob.log_talk(msg,LOG_OOC, tag="LOOC")

	var/list/heard = get_hearers_in_view(7, src.mob.get_top_level_mob())
	for(var/mob/M in heard)
		if(!M.client)
			continue
		var/client/C = M.client
		if (C in GLOB.admins)
			continue //they are handled after that

		if (isobserver(M))
			continue //Also handled later.

		if(C.prefs.chat_toggles & CHAT_OOC)
			if(GLOB.LOOC_COLOR)
				to_chat(C, "<font color='[GLOB.LOOC_COLOR]'><b><span class='prefix'>LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span></b></font>", type = MESSAGE_TYPE_LOOC)
			else
				to_chat(C, span_looc("<span class='prefix'>LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]</span>"), type = MESSAGE_TYPE_LOOC)

	for(var/client/C in GLOB.admins)
		if(C.prefs.chat_toggles & CHAT_OOC)
			var/prefix = "(R)LOOC"
			if (C.mob in heard)
				prefix = "LOOC"
			if(GLOB.LOOC_COLOR)
				to_chat(C, "<font color='[GLOB.LOOC_COLOR]'><b>[ADMIN_FLW(usr)] <span class='prefix'>[prefix]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span></b></font>", type = MESSAGE_TYPE_LOOC)
			else
				to_chat(C, span_looc("[ADMIN_FLW(usr)] <span class='prefix'>[prefix]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span>"), type = MESSAGE_TYPE_LOOC)


/mob/proc/get_top_level_mob()
	if(istype(src.loc, /mob) && src.loc != src)
		var/mob/M = src.loc
		return M.get_top_level_mob()
	return src
