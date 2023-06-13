/datum/job/juniorofficer
	title = "Operations Officer"
	faction = "Station"
	department_head = list("Lieutenant Commander", "Ground Commander")
	total_positions = 3
	spawn_positions = 3
	supervisors = "your senior officers"
	selection_color = "#a18438"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"
	outfit = /datum/outfit/job/officer
	display_order = 1.99

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	access = list(ACCESS_COMMAND)
	minimal_access = (ACCESS_COMMAND)
	rank_title = "LT"
	job_important = "You are a non-combative support and command role in Rcorp. Advise the Commander, protect and man the base."
	job_notice = "Run the Requisitions, assist Rcorp personnel on the base, and ship supplies to the frontline."

	alt_titles = list("Staff Officer", "Field Officer",	"Command Officer",	"Junior Officer")


/datum/outfit/job/officer
	name = "Operations Officer"
	jobtype = /datum/job/juniorofficer
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	ears =  /obj/item/radio/headset/heads
	head = /obj/item/clothing/head/beret/tegu/rcorpofficer
	l_pocket = /obj/item/commandprojector


// Beret
/obj/item/clothing/head/beret/tegu/rcorpofficer
	name = "lieutenant's beret"
	desc = "An orange beret used by Rcorp junior officers."
	icon_state = "beret_engineering"

