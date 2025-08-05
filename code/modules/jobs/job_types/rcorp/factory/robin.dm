GLOBAL_LIST_INIT(robin_sectionleaders, list("Section B", "Section C"))
GLOBAL_LIST_INIT(robin_sergeants, list("Section A", "Section B", "Section C"))

/datum/job/rcorp_captain/robin
	title = "Robin Squad Captain"
	faction = "Station"
	department_head = list("Commanders")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commanders"
	selection_color = "#a18438"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/robin_captain
	display_order = 2

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "You take the role of acquisitions team captain."
	job_notice = "Manage both of your section leaders, and all 3 sections. You also directly manage Section A."
	req_admin_notify = 1

/datum/job/rcorp_captain/robin/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/outfit/job/robin_captain
	name = "Robin Squad Captain"
	jobtype = /datum/job/rcorp_captain/robin

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/beret/tegu/lobotomy/wcorpaxe
	suit = null
	belt = null
	l_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE



/datum/job/robin_leader
	title = "Robin Section Leader"
	faction = "Station"
	department_head = list("Robin Team Captain", "Commanders")
	total_positions = 2
	spawn_positions = 2
	supervisors = "the robin team captain and commanders."
	selection_color = "#d9b555"
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/robin_leader
	display_order = 3


	access = list()
	minimal_access = list()

	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)
	rank_title = "LT"
	job_important = "You are a the leader of a section of Robins. "
	job_notice = "You have an a squad leader and 3 Robins underneath you. Gather your men, and follow the orders of your team captain."

/datum/job/robin_leader/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	var/squad = pick_n_take(GLOB.robin_sectionleaders)
	.=..()
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	to_chat(M, span_userdanger("You are the leader of [squad]."))

	var/head = null
	switch(squad)
		if("Section B")
			head = /obj/item/clothing/head/beret/sec/wcorpbuckler
		if("Section C")
			head = /obj/item/clothing/head/beret/tegu/lobotomy/wcorpcleaver
	if(head)
		if(outfit_owner.head)
			qdel(outfit_owner.head)
		outfit_owner.equip_to_slot_or_del(new head(outfit_owner),ITEM_SLOT_HEAD)


/datum/outfit/job/robin_leader
	name = "Robin Section Leader"
	jobtype = /datum/job/robin_leader

	ears = null
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = null
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = null
	l_pocket = /obj/item/commandprojector
	r_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE


/datum/job/robin_sergeant
	title = "Robin Squad Sergeant"
	faction = "Station"
	department_head = list("Robin Section Leader", "Commanders")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the robin team captain and commanders."
	selection_color = "#d9b555"
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/robin_sergeant
	display_order = 4


	access = list()
	minimal_access = list()

	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)
	rank_title = "SGT"
	job_important = "You are a the leader of a squad of Robins."
	job_notice = "You takes orders from your section leader and give orders to 3 Robins underneath you. Gather your men, and follow the orders of your section leader."

/datum/job/robin_sergeant/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	var/squad = pick_n_take(GLOB.robin_sergeants)
	.=..()
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	to_chat(M, span_userdanger("You are the squad leader of [squad]. Report to your section leader immediately!"))

	var/head = null
	switch(squad)
		if("Section A")
			head = /obj/item/clothing/head/beret/tegu/lobotomy/wcorpaxe
		if("Section B")
			head = /obj/item/clothing/head/beret/sec/wcorpbuckler
		if("Section C")
			head = /obj/item/clothing/head/beret/tegu/lobotomy/wcorpcleaver
	if(head)
		if(outfit_owner.head)
			qdel(outfit_owner.head)
		outfit_owner.equip_to_slot_or_del(new head(outfit_owner),ITEM_SLOT_HEAD)

/datum/outfit/job/robin_sergeant
	name = "Robin Squad Sergeant"
	jobtype = /datum/job/robin_sergeant

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = null
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = null
	r_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE


/datum/outfit/job/robin
	name = "Robin"
	jobtype = /datum/job/robin

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = null
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = null
	r_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE


//It's easier as their own jobs than to make a system to slot them into fucking squads

/datum/job/robin
	title = "Section A Robin"
	faction = "Station"
	department_head = list("Robin Squad Sergeant", "Commanders")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the robin team captain and commanders."
	selection_color = "#d9b555"
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/robin/a
	display_order = 5.1


	access = list()
	minimal_access = list()

	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)
	rank_title = "RAF"
	job_important = "You are an infantry unit. Report to your Section Commander (Green Berets)."


/datum/outfit/job/robin/a
	name = "Section A Robin"
	jobtype = /datum/job/robin


/datum/job/robin/b
	title = "Section B Robin"

	outfit = /datum/outfit/job/robin/b
	display_order = 5.2
	job_important = "You are an infantry unit. Report to your Section Commander (Red Berets)."

/datum/outfit/job/robin/b
	name = "Section B Robin"
	jobtype = /datum/job/robin/b

/datum/job/robin/c
	title = "Section C Robin"

	outfit = /datum/outfit/job/robin/c
	display_order = 5.3
	job_important = "You are an infantry unit. Report to your Section Commander (Blue Berets)."


/datum/outfit/job/robin/c
	name = "Section C Robin"
	jobtype = /datum/job/robin/c
