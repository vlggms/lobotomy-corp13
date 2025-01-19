/obj/item/fishing_net
	name = "fishing net"
	desc = "This tool functions as a aquatic wall you can put down and just harvest the fish that get tangled in it."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "trawling_net"
	w_class = WEIGHT_CLASS_HUGE
	var/deploy_type = /obj/structure/destructible/fishing_net
	//Item deployment code is inside /turf/open/water/deep

/obj/structure/destructible/fishing_net
	name = "fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "trawling_net_empty"
	anchored = TRUE
	max_integrity = 5
	break_message = span_notice("The net falls apart!")
	break_sound = 'sound/items/wirecutter.ogg'
	debris = list(/obj/item/fishing_net = 1)
	var/net_type = /obj/item/fishing_net
	var/icon_state_fished = "trawling_net_full"
	var/fishin_cooldown = 25 SECONDS
	var/fishin_cooldown_delay = 1 SECONDS
	var/fishin_power = 0.8
	var/turf/open/water/deep/open_waters
	var/enemy_chance = 15 //chance of getting enemies
	var/capacity = 5

/obj/structure/destructible/fishing_net/Initialize()
	. = ..()
	open_waters = get_turf(src)
	if(!istype(open_waters, /turf/open/water/deep))
		qdel(src)
		return
	//will proc at least 5 times before the loop stops.
	addtimer(CALLBACK(src, PROC_REF(CatchFish)), fishin_cooldown + fishin_cooldown_delay)

/obj/structure/destructible/fishing_net/examine(mob/user)
	. = ..()
	if(contents.len > 0)
		. += span_notice("[contents.len]/[capacity] things are caught in the [src].")

/obj/structure/destructible/fishing_net/AltClick(mob/living/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	EmptyNet(get_turf(user), user)

/obj/structure/destructible/fishing_net/proc/EmptyNet(turf/dropoff, mob/living/user)
	for(var/atom/movable/harvest in contents)
		harvest.forceMove(dropoff)
	new net_type(dropoff)
	if(SSmaptype.maptype in SSmaptype.citymaps)
		if(user.god_aligned == FISHGOD_VENUS)
			enemy_chance/=2

		if(CheckPlanetAligned(FISHGOD_VENUS))
			enemy_chance/=2

		if(enemy_chance>5) //gotta have more than 5%
			if(prob(enemy_chance))
				SpawnEnemy(dropoff, user)
	qdel(src)

/obj/structure/destructible/fishing_net/proc/CatchFish()
	if(contents.len >= capacity || !open_waters)
		return
	var/atom/thing_caught = pickweight(open_waters.ReturnChanceList(fishin_power))
	new thing_caught(src)
	icon_state = icon_state_fished
	update_icon()
	fishin_cooldown_delay = rand(0, 5) SECONDS
	addtimer(CALLBACK(src, PROC_REF(CatchFish)), fishin_cooldown + fishin_cooldown_delay)

/obj/structure/destructible/fishing_net/proc/SpawnEnemy(turf/dropoff, mob/user)
	var/spawning = /mob/living/simple_animal/hostile/shrimp
	if(prob(1) && SSfishing.IsAligned(/datum/planet/mars))
		spawning = /mob/living/simple_animal/hostile/distortion/shrimp_rambo/easy

	if(prob(5)) //Super rares first
		spawning = /mob/living/simple_animal/hostile/shrimp_soldier
	if(prob(20))
		spawning = pick(/mob/living/simple_animal/hostile/shrimp_rifleman, /mob/living/simple_animal/hostile/senior_shrimp)
	else
		spawning = /mob/living/simple_animal/hostile/shrimp

	new spawning(dropoff)

//Nylon net
/obj/item/fishing_net/nylon
	name = "nylon fishing net"
	desc = "This tool functions as a aquatic wall you can put down and just harvest the fish that get tangled in it. Nylon nets catch fish significantly faster, and catch less enemies."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "nylon_net"
	w_class = WEIGHT_CLASS_HUGE
	deploy_type = /obj/structure/destructible/fishing_net/nylon

/obj/structure/destructible/fishing_net/nylon
	name = "nylon fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon_state = "trawling_net_nylon"
	icon_state_fished = "trawling_net_nylon_full"
	debris = list(/obj/item/fishing_net/nylon = 1)
	net_type = /obj/item/fishing_net/nylon
	fishin_cooldown = 15 SECONDS
	fishin_power = 0.7 //Slightly worse
	enemy_chance = 10


//Steel net
/obj/item/fishing_net/steel
	name = "steel fishing net"
	desc = "This tool functions as a aquatic wall you can put down and just harvest the fish that get tangled in it. Steel nets are slightly slower, but catch better fish and less enemies."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "steel_net"
	w_class = WEIGHT_CLASS_HUGE
	deploy_type = /obj/structure/destructible/fishing_net/steel

/obj/structure/destructible/fishing_net/steel
	name = "steel fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon_state = "trawling_net_steel"
	icon_state_fished = "trawling_net_steel_full"
	debris = list(/obj/item/fishing_net/steel = 1)
	net_type = /obj/item/fishing_net/steel
	fishin_cooldown = 30 SECONDS //Slower.
	fishin_power = 1.4
	enemy_chance = 10


//Baited net
/obj/item/fishing_net/baited
	name = "baited fishing net"
	desc = "Baited nets are much faster, and have increased fishing power, however, they have a downside of catching more hostile lifeforms"
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "bait_net"
	w_class = WEIGHT_CLASS_HUGE
	deploy_type = /obj/structure/destructible/fishing_net/baited

/obj/structure/destructible/fishing_net/baited
	name = "baited fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon_state = "trawling_net_bait"
	icon_state_fished = "trawling_net_bait_full"
	debris = list(/obj/item/fishing_net/baited = 1)
	net_type = /obj/item/fishing_net/baited
	fishin_cooldown = 15 SECONDS
	fishin_power = 1.4
	enemy_chance = 30

//Hicap
/obj/item/fishing_net/hicap
	name = "high capacity fishing net"
	desc = "These special nets can hold twice the amount of fish!"
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "hicap_net"
	w_class = WEIGHT_CLASS_HUGE
	deploy_type = /obj/structure/destructible/fishing_net/hicap

/obj/structure/destructible/fishing_net/hicap
	name = "baited fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon_state = "trawling_net_hicap"
	icon_state_fished = "trawling_net_hicap_full"
	debris = list(/obj/item/fishing_net/hicap = 1)
	net_type = /obj/item/fishing_net/hicap
	capacity = 10

//Shrimp Bait net
/obj/item/fishing_net/big_bait
	name = "big baited fishing net"
	desc = "Big Baited nets are much slower the normal nets, however they have a near guaranteed chance at catching hostile lifeforms"
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "shrimp_net"
	w_class = WEIGHT_CLASS_HUGE
	deploy_type = /obj/structure/destructible/fishing_net/big_bait

/obj/structure/destructible/fishing_net/big_bait
	name = "big baited fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon_state = "trawling_shrimp_net"
	icon_state_fished = "trawling_shrimp_net_full"
	debris = list(/obj/item/fishing_net/big_bait = 1)
	net_type = /obj/item/fishing_net/big_bait
	fishin_cooldown = 45 SECONDS //Much Slower
	fishin_power = 1
	enemy_chance = 95
	capacity = 1

//Clan Nets
/obj/item/fishing_net/resurgence
	name = "resurgence clan fishing net"
	desc = "Resurgence Clan nets are slightly better then the normal fishing net, and have a slightly higher chance at catching foes"
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "clan_net"
	w_class = WEIGHT_CLASS_HUGE
	deploy_type = /obj/structure/destructible/fishing_net/resurgence

/obj/structure/destructible/fishing_net/resurgence
	name = "resurgence clan fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon_state = "trawling_net_clan"
	icon_state_fished = "trawling_net_clan_full"
	debris = list(/obj/item/fishing_net/resurgence = 1)
	net_type = /obj/item/fishing_net/resurgence
	fishin_cooldown = 30 SECONDS
	fishin_power = 1
	enemy_chance = 25
