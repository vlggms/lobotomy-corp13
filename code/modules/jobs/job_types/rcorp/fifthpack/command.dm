/datum/job/rcorp_captain/commander/assault
	title = "Assault Commander"
	faction = "Station"
	exp_requirements = 3000
	maptype = "rcorp_fifth"
	trusted_only = FALSE

	outfit = /datum/outfit/job/commander/assault
	display_order = 1

	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)

	rank_title = "LCDR"
	job_important = "You are the Assault Commander, and lead the charge from the front. You MUST first brief the pack, to make sure that you have a basic plan, and then you may lead the charge."
	job_notice = " Give a briefing and then open the doors to the outside via a button in the officer's room, and then lead the charge."


/datum/outfit/job/commander/assault
	name = "Assault Commander"
	jobtype = /datum/job/rcorp_captain/commander/assault

	belt = /obj/item/ego_weapon/city/rabbit_blade/command
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/lcdr
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/assaultofficer
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	ears = /obj/item/radio/headset/heads/manager/alt
	head = /obj/item/clothing/head/beret/tegu/rcorp
	l_pocket = /obj/item/commandprojector
	r_pocket = /obj/item/flashlight/seclite
	r_hand = /obj/item/announcementmaker


/datum/job/rcorp_captain/commander/base
	title = "Base Commander"
	trusted_only = FALSE
	outfit = /datum/outfit/job/commander/base
	display_order = 1.1
	exp_requirements = 1200
	maptype = "rcorp_fifth"
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	alt_titles = list("Base Commander", "Senior Officer")
	rank_title = "CPT"
	job_important = "You are the right hand man to the Assault Commander. Take care of the base, and protect it from hostiles. \
		If you are caught on the frontline, and the comms get ."
	job_notice = "Manage the Junior Officers at your disposal"


/datum/outfit/job/commander/base
	name = "Base Commander"
	jobtype = /datum/job/rcorp_captain/commander/lieutenant
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/lcdr
	belt = /obj/item/ego_weapon/city/rabbit_blade
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/officer
	head = /obj/item/clothing/head/beret/tegu/captain
