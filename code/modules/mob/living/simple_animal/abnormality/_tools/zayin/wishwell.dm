/obj/structure/toolabnormality/wishwell
	name = "wishing well"
	desc = "A well constructed of stone and wood. From where does it draw water?"
	icon_state = "wishwell"
	can_buckle = TRUE
	max_buckled_mobs = 1
	var/list/bastards = list()

	ego_list = list(
		/datum/ego_datum/weapon/bucket,
		/datum/ego_datum/armor/bucket
		)

//loot lists
	var/list/superEGO = list( //do NOT put this in the loot lists ever. SuperEGO is for inputs only so people can throw away twilight for no good reason.
		/obj/item/ego_weapon/paradise,
		/obj/item/clothing/suit/armor/ego_gear/aleph/twilight,
		/obj/item/ego_weapon/twilight,
		/obj/item/ego_weapon/shield/distortion
		)
	var/list/strongaleph = list( //items that can be bought with PE with costs over 100 and other goodies
		/obj/item/nihil/heart,
		/obj/item/nihil/spade,
		/obj/item/nihil/diamond,
		/obj/item/nihil/club,
		/obj/item/clothing/suit/armor/ego_gear/aleph/paradise,
		/obj/item/clothing/suit/armor/ego_gear/aleph/distortion,
		/obj/item/ego_weapon/iron_maiden,
		/obj/item/clothing/suit/armor/ego_gear/aleph/flowering,
		/obj/item/toy/plush/bongbong
		)
	var/list/alephitem = list(//less junk items at higher risk levels
		/obj/item/clothing/suit/armor/ego_gear/aleph/praetorian,
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
		/obj/item/clothing/suit/armor/ego_gear/he/lutemis,
		/obj/item/grenade/spawnergrenade/shrimp,
		/obj/item/clothing/neck/beads,
		/obj/item/clothing/glasses/sunglasses/reagent,
		/obj/item/clothing/suit/hawaiian,
		/obj/item/clothing/neck/necklace/dope,
		)
	var/list/tethitem = list(
		/obj/item/clothing/suit/armor/ego_gear/teth/training,
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
		/obj/item/clothing/mask/cigarette/cigar/havana,
		/mob/living/carbon/human/species/shrimp
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
		/obj/item/clothing/under/suit/lobotomy/control,
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
		/obj/item/clothing/mask/facehugger/bongy,
		/mob/living/simple_animal/hostile/ordeal/violet_fruit,
		/mob/living/simple_animal/hostile/ordeal/sin_sloth,
		/mob/living/simple_animal/hostile/ordeal/sin_gluttony
		)
	var/list/noon = list(
		/mob/living/simple_animal/hostile/ordeal/green_bot_big,
		/mob/living/simple_animal/hostile/ordeal/indigo_noon,
		/mob/living/simple_animal/hostile/ordeal/sin_gloom
		)
	var/list/dusk = list(
		/mob/living/simple_animal/hostile/ordeal/sin_pride,
		/mob/living/simple_animal/hostile/ordeal/KHz_corrosion,
		/mob/living/simple_animal/hostile/mini_censored,
		/mob/living/simple_animal/hostile/slime
		)
	var/list/midnight = list(//TODO: Add more somewhat reasonable threats
		/mob/living/simple_animal/hostile/slime/big,
		/mob/living/simple_animal/hostile/ordeal/sin_wrath,
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
	//Accepts money, any EGO item except realized armor & clerk pistols and compares them to the lists
	if(istype(I, /obj/item/tool_extractor))
		return ..()
	if(!do_after(user, 0.5 SECONDS))
		return
	RunGacha(I, user)

/obj/structure/toolabnormality/wishwell/proc/RunGacha(obj/item/I, mob/living/carbon/human/user)
	var/output = null
	if(istype(I, /obj/item/holochip))
		output = "MONEY"
		to_chat(user, span_notice("You hear a plop as the holochip comes in contact with the water..."))
		user.playsound_local(user, 'sound/items/coinflip.ogg', 80, TRUE)
	else if(istype(I, /obj/item/clothing/suit/armor/ego_gear) || istype(I, /obj/item/gun/ego_gun/pistol) || istype(I, /obj/item/ego_weapon) || istype(I, /obj/item/gun/ego_gun) && !istype(I, /obj/item/gun/ego_gun/clerk))
		to_chat(user, span_notice("You hear the ego dissolve as it comes in contact with the water..."))
		user.playsound_local(user, 'sound/effects/wounds/sizzle1.ogg', 40, TRUE)
		if(locate(I) in tethitem)
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
		to_chat(user, span_userdanger("The well rejects your item!"))

	// Now for outputs
	if(!output)
		return
	if(!do_after(user, 2 SECONDS))
		to_chat(user, span_notice("You decide you want to keep your item."))
		return

	var/gift = null
	qdel(I)
	var/gacha = rand(1,100)
	switch(output)
		if("MONEY")
			switch(gacha)
				if(1 to 10) //10% odds, spawn trash....
					gift = pick(trash)
				if(11 to 60)// 50% odds, down 1 risk level
					gift = pick(baditem)
				if(61 to 95)//35% odds, spawn an item of the same tier
					gift = pick(normalitem)
				if(96 to 100)//5% odds, go up 1 risk level
					gift = pick(zayinitem)
		if("ZAYIN")
			switch(gacha)
				if(1 to 10)//10% odds, ...or a hostile mob if using EGO
					gift = pick(pick(dawn),pick(trash))
				if(11 to 60)
					gift = pick(normalitem)
				if(61 to 95)
					gift = pick(zayinitem)
				if(96 to 100)
					gift = pick(tethitem)
		if("TETH")
			switch(gacha)
				if(1 to 10)
					gift = pick(dawn)
				if(11 to 60)
					gift = pick(zayinitem)
				if(61 to 95)
					gift = pick(tethitem)
				if(96 to 100)
					gift = pick(heitem)
		if("HE")
			switch(gacha)
				if(1 to 10)
					gift = pick(noon)
				if(11 to 60)
					gift = pick(tethitem)
				if(61 to 95)
					gift = pick(heitem)
				if(96 to 100)
					gift = pick(wawitem)
		if("WAW")
			switch(gacha)
				if(1 to 10)
					gift = pick(dusk)
				if(11 to 60)
					gift = pick(heitem)
				if(61 to 95)
					gift = pick(wawitem)
				if(96 to 100)
					gift = pick(alephitem)
		if("ALEPH")
			switch(gacha)
				if(1 to 10)
					gift = pick(midnight)
				if(11 to 60)
					gift = pick(wawitem)
				if(61 to 95)
					gift = pick(alephitem)
				if(96 to 100)
					gift = pick(strongaleph) //The rarest item of all

	//Gacha now locked in
	playsound(src, 'sound/effects/bubbles.ogg', 80, TRUE, -3)
	sleep(4 SECONDS)
	if(gift)
		Dispense(gift)

/obj/structure/toolabnormality/wishwell/proc/Dispense(atom/dispenseobject)
	playsound(src, 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 80, FALSE, -3)
	var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
	new dispenseobject(dispense_turf)
	var/list/water_area = range(1, dispense_turf)
	for(var/turf/open/O in water_area)
		new /obj/effect/particle_effect/water(O)
	visible_message(span_notice("Something comes out of the well!"))

//Throw yourself into the well : The Code
/obj/structure/toolabnormality/wishwell/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("It doesn't look like I can't quite fit in."))
		return FALSE // Can only extract from humans.

	if(M != user)
		to_chat(user, span_warning("You start pulling [M] into the well."))
		if(do_after(user, 7 SECONDS)) //If you're going to throw someone else, they have to be dead first.
			if(M.stat == DEAD)
				to_chat(user, span_notice("You throw [M] in the well!"))
				buckle_mob(M, check_loc = check_loc)
			else
				to_chat(user, span_warning("How could you be so cruel? [M] is still alive!"))
		return

	to_chat(user, span_warning("You start climbing into the well."))
	if(!do_after(user, 7 SECONDS))
		to_chat(user, span_notice("You decide that might be a bad idea."))
		return FALSE

	to_chat(user, span_userdanger("You fall into the well!"))
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
	Dispense(deathgift)
	..()
