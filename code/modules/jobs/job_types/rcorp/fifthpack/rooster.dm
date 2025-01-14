/datum/job/rooster
	title = "R-Corp Rooster"
	faction = "Station"
	department_head = list("Rooster Squad Leader", "Commander")
	total_positions = 4
	spawn_positions = 3
	exp_requirements = 120
	supervisors = "the rooster squad leader and the commander"
	selection_color = "#d13711"

	outfit = /datum/outfit/job/rooster
	display_order = 14
	maptype = "rcorp_fifth"

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "SGT" // Keep SGT becaues they're akin to Rhinos, but without mechs.
	job_important = "You take the role of heavy ranged infantry."
	job_notice = "You are a Rooster armed with a fully automatic light machinegun. You push forward and help define the frontline."

/datum/job/rooster/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)


/datum/job/rcorp_captain/rooster
	title = "Rooster Squad Leader"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d13711"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_fifth"

	outfit = /datum/outfit/job/rooster/leader
	display_order = 5

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 130,
								PRUDENCE_ATTRIBUTE = 130,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "LT"
	job_important = "You are the squad leader of the heavy ranged infantry division."
	//job_notice = "Visit your bunks in the command tent to gather your one-handed rabbit gun and multiphase blade."


// Mostly uneditted outfit datums for gear that doesn't exist yet. Both need Multiphase LMG.
/datum/outfit/job/rooster
	name = "R-Corp Rooster"
	jobtype = /datum/job/rooster

	ears = /obj/item/radio/headset/headset_discipline
	glasses = /obj/item/clothing/glasses/sunglasses
	suit_store = /obj/item/gun/energy/e_gun/rabbit/minigun/tricolor
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = null //I have nothing lol
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeerberserk
	l_pocket = /obj/item/flashlight/rooster
	r_pocket = /obj/item/pinpointer/nuke/rcorp

/datum/outfit/job/rooster/leader
	name = "Rooster Squad Leader"
	jobtype = /datum/job/rcorp_captain/rooster
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeerberserk
	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = /obj/item/clothing/head/beret/tegu/rcorpofficer
	ears = /obj/item/radio/headset/heads/headset_discipline


/obj/item/flashlight/rooster
	name = "high powered flashlight"
	light_system = MOVABLE_LIGHT
	light_range = 10
	light_power = 1
