//Index Messenger
/datum/job/messenger
	title = "Index Messenger"
	outfit = /datum/outfit/job/messenger
	department_head = list("the will of the prescript")
	faction = "Station"
	supervisors = "the will of the prescript"
	selection_color = "#cccccc"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_CITY_ANTAGONIST
	paycheck = 700
	maptype = list("city")
	job_important = "This is a roleplay role. You are the leader of this index branch. You are not inherently hostile. \
			As the leader, you can write prescripts in the back office for your subordinates to complete. \
			You do not need to hide, do not wear disguises. \
			Your base is hidden in the alleyway in the east behind the NO ENTRY Door."
	job_notice = "Avoid killing other players without a reason. Killing a player for stopping your prescripts is a valid reason."


	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/messenger/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/proxy))
			processing.total_positions = 1

		if(istype(processing, /datum/job/proselyte))
			processing.total_positions = 2
	. = ..()


/datum/outfit/job/messenger
	name = "Index Messenger"
	jobtype = /datum/job/messenger

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list(/obj/item/structurecapsule/syndicate)
	shoes = /obj/item/clothing/shoes/laceup
