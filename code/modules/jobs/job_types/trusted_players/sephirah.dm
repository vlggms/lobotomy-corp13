//Sephirah
/datum/job/command/sephirah
	title = "Sephirah"
	outfit = /datum/outfit/job/sephirah
	total_positions = 3
	spawn_positions = 3
	display_order = JOB_DISPLAY_ORDER_SEPHIRAH
	trusted_only = TRUE
	access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER) // Network is the trusted chat gamer access
	minimal_access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER)
	mapexclude = list("wonderlabs", "mini")
	job_important = "You are a roleplay role, and may not partake in combat. Assist the manager and roleplay with the agents and clerks"
	job_notice = "In the gamemaster tab, you may adjust game perimeters. \
		This is an OOC tool. Do not bring alert to the fact that you can do this IC. Alert any administrators if any IC action is taken against you. \
		Abusing this will result in a loss of whitelist."

	job_abbreviation = "SEPH"

/datum/job/command/sephirah/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	//You're a fucking robot.
	ADD_TRAIT(H, TRAIT_SANITYIMMUNE, JOB_TRAIT)

	//Let'em Grief
	add_verb(H, /mob/living/carbon/human/proc/RandomAbno)
	add_verb(H, /mob/living/carbon/human/proc/NextAbno)
	add_verb(H, /mob/living/carbon/human/proc/SlowGame)
	add_verb(H, /mob/living/carbon/human/proc/QuickenGame)
	add_verb(H, /mob/living/carbon/human/proc/WorkMeltIncrease)
	add_verb(H, /mob/living/carbon/human/proc/WorkMeltDecrease)
	add_verb(H, /mob/living/carbon/human/proc/MeltIncrease)
	add_verb(H, /mob/living/carbon/human/proc/MeltDecrease)
	add_verb(H, /mob/living/carbon/human/proc/GameInfo)
	// a TGUI menu that SHOULD contain all the above actions
	var/datum/action/sephirah_game_panel/new_action = new(H.mind || H)
	new_action.Grant(H)

	H.apply_pref_name("sephirah", M.client)
	H.name += " - [M.client.prefs.prefered_sephirah_department]"
	H.real_name += " - [M.client.prefs.prefered_sephirah_department]"
	for(var/obj/item/card/id/Y in H.contents)
		Y.registered_name = H.name
		Y.update_label()

	//You're a robot, man
	if(M.client.prefs.prefered_sephirah_bodytype == "Box")
		H.set_species(/datum/species/sephirah)
		H.dna.features["mcolor"] = sanitize_hexcolor(M.client.prefs.prefered_sephirah_boxcolor)
		H.update_body()
		H.update_body_parts()
		H.update_mutations_overlay() // no hulk lizard

	else
		H.set_species(/datum/species/synth)

	H.speech_span = SPAN_ROBOT

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

/datum/outfit/job/sephirah
	name = "Sephirah"
	jobtype = /datum/job/command/sephirah

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	l_pocket = /obj/item/commandprojector

GLOBAL_LIST_INIT(sephirah_names, list(
	"Job", "Lot", "Isaac", "Lazarus", "Gaius", "Abel", "Enoch", "Jescha",))




/*************************************************/
//Sephirah Gamemaster commands.

/mob/living/carbon/human/proc/RandomAbno()
	set name = "Randomize Current Abnormality"
	set category = "Sephirah.Events"
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
		var/mob/living/simple_animal/hostile/abnormality/target_type = SSabnormality_queue.GetRandomPossibleAbnormality()
		if(Q.locked)
			to_chat(src, span_danger("The abnormality was already randomized."))
			return

		Q.UpdateAnomaly(target_type, "fucked it lets rolled", TRUE)
		SSabnormality_queue.AnnounceLock()
		SSabnormality_queue.ClearChoices()

		//Literally being griefed.
		SSlobotomy_corp.available_box += 500
		minor_announce("Due to a lack of resources; a random abnormality has been chosen and PE has been deposited in your account. \
				Extraction Headquarters apologizes for the inconvenience", "Extraction Alert:", TRUE)
		return

//See next abnormality
/mob/living/carbon/human/proc/NextAbno()
	set name = "Next Abnormality Check"
	set category = "Sephirah"
	//Abno stuff, so you can grief more effectively.
	var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality
	to_chat(src, span_notice("Current Status:"))
	to_chat(src, span_notice("Number of Abnormalities: [SSabnormality_queue.spawned_abnos]."))
	to_chat(src, span_notice("Next Abnormality: [initial(queued_abno.name)]."))

//Speed stuff
GLOBAL_VAR_INIT(Sephirahspeed, 0)

/mob/living/carbon/human/proc/SlowGame()
	set name = "Abnormality Time Slow"
	set category = "Sephirah.Game Changes"
	if(GLOB.Sephirahspeed > -3)
		SSabnormality_queue.next_abno_spawn_time *= 1.2
		GLOB.Sephirahspeed --
		to_chat(src, span_notice("You have now slowed down when abnormalities arrive."))
		message_admins("<span class='notice'>A sephirah ([src.ckey]) has slowed down the abnormality rate.</span>")
	else
		to_chat(src, span_notice("Abnormality extraction cannot be slower."))

/mob/living/carbon/human/proc/QuickenGame()
	set name = "Abnormality Time Quicken"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahspeed < 3)
		SSabnormality_queue.next_abno_spawn_time /= 1.2
		GLOB.Sephirahspeed ++
		to_chat(src, span_notice("You have now sped up when abnormalities arrive."))
		message_admins("<span class='notice'>A sephirah ([src.ckey]) has sped up the abnormality rate.</span>")
	else
		to_chat(src, span_notice("Abnormality extraction cannot be faster."))

//Ordeal Stuff
GLOBAL_VAR_INIT(Sephirahordealspeed, 0)

/mob/living/carbon/human/proc/WorkMeltIncrease()
	set name = "Works Per Melt Increase"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahordealspeed > 5)
		to_chat(src, span_notice("Meltdowns are already taking too long!"))
		return

	GLOB.Sephirahordealspeed ++
	to_chat(src, span_notice("All meltdowns will take one more work."))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made works per melt longer.</span>")


/mob/living/carbon/human/proc/WorkMeltDecrease()
	set name = "Works Per Melt Decrease"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahordealspeed < -3 )
		to_chat(src, span_notice("Meltdowns are already too fast!"))
		return

	GLOB.Sephirahordealspeed --
	to_chat(src, span_notice("All meltdowns will take one less work."))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made works per melt shorter.</span>")


GLOBAL_VAR_INIT(Sephirahmeltmodifier, 0)

/mob/living/carbon/human/proc/MeltIncrease()
	set name = "Abno Melts Per Event Increase"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahmeltmodifier > 5)
		to_chat(src, span_notice("Too many abnormalities are melting!"))
		return

	GLOB.Sephirahmeltmodifier ++
	to_chat(src, span_notice("One more abnormality will melt per event."))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made more abnormalities melt per event.</span>")


/mob/living/carbon/human/proc/MeltDecrease()
	set name = "Abno Melts Per Event Decrease"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahmeltmodifier < -1*SSlobotomy_corp.qliphoth_meltdown_amount+2)
		to_chat(src, span_notice("Too little abnormalities are melting!"))
		return

	GLOB.Sephirahmeltmodifier --
	to_chat(src, span_notice("One less abnormality will melt per event."))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made less abnormalities melt per event.</span>")



//See next abnormality
/mob/living/carbon/human/proc/GameInfo()
	set name = "Check Game Info"
	set category = "Sephirah"
	//So you can see what the others have done
	to_chat(src, span_notice("Current Status:"))
	to_chat(src, span_notice("Sephirah Meltdown Modifier: [GLOB.Sephirahmeltmodifier]."))
	to_chat(src, span_notice("Sephirah Workmelt Modifier: [GLOB.Sephirahordealspeed]."))
	to_chat(src, span_notice("Abnormality Extraction Speed Modifier: [GLOB.Sephirahordealspeed]."))

// TGUI stuff below

/datum/action/sephirah_game_panel
	name = "Open the sephirah game control panel"
	desc = "This lets you manipulate the game in various ways, abuse may lead to a trusted player ban"
	button_icon_state = "round_end"

/datum/action/sephirah_game_panel/ui_state(mob/user)
	return GLOB.always_state // this line of code is actually needed, else it IMMEDIATELLY closes itself. Luv myself TGUI <3

/datum/action/sephirah_game_panel/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	message_admins("[owner] has opened the sephirah game control panel")
	ui_interact(owner)

/datum/action/sephirah_game_panel/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SephirahPanel")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/action/sephirah_game_panel/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	data["abno_number"] = SSabnormality_queue.spawned_abnos

	data["abnormality_arrival"] = GLOB.Sephirahspeed
	data["meltdown_speed"] = GLOB.Sephirahordealspeed


	var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality
	data["queued_abno"] = initial(queued_abno.name)

	/* Scrapped due to difficulty -- to be implemented
	// START OF ARRIVAL INFORMATION
	var/safe_abnormality_delay
	if(SSabnormality_queue.next_abno_spawn != INFINITY) // happens when starting abnormalities are being selected, or things break
		safe_abnormality_delay = SSabnormality_queue.next_abno_spawn
	else
		safe_abnormality_delay = ABNORMALITY_DELAY

	data["current_arrival"] = safe_abnormality_delay
	data["next_arrival"] = safe_abnormality_delay + SSabnormality_queue.next_abno_spawn_time + ((min(16, (SSabnormality_queue.spawned_abnos + 1)) - 6) * 6) SECONDS
	data["progress_component"] = (world.time - ABNORMALITY_DELAY) / safe_abnormality_delay
	// END OF ARRIVAL INFORMATION
	*/

	return data

/datum/action/sephirah_game_panel/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!ishuman(owner)) // we are calling human procs, so processing actions from non-humans is dangerous
		return
	var/mob/living/carbon/human/hooman = owner

	switch(action) // maybe change labels?
		if("Randomize abnormality")
			hooman.RandomAbno()

		if("Slow abnormality arrival")
			hooman.SlowGame()

		if("Quicken abnormality arrival")
			hooman.QuickenGame()

		if("Increase Work per Meltdown ratio")
			hooman.WorkMeltIncrease()

		if("Decrease Work per Meltdown ratio")
			hooman.WorkMeltDecrease()

		if("Increase abnormality per meltdown ratio")
			hooman.MeltIncrease()

		if("Decrease abnormality per meltdown")
			hooman.MeltDecrease()
