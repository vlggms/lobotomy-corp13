#define HOLOPAD_MAX_DIAL_TIME 200

#define HOLORECORD_DELAY	"delay"
#define HOLORECORD_SAY		"say"
#define HOLORECORD_SOUND	"sound"
#define HOLORECORD_LANGUAGE	"lang"
#define HOLORECORD_PRESET	"preset"
#define HOLORECORD_RENAME "rename"

#define HOLORECORD_MAX_LENGTH 200

/mob/camera/ai_eye/remote/holo/setLoc()
	. = ..()
	var/obj/machinery/holopad/H = origin
	H?.move_hologram(eye_user, loc)

/obj/machinery/holopad/remove_eye_control(mob/living/user)
	if(user.client)
		user.reset_perspective(null)
	user.remote_control = null

//this datum manages it's own references

/datum/holocall
	var/mob/living/user	//the one that called
	var/obj/machinery/holopad/calling_holopad	//the one that sent the call
	var/obj/machinery/holopad/connected_holopad	//the one that answered the call (may be null)
	var/list/dialed_holopads	//all things called, will be cleared out to just connected_holopad once answered

	var/mob/camera/ai_eye/remote/holo/eye	//user's eye, once connected
	var/obj/effect/overlay/holo_pad_hologram/hologram	//user's hologram, once connected
	var/datum/action/innate/end_holocall/hangup	//hangup action

	var/call_start_time
	var/head_call = FALSE //calls from a head of staff autoconnect, if the receiving pad is not secure.

//creates a holocall made by `caller` from `calling_pad` to `callees`
/datum/holocall/New(mob/living/caller, obj/machinery/holopad/calling_pad, list/callees, elevated_access = FALSE)
	call_start_time = world.time
	user = caller
	calling_pad.outgoing_call = src
	calling_holopad = calling_pad
	head_call = elevated_access
	dialed_holopads = list()

	for(var/I in callees)
		var/obj/machinery/holopad/H = I
		if(!QDELETED(H) && H.is_operational)
			dialed_holopads += H
			if(head_call)
				if(H.secure)
					calling_pad.say("Auto-connection refused, falling back to call mode.")
					H.say("Incoming call.")
				else
					H.say("Incoming connection.")
			else
				H.say("Incoming call.")
			LAZYADD(H.holo_calls, src)

	if(!dialed_holopads.len)
		calling_pad.say("Connection failure.")
		qdel(src)
		return

	testing("Holocall started")

//cleans up ALL references :)
/datum/holocall/Destroy()
	QDEL_NULL(hangup)

	if(!QDELETED(eye))
		QDEL_NULL(eye)

	if(connected_holopad && !QDELETED(hologram))
		hologram = null
		connected_holopad.clear_holo(user)

	user = null

	//Hologram survived holopad destro
	if(!QDELETED(hologram))
		hologram.HC = null
		QDEL_NULL(hologram)

	for(var/I in dialed_holopads)
		var/obj/machinery/holopad/H = I
		LAZYREMOVE(H.holo_calls, src)
	dialed_holopads.Cut()

	if(calling_holopad)
		calling_holopad.calling = FALSE
		calling_holopad.outgoing_call = null
		calling_holopad.SetLightsAndPower()
		calling_holopad = null
	if(connected_holopad)
		connected_holopad.SetLightsAndPower()
		connected_holopad = null

	testing("Holocall destroyed")

	return ..()

//Gracefully disconnects a holopad `H` from a call. Pads not in the call are ignored. Notifies participants of the disconnection
/datum/holocall/proc/Disconnect(obj/machinery/holopad/H)
	testing("Holocall disconnect")
	if(H == connected_holopad)
		var/area/A = get_area(connected_holopad)
		calling_holopad.say("[A] holopad disconnected.")
	else if(H == calling_holopad && connected_holopad)
		connected_holopad.say("[user] disconnected.")

	ConnectionFailure(H, TRUE)

//Forcefully disconnects a holopad `H` from a call. Pads not in the call are ignored.
/datum/holocall/proc/ConnectionFailure(obj/machinery/holopad/H, graceful = FALSE)
	testing("Holocall connection failure: graceful [graceful]")
	if(H == connected_holopad || H == calling_holopad)
		if(!graceful && H != calling_holopad)
			calling_holopad.say("Connection failure.")
		qdel(src)
		return

	LAZYREMOVE(H.holo_calls, src)
	dialed_holopads -= H
	if(!dialed_holopads.len)
		if(graceful)
			calling_holopad.say("Call rejected.")
		testing("No recipients, terminating")
		qdel(src)

//Answers a call made to a holopad `H` which cannot be the calling holopad. Pads not in the call are ignored
/datum/holocall/proc/Answer(obj/machinery/holopad/H)
	testing("Holocall answer")
	if(H == calling_holopad)
		CRASH("How cute, a holopad tried to answer itself.")

	if(!(H in dialed_holopads))
		return

	if(connected_holopad)
		CRASH("Multi-connection holocall")

	for(var/I in dialed_holopads)
		if(I == H)
			continue
		Disconnect(I)

	for(var/I in H.holo_calls)
		var/datum/holocall/HC = I
		if(HC != src)
			HC.Disconnect(H)

	connected_holopad = H

	if(!Check())
		return

	calling_holopad.calling = FALSE
	hologram = H.activate_holo(user)
	hologram.HC = src

	//eyeobj code is horrid, this is the best copypasta I could make
	eye = new
	eye.origin = H
	eye.eye_initialized = TRUE
	eye.eye_user = user
	eye.name = "Camera Eye ([user.name])"
	user.remote_control = eye
	user.reset_perspective(eye)
	eye.setLoc(H.loc)

	hangup = new(eye, src)
	hangup.Grant(user)
	playsound(H, 'sound/machines/ping.ogg', 100)
	H.say("Connection established.")

//Checks the validity of a holocall and qdels itself if it's not. Returns TRUE if valid, FALSE otherwise
/datum/holocall/proc/Check()
	for(var/I in dialed_holopads)
		var/obj/machinery/holopad/H = I
		if(!H.is_operational)
			ConnectionFailure(H)

	if(QDELETED(src))
		return FALSE

	. = !QDELETED(user) && !user.incapacitated() && !QDELETED(calling_holopad) && calling_holopad.is_operational && user.loc == calling_holopad.loc

	if(.)
		if(!connected_holopad)
			. = world.time < (call_start_time + HOLOPAD_MAX_DIAL_TIME)
			if(!.)
				calling_holopad.say("No answer received.")

	if(!.)
		testing("Holocall Check fail")
		qdel(src)

/datum/action/innate/end_holocall
	name = "End Holocall"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"
	var/datum/holocall/hcall

/datum/action/innate/end_holocall/New(Target, datum/holocall/HC)
	..()
	hcall = HC

/datum/action/innate/end_holocall/Activate()
	hcall.Disconnect(hcall.calling_holopad)


//RECORDS
/datum/holorecord
	var/caller_name = "Unknown" //Caller name
	var/image/caller_image
	var/list/entries = list()
	var/language = /datum/language/common //Initial language, can be changed by HOLORECORD_LANGUAGE entries

/datum/holorecord/proc/set_caller_image(mob/user)
	var/olddir = user.dir
	user.setDir(SOUTH)
	caller_image = image(user)
	user.setDir(olddir)

/obj/item/disk/holodisk
	name = "holorecord disk"
	desc = "Stores recorder holocalls."
	icon_state = "holodisk"
	obj_flags = UNIQUE_RENAME
	custom_materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	var/datum/holorecord/record
	//Preset variables
	var/preset_image_type
	var/preset_record_text

/obj/item/disk/holodisk/Initialize(mapload)
	. = ..()
	if(preset_record_text)
		INVOKE_ASYNC(src, .proc/build_record)

/obj/item/disk/holodisk/Destroy()
	QDEL_NULL(record)
	return ..()

/obj/item/disk/holodisk/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/disk/holodisk))
		var/obj/item/disk/holodisk/holodiskOriginal = W
		if (holodiskOriginal.record)
			if (!record)
				record = new
			record.caller_name = holodiskOriginal.record.caller_name
			record.caller_image = holodiskOriginal.record.caller_image
			record.entries = holodiskOriginal.record.entries.Copy()
			record.language = holodiskOriginal.record.language
			to_chat(user, "<span class='notice'>You copy the record from [holodiskOriginal] to [src] by connecting the ports!</span>")
			name = holodiskOriginal.name
		else
			to_chat(user, "<span class='warning'>[holodiskOriginal] has no record on it!</span>")
	..()

/obj/item/disk/holodisk/proc/build_record()
	record = new
	var/list/lines = splittext(preset_record_text,"\n")
	for(var/line in lines)
		var/prepared_line = trim(line)
		if(!length(prepared_line))
			continue
		var/splitpoint = findtext(prepared_line," ")
		if(!splitpoint)
			continue
		var/command = copytext(prepared_line, 1, splitpoint)
		var/value = copytext(prepared_line, splitpoint + length(prepared_line[splitpoint]))
		switch(command)
			if("DELAY")
				var/delay_value = text2num(value)
				if(!delay_value)
					continue
				record.entries += list(list(HOLORECORD_DELAY,delay_value))
			if("NAME")
				if(!record.caller_name)
					record.caller_name = value
				else
					record.entries += list(list(HOLORECORD_RENAME,value))
			if("SAY")
				record.entries += list(list(HOLORECORD_SAY,value))
			if("SOUND")
				record.entries += list(list(HOLORECORD_SOUND,value))
			if("LANGUAGE")
				var/lang_type = text2path(value)
				if(ispath(lang_type,/datum/language))
					record.entries += list(list(HOLORECORD_LANGUAGE,lang_type))
			if("PRESET")
				var/preset_type = text2path(value)
				if(ispath(preset_type,/datum/preset_holoimage))
					record.entries += list(list(HOLORECORD_PRESET,preset_type))
	if(!preset_image_type)
		record.caller_image = image('icons/mob/animal.dmi',"old")
	else
		var/datum/preset_holoimage/H = new preset_image_type
		record.caller_image = H.build_image()

//These build caller image from outfit and some additional data, for use by mappers for ruin holorecords
/datum/preset_holoimage
	var/nonhuman_mobtype //Fill this if you just want something nonhuman
	var/outfit_type
	var/species_type = /datum/species/human

/datum/preset_holoimage/proc/build_image()
	if(nonhuman_mobtype)
		if(nonhuman_mobtype == "angela")
			. = image('icons/mob/animal.dmi',"angela")
		else
			var/mob/living/L = nonhuman_mobtype
			. = image(initial(L.icon),initial(L.icon_state))
	else
		var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy("HOLODISK_PRESET")
		if(species_type)
			mannequin.set_species(species_type)
		if(outfit_type)
			mannequin.equipOutfit(outfit_type,TRUE)
		mannequin.setDir(SOUTH)
		COMPILE_OVERLAYS(mannequin)
		. = image(mannequin)
		unset_busy_human_dummy("HOLODISK_PRESET")

