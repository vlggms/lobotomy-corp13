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
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP
	rank_title = "LT"
	job_important = "You are a support and command role in Rcorp. Advise the Commander, Run requisitions and then deploy."
	job_notice = "Run the Requisitions, assist Rcorp personnel on the base. After deployment, use your beacon to select which class you'd like."

	alt_titles = list("Staff Officer", "Field Officer",	"Command Officer",	"Junior Officer")

/datum/job/juniorofficer/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	var/datum/action/G = new /datum/action/cooldown/warbanner/captain
	G.Grant(H)

	G = new /datum/action/cooldown/warcry/captain
	G.Grant(H)

/datum/outfit/job/officer
	name = "Operations Officer"
	jobtype = /datum/job/juniorofficer
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/officer
	belt = /obj/item/ego_weapon/city/rabbit_blade
	ears =  /obj/item/radio/headset/heads
	head = /obj/item/clothing/head/beret/tegu/rcorpofficer
	l_hand = /obj/item/choice_beacon/officer
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/flashlight/seclite


// Beret
/obj/item/clothing/head/beret/tegu/rcorpofficer
	name = "lieutenant's beret"
	desc = "An orange beret used by Rcorp junior officers."
	icon_state = "beret_engineering"



//Officer beacon
/obj/item/choice_beacon/officer
	name = "officer beacon"
	desc = "A beacon officers can use to select their role."

/obj/item/choice_beacon/officer/generate_display_names()
	var/static/list/officer_item_list
	if(!officer_item_list)
		officer_item_list = list()
		var/list/templist = subtypesof(/obj/item/storage/box/officer) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			officer_item_list[initial(A.name)] = A
	return officer_item_list

/obj/item/choice_beacon/officer/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, "<span class='hear'>Thank you for your service..</span>")

/obj/item/storage/box/officer/gunner
	name = "Gunner Officer"
	desc = "Includes the Rcorp machine gun."

/obj/item/storage/box/officer/gunner/PopulateContents()
	new /obj/item/gun/energy/e_gun/rabbit/minigun(src)

/obj/item/storage/box/officer/medic
	name = "Medic Officer"
	desc = "Includes medical supplies."

/obj/item/storage/box/officer/medic/PopulateContents()
	new /obj/item/reagent_containers/hypospray/emais(src)
	new /obj/item/clothing/glasses/hud/health(src)

/obj/item/storage/box/officer/command
	name = "Command Officer"
	desc = "Includes various command gear for assisting a captain."

/obj/item/storage/box/officer/command/PopulateContents()
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/binoculars(src)
	new /obj/item/megaphone(src)
	new /obj/item/survivalcapsule/rcorpsmallcommand(src)

/obj/item/storage/box/officer/engineer
	name = "Engineering Officer"
	desc = "Includes various engineering gear for repairing rhinos and setting up defenses."

/obj/item/storage/box/officer/engineer/PopulateContents()
	new /obj/item/weldingtool/experimental(src)
	new /obj/item/stack/sheet/mineral/sandbags/fifty(src)
	new /obj/item/clothing/glasses/hud/diagnostic/sunglasses(src)


/obj/item/storage/box/officer/delivery
	name = "Requisitions Officer"
	desc = "Includes a set of wheelies and night vision for going to and from the front quickly."

/obj/item/storage/box/officer/delivery/PopulateContents()
	new /obj/item/clothing/shoes/wheelys(src)
	new /obj/item/clothing/glasses/night(src)
