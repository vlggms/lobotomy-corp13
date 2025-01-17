/datum/job/supportofficer
	title = "Support Officer"
	faction = "Station"
	department_head = list("Lieutenant Commander", "Ground Commander")
	total_positions = 3
	spawn_positions = 3
	supervisors = "your senior officers"
	selection_color = "#a18438"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_fifth"
	outfit = /datum/outfit/job/supportofficer
	display_order = 1.99

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	access = list(ACCESS_COMMAND)
	minimal_access = (ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP
	rank_title = "LT"
	job_important = "You are a support and command role in Rcorp. Advise the Commander, Run requisitions and then deploy."
	job_notice = "Run the Requisitions, assist Rcorp personnel on the base. After deployment, use your beacon to select which class you'd like."

/datum/job/supportofficer/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	var/datum/action/G = new /datum/action/cooldown/warbanner/captain
	G.Grant(H)

	G = new /datum/action/cooldown/warcry/captain
	G.Grant(H)


/datum/outfit/job/supportofficer
	name = "Support Officer"
	jobtype = /datum/job/supportofficer
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/officer
	belt = /obj/item/ego_weapon/city/rabbit_blade
	ears =  /obj/item/radio/headset/heads
	head = /obj/item/clothing/head/beret/tegu/rcorpofficer
	l_hand = /obj/item/choice_beacon/officer
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/flashlight/seclite
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/officer
