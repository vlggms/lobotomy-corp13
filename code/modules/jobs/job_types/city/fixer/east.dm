//The leader is whitelisted.

//Director
/datum/job/fixer/eastdirector
	title = "East Office Director"
	outfit = /datum/outfit/job/edirector
	department_head = list("your office")
	faction = "Station"
	supervisors = "your office"
	selection_color = "#8f6791"
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_FIXERLEAD
	paycheck = 100
	trusted_only = TRUE
	access = list(ACCESS_MINING_STATION, ACCESS_RC_ANNOUNCE) // East office is 54
	minimal_access = list(ACCESS_MINING_STATION, ACCESS_RC_ANNOUNCE)
	maptype = list("city-small", "wonderlabs")

	job_attribute_limit = 80
	//80s in everything, they're barebones goobers
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/fixer/eastdirector/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	to_chat(M, "<span class='userdanger'>Fixers of the East office need to purchase their weapons from the workshop. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. Please use the beacon in your office to choose your association. \
	Do not assist L Corporation without significant payment.</span>")
	to_chat(M, "<span class='danger'>Avoid killing other players without a reason. </span>")

	//Don't spawn fixers without a director
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/fixer/east))
			processing.total_positions = 2

/datum/outfit/job/edirector
	name = "East Office Director"
	jobtype = /datum/job/fixer/eastdirector

	belt = /obj/item/pda/security
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/sneakers/black




//Associate fixer, Not whitelisted
/datum/job/fixer/east
	title = "East Office Fixer"
	outfit = /datum/outfit/job/efixer
	department_head = list("office director")
	faction = "Station"
	supervisors = "your office director"
	selection_color = "#bd7ebf"
	total_positions = 0
	spawn_positions = 0
	trusted_only = FALSE
	display_order = JOB_DISPLAY_ORDER_FIXER
	access = list(ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_MINING_STATION)
	maptype = "wonderlabs"

	job_attribute_limit = 60
	//They actually need this for their weapons
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

/datum/job/fixer/east/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	//Not fear immune you're basically some goober
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	to_chat(M, "<span class='userdanger'>Fixers of the East office need to purchase their weapons from the workshop.\
	Follow your Office Leader. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. </span>")
	to_chat(M, "<span class='danger'>Avoid killing other players without a reason. </span>")


/datum/outfit/job/efixer
	name = "East Office Fixer"
	jobtype = /datum/job/fixer/east

	belt = /obj/item/pda/security
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
