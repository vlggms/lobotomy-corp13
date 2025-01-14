/datum/job/raccoon
	title = "R-Corp Raccoon Spy"
	faction = "Station"
	department_head = list("Raccoon Squad Leader", "Commander")
	total_positions = 3
	spawn_positions = 3
	exp_requirements = 120
	supervisors = "the raccoon squad leader and the commander"
	selection_color = "#d13711"

	outfit = /datum/outfit/job/raccoon
	display_order = 11
	maptype = "rcorp_fifth"

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "SPC"
	job_important = "You take the role of a stealth recon unit."
	job_notice = "You are a Raccoon armed with camouflage technology. You report on enemy positions and find opportune moments to take advantage of."

/datum/job/raccoon/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)


/datum/job/raccoon/sniper
	title = "R-Corp Raccoon Sniper"
	total_positions = 2
	spawn_positions = 2
	exp_requirements = 120
	outfit = /datum/outfit/job/raccoon/sniper
	display_order = 11.5
	rank_title = "SGT"
	job_important = "You take the role of a long range marksman."
	job_notice = "You are a Raccoon armed with a long range rifle. You report on enemy positions and fire from the backlines with your IFF-enabled rifle."


/datum/job/rcorp_captain/raccoon
	title = "Raccoon Squad Leader"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d13711"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_fifth"

	outfit = /datum/outfit/job/raccoon/leader
	display_order = 3

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 80,
								)
	rank_title = "LT"
	job_important = "You are the squad leader of the stealth recon division."
	//job_notice = "Visit your bunks in the command tent to gather your one-handed rabbit gun and multiphase blade."


/datum/outfit/job/raccoon
	name = "R-Corp Raccoon Spy"
	jobtype = /datum/job/raccoon

	ears = /obj/item/radio/headset/headset_information
	glasses = /obj/item/clothing/glasses/night
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raccoon
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/raccoon
	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	backpack_contents = list(
		/obj/item/grenade/smokebomb = 1,
		/obj/item/chameleon = 1,)
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp


/datum/outfit/job/raccoon/sniper
	name = "R-Corp Raccoon Sniper"
	jobtype = /datum/job/raccoon/sniper

	head = /obj/item/clothing/head/rabbit_helmet/raccoonsniper
	suit_store = /obj/item/gun/energy/e_gun/rabbitdash/heavysniper
	backpack_contents = list()


/datum/outfit/job/raccoon/leader
	name = "Raccoon Squad Leader"
	jobtype = /datum/job/rcorp_captain/raccoon

	head = /obj/item/clothing/head/rabbit_helmet/raccooncap
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/raccooncap
	belt = /obj/item/ego_weapon/city/rabbit_blade
	suit_store = /obj/item/gun/energy/e_gun/rabbitdash/heavysniper
	ears = /obj/item/radio/headset/heads/headset_information
