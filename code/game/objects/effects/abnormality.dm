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
	animate(src, alpha = 225, time = 10)

/obj/effect/silent_orchestra_singer/proc/fade_out()
	animate(src, alpha = 0, time = 2 SECONDS)
	QDEL_IN(src, 2 SECONDS)

/obj/effect/qoh_sygil
	name = "magic sygil"
	desc = "A magic circle of power."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "qoh1"
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0

/obj/effect/qoh_sygil/Initialize()
	..()
	animate(src, alpha = 255, time = 15)

/obj/effect/qoh_sygil/proc/fade_out()
	animate(src, alpha = 0, time = 1 SECONDS)
	QDEL_IN(src, 1 SECONDS)
