/obj/structure/toolabnormality/wishwell
	name = "wishing well"
	desc = "A well constructed of stone and wood. From where does it draw water?"
	icon_state = "wishwell"
	can_buckle = TRUE
	max_buckled_mobs = 1
	var/list/bastards = list()

//loot lists
	var/list/superEGO = list( //do NOT put this in the loot lists ever. SuperEGO is for inputs only so people can throw away twilight for no good reason.
		/obj/item/ego_weapon/paradise,
		/obj/item/clothing/suit/armor/ego_gear/twilight,
		/obj/item/ego_weapon/twilight
		)
	var/list/alephitem = list(//less junk items at higher risk levels
		/obj/item/clothing/suit/armor/ego_gear/praetorian,
		/obj/item/toy/plush/mosb,
		/obj/item/toy/plush/melt
		)
	var/list/wawitem = list(
		/obj/item/clothing/suit/armor/ego_gear/limbus/durante,
		/obj/item/ego_weapon/lance/sangre,
		/obj/item/toy/plush/qoh,
		/obj/item/toy/plush/kog,
		/obj/item/toy/plush/kod,
		/obj/item/toy/plush/sow,
		/obj/item/toy/plush/nihil,
		/obj/item/toy/plush/bigbird,
		/obj/item/toy/plush/rabbit,
		/obj/item/grenade/spawnergrenade/shrimp/super,
		/obj/item/ego_weapon/flower_waltz
		)
	var/list/heitem = list(
		/obj/item/gun/ego_gun/sodashotty,
		/obj/item/gun/ego_gun/sodarifle,
		/obj/item/gun/ego_gun/sodasmg,
		/obj/item/clothing/suit/armor/ego_gear/lutemis,
		/obj/item/grenade/spawnergrenade/shrimp,
		/obj/item/clothing/neck/beads,
		/obj/item/clothing/glasses/sunglasses/reagent,
		/obj/item/clothing/suit/hawaiian,
		/obj/item/clothing/neck/necklace/dope,
		)
	var/list/tethitem = list(
		/obj/item/clothing/suit/armor/ego_gear/training,
		/obj/item/ego_weapon/training,
		/obj/item/clothing/suit/armor/ego_gear/rookie,
		/obj/item/clothing/suit/armor/ego_gear/fledgling,
		/obj/item/clothing/suit/armor/ego_gear/apprentice,
		/obj/item/clothing/suit/armor/ego_gear/freshman,
		/obj/item/clothing/under/suit/lobotomy/extraction/arbiter,
		/obj/item/clothing/under/suit/lobotomy/architecture,
		/obj/item/clothing/under/suit/lobotomy/rabbit,
		/obj/item/clothing/under/color/rainbow,
		/obj/item/toy/plush/yuri
		)
	var/list/zayinitem = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
		/obj/item/food/bread/bongbread,
		/obj/item/clothing/neck/tie/horrible,
		/obj/item/clothing/mask/cigarette/cigar/havana
		)
	var/list/normalitem = list(
		/obj/item/reagent_containers/hypospray/medipen/salacid,
		/obj/item/reagent_containers/hypospray/medipen/mental,
		/obj/item/ego_weapon/tutorial,
		/obj/item/ego_weapon/tutorial/white,
		/obj/item/ego_weapon/tutorial/black,
		/obj/item/ego_weapon/tutorial/pale,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/neck/tie/blue,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/under/suit/lobotomy/control, //remove these once enough items are here
		/obj/item/clothing/under/suit/lobotomy/information,
		/obj/item/clothing/under/suit/lobotomy/safety,
		/obj/item/clothing/under/suit/lobotomy/training,
		/obj/item/clothing/under/suit/lobotomy/command,
		/obj/item/clothing/under/suit/lobotomy/discipline,
		/obj/item/clothing/under/suit/lobotomy/discipline/alternative,
		/obj/item/clothing/under/suit/lobotomy/welfare,
		/obj/item/clothing/under/suit/lobotomy/extraction,
		/obj/item/clothing/under/suit/lobotomy/records,
		)
	var/list/baditem = list(
		/obj/item/toy/plush/yisang,
		/obj/item/toy/plush/faust,
		/obj/item/toy/plush/don,
		/obj/item/toy/plush/ryoshu,
		/obj/item/toy/plush/meursault,
		/obj/item/toy/plush/honglu,
		/obj/item/toy/plush/heathcliff,
		/obj/item/toy/plush/ishmael,
		/obj/item/toy/plush/rodion,
		/obj/item/toy/plush/sinclair,
		/obj/item/toy/plush/dante,
		/obj/item/toy/plush/outis,
		/obj/item/toy/plush/gregor,
		/obj/item/poster/random_contraband,
		/obj/item/poster/random_official,
		/obj/item/camera,
		/obj/item/light/bulb,
		/obj/item/light/tube,
		/obj/item/toy/eightball,
		/obj/item/rack_parts,
		/obj/item/clothing/under/color/rainbow,
		/obj/item/coin/silver
		)
	var/list/trash = list(
		/obj/item/toy/plush/fumo, //Needs no explanation
		/obj/item/toy/plush/blank,
		/obj/item/trash/raisins,
		/obj/item/trash/candy,
		/obj/item/trash/cheesie,
		/obj/item/trash/chips,
		/obj/item/trash/popcorn,
		/obj/item/trash/sosjerky,
		/obj/item/trash/plate,
		/obj/item/trash/pistachios,
		/obj/item/paper/crumpled,
		/obj/effect/decal/cleanable/ash,
		/obj/item/cigbutt,
		/obj/item/food/urinalcake,
		/obj/item/shard
		)

