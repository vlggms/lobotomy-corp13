/*
Assistant
*/
/datum/job/assistant
	title = "General Clerk"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT



/datum/outfit/job/assistant
	name = "General Clerk"
	jobtype = /datum/job/assistant
	uniform = /obj/item/clothing/under/suit/black

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	..()
	if(uniform != /obj/item/clothing/under/color/grey)//tegu edit alt job titles
		return//tegu edit too but you should have already known that
	if (CONFIG_GET(flag/grey_assistants))
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/grey
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/grey
	else
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/random
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/random
