//Kurokumo Hosa
/datum/job/kuroenforcer
	title = "Kurokumo Hosa"
	outfit = /datum/outfit/job/kuroenforcer
	department_head = list("the kashira.")
	faction = "Station"
	supervisors = "the kashira."
	selection_color = "#b0936f"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEVET
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 200
	maptype = list("city")
	job_important = "You are an enforcer in the Kurokumo clan. You are to be respectful and follow orders from the Kashira. Not doing either will result in death. \
		Unlike the Kashira and their Wakashu, your main goal is to enforce the law among the Wakashu and your territory, and are not really made for defending it. \
		Enforce the Kurokumo law on the civilians."
	job_notice = "Avoid killing other players for no reason. Multilation is on the table. "

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/kuroenforcer/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/kuroenforcer
	name = "Kurokumo Hosa"
	jobtype = /datum/job/kuroenforcer

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
