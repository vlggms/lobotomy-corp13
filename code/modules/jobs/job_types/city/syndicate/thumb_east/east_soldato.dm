/// Thumb East Soldato. Non trusted role, but has the power level of a regular CoL South Capo.
/datum/job/east_soldato
	title = "Thumb East Soldato"
	outfit = /datum/outfit/job/east_soldato
	department_head = list("your capo and the Hierarchy of the Thumb")
	faction = "Station"
	supervisors = "your capo and the Hierarchy of the Thumb"
	selection_color = "#861632"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 100
	maptype = list("city")
	job_important = "You are a soldier in the Thumb Syndicate's eastern branch. Conduct yourself according to perfect etiquette and obey your superiors' orders to the letter, or you will be harshly punished.\
	Do not forget to treat your peers with courtesy."
	job_notice = "Avoid killing other players without a reason."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/east_soldato/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/east_soldato
	name = "Thumb East Soldato"
	jobtype = /datum/job/east_soldato

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
