/obj/item/encryptionkey
	name = "standard encryption key"
	desc = "An encryption key for a radio headset."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	w_class = WEIGHT_CLASS_TINY
	var/translate_binary = FALSE
	var/syndie = FALSE
	var/independent = FALSE
	var/list/channels = list()

/obj/item/encryptionkey/Initialize()
	. = ..()
	if(!channels.len)
		desc = "An encryption key for a radio headset.  Has no special codes in it. You should probably tell a coder!"

/obj/item/encryptionkey/examine(mob/user)
	. = ..()
	if(LAZYLEN(channels))
		var/list/examine_text_list = list()
		for(var/i in channels)
			examine_text_list += "[GLOB.channel_tokens[i]] - [lowertext(i)]"

		. += "<span class='notice'>It can access the following channels; [jointext(examine_text_list, ", ")].</span>"

/obj/item/encryptionkey/syndicate
	name = "syndicate encryption key"
	icon_state = "syn_cypherkey"
	channels = list(RADIO_CHANNEL_SYNDICATE = 1)
	syndie = TRUE//Signifies that it de-crypts Syndicate transmissions

/obj/item/encryptionkey/binary
	name = "binary translator key"
	icon_state = "bin_cypherkey"
	translate_binary = TRUE

/obj/item/encryptionkey/headset_control
	name = "control radio encryption key"
	icon_state = "cargo_cypherkey"
	channels = list(RADIO_CHANNEL_CONTROL = 1)

/obj/item/encryptionkey/headset_information
	name = "information radio encryption key"
	icon_state = "sci_cypherkey"
	channels = list(RADIO_CHANNEL_INFORMATION = 1)

/obj/item/encryptionkey/headset_safety
	name = "safety radio encryption key"
	icon_state = "bin_cypherkey"
	channels = list(RADIO_CHANNEL_SAFETY = 1)

/obj/item/encryptionkey/headset_training
	name = "training radio encryption key"
	icon_state = "rob_cypherkey"
	channels = list(RADIO_CHANNEL_TRAINING = 1)

/obj/item/encryptionkey/headset_command
	name = "command radio encryption key"
	icon_state = "ce_cypherkey"
	channels = list(RADIO_CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/headset_welfare
	name = "welfare radio encryption key"
	icon_state = "com_cypherkey"
	channels = list(RADIO_CHANNEL_WELFARE = 1)

/obj/item/encryptionkey/headset_discipline
	name = "discipline radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list(RADIO_CHANNEL_DISCIPLINE = 1)

/obj/item/encryptionkey/headset_architecture
	name = "architecture radio encryption key"
	icon_state = "srvmed_cypherkey"
	channels = list(RADIO_CHANNEL_ARCHITECTURE = 1)

/obj/item/encryptionkey/agent_lieutenant
	name = "\proper the agent captain's encryption key"
	icon_state = "cap_cypherkey"
	channels = list(
	RADIO_CHANNEL_CONTROL = 1, RADIO_CHANNEL_INFORMATION = 1, RADIO_CHANNEL_SAFETY = 1, RADIO_CHANNEL_TRAINING = 1, \
	RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_WELFARE = 1, RADIO_CHANNEL_DISCIPLINE = 1)


/obj/item/encryptionkey/heads/manager
	name = "\proper the manager's encryption key"
	icon_state = "cap_cypherkey"
	channels = list(
	RADIO_CHANNEL_CONTROL = 1, RADIO_CHANNEL_INFORMATION = 1, RADIO_CHANNEL_SAFETY = 1, RADIO_CHANNEL_TRAINING = 1, \
	RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_WELFARE = 1, RADIO_CHANNEL_DISCIPLINE = 1, RADIO_CHANNEL_ARCHITECTURE = 1)

/obj/item/encryptionkey/heads/agent_captain
	name = "\proper the agent captain's encryption key"
	icon_state = "cap_cypherkey"
	channels = list(
	RADIO_CHANNEL_CONTROL = 1, RADIO_CHANNEL_INFORMATION = 1, RADIO_CHANNEL_SAFETY = 1, RADIO_CHANNEL_TRAINING = 1, \
	RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_WELFARE = 1, RADIO_CHANNEL_DISCIPLINE = 1)

/obj/item/encryptionkey/headset_cent
	name = "\improper CentCom radio encryption key"
	icon_state = "cent_cypherkey"
	independent = TRUE
	channels = list(RADIO_CHANNEL_CENTCOM = 1)

/obj/item/encryptionkey/headset_head
	name = "\improper Head radio encryption key"
	icon_state = "head_cypherkey"
	independent = TRUE
	channels = list(RADIO_CHANNEL_HEAD = 1)

/obj/item/encryptionkey/ai //ported from NT, this goes 'inside' the AI.
	channels = list(RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_SECURITY = 1, RADIO_CHANNEL_ENGINEERING = 1, RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_MEDICAL = 1, RADIO_CHANNEL_SUPPLY = 1, RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_AI_PRIVATE = 1)

/obj/item/encryptionkey/secbot
	channels = list(RADIO_CHANNEL_AI_PRIVATE = 1, RADIO_CHANNEL_SECURITY = 1)


//Department heads
/obj/item/encryptionkey/heads/headset_control
	name = "control radio encryption key"
	icon_state = "cargo_cypherkey"
	channels = list(RADIO_CHANNEL_CONTROL = 1, RADIO_CHANNEL_ARCHITECTURE = 1)

/obj/item/encryptionkey/heads/headset_information
	name = "information radio encryption key"
	icon_state = "sci_cypherkey"
	channels = list(RADIO_CHANNEL_INFORMATION = 1, RADIO_CHANNEL_ARCHITECTURE = 1)

/obj/item/encryptionkey/heads/headset_safety
	name = "safety radio encryption key"
	icon_state = "bin_cypherkey"
	channels = list(RADIO_CHANNEL_SAFETY = 1, RADIO_CHANNEL_ARCHITECTURE = 1)

/obj/item/encryptionkey/heads/headset_training
	name = "training radio encryption key"
	icon_state = "rob_cypherkey"
	channels = list(RADIO_CHANNEL_TRAINING = 1, RADIO_CHANNEL_ARCHITECTURE = 1)

/obj/item/encryptionkey/heads/headset_welfare
	name = "welfare radio encryption key"
	icon_state = "com_cypherkey"
	channels = list(RADIO_CHANNEL_WELFARE = 1, RADIO_CHANNEL_ARCHITECTURE = 1)

/obj/item/encryptionkey/heads/headset_discipline
	name = "discipline radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list(RADIO_CHANNEL_DISCIPLINE = 1, RADIO_CHANNEL_ARCHITECTURE = 1)
