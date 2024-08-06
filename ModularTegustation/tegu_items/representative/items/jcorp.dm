/obj/item/casinotoken
	name = "J-Corp Casino Token"
	desc = "You won't get much use of it in this facility. But maybe the wishing well might see this as a more fitting sacrifice?"
	icon = 'icons/obj/economy.dmi'
	icon_state = "coin_heads"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/a_gift/jcorp
	name = "J Corp Brand Lootbox"
	desc = "What could be inside of this?"
	icon_state = "jcorplootbox1" //Sprite by RayAleciana
	inhand_icon_state = "jcorplootbox"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/a_gift/jcorp/Initialize()
	. = ..()
	icon_state = "jcorplootbox[rand(1,3)]"

/obj/item/a_gift/jcorp/get_gift_type()
	var/list/banned_items = subtypesof(/obj/item/lc_debug) + subtypesof(/obj/item/reagent_containers/glass/bottle) + subtypesof(/obj/item/uplink)
	if(!GLOB.possible_gifts.len)
		var/list/gift_types_list = subtypesof(/obj/item)
		for(var/V in gift_types_list)
			var/obj/item/I = V
			if((!initial(I.icon_state)) || (!initial(I.inhand_icon_state)) || (initial(I.item_flags) & ABSTRACT))
				gift_types_list -= V
				continue
			if(I in banned_items)
				gift_types_list -= V
		GLOB.possible_gifts = gift_types_list
	var/gift_type = pick(GLOB.possible_gifts)
	return gift_type

// Crit Sticker (Will Test and add once Critical Hits are in)
///obj/item/clothing/mask/crit_sticker
//	name = "J Corp Critical Hit Sticker"
//	desc = "A sticker with a J on it. It seems to make you feel more focused when it is on you."
//	slot_flags = ITEM_SLOT_POCKETS
//	w_class = WEIGHT_CLASS_SMALL
//	var/crit_modifier = 2.5
