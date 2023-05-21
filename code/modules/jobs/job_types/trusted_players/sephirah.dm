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
	mapexclude = list("wonderlabs")

/datum/job/command/sephirah/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	//You're a fucking robot.
	ADD_TRAIT(H, TRAIT_SANITYIMMUNE, JOB_TRAIT)

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
