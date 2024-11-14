GLOBAL_LIST_INIT(railway1, list(
	/mob/living/simple_animal/hostile/abnormality/blue_shepherd,
	/mob/living/simple_animal/hostile/abnormality/helper,
	/mob/living/simple_animal/hostile/abnormality/fragment,
	/mob/living/simple_animal/hostile/abnormality/puss_in_boots,
	/mob/living/simple_animal/hostile/abnormality/woodsman,
	/mob/living/simple_animal/hostile/abnormality/scarecrow,
	/mob/living/simple_animal/hostile/abnormality/fairy_gentleman,
	/mob/living/simple_animal/hostile/abnormality/headless_ichthys,
))

GLOBAL_LIST_INIT(railway2, list(
	/mob/living/simple_animal/hostile/abnormality/judgement_bird,
	/mob/living/simple_animal/hostile/abnormality/yin,
	/mob/living/simple_animal/hostile/abnormality/ebony_queen,
	/mob/living/simple_animal/hostile/abnormality/thunder_bird,
	/mob/living/simple_animal/hostile/abnormality/clouded_monk,
	/mob/living/simple_animal/hostile/abnormality/red_hood,
	/mob/living/simple_animal/hostile/abnormality/despair_knight,
	/mob/living/simple_animal/hostile/abnormality/kqe,
	/mob/living/simple_animal/hostile/abnormality/golden_apple,
	/mob/living/simple_animal/hostile/abnormality/black_swan,
	/mob/living/simple_animal/hostile/abnormality/funeral,
	/mob/living/simple_animal/hostile/abnormality/nosferatu,
))

GLOBAL_LIST_INIT(railway3, list(
	/mob/living/simple_animal/hostile/abnormality/nothing_there,
	/mob/living/simple_animal/hostile/abnormality/luna,
	/mob/living/simple_animal/hostile/abnormality/big_wolf,
))

/obj/effect/landmark/abnospawn/railway1
	name = "railway easy abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/abnospawn/railway1/Initialize()
	..()
	var/spawning = pick_n_take(GLOB.railway1)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL


/obj/effect/landmark/abnospawn/railway2
	name = "railway medium abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"

/obj/effect/landmark/abnospawn/railway2/Initialize()
	..()
	var/spawning = pick_n_take(GLOB.railway2)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL


/obj/effect/landmark/abnospawn/railway3
	name = "railway boss abno spawner"
	desc = "It spawns an abno. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x3"

/obj/effect/landmark/abnospawn/railway3/Initialize()
	..()
	var/spawning = pick_n_take(GLOB.railway3)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL
