
// Captain
/datum/job/agent/captain
	title = "Agent Captain"
	selection_color = "#BB9999"
	total_positions = 1
	spawn_positions = 1
	outfit = /datum/outfit/job/agent/captain
	display_order = JOB_DISPLAY_ORDER_CAPTAIN

	access = list(ACCESS_COMMAND) // LC13:To-Do
	departments = DEPARTMENT_COMMAND | DEPARTMENT_SECURITY
	exp_requirements = 6000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	mapexclude = list("wonderlabs", "mini")
	job_important = "You are an Agent Captain. As an experienced Agent, you are expected to disseminate important information and use your experience lead other Agents."

	job_abbreviation = "CPT"

/datum/job/agent/captain/after_spawn(mob/living/carbon/human/outfit_owner, mob/M, latejoin = FALSE)
	..()
	var/datum/action/G = new /datum/action/cooldown/warbanner/captain
	G.Grant(outfit_owner)

	G = new /datum/action/cooldown/warcry/captain
	G.Grant(outfit_owner)

/datum/outfit/job/agent/captain
	name = "Agent Captain"
	jobtype = /datum/job/agent/captain
	head = /obj/item/clothing/head/hos/beret
	ears = /obj/item/radio/headset/heads/agent_captain/alt
	l_pocket = /obj/item/commandprojector

	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/info_printer,
		/obj/item/announcementmaker/lcorp,
	)

/datum/action/cooldown/warbanner/captain
	range = 6
	affect_self = FALSE

/datum/action/cooldown/warcry/captain
	range = 6
	affect_self = FALSE
