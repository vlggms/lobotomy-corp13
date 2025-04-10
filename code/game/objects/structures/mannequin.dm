/////////////////////////////////////////////////////////MANNEQUINS//////////////////////////////////////////////////////////
//Basically statues that you can dress up. Poorly Translate from VG station

#define MANNEQUIN_ICONS_SLOT "slot_icon"
#define SLOT_MANNEQUIN_LEFT_HAND "left_hand"
#define SLOT_MANNEQUIN_RIGHT_HAND "right_hand"
#define SLOT_MANNEQUIN_ICLOTHING "inner_clothing"
#define SLOT_MANNEQUIN_FEET "feet"
#define SLOT_MANNEQUIN_GLOVES "gloves"
#define SLOT_MANNEQUIN_OCLOTHING "outer_clothing"
#define SLOT_MANNEQUIN_EYES "eyes"
#define SLOT_MANNEQUIN_BELT "belt"
#define SLOT_MANNEQUIN_MASK "mask"
#define SLOT_MANNEQUIN_HEAD "head"
#define SLOT_MANNEQUIN_BACK "back"
#define SLOT_MANNEQUIN_NECK "neck"
#define HTMLTAB "&nbsp;&nbsp;&nbsp;&nbsp;"

/*
* If you are porting this from another codebase
* some of the procs that you will need to replace are
* get_active_held_item(),
*/

/obj/structure/mannequin
	name = "mannequin"
	desc = "You almost feel like it's going to come alive any second."
	icon = 'icons/obj/mannequin.dmi'
	icon_state="mannequin_human_wood"
	density = TRUE
	anchored = FALSE
	gender = PLURAL
	max_integrity = 50
	var/tipped_over = FALSE
	var/clothing_offset_x = 0
	var/clothing_offset_y = 0
	var/list/clothing = list()

	//for mappers, with love
	var/mapping_uniform = null
	var/mapping_shoes = null
	var/mapping_gloves = null
	var/mapping_ears = null
	var/mapping_suit = null
	var/mapping_glasses = null
	var/mapping_hat = null
	var/mapping_belt = null
	var/mapping_mask = null
	var/mapping_back = null
	var/mapping_neck = null
	var/mapping_righthand = null
	var/mapping_lefthand = null

/obj/structure/mannequin/New(turf/loc, list/items_to_wear)
	..()

	clothing = list(
		SLOT_MANNEQUIN_ICLOTHING,
		SLOT_MANNEQUIN_FEET,
		SLOT_MANNEQUIN_GLOVES,
		SLOT_MANNEQUIN_OCLOTHING,
		SLOT_MANNEQUIN_EYES,
		SLOT_MANNEQUIN_BELT,
		SLOT_MANNEQUIN_MASK,
		SLOT_MANNEQUIN_HEAD,
		SLOT_MANNEQUIN_BACK,
		SLOT_MANNEQUIN_NECK,
		SLOT_MANNEQUIN_RIGHT_HAND,
		SLOT_MANNEQUIN_LEFT_HAND,
		)

	MapEquip(items_to_wear)

	update_icon()

