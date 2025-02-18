//Hana
/datum/job/hana
	title = "Hana Representative"
	outfit = /datum/outfit/job/hana
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#ffffff"
	total_positions = 2
	spawn_positions = 2
	display_order = JOB_DISPLAY_ORDER_CAPTAIN
	trusted_only = TRUE
	access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER, ACCESS_CHANGE_IDS)
	minimal_access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER, ACCESS_CHANGE_IDS)
	departments = DEPARTMENT_HANA
	paycheck = 0
	maptype = list("city", "fixers")
	job_important = "You are the city's administrator, and have a small sort of power over the local association. \
		You MUST assist new fixer offices in getting set up, as well as issuing fixer licenses. \
		All new fixer offices MUST be announced upon creation, including office name and director name."
	job_notice = "Along with this, you may announce new taboos (which must be announced), and issue the association to enforce them. \
		You may also grade fixers, administer quests, and perform office inspections at your leisure. \
		For more information, see https://wiki.lc13.net/view/Hana_Association"


	//Mostly for armor.
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)

/datum/job/hana/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

	//Don't give this shit to the interns, my lord
	if(paycheck==0)
		add_verb(outfit_owner, /client/proc/hanafetchquest)
//		add_verb(outfit_owner, /client/proc/hanaslayquest)
	if(SSmaptype.maptype == "fixers")
		for(var/datum/job/processing in SSjob.occupations)
			if(istype(processing, /datum/job/associateroaming) && processing.total_positions<6)	//Can have a max of 6 of these
				processing.total_positions +=2

	. = ..()

	return ..()

/datum/outfit/job/hana
	name = "Hana Representative"
	jobtype = /datum/job/hana

	id = /obj/item/card/id/silver/plastic
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/clothing/suit/armor/ego_gear/city/hana
	l_pocket = /obj/item/potential_tester

	backpack_contents = list()

//Hana
/datum/job/hana/boss
	title = "Hana Administrator"
	outfit = /datum/outfit/job/hana/admin
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_MANAGER
	departments = DEPARTMENT_COMMAND | DEPARTMENT_HANA
	paycheck = 0


	//Mostly for armor.
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)


/datum/outfit/job/hana/admin
	name = "Hana Administrator"
	jobtype = /datum/job/hana/boss

	ears = /obj/item/radio/headset/heads/headset_association
	l_hand = /obj/item/clothing/suit/armor/ego_gear/city/hanacombat/paperwork

//Hana
/datum/job/hana/intern
	title = "Hana Intern"
	outfit = /datum/outfit/job/hana/intern
	total_positions = 2
	spawn_positions = 2
	display_order = JOB_DISPLAY_ORDER_INTERN
	paycheck = 1000
	trusted_only = FALSE


	//Mostly for armor.
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

	job_important = "You are a Intern for the Hana association, Your only job is to assist the higher ups with their duities. \
		You MUST assist new fixer offices in getting set up, as well as issuing fixer licenses. \
		All new fixer offices MUST be announced upon creation, including office name and director name. "
	job_notice = "For more information, see https://wiki.lc13.net/view/Hana_Association"


/datum/outfit/job/hana/intern
	name = "Hana Intern"
	jobtype = /datum/job/hana/intern
	l_hand = null


/client/proc/hanafetchquest()
	set name = "Issue Fetch Quest"
	set category = "Hana Quests"

	minor_announce("Hana has issued a request for a diamond coin. Payment will be given upon quest completion", "Hana Assignment:", TRUE)
	var/T = pick(SScityevents.distortion)
	var/Y = /obj/item/coin/diamond
	new Y (get_turf(T))

/client/proc/hanaslayquest()
	set name = "Issue Slay Quest"
	set category = "Hana Quests"

	minor_announce("Hana has issued a kill request on an unknown distortion. Payment will be given upon quest completion", "Hana Assignment:", TRUE)
	var/T = pick(SScityevents.distortion)
	new /obj/effect/bloodpool(get_turf(T))
	sleep(10)
	var/spawning = pick(SScityevents.distortions_available)
	new spawning (get_turf(T))
