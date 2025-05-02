
/obj/structure/closet/secure_closet/record
	name = "\proper record officer's locker"
	req_access = list(ACCESS_COMMAND)
	icon_state = "records"

/obj/structure/closet/secure_closet/record/PopulateContents()
	..()
//	new /obj/effect/spawner/bundle/combat_pages(src)

	new /obj/item/records/timestop(src)
	new /obj/item/records/information(src)
	new /obj/item/records/abnodelay(src)
	new /obj/item/records/meltdown_extend(src)


/obj/structure/closet/secure_closet/discipline
	name = "\proper disciplinary officer's locker"
	req_access = list(ACCESS_COMMAND)
	icon_state = "discipline"


/obj/structure/closet/secure_closet/discipline/PopulateContents()
	..()
//	new /obj/effect/spawner/bundle/combat_pages(src)
	new /obj/item/clothing/suit/armor/ego_gear/disc_off(src)



//need to use a god damn bundle for this
/obj/effect/spawner/bundle/combat_pages
	name = "combat page spawner"
	items = list(/obj/item/combat_page/level1,
			/obj/item/combat_page/level1,
			/obj/item/combat_page/level1,
			/obj/item/combat_page/level2,
			/obj/item/combat_page/level2,
		)

//Doing it here to avoid conflicts if anything in the future touches medical.dm
/obj/structure/closet/secure_closet/medical2/city
	req_access = list(ACCESS_MEDICAL)
