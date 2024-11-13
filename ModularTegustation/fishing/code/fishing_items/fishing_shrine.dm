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
		this_fish_point*=2
	if(SSfishing.Neptune==8)
		this_fish_point*=2
	qdel(I)
	user.devotion+=this_fish_point
	if(SSfishing.Neptune==8)
		to_chat(user, span_notice("Neptune is in alignment. Devotion increased by [this_fish_point]. Your devotion to [user.god_aligned] is now [user.devotion]."))
	else
		to_chat(user, span_notice("Devotion increased by [this_fish_point]. Your devotion to [user.god_aligned] is now [user.devotion]."))


/obj/structure/fishshrine/attack_hand(mob/living/user)
	..()
	if(user.devotion>=1&& user.devotion<5)
		to_chat(user, span_notice("The gods look the other way."))
		return
	if(user.devotion>=5 && user.god_aligned == FISHGOD_NONE)
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

	if(SSfishing.Mercury == 2)
		to_chat(user, span_notice("Mercury is in alignment with earth."))
	if(SSfishing.Venus == 3)
		to_chat(user, span_notice("Venus is in alignment with earth."))
	if(SSfishing.Mars == 4)
		to_chat(user, span_notice("Mars is in alignment with earth."))
	if(SSfishing.Jupiter == 5)
		to_chat(user, span_notice("Jupiter is in alignment with earth."))
	if(SSfishing.Saturn == 6)
		to_chat(user, span_notice("Saturn is in alignment with earth."))
	if(SSfishing.Uranus == 7)
		to_chat(user, span_notice("Uranus is in alignment with earth."))
	if(SSfishing.Neptune == 8)
		to_chat(user, span_notice("Neptune is in alignment with earth."))



//Godpicking shit
/obj/structure/fishshrine/proc/pick_god(mob/living/user)
	var/list/display_names = list("Lir", "Tefnut", "Arnapkapfaaluk", "Susanoo" , "Kukulkan", "Abena Mansa", "Glaucus")
	if(!display_names.len)
		return
	var/choice = input(user,"Which god would you like to align yourself with?","Select a god") as null|anything in display_names
	if(!choice || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		to_chat(user, span_notice("You decide to stay a fish athiest for now."))
		return

	switch(choice)
		if("Lir")
			var/confirm = alert("Lir is the God of The Sea, and represents Mercury. Devoting yourself to Lir will give you better fortune with the sizes of fish.", "God Choser", "Devote Yourself", "Take more time")
			if(confirm == "Devote Yourself")
				user.god_aligned = FISHGOD_MERCURY

		if("Tefnut")
			var/confirm = alert("Tefnut is the Goddess of moisture, fertility and water, and represents Venus. Devoting yourself to Tefnut will make it less likely for enemies to spawn while catching with nets.", "God Choser", "Devote Yourself", "Take more time")
			if(confirm == "Devote Yourself")
				user.god_aligned = FISHGOD_VENUS

		if("Arnapkapfaaluk")
			var/confirm = alert("Arnapkapfaaluk is the Goddess of aquatic combat, and represents Mars. Devoting yourself to Arnapkapfaaluk will give you strength with fishing weapons.", "God Choser", "Devote Yourself", "Take more time")
			if(confirm == "Devote Yourself")
				user.god_aligned = FISHGOD_MARS

		if("Susanoo")
			var/confirm = alert("Susanoo is the God of harvest and storms, and represents Jupiter. Devoting yourself to Susanoo will make fishing weapons heal on kill.", "God Choser", "Devote Yourself", "Take more time")
			if(confirm == "Devote Yourself")
				user.god_aligned = FISHGOD_JUPITER

		if("Kukulkan")
			var/confirm = alert("Kukulkan is the Serpent Deity, and represents Saturn. Devoting yourself to Kukulkan will decrease the cost of all spells by 1 devotion.", "God Choser", "Devote Yourself", "Take more time")
			if(confirm == "Devote Yourself")
				user.god_aligned = FISHGOD_SATURN

		if("Abena Mansa")
			var/confirm = alert("Abena Mansa is a sea Goddess of gold, and represents Uranus. Devoting yourself to Abena Mansa will make fishing up ahn possible, scaling with your devotion.", "God Choser", "Devote Yourself", "Take more time")
			if(confirm == "Devote Yourself")
				user.god_aligned = FISHGOD_URANUS

		if("Glaucus")
			var/confirm = alert("Glaucus is the God of fishing, and represents Neptune. Devoting yourself to Glaucus will enhance all of your fishing skills.", "God Choser", "Devote Yourself", "Take more time")
			if(confirm == "Devote Yourself")
				user.god_aligned = FISHGOD_NEPTUNE


	to_chat(user, span_notice("You devote yourself to [user.god_aligned]."))
