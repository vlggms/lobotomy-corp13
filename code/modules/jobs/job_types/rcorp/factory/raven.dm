/datum/job/raven_messenger
	title = "R-Corp Messenger Raven"
	faction = "Station"
	department_head = list("Raven Team Captain", "Commanders")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the raven team captain and the commanders"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/raven_messenger
	display_order = 8

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 100
								)
	rank_title = "SPC"
	job_important = "You take the role of a messenger unit."
	job_notice = "You are quite weak in terms of offensive capabilities, however, your high speed lets you courier messages from command. \
			Move to the raven messenger bunks and await orders."

/datum/job/raven_messenger/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/outfit/job/raven_messenger
	name = "R-Corp Messenger Raven"
	jobtype = /datum/job/raven_messenger

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raven/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/raven
	belt = null
	l_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE


/datum/job/raven_mp
	title = "R-Corp Raven MP"
	faction = "Station"
	department_head = list("Raven Team Captain", "Commanders")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the raven team captain and the commanders"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/raven_mp
	display_order = 7

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "LT"
	job_important = "You take the role of base defense."
	job_notice = "Assist around the base the best you can, defending from attacks. In your downtime, you may assist with medical work, or assist with production."

/datum/job/raven_mp/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/outfit/job/raven_mp
	name = "R-Corp Raven MP"
	jobtype = /datum/job/raven_mp

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raven/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/ravensup
	belt = null
	l_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE


/datum/job/rcorp_captain/raven_factorycap
	title = "Raven Squad Captain"
	faction = "Station"
	department_head = list("Commanders")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commanders"
	selection_color = "#a18438"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/raven_factorycap
	display_order = 6

	access = list(ACCESS_RND, ACCESS_COMMAND)
	minimal_access = list(ACCESS_RND, ACCESS_COMMAND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 100
								)
	rank_title = "CPT"
	job_important = "You take the role of support team captain."
	job_notice = "Manage both the messengers and military police. This role has a lot of downtime."
	req_admin_notify = 1

/datum/job/rcorp_captain/raven_factorycap/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/outfit/job/raven_factorycap
	name = "Raven Team Captain"
	jobtype = /datum/job/rcorp_captain/raven_factorycap

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raven
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/ravencap
	belt = null
	l_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE
