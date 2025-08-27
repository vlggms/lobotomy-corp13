/obj/item/reagent_containers/pill/helapoeisis
	name = "helapoeisis pill"
	desc = "Patented by company K. Heals brute damage throughout the body, including organs. Also heals a small amount of burn damage. Overdose leads to mild toxin damage."
	icon_state = "pill_kcorp"
	list_reagents = list(/datum/reagent/medicine/helapoeisis = 10)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/enkephalin
	name = "enkephalin pill"
	desc = "A controlled substance patented by Lobotomy Corporation. Heals sanity damage. An overdose causes hallucinations."
	icon_state = "pill_happy"
	list_reagents = list(/datum/reagent/medicine/enkephalin = 10)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/rcorp
	name = "combat pill"
	desc = "A pill distributed by company R. Provides a short adrenaline boost and a small amount of healing."
	icon_state = "pill_syndie"
	list_reagents = list(
		/datum/reagent/medicine/epinephrine = 10, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/medicine/coagulant = 2,
		/datum/reagent/medicine/helapoeisis = 3, /datum/reagent/medicine/enkephalin = 3
			)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/bolus
	name = "hongyuan healing bolus"
	desc = "Known across the city as the \"Essence of Healing\". Effective on all types of damage except Brute. Overdose can cause severe mental atrophy."
	icon_state = "pill11"
	list_reagents = list(/datum/reagent/medicine/bolus = 10)
	rename_with_volume = TRUE
