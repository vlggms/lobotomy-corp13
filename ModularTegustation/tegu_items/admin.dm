	//Admin Quick Leveler
/obj/item/attribute_tester
	name = "attribute injector"
	desc = "A fluid used to drastically change an employee for tests. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity7"

/obj/item/attribute_tester/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.adjust_all_attribute_levels(100)
	qdel(src)

/obj/item/easygift_tester
	name = "gift extractor"
	desc = "Unpopular due to its excessive energy use, this device extracts gifts from an entity on demand."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "hammeroff"

/obj/item/easygift_tester/attack(mob/living/simple_animal/hostile/abnormality/M, mob/living/carbon/human/user)
	if(!isabnormalitymob(M))
		to_chat(user, span_warning("Error: Entity doesnt classify as an L Corp Abnormality."))
		playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
		return
	if(!M.gift_type)
		to_chat(user, span_notice("[src] has no gift type."))
		playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
		return
	var/datum/ego_gifts/EG = new M.gift_type
	EG.datum_reference = M.datum_reference
	user.Apply_Gift(EG)
	to_chat(user, span_nicegreen("[M.gift_message]"))
	playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
	to_chat(user, span_nicegreen("You bonk the abnormality with the [src]."))
	qdel(src)
