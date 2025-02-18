//Thumb capo
/datum/job/capo
	title = "Thumb Capo"
	outfit = /datum/outfit/job/capo
	department_head = list("the sottocapo.")
	faction = "Station"
	supervisors = "the sottocapo."
	selection_color = "#b0936f"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEVET
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 200
	maptype = list("city")
	job_important = "You are a lieutenant in the Thumb Syndicate. You are to be respectful and follow orders from the sottocapo. Not doing either will result in death. \
		Under you is two soldatos, you may treat them as you will. Heirarchy is king."
	job_notice = "Avoid killing other players without a reason, any fixers or soldatos disrespecting you is a valid reason."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/capo/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/capo
	name = "Thumb capo"
	jobtype = /datum/job/capo

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
