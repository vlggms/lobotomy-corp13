/datum/job/manager
	title = "Manager"
	department_head = list("L Corp")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the manager"
	selection_color = "#ccccff"

	outfit = /datum/outfit/job/manager

	access = list() // LC13:To-Do
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 0,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 0,
								JUSTICE_ATTRIBUTE = 0
								)

/datum/job/manager/announce(mob/living/carbon/human/H)
	..()
	var/displayed_rank = title // Tegu Edit: Alt Titles
	displayed_rank = H?.client?.prefs?.alt_titles_preferences[title]
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "[displayed_rank] [H.real_name] has arrived to the facility."))

/datum/outfit/job/manager
	name = "Manager"
	jobtype = /datum/job/manager

	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/captain/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit =  /obj/item/clothing/suit/toggle/labcoat
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
