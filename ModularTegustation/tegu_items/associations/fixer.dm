//Captain blade beacon
/obj/item/choice_beacon/fixer
	name = "fixer director's beacon"
	desc = "A beacon the director uses to grab their equipment."

/obj/item/choice_beacon/fixer/generate_display_names()
	var/static/list/beacon_item_list
	if(!beacon_item_list)
		beacon_item_list = list()
		var/list/templist = subtypesof(/obj/item/storage/box/fixer) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			beacon_item_list[initial(A.name)] = A
	return beacon_item_list

/obj/item/choice_beacon/fixer/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, "<span class='hear'>Make sure you put the equipment away.</span>")



//Wedge
/obj/item/storage/box/fixer/wedge
	name = "Wedge Office"
	desc = "A kit containing Wedge gear."

/obj/item/storage/box/fixer/wedge/PopulateContents()
	new /obj/item/ego_weapon/city/wedge/weak(src)
	new /obj/item/ego_weapon/city/wedge/weak(src)
	new /obj/item/ego_weapon/city/wedge/weak(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/wedgeleader(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/wedge/female(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/wedge/female(src)



//Dawn
/obj/item/storage/box/fixer/dawn
	name = "Dawn Office"
	desc = "A kit from containing Dawn office gear."

/obj/item/storage/box/fixer/dawn/PopulateContents()
	new /obj/item/ego_weapon/city/dawn/sword/white(src)
	new /obj/item/ego_weapon/city/dawn/cello/white(src)
	new /obj/item/ego_weapon/city/dawn/zwei/white(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/dawnleader(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/dawn(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/dawn(src)


//Fullstop
/obj/item/storage/box/fixer/fullstop
	name = "Fullstop Office"
	desc = "A kit containing Full Stop offier gear."

/obj/item/storage/box/fixer/fullstop/PopulateContents()
	new /obj/item/gun/ego_gun/city/fullstop/assault(src)
	new /obj/item/gun/ego_gun/city/fullstop/sniper(src)
	new /obj/item/gun/ego_gun/city/fullstop/deagle(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/fullstopleader(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/fullstop(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/fullstop/sniper(src)


//Custom
/obj/item/storage/box/fixer/custom
	name = "Custom Office"
	desc = "A kit containing basic armor and money to buy gear."

/obj/item/storage/box/fixer/custom/PopulateContents()
	new /obj/item/stack/spacecash/c1000(src)
	new /obj/item/stack/spacecash/c1000(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)

//Hardmode
/obj/item/storage/box/fixer/challengemode
	name = "CHALLENGE MODE"
	desc = "A box containing a beacon to call for shittier options."

/obj/item/storage/box/fixer/challengemode/PopulateContents()
	new /obj/item/stack/spacecash/c1000(src)
	new /obj/item/choice_beacon/fixerhard(src)


//Below is for challenge mode, all these suck

//Captain blade beacon
/obj/item/choice_beacon/fixerhard
	name = "fixer director's beacon"
	desc = "A beacon the director uses to grab their equipment."

/obj/item/choice_beacon/fixerhard/generate_display_names()
	var/static/list/beacon_item_list
	if(!beacon_item_list)
		beacon_item_list = list()
		var/list/templist = subtypesof(/obj/item/storage/box/fixerhard)
		for(var/V in templist)
			var/atom/A = V
			beacon_item_list[initial(A.name)] = A
	return beacon_item_list

/obj/item/choice_beacon/fixerhard/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, "<span class='hear'>Make sure you put the equipment away.</span>")



//Streetlight Office
/obj/item/storage/box/fixerhard/streetlight
	name = "CHALLENGE MODE - Stretlight Office"
	desc = "A kit containing Stretlight Office gear."

/obj/item/storage/box/fixerhard/streetlight/PopulateContents()
	new /obj/item/ego_weapon/city/zweihander/streetlight_baton(src)
	new /obj/item/ego_weapon/city/streetlight_greatsword(src)
	new /obj/item/ego_weapon/city/streetlight_bat(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)

//Yun Office
/obj/item/storage/box/fixerhard/yun
	name = "CHALLENGE MODE - Yun Office"
	desc = "A kit containing Yun Office gear."

/obj/item/storage/box/fixerhard/yun/PopulateContents()
	new /obj/item/ego_weapon/city/yun(src)
	new /obj/item/ego_weapon/city/yun/shortsword(src)
	new /obj/item/ego_weapon/city/yun/chainsaw(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)

//Cane Office
/obj/item/storage/box/fixerhard/cane
	name = "CHALLENGE MODE - Cane Office"
	desc = "A kit containing Cane Office gear."

/obj/item/storage/box/fixerhard/cane/PopulateContents()
	new /obj/item/ego_weapon/city/cane/cane/weak(src)
	new /obj/item/ego_weapon/city/cane/claw/weak(src)
	new /obj/item/ego_weapon/city/cane/fist/weak(src)
	new /obj/item/ego_weapon/city/cane/briefcase/weak(src)
	new /obj/item/clothing/under/suit/tuxedo(src)
	new /obj/item/clothing/under/suit/tuxedo(src)
	new /obj/item/clothing/under/suit/tuxedo(src)
