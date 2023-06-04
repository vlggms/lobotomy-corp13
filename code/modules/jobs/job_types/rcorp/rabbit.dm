/datum/job/rabbit
	title = "R-Corp Suppressive Rabbit"
	faction = "Station"
	department_head = list("Rabbit Team Captain", "Commander")
	total_positions = 4
	spawn_positions = 3
	supervisors = "the rabbit team captain and the commander"
	selection_color = "#d9b555"

	outfit = /datum/outfit/job/rabbit
	display_order = 9
	maptype = "rcorp"

	//Eat shit rabbits lol
	access = list()
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

/datum/job/rabbit/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/job/rabbit/assault
	title = "R-Corp Assault Rabbit"
	total_positions = 10
	spawn_positions = 8
	outfit = /datum/outfit/job/rabbit/assault

/datum/job/rcorp_captain/rabbit
	title = "Rabbit Squad Captain"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d1a83b"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"

	outfit = /datum/outfit/job/rabbit/captain
	display_order = 5

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)


/datum/outfit/job/rabbit
	name = "R-Corp Suppressive Rabbit"
	jobtype = /datum/job/rabbit

	ears = /obj/item/radio/headset/headset_control
	glasses = /obj/item/clothing/glasses/sunglasses
	suit_store = /obj/item/gun/energy/e_gun/rabbit/nopin
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/grunts
	l_pocket = /obj/item/flashlight/seclite

/datum/outfit/job/rabbit/assault
	name = "R-Corp Assault Rabbit"
	jobtype = /datum/job/rabbit

	suit_store = /obj/item/gun/energy/e_gun/rabbitdash
	belt = /obj/item/ego_weapon/city/rabbit_rush



/datum/outfit/job/rabbit/captain
	name = "Rabbit Squad Captain"
	jobtype = /datum/job/rcorp_captain/rabbit
	glasses = /obj/item/clothing/glasses/hud/health/night
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = null
	suit_store = null
	ears = /obj/item/radio/headset/heads/headset_control
