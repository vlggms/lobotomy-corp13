//Butcher almost boss
/datum/job/butcher
	title = "Bistro Butcher"
	outfit = /datum/outfit/job/cutthroat
	department_head = list("The butchers")
	faction = "Station"
	supervisors = "Your refined pallete"
	selection_color = "#872020"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	paycheck = 500
	maptype = list("city")
	job_important = "This is a roleplay role. You work for Bistro, you're not inherenly hostile. \
			After all, people who die without having the chance to fear for their lives taste worse. \
			Help your boss have the world know about Bistro!"
	job_notice = "Avoid killing other players without some escalation."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

/datum/job/salsu/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()

/datum/outfit/job/butcher
	name = "Bistro Butcher"
	jobtype = /datum/job/butcher

	belt = /obj/item/pda/cook
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup