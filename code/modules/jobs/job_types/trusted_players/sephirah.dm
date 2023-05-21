//Sephirah
/datum/job/command/sephirah
	title = "Sephirah"
	outfit = /datum/outfit/job/sephirah
	total_positions = 3
	spawn_positions = 3
	display_order = JOB_DISPLAY_ORDER_SEPHIRAH
	trusted_only = TRUE
	access = list(ACCESS_NETWORK, ACCESS_COMMAND) // This is the trusted chat gamer access
	minimal_access = list(ACCESS_NETWORK, ACCESS_COMMAND)
	mapexclude = list("wonderlabs", "mini")

/datum/job/command/sephirah/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	H.apply_pref_name("sephirah", M.client)

/datum/outfit/job/sephirah
	name = "Sephirah"
	jobtype = /datum/job/command/sephirah

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	glasses = /obj/item/clothing/glasses/hud/security
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	l_pocket = /obj/item/commandprojector
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)

GLOBAL_LIST_INIT(sephirah_names, list(
	"Job - Control",
	"Lot - Information",
	"Isaac - Training",
	"Lazarus - Safety",
	"Gaius - Welfare",
	"Abel - Discipline",
	"Enoch - Extraction",
	"Jescha - Records",
	))
