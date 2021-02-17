//Prosthetic Limb
//Right Arm
/datum/quirk/prosthetic_limb/r_arm
	name = "Prosthetic Right Arm"
	desc = "An accident caused you to your right arm. Because of this, you now have a prosthetic arm!"
	value = -4
	var/slot_string = "limb"
	medical_record_text = "During physical examination, patient was found to have a prosthetic right arm."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/r_arm/on_spawn()
    var/limb_slot = pick(BODY_ZONE_R_ARM)
    var/mob/living/carbon/human/H = quirk_holder
    var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
    var/obj/item/bodypart/prosthetic
    switch(limb_slot)
        if(BODY_ZONE_R_ARM)
            prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
            slot_string = "right arm"
    prosthetic.replace_limb(H)
    qdel(old_part)
    H.regenerate_icons()

//Left Arm
/datum/quirk/prosthetic_limb/l_arm
	name = "Prosthetic Left Arm"
	desc = "An accident caused you to your left arm. Because of this, you now have a prosthetic arm!"
	value = -4
	var/slot_string = "limb"
	medical_record_text = "During physical examination, patient was found to have a prosthetic left arm."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/l_arm/on_spawn()
    var/limb_slot = pick(BODY_ZONE_L_ARM)
    var/mob/living/carbon/human/H = quirk_holder
    var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
    var/obj/item/bodypart/prosthetic
    switch(limb_slot)
        if(BODY_ZONE_L_ARM)
            prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
            slot_string = "left arm"
    prosthetic.replace_limb(H)
    qdel(old_part)
    H.regenerate_icons()

//Right Leg
/datum/quirk/prosthetic_limb/r_leg
	name = "Prosthetic Right Leg"
	desc = "An accident caused you to your right leg. Because of this, you now have a prosthetic leg!"
	value = -4
	var/slot_string = "limb"
	medical_record_text = "During physical examination, patient was found to have a prosthetic right leg."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/r_leg/on_spawn()
    var/limb_slot = pick(BODY_ZONE_R_LEG)
    var/mob/living/carbon/human/H = quirk_holder
    var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
    var/obj/item/bodypart/prosthetic
    switch(limb_slot)
        if(BODY_ZONE_R_LEG)
            prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
            slot_string = "right leg"
    prosthetic.replace_limb(H)
    qdel(old_part)
    H.regenerate_icons()

//Left Leg
/datum/quirk/prosthetic_limb/l_leg
	name = "Prosthetic Left Leg"
	desc = "An accident caused you to your left leg. Because of this, you now have a prosthetic leg!"
	value = -4
	var/slot_string = "limb"
	medical_record_text = "During physical examination, patient was found to have a prosthetic left leg."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/l_leg/on_spawn()
    var/limb_slot = pick(BODY_ZONE_L_LEG)
    var/mob/living/carbon/human/H = quirk_holder
    var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
    var/obj/item/bodypart/prosthetic
    switch(limb_slot)
        if(BODY_ZONE_L_LEG)
            prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
            slot_string = "left leg"
    prosthetic.replace_limb(H)
    qdel(old_part)
    H.regenerate_icons()
