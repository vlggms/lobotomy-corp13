//Kurokumo Captain
/datum/job/kurocaptain
	title = "Kurokumo Kashira"
	outfit = /datum/outfit/job/kurocaptain
	department_head = list("money and order.")
	faction = "Station"
	supervisors = "money and order."
	selection_color = "#856948"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_CITY_ANTAGONIST
	paycheck = 700
	maptype = list("city")
	job_important = "This is a roleplay role. You are the leader of this kurokumo branch. \
		Much like The Thumb, Kurokumo demands respect, but mostly from people inside the organization. \
		Take workshops, businesses and fixers under your protection for a slice of profit, turn this town into your racketeering scheme. \
		If they cannot pay, take their limbs until they do. \
		You are supplied with two hosa and three wakashu. The hosa get money from your territory, and you and the Wakashu are to proetct it. \
		Your base is hidden in the alleyway in the east behind the NO ENTRY Door."
	job_notice = "You may kill other kurokumo for any major disrespect to kurokumo or thumb."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/kurocaptain/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/kuroenforcer))
			processing.total_positions = 2

		if(istype(processing, /datum/job/kurowakashu))
			processing.total_positions = 4

		if(istype(processing, /datum/job/ronin))
			processing.total_positions = 1
	. = ..()


/datum/outfit/job/kurocaptain
	name = "Kurokumo Kashira"
	jobtype = /datum/job/kurocaptain

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list(/obj/item/structurecapsule/syndicate/kurokumo)
	shoes = /obj/item/clothing/shoes/laceup
