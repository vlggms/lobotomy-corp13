
/datum/job/low_sec_officer
    title = "Low Security Officer"
    faction = "Station"
    supervisors = "Low Security Commander"
    total_positions = 5
    spawn_positions = 5
    exp_requirements = 0
    selection_color = "#ccaaaa"
    access = list(ACCESS_SECURITY)            //See /datum/job/assistant/get_access()
    minimal_access = list(ACCESS_SECURITY)    //See /datum/job/assistant/get_access()

    outfit = /datum/outfit/job/low_sec_officer
    display_order = 10.5

    job_important = "You are a Low Security Officer, hired by LCB. Your job to ensure the safety of the researchers of the Low Security Zone. Deal with any hazards that occur with the zone, and attempt to coerce abnormalities to stay. If you are unable to keep the abnormalities to stay through coersion, suppress them."

    alt_titles = list()
    roundstart_attributes = list(
                                FORTITUDE_ATTRIBUTE = 20,
                                PRUDENCE_ATTRIBUTE = 20,
                                TEMPERANCE_ATTRIBUTE = 20,
                                JUSTICE_ATTRIBUTE = 20
                                )
    loadalways = FALSE
    maptype = "lcb"


/datum/job/low_sec_officer/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
    H.set_attribute_limit(20)
    ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/low_sec_officer
	name = "Low Security Officer"
	jobtype = /datum/job/low_sec_officer

	head = /obj/item/clothing/beret/control
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_control
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)


/datum/job/low_sec_commander
    title = "Low Security Commander"
    faction = "Station"
    supervisors = "LCB officials"
    total_positions = 1
    spawn_positions = 1
    exp_requirements = 0
    selection_color = "#ccaaaa"
    access = list(ACCESS_SECURITY, ACCESS_COMMAND)            //See /datum/job/assistant/get_access()
    minimal_access = list(ACCESS_SECURITY, ACCESS_COMMAND)    //See /datum/job/assistant/get_access()

    outfit = /datum/outfit/job/low_sec_commander
    display_order = 3.5

    job_important = "You are a Low Security Commander, hired by LCB. Your job to commnand the Low Security Zone."

    alt_titles = list()
    roundstart_attributes = list(
                                FORTITUDE_ATTRIBUTE = 60,
                                PRUDENCE_ATTRIBUTE = 60,
                                TEMPERANCE_ATTRIBUTE = 60,
                                JUSTICE_ATTRIBUTE = 60
                                )
    loadalways = FALSE
    maptype = "lcb"


/datum/job/low_sec_commander/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
    H.set_attribute_limit(60)
    ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/low_sec_officer
	name = "Low Security Officer"
	jobtype = /datum/job/low_sec_officer

	head = /obj/item/clothing/beret/control
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/headset_control
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)


