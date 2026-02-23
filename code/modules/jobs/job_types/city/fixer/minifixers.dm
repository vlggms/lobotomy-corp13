/datum/job/fixer/smalldirector
	title = "Office Director"
	outfit = /datum/outfit/job/smalldirector
	selection_color = "#8f6791"
	total_positions = 1
	spawn_positions = 1
	trusted_only = FALSE
	display_order = JOB_DISPLAY_ORDER_FIXERLEAD
	paycheck = 170
	access = list(ACCESS_XENOBIOLOGY, ACCESS_RC_ANNOUNCE) // Numero 55
	minimal_access = list(ACCESS_XENOBIOLOGY, ACCESS_RC_ANNOUNCE)
	departments = DEPARTMENT_FIXERS
	maptype = "office"
	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

/datum/job/fixer/smalldirector/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	to_chat(M, "<span class='userdanger'>This is a roleplay role. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. Please use the beacon in your office to choose your association. \
	Do not assist L Corporation without significant payment.</span>")
	to_chat(M, "<span class='danger'>Avoid killing other players without a reason. </span>")

	//Don't spawn fixers without a director
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/fixer/small))
			processing.total_positions = -1

/datum/outfit/job/smalldirector
	name = "Office Director"
	jobtype = /datum/job/fixer/smalldirector

	uniform = /obj/item/clothing/under/suit/charcoal
	belt = null
	ears = null
	id = /obj/item/card/id/fixerdirector
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/sneakers/black



/datum/job/fixer/small
	title = "Office Fixer"
	outfit = /datum/outfit/job/smallfixer
	department_head = list("office director")
	supervisors = "your office director"
	selection_color = "#bd7ebf"
	total_positions = 0
	spawn_positions = 0
	trusted_only = FALSE
	display_order = JOB_DISPLAY_ORDER_FIXER
	departments = DEPARTMENT_FIXERS
	access = list(ACCESS_XENOBIOLOGY)
	minimal_access = list(ACCESS_XENOBIOLOGY)
	maptype = "office"
	paycheck = 170

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

/datum/outfit/job/smallfixer
	name = "Office Fixer"
	jobtype = /datum/job/fixer/small

	uniform = /obj/item/clothing/under/suit/charcoal
	belt = null
	ears = null
	id = /obj/item/card/id/fixercard
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/sneakers/black
