//Representative
/datum/job/representative
	title = "Main Office Representative"
	outfit = /datum/outfit/job/representative
	department_head = list("your corporation")
	faction = "Station"
	supervisors = "the manager"
	selection_color = "#777777"
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_REPRESENTATIVE
	trusted_only = TRUE
	access = list(ACCESS_PHARMACY, ACCESS_COMMAND) // I want to use the number 69.
	minimal_access = list(ACCESS_PHARMACY, ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND
	mapexclude = list("wonderlabs", "mini")

	job_abbreviation = "REP"

/datum/job/representative/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	outfit_owner.set_attribute_limit(0)
	to_chat(M, span_userdanger("This is a roleplay role. You are expected to roleplay as the representative for the corporation you chose. Feel free to ask any online admins to further any deals you make."))
	return ..()

/datum/outfit/job/representative
	name = "Main Office Representative"
	jobtype = /datum/job/representative

	belt = /obj/item/pda/lawyer
	ears = /obj/item/radio/headset/heads/rep
	uniform = /obj/item/clothing/under/suit/lobotomy
	shoes = /obj/item/clothing/shoes/laceup

	backpack_contents = list(
		/obj/item/storage/box/rxglasses/spyglasskit,
	)

/// Alternate corps you can pick
/datum/job/representative
	alt_titles = list(
		"R Corp Representative",
		"W Corp Representative",
		"K Corp Representative",
		"N Corp Representative",
		"P Corp Representative",
		"J Corp Representative",
	)

/datum/outfit/job/representative/rcorprepresentative
	name = "R Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/rcorp

/datum/outfit/job/representative/wcorprepresentative
	name = "W Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp_command

/datum/outfit/job/representative/kcorprepresentative
	name = "K Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/kcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/city/kcorp_sci

/datum/outfit/job/representative/ncorprepresentative
	name = "N Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/ncorp

/datum/outfit/job/representative/pcorprepresentative
	name = "P Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/pcorp

/datum/outfit/job/representitive/jcorprepresentative
	name = "J Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/jcorp
