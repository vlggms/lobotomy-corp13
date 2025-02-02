/mob/living/simple_animal/hostile/abnormality/training_rabbit/boar
	name = "Standard Training-Dummy Boar"
	desc = "A boar-like training dummy. Should be completely harmless."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "std_boar"
	icon_living = "std_boar"

/obj/effect/landmark/abnormality_spawn/boar
	name = "training boar spawn"

/obj/effect/landmark/abnormality_spawn/boar/LateInitialize()
	..()
	datum_reference = new(src, /mob/living/simple_animal/hostile/abnormality/training_rabbit/boar)
	var/obj/machinery/computer/abnormality/training_rabbit/AR = get_closest_atom(/obj/machinery/computer/abnormality/training_rabbit, GLOB.lobotomy_devices, src)
	if(istype(AR))
		AR.datum_reference = datum_reference
		datum_reference.console = AR
	return
