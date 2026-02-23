// Clothes and clothing data used by the hatchery in safety.
/datum/outfit/job/patient
	name = "Patient"
	jobtype = /datum/job/civilian
	uniform = /obj/item/clothing/under/hospital
	suit = null
	belt = null
	ears = null
	shoes = /obj/item/clothing/shoes/sandal
	back = null
	backpack_contents = null
	box = null

/datum/outfit/job/patient/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	return

/obj/item/clothing/under/hospital
	name = "hospital gown"
	desc = "Lets you keep some mediocrum of dignity while the doctors put you back together."
	icon_state = "hospital"
	icon = 'icons/obj/clothing/ego_gear/suits.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/suit.dmi'
	can_adjust = FALSE
