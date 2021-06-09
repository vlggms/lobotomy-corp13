/*** Beacons ***/
// Sidearm
/obj/item/choice_beacon/terragov_sidearm
	name = "sidearm choice"
	desc = "TerraGov has collected a armament of service pistols over history. Most of them are still in service and can be ordered here."
	beacon_msg = "You hear something crackle in your ears for a moment before a voice speaks.  \"Please stand by for a message from the Military Command of Terra. Message as follows: <span class='bold'>Item request received. Your package is inbound, please stand back from the landing site.</span> Message ends.\""

/obj/item/choice_beacon/terragov_sidearm/generate_display_names()
	var/static/list/gun_list
	if(!gun_list)
		gun_list = list()
		var/list/templist = typesof(/obj/item/storage/box/terragov_sidearm) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			gun_list[initial(A.name)] = A
	return sortList(gun_list)

// Special
/obj/item/choice_beacon/terragov_specialist
	name = "specialist choice"
	desc = "No two missions are the same, although you can get good weaponry from here, its to have designate roles based on your choices here."
	beacon_msg = "You hear something crackle in your ears for a moment before a voice speaks.  \"Please stand by for a message from the Military Command of Terra. Message as follows: <span class='bold'>Item request received. Your package is inbound, please stand back from the landing site.</span> Message ends.\""

/obj/item/choice_beacon/terragov_specialist/generate_display_names()
	var/static/list/special_list
	if(!special_list)
		special_list = list()
		var/list/templist = typesof(/obj/item/storage/backpack/duffelbag/captain/specialist) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			special_list[initial(A.name)] = A
	return sortList(special_list)

/*** Boxes with items ***/
// Sidearm
/obj/item/storage/box/terragov_sidearm
	name = "Makarov PM kit"

/obj/item/storage/box/terragov_sidearm/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/terragov(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/ammo_box/magazine/m9mm(src)

/obj/item/storage/box/terragov_sidearm/m1911
	name = "M1911 kit"

/obj/item/storage/box/terragov_sidearm/m1911/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/m1911(src)
	new /obj/item/ammo_box/magazine/m45(src)

/obj/item/storage/box/terragov_sidearm/sig
	name = "Sig Sauer kit"

/obj/item/storage/box/terragov_sidearm/sig/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/terragov/sig(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/sig(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/sig(src)

/obj/item/storage/box/terragov_sidearm/deagle
	name = "Desert Eagle kit"

/obj/item/storage/box/terragov_sidearm/deagle/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/deagle/camo(src)

/obj/item/storage/box/terragov_sidearm/ppk
	name = "Type 64 kit"

/obj/item/storage/box/terragov_sidearm/ppk/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/terragov/ppk(src)
	new /obj/item/ammo_box/magazine/m38(src)
	new /obj/item/ammo_box/magazine/m38(src)

/obj/item/storage/box/terragov_sidearm/glock
	name = "Glock kit"

/obj/item/storage/box/terragov_sidearm/glock/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/terragov/glock(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/ammo_box/magazine/m9mm(src)

/obj/item/storage/box/terragov_sidearm/beretta
	name = "Beretta kit"

/obj/item/storage/box/terragov_sidearm/beretta/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/terragov/beretta(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/ammo_box/magazine/m9mm(src)

// Special
/obj/item/storage/backpack/duffelbag/captain/specialist
	name = "SABR smg kit"
	desc = "A kit that contains a standard SMG used by TerraGov forces."

/obj/item/storage/backpack/duffelbag/captain/specialist/PopulateContents()
	new /obj/item/gun/ballistic/automatic/proto/terragov(src)
	new /obj/item/ammo_box/magazine/smgm9mm(src)
	new /obj/item/ammo_box/magazine/smgm9mm(src)
	new /obj/item/ammo_box/magazine/smgm9mm(src)
	new /obj/item/ammo_box/magazine/smgm9mm(src)


/obj/item/storage/backpack/duffelbag/captain/specialist/uzi
	name = "Uzi smg kit"
	desc = "A kit containing a submachine gun and magazines for it. Just don't expect to hit anything."

/obj/item/storage/backpack/duffelbag/captain/specialist/uzi/PopulateContents()
	new /obj/item/gun/ballistic/automatic/mini_uzi(src)
	new /obj/item/ammo_box/magazine/uzim9mm(src)
	new /obj/item/ammo_box/magazine/uzim9mm(src)
	new /obj/item/ammo_box/magazine/uzim9mm(src)

/obj/item/storage/backpack/duffelbag/captain/specialist/medic
	name = "medical kit"
	desc = "A kit containing medical supplies and a portable medbeam."

/obj/item/storage/backpack/duffelbag/captain/specialist/medic/PopulateContents()
	new /obj/item/gun/medbeam(src)
	new /obj/item/defibrillator/compact(src)
	new /obj/item/storage/firstaid/tactical/terragov(src)

/obj/item/storage/firstaid/tactical/terragov/PopulateContents()
	if(empty)
		return
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/reagent_containers/hypospray/combat(src)
	new /obj/item/reagent_containers/pill/patch/libital(src)
	new /obj/item/reagent_containers/pill/patch/libital(src)
	new /obj/item/reagent_containers/pill/patch/aiuri(src)
	new /obj/item/reagent_containers/pill/patch/aiuri(src)

/obj/item/storage/backpack/duffelbag/captain/specialist/toolbelt
	name = "engineering supplies"
	desc = "Contains a fully stocked toolbelt, industrial RCD, and an inducer. You are probably going to break into places with this instead of repairing."

/obj/item/storage/backpack/duffelbag/captain/specialist/toolbelt/PopulateContents()
	new /obj/item/storage/belt/utility/chief/full(src)
	new /obj/item/construction/rcd/combat(src)
	new /obj/item/inducer/syndicate(src)
