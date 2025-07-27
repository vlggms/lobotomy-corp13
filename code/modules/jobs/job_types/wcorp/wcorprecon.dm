GLOBAL_LIST_INIT(l2asquads, list("Axe", "Buckler", "Cleaver"))

/datum/job/wcorpl2recon
	title = "W-Corp L2 Type A Lieutenant"
	faction = "Station"
	department_head = list("W-Corp L3 Cleanup Captain, W-Corp Representative")
	total_positions = 3
	spawn_positions = 3
	supervisors = "Your assigned W-Corp L3 Agent and the W-Corp Representative"
	selection_color = "#1b7ced"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "wcorp"

	outfit = /datum/outfit/job/wcorpl2recon
	display_order = 3

	access = list() //add accesses as necessary
	minimal_access = list()
	departments = DEPARTMENT_W_CORP

	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)
	rank_title = "L2-LT"
	job_important = "You take the role of inter-squad communication."
	job_notice = "You are a agent tasked with assisting with communications and coordination between your squad and other squads. Support your squadron with your equipment."

/datum/job/wcorpl2recon/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	var/squad = pick_n_take(GLOB.l2asquads)
	. = ..()

	to_chat(M, span_userdanger("You have been assigned to the [squad] squad."))

/datum/outfit/job/wcorpl2recon
	name = "W-Corp L2 Type A Lieutenant"
	jobtype = /datum/job/wcorpl2support

	ears = /obj/item/radio/headset/agent_lieutenant
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/wsenior
	belt = /obj/item/ego_weapon/city/wcorp
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/ego_hat/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp/noreq
	l_pocket = /obj/item/commandprojector
	r_pocket = /obj/item/storage/packet

	backpack_contents = list(
		/obj/item/storage/box/pcorp,
		/obj/item/binoculars,
		/obj/item/announcementmaker/wcorp,
	)
