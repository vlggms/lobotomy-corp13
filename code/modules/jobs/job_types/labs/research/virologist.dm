/datum/job/virologist
	title = "Virologist"
	faction = "Station"
	supervisors = "Lead Researcher"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#cd6fd9"

	outfit = /datum/outfit/job/virologist

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)

	job_attribute_limit = 0


	display_order = 6.5
	alt_titles = list("Fish Doctor")
	maptype = "limbus_labs"
	job_important = "You are a Virologist. Your goal is to create helpful viruses for your colleages."
	job_abbreviation = "VIR"

/datum/job/virologist/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/virologist
	name = "Virologist"
	jobtype = /datum/job/virologist

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/viro
	gloves = /obj/item/clothing/gloves/color/latex
	l_pocket = /obj/item/radio
