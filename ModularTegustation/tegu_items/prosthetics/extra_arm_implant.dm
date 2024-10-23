GLOBAL_LIST_EMPTY(threearmed_fucks)
//This is temporary

/obj/item/extra_arm
	name = "\improper Extra Arm Implant"
	desc = "An extremely expensive implant allowing a fixer to gain newly found dexterity and handiness. However, this slows you down."
	icon = 'icons/obj/device.dmi'
	icon_state = "autoimplanter"
	var/uses = 1
	var/arms_added = 1
	custom_premium_price = 1400

/obj/item/extra_arm/attack_self(mob/user)
	if(!uses)
		to_chat(user, "<span class='alert'>[src] has already been used. The tools are dull and won't reactivate.</span>")
		return
	if(user in GLOB.threearmed_fucks)	//not letting people get 6 arms
		to_chat(user, "<span class='alert'>You already have an extra arm.</span>")
		return
	var/limbs = user.held_items.len
	user.change_number_of_hands(limbs+1)
	GLOB.threearmed_fucks += user
	user.visible_message("<span class='notice'>[user] presses a button on [src], and you hear a short mechanical noise.</span>", "<span class='notice'>You feel a sharp sting as [src] plunges into your body.</span>")
	to_chat(user, "Your extra arm whirrs with life")
	playsound(get_turf(user), 'sound/weapons/circsawhit.ogg', 50, TRUE)
	user.add_movespeed_modifier(/datum/movespeed_modifier/armimplant)
	if(uses == 1)
		uses--
	if(!uses)
		desc = "[initial(desc)] Looks like it's been used up."


/datum/movespeed_modifier/armimplant
	variable = TRUE
	multiplicative_slowdown = 0.30



/obj/item/extra_arm/double
	name = "\improper Double Arms Implant"
	desc = "An extremely expensive implant allowing a fixer to gain newly found dexterity and handiness. However, this slows you down greatly."
	icon = 'icons/obj/device.dmi'
	icon_state = "autoimplanter"
	arms_added = 2
	custom_premium_price = 1800


/datum/movespeed_modifier/doublearmimplant
	variable = TRUE
	multiplicative_slowdown = 0.50


/obj/item/extra_arm/double/attack_self(mob/user)
	if(!uses)
		to_chat(user, "<span class='alert'>[src] has already been used. The tools are dull and won't reactivate.</span>")
		return
	if(user in GLOB.threearmed_fucks)	//not letting people get 6 arms
		to_chat(user, "<span class='alert'>You already have an extra arm.</span>")
		return
	var/limbs = user.held_items.len
	user.change_number_of_hands(limbs+2)
	GLOB.threearmed_fucks += user
	user.visible_message("<span class='notice'>[user] presses a button on [src], and you hear a short mechanical noise.</span>", "<span class='notice'>You feel a sharp sting as [src] plunges into your body.</span>")
	to_chat(user, "Your extra arm whirrs with life")
	playsound(get_turf(user), 'sound/weapons/circsawhit.ogg', 50, TRUE)
	user.add_movespeed_modifier(/datum/movespeed_modifier/doublearmimplant)
	if(uses == 1)
		uses--
	if(!uses)
		desc = "[initial(desc)] Looks like it's been used up."
