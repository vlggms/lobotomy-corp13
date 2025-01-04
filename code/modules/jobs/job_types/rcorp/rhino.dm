/datum/job/rhino
	title = "R-Corp Gunner Rhino"
	faction = "Station"
	department_head = list("Rhino Team Captain", "Commander")
	total_positions = 2
	spawn_positions = 2
	supervisors = "the rhino team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/rhino
	display_order = 6

	access = list(ACCESS_ARMORY, ACCESS_CENT_GENERAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_CENT_GENERAL)
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	rank_title = "SGT"
	job_important = "You take the role of ranged armored unit."
	job_notice = "Equip your mecha in the supply tent to the northwest. Take point, and cover for the rabbits. \
		You can heal your mech with the welder. Keep in mind that certain attacks can pierce your mecha"

/datum/job/rhino/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/job/rhino/hammer
	title = "R-Corp Hammer Rhino"
	total_positions = 1
	spawn_positions = 1
	display_order = 6.1
	outfit = /datum/outfit/job/rhino/melee

	access = list(ACCESS_ARMORY, ACCESS_CENT_THUNDER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_CENT_THUNDER)

	job_important = "You take the role of melee armored unit."

/datum/job/rcorp_captain/rhino
	title = "Rhino Squad Captain"
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

	outfit = /datum/outfit/job/rhino/captain
	display_order = 2

	access = list(ACCESS_ARMORY, ACCESS_COMMAND, ACCESS_CENT_GENERAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_COMMAND, ACCESS_CENT_GENERAL)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "You are the captain of the armored division."
	job_notice = "Visit your bunks in the command tent to gather your mecha, and lead the Rhinos at the point."



/datum/outfit/job/rhino
	name = "R-Corp Gunner Rhino"
	jobtype = /datum/job/rhino

	ears = /obj/item/radio/headset/headset_discipline
	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	belt = /obj/item/storage/belt/rhino/full

/datum/outfit/job/rhino/melee
	name = "R-Corp Hammer Rhino"
	jobtype = /datum/job/rhino/hammer



/datum/outfit/job/rhino/captain
	name = "Rhino Squad Captain"
	jobtype = /datum/job/rcorp_captain/rhino
	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	ears = /obj/item/radio/headset/heads/headset_discipline
	belt = /obj/item/storage/belt/rhino/captain
