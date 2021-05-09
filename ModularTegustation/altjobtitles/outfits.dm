/*** Command ***/
/datum/outfit/job/captain/commodore
	name = "Captain (Commodore)"
	head = /obj/item/clothing/head/caphat/parade
	uniform = /obj/item/clothing/under/rank/captain/parade
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/alt
	shoes = /obj/item/clothing/shoes/jackboots

/datum/outfit/job/captain/rearadmiral
	name = "Captain (Rear Admiral)"
	head = /obj/item/clothing/head/caphat/admiral
	uniform = /obj/item/clothing/under/rank/captain/admiral
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/admiral
	shoes = /obj/item/clothing/shoes/jackboots

/*** Security ***/
/// Security Officer
/datum/outfit/job/security/securitysergeant
	name = "Security Officer (Sergeant)"
	head = /obj/item/clothing/head/beret/sec/navyofficer
	uniform = /obj/item/clothing/under/rank/security/officer/formal
	suit = /obj/item/clothing/suit/armor/vest/officer

/*** Science ***/
/// Scientist
/datum/outfit/job/scientist/professor
	name = "Scientist (Professor)"
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/toggle/labcoat
	glasses = /obj/item/clothing/glasses/regular

/*** Medical ***/
/// Medical Doctor
/datum/outfit/job/doctor/surgeon
	name = "Medical Doctor (Surgeon)"
	uniform = /obj/item/clothing/under/rank/medical/doctor/blue
	suit = /obj/item/clothing/suit/apron/surgical
	suit_store = null
	mask = /obj/item/clothing/mask/surgical

/datum/outfit/job/doctor/nurse
 	name = "Medical Doctor (Nurse)"
 	head = /obj/item/clothing/head/nursehat
 	suit = null
 	suit_store = null
 	accessory = /obj/item/clothing/accessory/armband/medblue

/*** Engineering ***/
/// Station Engineer
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
	l_hand = /obj/item/storage/bag/construction

/// Atmospheric Technician
/datum/outfit/job/atmos/firefighter
	name = "Atmospheric Technician (Firefighter)"
	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	head = /obj/item/clothing/head/hardhat/red
	l_hand = /obj/item/extinguisher

/datum/outfit/job/atmos/lifesupportspecialist
	name = "Atmospheric Technician (Life Support Specialist)"
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1, /obj/item/storage/box/survival=2)

/// Void Technician
/datum/outfit/job/voidtech/marine
	name = "Void Technician (Space Marine)"
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/space/hardsuit/voidtech/marine

/*** Supply ***/
/datum/outfit/job/cargo_tech/mailroomtechnician
	name = "Cargo Technician (Mailroom Technician)"
	backpack_contents = list(/obj/item/storage/box/shipping=1, /obj/item/modular_computer/tablet/preset/cargo=1)

/*** Service ***/
/// Cook
/datum/outfit/job/cook/grillmaster
	uniform = /obj/item/clothing/under/rank/civilian/cookjorts
	suit = null
	head = null
	mask = null
	r_hand = /obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy

/// Curator
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

/// Assistant
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
	backpack_contents = list(/obj/item/export_scanner=1, /obj/item/modular_computer/tablet/preset/cargo=1)

/datum/outfit/job/assistant/entertainer
	name = "Assistant (Entertainer)"
	r_hand = /obj/item/bikehorn //hjonk

/datum/outfit/job/assistant/assistinator
	name = "Assistant (Assistinator)"
	uniform = /obj/item/clothing/under/color/grey/ancient
	mask = /obj/item/clothing/mask/gas

/datum/outfit/job/clown/jester
	name = "Clown (Jester)"
	uniform = /obj/item/clothing/under/rank/civilian/clown/jester
	shoes = /obj/item/clothing/shoes/clown_shoes/jester
	head = /obj/item/clothing/head/jester
