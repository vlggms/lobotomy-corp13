//Mainly supplies for latejoiners
/obj/effect/landmark/enkritemspawn
	name = "site burial requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
	/obj/item/ksyringe,
	/obj/item/reagent_containers/hypospray/medipen/salacid,
	/obj/item/reagent_containers/hypospray/medipen/mental,
	)

/obj/effect/landmark/enkritemspawn/Initialize()
	..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	var/timeradd = rand(1200, 1800)
	addtimer(CALLBACK(src, PROC_REF(spawnagain)), timeradd)
	return INITIALIZE_HINT_NORMAL

/obj/effect/landmark/enkritemspawn/proc/spawnagain()
	var/timeradd = rand(1200, 1800)
	addtimer(CALLBACK(src, PROC_REF(spawnagain)), timeradd)

	if(prob(50))	//50% to spawn
		return

	var/spawning = pick(possible_items)
	new spawning(get_turf(src))


//map-based enemy faction selection
/obj/effect/spawner/map_enemy
	var/risk_multiplier = 1
	var/level = 1//risk level
	var/obj/effect/spawner/scatter/chosen_spawner//the spawner this copies vars from
	var/global/map_enemy//enemy type determined when initialized the first time in a given round
	var/list/ordeal_types = list()//the types of ordeals the enemy type can spawn
	var/list/spawner_types = list(//TODO: this needs to be determined by specific maps. Default is currently for District 4
			/datum/enemy/gold,
//			/datum/enemy/brown,
//			/datum/enemy/steel,
			/datum/enemy/abnos,
			//TODO: wineberry creek E.G.O corrosion faction
			)

/obj/effect/spawner/map_enemy/New(loc, risk_level)
	if(risk_level)
		level = risk_level
	..()

/obj/effect/spawner/map_enemy/Initialize()
	if(!map_enemy)
		map_enemy = pick(spawner_types)
	var/datum/enemy/myenemy = new map_enemy()
	if(istype(myenemy,/datum/enemy))
		ordeal_types = myenemy.ordeal_types
	var/i = 0
	for(var/obj/S as anything in ordeal_types)
		i++
		if(i == level || i == LAZYLEN(ordeal_types))
			var/bonus_spawns = level - i
			chosen_spawner = new S(loc, spawns = (1 + bonus_spawns), range = 1)
			break
	..()
	return INITIALIZE_HINT_QDEL

/datum/enemy
	var/ordeal_types = list()

//amber ordeals
/datum/enemy/amber
	ordeal_types = list(
			/obj/effect/spawner/scatter/amber_dawn,
	)
//clockwork teeth; green ordeals
/datum/enemy/green
	ordeal_types = list(
			/obj/effect/spawner/scatter/green_dawn,
			/obj/effect/spawner/scatter/green_noon,
	)
//sweepers
/datum/enemy/indigo
	ordeal_types = list(
			/obj/effect/spawner/scatter/indigo_dawn,
			/obj/effect/spawner/scatter/indigo_noon,
	)
//E.G.O corroded LC employees
/datum/enemy/gold
	ordeal_types = list(
			/obj/effect/spawner/scatter/gold_dawn,
			/obj/effect/spawner/scatter/gold_noon,
			/obj/effect/spawner/scatter/gold_dusk,
			/obj/effect/spawner/scatter/gold_midnight,
	)
//peccatulae
/datum/enemy/brown
	ordeal_types = list(
			/obj/effect/spawner/scatter/brown_dawn,
	)
//G. corp veterans
/datum/enemy/steel
	ordeal_types = list(
			/obj/effect/spawner/scatter/steel_dawn,
			/obj/effect/spawner/scatter/steel_noon,
	)

//Abnormality thralls
/datum/enemy/abnos
	ordeal_types = list(
			/obj/effect/spawner/scatter/teth,
			/obj/effect/spawner/scatter/he,
			/obj/effect/spawner/scatter/waw,
			/obj/effect/spawner/scatter/aleph,
	)

	//Peccatulae
/obj/effect/spawner/scatter/brown_dawn
	name = "mixed peccatulae spawn"
	max_spawns = 10
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/sin_sloth = 1,
			/mob/living/simple_animal/hostile/ordeal/sin_gluttony = 1,
			/mob/living/simple_animal/hostile/ordeal/sin_gloom = 1,
			/mob/living/simple_animal/hostile/ordeal/sin_pride = 1,
			/mob/living/simple_animal/hostile/ordeal/sin_lust = 1,
			/mob/living/simple_animal/hostile/ordeal/sin_wrath = 1,
			)

	//E.G.O Corrosions
/obj/effect/spawner/scatter/gold_dawn
	name = "gold dawn corrosion spawn"
	max_spawns = 5
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/dragonskull_corrosion = 5,
			/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion = 1,
			/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion = 3,
			)

/obj/effect/spawner/scatter/gold_noon
	name = "gold noon spawn"
	max_spawns = 5
	loot_table = list(
			/mob/living/simple_animal/hostile/humanoid/rat/knife = 10,//temporary, until a proper silentgirl replacement is made
//			/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion = 10,
			/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion = 1,
			)

/obj/effect/spawner/scatter/gold_dusk
	name = "electric gold dusk spawn"
	max_spawns = 5
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/centipede_corrosion = 1 ,
			/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion = 12,
			/mob/living/simple_animal/hostile/ordeal/KHz_corrosion = 15,
			)

/obj/effect/spawner/scatter/gold_midnight
	name = "corroded inquisition spawn"
	max_spawns = 1
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/snake_corrosion = 10,
			/mob/living/simple_animal/hostile/ordeal/dog_corrosion = 10,
			/mob/living/simple_animal/hostile/ordeal/dog_corrosion/strong = 3,
			/mob/living/simple_animal/hostile/ordeal/snake_corrosion/strong = 3,
			/mob/living/simple_animal/hostile/ordeal/NT_corrosion = 3,
			/mob/living/simple_animal/hostile/ordeal/tso_corrosion = 1,//bosses
			)

/obj/effect/spawner/scatter/teth//generally these are supposed to be humans who died in the facility, but there aren't enough for good variety
	name = "teth abnormality thrall spawn"
	loot_table = list(
			/mob/living/simple_animal/hostile/doomsday_doll = 10,
			/mob/living/simple_animal/hostile/runawaybird = 5,//judgement bird minion
			/mob/living/simple_animal/hostile/azure_stave = 1,//servant of wrath minion
			)

/obj/effect/spawner/scatter/he
	name = "he abnormality thrall spawn"
	loot_table = list(
			/mob/living/simple_animal/hostile/shrimp = 10,//shrimp liquidation intern
			/mob/living/simple_animal/hostile/shrimp_soldier = 1,//shotgun shrimp
			/mob/living/simple_animal/hostile/gift = 1,//laetitia spider
			/mob/living/simple_animal/hostile/grown_strong = 1,
			/mob/living/simple_animal/hostile/nosferatu_mob = 10,
			/mob/living/simple_animal/hostile/worker_bee = 10,
			/mob/living/simple_animal/hostile/soldier_bee = 10,//identical to above, has a hat
			/mob/living/simple_animal/hostile/artillery_bee = 5,
			/mob/living/simple_animal/hostile/slime = 1,//ML slime (small)
			)

/obj/effect/spawner/scatter/waw
	name = "waw abnormality thrall spawn"
	loot_table = list(
			/mob/living/simple_animal/hostile/yagaslave = 5,
			/mob/living/simple_animal/hostile/parasite_tree_sapling = 1,
			/mob/living/simple_animal/hostile/thunder_zombie = 5,
			)

/obj/effect/spawner/scatter/aleph
	name = "aleph abnormality thrall spawn"
	loot_table = list(
			/mob/living/simple_animal/hostile/little_prince_1 = 1,//this guy has a wopping 1200 hp
			/mob/living/simple_animal/hostile/mini_censored = 1,
			/mob/living/simple_animal/hostile/meatblob = 10,
			/mob/living/simple_animal/hostile/meatblob/gunner = 5,
			/mob/living/simple_animal/hostile/meatblob/gunner/shotgun = 5,
			/mob/living/simple_animal/hostile/meatblob/gunner/sniper = 5,
			/mob/living/simple_animal/hostile/slime/big = 2//ML's chosen
			)
