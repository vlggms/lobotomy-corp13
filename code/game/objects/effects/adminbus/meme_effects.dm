/obj/effect/adminbus/balding
	name = "balding blast"
	icon = 'icons/effects/effects.dmi'
	icon_state = "quantum_sparks"
	var/turf/T
	var/range = 4
	var/visual_effect_chance = 60

/obj/effect/adminbus/balding/Initialize(mapload)
	. = ..()
	T = get_turf(src)
	new /obj/effect/particle_effect/sparks/quantum(T)
	for(var/mob/living/carbon/human/M in range(T, range))
		if(!HAS_TRAIT(M, TRAIT_BALD))
			ADD_TRAIT(M, TRAIT_BALD, "BALDING_BLAST")
			M.hairstyle = "Bald"
			M.update_hair()
			if(prob(visual_effect_chance))
				M.add_overlay(icon('ModularTegustation/Teguicons/tegu_effects.dmi', "bald_blast"))
				addtimer(CALLBACK(M, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('ModularTegustation/Teguicons/tegu_effects.dmi', "bald_blast")), 20)

	return INITIALIZE_HINT_QDEL

/obj/effect/adminbus/targeted/balding
	name = "balding blast"
	icon = 'icons/effects/effects.dmi'
	icon_state = "quantum_sparks"
	var/turf/T

/obj/effect/adminbus/targeted/balding/Initialize(mapload, mob/living/carbon/human/M)
	. = ..()
	T = get_turf(src)
	new /obj/effect/particle_effect/sparks/quantum(T)
	if(!HAS_TRAIT(M, TRAIT_BALD))
		ADD_TRAIT(M, TRAIT_BALD, "BALDING_BLAST")
		M.hairstyle = "Bald"
		M.update_hair()
		M.add_overlay(icon('ModularTegustation/Teguicons/tegu_effects.dmi', "bald_blast"))
		addtimer(CALLBACK(M, TYPE_PROC_REF(/atom, cut_overlay), \
						icon('ModularTegustation/Teguicons/tegu_effects.dmi', "bald_blast")), 20)

	return INITIALIZE_HINT_QDEL
