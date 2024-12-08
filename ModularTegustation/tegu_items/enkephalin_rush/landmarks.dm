//Abnormalities that are mapped into enkephalin rush. Generally none should teleport or overall cause inconvenience to people outside the surrounding area
GLOBAL_LIST_INIT(assiyah, list(//HE's and TETHs
	/mob/living/simple_animal/hostile/abnormality/puss_in_boots,
	/mob/living/simple_animal/hostile/abnormality/woodsman,
	/mob/living/simple_animal/hostile/abnormality/redblooded,
	/mob/living/simple_animal/hostile/abnormality/funeral,
	/mob/living/simple_animal/hostile/abnormality/scarecrow,
	/mob/living/simple_animal/hostile/abnormality/golden_apple,
	/mob/living/simple_animal/hostile/abnormality/shock_centipede,
	/mob/living/simple_animal/hostile/abnormality/ardor_moth,
	/mob/living/simple_animal/hostile/abnormality/porccubus,
))

GLOBAL_LIST_INIT(briah, list(//WAW
	/mob/living/simple_animal/hostile/abnormality/thunder_bird,
	/mob/living/simple_animal/hostile/abnormality/big_bird,
	/mob/living/simple_animal/hostile/abnormality/nosferatu,
	/mob/living/simple_animal/hostile/abnormality/big_wolf,
	/mob/living/simple_animal/hostile/abnormality/dreaming_current,
))

GLOBAL_LIST_INIT(atziluth, list(//ALEPH
	/mob/living/simple_animal/hostile/abnormality/mountain,
	/mob/living/simple_animal/hostile/abnormality/melting_love,
	/mob/living/simple_animal/hostile/abnormality/censored,

))

//Split into 3 groups, Combat for damaging abnos, Support for ranged, AOE and otherwise support abnos, and tank for abnos that can take a beating reliably
/obj/effect/landmark/abnospawn/assiyah
	name = "assiyah abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/abnospawn/assiyah/Initialize()//Use subtypes instead of repeating all this code
	..()
	var/spawning = pick_n_take(GLOB.assiyah)
	if(spawning)
		var/mob/living/simple_animal/hostile/abnormality/A = new spawning(get_turf(src))
		addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality, BreachEffect), BREACH_PINK), 2 SECONDS)
		SSabnormality_queue.possible_abnormalities[HE_LEVEL] -= spawning
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/abnospawn/briah
	name = "briah abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/abnospawn/briah/Initialize()
	..()
	var/spawning = pick_n_take(GLOB.briah)
	if(spawning)
		var/mob/living/simple_animal/hostile/abnormality/A = new spawning(get_turf(src))
		addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality, BreachEffect), BREACH_PINK), 2 SECONDS)
		SSabnormality_queue.possible_abnormalities[WAW_LEVEL] -= spawning
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/abnospawn/atziluth
	name = "atziluth abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/abnospawn/atziluth/Initialize()
	..()
	var/spawning = pick_n_take(GLOB.atziluth)
	if(spawning)
		var/mob/living/simple_animal/hostile/abnormality/A = new spawning(get_turf(src))
		addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality, BreachEffect), BREACH_PINK), 2 SECONDS)
		SSabnormality_queue.possible_abnormalities[ALEPH_LEVEL] -= spawning
	return INITIALIZE_HINT_QDEL

//containment cells and xenospawns
/obj/effect/landmark/delayed
	icon_state = "x2"
	var/spawner = null

/obj/effect/landmark/delayed/proc/CreateLandmark(spawner)
	if(spawner)
		new spawner(get_turf(src))
	qdel(src)

/obj/effect/landmark/delayed/xeno_spawn
	icon_state = "xeno_spawn"
	spawner = /obj/effect/landmark/xeno_spawn

/obj/effect/landmark/delayed/abnormality_room
	icon_state = "abno_room"
	spawner = /obj/effect/spawner/abnormality_room

/obj/effect/landmark/delayed/department_center
	name = "department_center"
	spawner = /obj/effect/landmark/department_center
