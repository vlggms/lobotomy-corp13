//Representative
/datum/job/representative
	title = "Main Office Representative"
	outfit = /datum/outfit/job/representative
	department_head = list("your corporation")
	faction = "Station"
	supervisors = "the manager"
	selection_color = "#e09660"
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_REPRESENTATIVE
	trusted_only = TRUE
	access = list(ACCESS_PHARMACY, ACCESS_COMMAND) // I want to use the number 69.
	minimal_access = list(ACCESS_PHARMACY, ACCESS_COMMAND)
	mapexclude = list("wonderlabs", "mini")


	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 0,
								PRUDENCE_ATTRIBUTE = 0,
								TEMPERANCE_ATTRIBUTE = 0,
								JUSTICE_ATTRIBUTE = 0
								)

/datum/job/representative/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	H.set_attribute_limit(0)
	to_chat(M, "<span class='userdanger'>This is a roleplay role. You are expected to roleplay as the representative for the corporation you chose. Feel free to ask any online admins to further any deals you make.</span>")
	. = ..()

/datum/outfit/job/representative
	name = "Main Office Representative"
	jobtype = /datum/job/representative

	belt = /obj/item/pda/lawyer
	ears = /obj/item/radio/headset/heads
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup

/// Alternate corps you cna pick
/datum/job/representative
	alt_titles = list("R Corp Representative", "W Corp Representative",
			"K Corp Representative", "N Corp Representative", "P Corp Representative")

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
