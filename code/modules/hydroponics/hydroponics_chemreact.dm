/**
 *This is NOW the gradual affects that each chemical applies on every process() proc. Nutrients now use a more robust reagent holder in order to apply less insane
 * stat changes as opposed to 271 lines of individual statline effects. Shoutout to the original comments on chems, I just cleaned a few up.
 */
/obj/machinery/hydroponics/proc/apply_chemicals(mob/user)
	///Contains the reagents within the tray.
	if(myseed)
		myseed.on_chem_reaction(reagents) //In case seeds have some special interactions with special chems, currently only used by vines
	for(var/c in reagents.reagent_list)
		var/datum/reagent/chem = c
		chem.on_hydroponics_apply(myseed, reagents, src, user)


/obj/machinery/hydroponics/proc/mutation_roll(mob/user)
	switch(rand(100))
		if(90 to 100)
			adjustHealth(-10)
			visible_message("<span class='warning'>\The [myseed.plantname] starts to wilt and burn!</span>")
			return
		if(40 to 89)
			if(myseed && !self_sustaining) //Stability
				myseed.adjust_instability(5)
				return
		if(20 to 39)
			visible_message("<span class='notice'>\The [myseed.plantname] appears unusually reactive...</span>")
			return
		if(10 to 19)
			mutateweed()
			return
		if(0 to 9)
			mutatepest(user)
			return
