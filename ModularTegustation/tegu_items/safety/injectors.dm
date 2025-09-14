/// Instant use injectors/ampoules. Uses modified autoinjector code.

/obj/item/reagent_containers/hypospray/medipen/safety/kcorp
	name = "helapoeisis ampoule"
	icon_state = "ampoule_kcorp"
	desc = "A drug developed by company K that rapidly heals HP."
	special = "Heals brute damage throughout the body, including organs. Also heals a small amount of burn damage. Overdose leads to mild toxin damage."
	list_reagents = list(/datum/reagent/medicine/helapoeisis = 5)

/obj/item/reagent_containers/hypospray/medipen/safety/lcorp
	name = "enkephalin syringe"
	icon_state = "ampoule_lcorp"
	desc = "A wonder substance produced by Lobotomy Corporation. Can be used as a clean source of energy, although some have figured out how to abuse its mild hallucinogenic properties."
	special = "Heals sanity damage. An overdose causes hallucinations."
	list_reagents = list(/datum/reagent/medicine/enkephalin = 5)

/obj/item/reagent_containers/hypospray/medipen/safety/rcorp
	name = "adrenaline syringe"
	icon_state = "ampoule_rcorp"
	desc = "Whether due to surplus or expiration, these ampoules produced by company R can be found almost anywhere in the city."
	special = "Wakes up and heals those who are unconscious or in critical condition. Has a side effect of slowing down corpse decomposition."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 10, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/medicine/coagulant = 2)
