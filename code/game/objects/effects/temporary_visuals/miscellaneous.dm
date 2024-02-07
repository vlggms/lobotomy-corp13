//unsorted miscellaneous temporary visuals
/obj/effect/temp_visual/dir_setting/bloodsplatter
	icon = 'icons/effects/blood.dmi'
	duration = 5
	randomdir = FALSE
	layer = BELOW_MOB_LAYER
	var/splatter_type = "splatter"

/obj/effect/temp_visual/dir_setting/bloodsplatter/Initialize(mapload, set_dir)
	if(ISDIAGONALDIR(set_dir))
		icon_state = "[splatter_type][pick(1, 2, 6)]"
	else
		icon_state = "[splatter_type][pick(3, 4, 5)]"
	. = ..()
	var/target_pixel_x = 0
	var/target_pixel_y = 0
	switch(set_dir)
		if(NORTH)
			target_pixel_y = 16
		if(SOUTH)
			target_pixel_y = -16
			layer = ABOVE_MOB_LAYER
		if(EAST)
			target_pixel_x = 16
		if(WEST)
			target_pixel_x = -16
		if(NORTHEAST)
			target_pixel_x = 16
			target_pixel_y = 16
		if(NORTHWEST)
			target_pixel_x = -16
			target_pixel_y = 16
		if(SOUTHEAST)
			target_pixel_x = 16
			target_pixel_y = -16
			layer = ABOVE_MOB_LAYER
		if(SOUTHWEST)
			target_pixel_x = -16
			target_pixel_y = -16
			layer = ABOVE_MOB_LAYER
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)

/obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter
	splatter_type = "xsplatter"

/obj/effect/temp_visual/dir_setting/speedbike_trail
	name = "speedbike trails"
	icon_state = "ion_fade"
	layer = BELOW_MOB_LAYER
	duration = 10
	randomdir = 0

/obj/effect/temp_visual/dir_setting/firing_effect
	icon = 'icons/effects/effects.dmi'
	icon_state = "firing_effect"
	duration = 2

/obj/effect/temp_visual/dir_setting/firing_effect/setDir(newdir)
	switch(newdir)
		if(NORTH)
			layer = BELOW_MOB_LAYER
			pixel_x = rand(-3,3)
			pixel_y = rand(4,6)
		if(SOUTH)
			pixel_x = rand(-3,3)
			pixel_y = rand(-1,1)
		else
			pixel_x = rand(-1,1)
			pixel_y = rand(-1,1)
	..()

/obj/effect/temp_visual/dir_setting/firing_effect/energy
	icon_state = "firing_effect_energy"
	duration = 3

/obj/effect/temp_visual/dir_setting/firing_effect/magic
	icon_state = "shieldsparkles"
	duration = 3

/obj/effect/temp_visual/dir_setting/ninja
	name = "ninja shadow"
	icon = 'icons/mob/mob.dmi'
	icon_state = "uncloak"
	duration = 9

/obj/effect/temp_visual/dir_setting/ninja/cloak
	icon_state = "cloak"

/obj/effect/temp_visual/dir_setting/ninja/shadow
	icon_state = "shadow"

/obj/effect/temp_visual/dir_setting/ninja/phase
	name = "energy"
	icon_state = "phasein"

/obj/effect/temp_visual/dir_setting/ninja/phase/out
	icon_state = "phaseout"

/obj/effect/temp_visual/dir_setting/wraith
	name = "shadow"
	icon = 'icons/mob/mob.dmi'
	icon_state = "phase_shift2"
	duration = 6

/obj/effect/temp_visual/dir_setting/wraith/angelic
	icon_state = "phase_shift2_angelic"

/obj/effect/temp_visual/dir_setting/wraith/out
	icon_state = "phase_shift"

/obj/effect/temp_visual/dir_setting/wraith/out/angelic
	icon_state = "phase_shift_angelic"

/obj/effect/temp_visual/dir_setting/tailsweep
	icon_state = "tailsweep"
	duration = 4

/obj/effect/temp_visual/dir_setting/curse
	icon_state = "curse"
	duration = 32
	var/fades = TRUE

/obj/effect/temp_visual/dir_setting/curse/Initialize(mapload, set_dir)
	. = ..()
	if(fades)
		animate(src, alpha = 0, time = 32)

/obj/effect/temp_visual/dir_setting/curse/blob
	icon_state = "curseblob"

