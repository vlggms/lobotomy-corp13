/obj/machinery/regenerator
	name = "Regenerator"
	desc = "A machine responsible for slowly restoring health and sanity of employees in the area."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "smoke1"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	/// How many HP and SP we restore on each process tick
	var/regeneration_amount = 3
	/// Pre-declared variable
	var/modified = FALSE // Whether or not the regenerator is currently undergoing modified action
	var/hp_bonus = 0
	var/sp_bonus = 0
	var/critical_heal = FALSE // Whether it heals people who are in critical condition (sanity loss/health loss)
	var/burst = FALSE // Set to heal in a large burst
	var/burst_cooldown = FALSE // Whether it's operational due to Burst Cooldown
	var/short_duration = 30 SECONDS
	var/long_duration = 60 SECONDS
	var/reset_timer = 0

/obj/machinery/regenerator/process()
	..()
	if(reset_timer <= world.time)
		burst_cooldown = FALSE
		modified = FALSE
		hp_bonus = 0
		sp_bonus = 0
		critical_heal = FALSE
	if(burst_cooldown)
		return
	var/area/A = get_area(src)
	if(!istype(A))
		return
	var/regen_amt = regeneration_amount
	for(var/mob/living/L in A)
		if(!("neutral" in L.faction) && L.stat != DEAD) // Enemy spotted
			regen_amt *= 0.5
			break
	if(burst)
		regen_amt *= 7.5
		burst = FALSE
		burst_cooldown = TRUE
		reset_timer = short_duration + world.time
	for(var/mob/living/carbon/human/H in A)
		if(H.sanity_lost && !critical_heal)
			continue
		if(H.health < 0 && !critical_heal)
			continue
		H.adjustBruteLoss(-H.maxHealth * ((regen_amt+hp_bonus)/100))
		H.adjustFireLoss(-H.maxHealth * ((regen_amt+hp_bonus)/100))
		H.adjustSanityLoss(H.maxSanity * ((regen_amt+sp_bonus)/100))

/obj/machinery/regenerator/examine(mob/user)
	. = ..()
	if(burst_cooldown)
		. += "<span class='warning'>The [src] is currently offline!</span>"
		return
	. += "<span class='notice'>The [src] restores [regeneration_amount+hp_bonus]% HP and [regeneration_amount+sp_bonus]% SP once in 2 seconds.</span>"


/obj/machinery/regenerator/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/safety_kit))
		var/obj/item/safety_kit/cooler_I = I
		if(user?.mind?.assigned_role != "Clerk")
			to_chat(user,"<span class='warning'>You don't know how to use this.</span>")
			return FALSE
		if (modified)
			to_chat(user, "<span class='notice'>The [src] is already modified.</span>")
			return FALSE
		to_chat(user, "<span class='notice'>You begin tinkering with the [src].</span>")
		if(do_after(user, 5 SECONDS))
			if (modified)
				to_chat(user, "<span class='spider'>Your work has been interrupted!</span>")
				return FALSE
			modified = TRUE
			switch(cooler_I.mode)
				if(1)
					to_chat(user, "<span class='notice'>You modify the [src] to restore more HP but less SP.</span>")
					hp_bonus = 3
					sp_bonus = -1
					reset_timer = long_duration + world.time
				if(2)
					to_chat(user, "<span class='notice'>You modify the [src] to restore more SP but less HP.</span>")
					hp_bonus = -1
					sp_bonus = 3
					reset_timer = long_duration + world.time
				if(3)
					to_chat(user, "<span class='notice'>You modify the [src] to restore more SP and HP.</span>")
					hp_bonus = 1
					sp_bonus = 1
					reset_timer = short_duration + world.time
				if(4)
					to_chat(user, "<span class='notice'>You modify the [src] to heal those in Critical Conditions.</span>")
					critical_heal = TRUE
					hp_bonus = -1
					sp_bonus = -1
					reset_timer = short_duration + world.time
				if(5)
					to_chat(user, "<span class='warning'>You set the [src] to overload and heal those in the area for a large amount!</span>")
					burst = TRUE
					// No Timer as it's an "instant" effect. Also handles turning off over there
			return TRUE
		to_chat(user, "<span class='spider'>Your work has been interrupted!</span>")
		return FALSE
	return ..()
