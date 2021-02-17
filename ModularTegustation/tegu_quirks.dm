//Prosthetic Limb
//Right Arm
/datum/quirk/prosthetic_limb/r_arm
	name = "Prosthetic Right Arm"
	desc = "An accident caused you to your right arm. Because of this, you now have a prosthetic arm!"
	value = -4
	medical_record_text = "During physical examination, patient was found to have a prosthetic right arm."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/r_arm/on_spawn()
    var/limb_slot = pick(BODY_ZONE_R_ARM)

//Left Arm
/datum/quirk/prosthetic_limb/l_arm
	name = "Prosthetic Left Arm"
	desc = "An accident caused you to your left arm. Because of this, you now have a prosthetic arm!"
	value = -4
	medical_record_text = "During physical examination, patient was found to have a prosthetic left arm."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/l_arm/on_spawn()
    var/limb_slot = pick(BODY_ZONE_L_ARM)

//Right Leg
/datum/quirk/prosthetic_limb/r_leg
	name = "Prosthetic Right Leg"
	desc = "An accident caused you to your right leg. Because of this, you now have a prosthetic leg!"
	value = -4
	medical_record_text = "During physical examination, patient was found to have a prosthetic right leg."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/r_leg/on_spawn()
    var/limb_slot = pick(BODY_ZONE_R_LEG)

//Left Leg
/datum/quirk/prosthetic_limb/l_leg
	name = "Prosthetic Left Leg"
	desc = "An accident caused you to your left leg. Because of this, you now have a prosthetic leg!"
	value = -4
	medical_record_text = "During physical examination, patient was found to have a prosthetic left leg."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/l_leg/on_spawn()
    var/limb_slot = pick(BODY_ZONE_L_LEG)
