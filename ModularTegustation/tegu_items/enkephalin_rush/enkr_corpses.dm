//dead stuff but better

/obj/effect/mob_spawn/human/clerk
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/assistant
	brute_damage = 1000

/obj/effect/mob_spawn/human/agent//TODO: make these always available
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/agent
	brute_damage = 1000

/obj/effect/mob_spawn/human/agent/equip(mob/living/carbon/human/H)
	..()
	if(ispath(suit, /obj/item/clothing/suit/armor/ego_gear))
		var/obj/item/clothing/suit/armor/ego_gear/mysuit = new suit(get_turf(src))
		H.equip_to_slot(mysuit,ITEM_SLOT_OCLOTHING, TRUE)

/obj/effect/mob_spawn/human/agent/loot
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/agent
	suit = /obj/item/clothing/suit/armor/ego_gear/zayin/penitence
	var/list/ego_list = list()
	var/obj/item/clothing/suit/armor/ego_gear/chosenEGO
	var/risk_level = 1

/obj/effect/mob_spawn/human/agent/loot/equip(mob/living/carbon/human/H)//TODO: Check abnormality cores and tool abnos. Maybe a separate subtype exclusively for tool abnos.
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.mob_living_list)//picks all abnormalities in the mob list
		if(A.threat_level != risk_level)
			continue
		var/list/E = A.ego_list
		if(E.len == 0)//mainly omits tutorial abnos + training rabbit, whose lists are empty
			continue
		for(var/i = 1, i <= E.len, i++)
			if(ispath(E[i], /datum/ego_datum/armor))
				var/datum/ego_datum/armor/C = E[i]
				ego_list += C.item_path
	if(!ego_list.len)
		return..()
	chosenEGO = pick(ego_list)
	suit = chosenEGO
	..()

/obj/effect/mob_spawn/human/agent/loot/teth
	suit = /obj/item/clothing/suit/armor/ego_gear/teth/training
	risk_level = 2

/obj/effect/mob_spawn/human/agent/loot/he
	suit = /obj/item/clothing/suit/armor/ego_gear/he/frostsplinter
	risk_level = 3

/obj/effect/mob_spawn/human/agent/loot/waw
	suit = /obj/item/clothing/suit/armor/ego_gear/waw/scene//replace this with heaven when available
	risk_level = 4

/obj/effect/mob_spawn/human/agent/loot/aleph
	suit = /obj/item/clothing/suit/armor/ego_gear/aleph/star
	risk_level = 5

/obj/effect/mob_spawn/human/agent/randomloot
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/agent
	suit = /obj/item/clothing/suit/armor/ego_gear/zayin/penitence
	var/obj/structure/toolabnormality/wishwell/linked_structure
	var/list/ego_list = list()
	var/obj/item/clothing/suit/armor/ego_gear/chosenEGO
	var/risk_level = 1

/obj/effect/mob_spawn/human/agent/randomloot/equip(mob/living/carbon/human/H)
	if(!linked_structure)
		linked_structure = locate(/obj/structure/toolabnormality/wishwell) in world.contents
	var/threat_ref = linked_structure.zayinitem
	switch(risk_level)
		if(1)
		if(2)
			threat_ref = linked_structure.tethitem
		if(3)
			threat_ref = linked_structure.heitem
		if(4)
			threat_ref = linked_structure.wawitem
		if(5)
			threat_ref = linked_structure.alephitem
	for(var/egoitem in threat_ref)
		if(ispath(egoitem, /obj/item/clothing/suit/armor/ego_gear))
			ego_list += egoitem
			continue
	if(!ego_list.len)
		return ..()
	chosenEGO = pick(ego_list)
	suit = chosenEGO
	..()

/obj/effect/mob_spawn/human/manager
	icon_state = "corpsehuman"
	outfit = /datum/outfit/job/manager
	brute_damage = 1000

/obj/effect/mob_spawn/human/fixer
	icon_state = "corpsehuman"
	brute_damage = 1000
	belt = /obj/item/pda/security
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	suit = /obj/item/clothing/suit/armor/ego_gear/city/misc/lone
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id
	id_job = "Fixer"

/obj/effect/mob_spawn/human/fixer/equip(mob/living/carbon/human/H)
//Be very careful, sometimes these guys don't like to initialize
	..()
	var/obj/item/clothing/suit/armor/ego_gear/modsuit = new suit(get_turf(src))
	modsuit.name = "tattered fixer jacket"
	modsuit.armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	H.equip_to_slot(modsuit,ITEM_SLOT_OCLOTHING, TRUE)

/obj/effect/mob_spawn/human/fixer/tieoffice
	var/tie_list = list(
		/obj/item/clothing/neck/tie/blue,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/neck/tie/horrible,
		)
	back = /obj/item/storage/backpack/duffelbag
	id_job = "Tie Office Fixer"

/obj/effect/mob_spawn/human/fixer/tieoffice/equip(mob/living/carbon/human/H)
	var/obj/item/clothing/neck/tie/mytie = pick(tie_list)
	neck = mytie
	..()

/obj/effect/mob_spawn/human/thumb
	icon_state = "corpsehuman"
	brute_damage = 1000
	belt = /obj/item/pda/security
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	suit = /obj/item/clothing/suit/armor/ego_gear/city/thumb
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id
	id_job = "Thumb Soldato"

/obj/effect/mob_spawn/human/thumb/equip(mob/living/carbon/human/H)
//Ditto
	..()
	var/obj/item/clothing/suit/armor/ego_gear/modsuit = new suit(get_turf(src))
	modsuit.name = "ruined thumb soldato uniform"
	modsuit.armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	modsuit.attribute_requirements = list()
	H.equip_to_slot(modsuit,ITEM_SLOT_OCLOTHING, TRUE)
