//Speech verbs.

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = TRUE

	create_typing_indicator()
	window_typing = TRUE
	var/message = input("", "Say \"text\"") as null|text

	window_typing = FALSE
	remove_typing_indicator()


	if(message)
		say_verb(message)

///Say verb
/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	if(message)
		say(message)

///Whisper verb
/mob/verb/whisper_verb(message as text)
	set name = "Whisper"
	set category = "IC"
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	whisper(message)

///whisper a message
/mob/proc/whisper(message, datum/language/language=null)
	say(message, language) //only living mobs actually whisper, everything else just talks

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = TRUE

	create_typing_indicator()
	window_typing = TRUE

	var/message = input("", "Me \"text\"") as null|text

	window_typing = FALSE
	remove_typing_indicator()

	if(message)
		me_verb(message)

///The me emote verb
/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))

	usr.emote("me",1,message,TRUE)

///Speak as a dead person (ghost etc)
/mob/proc/say_dead(message)
	var/name = real_name
	var/alt_name = ""

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	var/jb = is_banned_from(ckey, "Deadchat")
	if(QDELETED(src))
		return

	if(jb)
		to_chat(src, "<span class='danger'>You have been banned from deadchat.</span>")
		return



	if (src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, "<span class='danger'>You cannot talk in deadchat (muted).</span>")
			return

		if(src.client.handle_spam_prevention(message,MUTE_DEADCHAT))
			return

	var/mob/dead/observer/O = src
	if(isobserver(src) && O.deadchat_name)
		name = "[O.deadchat_name]"
	else
		if(mind?.name)
			name = "[mind.name]"
		else
			name = real_name
		if(name != real_name)
			alt_name = " (died as [real_name])"

	var/spanned = say_quote(message)
	var/source = "<span class='game'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span>[alt_name]"
	var/rendered = " <span class='message'>[emoji_parse(spanned)]</span></span>"
	log_talk(message, LOG_SAY, tag="DEAD")
	if(SEND_SIGNAL(src, COMSIG_MOB_DEADSAY, message) & MOB_DEADSAY_SIGNAL_INTERCEPT)
		return
	var/displayed_key = key
	if(client?.holder?.fakekey)
		displayed_key = null
	deadchat_broadcast(rendered, source, follow_target = src, speaker_key = displayed_key)

///Check if this message is an emote
/mob/proc/check_emote(message, forced)
	if(message[1] == "*")
		emote(copytext(message, length(message[1]) + 1), intentional = !forced)
		return TRUE

///Check if the mob has a hivemind channel
/mob/proc/hivecheck()
	return FALSE

///The amount of items we are looking for in the message
#define MESSAGE_MODS_LENGTH 6
/**
 * Extracts and cleans message of any extenstions at the begining of the message
 * Inserts the info into the passed list, returns the cleaned message
 *
 * Result can be
 * * SAY_MODE (Things like aliens, channels that aren't channels)
 * * MODE_WHISPER (Quiet speech)
 * * MODE_SING (Singing)
 * * MODE_HEADSET (Common radio channel)
 * * RADIO_EXTENSION the extension we're using (lots of values here)
 * * RADIO_KEY the radio key we're using, to make some things easier later (lots of values here)
 * * LANGUAGE_EXTENSION the language we're trying to use (lots of values here)
 */
/mob/proc/get_message_mods(message, list/mods)
	for(var/I in 1 to MESSAGE_MODS_LENGTH)
		// Prevents "...text" from being read as a radio message
		if (length(message) > 1 && message[2] == message[1])
			continue

		var/key = message[1]
		var/chop_to = 2 //By default we just take off the first char
		if(key == "#" && !mods[WHISPER_MODE])
			mods[WHISPER_MODE] = MODE_WHISPER
		else if(key == "%" && !mods[MODE_SING])
			mods[MODE_SING] = TRUE
		else if(key == ";" && !mods[MODE_HEADSET])
			if(stat == CONSCIOUS) //necessary indentation so it gets stripped of the semicolon anyway.
				mods[MODE_HEADSET] = TRUE
		else if((key in GLOB.department_radio_prefixes) && length(message) > length(key) + 1 && !mods[RADIO_EXTENSION])
			mods[RADIO_KEY] = lowertext(message[1 + length(key)])
			mods[RADIO_EXTENSION] = GLOB.department_radio_keys[mods[RADIO_KEY]]
			chop_to = length(key) + 2
		else if(key == "," && !mods[LANGUAGE_EXTENSION])
			for(var/ld in GLOB.all_languages)
				var/datum/language/LD = ld
				if(initial(LD.key) == message[1 + length(message[1])])
					// No, you cannot speak in xenocommon just because you know the key
					if(!can_speak_language(LD))
						return message
					mods[LANGUAGE_EXTENSION] = LD
					chop_to = length(key) + length(initial(LD.key)) + 1
			if(!mods[LANGUAGE_EXTENSION])
				return message
		else
			return message
		message = trim_left(copytext_char(message, chop_to))
		if(!message)
			return
	return message

#define TYPING_INDICATOR_RANGE 7

/mob/proc/typing_indicator_process()
	set waitfor = FALSE
	if(client)
		var/temp = winget(client, "input", "text")
		if(temp != last_typed)
			last_typed = temp
			last_typed_time = world.time
		if(world.time > last_typed_time + 10 SECONDS)
			bar_typing = FALSE
			remove_typing_indicator()
			return
		if(length(temp) > 5 && findtext(temp, "Say \"", 1, 7))
			create_typing_indicator()
			bar_typing = TRUE
		else if(length(temp) > 3 && findtext(temp, "Me ", 1, 5))
			//set_typing_indicator(1)
		else
			bar_typing = FALSE
			remove_typing_indicator()


/mob/proc/create_typing_indicator()
	set waitfor = FALSE
	if(typing_overlay)
		return
	if(stat)
		return
	var/list/listening = get_hearers_in_view(TYPING_INDICATOR_RANGE, src)
	speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client && M.client?.prefs.see_typing_indicator)
			speech_bubble_recipients.Add(M.client)
	var/bubble = "default"
	if(isliving(src))
		var/mob/living/L = src
		bubble = L.bubble_icon
	typing_overlay = image('icons/mob/talk.dmi', src, "[bubble]0", FLY_LAYER)
	typing_overlay.appearance_flags = APPEARANCE_UI
	typing_overlay.invisibility = invisibility
	typing_overlay.alpha = alpha
	for(var/client/C in speech_bubble_recipients)
		C.images += typing_overlay


/mob/proc/remove_typing_indicator()
	if(!typing_overlay)
		return
	if(window_typing || bar_typing)
		return
	for(var/client/C in speech_bubble_recipients)
		C.images -= typing_overlay
	typing_overlay = null
	speech_bubble_recipients = list()

/mob/camera/typing_indicator_process() //RIP in piece camera mobs
	return

/mob/camera/create_typing_indicator() //NGL, it'd be pretty fuckin terrifying to see a random speech bubble pop up
	return

/mob/camera/remove_typing_indicator()
	return


#undef TYPING_INDICATOR_RANGE