/obj/effect/temp_visual/dir_setting/curse/grasp_portal
	icon = 'icons/effects/64x64.dmi'
	layer = LARGE_MOB_LAYER
	pixel_y = -16
	pixel_x = -16
	duration = 32
	fades = FALSE

/obj/effect/temp_visual/dir_setting/curse/grasp_portal/fading
	duration = 32
	fades = TRUE

/obj/effect/temp_visual/dir_setting/curse/hand
	icon_state = "cursehand"


/obj/effect/temp_visual/bsa_splash
	name = "\improper Bluespace energy wave"
	desc = "A massive, rippling wave of bluepace energy, all rapidly exhausting itself the moment it leaves the concentrated beam of light."
	icon = 'icons/effects/beam_splash.dmi'
	icon_state = "beam_splash_l"
	layer = ABOVE_ALL_MOB_LAYER
	pixel_y = -16
	duration = 50

/obj/effect/temp_visual/bsa_splash/Initialize(mapload, dir)
	. = ..()
	switch(dir)
		if(WEST)
			icon_state = "beam_splash_w"
		if(EAST)
			icon_state = "beam_splash_e"

/obj/effect/temp_visual/wizard
	name = "water"
	icon = 'icons/mob/mob.dmi'
	icon_state = "reappear"
	duration = 5

/obj/effect/temp_visual/wizard/out
	icon_state = "liquify"
	duration = 12

/obj/effect/temp_visual/monkeyify
	icon = 'icons/mob/mob.dmi'
	icon_state = "h2monkey"
	duration = 22

/obj/effect/temp_visual/monkeyify/humanify
	icon_state = "monkey2h"

/obj/effect/temp_visual/borgflash
	icon = 'icons/mob/mob.dmi'
	icon_state = "blspell"
	duration = 5

/obj/effect/temp_visual/guardian
	randomdir = 0

/obj/effect/temp_visual/guardian/phase
	duration = 5
	icon_state = "phasein"

/obj/effect/temp_visual/guardian/phase/out
	icon_state = "phaseout"

/obj/effect/temp_visual/decoy
	desc = "It's a decoy!"
	duration = 15

/obj/effect/temp_visual/decoy/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	alpha = initial(alpha)
	if(mimiced_atom)
		name = mimiced_atom.name
		appearance = mimiced_atom.appearance
		setDir(mimiced_atom.dir)
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/decoy/fading/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/decoy/fading/threesecond
	duration = 40

/obj/effect/temp_visual/decoy/fading/fivesecond
	duration = 50

/obj/effect/temp_visual/decoy/fading/halfsecond
	duration = 5

/obj/effect/temp_visual/small_smoke
	icon_state = "smoke"
	duration = 50

/obj/effect/temp_visual/small_smoke/Initialize(mapload)
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/small_smoke/fixer_w
	name = "mental smoke"

/obj/effect/temp_visual/small_smoke/second
	duration = 10

/obj/effect/temp_visual/small_smoke/second/fruit
	color = LIGHT_COLOR_PURPLE

/obj/effect/temp_visual/small_smoke/halfsecond
	duration = 5

/obj/effect/temp_visual/small_smoke/halfsecond/green
	color = COLOR_GREEN

/obj/effect/temp_visual/fire
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	light_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	duration = 10

/obj/effect/temp_visual/fire/fast
	icon_state = "1"
	duration = 5

/obj/effect/temp_visual/sparks
	icon_state = "sparks"
	duration = 5

/obj/effect/temp_visual/sparks/quantum
	icon_state = "quantum_sparks"

/obj/effect/temp_visual/revenant
	name = "spooky lights"
	icon_state = "purplesparkles"

/obj/effect/temp_visual/revenant/cracks
	name = "glowing cracks"
	icon_state = "purplecrack"
	duration = 6

/obj/effect/temp_visual/gravpush
	name = "gravity wave"
	icon_state = "shieldsparkles"
	duration = 5

/obj/effect/temp_visual/telekinesis
	name = "telekinetic force"
	icon_state = "empdisable"
	duration = 5

/obj/effect/temp_visual/emp
	name = "emp sparks"
	icon_state = "empdisable"

/obj/effect/temp_visual/emp/pulse
	name = "emp pulse"
	icon_state = "emppulse"
	duration = 8
	randomdir = 0

/obj/effect/temp_visual/bluespace_fissure
	name = "bluespace fissure"
	icon_state = "bluestream_fade"
	duration = 9

