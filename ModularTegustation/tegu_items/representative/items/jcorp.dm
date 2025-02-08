/obj/item/coin/casino_token
	name = "J-Corp Casino Token"
	desc = "From a closer look, you can see this is a token from the casino gift shops, not actual currency!"
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR

/obj/item/coin/casino_token/wood
	desc = "The cheapest kind of casino token. Maybe the wishing well might see this as a fitting sacrifice?"
	custom_materials = list(/datum/material/wood = 400)

/obj/item/coin/casino_token/iron
	desc = "The second cheapest kind of casino token. Throwing it in the wishing well is one option, but you can gamble more to get even better tokens."
	custom_materials = list(/datum/material/iron = 400)

/obj/item/coin/casino_token/silver
	desc = "This token is pretty valuable. Not only is it worth a lot of ahn, but also werewolves won't mug you!" //Awful joke
	custom_materials = list(/datum/material/silver = 400)

/obj/item/coin/casino_token/gold
	desc = "This token is a high value token. The wishing well will pay out with something good, but will you go higher for more riches?"
	custom_materials = list(/datum/material/gold = 400)

/obj/item/coin/casino_token/diamond
	desc = "This token is worth a lot of ahn in casinos! It is about the amount of money the average nest citizen makes in a month!"
	custom_materials = list(/datum/material/diamond = 400)

GLOBAL_LIST_EMPTY(possible_loot_jcorp)

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
	var/list/banned_items = list(
		/obj/item/storage/box/lc_debugtools,
		/obj/item/storage/box/debugtools,
		/obj/item/storage/box/material,
		/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/admin,
		/obj/item/clothing/suit/space/hardsuit/syndi/elite/admin,
		/obj/item/card/id/debug,
		/obj/item/water_turf_spawner,
		/obj/item/ego_weapon/city/rats/truepipe,
		/obj/item/storage/belt/grenade,
		/obj/item/storage/belt/wands/full,
		/obj/item/melee/cultblade/dagger,
		/obj/item/gun/ballistic/automatic/gyropistol,
		/obj/item/gun/ballistic/rocketlauncher,
		/obj/item/gun/grenadelauncher,
		/obj/item/pda,
		/obj/item/necromantic_stone,
		/obj/item/gun/energy/decloner,
		/obj/item/melee/baton/cattleprod/teleprod,
	)
	var/list/banned_subtypes = list(
		/obj/item/lc_debug,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/uplink,
		/obj/item/gun/magic/wand,
		/obj/item/construction/rcd,
		/obj/item/dice/d20/fate,
		/obj/item/clothing/mask/animal, //There are cursed variants for each type
		/obj/item/defibrillator,
		/obj/item/grenade,
		/obj/item/gun/ballistic/revolver/grenadelauncher,
		/obj/item/storage/box/syndicate,
		/obj/item/clothing/head/hooded,
	)
	var/list/safe_items = list(
		/obj/item/grenade/firecracker,
		/obj/item/grenade/barrier,
		/obj/item/grenade/spawnergrenade/shrimp,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/ez_clean,
		/obj/item/grenade/chem_grenade/colorful,
		/obj/item/grenade/chem_grenade/glitter,
	)
	var/list/safe_subtypes = list(
		/obj/item/grenade/r_corp,
		/obj/item/grenade/spawnergrenade/shrimp,
		/obj/item/grenade/chem_grenade/glitter,
		/obj/item/grenade/smokebomb,
	)

	if(!GLOB.possible_loot_jcorp.len)
		var/list/gift_types_list = subtypesof(/obj/item)
		for(var/V in gift_types_list)
			var/obj/item/I = V
			if((!initial(I.icon_state)) || (!initial(I.inhand_icon_state)) || (initial(I.item_flags) & ABSTRACT))
				gift_types_list -= V
				continue
			if(I in safe_items)
				continue
			if(I in banned_items)
				gift_types_list -= V
			for(var/S in banned_subtypes)
				if(I in typesof(S))
					gift_types_list -= V
		for(var/safetype in safe_subtypes)
			for(var/I in safetype)
				if(!(I in gift_types_list))
					gift_types_list += I
		GLOB.possible_loot_jcorp = gift_types_list
	var/gift_type = pick(GLOB.possible_loot_jcorp)
	return gift_type

// Slot Machines

/obj/machinery/jcorp_slot_machine
	name = "J Corp Slot Machine"
	desc = "Just put in your casino token to gamble!"
	icon = 'icons/obj/economy.dmi'
	icon_state = "slots1"
	anchored = FALSE
	max_integrity = 2000
	density = TRUE
	use_power = 0

/obj/machinery/jcorp_slot_machine/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/coin/casino_token))
		if(!do_after(user, 2 SECONDS, src))
			return
		if(istype(I, /obj/item/coin/casino_token/diamond))
			process_gamble(5)
		else if(istype(I, /obj/item/coin/casino_token/gold))
			process_gamble(4)
		else if(istype(I, /obj/item/coin/casino_token/silver))
			process_gamble(3)
		else if(istype(I, /obj/item/coin/casino_token/iron))
			process_gamble(2)
		else if(istype(I, /obj/item/coin/casino_token/wood))
			process_gamble(1)
		else
			to_chat(user, span_userdanger("Wait a minute.... This isn't a legit token!"))
			return
		qdel(I)
	else
		return ..()

/obj/machinery/jcorp_slot_machine/proc/process_gamble(var/token_value)
	var/result = rand(10)
	var/final_value = 0
	if(result <= 1)
		final_value = 0
		visible_message(span_notice("The machine buzzes as nothing comes out"))
	else if(result <= 4)
		final_value = token_value - 1
		visible_message(span_notice("The machine buzzes as a less valuable token comes out."))
	else if(result <= 8)
		final_value = token_value
		visible_message(span_notice("The machine chimes as a token comes out"))
	else
		final_value = token_value
		print_prize(final_value)
		visible_message(span_notice("The machine makes all kind of noises as the prize is twice the tokens that was put in!"))
	if(final_value > 0)
		print_prize(final_value)

/obj/machinery/jcorp_slot_machine/proc/print_prize(var/token_value)
	switch(token_value)
		if(1)
			new /obj/item/coin/casino_token/wood(get_turf(src))
		if(2)
			new /obj/item/coin/casino_token/iron(get_turf(src))
		if(3)
			new /obj/item/coin/casino_token/silver(get_turf(src))
		if(4)
			new /obj/item/coin/casino_token/gold(get_turf(src))
		if(5)
			new /obj/item/coin/casino_token/diamond(get_turf(src))

// Crit Sticker (Will Test and add once Critical Hits are in)
///obj/item/clothing/mask/crit_sticker
//	name = "J Corp Critical Hit Sticker"
//	desc = "A sticker with a J on it. It seems to make you feel more focused when it is on you."
//	slot_flags = ITEM_SLOT_POCKETS
//	w_class = WEIGHT_CLASS_SMALL
//	var/crit_modifier = 2.5

// J Corp ERT Gear (We can move this code in case somebody adds some of the gear to gacha)
