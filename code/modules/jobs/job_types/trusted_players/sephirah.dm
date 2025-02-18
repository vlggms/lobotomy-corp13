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
	departments = DEPARTMENT_COMMAND
	mapexclude = list("wonderlabs", "mini")
	job_important = "You are a roleplay role, and may not partake in combat. Assist the manager and roleplay with the agents and clerks"
	job_notice = "\
		In the gamemaster tab, you may adjust game perimeters. \
		This is an OOC tool. Do not bring alert to the fact that you can do this IC. \
		Alert any administrators if any IC action is taken against you. \
		Abusing this will result in a loss of whitelist.\
	"

	job_abbreviation = "SEPH"

/datum/job/command/sephirah/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	. = ..()
	//You're a fucking robot.
	ADD_TRAIT(outfit_owner, TRAIT_SANITYIMMUNE, JOB_TRAIT)
	//Okay maybe don't JUST let them grief.
	add_verb(outfit_owner, /mob/living/carbon/human/proc/QuestComplete)

	//NOW Let'em Grief
	add_verb(outfit_owner, /mob/living/carbon/human/proc/GameInfo)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/Announcement)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/RandomAbno)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/RandomSelection)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/NextAbno)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/SlowGame)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/QuickenGame)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/WorkMeltIncrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/WorkMeltDecrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/MeltIncrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/MeltDecrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/BulletAuth)
	// a TGUI menu that SHOULD contain all the above actions
	var/datum/action/sephirah_game_panel/new_action = new(outfit_owner.mind || outfit_owner)
	new_action.Grant(outfit_owner)

	outfit_owner.apply_pref_name("sephirah", M.client)
	outfit_owner.name += " - [M.client.prefs.prefered_sephirah_department]"
	outfit_owner.real_name += " - [M.client.prefs.prefered_sephirah_department]"
	for(var/obj/item/card/id/Y in outfit_owner.contents)
		Y.registered_name = outfit_owner.name
		Y.update_label()

	//You're a robot, man
	if(M.client.prefs.prefered_sephirah_bodytype == "Box")
		outfit_owner.set_species(/datum/species/sephirah)
		outfit_owner.dna.features["mcolor"] = sanitize_hexcolor(M.client.prefs.prefered_sephirah_boxcolor)
		outfit_owner.update_body()
		outfit_owner.update_body_parts()
		outfit_owner.update_mutations_overlay() // no hulk lizard

	else
		outfit_owner.set_species(/datum/species/synth)

	outfit_owner.speech_span = SPAN_ROBOT

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(outfit_owner)
	medsensor.add_hud_to(outfit_owner)

/datum/outfit/job/sephirah
	name = "Sephirah"
	jobtype = /datum/job/command/sephirah

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	l_pocket = /obj/item/commandprojector

	backpack_contents = list()

GLOBAL_LIST_INIT(sephirah_names, list(
	"Job", "Lot", "Isaac", "Lazarus", "Gaius", "Abel", "Enoch", "Jescha"
))




/*************************************************/
//Sephirah Gamemaster commands.

/mob/living/carbon/human/proc/QuestComplete()
	set name = "Reward Custom Quest"
	set category = "Sephirah.Events"
	SSlobotomy_corp.lob_points += 1
	minor_announce("The local sephirah have decided that the facility's, and by extention, the manager's, performance have been exemplary. \
				1 LOB point has been deposited into the account of your manager", "Central Command Alert:", TRUE)
	return

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
		SSlobotomy_corp.lob_points += 1
		minor_announce("Due to a lack of resources; a random abnormality has been chosen and LOB point has been deposited in your account. \
				Extraction Headquarters apologizes for the inconvenience", "Extraction Alert:", TRUE)
		return

/mob/living/carbon/human/proc/RandomSelection()
	set name = "Randomize Abnormality Selection"
	set category = "Sephirah.Events"

	SSabnormality_queue.next_abno_spawn = world.time + SSabnormality_queue.next_abno_spawn_time + ((min(16, SSabnormality_queue.spawned_abnos) - 6) * 6) SECONDS
	SSabnormality_queue.PickAbno()

	//Literally being griefed.
	SSlobotomy_corp.lob_points += 0.25
	minor_announce("Extraction has made an error in which abnormalities your manager was to select. Extraction apologizes profusely, \
			and the actual set of [GetFacilityUpgradeValue(UPGRADE_ABNO_QUEUE_COUNT)] abnormalities has been sent to your manager's console.", "Extraction Alert:", TRUE)
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

//Execution barrets
GLOBAL_LIST_EMPTY(SephirahBullet)

/mob/living/carbon/human/proc/BulletAuth()
	set name = "Authorize Execution Bullets"
	set category = "Sephirah"
	GLOB.SephirahBullet |= src.ckey
	if(length(GLOB.SephirahBullet) == 2)
		if(SSmaptype.maptype == "skeld")
			minor_announce("There has been an error in the authorizing of our new Execution Bullet pilot program. \
				Execution Bullets won't be able to be delivered to this facility.", "Control Alert:", TRUE)
		else
			minor_announce("The facility's manager has been deemed trustworthy of our new Execution Bullet pilot program. \
				Execution bullets will be delivered immediately.", "Disciplinary Alert:", TRUE)
			GLOB.execution_enabled = TRUE

	else
		to_chat(src, span_notice("Your superiors have been notified of your authorization. Reminder that execution bullets require authorization of 2 sephirah."))
		message_admins(span_notice("A sephirah ([src.ckey]) has given an authorization for execution bullets."))

/mob/living/carbon/human/proc/Announcement()
	set name = "Make Announcement"
	set category = "Sephirah"
	var/input = stripped_input(src,"What do you want announce?", ,"Test Announcement")
	minor_announce("[input]" , "Official Sephirah announcement from: [src.name]")

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

	// START OF ARRIVAL INFORMATION
	var/safe_abnormality_delay
	if(SSabnormality_queue.next_abno_spawn != INFINITY) // Happens when starting abnormalities are being selected, or things break
		safe_abnormality_delay = floor(SSabnormality_queue.next_abno_spawn)
	else
		safe_abnormality_delay = ABNORMALITY_DELAY + SSticker.round_start_time

	data["previous_arrival_time"] = floor(SSabnormality_queue.previous_abno_spawn ? SSabnormality_queue.previous_abno_spawn : ROUNDTIME)
	data["current_arrival_time"] = floor(world.time)
	data["next_arrival_time"] = safe_abnormality_delay + 5 SECONDS // The seconds are because the subsystem fires every 10 seconds
	// END OF ARRIVAL INFORMATION

	return data

/datum/action/sephirah_game_panel/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!ishuman(owner)) // we are calling human procs, so processing actions from non-humans is dangerous
		return
	var/mob/living/carbon/human/hooman = owner

	switch(action) // maybe change labels?
		if("Make announcement")
			hooman.Announcement()

		if("Complete quest")
			hooman.QuestComplete()

		if("Randomize abnormality")
			hooman.RandomAbno()

		if("Randomize selection")
			hooman.RandomSelection()

		if("Authorize execution bullets")
			hooman.BulletAuth()

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


