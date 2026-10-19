//Abnormalities that are mapped into enkephalin rush. Generally none should teleport or overall cause inconvenience to people outside the surrounding area
GLOBAL_LIST_INIT(assiyah, list(//HE's and TETHs
//	/mob/living/simple_animal/hostile/abnormality/puss_in_boots,//difficulty needs testing
//	/mob/living/simple_animal/hostile/abnormality/red_shoes,//re-introduce after breach rework
//	/mob/living/simple_animal/hostile/abnormality/der_freischutz,//buff its firing speed or range in #2723
	/mob/living/simple_animal/hostile/abnormality/golden_apple,
	/mob/living/simple_animal/hostile/abnormality/shock_centipede,
	/mob/living/simple_animal/hostile/abnormality/porccubus,
	/mob/living/simple_animal/hostile/abnormality/funeral,
	/mob/living/simple_animal/hostile/abnormality/kqe,
	/mob/living/simple_animal/hostile/abnormality/snow_queen,
	/mob/living/simple_animal/hostile/abnormality/der_fluschutze,
))

GLOBAL_LIST_INIT(briah, list(//WAW
	/mob/living/simple_animal/hostile/abnormality/apex_predator,
	/mob/living/simple_animal/hostile/abnormality/ebony_queen,
	/mob/living/simple_animal/hostile/abnormality/sphinx,
	/mob/living/simple_animal/hostile/abnormality/warden,
	/mob/living/simple_animal/hostile/abnormality/red_hood,
	/mob/living/simple_animal/hostile/abnormality/ardor_moth,
	null,
))

GLOBAL_LIST_INIT(atziluth, list(//ALEPH
	/mob/living/simple_animal/hostile/abnormality/nothing_there,
	/mob/living/simple_animal/hostile/abnormality/nobody_is,
	null,//District4 has four of these spawn points. Only two abnormalities will appear.
	null,
))

/obj/effect/landmark/abnospawn/enkephalin_rush
	name = "assiyah abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "zayin"
	var/list/abno_list = list()
	var/threat_level = ZAYIN_LEVEL

/obj/effect/landmark/abnospawn/enkephalin_rush/Initialize(mapload)
	..()
	if(!length(abno_list))
		return INITIALIZE_HINT_LATELOAD
	var/spawning = pick_n_take(abno_list)
	if(spawning)
		var/mob/living/simple_animal/hostile/abnormality/A = new spawning(get_turf(src))
		INVOKE_ASYNC(src, PROC_REF(CutQueue), A)
		return INITIALIZE_HINT_LATELOAD
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/abnospawn/enkephalin_rush/proc/CutQueue(mob/living/simple_animal/hostile/abnormality/abno)
	if(abno.type in SSabnormality_queue.possible_abnormalities[threat_level])
		addtimer(CALLBACK(abno, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality, BreachEffect), null, BREACH_MINING), 20 SECONDS)
		SSabnormality_queue.possible_abnormalities[threat_level] -= abno.type
		qdel(src)
	sleep(50)
	CutQueue(abno)

/obj/effect/landmark/abnospawn/enkephalin_rush/he
	threat_level = HE_LEVEL
	icon_state = "he"

/obj/effect/landmark/abnospawn/enkephalin_rush/he/Initialize(mapload)
	abno_list = GLOB.assiyah
	..()
	return INITIALIZE_HINT_QDEL//clogs the initialize() log otherwise

/obj/effect/landmark/abnospawn/enkephalin_rush/waw
	threat_level = WAW_LEVEL
	icon_state = "waw"

/obj/effect/landmark/abnospawn/enkephalin_rush/waw/Initialize(mapload)
	abno_list = GLOB.briah
	..()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/abnospawn/enkephalin_rush/aleph
	threat_level = ALEPH_LEVEL
	icon_state = "aleph"

/obj/effect/landmark/abnospawn/enkephalin_rush/aleph/Initialize(mapload)
	abno_list = GLOB.atziluth
	..()
	return INITIALIZE_HINT_QDEL

//containment cells and xenospawns
/obj/effect/landmark/delayed
	icon_state = "x2"
	var/spawner = null

/obj/effect/landmark/delayed/Initialize(mapload)
	..()
	addtimer(CALLBACK(src, PROC_REF(ArmProx)), 200)
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/delayed/HasProximity(atom/movable/AM)
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	if(!L.client)
		return
	INVOKE_ASYNC(src, PROC_REF(CreateLandmark),spawner)

/obj/effect/landmark/delayed/proc/ArmProx()
	proximity_monitor = new(src, 1)

/obj/effect/landmark/delayed/proc/CreateLandmark(spawner)
	if(spawner)
		new spawner(get_turf(src))
	qdel(src)

/obj/effect/landmark/delayed/xeno_spawn
	icon_state = "xeno_spawn"
	spawner = /obj/effect/landmark/xeno_spawn

/obj/effect/landmark/delayed/department_center
	name = "department_center"
	spawner = /obj/effect/landmark/department_center

/obj/effect/landmark/lake_generator
	name = "lake_generator"
	icon_state = "zayin"
	var/size = 16
	var/affected_turfs = list()
	var/corners = list()//list of corner pieces
	var/risk_level = 1

/obj/effect/landmark/lake_generator/Initialize()
	addtimer(CALLBACK(src, PROC_REF(GenerateLake)), 200)
	..()

/obj/effect/landmark/lake_generator/proc/GenerateLake()
	var/area/great_lake/random_lake/A = new()
	A.risk_level = risk_level
	var/list/diagonals = GLOB.diagonals.Copy()
	//randomly assign size here

	var/turf/corner_NW = get_ranged_target_turf(src, diagonals[2], size)
	var/turf/corner_SE = get_ranged_target_turf(src, diagonals[3], size)


	for(var/turf/T in block(corner_NW, corner_SE))//generate the initial square
		if(!istype(T, /turf/open/water/deep))
			continue
		affected_turfs += T

/*
	if(prob(10))//Starting point- lakes must become larger, rather than smaller. Think of some algorithms for trapezoids and stuff
		var/list/myline = getline(corner_NW, corner_SE)
		var mydir = pick(GLOB.cardinals)
		for(var/turf/T in myline)
			if(T in affected_turfs)
				affected_turfs -= T
				for(var/i = 1; i < size; ++i)
					var/turf/B = get_ranged_target_turf(T, mydir, i)
					affected_turfs -= B
*/

	for(var/turf/T in affected_turfs)//Initialize the lakes
		A.contents += T
	A.ColorWater()
	A.test_gen()
	qdel(src)

/obj/effect/landmark/lake_generator/teth
	icon_state = "teth"
	risk_level = 2

/obj/effect/landmark/lake_generator/he
	icon_state = "he"
	risk_level = 3

/obj/effect/landmark/lake_generator/waw
	icon_state = "waw"
	risk_level = 4

/obj/effect/landmark/lake_generator/aleph
	icon_state = "aleph"
	risk_level = 5

/obj/effect/landmark/middle_generator
	name = "middle_ship"
	icon_state = "random_room"

/obj/effect/landmark/middle_generator/Initialize(mapload)//Generate the boat with a bit of randomness - doesn't need to be super precise
	..()
	var/offset = rand(-64, 64)
	var/turf/T = get_ranged_target_turf(loc, pick(GLOB.alldirs), offset)
	new /obj/structure/middle_ship(get_turf(T))
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/sailor_spawn
	icon_state = "xeno_spawn"
	var/datum/sailor/datum_reference

/obj/effect/landmark/sailor_spawn/Destroy()
	QDEL_NULL(datum_reference)
	return ..()

