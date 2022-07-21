/obj/machinery/regenerator
	name = "regenerator"
	desc = "A machine responsible for slowly restoring health and sanity of employees in the area."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "smoke1"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	/// How many HP and SP we restore on each process tick
	var/regeneration_amount = 3

/obj/machinery/regenerator/process()
	..()
	var/area/A = get_area(src)
	if(!istype(A))
		return
	var/regen_amt = regeneration_amount
	for(var/mob/living/L in A)
		if(!("neutral" in L.faction)) // Enemy spotted
			regen_amt *= 0.5
			break
	for(var/mob/living/carbon/human/H in A)
		if(H.sanity_lost)
			continue
		if(H.health < 0)
			continue
		H.adjustBruteLoss(-regen_amt)
		H.adjustFireLoss(-regen_amt)
		H.adjustSanityLoss(regen_amt)

/obj/machinery/regenerator/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The [src] restores [regeneration_amount] HP and SP once in 2 seconds.</span>"
