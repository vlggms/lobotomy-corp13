/obj/structure/fishshrine
	name = "mysterious shrine"
	desc = "A strange shrine with a sacrificial dagger on the altar."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "altar"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/list/chose_gods = list()

/obj/structure/fishshrine/attackby(obj/item/I, mob/living/user, params)
	..()
	if(user.devotion<1)
		return
	if(!istype(I, /obj/item/food/fish))
		to_chat(user, span_notice("You may only sacrifice fish here."))
		return
	var/this_fish_point

	var/obj/item/food/fish/sacrificing = I
	switch(sacrificing.random_case_rarity)
		if(FISH_RARITY_BASIC)
			this_fish_point = 0.1
		if(FISH_RARITY_RARE)
			this_fish_point = 0.2
		if(FISH_RARITY_VERY_RARE)
			this_fish_point = 0.4
		if(FISH_RARITY_GOOD_LUCK_FINDING_THIS)
			this_fish_point = 0.8
	if(sacrificing.status == FISH_ALIVE)
		this_fish_point *= 2

	var/neptune = SSfishing.IsAligned(/datum/planet/neptune)
	if(neptune) //If neptune is aligned, double your points
		this_fish_point *= 2

	qdel(I)
	user.devotion+=this_fish_point
	to_chat(user, span_notice("[neptune ? "Neptune is in alignment. " : ""]Devotion increased by [this_fish_point]. Your devotion to [user.god_aligned] is now [user.devotion]."))

/obj/structure/fishshrine/attack_hand(mob/living/user)
	..()
	if(user.devotion >= 1 && user.devotion < 5)
		to_chat(user, span_notice("The gods look the other way."))
		return
	if(user.devotion >= 5 && user.god_aligned == FISHGOD_NONE)
		pick_god(user)
	if(user.god_aligned != FISHGOD_NONE)
		display_info(user)

/obj/structure/fishshrine/proc/display_info(mob/living/user)
	to_chat(user, span_notice("Your devotion to the gods is [user.devotion]"))
	switch(SSfishing.moonphase)
		if(1)
			to_chat(user, span_notice("The moon is Waning."))
		if(2)
			to_chat(user, span_notice("The moon is New."))
		if(3)
			to_chat(user, span_notice("The moon is Waxxing."))
		if(4)
			to_chat(user, span_notice("The moon is Full."))

	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(planet.phase == 1)
			to_chat(user, span_notice("[planet.name] is in alignment with earth."))

//Godpicking shit
/obj/structure/fishshrine/proc/pick_god(mob/living/user)
	var/list/god_names = list()
	for(var/datum/planet/planet as anything in SSfishing.planets)
		god_names[planet.god] = planet.god_desc

	for(var/god as anything in SSfishing.sleeping_gods)
		god_names[god] = "Warning, [god]'s planet has been destroyed, this can negativelly affect you in several situations.\n[SSfishing.sleeping_gods[god]]"

	if(!length(god_names))
		return

	var/choice = input(user, "Which god would you like to align yourself with?", "Select a god") as null|anything in god_names
	if(!choice || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		to_chat(user, span_notice("You decide to stay a fish athiest for now."))
		return

	if(alert(god_names[choice], "God Choser", "Devote Yourself", "Take more time") != "Devote Yourself")
		return

	user.god_aligned = choice
	to_chat(user, span_notice("You devote yourself to [user.god_aligned]."))
