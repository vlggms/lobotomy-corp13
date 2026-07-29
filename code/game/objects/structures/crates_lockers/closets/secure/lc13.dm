/obj/structure/closet/secure_closet/discipline
	name = "\proper disciplinary officer's locker"
	req_access = list(ACCESS_COMMAND)
	icon_state = "discipline"


/obj/structure/closet/secure_closet/discipline/PopulateContents()
	..()
	//placeholder for now?
	new /obj/item/ego_weapon/city/lcorp/baton(src)
	new /obj/item/ego_weapon/ranged/city/lcorp/pistol(src)
	new /obj/item/ego_weapon/shield/lcorp_shield(src)
	new /obj/item/egoshard(src)
	new /obj/item/egoshard/white(src)
	new /obj/item/egoshard/black(src)

//Doing it here to avoid conflicts if anything in the future touches medical.dm
/obj/structure/closet/secure_closet/medical2/city
	req_access = list(ACCESS_MEDICAL)