/obj/structure/mannequin/attack_hand(mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(tipped_over)
		StandUp(user)
		return
	//For easy moving of mannequins.
	if(!anchored && user.a_intent == INTENT_GRAB)
		user.start_pulling(src)
		return
	ShowInventory(user)

/obj/structure/mannequin/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/mannequin/attackby(obj/item/I, mob/user)
	if(user.a_intent == INTENT_HARM)
		if(!tipped_over)
			TipOver()
			return
		return ..()
	if(!tipped_over)
		//For anchoring with a wrench.
		if(I.tool_behaviour == TOOL_WRENCH)
			if(anchored)
				user.visible_message(span_notice("[user] starts unfastening \the [src] from the floor..."),
					span_notice("You start unfastening the bolts from the floor..."))
				if(I.use_tool(src, user, 20, volume = 50))
					to_chat(user, span_notice("You unfasten the [src] from the floor."))
					set_anchored(FALSE)
			else
				to_chat(user, span_notice("You fasten the [src] to the floor."))
				set_anchored(TRUE)
	else
		to_chat(user, span_notice("You should pick the [src] up from the floor before doing this."))
		return
	attack_hand(user)

//Hostiles that bump into mannequins knock them over.
/obj/structure/mannequin/Bumped(atom/movable/AM)
	if(ishostile(AM))
		TipOver()
		return
	return ..()

/obj/structure/mannequin/Destroy()
	var/turf/drop_turf = get_turf(src)
	for(var/atom/movable/AM in src)
		AM.forceMove(drop_turf)
	..()

/obj/structure/mannequin/examine(mob/user)
	..()
	var/msg = ""
	var/slot_examine

	for(var/slot_cloth in clothing)
		var/obj/item/cloth_to_examine = clothing[slot_cloth]
		if(cloth_to_examine)
			switch(slot_cloth)
				if(SLOT_MANNEQUIN_HEAD)
					slot_examine = " on its head"
				if(SLOT_MANNEQUIN_BACK)
					slot_examine = " on its back"
				if(SLOT_MANNEQUIN_GLOVES)
					slot_examine = " on its hands"
				if(SLOT_MANNEQUIN_BELT)
					slot_examine = " about its waist"
				if(SLOT_MANNEQUIN_ICLOTHING)
					slot_examine = " close to its skin"
				if(SLOT_MANNEQUIN_OCLOTHING)
					slot_examine = " over its body"
				if(SLOT_MANNEQUIN_FEET)
					slot_examine = " on its feet"
				if(SLOT_MANNEQUIN_MASK)
					slot_examine = " on its face"
				if(SLOT_MANNEQUIN_EYES)
					slot_examine = " covering its eyes"
				if(SLOT_MANNEQUIN_NECK)
					slot_examine = " around its neck"
				if(SLOT_MANNEQUIN_RIGHT_HAND)
					slot_examine = " in its right hand"
				if(SLOT_MANNEQUIN_LEFT_HAND)
					slot_examine = " in its left hand"
			msg += "Wearing [cloth_to_examine][slot_examine].<br>"

	. += msg

/obj/structure/mannequin/update_icon()
	..()
	overlays.Cut()
	var/list/manniquin_item_overlays = list()
	for(var/cloth_slot in clothing)
		manniquin_item_overlays += FormatOverlay(clothing[cloth_slot], cloth_slot)

	overlays += manniquin_item_overlays

/*
* This is where the button presses from ShowInventory() go.
* Press turn? then the word turn will be sent here and
* the resulting effects will be placed in its if(href_list["turn"]) statement.
*/
/obj/structure/mannequin/Topic(href, href_list)
	..()
	if(usr.incapacitated() || !Adjacent(usr) || !(iscarbon(usr)) || tipped_over)
		return
	var/mob/living/carbon/user = usr
	if(href_list["item"])
		var/obj/item/item_in_hand = usr.get_active_held_item()
		var/item_slot = href_list["item"]
		if(!item_in_hand)
			if(clothing[item_slot])
				var/obj/item/I = clothing[item_slot]
				MannequinUnequip(I,item_slot)
				user.put_in_hand(I)
				add_fingerprint(user)
				to_chat(user, span_info("You pick up \the [I] from \the [src]."))
		else
			if(clothing[item_slot])
				if(canEquip(user, item_slot,item_in_hand))
					if(user.dropItemToGround(item_in_hand))
						var/obj/item/I = clothing[item_slot]
						MannequinUnequip(I,item_slot)
						user.put_in_hands(I)
						MannequinEquip(item_in_hand,item_slot)
						add_fingerprint(user)
						to_chat(user, span_info("You switch \the [item_in_hand] and \the [I] on the [src]."))
					else
						to_chat(user, span_warning("You can't drop that!"))
				else
					return
			else
				if(canEquip(user, item_slot,item_in_hand))
					if(user.dropItemToGround(item_in_hand))
						MannequinEquip(item_in_hand,item_slot)
						add_fingerprint(user)
						to_chat(user, span_info("You place \the [item_in_hand] on \the [src]."))
					else
						to_chat(user, span_warning("You can't drop that!"))
				else
					return

	//Utility Button Effects
	if(href_list["recolor"])
		ReColorMannequin()
	if(href_list["turn"])
		switch(dir)
			if(NORTH)
				dir = EAST
			if(SOUTH)
				dir = WEST
			if(WEST)
				dir = NORTH
			//Safety Net
			else
				dir = SOUTH
	update_icon()
	ShowInventory(user)

//Mannequin Interaction UI
/obj/structure/mannequin/proc/ShowInventory(mob/user)
	var/dat
	dat += "<BR><B>Back:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_BACK]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_BACK])]</A>"
	dat += "<BR><B>Head:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_HEAD]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_HEAD])]</A>"
	dat += "<BR><B>Neck:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_NECK]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_NECK])]</A>"
	dat += "<BR><B>Mask:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_MASK]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_MASK])]</A>"
	dat += "<BR><B>Eyes:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_EYES]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_EYES])]</A>"
	dat += "<BR><B>Belt:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_BELT]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_BELT])]</A>"
	dat += "<BR><B>Shoes:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_FEET]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_FEET])]</A>"
	dat += "<BR><B>Gloves:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_GLOVES]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_GLOVES])]</A>"
	dat += "<BR><B>Uniform:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_ICLOTHING]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_ICLOTHING])]</A>"
	dat += "<BR><B>Exosuit:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_OCLOTHING]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_OCLOTHING])]</A>"
	//LC13 specific consideration
	var/obj/item/clothing/suit/ego_armor = clothing[SLOT_MANNEQUIN_OCLOTHING]
	if(ego_armor)
		dat += "<BR>Mannequin Armor:<BR> \
			[1-(ego_armor.armor[RED_DAMAGE]/100)] RED|\
			[1-(ego_armor.armor[WHITE_DAMAGE]/100)] WHITE|\
			[1-(ego_armor.armor[BLACK_DAMAGE]/100)] BLACK|\
			[1-(ego_armor.armor[PALE_DAMAGE]/100)] PALE"
	dat += "<BR>---"
	dat += "<BR><B>RightHand:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_RIGHT_HAND]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_RIGHT_HAND])]</A>"
	dat += "<BR><B>LeftHand:</B> <A href='byond://?src=\ref[src];item=[SLOT_MANNEQUIN_LEFT_HAND]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_LEFT_HAND])]</A><BR>"
	dat += "<BR>---"
	dat += "<BR>Recolor Mannequin:<B><A href='byond://?src=\ref[src];recolor=recolor'>[GetCurrentColor()]</A></B>"
	dat += "<BR>Turn Mannequin:<B><A href='byond://?src=\ref[src];turn=turn'>[dir2text(dir)]</A></B>"
	dat += "<BR>"
	dat += {"
	<BR>
	<BR><A href='byond://?src=\ref[user];mach_close=mob\ref[src]'>Close</A>
	"}

	var/datum/browser/popup = new(user, "mannequin\ref[src]", "[src]", 340, 500)
	popup.set_content(dat)
	popup.open()

//This is for formatting text on a button based on icon state.
/obj/structure/mannequin/proc/GetCurrentColor()
	switch(icon_state)
		if("mannequin_human_wood")
			return "NORMAL"
		if("mannequin_human_red")
			return "REDWOOD"
		if("mannequin_human_white")
			return "CREAMWOOD"
		if("mannequin_human_purple")
			return "BLACKWOOD"
		if("mannequin_human_pale")
			return "TEALWOOD"

/*
* Recolor the mannequin for more diverse indicators.
* In LC13 these are used to show what damage they are good against.
*/
/obj/structure/mannequin/proc/ReColorMannequin()
	switch(icon_state)
		if("mannequin_human_wood")
			icon_state = "mannequin_human_red"
		if("mannequin_human_red")
			icon_state = "mannequin_human_white"
		if("mannequin_human_white")
			icon_state = "mannequin_human_purple"
		if("mannequin_human_purple")
			icon_state = "mannequin_human_pale"
		if("mannequin_human_pale")
			icon_state = "mannequin_human_wood"

//Checks if the item can be equipped by the manniquin.
/obj/structure/mannequin/proc/canEquip(mob/user, item_slot, obj/item/item_to_check)
	var/inv_slot

	switch(item_slot)//human slot defines are bitflags, so mannequins require their own string-based slot defines to avoid bugs when using lists.
		if(SLOT_MANNEQUIN_ICLOTHING)
			inv_slot = ITEM_SLOT_ICLOTHING
		if(SLOT_MANNEQUIN_FEET)
			inv_slot = ITEM_SLOT_FEET
		if(SLOT_MANNEQUIN_GLOVES)
			inv_slot = ITEM_SLOT_GLOVES
		if(SLOT_MANNEQUIN_OCLOTHING)
			inv_slot = ITEM_SLOT_OCLOTHING
		if(SLOT_MANNEQUIN_EYES)
			inv_slot = ITEM_SLOT_EYES
		if(SLOT_MANNEQUIN_BELT)
			inv_slot = ITEM_SLOT_BELT
		if(SLOT_MANNEQUIN_MASK)
			inv_slot = ITEM_SLOT_MASK
		if(SLOT_MANNEQUIN_HEAD)
			inv_slot = ITEM_SLOT_HEAD
		if(SLOT_MANNEQUIN_NECK)
			inv_slot = ITEM_SLOT_NECK
		if(SLOT_MANNEQUIN_BACK)
			inv_slot = ITEM_SLOT_BACK
		if(SLOT_MANNEQUIN_RIGHT_HAND)
			return TRUE
		if(SLOT_MANNEQUIN_LEFT_HAND)
			return TRUE

	if(item_to_check.slot_flags & inv_slot)
		return TRUE

	if(user)
		to_chat(user, span_warning("\The [item_to_check] doesn't fit there."))
	return FALSE

/*
* This proc returns a mutative overlay that
* figures out what icon and icon_state to apply.
* This is used in update_icon()
*/
/obj/structure/mannequin/proc/FormatOverlay(obj/item/worn_thing, slot_worn_on)
	if(!worn_thing)
		return
	//Is it not even a item?
	if(!isitem(worn_thing))
		return

	var/overlay_icon = worn_thing.worn_icon
	var/overlay_state = worn_thing.icon_state

	//Are we placing the thing in the mannequins hands?
	if(slot_worn_on == SLOT_MANNEQUIN_LEFT_HAND || slot_worn_on ==  SLOT_MANNEQUIN_RIGHT_HAND)
		overlay_state = worn_thing.icon_state
		if(worn_thing.inhand_icon_state)
			overlay_state = worn_thing.inhand_icon_state
		if(slot_worn_on == SLOT_MANNEQUIN_LEFT_HAND)
			overlay_icon = worn_thing.lefthand_file
		if(slot_worn_on == SLOT_MANNEQUIN_RIGHT_HAND)
			overlay_icon = worn_thing.righthand_file

	//It is not in their hands so if there is a worn_icon_state get it.
	else if(worn_thing.worn_icon_state)
		overlay_state = worn_thing.worn_icon_state
	if(!overlay_icon)
		switch(slot_worn_on)
			//I dont know why the worn icon doesnt exist but somehow these files contain the worn sprites.
			if(SLOT_MANNEQUIN_FEET)
				overlay_icon = 'icons/mob/clothing/feet.dmi'
			if(SLOT_MANNEQUIN_GLOVES)
				overlay_icon = 'icons/mob/clothing/hands.dmi'
			if(SLOT_MANNEQUIN_OCLOTHING)
				overlay_icon = 'icons/mob/clothing/suit.dmi'
			if(SLOT_MANNEQUIN_EYES)
				overlay_icon = 'icons/mob/clothing/eyes.dmi'
			if(SLOT_MANNEQUIN_BELT)
				overlay_icon = 'icons/mob/clothing/belt.dmi'
			if(SLOT_MANNEQUIN_MASK)
				overlay_icon = 'icons/mob/clothing/mask.dmi'
			if(SLOT_MANNEQUIN_HEAD)
				overlay_icon = 'icons/mob/clothing/head.dmi'
			if(SLOT_MANNEQUIN_BACK)
				overlay_icon = 'icons/mob/clothing/back.dmi'
			if(SLOT_MANNEQUIN_NECK)
				overlay_icon = 'icons/mob/clothing/neck.dmi'

	var/mutable_appearance/mannequin_overlay = mutable_appearance(overlay_icon, overlay_state)
	mannequin_overlay.pixel_x = clothing_offset_x
	mannequin_overlay.pixel_y = clothing_offset_y
	return mannequin_overlay

/obj/structure/mannequin/proc/makeStrippingButton(obj/item/I) //Not actually the stripping button, just what's written on it
	if(!istype(I))
		return "<font color=grey>Empty</font>"
	else
		return I

/*
* These two small procs add and remove
* the item from the mannequins
* physical form and clothing list.
*/
/obj/structure/mannequin/proc/MannequinEquip(obj/item/O, item_slot)
	O.forceMove(src)
	clothing[item_slot] = O

	update_icon()

/obj/structure/mannequin/proc/MannequinUnequip(obj/item/O, item_slot)
	if(!O)
		O = clothing[item_slot]
		//I know its sloppy but i do have to double check.
		if(!O)
			return
	O.forceMove(get_turf(src))
	clothing[item_slot] = null

	update_icon()

//For dropping all clothing.
/obj/structure/mannequin/proc/DropAll()
	for(var/slot in clothing)
		MannequinUnequip(null, slot)

	update_icon()

//For knocking the mannequin over whenever it is hit by a hostile.
/obj/structure/mannequin/proc/TipOver()
	playsound(get_turf(src), pick('sound/effects/bodyfall1.ogg', 'sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg'), 50, TRUE)
	density = FALSE
	tipped_over = TRUE
	DropAll()
	var/matrix/mat = transform
	transform = mat.Turn(90)

//For picking the mannequin back up off the floor
/obj/structure/mannequin/proc/StandUp(mob/living/L)
	//This is here to prevent mannequins from being stacked ontop of eachother.
	for(var/obj/structure/mannequin/O in get_turf(src))
		if(O.density && !O.tipped_over)
			return
	playsound(get_turf(src), 'sound/effects/rustle4.ogg', 50, TRUE)
	density = TRUE
	tipped_over = FALSE
	var/matrix/mat = transform
	transform = mat.Turn(-90)
	to_chat(L, "You pull [src] off the ground.")

/*
* Procs at creation or mapload. If no items_to_wear then it will equip
* the mannequin with whatever is in the mapping variables.
* Remember to create the items in the list with new /obj/whatever()
*/

/obj/structure/mannequin/proc/MapEquip(list/items_to_wear)
	if(items_to_wear?.len)
		for(var/slot in clothing)
			var/obj/item/O = items_to_wear[slot]
			if (O)
				clothing[slot] = O
				O.forceMove(src)
		return
	var/obj/item/mapping_item = null
	for(var/slot in clothing)
		switch(slot)
			if(SLOT_MANNEQUIN_ICLOTHING)
				mapping_item = mapping_uniform
			if(SLOT_MANNEQUIN_FEET)
				mapping_item = mapping_shoes
			if(SLOT_MANNEQUIN_GLOVES)
				mapping_item = mapping_gloves
			if(SLOT_MANNEQUIN_OCLOTHING)
				mapping_item = mapping_suit
			if(SLOT_MANNEQUIN_EYES)
				mapping_item = mapping_glasses
			if(SLOT_MANNEQUIN_HEAD)
				mapping_item = mapping_hat
			if(SLOT_MANNEQUIN_BELT)
				mapping_item = mapping_belt
			if(SLOT_MANNEQUIN_MASK)
				mapping_item = mapping_mask
			if(SLOT_MANNEQUIN_BACK)
				mapping_item = mapping_back
			if(SLOT_MANNEQUIN_NECK)
				mapping_item = mapping_neck
			if(SLOT_MANNEQUIN_RIGHT_HAND)
				mapping_item = mapping_righthand
			if(SLOT_MANNEQUIN_LEFT_HAND)
				mapping_item = mapping_lefthand
		if(!mapping_item || !isitem(mapping_item))
			continue
		MannequinEquip(mapping_item, slot)

#undef MANNEQUIN_ICONS_SLOT
#undef SLOT_MANNEQUIN_LEFT_HAND
#undef SLOT_MANNEQUIN_RIGHT_HAND
#undef SLOT_MANNEQUIN_ICLOTHING
#undef SLOT_MANNEQUIN_FEET
#undef SLOT_MANNEQUIN_GLOVES
#undef SLOT_MANNEQUIN_OCLOTHING
#undef SLOT_MANNEQUIN_EYES
#undef SLOT_MANNEQUIN_BELT
#undef SLOT_MANNEQUIN_MASK
#undef SLOT_MANNEQUIN_HEAD
#undef SLOT_MANNEQUIN_BACK
#undef SLOT_MANNEQUIN_NECK
#undef HTMLTAB
