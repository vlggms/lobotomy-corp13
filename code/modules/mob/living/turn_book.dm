//Turns Mobs Into Books, uses simple desc by default. Insert custom loot and info from the proc if you want
/mob/living/proc/turn_book(custom_loot, custom_name, custom_title, custom_body, custom_icon)
	var/title = custom_title ? custom_title : "[src]'s Page"
	var/body

	//Spawns the book
	var/obj/item/paper/fluff/lor_book/lor = new(get_turf(src))
	lor.name = custom_name ? custom_name : "Book of [src]"
	if(custom_icon)
		lor.icon_state = custom_icon

	//Checks equipped egos for lootbox + body description
	if(ishuman(src))
		var/mob/living/carbon/human/user = src
		var/list/search_area = user.contents.Copy()
		for(var/obj/item/storage/spare_space in search_area)
			search_area |= spare_space.contents
		for(var/obj/item/I in search_area)
			if(istype(I, /obj/item/clothing/suit/armor/ego_gear) || istype(I, /obj/item/gun/ego_gun/pistol) || istype(I, /obj/item/ego_weapon) || istype(I, /obj/item/gun/ego_gun) && !istype(I, /obj/item/gun/ego_gun/clerk))
				lor.lootbox += I.type
		body = "[user.job] from Lobotomy Corporation"
		user.death()
	else
		body = "[desc]"

	//Checks spawnable egos for lootbox from abos
	if(istype(src, /mob/living/simple_animal/hostile/abnormality))
		var/mob/living/simple_animal/hostile/abnormality/ABNO = src
		for(var/path in ABNO.ego_list)
			var/datum/ego_datum/I = path
			lor.lootbox += initial(I.item_path)

	//Reverts loot and body if there were custom ones
	if(custom_loot)
		lor.lootbox = custom_loot
	if(custom_body)
		body = custom_body

	//Writes the page
	lor.info = "<hr><h1><center>[title]</center></h1><hr>"
	lor.info += "[body]<br><br>"
	if(lor.lootbox.len)
		lor.info += "Obtainable Rewards: <br>"
		for(var/I in lor.lootbox)
			if(ispath(I, /obj/item/clothing/suit/armor/ego_gear))
				lor.info += "- Ego Armor: "
			if(ispath(I, /obj/item/gun/ego_gun))
				lor.info += "- Ego Gun: "
			if(ispath(I, /obj/item/ego_weapon))
				lor.info += "- Ego Weapon: "
			var/obj/item/loot = I
			lor.info += "[initial(loot.name)]<br>"

	visible_message(span_userdanger("[src] was turned into a book!"))
	playsound(src, 'sound/effects/book_turn.ogg', 75, TRUE, TRUE)
	new /obj/effect/temp_visual/turn_book(get_turf(src))
	qdel(src)

//Book Code
/obj/item/paper/fluff/lor_book
	name = "THE ONE TRUE BOOK"
	show_written_words = FALSE
	slot_flags = null // No books on head, sorry
	info = "Ayin did nothing wrong"
	var/list/lootbox = list()
	icon_state = "lor"

/obj/item/paper/fluff/lor_book/AltClick(mob/living/user, obj/item/I)
	return

/obj/item/paper/fluff/lor_book/attackby(obj/item/P, mob/living/user, params)
	//Spawns ego if burned
	if(burn_paper_product_attackby_check(P, user))
		var/obj/item/loot = pick(lootbox)
		if(loot)
			new loot(get_turf(src))
			visible_message(span_nicegreen("A [initial(loot.name)] came out of the ashes!"))
			playsound(src, 'sound/effects/book_burn.ogg', 50, TRUE, TRUE)
		SStgui.close_uis(src)
		qdel(src)
		return
	ui_interact(user)
