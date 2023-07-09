//This is a massive file and all the liu weapons kill humans while insane
/obj/item/ego_weapon/city/liu
	name = "Liu template"
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE

/obj/item/ego_weapon/city/liu/examine(mob/user)
	. = ..()
	. += "This weapon kills insane people."

/obj/item/ego_weapon/city/liu/attack(mob/living/target, mob/living/user)
	//Happens before the attack so you need to do another attack.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.sanity_lost)
			H.death()

	..()

//Section 1&2, 6-5-4-2 as the grades
/obj/item/ego_weapon/city/liu/fire
	name = "liu blade"
	desc = "A blade used by junior fixers of Liu Section 1 and Section 2."
	icon_state = "liublade"
	force = 28
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/city/liu/fire/examine(mob/user)
	. = ..()
	. +="This weapon gains +10% damage for each person in sight."

/obj/item/ego_weapon/city/liu/fire/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	for(var/mob/living/carbon/human/friend in oview(user, 10))
		//Minor bonus for having multiple people around you
		if(friend.ckey && friend.stat != DEAD && friend != user)
			force += force*0.1	//+10% for each person around you
	..()
	force = initial(force)


/obj/item/ego_weapon/city/liu/fire/fist
	name = "liu flaming glove"
	desc = "A fiery fist used by some veteran fixers of Liu Section 1 and Section 2."
	icon_state = "liuglove"
	force = 35
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/liu/fire/spear
	name = "liu spear"
	desc = "A spear used by veteran fixers of Liu Section 1 and Section 2, and is used by the director of Liu Section 2."
	icon_state = "liuspear"
	force = 45
	reach = 2
	attack_speed = 1.2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)


/obj/item/ego_weapon/city/liu/fire/sword
	name = "liu director sword"
	desc = "The personal sword found in the hands of the director of Liu Section 1."
	icon_state = "liusword"
	force = 67
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

