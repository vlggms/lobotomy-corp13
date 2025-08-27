/// Safety department healing items for health, sanity, etc are covered here.
/// Injectors, bandages, and pills are the types of healing items.
/// These items take advantage of legacy code to make our own items.

/obj/item/safety_bandage/kcorp
	name = "helapoeisis ampoule"
	icon_state = "kcorp"
	desc = "Bandages soaked in Serum K. Treats wounds very rapidly."
	special = "Heals brute and organ damage very quickly. Should not be used more than once in a short time period, as there is a high risk of overdose."
	list_reagents = list(/datum/reagent/medicine/helapoeisis/concentrated = 3)

/obj/item/safety_bandage/kcorp/try_heal(mob/living/patient, mob/user)
	if(patient.health >= patient.maxHealth)
		if(patient == user)
			to_chat(user, span_warning("It would be a waste to use this now."))
			return FALSE
		to_chat(user, span_warning("[patient] doesn't look hurt."))
		return FALSE
	..()

/obj/item/safety_bandage/mcorp
	name = "moonlight stone"
	icon_state = "mcorp"
	desc = "A product of MDM Entreprise, the moonstone. With concentration, this can be used to withstand mental ailments."
	special = "Heals sanity very quickly. Should not be used more than once in a short time period, as there is a high risk of overdose."
	list_reagents = list(/datum/reagent/medicine/enkephalin/concentrated = 3)
	use_sound = 'sound/effects/zzzt.ogg'

/obj/item/safety_bandage/mcorp/try_heal(mob/living/patient, mob/user)
	if(!ishuman(patient))
		to_chat(user, span_warning("[patient] does not need this."))
	var/mob/living/carbon/human/H = patient
	if(H.sanityhealth >= H.maxSanity)
		if(H == user)
			to_chat(user, span_warning("It would be a waste to use this now."))
			return FALSE
		to_chat(user, span_warning("[H] seems mentally sound, relatively speaking at least."))
		return FALSE
	..()

/obj/item/safety_bandage/hcorp
	name = "hongyuan bolus-soaked bandages"
	icon_state = "gauze"
	desc = "A miracle product of Hongyuan. Can alledgedly heal everything if you soak your skin in the bolus. Side effects known but undisclosed."
	special = "Effective on all types of damage except Brute, and heals very quickly. Overdose can cause severe mental atrophy"
	list_reagents = list(/datum/reagent/medicine/bolus/concentrated = 3)

