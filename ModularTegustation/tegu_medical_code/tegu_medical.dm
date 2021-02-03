/obj/item/storage/belt/medical/surgeryfilled
	name = "\improper Chief Medical Officers's surgerybelt"
	desc = "a toolbelt full of surgery tools."

/obj/item/storage/belt/medical/surgeryfilled/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)

/datum/surgery_step/heal/proc/remove_husking(mob/living/carbon/target) // Tegustation Husking: Surgery heal can repair husking, including changeling husking now that we have no cloning.
	if(HAS_TRAIT(target, TRAIT_HUSK) && target.getFireLoss() < UNHUSK_DAMAGE_THRESHOLD)
		target.cure_husk()
		target.visible_message("<span class='nicegreen'>[target]'s tissues are surgically repaired, taking on a more healthy appearance.")
