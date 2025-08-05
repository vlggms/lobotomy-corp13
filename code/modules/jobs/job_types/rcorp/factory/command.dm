/datum/job/rcorp_captain/commander/operations
	title = "Operations Commander"
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/commander/operations
	rank_title = "CDR"
	job_important = "Lead the Rcorp 6th Pack to gather as many materials as you possibly can!"
	job_notice = "Destroy the X-Corp Heart."
	req_admin_notify = 1

/datum/job/rcorp_captain/commander/operations/New()
	..()
	if(rank_title == "JCDR")
		rank_title = "CDR"

/datum/outfit/job/commander/operations
	name = "Operations Commander"
	jobtype = /datum/job/rcorp_captain/commander/operations

	belt = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rcorp_command
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/beret/tegu/rcorp
	l_pocket = /obj/item/commandprojector
	r_hand = null
	box = null

	//Cursed.
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE





/datum/job/rcorp_captain/commander/factory
	title = "Executive Officer"
	trusted_only = FALSE
	outfit = /datum/outfit/job/commander/factory
	display_order = 1.1
	exp_requirements = 1200
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	alt_titles = list("Base Commander")
	rank_title = "LCDR"
	job_important = "Keep the base producing materials. You are in charge of the Raven, Rook and Production teams."
	job_notice = ""
	maptype = "rcorp_factory"
	req_admin_notify = 1

/datum/outfit/job/commander/factory
	name = "Executive Officer"
	jobtype = /datum/job/rcorp_captain/commander/factory

	belt = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rcorp_command
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/beret/tegu/rcorp
	l_pocket = /obj/item/commandprojector
	r_hand = null
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE

