//Butcher boss
/datum/job/headchef
	title = "Bistro Head Chef"
	outfit = /datum/outfit/job/cutthroat
	department_head = list("The butchers")
	faction = "Station"
	supervisors = "Your refined pallete"
	selection_color = "#872020"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	paycheck = 1000
	maptype = list("city")
	job_important = "This is a roleplay role. You are the leader of this Bistro, you're not inherenly hostile. \
			After all, people who die without having the chance to fear for their lives taste worse. \
			Every butcher must obey your every command, you tell them to fetch the ingredients and you cook them.\
			Your purpose is to cook people and become stronger, let the world know about your amazing food!"
	job_notice = "Avoid killing other players without some escalation."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

/datum/job/cutthroat/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/sidechef))
			processing.total_positions = 1
	. = ..()

		if(istype(processing, /datum/job/butcher))
			processing.total_positions = 6
	. = ..()

/datum/outfit/job/headchef
	name = "Bistro Head Chef"
	jobtype = /datum/job/headchef

	belt = /obj/item/pda/cook
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list(/obj/item/structurecapsule/syndicate/butcher)
	shoes = /obj/item/clothing/shoes/laceup