//Insurgence Nightwatch Agent
/datum/job/nightwatch_agent
	title = "Insurgence Nightwatch Agent"
	outfit = /datum/outfit/job/nightwatch_agent
	department_head = list("the Elder One")
	faction = "Station"
	supervisors = "the will of the Elder One"
	selection_color = "#cccccc"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_CITY_ANTAGONIST
	paycheck = 700
	maptype = list("city")
	job_important = "This is a roleplay role. You are the leader of this Insurgence Clan cell. You are not inherently hostile. \
			As the leader, you coordinate the Transport Agents in distributing custom augments with Mental Corrosion. \
			Your goal is to track augment users and ensure they reach 60% Mental Corrosion, then convince or force them into the Great Lake. \
			You have access to a special cloaking ability through your armor. \
			Lead your Transport Agents to deliver augments, however if they reveal their true nature, feel free to execute them.\
			Your base is hidden in the alleyway in the east behind the NO ENTRY Door."
	job_notice = "This is an RP-focused antagonist role. Focus on psychological manipulation and converting humans rather than killing. \
			Only use violence when necessary to complete your objectives. Remember: 'For the Order of the Elder one...'"

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/nightwatch_agent/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Enable Transport Agent spawning when Nightwatch spawns
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/transport_agent))
			processing.total_positions = 4
	. = ..()

/datum/outfit/job/nightwatch_agent
	name = "Insurgence Nightwatch Agent"
	jobtype = /datum/job/nightwatch_agent

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	mask = /obj/item/clothing/mask/gas/syndicate
	glasses = /obj/item/clothing/glasses/hud/health/night
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(
		/obj/item/structurecapsule/syndicate/insurgence = 1,
		/obj/item/paper/fluff/insurgence_instructions = 1
	)
