//Captain blade beacon
/obj/item/choice_beacon/association
	name = "director's beacon"
	desc = "A beacon the director uses to ally with an association."

/obj/item/choice_beacon/association/generate_display_names()
	var/static/list/beacon_item_list
	if(!beacon_item_list)
		beacon_item_list = list()
		var/list/templist = subtypesof(/obj/item/storage/box/association) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			beacon_item_list[initial(A.name)] = A
	return beacon_item_list

/obj/item/choice_beacon/association/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, "<span class='hear'>Make sure you put the equipment in the armory.</span>")



//Seven Asso
/obj/item/storage/box/association/seven
	name = "Seven Association Section 12"
	desc = "A kit from Section 1 containing Seven association gear."

/obj/item/storage/box/association/seven/PopulateContents()
	new /obj/item/ego_weapon/city/seven(src)
	new /obj/item/ego_weapon/city/seven(src)
	new /obj/item/ego_weapon/city/seven(src)
	new /obj/item/ego_weapon/city/seven/vet(src)
	new /obj/item/ego_weapon/city/seven/director(src)
	new /obj/item/ego_weapon/city/seven/cane(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/seven(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/seven(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/seven(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/sevenvet(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/sevendirector(src)



//Zwei Asso
/obj/item/storage/box/association/zwei
	name = "Zwei Association Section 12"
	desc = "A kit from Section 1 containing Zwei association gear."

/obj/item/storage/box/association/zwei/PopulateContents()
	new /obj/item/ego_weapon/city/zweihander(src)
	new /obj/item/ego_weapon/city/zweihander(src)
	new /obj/item/ego_weapon/city/zweihander(src)
	new /obj/item/ego_weapon/city/zweihander/vet(src)
	new /obj/item/ego_weapon/city/zweihander/vet(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zwei(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zwei(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zwei(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zweivet(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zweileader(src)


