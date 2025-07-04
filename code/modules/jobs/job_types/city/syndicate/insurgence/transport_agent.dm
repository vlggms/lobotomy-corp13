//Insurgence Transport Agents
/datum/job/transport_agent
	title = "Insurgence Transport Agent"
	outfit = /datum/outfit/job/transport_agent
	department_head = list("the Nightwatch Agent")
	faction = "Station"
	supervisors = "the Nightwatch Agent and the Elder One"
	selection_color = "#aaaaaa"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 100
	maptype = list("city")
	job_important = "You are a Transport Agent for the Insurgence Clan. You are not inherently hostile. \
			Your goal is to distribute custom augments to civilians and track their Mental Corrosion levels. \
			Work with other agents to isolate targets and convince them to enter the Great Lake once they reach 60% Mental Corrosion. \
			Your base is hidden somewhere in the city - coordinate with the Nightwatch Agent to locate it."
	job_notice = "This is an RP-focused antagonist role. Avoid killing other players without reason. \
			Focus on psychological manipulation and augment distribution rather than direct violence."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

/datum/job/transport_agent/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()

/datum/outfit/job/transport_agent
	name = "Insurgence Transport Agent"
	jobtype = /datum/job/transport_agent

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(
		/obj/item/structurecapsule/syndicate = 1,
		/obj/item/paper/fluff/insurgence_instructions = 1
	)
