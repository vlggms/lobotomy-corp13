//Butcher almost boss
/datum/job/sidechef
	title = "Bistro Side Chef"
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
	job_important = "This is a roleplay role. You are the assistant of the boss, you're not inherenly hostile. \
			After all, people who die without having the chance to fear for their lives taste worse. \
			Your purpose is to cook people and become stronger, Help your boss have the world know about Bistro!"
	job_notice = "Avoid killing other players without some escalation."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)

/datum/job/salsu/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()

/datum/outfit/job/headchef
	name = "Bistro Side Chef"
	jobtype = /datum/job/sidechef

	belt = /obj/item/pda/cook
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup