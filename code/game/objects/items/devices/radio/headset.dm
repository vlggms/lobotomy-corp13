// Used for translating channels to tokens on examination
GLOBAL_LIST_INIT(channel_tokens, list(
	RADIO_CHANNEL_COMMON = RADIO_KEY_COMMON,
	RADIO_CHANNEL_CONTROL = RADIO_TOKEN_CONTROL,
	RADIO_CHANNEL_INFORMATION = RADIO_TOKEN_INFORMATION,
	RADIO_CHANNEL_SAFETY = RADIO_TOKEN_SAFETY,
	RADIO_CHANNEL_TRAINING = RADIO_TOKEN_TRAINING,
	RADIO_CHANNEL_COMMAND = RADIO_TOKEN_COMMAND,
	RADIO_CHANNEL_WELFARE = RADIO_TOKEN_WELFARE,
	RADIO_CHANNEL_DISCIPLINE = RADIO_TOKEN_DISCIPLINE,
	RADIO_CHANNEL_ARCHITECTURE = RADIO_TOKEN_ARCHITECTURE,
	RADIO_CHANNEL_HEAD = RADIO_TOKEN_HEAD,
	RADIO_CHANNEL_CENTCOM = RADIO_TOKEN_CENTCOM,
	RADIO_CHANNEL_SYNDICATE = RADIO_TOKEN_SYNDICATE,
	MODE_BINARY = MODE_TOKEN_BINARY,
	RADIO_CHANNEL_AI_PRIVATE = RADIO_TOKEN_AI_PRIVATE
))

/obj/item/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys, but only a few."
	icon_state = "headset"
	inhand_icon_state = "headset"
	worn_icon_state = null
	custom_materials = list(/datum/material/iron=75)
	subspace_transmission = TRUE
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = ITEM_SLOT_EARS
	var/obj/item/encryptionkey/keyslot2 = null
	dog_fashion = null

/obj/item/radio/headset/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins putting \the [src]'s antenna up [user.p_their()] nose! It looks like [user.p_theyre()] trying to give [user.p_them()]self cancer!</span>")
	return TOXLOSS

/obj/item/radio/headset/examine(mob/user)
	. = ..()

	if(item_flags & IN_INVENTORY && loc == user)
		// construction of frequency description
		var/list/avail_chans = list("Use [RADIO_KEY_COMMON] for the currently tuned frequency")
		if(translate_binary)
			avail_chans += "use [MODE_TOKEN_BINARY] for [MODE_BINARY]"
		if(length(channels))
			for(var/i in 1 to length(channels))
				if(i == 1)
					avail_chans += "use [MODE_TOKEN_DEPARTMENT] or [GLOB.channel_tokens[channels[i]]] for [lowertext(channels[i])]"
				else
					avail_chans += "use [GLOB.channel_tokens[channels[i]]] for [lowertext(channels[i])]"
		. += "<span class='notice'>A small screen on the headset displays the following available frequencies:\n[english_list(avail_chans)].</span>"

		if(command)
			. += "<span class='info'>Alt-click to toggle the high-volume mode.</span>"
	else
		. += "<span class='notice'>A small screen on the headset flashes, it's too small to read without holding or wearing the headset.</span>"

/obj/item/radio/headset/Initialize()
	. = ..()
	recalculateChannels()

/obj/item/radio/headset/Destroy()
	QDEL_NULL(keyslot2)
	return ..()

/obj/item/radio/headset/talk_into(mob/living/M, message, channel, list/spans, datum/language/language, list/message_mods)
	if (!listening)
		return ITALICS | REDUCE_RANGE
	return ..()

/obj/item/radio/headset/can_receive(freq, level, AIuser)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.ears == src)
			return ..(freq, level)
	else if(AIuser)
		return ..(freq, level)
	return FALSE

/obj/item/radio/headset/ui_data(mob/user)
	. = ..()
	.["headset"] = TRUE

/obj/item/radio/headset/alt
	name = "bowman headset"
	desc = "An updated, modular intercom that fits over the head. Protect ears from flashbangs. Takes encryption keys, but only a few."
	icon_state = "headset_alt"
	inhand_icon_state = "headset_alt"

/obj/item/radio/headset/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/syndicate //disguised to look like a normal headset for stealth ops

/obj/item/radio/headset/syndicate/alt //undisguised bowman with flash protection
	name = "syndicate headset"
	desc = "A syndicate headset that can be used to hear all radio frequencies. Protects ears from flashbangs."
	icon_state = "syndie_headset"
	inhand_icon_state = "syndie_headset"

/obj/item/radio/headset/syndicate/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/syndicate/alt/leader
	name = "team leader headset"
	command = TRUE

/obj/item/radio/headset/syndicate/Initialize()
	. = ..()
	make_syndie()

/obj/item/radio/headset/binary
/obj/item/radio/headset/binary/Initialize()
	. = ..()
	qdel(keyslot)
	keyslot = new /obj/item/encryptionkey/binary
	recalculateChannels()

/obj/item/radio/headset/headset_control
	name = "control radio headset"
	desc = "This is used by the control department."
	icon_state = "cargo_headset"
	keyslot = new /obj/item/encryptionkey/headset_control

/obj/item/radio/headset/headset_information
	name = "information radio headset"
	desc = "This is used by the information department."
	icon_state = "sci_headset"
	keyslot = new /obj/item/encryptionkey/headset_information

/obj/item/radio/headset/headset_safety
	name = "safety radio headset"
	desc = "This is used by the safety department."
	icon_state = "cent_headset"
	keyslot = new /obj/item/encryptionkey/headset_safety

/obj/item/radio/headset/headset_training
	name = "training radio headset"
	desc = "This is used by the training department."
	icon_state = "rob_headset"
	keyslot = new /obj/item/encryptionkey/headset_training

/obj/item/radio/headset/headset_command
	name = "central radio headset"
	desc = "This is used by the central command department."
	icon_state = "eng_headset"
	keyslot = new /obj/item/encryptionkey/headset_command

/obj/item/radio/headset/headset_welfare
	name = "welfare radio headset"
	desc = "This is used by the welfare department."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/headset_welfare

/obj/item/radio/headset/headset_discipline
	name = "disciplinary headset"
	desc = "This is used by the disciplinary department."
	icon_state = "sec_headset"
	keyslot = new /obj/item/encryptionkey/headset_discipline

/obj/item/radio/headset/headset_extraction
	name = "extraction headset"
	desc = "This is used by the extraction department."
	icon_state = "extraction_headset"
	//keyslot = new /obj/item/encryptionkey/headset_extraction //Waiting for someone to add in radio channels for them because i cannot find a way to add it in.

/obj/item/radio/headset/headset_records
	name = "records headset"
	desc = "This is used by the records department."
	icon_state = "records_headset"
	//keyslot = new /obj/item/encryptionkey/headset_records

/obj/item/radio/headset/headset_architecture
	name = "architecture headset"
	desc = "A headset used by the mysterious architecture department. Is that a thing?"
	icon_state = "med_headset"
	keyslot = new /obj/item/encryptionkey/headset_architecture

/obj/item/radio/headset/headset_com
	name = "command headset"
	desc = "This is used by the central command department."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/headset_command

/obj/item/radio/headset/heads
	command = TRUE
	keyslot = new /obj/item/encryptionkey/headset_architecture

/obj/item/radio/headset/agent_lieutenant
	name = "\proper the lieutenant's headset"
	desc = "A headset used by agents in Lobotomy Corporation who have earned the rank of captain."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/agent_lieutenant

/obj/item/radio/headset/heads/agent_captain
	name = "\proper the captain's headset"
	desc = "A headset used by agents in Lobotomy Corporation who have earned the rank of captain."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/agent_captain

/obj/item/radio/headset/heads/agent_captain/alt
	name = "\proper the captain's bowman headset"
	desc = "A headset used by agents in Lobotomy Corporation who have earned the rank of captain. Protects ears from flashbangs."
	icon_state = "com_headset_alt"
	inhand_icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/agent_captain/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/heads/manager
	name = "\proper the manager's headset"
	desc = "The headset of the manager of a Lobotomy Corporation facility."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/manager

/obj/item/radio/headset/heads/manager/alt
	name = "\proper the manager's bowman headset"
	desc = "The headset of the manager of a Lobotomy Corporation facility. Protects ears from flashbangs."
	icon_state = "com_headset_alt"
	inhand_icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/manager/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/headset_head
	name = "\improper Head headset"
	desc = "A headset used by the A-Corporation."
	icon_state = "head_headset"
	keyslot = new /obj/item/encryptionkey/headset_head

/obj/item/radio/headset/headset_head/alt
	name = "\improper Head bowman headset"
	icon_state = "head_headset_alt"

/obj/item/radio/headset/headset_head/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/headset_cent
	name = "\improper R-Corporation headset"
	desc = "A headset used by the upper echelons of R-Corporation, a powerful private security corporation."
	icon_state = "cent_headset"
	keyslot = new /obj/item/encryptionkey/heads/manager
	keyslot2 = new /obj/item/encryptionkey/headset_cent

/obj/item/radio/headset/headset_cent/empty
	keyslot = null
	keyslot2 = null

/obj/item/radio/headset/headset_cent/commander
	keyslot = new /obj/item/encryptionkey/heads/manager

/obj/item/radio/headset/headset_cent/alt
	name = "\improper R-Corporation bowman headset"
	desc = "A headset especially for emergency response personnel from R-Corporation."
	icon_state = "cent_headset_alt"
	inhand_icon_state = "cent_headset_alt"
	keyslot = null

/obj/item/radio/headset/headset_cent/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/silicon/pai
	name = "\proper mini Integrated Subspace Transceiver "
	subspace_transmission = FALSE


/obj/item/radio/headset/silicon/ai
	name = "\proper Integrated Subspace Transceiver "
	keyslot2 = new /obj/item/encryptionkey/ai
	command = TRUE

/obj/item/radio/headset/silicon/can_receive(freq, level)
	return ..(freq, level, TRUE)

//Department heads

/obj/item/radio/headset/heads/headset_control
	name = "control radio headset"
	desc = "This is used by the control department."
	icon_state = "cargo_headset"
	keyslot = new /obj/item/encryptionkey/heads/headset_control

/obj/item/radio/headset/heads/headset_information
	name = "information radio headset"
	desc = "This is used by the information department."
	icon_state = "sci_headset"
	keyslot = new /obj/item/encryptionkey/heads/headset_information

/obj/item/radio/headset/heads/headset_safety
	name = "safety radio headset"
	desc = "This is used by the safety department."
	icon_state = "cent_headset"
	keyslot = new /obj/item/encryptionkey/heads/headset_safety

/obj/item/radio/headset/heads/headset_training
	name = "training radio headset"
	desc = "This is used by the training department."
	icon_state = "rob_headset"
	keyslot = new /obj/item/encryptionkey/heads/headset_training

/obj/item/radio/headset/heads/headset_welfare
	name = "welfare radio headset"
	desc = "This is used by the welfare department."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/headset_welfare

/obj/item/radio/headset/heads/headset_discipline
	name = "disciplinary headset"
	desc = "This is used by the disciplinary department."
	icon_state = "sec_headset"
	keyslot = new /obj/item/encryptionkey/heads/headset_discipline

//Assciation stuff
/obj/item/radio/headset/heads/headset_association
	name = "association director headset"
	desc = "This is used by the local association director."
	icon_state = "cent_headset"
	keyslot = new /obj/item/encryptionkey/headset_cent

/obj/item/radio/headset/headset_cent
	name = "association headset"
	desc = "This is used by the local association."
	icon_state = "cent_headset"
	keyslot = new /obj/item/encryptionkey/headset_cent



/obj/item/radio/headset/attackby(obj/item/W, mob/user, params)
	user.set_machine(src)

	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(keyslot || keyslot2)
			for(var/ch_name in channels)
				SSradio.remove_object(src, GLOB.radiochannels[ch_name])
				secure_radio_connections[ch_name] = null

			if(keyslot)
				user.put_in_hands(keyslot)
				keyslot = null
			if(keyslot2)
				user.put_in_hands(keyslot2)
				keyslot2 = null

			recalculateChannels()
			to_chat(user, "<span class='notice'>You pop out the encryption keys in the headset.</span>")

		else
			to_chat(user, "<span class='warning'>This headset doesn't have any unique encryption keys! How useless...</span>")

	else if(istype(W, /obj/item/encryptionkey))
		if(keyslot && keyslot2)
			to_chat(user, "<span class='warning'>The headset can't hold another key!</span>")
			return

		if(!keyslot)
			if(!user.transferItemToLoc(W, src))
				return
			keyslot = W

		else
			if(!user.transferItemToLoc(W, src))
				return
			keyslot2 = W


		recalculateChannels()
	else
		return ..()


/obj/item/radio/headset/recalculateChannels()
	..()
	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(!(ch_name in src.channels))
				channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			translate_binary = TRUE
		if(keyslot2.syndie)
			syndie = TRUE
		if (keyslot2.independent)
			independent = TRUE

	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = add_radio(src, GLOB.radiochannels[ch_name])

/obj/item/radio/headset/AltClick(mob/living/user)
	if(!istype(user) || !Adjacent(user) || user.incapacitated())
		return
	if (command)
		use_command = !use_command
		to_chat(user, "<span class='notice'>You toggle high-volume mode [use_command ? "on" : "off"].</span>")