//Potential threats
	var/list/dawn = list(
		/mob/living/simple_animal/hostile/ordeal/green_bot,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
		/mob/living/simple_animal/hostile/ordeal/violet_fruit
		)
	var/list/noon = list(
		/mob/living/simple_animal/hostile/ordeal/green_bot_big,
		/mob/living/simple_animal/hostile/ordeal/indigo_noon,
		/mob/living/simple_animal/hostile/slime
		)
	var/list/dusk = list(
		/mob/living/simple_animal/hostile/ordeal/amber_dusk,
		/mob/living/simple_animal/hostile/ordeal/green_dusk,
		/mob/living/simple_animal/hostile/mini_censored,
		/mob/living/simple_animal/hostile/slime/big
		)
	var/list/midnight = list(//TODO: Wait until reasonable threats exist. These guys are too easy and midnights are too hard. Egor said no fixers.
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale
		)

//This proc removes the need to copypaste every single armor and weapon into a list.
/obj/structure/toolabnormality/wishwell/Initialize()
	. = ..()

//Sorts them into their lists
	for(var/path in subtypesof(/datum/ego_datum))
		var/datum/ego_datum/ego = path
		switch(initial(ego.cost))
			if(200 to INFINITY)
				superEGO += initial(ego.item_path)
			if(100 to 200)
				alephitem += initial(ego.item_path)
			if(50 to 100)
				wawitem += initial(ego.item_path)
			if(35 to 50)
				heitem += initial(ego.item_path)
			if(20 to 35)
				tethitem += initial(ego.item_path)
			if(0 to 20)
				zayinitem += initial(ego.item_path)