/obj/item/disk/holodisk/example
	preset_image_type = /datum/preset_holoimage/clown
	preset_record_text = {"
	NAME Clown
	DELAY 10
	SAY Why did the chaplain cross the maint ?
	DELAY 20
	SAY He wanted to get to the other side!
	SOUND clownstep
	DELAY 30
	LANGUAGE /datum/language/narsie
	SAY Helped him get there!
	DELAY 10
	SAY ALSO IM SECRETLY A GORILLA
	DELAY 10
	PRESET /datum/preset_holoimage/gorilla
	NAME Gorilla
	LANGUAGE /datum/language/common
	SAY OOGA
	DELAY 20"}

/datum/preset_holoimage/engineer
	outfit_type = /datum/outfit/job/engineer

/datum/preset_holoimage/engineer/rig
	outfit_type = /datum/outfit/job/engineer/gloved/rig

/datum/preset_holoimage/engineer/ce
	outfit_type = /datum/outfit/job/ce

/datum/preset_holoimage/engineer/ce/rig
	outfit_type = /datum/outfit/job/engineer/gloved/rig

/datum/preset_holoimage/engineer/atmos
	outfit_type = /datum/outfit/job/atmos

/datum/preset_holoimage/engineer/atmos/rig
	outfit_type = /datum/outfit/job/engineer/gloved/rig

/datum/preset_holoimage/researcher
	outfit_type = /datum/outfit/job/scientist

/datum/preset_holoimage/captain
	outfit_type = /datum/outfit/job/captain

/datum/preset_holoimage/nanotrasenprivatesecurity
	outfit_type = /datum/outfit/nanotrasensoldiercorpse2

/datum/preset_holoimage/gorilla
	nonhuman_mobtype = /mob/living/simple_animal/hostile/gorilla

/datum/preset_holoimage/corgi
	nonhuman_mobtype = /mob/living/simple_animal/pet/dog/corgi

/datum/preset_holoimage/clown
	outfit_type = /datum/outfit/job/clown

/datum/preset_holoimage/angela
	nonhuman_mobtype = "angela"

/obj/item/disk/holodisk/donutstation/whiteship
	name = "Blackbox Print-out #DS024"
	desc = "A holodisk containing the last viable recording of DS024's blackbox."
	preset_image_type = /datum/preset_holoimage/engineer/ce
	preset_record_text = {"
	NAME Geysr Shorthalt
	SAY Engine renovations complete and the ships been loaded. We all ready?
	DELAY 25
	PRESET /datum/preset_holoimage/engineer
	NAME Jacob Ullman
	SAY Lets blow this popsicle stand of a station.
	DELAY 20
	PRESET /datum/preset_holoimage/engineer/atmos
	NAME Lindsey Cuffler
	SAY Uh, sir? Shouldn't we call for a secondary shuttle? The bluespace drive on this thing made an awfully weird noise when we jumped here..
	DELAY 30
	PRESET /datum/preset_holoimage/engineer/ce
	NAME Geysr Shorthalt
	SAY Pah! Ship techie at the dock said to give it a good few kicks if it started acting up, let me just..
	DELAY 25
	SOUND punch
	SOUND sparks
	DELAY 10
	SOUND punch
	SOUND sparks
	DELAY 10
	SOUND punch
	SOUND sparks
	SOUND warpspeed
	DELAY 15
	PRESET /datum/preset_holoimage/engineer/atmos
	NAME Lindsey Cuffler
	SAY Uhh.. is it supposed to be doing that??
	DELAY 15
	PRESET /datum/preset_holoimage/engineer/ce
	NAME Geysr Shorthalt
	SAY See? Working as intended. Now, are we all ready?
	DELAY 10
	PRESET /datum/preset_holoimage/engineer
	NAME Jacob Ullman
	SAY Is it supposed to be glowing like that?
	DELAY 20
	SOUND explosion

	"}

/obj/item/disk/holodisk/ruin/snowengieruin
	name = "Blackbox Print-out #EB412"
	desc = "A holodisk containing the last moments of EB412. There's a bloody fingerprint on it."
	preset_image_type = /datum/preset_holoimage/engineer
	preset_record_text = {"
	NAME Dave Tundrale
	SAY Maria, how's Build?
	DELAY 10
	NAME Maria Dell
	PRESET /datum/preset_holoimage/engineer/atmos
	SAY It's fine, don't worry. I've got Plastic on it. And frankly, i'm kinda busy with, the, uhhm, incinerator.
	DELAY 30
	NAME Dave Tundrale
	PRESET /datum/preset_holoimage/engineer
	SAY Aight, wonderful. The science mans been kinda shit though. No RCDs-
	DELAY 20
	NAME Maria Dell
	PRESET /datum/preset_holoimage/engineer/atmos
	SAY Enough about your RCDs. They're not even that important, just bui-
	DELAY 15
	SOUND explosion
	DELAY 10
	SAY Oh, shit!
	DELAY 10
	PRESET /datum/preset_holoimage/engineer/atmos/rig
	LANGUAGE /datum/language/narsie
	NAME Unknown
	SAY RISE, MY LORD!!
	DELAY 10
	LANGUAGE /datum/language/common
	NAME Plastic
	PRESET /datum/preset_holoimage/engineer/rig
	SAY Fuck, fuck, fuck!
	DELAY 20
	SAY It's loose! CALL THE FUCKING SHUTT-
	DELAY 10
	PRESET /datum/preset_holoimage/corgi
	NAME Blackbox Automated Message
	SAY Connection lost. Dumping audio logs to disk.
	DELAY 50"}

//Tutorial Holodisks
/obj/item/disk/holodisk/tutorial
	preset_image_type = /datum/preset_holoimage/angela

/obj/item/disk/holodisk/tutorial/build_record()
	..()
	record.caller_name = "Angela"

/obj/item/disk/holodisk/tutorial/tutorialintro
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY Hello employee, I'd like to welcome you to the Lobotomy Corporation 13 Onboarding Program.
	DELAY 40
	SAY If you already know the basics of SS13 inventory and movement controls, take your backpack off and go under the plastic flaps.
	DELAY 45
	SAY Otherwise, move with WASD keys and head into the portal ahead.
	DELAY 30
	SAY If you are unable to move, you may need to hit TAB to enter hotkey mode. Check the text bar at the bottom of your screen to make sure it's not colored.
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/basicmechanic1
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY A key mechanic in SS13 is using the hands system to interact with objects. You have a left and right hand slot that can hold things.
	DELAY 40
	SAY You interact with the environment by clicking on objects with either an empty hand or an item inhand.
	DELAY 35
	SAY Try clicking on the nearby objects with an empty hand to see what they do. You'll need to be next to them to use them.
	DELAY 45
	SAY If you are currently holding an item and cannot interact with the objects, hit Q to drop the item.
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/basicmechanic2
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY This area will teach you the basics regarding item usage.
	DELAY 25
	SAY Pick items up with your active hand by clicking on them. You need to be next to the item to do so.
	DELAY 45
	SAY You can switch your active hand by pressing X. The active hand will have a border highlighting it.
	DELAY 45
	SAY Clicking on an item that is in your active hand or pressing Z will "use the item inhand".
	DELAY 40
	SAY If there are multiple items on a single tile, right-click or Alt+Click the tile to view all the items there.
	DELAY 50
	SAY Use Shift+Middle Click in order to point at things. This is useful in telling other players what you want them to look at.
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/basicmechanic3
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY This area will teach you the basics regarding inventory.
	DELAY 25
	SAY To see all your equipment slots, click on the backpack icon in the bottom left corner of your screen. Each slot can hold certain types of items.
	DELAY 50
	SAY Click on a slot or container while your active hand is holding an item to store that item.
	DELAY 40
	SAY Hitting E will equip the item from your active hand into an available slot.
	DELAY 40
	SAY Click on a held storage item with an empty hand to view its contents.
	DELAY 40
	SAY You can also do this by click-dragging the storage item onto your <span class='bold'>character</span>.
	DELAY 40
	SAY To unequip storage items such as your backpack, click-drag that item's sprite onto a hand slot.
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/basicmechanic4
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY Press T to talk.
	DELAY 20
	SAY To talk on the public radio channel, type ; before your speech like <span class='italics'>; Hello, World!</span>.
	DELAY 40
	SAY However, since we don't provide radio headsets to interns, this won't do anything.
	DELAY 30
	SAY Items like the microphone can modify how you talk when held. Test it out.
	DELAY 35
	SAY When you have finished familiarizing yourself with the controls, take your backpack off your back slot and return any items before continuing.
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/basicmechanic5
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY In order to examine objects and read their descriptions, right-click the object and select "Examine" in the dropdown menu.
	DELAY 45
	SAY You can also examine by doing Shift+Click on the item.
	DELAY 35
	SAY All the structures in this area are ones that you can move onto. To do so, Click-drag your character onto the <span class='bold'>object</span> while not moving.
	DELAY 50
	SAY Some objects such as the sleeper have shortcuts with specific functions. Examine them to find out what they can do.
	DELAY 45
	SAY After you have finished with the structures here, proceed by getting over the railing.
	DELAY 35"}

/obj/item/disk/holodisk/tutorial/basicmechanic6
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY Locate the grid of four squares with symbols at the bottom-right corner of your screen.
	DELAY 40
	SAY There squares are "intents", which affect how you use items and your <span class='bold'>empty hands</span>.
	DELAY 40
	SAY You can cycle through them using number keys 1-4 or by clicking on the squares.
	DELAY 40
	SAY Help intent (green) allows you to help other people up and give hugs.
	DELAY 35
	SAY Disarm intent (blue) shoves objects and people out of way, potentially causing them to drop their items.
	DELAY 40
	SAY Grab intent (yellow) grabs people and drags objects behind you. Increase the strength of your grab by repeatedly clicking with grab intent.
	DELAY 50
	SAY Grabs can be resisted out of with either the "Resist" button or keybind B.
	DELAY 35
	SAY Harm intent (red) allows you to punch. It also ensures you will attack with the item you are holding.
	DELAY 40
	SAY All intents except for help will bodyblock, preventing other players from moving past you.
	DELAY 40
	SAY Use disarm intent to push the box out of the way. Then vault over the railing.
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/basicmechanic7
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY You have reached the final section of the SS13 mechanics training.
	DELAY 30
	SAY You may have noticed additional buttons and windows next to the intents.
	DELAY 35
	SAY These are used to trigger certain actions and alter your interactions, such as which body part you are targetting.
	DELAY 45
	SAY To crawl underneath certain objects or other people, use the "Rest" button or keybind U to lie on the ground.
	DELAY 40
	SAY While you are crawling, projectiles cannot hit you unless they specifically target you.
	DELAY 30
	SAY Now, crawl under the plastic flaps and enter the portal to continue to the LobCorp-specific training.
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/lobcorp1
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY At Lobotomy Corporation, we are primarily concerned with 4 key attributes of employees. They are Fortitude, Prudence, Temperance, and Justice.
	DELAY 50
	SAY To view your stats, enter the IC tab in the upper-right corner and click "Show Attributes".
	DELAY 50
	SAY Fortitude increases your maximum health (HP), and Prudence increases your maximum sanity (SP).
	DELAY 40
	SAY Temperance provides additional work success chances and faster work speed. Raising this improves the efficiency of performing works.
	DELAY 55
	SAY Justice increases your movement speed and your <span class='bold'>melee</span> damage.
	DELAY 40
	SAY There are two important values to keep track of for each attribute: Stat Value and Stat Level.
	DELAY 40
	SAY Stat Value is simply the numerical value, while Stat Level is in roman numerals and increases every 20 past the first 20.
	DELAY 50
	SAY Many interactions with Abnormalities depend on these values, and a single level is often the difference between life and death.
	DELAY 55
	SAY All of these attributes contribute to an overall Agent Level, which is mostly involved in fear-related interactions.
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/lobcorp2
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY Lobotomy Corporation is an energy corporation, and we produce energy by working on entities called "Abnormalities".
	DELAY 45
	SAY Working also improves your attributes, allowing you to become a better employee.
	DELAY 35
	SAY There are four primary types of work: Instinct, Insight, Attachment, and Repression.
	DELAY 40
	SAY Instinct work increases your Fortitude. It represents nourishment and physical contact.
	DELAY 40
	SAY Insight work increases your Prudence. It represents improving the environment of the Containment Unit.
	DELAY 40
	SAY Attachment work increases your Temperance. It represents satisfying social needs through communication.
	DELAY 40
	SAY Repression work increases your Justice. It represents suppressing and controlling impulses and desires.
	DELAY 40
	SAY The success chance of each work type is listed as Very Low/Low/Common/High/Very High.
	DELAY 45
	SAY Certain Abnormalities may also have special work types. It is important to check our documentation about Abnormality behaviors.
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/lobcorp3
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY Every Abnormality has an assigned risk level, work preferences, and unique quirks that can pose a danger to survival.
	DELAY 45
	SAY The risk levels, in order from least to most dangerous, are ZAYIN, TETH, HE, WAW, and finally ALEPH.
	DELAY 40
	SAY Depending on the risk level of the Abnormality, there is a limit to how much your stats can be increased from work (20 + 20 * Risk Level).
	DELAY 45
	SAY For example, ZAYINs can only raise your stats up to 40, and TETHs to 60. As you become more experienced, you must move on to more dangerous Abnormalities.
	DELAY 55
	SAY Working on Abnormalities will incur a fear penalty, damaging a percentage of your total sanity based on the difference between your Agent Level and the risk level.
	DELAY 55
	SAY Most Abnormalities have a Qliphoth Counter that can be seen when examining their console.
	DELAY 35
	SAY When the Qliphoth Counter reaches 0, the Abnormality has a deleterious effect on the facility. This typically involves breaching and becoming hostile.
	DELAY 55
	SAY To find info about Abnormalities, locate the cabinets you see in this room in the <span class='italics'>Records Department</span> of our facilities.
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/lobcorp4
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY There are four damage types that are color-coded: RED, WHITE, BLACK, and PALE.
	DELAY 40
	SAY RED attacks deal damage to your health. You die when your health reaches 0.
	DELAY 45
	SAY WHITE attacks deal damage to your sanity. When your sanity is depleted, you go insane and lose control of your character.
	DELAY 50
	SAY Insane employees will do determental things to those around them. Attacking them with WHITE damage will restore their sanity.
	DELAY 55
	SAY BLACK attacks deal damage to both your health and your sanity.
	DELAY 45
	SAY PALE attacks deal a percentage of your max health, regardless of how high it is.
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/lobcorp5
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY When employees have successful work sessions, Lobotomy Corp collects the generated energy in the form of PE-boxes.
	DELAY 45
	SAY These PE-boxes can be spent to generate special equipment related to the respective Abnormality called EGOs.
	DELAY 45
	SAY Each EGO has unique damage/resistances, Stat requirements, and special traits. Examine them to see their qualities.
	DELAY 50
	SAY EGO armors have resistances to damage types, which can be seen by a tag when examining. The unit for these resistances is 10% per number.
	DELAY 55
	SAY To wear EGO armor, first take off the armor vest in your o_clothing slot with an empty hand.
	DELAY 45
	SAY Then, click on your o_clothing slot with the EGO armor inhand while standing still.
	DELAY 45
	SAY EGO weapons are stored in the belt and suit storage slots. Small EGO weapons can additonally be stored in EGO weapon belts.
	DELAY 50
	SAY EGO is acquired from a console located in the <span class='italics'>Extraction Department</span> of our facilties.
	DELAY 45
	SAY Equip a set of EGO armor and weapon from the nearby racks. You will need them shortly.
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/lobcorp6
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY The most important section of your onboarding lies ahead.
	DELAY 30
	SAY You will begin working with our beginner Abnormalities. Their record can be found in their Containment Unit.
	DELAY 40
	SAY Main department rooms, which look similar to this room, have a regenerator that restore health and sanity. Be sure to return here whenever you are injured.
	DELAY 55
	SAY LobCorp takes workplace safety seriously, but employees are required to have a certain level of initiative and tenacity.
	DELAY 45
	SAY As such, new employees are expected to suppress any escaped Abnormalities on their own.
	DELAY 40
	SAY The first time you witness a breached Abnormality, you will take sanity damage based on the difference between its threat level and your Agent Level.
	DELAY 55
	SAY Abnormalities also have varying resistances to each damage type. Read their records to take advantage of this during suppressions.
	DELAY 45
	SAY <span class='warning'>It is important you do not move or grab items while working.</span> Otherwise you will automatically fail the work and take heavy damage.
	DELAY 50
	SAY Don't forget to wear the appropriate EGO while working to minimize injury. Return them to the racks when you are finished.
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/warning
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY TO SIMULATE THE WORKING ENVIRONMENT OF OUR FACILITIES, THE REGENERATOR WILL NOT AFFECT THE HALLWAY OR CONTAINMENT UNITS.
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/lobcorp7
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY If you feel you are sufficiently proficient working with Abnormalities, then keep listening.
	DELAY 40
	SAY Otherwise, please return to the hallway and continue practicing.
	DELAY 30
	SAY The Qliphoth Meter, which can be seen by examining an <span class='italics'>ordeal monitor</span>, increases every time a work is completed.
	DELAY 50
	SAY When it reaches its limit, an announcement reveals which Abnormalities have been affected by Qliphoth Meltdowns.
	DELAY 45
	SAY These Abnormalities must be worked on within a set amount of time, or else they will immediately breach. You can see this timer by examining their console.
	DELAY 55
	SAY If you would like some practice, activate the machine to trigger a meltdown on the training Abnormalities.
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/lobcorp8
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY Every couple of meltdowns, an "Ordeal" will occur. These facility-wide challenges serve as progression for a LobCorp shift.
	DELAY 45
	SAY When an Ordeal is imminent, an icon will appear on ordeal monitors identifying the type of ordeal.
	DELAY 40
	SAY After an Ordeal starts, a set of enemies will appear around the facility and will need to be defeated in a timely manner.
	DELAY 45
	SAY It is <span class='bold'>paramount</span> that employees stop working to address Ordeals, as they can severely cripple a facility's functionality.
	DELAY 55
	SAY The Ordeals are classified by color: Amber, Crimson, Green, Indigo, Violet, and White.
	DELAY 35
	SAY Ambers have overwhelming swarms. Crimsons trigger effects upon death. Greens are efficient at combat.
	DELAY 45
	SAY Indigos use dead bodies to recover strength. Violets are static threats that lower Qliphoth Counters. Whites focus on specific types of damage.
	DELAY 55
	SAY The tiers of Ordeals are as follows: Dawn, Noon, Dusk, and Midnight. These are progressively deadlier and harder to deal with.
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/lobcorp9
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY Congrations! You have completed your onboarding and are now ready to begin working at Lobotomy Corporation!
	DELAY 45
	SAY If you need ever need help while at a facility, go to the Mentor tab in your top-right corner and use Mentorhelp to ask questions.
	DELAY 50
	SAY When you are ready, enter the employee storage by dragging your character onto it, and click yes on the window that pops up.
	DELAY 50
	SAY First type <span class='italics'>ghost</span> in the text bar at the bottom of the screen. Then type <span class='italics'>respawn</span> to join the facility.
	DELAY 50
	SAY Good luck employee. Face the fear, build the future.
	DELAY 60"}
