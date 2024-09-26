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
	to_chat(M, span_hear("Make sure you put the equipment in the armory."))


//Zwei Asso
/obj/item/storage/box/association/zwei
	name = "Zwei Association Section 6"
	desc = "A kit from Section 1 containing Zwei association gear."

/obj/item/storage/box/association/zwei/PopulateContents()
	new /obj/item/ego_weapon/city/zweihander(src)
	new /obj/item/ego_weapon/city/zweihander(src)
	new /obj/item/ego_weapon/city/zweibaton(src)
	new /obj/item/ego_weapon/city/zweihander/vet(src)
	new /obj/item/ego_weapon/city/zweihander/vet(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zwei(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zwei(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zweiriot(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zweivet(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/zweileader(src)


//Liu Asso
/obj/item/storage/box/association/liu
	name = "Liu Association Section 5"
	desc = "A kit from Section 1 containing Liu association gear."

/obj/item/storage/box/association/liu/PopulateContents()
	new /obj/item/ego_weapon/city/liu/fire/section5(src)
	new /obj/item/ego_weapon/city/liu/fire/section5(src)
	new /obj/item/ego_weapon/city/liu/fire/section5(src)
	new /obj/item/ego_weapon/city/liu/fire/section5/vet(src)
	new /obj/item/ego_weapon/city/liu/fire/section5/vet(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/liu/section5(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/liu/section5(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/liu/section5(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/liuvet/section5(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/liuleader/section5(src)

//Seven Asso
/obj/item/storage/box/association/seven
	name = "Seven Association Section 6"
	desc = "A kit from Section 1 containing Seven association gear."

/obj/item/storage/box/association/seven/PopulateContents()
	new /obj/item/ego_weapon/city/seven(src)
	new /obj/item/ego_weapon/city/seven(src)
	new /obj/item/ego_weapon/city/seven_fencing(src)
	new /obj/item/ego_weapon/city/seven/vet(src)
	new /obj/item/ego_weapon/city/seven/director(src)
	new /obj/item/ego_weapon/city/seven/cane(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/seven(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/seven(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/sevenrecon(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/sevenvet(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/sevendirector(src)
	new /obj/item/binoculars(src)
	new /obj/item/binoculars(src)

