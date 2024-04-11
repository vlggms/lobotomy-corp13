GLOBAL_LIST_INIT(low_security, list(
	/mob/living/simple_animal/hostile/abnormality/scarecrow,
	/mob/living/simple_animal/hostile/abnormality/kqe,
	/mob/living/simple_animal/hostile/abnormality/funeral,
	/mob/living/simple_animal/hostile/abnormality/redblooded,
	/mob/living/simple_animal/hostile/abnormality/blue_shepherd,
	/mob/living/simple_animal/hostile/abnormality/cleaner,
	/mob/living/simple_animal/hostile/abnormality/pinocchio,
	/mob/living/simple_animal/hostile/abnormality/forsaken_murderer,
	/mob/living/simple_animal/hostile/abnormality/fragment,
	/mob/living/simple_animal/hostile/abnormality/fairy_longlegs,
	/mob/living/simple_animal/hostile/abnormality/pisc_mermaid,
	/mob/living/simple_animal/hostile/abnormality/der_freischutz,

))

GLOBAL_LIST_INIT(high_security, list(
	/mob/living/simple_animal/hostile/abnormality/clouded_monk,
	/mob/living/simple_animal/hostile/abnormality/clown,
	/mob/living/simple_animal/hostile/abnormality/nothing_there,
	/mob/living/simple_animal/hostile/abnormality/steam,
	/mob/living/simple_animal/hostile/abnormality/mountain,
	/mob/living/simple_animal/hostile/abnormality/despair_knight,
	/mob/living/simple_animal/hostile/abnormality/red_hood,

))


//Split into Lowsec and Highsec
/obj/effect/landmark/abnospawn/lowsec
	name = "lowsec abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x3"

/obj/effect/landmark/abnospawn/lowsec/Initialize()
	..()
	var/spawning = pick_n_take(GLOB.low_security)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/abnospawn/highsec
	name = "highsec abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"

/obj/effect/landmark/abnospawn/highsec/Initialize()
	..()
	var/spawning = pick_n_take(GLOB.high_security)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL

