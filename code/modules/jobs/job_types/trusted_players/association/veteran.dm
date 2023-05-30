//Veteran
/datum/job/veteran
	title = "Association Veteran"
	outfit = /datum/outfit/job/veteran
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#e09660"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_VETERAN
	trusted_only = TRUE
	access = list(ACCESS_NETWORK)
	minimal_access = list(ACCESS_NETWORK)
	maptype = "wonderlabs"


	//They actually need this for their weapons
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/veteran/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	H.set_attribute_limit(100)
	to_chat(M, "<span class='userdanger'>This is a roleplay role. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. You are the second in command of the local association, \
	and can offer frontline command.</span>")
	to_chat(M, "<span class='danger'>Avoid killing other players without a reason. </span>")


/datum/outfit/job/veteran
	name = "Associate Veteran"
	jobtype = /datum/job/veteran

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
