
/obj/structure/closet/secure_closet/record
	name = "\proper record officer's locker"
	req_access = list(ACCESS_COMMAND)
	icon_state = "records"

/obj/structure/closet/secure_closet/record/PopulateContents()
	..()
	new /obj/effect/spawner/bundle/combat_pages(src)

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
	new /obj/effect/spawner/bundle/combat_pages(src)



//need to use a god damn bundle for this
/obj/effect/spawner/bundle/combat_pages
	name = "combat page spawner"
	items = list(/obj/effect/spawner/lootdrop/combatpage_L1,
			/obj/effect/spawner/lootdrop/combatpage_L1,
			/obj/effect/spawner/lootdrop/combatpage_L2,
			/obj/effect/spawner/lootdrop/combatpage_L2,
			/obj/effect/spawner/lootdrop/combatpage_L3
		)


/obj/effect/spawner/lootdrop/combatpage_L1
	name = "level 1 combat page spawner"
	lootdoubles = FALSE
	loot = list()

/obj/effect/spawner/lootdrop/combatpage_L1/Initialize(mapload)
	loot += subtypesof(/obj/item/combat_page/level1)
	return ..()

/obj/effect/spawner/lootdrop/combatpage_L2
	name = "level 2 combat page spawner"
	lootdoubles = FALSE
	loot = list()

/obj/effect/spawner/lootdrop/combatpage_L2/Initialize(mapload)
	loot += subtypesof(/obj/item/combat_page/level2)
	return ..()

/obj/effect/spawner/lootdrop/combatpage_L3
	name = "level 2 combat page spawner"
	lootdoubles = FALSE
	loot = list()

/obj/effect/spawner/lootdrop/combatpage_L3/Initialize(mapload)
	loot += subtypesof(/obj/item/combat_page/level3)
	return ..()

/obj/effect/spawner/lootdrop/combatpage_L4
	name = "level 2 combat page spawner"
	lootdoubles = FALSE
	loot = list()

/obj/effect/spawner/lootdrop/combatpage_L4/Initialize(mapload)
	loot += subtypesof(/obj/item/combat_page/level4)
	return ..()
