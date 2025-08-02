/// Despite being just a Capo, this is the leader of Thumb East in CoL. Technically subordinate to Sottocapos if staff send one in.
/datum/job/east_capo
	title = "Thumb East Capo"
	outfit = /datum/outfit/job/east_capo
	department_head = list("the Hierarchy of the Thumb")
	faction = "Station"
	supervisors = "the Hierarchy of the Thumb"
	selection_color = "#861632"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_CITY_ANTAGONIST
	paycheck = 700
	maptype = list("city")
	job_important = "This is a roleplay role. You are in charge of a small squad of the Thumb's eastern branch. Your goal is to secure income for your squad and exert the Thumb's influence in this Nest. \
		Your rank is not the highest present in this Nest, but that does not mean you should allow yourself to be trampled over. You were sent for a reason, ensure the Thumb's presence here is firm. \
		You are not to tolerate anyone talking down to you, and none of the Thumb may use disguises. \
		You may order the death of any other player aside from the Hana Association and Association Director that does not give you the respect you deserve. \
		You may order the death of any of your soldatos for so much as questioning you. \
		On the base City of Light map, your base is hidden in the alleyway in the east behind the NO ENTRY Door. Use mentor-help if you are lost on a CoL submap."
	job_notice = "You may kill other players for any major disrespect; avoid killing players for minor infractions."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/east_capo/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/east_soldato))
			processing.total_positions = 4
	. = ..()


/datum/outfit/job/east_capo
	name = "Thumb East Capo"
	jobtype = /datum/job/east_capo

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list(/obj/item/structurecapsule/syndicate/thumb_east, /obj/item/office_marker/syndicate)
	shoes = /obj/item/clothing/shoes/laceup
