//Abnormalities that are mapped into enkephalin rush. Generally none should teleport or overall cause inconvenience to people outside the surrounding area
GLOBAL_LIST_INIT(assiyah, list(//HE's and TETHs
//	/mob/living/simple_animal/hostile/abnormality/puss_in_boots,//difficulty needs testing
//	/mob/living/simple_animal/hostile/abnormality/red_shoes,//re-introduce after breach rework
//	/mob/living/simple_animal/hostile/abnormality/der_freischutz,//buff its firing speed or range in #2723
	/mob/living/simple_animal/hostile/abnormality/golden_apple,
	/mob/living/simple_animal/hostile/abnormality/shock_centipede,
	/mob/living/simple_animal/hostile/abnormality/ardor_moth,
	/mob/living/simple_animal/hostile/abnormality/porccubus,
	/mob/living/simple_animal/hostile/abnormality/funeral,
	/mob/living/simple_animal/hostile/abnormality/kqe,
	/mob/living/simple_animal/hostile/abnormality/snow_queen,
))

GLOBAL_LIST_INIT(briah, list(//WAW
	/mob/living/simple_animal/hostile/abnormality/apex_predator,
	/mob/living/simple_animal/hostile/abnormality/ebony_queen,
	/mob/living/simple_animal/hostile/abnormality/sphinx,
	/mob/living/simple_animal/hostile/abnormality/warden,
	/mob/living/simple_animal/hostile/abnormality/red_hood,
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
	icon_state = "x4"
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

/obj/effect/landmark/abnospawn/enkephalin_rush/he/Initialize(mapload)
	abno_list = GLOB.assiyah
	..()
	return INITIALIZE_HINT_QDEL//clogs the initialize() log otherwise

/obj/effect/landmark/abnospawn/enkephalin_rush/waw
	threat_level = WAW_LEVEL

/obj/effect/landmark/abnospawn/enkephalin_rush/waw/Initialize(mapload)
	abno_list = GLOB.briah
	..()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/abnospawn/enkephalin_rush/aleph
	threat_level = ALEPH_LEVEL

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

