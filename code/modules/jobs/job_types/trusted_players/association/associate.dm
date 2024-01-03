//Associate fixer
/datum/job/associate
	title = "Association Fixer"
	outfit = /datum/outfit/job/associate
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#e09660"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_ASSOCIATION
	trusted_only = TRUE
	access = list(ACCESS_NETWORK)
	minimal_access = list(ACCESS_NETWORK)
	paycheck = 700
	maptype = list("wonderlabs", "city")


	//They actually need this for their weapons
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/associate/after_spawn(mob/living/carbon/human/H, mob/M)
	//Not fear immune you're basically some goober
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	to_chat(M, "<span class='userdanger'>This is a roleplay role. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. </span>")
	to_chat(M, "<span class='danger'>Avoid killing other players without a reason. </span>")
	H.set_attribute_limit(80)
	. = ..()


/datum/outfit/job/associate
	name = "Associate Fixer"
	jobtype = /datum/job/associate

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/association
