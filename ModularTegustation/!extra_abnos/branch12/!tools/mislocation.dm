/obj/structure/toolabnormality/mislocation
	name = "Mislocation"
	desc = "A lampost with a bench under."
	icon_state = "mislocation"
	icon = 'ModularTegustation/Teguicons/branch12/48x64.dmi'
	pixel_x = -13
	base_pixel_x = -13
	density = FALSE

/obj/structure/toolabnormality/mislocation/Crossed(atom/movable/AM, oldloc, force_stop = 0)
	..()
	if(!ishuman(AM))
		return

	var/mob/living/carbon/human/user = AM
	ADD_TRAIT(user, TRAIT_NODEATH, "memento_mori")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "memento_mori")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "memento_mori")

/obj/structure/toolabnormality/mislocation/Uncrossed(atom/movable/AM, oldloc, force_stop = 0)
	..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	REMOVE_TRAIT(user, TRAIT_NODEATH, "memento_mori")
	REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "memento_mori")
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "memento_mori")
