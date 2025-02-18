//Grand Inquisitor
/datum/job/grandinquis
	title = "Grand Inquisitor"
	outfit = /datum/outfit/job/grandinquis
	department_head = list("the glory of righteousness.")
	faction = "Station"
	supervisors = "the glory of righteousness."
	selection_color = "#b5a357"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_CITY_ANTAGONIST
	paycheck = 700
	maptype = list("city")
	job_important = "This is a roleplay role. You are the leader of this NCorp inquisition. \
		Your goal is simple, kill and torture everyone with prosthetics, and anyone who defends them. \
		You may kill or amputate, without warning, anyone with prosthetic limbs. \
		Your presence must be known, do not wear disguises. \
		You only start with Mittlehammers and a Grosshammer, you need to recruit new Kleinhammers. \
		Your base is hidden in the alleyway in the east behind the NO ENTRY Door."
	job_notice = "You may kill anyone with prosthetics, or anyone sympathetic to prosthetics."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 120,
								PRUDENCE_ATTRIBUTE = 120,
								TEMPERANCE_ATTRIBUTE = 120,
								JUSTICE_ATTRIBUTE = 120
								)

/datum/job/grandinquis/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/grosshammer))
			processing.total_positions = 1

		if(istype(processing, /datum/job/mittlehammer))
			processing.total_positions = 2
	. = ..()


/datum/outfit/job/grandinquis
	name = "Grand Inquisitor"
	jobtype = /datum/job/grandinquis

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list(/obj/item/structurecapsule/syndicate/ncorp)
	shoes = /obj/item/clothing/shoes/laceup
