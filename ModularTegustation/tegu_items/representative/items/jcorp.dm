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
		/obj/item/clothing/suit/space/hardsuit/syndi/elite/admin,
		/obj/item/card/id/debug,
		/obj/item/water_turf_spawner,
		/obj/item/ego_weapon/city/rats/truepipe,
		/obj/item/storage/belt/grenade,
		/obj/item/storage/belt/wands/full,
		/obj/item/gun/ballistic/automatic/gyropistol,
		/obj/item/gun/ballistic/rocketlauncher,
		/obj/item/gun/grenadelauncher,
		/obj/item/pda,
		/obj/item/necromantic_stone,
		/obj/item/gun/energy/decloner,
		/obj/item/melee/baton/cattleprod/teleprod,
		/obj/item/storage/backpack/duffelbag/cursed,
		/obj/item/storage/backpack/santabag,
		/obj/item/clothing/mask/facehugger,
		/obj/item/disk/surgery/debug,
		/obj/item/clothing/suit/space/chronos,
		/obj/item/veilrender,
		/obj/item/clothing/head/sombrero/shamebrero,
		/obj/item/lava_staff,
		/obj/item/cult_bastard,
		/obj/item/gun/energy/minigun, //No pack means it auto deletes itself
	)
	var/list/banned_subtypes = list(
		/obj/item/lc_debug,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/uplink,
		/obj/item/gun/magic,
		/obj/item/construction/rcd,
		/obj/item/dice/d20/fate,
		/obj/item/clothing/mask/animal, //There are cursed variants for each type
		/obj/item/defibrillator,
		/obj/item/grenade,
		/obj/item/gun/ballistic/revolver/grenadelauncher,
		/obj/item/storage/box,
		/obj/item/clothing/head/hooded,
		/obj/item/reagent_containers/borghypo,
		/obj/item/autosurgeon/organ/syndicate,
		/obj/item/implanter,
		/obj/item/reagent_containers/hypospray,
		/obj/item/bombcore,
		/obj/item/a_gift,
		/obj/item/cartridge/virus,
		/obj/item/melee/cultblade,
		/obj/item/reagent_containers/borghypo,
		/obj/item/storage/belt/soulstone,
		/obj/item/soulstone,
		/obj/item/clothing/head/helmet/space,
		/obj/item/storage/backpack/duffelbag/syndie,
		/obj/item/assembly/signaler/anomaly,
		/obj/item/autosurgeon/skillchip/syndicate,
		/obj/item/gun/energy/meteorgun,
		/obj/item/implanter/uplink,
		/obj/item/shockpaddles,
		/obj/item/gun/energy/laser/instakill,
	)
	var/list/safe_items = list(
		/obj/item/grenade/firecracker,
		/obj/item/grenade/barrier,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/ez_clean,
		/obj/item/grenade/chem_grenade/colorful,
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
			if((!initial(I.icon_state)) || (!initial(I.inhand_icon_state)) || (initial(I.item_flags) & (ABSTRACT | DROPDEL)))
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
	var/result = rand(20)
	var/final_value = 0
	if(result <= 9)
		final_value = 0
		visible_message(span_notice("The machine buzzes as nothing comes out"))
	else if(result == 10)
		final_value = token_value - 1
		visible_message(span_notice("The machine buzzes as a less valuable token comes out."))
	else if(result <= 19)
		final_value = token_value
		visible_message(span_notice("The machine chimes as twice as many tokens come out"))
		print_prize(final_value)
	else
		final_value = token_value + 1
		if(final_value == 6)
			visible_message(span_notice("The machine chimes as twice as many tokens come out"))
			print_prize(final_value)
		else
			visible_message(span_notice("The machine makes all kind of noises as a more valuable token comes out!"))
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
		if(5 to INFINITY) //Shouldn't be possible to get higher than six but might as well put a failsafe
			new /obj/item/coin/casino_token/diamond(get_turf(src))

/obj/item/blood_slots
	name = "J Corp Blood Slots"
	desc = "A peculiar device sold by J Corp that uses health as currency for gambling! It can give a variety of prizes!"
	icon = 'icons/obj/syringe.dmi'
	icon_state = "sampler"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown_timer = 2 SECONDS
	var/cooldown

/obj/item/blood_slots/Initialize()
	. = ..()
	cooldown = world.time

/obj/item/blood_slots/attack_self(mob/living/user)
	..()
	if(cooldown <= world.time)
		to_chat(user, span_notice("You feel the injector jab into you!"))
		user.adjustBruteLoss(50)
		var/result = rand(1,100)
		switch(result)
			if(1 to 55)
				to_chat(user, span_notice("The machine buzzes."))
			if(56 to 90)
				to_chat(user, span_notice("The machine gives off a healing pulse."))
				user.adjustBruteLoss(-100)
				new /obj/effect/temp_visual/heal(get_turf(user), "#FF4444")
				for(var/mob/living/carbon/human/H in view(4, get_turf(src)))
					if(H.stat >= HARD_CRIT)
						continue
					H.adjustBruteLoss(-100)
					new /obj/effect/temp_visual/heal(get_turf(H), "#FF4444")
			if(90 to 99)
				to_chat(user, span_notice("The machine dispenses a token!"))
				new /obj/item/coin/casino_token/iron(get_turf(src))
			if(100)
				to_chat(user, span_notice("The machine dispenses a token!"))
				new /obj/item/coin/casino_token/silver(get_turf(src))
		cooldown = world.time + cooldown_timer




// J Corp ERT Gear (We can move this code in case somebody adds some of the gear to gacha)
