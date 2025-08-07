// Global tracking list for active livestreams
GLOBAL_LIST_EMPTY(active_selfie_sticks)

/obj/item/ego_weapon/city/cinqwest_selfiestick
	name = "cinqwest selfie stick"
	desc = "A selfie stick that can broadcast livestreams. Use in hand to toggle streaming or open chat."
	special = "Use in hand to toggle livestreaming mode or open chat window."
	icon_state = "cinqwest_selfie"
	force = 20
	damtype = RED_DAMAGE
	flags_1 = HEAR_1 // Can hear sounds to relay to viewers

	// Streaming variables
	var/streaming = FALSE
	var/mob/living/carbon/human/streamer = null
	var/list/viewers = list()

	// Chat variables
	var/list/chat_history = list()
	var/chat_window_id = null

/obj/item/ego_weapon/city/cinqwest_selfiestick/New()
	..()
	chat_window_id = "stream_chat_[REF(src)]"

// Toggle streaming or open chat
/obj/item/ego_weapon/city/cinqwest_selfiestick/attack_self(mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return

	// If already streaming and user is the streamer, open chat
	if(streaming && streamer == user)
		show_chat_window(user)
		return

	// Toggle streaming
	streaming = !streaming
	if(streaming)
		streamer = user
		GLOB.active_selfie_sticks += src
		to_chat(user, span_notice("You start livestreaming!"))
		playsound(src, 'sound/machines/terminal_on.ogg', 25, TRUE)

		// Open chat window for streamer
		show_chat_window(user)

		// Welcome message
		receive_chat(user, "System", "[user.name] started streaming!", 0)
	else
		GLOB.active_selfie_sticks -= src

		// Notify viewers stream is ending
		receive_chat(user, "System", "Stream ending...", 0)

		// Disconnect all viewers
		for(var/obj/item/pda/P in viewers)
			P.stop_watching()
		viewers.Cut()

		// Close streamer's chat window
		if(user.client)
			user << browse(null, "window=[chat_window_id]")

		streamer = null
		chat_history.Cut()
		to_chat(user, span_notice("You stop livestreaming."))
		playsound(src, 'sound/machines/terminal_off.ogg', 25, TRUE)

// Handle incoming chat messages
/obj/item/ego_weapon/city/cinqwest_selfiestick/proc/receive_chat(mob/sender, nickname, message, donation_amount = 0)
	var/formatted_message
	var/timestamp = "[station_time_timestamp()]"

	if(donation_amount > 0)
		// Big donation message
		formatted_message = "<div style='background-color:#FFD700; padding:5px; margin:5px; border:2px solid #FFA500;'>"
		formatted_message += "<b>[timestamp] $ [nickname] donated [donation_amount] ahn:</b><br>"
		formatted_message += "<span style='font-size:1.2em;'>[message]</span></div>"

		// Sound effect for donations
		if(streamer)
			playsound(streamer, 'sound/machines/chime.ogg', 50, TRUE)
	else
		// Regular message
		formatted_message = "<div style='margin:2px;'>[timestamp] <b>[nickname]:</b> [message]</div>"

	// Add to history (keep last 50 messages)
	chat_history += formatted_message
	if(chat_history.len > 50)
		chat_history.Cut(1, 2)

	// Update all viewer windows
	update_chat_windows()

// Update all connected chat windows
/obj/item/ego_weapon/city/cinqwest_selfiestick/proc/update_chat_windows()
	// Update streamer's window
	if(streamer && streamer.client)
		show_chat_window(streamer)

	// Update all viewers' windows
	for(var/obj/item/pda/P in viewers)
		if(P.loc && ismob(P.loc))
			var/mob/M = P.loc
			if(M.client)
				show_chat_window(M)

// Show/refresh chat window
/obj/item/ego_weapon/city/cinqwest_selfiestick/proc/show_chat_window(mob/user)
	var/stream_name = streamer ? streamer.name : "Stream"
	var/viewer_count = num2text(viewers.len)
	var/html = "<html><head><title>Stream Chat</title>"
	html += "<style>"
	html += "body { background-color: #1a1a1a; color: #ffffff; font-family: monospace; margin: 5px; }"
	html += "#chatlog { height: 300px; overflow-y: scroll; border: 1px solid #444; padding: 5px; background-color: #0a0a0a; }"
	html += "#controls { margin-top: 10px; }"
	html += "input\[type='text'] { width: 70%; background-color: #333; color: #fff; border: 1px solid #666; padding: 3px; }"
	html += "input\[type='submit'] { background-color: #444; color: #fff; border: 1px solid #666; padding: 3px 10px; cursor: pointer; }"
	html += ".donation-controls { margin-top: 5px; }"
	html += "</style>"
	html += "<script>"
	html += "function scrollToBottom() { var chatlog = document.getElementById('chatlog'); chatlog.scrollTop = chatlog.scrollHeight; }"
	html += "</script>"
	html += "</head>"
	html += "<body onload='scrollToBottom()'>"
	html += "<h3>LIVE - [stream_name] ([viewer_count] viewers)</h3>"
	html += "<div id='chatlog'>"

	// Add chat history
	for(var/msg in chat_history)
		html += msg

	html += "</div>"
	html += "<div id='controls'>"
	html += "<form action='byond://'>"
	html += "<input type='hidden' name='src' value='[REF(src)]'>"
	html += "<input type='text' name='message' placeholder='Type a message...' maxlength='200'>"
	html += "<input type='submit' name='send_chat' value='Send'>"
	html += "</form>"
	html += "<div class='donation-controls'>"
	html += "<form action='byond://'>"
	html += "<input type='hidden' name='src' value='[REF(src)]'>"
	html += "<input type='text' name='donation_amount' placeholder='Amount' size='10'>"
	html += "<input type='text' name='donation_message' placeholder='Donation message...' maxlength='100'>"
	html += "<input type='submit' name='send_donation' value='Donate'>"
	html += "</form>"
	html += "</div>"
	html += "</div>"
	html += "</body>"
	html += "</html>"

	var/datum/browser/popup = new(user, chat_window_id, "Stream Chat", 500, 450)
	popup.set_content(html)
	popup.open()

// Handle Topic for chat interactions
/obj/item/ego_weapon/city/cinqwest_selfiestick/Topic(href, href_list)
	if(href_list["send_chat"])
		var/mob/user = usr
		var/message = strip_html(href_list["message"])
		if(!message || length(message) < 1)
			return

		// Get nickname
		var/nickname = user.name
		if(istype(user.loc, /obj/item/pda))
			var/obj/item/pda/P = user.loc
			if(P.stream_nickname)
				nickname = P.stream_nickname
		else if(user == streamer)
			nickname = "[user.name] (Streamer)"

		receive_chat(user, nickname, message)
		return

	if(href_list["send_donation"])
		var/mob/user = usr
		var/amount = text2num(href_list["donation_amount"])
		var/message = strip_html(href_list["donation_message"])

		if(!amount || amount <= 0)
			to_chat(user, span_warning("Invalid donation amount!"))
			return

		// Check if user has a bank account
		var/obj/item/card/id/id_card
		if(istype(user.loc, /obj/item/pda))
			var/obj/item/pda/P = user.loc
			id_card = P.id
		else if(ishuman(user))
			var/mob/living/carbon/human/H = user
			id_card = H.get_idcard(TRUE)

		if(!id_card || !id_card.registered_account)
			to_chat(user, span_warning("No bank account found!"))
			return

		if(id_card.registered_account.account_balance < amount)
			to_chat(user, span_warning("Insufficient funds!"))
			return

		// Find streamer's bank account
		var/obj/item/card/id/streamer_id = streamer.get_idcard(TRUE)
		if(!streamer_id || !streamer_id.registered_account)
			to_chat(user, span_warning("Streamer has no bank account!"))
			return

		// Transfer money
		id_card.registered_account.adjust_money(-amount)
		streamer_id.registered_account.adjust_money(amount)

		// Get nickname
		var/nickname = user.name
		if(istype(user.loc, /obj/item/pda))
			var/obj/item/pda/P = user.loc
			if(P.stream_nickname)
				nickname = P.stream_nickname

		// Send donation message
		receive_chat(user, nickname, message, amount)

		// Notify users
		to_chat(user, span_notice("You donated [amount] ahn!"))
		to_chat(streamer, span_nicegreen("[nickname] donated [amount] ahn!"))

// Clean up on deletion
/obj/item/ego_weapon/city/cinqwest_selfiestick/Destroy()
	if(streaming)
		GLOB.active_selfie_sticks -= src
		for(var/obj/item/pda/P in viewers)
			P.stop_watching()
	return ..()

// Handle being dropped
/obj/item/ego_weapon/city/cinqwest_selfiestick/dropped(mob/user)
	..()
	if(streaming)
		attack_self(user) // Turn off streaming when dropped

// Relay sounds and speech to all viewers
/obj/item/ego_weapon/city/cinqwest_selfiestick/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	if(!streaming || !viewers.len)
		return

	// Relay the message to all viewers
	for(var/obj/item/pda/P in viewers)
		if(!P.loc || !ismob(P.loc))
			continue
		var/mob/M = P.loc
		if(!M.client)
			continue

		// Don't relay to the viewer if they are the speaker (to prevent hearing themselves twice)
		if(speaker == M)
			continue

		// Send the message to the viewer as if they heard it from the selfie stick location
		// Add a small indicator that this is from the stream
		var/stream_prefix = "<span class='notice'>\[STREAM\]</span> "
		M.Hear(stream_prefix + message, speaker, message_language, raw_message, radio_freq, spans, message_mods)