//End of loot lists
/obj/structure/toolabnormality/wishwell/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	//Accepts money, any EGO item except realized armor & clerk pistols and compares them to the lists
	if(!do_after(user, 0.5 SECONDS))
		return

	var/output = null
	if(istype(I, /obj/item/holochip))
		output = "MONEY"
		playsound(src, 'sound/items/coinflip.ogg', 80, TRUE, -3)
		to_chat(user, "<span class='notice'>You hear a plop as the holochip comes in contact with the water...</span>")
	else if(istype(I, /obj/item/clothing/suit/armor/ego_gear) || istype(I, /obj/item/gun/ego_gun/pistol) || istype(I, /obj/item/ego_weapon) || istype(I, /obj/item/gun/ego_gun) && !istype(I, /obj/item/gun/ego_gun/clerk))
		playsound(src, 'sound/effects/bubbles.ogg', 80, TRUE, -3)
		to_chat(user, "<span class='notice'>You hear the ego dissolve as it comes in contact with the water...</span>")
		if(locate(I) in tethitem) //TODO: use a different proc? We want an exact match in item paths.
			output = "TETH"
		else if(locate(I) in heitem)
			output = "HE"
		else if(locate(I) in wawitem)
			output = "WAW"
		else if((locate(I) in alephitem) || (locate(I) in superEGO))
			output = "ALEPH"
		else
			output = "ZAYIN" //If an EGO is not in the lists for whatever reason it will default to zayin
	else
		to_chat(user, "<span class='userdanger'>The well rejects your item!</span>")

	// Now for outputs
	if(!output)
		return

	if(!do_after(user, 7 SECONDS))
		to_chat(user, "<span class='userdanger'>The well goes silent as it detects your impatience.</span>")
		return

	var/gift = null
	qdel(I)
	var/gacha = rand(1,100)
	if(gacha > 50)
		playsound(src, 'sound/abnormalities//dreamingcurrent/dead.ogg', 80, TRUE, -3)
		to_chat(user, "<span class='notice'>Nothing happens...</span>")
		return

	switch(output)
		if("MONEY")
			switch(gacha)
				if(1 to 5) //5% odds, spawn trash....
					gift = pick(trash)
				if(6 to 15)// 10% odds, down 1 risk level
					gift = pick(baditem)
				if(16 to 50)//35% odds, spawn an item of the same tier
					gift = pick(normalitem)
		if("ZAYIN")
			switch(gacha)
				if(1 to 5)//5% odds, ...or a hostile mob if using EGO
					gift = pick(pick(dawn),pick(trash))
				if(6 to 15)
					gift = pick(normalitem)
				if(16 to 50)
					gift = pick(zayinitem)
		if("TETH")
			switch(gacha)
				if(1 to 5)
					gift = pick(dawn)
				if(6 to 15)
					gift = pick(zayinitem)
				if(16 to 50)
					gift = pick(tethitem)
		if("HE")
			switch(gacha)
				if(1 to 5)
					gift = pick(noon)
				if(6 to 15)
					gift = pick(tethitem)
				if(16 to 50)
					gift = pick(heitem)
		if("WAW")
			switch(gacha)
				if(1 to 5)
					gift = pick(dusk)
				if(6 to 15)
					gift = pick(heitem)
				if(16 to 20)//5% odds to get a rarer item at WAW/ALEPH
					gift = pick(/obj/item/ego_weapon/city/rabbit_blade,/obj/item/clothing/suit/armor/ego_gear/rabbit)
				if(21 to 50)
					gift = pick(wawitem)
		if("ALEPH")
			switch(gacha)
				if(1 to 5)
					gift = pick(midnight)
				if(6 to 15)
					gift = pick(wawitem)
				if(16 to 20)
					gift = pick(pick(alephitem),/obj/item/toy/plush/bongbong) //egor says no PL/flowering/twilight
				if(21 to 50)
					gift = pick(alephitem)

	//Gacha now locked in
	if(gift)
		playsound(src, 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 80, TRUE, -3)
		new gift(get_turf(src))
		visible_message("<span class='notice'>Something comes out of the well!</span>")

//Throw yourself into the well : The Code
/obj/structure/toolabnormality/wishwell/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(M != user)
		return FALSE

	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, "<span class='warning'>It doesn't look like I can't quite fit in.</span>")
		return FALSE // Can only extract from humans.

	to_chat(user, "<span class='warning'>You start climbing into the well.</span>")
	if(!do_after(user, 7 SECONDS))
		to_chat(user, "<span class='notice'>You decide that might be a bad idea.</span>")
		return FALSE

	to_chat(user, "<span class='userdanger'>You fall into the well!</span>")
	return ..(M, user, check_loc = FALSE) //it just works

/obj/structure/toolabnormality/wishwell/post_buckle_mob(mob/living/carbon/human/M)
	if(!ishuman(M))
		return
	var/deathgift
	var/stat_total
	for(var/attribute in M.attributes)
		stat_total += round(get_raw_level(M, attribute))

	switch(stat_total)
		if(0 to 80)
			deathgift = pick(normalitem)
		if(81 to 159)
			deathgift = pick(zayinitem)
		if(160 to 239)
			deathgift = pick(tethitem)
		if(240 to 359)
			deathgift = pick(heitem)
		if(360 to 479)
			deathgift = pick(wawitem) //best you can expect at max respawn stats
		if(480 to INFINITY)
			deathgift = pick(alephitem)

	qdel(M)
	playsound(src, 'sound/voice/human/wilhelm_scream.ogg', 50, TRUE, -3)
	if((M.ckey in bastards)) //prevents respawn abuse
		deathgift = pick(trash)

	bastards += M.ckey
	sleep(10)
	new deathgift(get_turf(src))
	playsound(src, 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 80, TRUE, -3)
	visible_message("<span class='notice'>Something comes out of the well!</span>")
	..()