/obj/effect/temp_visual/gib_animation
	icon = 'icons/mob/mob.dmi'
	duration = 15

/obj/effect/temp_visual/gib_animation/Initialize(mapload, gib_icon)
	icon_state = gib_icon // Needs to be before ..() so icon is correct
	. = ..()

/obj/effect/temp_visual/gib_animation/animal
	icon = 'icons/mob/animal.dmi'

/obj/effect/temp_visual/dust_animation
	icon = 'icons/mob/mob.dmi'
	duration = 15

/obj/effect/temp_visual/dust_animation/Initialize(mapload, dust_icon)
	icon_state = dust_icon // Before ..() so the correct icon is flick()'d
	. = ..()

/obj/effect/temp_visual/mummy_animation
	icon = 'icons/mob/mob.dmi'
	icon_state = "mummy_revive"
	duration = 20

/obj/effect/temp_visual/heal //color is white by default, set to whatever is needed
	name = "healing glow"
	icon_state = "heal"
	duration = 15

/obj/effect/temp_visual/heal/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/obj/effect/temp_visual/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 4

/obj/effect/temp_visual/explosion
	name = "explosion"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	pixel_x = -32
	pixel_y = -32
	duration = 8

/obj/effect/temp_visual/explosion/fast
	icon_state = "explosionfast"
	duration = 4

/obj/effect/temp_visual/blob
	name = "blob"
	icon_state = "blob_attack"
	alpha = 140
	randomdir = 0
	duration = 6

/obj/effect/temp_visual/desynchronizer
	name = "desynchronizer field"
	icon_state = "chronofield"
	duration = 3

/obj/effect/temp_visual/impact_effect
	icon_state = "impact_bullet"
	duration = 5

/obj/effect/temp_visual/impact_effect/Initialize(mapload, x, y)
	pixel_x = x
	pixel_y = y
	return ..()

/obj/effect/temp_visual/impact_effect/red_laser
	icon_state = "impact_laser"
	duration = 4

/obj/effect/temp_visual/impact_effect/red_laser/wall
	icon_state = "impact_laser_wall"
	duration = 10

/obj/effect/temp_visual/impact_effect/blue_laser
	icon_state = "impact_laser_blue"
	duration = 4

/obj/effect/temp_visual/impact_effect/green_laser
	icon_state = "impact_laser_green"
	duration = 4

/obj/effect/temp_visual/impact_effect/purple_laser
	icon_state = "impact_laser_purple"
	duration = 4

/obj/effect/temp_visual/impact_effect/white_laser
	icon_state = "impact_laser_white"
	duration = 4

/obj/effect/temp_visual/impact_effect/shrink
	icon_state = "m_shield"
	duration = 10

/obj/effect/temp_visual/impact_effect/ion
	icon_state = "shieldsparkles"
	duration = 6

/obj/effect/temp_visual/impact_effect/energy
	icon_state = "impact_energy"
	duration = 6

/obj/effect/temp_visual/impact_effect/neurotoxin
	icon_state = "impact_neurotoxin"

/obj/effect/temp_visual/heart
	name = "heart"
	icon = 'icons/mob/animal.dmi'
	icon_state = "heart"
	duration = 25

/obj/effect/temp_visual/heart/Initialize(mapload)
	. = ..()
	pixel_x = rand(-4,4)
	pixel_y = rand(-4,4)
	animate(src, pixel_y = pixel_y + 32, alpha = 0, time = 25)

/obj/effect/temp_visual/annoyed
	name = "annoyed"
	icon = 'icons/effects/effects.dmi'
	icon_state = "annoyed"
	duration = 25

/obj/effect/temp_visual/annoyed/Initialize(mapload)
	. = ..()
	pixel_x = rand(-4,0)
	pixel_y = rand(8,12)
	animate(src, pixel_y = pixel_y + 16, alpha = 0, time = duration)

/obj/effect/temp_visual/love_heart
	name = "love heart"
	icon = 'icons/effects/effects.dmi'
	icon_state = "heart"
	duration = 25

/obj/effect/temp_visual/love_heart/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	animate(src, pixel_y = pixel_y + 32, alpha = 0, time = duration)

/obj/effect/temp_visual/love_heart/invisible
	icon_state = null

/obj/effect/temp_visual/love_heart/invisible/Initialize(mapload, mob/seer)
	. = ..()
	var/image/I = image(icon = 'icons/effects/effects.dmi', icon_state = "heart", layer = ABOVE_MOB_LAYER, loc = src)
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/one_person, "heart", I, seer)
	I.alpha = 255
	I.appearance_flags = RESET_ALPHA
	animate(I, alpha = 0, time = duration)

/obj/effect/temp_visual/bleed
	name = "bleed"
	icon = 'icons/effects/bleed.dmi'
	icon_state = "bleed0"
	duration = 10
	var/shrink = TRUE

/obj/effect/temp_visual/bleed/Initialize(mapload, atom/size_calc_target)
	. = ..()
	var/size_matrix = matrix()
	if(size_calc_target)
		layer = size_calc_target.layer + 0.01
		var/icon/I = icon(size_calc_target.icon, size_calc_target.icon_state, size_calc_target.dir)
		size_matrix = matrix() * (I.Height()/world.icon_size)
		transform = size_matrix //scale the bleed overlay's size based on the target's icon size
	var/matrix/M = transform
	if(shrink)
		M = size_matrix*0.1
	else
		M = size_matrix*2
	animate(src, alpha = 20, transform = M, time = duration, flags = ANIMATION_PARALLEL)

/obj/effect/temp_visual/bleed/explode
	icon_state = "bleed10"
	duration = 12
	shrink = FALSE

/obj/effect/temp_visual/warp_cube
	duration = 5
	var/outgoing = TRUE

/obj/effect/temp_visual/warp_cube/Initialize(mapload, atom/teleporting_atom, warp_color, new_outgoing)
	. = ..()
	if(teleporting_atom)
		outgoing = new_outgoing
		appearance = teleporting_atom.appearance
		setDir(teleporting_atom.dir)
		if(warp_color)
			color = list(warp_color, warp_color, warp_color, list(0,0,0))
			set_light(1.4, 1, warp_color)
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		var/matrix/skew = transform
		skew = skew.Turn(180)
		skew = skew.Interpolate(transform, 0.5)
		if(!outgoing)
			transform = skew * 2
			skew = teleporting_atom.transform
			alpha = 0
			animate(src, alpha = teleporting_atom.alpha, transform = skew, time = duration)
		else
			skew *= 2
			animate(src, alpha = 0, transform = skew, time = duration)
	else
		return INITIALIZE_HINT_QDEL

/obj/effect/temp_visual/cart_space
	icon_state = "launchpad_launch"
	duration = 2 SECONDS

/obj/effect/temp_visual/cart_space/bad
	icon_state = "launchpad_pull"
	duration = 2 SECONDS

/obj/effect/constructing_effect
	icon = 'icons/effects/effects_rcd.dmi'
	icon_state = ""
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/status = 0
	var/delay = 0

/obj/effect/constructing_effect/Initialize(mapload, rcd_delay, rcd_status)
	. = ..()
	status = rcd_status
	delay = rcd_delay
	if (status == RCD_DECONSTRUCT)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 11)
		delay -= 11
		icon_state = "rcd_end_reverse"
	else
		update_icon()

/obj/effect/constructing_effect/update_icon_state()
	icon_state = "rcd"
	if (delay < 10)
		icon_state += "_shortest"
	else if (delay < 20)
		icon_state += "_shorter"
	else if (delay < 37)
		icon_state += "_short"
	if (status == RCD_DECONSTRUCT)
		icon_state += "_reverse"

/obj/effect/constructing_effect/proc/end_animation()
	if (status == RCD_DECONSTRUCT)
		qdel(src)
	else
		icon_state = "rcd_end"
		addtimer(CALLBACK(src, PROC_REF(end)), 15)

/obj/effect/constructing_effect/proc/end()
	qdel(src)

//LC13 EFFECTS

/obj/effect/temp_visual/bee_gas
	icon_state = "mustard"
	alpha = 0
	duration = 50

/obj/effect/temp_visual/bee_gas/Initialize()
	. = ..()
	animate(src, alpha = rand(125,200), time = 5)
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 5)

/obj/effect/temp_visual/bee_gas/proc/fade_out()
	animate(src, alpha = 0, time = duration-5)

// White colored sparkles. Just modify color variable as needed
/obj/effect/temp_visual/sparkles
	icon_state = "sparkles"
	duration = 10

/obj/effect/temp_visual/sparkles/red
	color = COLOR_RED

/obj/effect/temp_visual/sparkles/purple
	color = COLOR_PURPLE

/obj/effect/temp_visual/sparkles/sanity_heal
	color = "#42f2f5"
	duration = 2

/obj/effect/temp_visual/judgement
	icon_state = "judge"
	duration = 20

/obj/effect/temp_visual/judgement/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 10)

/obj/effect/temp_visual/judgement/proc/fade_out()
	animate(src, alpha = 0, time = duration-10)

/obj/effect/temp_visual/judgement/still
	icon_state = "judge_still"
	duration = 20

/obj/effect/temp_visual/whitelake
	icon_state = "whitelake"
	duration = 20

/obj/effect/temp_visual/thirteen
	icon_state = "thirteen"
	duration = 20

/obj/effect/temp_visual/paradise_attack
	icon_state = "paradise_attack"
	duration = 10

/obj/effect/temp_visual/paradise_attack/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/water_waves
	name = "ocean"
	icon = 'icons/turf/floors.dmi'
	icon_state = "riverwater_motion"
	layer = ABOVE_ALL_MOB_LAYER
	density = TRUE
	duration = 18 SECONDS
	alpha = 0

/obj/effect/temp_visual/water_waves/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 10)
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 10 SECONDS)

/obj/effect/temp_visual/water_waves/proc/fade_out()
	animate(src, alpha = 0, time = (duration - 10 SECONDS))

/obj/effect/temp_visual/justitia_effect
	name = "slash"
	icon_state = "bluestream"
	duration = 5

/obj/effect/temp_visual/justitia_effect/Initialize()
	. = ..()
	animate(src, alpha = 0, transform = transform*2, time = 5)

/obj/effect/temp_visual/fragment_song
	name = "sound waves"
	icon_state = "fragment_song"
	duration = 5
	pixel_y = 16
	base_pixel_y = 16

/obj/effect/temp_visual/fragment_song/Initialize()
	. = ..()
	animate(src, alpha = 0, transform = transform*3, time = 5)


/obj/effect/temp_visual/cherry_aura
	name = "petal blizzard"
	icon_state = "cherry_aura"
	duration = 16

/obj/effect/temp_visual/cherry_aura2
	name = "petal blizzard2"
	icon_state = "cherry_aura2"
	duration = 16

/obj/effect/temp_visual/cherry_aura3
	name = "petal blizzard3"
	icon_state = "cherry_aura3"
	duration = 16
/obj/effect/temp_visual/saw_effect
	name = "saw"
	icon_state = "claw"
	duration = 4

/obj/effect/temp_visual/smash_effect
	name = "smash"
	icon_state = "smash"
	duration = 4

/obj/effect/temp_visual/green_noon_reload
	name = "recharging field"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "green_bot_reload_effect"
	layer = BELOW_MOB_LAYER
	pixel_x = -8
	base_pixel_x = -8
	duration = 8

/obj/effect/temp_visual/green_noon_reload/Initialize()
	. = ..()
	animate(src, alpha = 0, transform = transform*1.5, time = duration)

/obj/effect/temp_visual/slice
	name = "slice"
	icon_state = "slice"
	duration = 4

/obj/effect/temp_visual/dir_setting/slash
	name = "slash"
	icon_state = "slash"
	duration = 4

/obj/effect/temp_visual/hatred
	name = "hatred"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "hatred"
	duration = 3 SECONDS

/obj/effect/temp_visual/hatred/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	animate(src, alpha = 0, pixel_z = rand(16, 48), time = duration)

/obj/effect/temp_visual/flesh
	name = "flesh"
	icon = 'icons/turf/floors.dmi'
	icon_state = "flesh0"
	layer = ABOVE_ALL_MOB_LAYER
	density = TRUE
	duration = 8 SECONDS
	alpha = 0

/obj/effect/temp_visual/flesh/Initialize()
	. = ..()
	icon_state = "flesh[rand(0,3)]"
	animate(src, alpha = 255, time = 5)
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 4 SECONDS)

/obj/effect/temp_visual/flesh/proc/fade_out()
	animate(src, alpha = 0, time = (duration - 4 SECONDS))

/obj/effect/temp_visual/black_fixer_ability
	name = "pulse"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "black_fixer"
	pixel_y = 30
	base_pixel_y = 30
	duration = 4
	alpha = 175

/obj/effect/temp_visual/black_fixer_ability/Initialize()
	. = ..()
	animate(src, alpha = 0, transform = transform*4, time = 4)

/obj/effect/temp_visual/censored
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "censored_kill"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 20
	alpha = 0
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -48
	base_pixel_y = -48

/obj/effect/temp_visual/censored/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 2)
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 17)
	for(var/i = 1 to 9)
		addtimer(CALLBACK(src, PROC_REF(shake)), 2*i)

/obj/effect/temp_visual/censored/proc/shake()
	animate(src, pixel_x = base_pixel_x + rand(-4, 4), pixel_y = base_pixel_y + rand(-4, 4), time = 1)

/obj/effect/temp_visual/censored/proc/fade_out()
	animate(src, alpha = 0, time = 2)

/obj/effect/temp_visual/beakbite
	name = "bite"
	icon_state = "bite"
	color = COLOR_RED

/obj/effect/temp_visual/apocaspiral
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	name = "apocaspiral"
	icon_state = "apocalypse_enchant_effect"
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/ambermidnight_hole
	name = "hole"
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	icon_state = "ambermidnight_hole"
	duration = 10 SECONDS
	pixel_x = -96
	base_pixel_x = -96
	pixel_y = -16
	base_pixel_y = -16

/obj/effect/temp_visual/ambermidnight_hole/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/cross
	name = "holy cross"
	icon = 'icons/effects/32x64.dmi'
	icon_state = "cross"
	duration = 2 SECONDS

/obj/effect/temp_visual/cross/fall
	icon_state = "cross_fall"
	duration = 8 SECONDS

/obj/effect/temp_visual/cross/fall/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(FadeOut)), 6 SECONDS)

/obj/effect/temp_visual/cross/fall/proc/FadeOut()
	animate(src, alpha = 0, time = 2 SECONDS)

/obj/effect/temp_visual/markedfordeath
	name = "marked"
	icon_state = "markdeath"
	duration = 13

/obj/effect/temp_visual/mermaid_drowning
	name = "lovely drowning"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "mermaid_drowning"
	duration = 0.5 SECONDS

/obj/effect/temp_visual/mermaid_drowning/Initialize()
	. = ..()
	animate(src, alpha = 0, pixel_y = pixel_y + 5 , time = duration)

/obj/effect/temp_visual/alriune_attack
	name = "petals"
	icon_state = "alriune_attack"
	duration = 6

/obj/effect/temp_visual/alriune_curtain
	name = "flower curtain"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "alriune_curtain"
	duration = 2 SECONDS

/obj/effect/temp_visual/alriune_curtain/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 5)
	addtimer(CALLBACK(src, PROC_REF(FadeOut)), 5)

/obj/effect/temp_visual/alriune_curtain/proc/FadeOut()
	animate(src, alpha = 0, time = 15)

/obj/effect/temp_visual/tbirdlightning
	name = "emp pulse"
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "lightning"
	duration = 8
	randomdir = 0
	pixel_y = 0
	pixel_x = -16

/obj/effect/temp_visual/healing
	icon_state = "healing"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 8

/obj/effect/temp_visual/healing/Initialize(mapload)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/obj/effect/temp_visual/healing/no_dam
	icon_state = "no_dam"

/obj/effect/temp_visual/pale_eye_attack
	name = "pale particles"
	icon_state = "ion_fade_flight"
	duration = 5

/obj/effect/temp_visual/pale_eye_attack/Initialize()
	. = ..()
	animate(src, alpha = 0, time = 5)

/obj/effect/temp_visual/screech
	name = "sound waves"
	icon_state = "screech"
	duration = 5

/obj/effect/temp_visual/screech/Initialize()
	. = ..()
	animate(src, alpha = 0, transform = transform*4, time = 5)

/obj/effect/temp_visual/human_fire
	name = "fire"
	icon = 'icons/mob/onfire.dmi'
	icon_state = "Standing"
	duration = 30

/obj/effect/temp_visual/fire
	name = "fire"
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"

/obj/effect/temp_visual/fire/Initialize()
	. = ..()
	icon_state = pick("1", "2", "3")

/obj/effect/temp_visual/cloud_swirl
	name = "cloud_swirl"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "cloud_swirl"
	duration = 10

/obj/effect/temp_visual/nt_goodbye
	name = "goodbye"
	icon_state = "nt_goodbye"
	duration = 5

/obj/effect/temp_visual/talisman
	name = "talisman"
	icon_state = "talisman"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 10

/obj/effect/temp_visual/talisman/Initialize()
	. = ..()
	animate(src, alpha = 0, time = 10)

/obj/effect/temp_visual/talisman/curse
	icon_state = "curse_talisman"

/obj/effect/temp_visual/turn_book
	name = "scattered pages"
	icon_state = "turn_book"
	duration = 6

/obj/effect/temp_visual/lovetown_shapes
	name = "shapes"
	icon_state = "lovetown_shapes"
	duration = 4

/obj/effect/temp_visual/lovetown_whip
	name = "whip"
	icon_state = "lovetown_whip"
	duration = 4

/obj/effect/temp_visual/galaxy_aura
	name = "galaxy_aura"
	icon_state = "galaxy_aura"
	duration = 6

/obj/effect/temp_visual/human_horizontal_bisect
	icon = 'icons/mob/mob.dmi'
	icon_state = "Hbisected-h"
	duration = 15

/obj/effect/temp_visual/rip_space
	name = "dimensional rift"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "rift"
	duration = 2

/obj/effect/temp_visual/ripped_space
	name = "ripped space"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "ripped_space"
	duration = 3

/obj/effect/temp_visual/rip_space_slash
	name = "ripped space"
	icon_state = "rift"
	duration = 2

/obj/effect/temp_visual/rip_space_slash/Initialize()
	. = ..()
	var/matrix/M = matrix()
	transform = M.Turn(45)
	transform = M.Scale(5, 0.5)
	transform = M.Turn(rand(0, 360))
	animate(src, alpha = 0, transform = transform*2, time = 2)

/obj/effect/temp_visual/mustardgas
	icon_state = "mustard"
	duration = 5

/obj/effect/temp_visual/smash_effect/red
	color = COLOR_RED

/obj/effect/temp_visual/house
	name = "home"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "House"
	duration = 4 SECONDS
	pixel_x = -34
	pixel_z = 128

/obj/effect/temp_visual/house/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(FadeOut)), 2 SECONDS)

/obj/effect/temp_visual/house/proc/FadeOut()
	animate(src, alpha = 0, time = 1 SECONDS)

/obj/effect/temp_visual/v_noon
	name = "violet noon"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "violet_noon_ability"
	pixel_x = -8

/obj/effect/temp_visual/blubbering_smash
	name = "blubbering smash"
	icon_state = "blubbering_smash"
	duration = 5

/obj/effect/temp_visual/onesin_punishment
	name = "heavenly punishment"
	icon_state = "onesin_punishment"
	duration = 6

/obj/effect/temp_visual/onesin_blessing
	name = "heavenly blessing"
	icon_state = "onesin_blessing"
	duration = 12

/obj/effect/temp_visual/distortedform_shift
	name = "shift"
	icon_state = "shift"
	duration = 3

/obj/effect/temp_visual/warning3x3
	name = "warning3x3"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "warning_gray"
	duration = 2 SECONDS
	pixel_x = -32
	pixel_z = -32

/obj/effect/temp_visual/nobody_grab
	name = "goodbye"
	icon_state = "nobody_slash"
	duration = 5

/obj/effect/temp_visual/holo_command
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	light_range = 1.5
	light_power = 0.2
	light_system = MOVABLE_LIGHT
	duration = 150 		//15 Seconds

/obj/effect/temp_visual/holo_command/command_move
	icon_state = "Move_here_wagie"
	light_range = 1
	light_power = 1
	light_color = COLOR_VERY_LIGHT_GRAY

/obj/effect/temp_visual/holo_command/command_warn
	icon_state = "Watch_out_wagie"
	light_color = COLOR_PALE_RED_GRAY

/obj/effect/temp_visual/holo_command/command_guard
	icon_state = "Guard_this_wagie"
	light_color = COLOR_VERY_SOFT_YELLOW

/obj/effect/temp_visual/holo_command/command_heal
	icon_state = "Heal_this_wagie"
	light_color = COLOR_VERY_PALE_LIME_GREEN

/obj/effect/temp_visual/holo_command/command_fight_a
	icon_state = "Fight_this_wagie1"
	light_color = COLOR_PALE_BLUE_GRAY

/obj/effect/temp_visual/holo_command/command_fight_b
	icon_state = "Fight_this_wagie2"
	light_color = COLOR_PALE_BLUE_GRAY
