//BL Ronin, a job to hunt down Kurokumo
/datum/job/ronin
	title = "Blade Lineage Ronin"
	outfit = /datum/outfit/job/ronin
	department_head = list("the code of honor")
	faction = "Station"
	supervisors = "the code of honor"
	selection_color = "#59578a"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEEXTRA
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	paycheck = 700
	maptype = list("city")
	job_important = "You are not apart of Kurokumo Clan. \
				You are wandering the city in pursuit of the Kurokumo clan. \
				Your life's work is to hunt them down and kill them. \
				All other blade lineage rules apply; and Kurokumo Clan members are always dishonorable."
	job_notice = "Avoid killing other players without a reason. Killing weak players not in self-defense is cowardly."


	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/cutthroat/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/ronin
	name = "Blade Lineage Ronin"
	jobtype = /datum/job/ronin

	belt = /obj/item/ego_weapon/city/bladelineage
	ears = null
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list(/obj/item/structurecapsule/syndicate/bladelineage)
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin
