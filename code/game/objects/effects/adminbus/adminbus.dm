/obj/effect/adminbus
	name = "yell at coderbus/adminbus"
	icon = 'icons/effects/effects.dmi'
	icon_state = "chronofield"

/obj/effect/adminbus/Initialize(mapload)
	. = ..()

/obj/effect/adminbus/targeted/Initialize(mapload, mob/M = NONE)
	. = ..()
