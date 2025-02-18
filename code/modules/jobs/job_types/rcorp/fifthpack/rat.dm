/datum/job/rat
	title = "R-Corp Rat"
	faction = "Station"
	department_head = list("Rat Squad Leader", "Commander")
	total_positions = 15
	spawn_positions = 15
	supervisors = "the rat squad leader and the commander"
	selection_color = "#d13711"

	outfit = /datum/outfit/job/rat
	display_order = 10
	maptype = "rcorp_fifth"

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "RAF"
	job_important = "You take the role of a diverse operations unit. You also take the role of a healer. No one else has medical equipment aside from you."
	job_notice = "You are a Rat armed with a shotgun, multiphase-knife, and micro-healthkit. Your role is whatever the mission needs at the moment."

/datum/job/rat/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

/datum/job/rcorp_captain/rat
	title = "Rat Squad Leader"
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

	outfit = /datum/outfit/job/rat/leader
	display_order = 2

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80,
								)
	rank_title = "LT"
	job_important = "You are the squad leader of the diverse operations division."
	//job_notice = "Visit your bunks in the command tent to gather your one-handed rabbit gun and multiphase blade."

/datum/job/rcorp_captain/rat/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

// Mostly uneditted outfit datums for gear that doesn't exist yet.
/datum/outfit/job/rat
	name = "R-Corp Rat"
	jobtype = /datum/job/rat

	ears = /obj/item/radio/headset/headset_welfare
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/rat
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/rat
	belt = /obj/item/ego_weapon/city/rabbit_blade
	suit_store = /obj/item/gun/energy/e_gun/rabbitdash/shotgun
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp
	backpack_contents = list(
		/obj/item/grenade/r_corp,
		/obj/item/grenade/r_corp/black,
		/obj/item/grenade/r_corp/white,
		/obj/item/storage/firstaid/revival = 1)


/datum/outfit/job/rat/leader
	name = "Rat Squad Leader"
	jobtype = /datum/job/rcorp_captain/rat

	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = /obj/item/clothing/head/beret/tegu/rcorpofficer
	ears = /obj/item/radio/headset/heads/headset_welfare
