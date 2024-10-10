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
	/obj/item/flashlight/flare,
	/obj/item/pickaxe,
	)

/obj/effect/landmark/enkritemspawn/Initialize()
	..()
	var/spawning = pick(possible_items)
	new spawning(get_turf(src))
	var/timeradd = rand(1200, 1800)
	addtimer(CALLBACK(src, PROC_REF(spawnagain)), timeradd)

/obj/effect/landmark/enkritemspawn/proc/spawnagain()
	var/timeradd = rand(1200, 1800)
	addtimer(CALLBACK(src, PROC_REF(spawnagain)), timeradd)

	if(prob(50))	//50% to spawn
		return

	var/spawning = pick(possible_items)
	new spawning(get_turf(src))


//map-based enemy faction selection
//this will need its own folder
/obj/effect/spawner/scatter/enemy/map_enemy
	max_spawns = 0
	var/risk_multiplier = 1
	var/level = 1//risk level
	var/obj/effect/spawner/scatter/chosen_spawner//the spawner this copies vars from
	var/global/map_enemy//enemy type determined on roundstart
	var/list/ordeal_types = list()//the types of ordeals the enemy type can spawn
	var/list/spawner_types = list(//TODO: this needs to be determined by specific maps. Default is for District 4
			/datum/enemy/gold,
			/datum/enemy/brown,
			/datum/enemy/steel,
			)

/obj/effect/spawner/scatter/enemy/map_enemy/Initialize()//FIXME: basically none of this actually works. It spawns the picked spawner type while additionally spawning itself
	if(!map_enemy)
		map_enemy = pick(spawner_types)
		say(map_enemy)
	var/datum/enemy/myenemy = new map_enemy()
	if(istype(myenemy,/datum/enemy))
		ordeal_types = myenemy.ordeal_types
	say("there are [LAZYLEN(ordeal_types)] ordeal types")
	var/i = 0
	for(var/obj/S as anything in ordeal_types)
		say(S)
		i++
		if(i == level)
			chosen_spawner = new S()
			break
	var/bonus_spawns = level - i
	loot_table = chosen_spawner.loot_table//add the mobs to your own list
	max_spawns = ((chosen_spawner.max_spawns / 5) + 1) * bonus_spawns//these are meant to be fight solo. additional risk levels multiply # of units
	chosen_spawner.max_spawns = 0
	..()//spawn the enemies
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
	name = "amurdad-beanstalk corrosion spawn"
	max_spawns = 5
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion = 1,
			/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion = 1,
			)

/obj/effect/spawner/scatter/gold_noon
	name = "silent handmaiden spawn"
	max_spawns = 5
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion = 1,
			)

/obj/effect/spawner/scatter/gold_dusk
	name = "electric gold dusk spawn"
	max_spawns = 5
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/centipede_corrosion = 1 ,
			/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion = 1,
			/mob/living/simple_animal/hostile/ordeal/KHz_corrosion = 1,
			)

/obj/effect/spawner/scatter/gold_midnight
	name = "da capo corrosion spawn"
	max_spawns = 1
	loot_table = list(
			/mob/living/simple_animal/hostile/ordeal/tso_corrosion = 1 ,
			)
