/obj/effect/silent_orchestra_singer
	name = "silent orchestra performer"
	desc = "A white figure singing a song nobody can hear, but everyone can listen to."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "silent_1"
	density = FALSE
	anchored = TRUE
	alpha = 0

/obj/effect/silent_orchestra_singer/Initialize()
	..()
	animate(src, alpha = 155, time = 10)

/obj/effect/silent_orchestra_singer/proc/fade_out()
	animate(src, alpha = 0, time = 2 SECONDS)
	QDEL_IN(src, 2 SECONDS)
