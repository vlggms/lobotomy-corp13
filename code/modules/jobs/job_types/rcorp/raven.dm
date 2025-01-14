/datum/job/raven
	title = "R-Corp Scout Raven"
	faction = "Station"
	department_head = list("Raven Team Captain", "Commander")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the raven team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/raven
	display_order = 8

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 100
								)
	rank_title = "SPC"
	job_important = "You take the role of a scout support unit."
	job_notice = "You cannot use guns, but are fast, and have access to night vision. Scout ahead and relay information to the group. \
		You are also capable of striking with surgical precision and high speed."

/datum/job/raven/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)


/datum/job/raven/support
	title = "R-Corp Support Raven"
	total_positions = 2
	spawn_positions = 2
	display_order = 8.1
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 80
								)
	outfit = /datum/outfit/job/raven/support
	job_important = "You take the role of an intelligence support unit."
	job_notice = "You cannot use guns, but have access to night vision. In your backpack you have a variety of tools to supply information to, and support your teammates. \
		You are not as fast as scout ravens, try to stay with the group."

/datum/job/rcorp_captain/raven
	title = "Raven Squad Captain"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d1a83b"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"

	outfit = /datum/outfit/job/raven/captain
	display_order = 4

	access = list(ACCESS_RND, ACCESS_COMMAND)
	minimal_access = list(ACCESS_RND, ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 130
								)
	rank_title = "CPT"
	job_important = "You are the captain of the intelligence division."
	job_notice = "Visit your bunks in the command tent to gather your intel tools. \
	Gather and disseminate information among command. \
	You are the fastest unit in the 4th pack, and can strike with the speed of which no one else can"

/datum/outfit/job/raven
	name = "R-Corp Scout Raven"
	jobtype = /datum/job/raven

	ears = /obj/item/radio/headset/headset_information
	glasses = /obj/item/clothing/glasses/night/rabbit
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raven/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/raven
	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	r_pocket = /obj/item/pinpointer/nuke/rcorp
	backpack_contents = list(
		/obj/item/grenade/smokebomb = 1)

/datum/outfit/job/raven/support
	name = "R-Corp Support Raven"
	jobtype = /datum/job/raven/support
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/ravensup
	backpack_contents = list(
		/obj/item/powered_gadget/slowingtrapmk1 = 1,
		/obj/item/powered_gadget/detector_gadget/abnormality = 1,
		/obj/item/powered_gadget/vitals_projector = 1,
		/obj/item/powered_gadget/handheld_taser = 1,
		/obj/item/grenade/smokebomb = 1)

/datum/outfit/job/raven/captain
	name = "Raven Squad Captain"
	jobtype = /datum/job/rcorp_captain/raven
	glasses = /obj/item/clothing/glasses/hud/health/night/rabbit
	head = /obj/item/clothing/head/rabbit_helmet/raven
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/ravencap
	suit_store = null
	ears = /obj/item/radio/headset/heads/headset_information
