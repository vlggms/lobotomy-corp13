/* A series of particle systems. Some are based on F0lak's particle systems
*/

/particles/fire
	width = 500
	height = 500
	count = 3000
	spawning = 3
	lifespan = 10
	fade = 10
	velocity = list(0, 0)
	position = generator("circle", 0, 8, NORMAL_RAND)
	drift = generator("vector", list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.65)

	color = "white"

/particles/smoke
	width = 500
	height = 1000
	count = 3000
	spawning = 5
	lifespan = 40
	fade = 40
	velocity = generator("box", list(-1, 2), list(1, 2), NORMAL_RAND)
	gravity = list(0, 1)

	friction = 0.1
	drift = generator("vector", list(-0.2, -0.3), list(0.2, 0.3))
	color = "white"

/particles/fire_sparks
	width = 500
	height = 500
	count = 3000
	spawning = 1
	lifespan = 40
	fade = 20
	position = generator("circle", -10, 10, NORMAL_RAND)
	gravity = list(0, 1)

	friction = 0.25
	drift = generator("sphere", 0, 2)
	gradient = list(0, "yellow", 1, "red")
	color = "yellow"

/particles/drill_sparks
	width = 124
	height = 124
	count = 1600
	spawning = 4
	lifespan = 1.5 SECONDS
	fade = 0.25 SECONDS
	position = generator("circle", -3, 3, NORMAL_RAND)
	gravity = list(0, -1)
	velocity = generator("box", list(-3, 2, 0), list(3, 12, 5), NORMAL_RAND)
	friction = 0.25
	gradient = list(0, COLOR_WHITE, 1, COLOR_ORANGE)
	color_change = 0.125
	color = 0
	transform = list(1,0,0,0, 0,1,0,0, 0,0,1,1/5, 0,0,0,1)

/particles/flare_sparks
	width = 500
	height = 500
	count = 2000
	spawning = 12
	lifespan = 0.75 SECONDS
	fade = 0.95 SECONDS
	position = generator("circle", -2, 2, NORMAL_RAND)
	velocity = generator("circle", -6, 6, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.4, COLOR_RED)
	color_change = 0.125

/particles/dust
	width = 124
	height = 124
	count = 256
	spawning = 999999 //spawn all instantly
	lifespan = 0.75 SECONDS
	fade = 0.35 SECONDS
	position = generator("box", list(-16, -16), list(16, 16), NORMAL_RAND)
	velocity = generator("circle", -8, 8, NORMAL_RAND)
	friction = 0.125
	color = COLOR_GRAY

/particles/white_night
	width = 1200
	height = 1200
	count = 2500
	spawning = 500
	lifespan = 2 SECONDS
	fade = 1 SECONDS
	position = generator("circle", 42, 54, NORMAL_RAND)
	velocity = generator("circle", -4, 4, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_ORANGE, 0.75, COLOR_RED)
	color_change = 1
	drift = generator("vector", list(-0.1, -0.1), list(0.1, 0.1))

/particles/fragment_note
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "fragment_note"
	width = 96
	height = 96
	count = 30
	spawning = 1
	lifespan = 6
	fade = 2
	velocity = generator("circle", 10, 15)
	friction = 0.25

/particles/fragment_song
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = list("fragment_song_small","fragment_song_medium","fragment_song_large")
	width = 128
	height = 128
	count = 30
	spawning = 2
	lifespan = 12
	fadein = 6
	fade = 6
	velocity = generator("circle", -5, 5, NORMAL_RAND)
	rotation = generator("num", -120, 120)
	spin = generator("num", -20, 20)
	grow = list(0.2,0.2)
	friction = 0.6

/particles/singing_note
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = list("singing_note_1","singing_note_2","singing_note_3","singing_note_4")
	width = 96
	height = 96
	count = 12
	spawning = 0.6
	lifespan = 8
	fade = 4
	position = list(18,23)
	velocity = generator("box", list(-10, 18), list(10, 20))
	rotation = generator("num", -30, 50, NORMAL_RAND)
	friction = 0.5

/particles/singing_note_broken
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = list("singing_note_1_broken","singing_note_2_broken","singing_note_3_broken","singing_note_4_broken")
	width = 96
	height = 96
	count = 12
	spawning = 0.5
	lifespan = 8
	fade = 4
	position = list(8,12)
	velocity = generator("box", list(-7, 15), list(7, 15))
	rotation = generator("num", -50, 70)
	friction = 0.5

/particles/singing_grind
	icon = 'ModularTegustation/Teguicons/lc13_effects.dmi'
	icon_state = "singing_grind"
	width = 48
	height = 96
	count = 2
	position
	spawning = 0.5
	lifespan = 3
	fade = 1
	velocity = list(0,6)
	friction = 0.3

/particles/singing_blood
	width = 128
	height = 128
	count = 200
	spawning = 8
	lifespan = 6
	fade = 4
	position = generator("vector", list(-2,7), list(23,7))
	velocity = generator("circle", -5, 10)
	color = COLOR_RED
	gravity = list(0, -4)
	friction = 0.5

/* Particle emitter objects */

/obj/particle_emitter
	name = ""
	anchored = TRUE
	mouse_opacity = 0
	appearance_flags = PIXEL_SCALE

/obj/particle_emitter/Initialize(mapload, time, _color)
	. = ..()
	if(time > 0)
		QDEL_IN(src, time)
	color = _color

/obj/particle_emitter/proc/enable(on)
	if(on)
		particles.spawning = initial(particles.spawning)
	else
		particles.spawning = 0

/obj/particle_emitter/proc/fadeout()
	enable(FALSE)
	if(istype(particles))
		QDEL_IN(src, initial(particles.lifespan))
	else
		QDEL_NULL(src)

/obj/particle_emitter/sparks
	particles = new/particles/drill_sparks
	plane = ABOVE_LIGHTING_PLANE

/obj/particle_emitter/sparks/setDir(dir)
	..()
	var/list/min
	var/list/max
	if(dir == NORTH)
		min = list(-3, 2, -1)
		max = list(3, 12, 0)
	else if(dir == SOUTH)
		min = list(-3, 2, 0)
		max = list(3, 12, 1)
	else if(dir == EAST)
		min = list(1, 3, 0)
		max = list(6, 12, 0)
	else
		min = list(-1, 3, 0)
		max = list(-6, 12, 0)

	particles.velocity = generator("box", min, max, NORMAL_RAND)

/obj/particle_emitter/smoke
	layer = FIRE_LAYER
	particles = new/particles/smoke

/obj/particle_emitter/smoke/Initialize(mapload, time, _color)
	. = ..()
	filters = filter(type="blur", size=1.5)

/obj/particle_emitter/fragment_note
	layer = MOB_LAYER+1
	particles = new/particles/fragment_note

/obj/particle_emitter/fragment_song
	layer = MOB_LAYER+1
	particles = new/particles/fragment_song

/obj/particle_emitter/singing_note
	layer = MOB_LAYER+1
	particles = new/particles/singing_note

/obj/particle_emitter/singing_note_broken
	layer = MOB_LAYER+1
	particles = new/particles/singing_note_broken

/obj/particle_emitter/singing_grind
	layer = MOB_LAYER+1
	particles = new/particles/singing_grind

/obj/particle_emitter/singing_blood
	layer = MOB_LAYER+1
	particles = new/particles/singing_blood
