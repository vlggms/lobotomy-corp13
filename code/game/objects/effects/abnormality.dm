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

/obj/effect/magic_bullet
	name = "magic bullet"
	desc = "A black bullet wreathed in blue-white energy, screaming forth at an unfathomable speed."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "magicbullet"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING

/obj/effect/magic_bullet/Initialize()
	..()
	playsound(get_turf(src), 'sound/abnormalities/freischutz/shoot.ogg', 100, 1)

/obj/effect/magic_bullet/proc/moveBullet() // Shamelessly stolen code from immovable rod and paradise lost, GO!
	var/list/nearmiss = list()
	while(src.x < 245 && src.x > 10 && src.y < 245 && src.y > 10)
		if(dir in list(EAST, WEST))
			nearmiss |= get_step(src, SOUTH).contents
			nearmiss |= get_step(src, NORTH).contents
		else
			nearmiss |= get_step(src, EAST).contents
			nearmiss |= get_step(src, WEST).contents
		var/turf/T = get_turf(src)
		for(var/mob/living/L in T.contents)
			if(L in nearmiss)
				continue
			L.apply_damage(160, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			visible_message("<span class='boldwarning'>[src] pierces through [L]!</span>")
			to_chat(L, "<span class='userdanger'>[src] slams through you!</span>")
		for(var/mob/living/L in nearmiss)
			L.apply_damage(80, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			visible_message("<span class='warning'>[src] just barely brushes past [L]!</span>")
			to_chat(L, "<span class='danger'>[src] grazes your side!</span>")
		var/obj/effect/frei_trail/trayl = new(T)
		trayl.dir = dir
		forceMove(get_step(src, dir))
	qdel(src)
	return

/obj/effect/frei_magic
	name = "magic circle"
	icon = 'icons/effects/effects.dmi'
	icon_state = "freicircle1"
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0

/obj/effect/frei_magic/Initialize()
	..()
	animate(src, alpha = 255, time = 6)
	playsound(get_turf(src), 'sound/abnormalities/freischutz/portal.ogg', 100, 0, 10)

/obj/effect/frei_magic/proc/fade_out()
	animate(src, alpha = 0, time = 10)
	QDEL_IN(src, 10)

/obj/effect/frei_trail
	name = "magic bullet trail"
	icon = 'icons/obj/projectiles_tracer.dmi'
	icon_state = "magicbullettrail"
	alpha = 0

/obj/effect/frei_trail/Initialize()
	..()
	animate(src, alpha = 255, time = 1, easing = JUMP_EASING)
	QDEL_IN(src, 33)

/obj/effect/scaredy_stun
	name = "Together"
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	icon_state = "scaredy_stun"
	layer = ABOVE_MOB_LAYER
	pixel_x = -10
	base_pixel_x = -10
	pixel_y = 25
	base_pixel_y = 25

/obj/effect/scaredy_stun/Initialize()
	..()
	animate(src, alpha = 0, time = 20 SECONDS)
	QDEL_IN(src, 20 SECONDS)

/obj/effect/expresstrain
	name = "Express Train to Hell"
	desc = "Oh no."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "expressengine_2"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	pixel_y = -32
	pixel_x = -32
	var/list/damaged = list()
	animate_movement = SLIDE_STEPS
	var/datum/looping_sound/expresstrain/soundloop
	var/clickety = 0
	var/noise = 0

/obj/effect/expresstrain/Moved()
	if(icon_state != "expressengine_1")
		return ..()
	if(clickety == 22)
		playsound(get_turf(src), 'sound/abnormalities/expresstrain/express_move_loop.ogg', 100, 0, 20)
		clickety = 0
	clickety += 1
	if(clickety % 2)
		var/obj/effect/particle_effect/smoke/s = new(locate(src.x, src.y + 2, src.z))
		s.pixel_y += 16
		if(src.dir != EAST)
			s.x += 2
	return ..()

/obj/effect/pale_case
	name = "pale suitcase"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "pale_case"
	density = FALSE
	anchored = TRUE

/obj/effect/pale_case/proc/FadeOut()
	animate(src, alpha = 0, time = 5)
	QDEL_IN(src, 5)
