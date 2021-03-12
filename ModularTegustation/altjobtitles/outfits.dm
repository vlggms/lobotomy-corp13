//assistant
/datum/outfit/job/assistant/businessman
	name = "Assistant (Businessman)"
	uniform = /obj/item/clothing/under/suit/black_really
	l_hand = /obj/item/storage/briefcase

/datum/outfit/job/assistant/visitor
	name = "Assistant (Visitor)"
	uniform = /obj/item/clothing/under/misc/assistantformal
	neck = /obj/item/camera

/datum/outfit/job/assistant/trader
	name = "Assistant (Trader)"
	r_pocket = /obj/item/coin/gold
	backpack_contents = list(/obj/item/export_scanner=1)

/datum/outfit/job/assistant/entertainer
	name = "Assistant (Entertainer)"
	r_hand = /obj/item/bikehorn //hjonk

//atmos tech
/datum/outfit/job/atmos/firefighter
	name = "Atmospheric Technician (Firefighter)"
	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	head = /obj/item/clothing/head/hardhat/red
	l_hand = /obj/item/extinguisher

/datum/outfit/job/atmos/lifesupportspecialist
	name = "Atmospheric Technician (Life Support Specialist)"
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1, /obj/item/storage/box/survival=2)

//cook
/datum/outfit/job/cook/grillmaster
	uniform = /obj/item/clothing/under/rank/civilian/cookjorts
	suit = null
	head = null
	mask = null
	r_hand = /obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy

//curator
/datum/outfit/job/curator/journalist
	name = "Curator (Journalist)"
	uniform = /obj/item/clothing/under/suit/checkered
	head = /obj/item/clothing/head/fedora
	neck = /obj/item/camera
	l_hand = /obj/item/taperecorder
	l_pocket = /obj/item/newspaper
	backpack_contents = list(
		/obj/item/choice_beacon/hero = 1,
		/obj/item/soapstone = 1,
		/obj/item/tape = 1
	)

//lawyer
/datum/outfit/job/lawyer/corporaterepresentative
	uniform = /obj/item/clothing/under/suit/black
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	neck = /obj/item/clothing/neck/tie/blue
	l_hand = /obj/item/clipboard
	r_pocket = /obj/item/pen/fountain

//md
/datum/outfit/job/doctor/surgeon
	name = "Medical Doctor (Surgeon)"
	uniform = /obj/item/clothing/under/rank/medical/doctor/blue
	suit = /obj/item/clothing/suit/apron/surgical
	mask = /obj/item/clothing/mask/surgical

/datum/outfit/job/doctor/nurse
	name = "Medical Doctor (Nurse)"
	head = /obj/item/clothing/head/nursehat
	suit = null
	alt_uniform = /obj/item/clothing/under/rank/medical/doctor/nurse
	accessory = /obj/item/clothing/accessory/armband/medblue

/datum/outfit/job/doctor/psychiatrist
	name = "Medical Doctor (Psychiatrist)"
	uniform = /obj/item/clothing/under/suit/black
	suit = null
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id
	belt = /obj/item/pda/medical
	l_hand = /obj/item/clipboard
	backpack_contents = list(/obj/item/storage/pill_bottle/psicodine=1, /obj/item/storage/pill_bottle/happy=1, /obj/item/storage/pill_bottle/lsd=1)

//se
/datum/outfit/job/engineer/electrician
	name = "Station Engineer (Electrician)"
	l_hand = /obj/item/storage/toolbox/electrical
	gloves = /obj/item/clothing/gloves/color/grey

/datum/outfit/job/engineer/enginetechnician
	name = "Station Engineer (Engine Technician)"
	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	r_pocket = /obj/item/geiger_counter

/datum/outfit/job/engineer/maintenancetechnician
	name = "Station Engineer (Maintenance Technician)"
	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/hazardvest
	accessory = /obj/item/clothing/accessory/armband/engine
	r_pocket = /obj/item/stack/cable_coil
	l_pocket = /obj/item/flashlight
	l_hand = /obj/item/bag/construction
