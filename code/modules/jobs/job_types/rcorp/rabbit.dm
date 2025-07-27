/datum/job/rabbit
	title = "R-Corp Suppressive Rabbit"
	faction = "Station"
	department_head = list("Rabbit Team Captain", "Commander")
	total_positions = 4
	spawn_positions = 3
	exp_requirements = 120
	supervisors = "the rabbit team captain and the commander"
	selection_color = "#d9b555"

	outfit = /datum/outfit/job/rabbit
	display_order = 9
	maptype = "rcorp"

	//Eat shit rabbits lol
	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "SGT"
	job_important = "You take the role of mobile ranged infantry."
	job_notice = "You are a Senior rabbit armed with a fully automatic rifle and multiphase blade. You are highly mobile and pack a punch."

/datum/job/rabbit/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/job/rabbit/assault
	title = "R-Corp Assault Rabbit"
	total_positions = 10
	spawn_positions = 8
	outfit = /datum/outfit/job/rabbit/assault
	rank_title = "RAF"
	job_important = "You take the role of mobile ranged infantry."
	job_notice = "You are a rabbit armed with a semi automatic, single phase rifle and blade with rush capabilities. You form the meat of the 4th pack."


/datum/job/rcorp_captain/rabbit
	title = "Rabbit Squad Captain"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d1a83b"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"

	outfit = /datum/outfit/job/rabbit/captain
	display_order = 5

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "You are the captain of the mobile ranged infantry division."
	job_notice = "Visit your bunks in the command tent to gather your one-handed rabbit gun and multiphase blade."



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
	r_pocket = /obj/item/pinpointer/nuke/rcorp

/datum/outfit/job/rabbit/assault
	name = "R-Corp Assault Rabbit"
	jobtype = /datum/job/rabbit/assault

	suit_store = /obj/item/ego_weapon/city/rabbit_rush
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/assault
	belt = null

/datum/outfit/job/rabbit/assault/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	var/belt = pick(
	/obj/item/gun/energy/e_gun/rabbitdash,
	/obj/item/gun/energy/e_gun/rabbitdash/small,
	/obj/item/gun/energy/e_gun/rabbitdash/sniper,
	/obj/item/gun/energy/e_gun/rabbitdash/white,
	/obj/item/gun/energy/e_gun/rabbitdash/black,
	/obj/item/gun/energy/e_gun/rabbitdash/shotgun,
	)
	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)



/datum/outfit/job/rabbit/captain
	name = "Rabbit Squad Captain"
	jobtype = /datum/job/rcorp_captain/rabbit
	glasses = /obj/item/clothing/glasses/hud/health/night/rabbit
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = null
	suit_store = null
	ears = /obj/item/radio/headset/heads/headset_control
