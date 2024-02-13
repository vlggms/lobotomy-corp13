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
	job_notice = "In the OOC tab you have a verb called 'randomize current abnormality'. \
		It is to be used to spice up boring rounds, and punish manager players you think are playing too safe. \
		This is an OOC tool. Do not bring alert to the fact that you can do this IC. Alert any administrators if any IC action is taken against you. \
		Abusing this will result in a loss of whitelist."

/datum/job/command/sephirah/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	//You're a fucking robot.
	ADD_TRAIT(H, TRAIT_SANITYIMMUNE, JOB_TRAIT)

	//Let'em Grief
	add_verb(H, /client/proc/randomabno)

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


/client/proc/randomabno()
	set name = "Randomize Current Abnormality"
	set category = "OOC"
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

