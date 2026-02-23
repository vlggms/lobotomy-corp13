//Small visuals used for indicating damage or healing or similar
//Stuntime visual for when you're stunned by your weapon, so you know what happened.
/obj/effect/temp_visual/weapon_stun
	icon = 'ModularTegustation/Teguicons/lc13_coloreffect.dmi'
	icon_state = "stun"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 9

/obj/effect/temp_visual/weapon_stun/tremorburst
	icon_state = "tremorburst"

/obj/effect/temp_visual/area_heal
	name = "large healing aura"
	desc = "A large area of restorative energy."
	icon = 'ModularTegustation/Teguicons/lc13_effects64x64.dmi'
	icon_state = "healarea_fade"
	duration = 15
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	alpha = 200
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

//These Are Legacy versions. I'm trying out porting the flick ones - Crabby
/obj/effect/temp_visual/healing
	icon = 'ModularTegustation/Teguicons/lc13_coloreffect.dmi'
	icon_state = "healing"
	layer = EMISSIVE_LAYER
	//duration based on the frames in the sprites.
	duration = 8

/obj/effect/temp_visual/healing/Initialize(mapload)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/obj/effect/temp_visual/healing/no_dam
	icon_state = "no_dam"

/obj/effect/temp_visual/healing/charge
	icon_state = "charge"

/obj/effect/temp_visual/damage_effect
	icon = 'ModularTegustation/Teguicons/lc13_coloreffect.dmi'
	layer = EMISSIVE_LAYER
	duration = 12
	var/style_text_color = "#FFFFFF"

/obj/effect/temp_visual/damage_effect/Initialize(mapload, damage_count)
	icon_state = "[icon_state][rand(1,2)]"
	pixel_x = rand(-16, 8)
	pixel_y = rand(-9, 9)
	if(isnum(damage_count))
		maptext_x = 22
		maptext_y = 10
		maptext_height = 32
		maptext_width = 32
		var/style = "font-family: 'Better VCR'; font-size: 5px; -dm-text-outline: 1px black; color: [style_text_color];"
		maptext = "<span style=\"[style]\">[round(damage_count)]</span>"
	animate(src, pixel_x = pixel_x + rand(1, 4), pixel_y = pixel_y + 10, alpha = 0, time = rand(8, 12), easing = SINE_EASING)
	return ..()

/obj/effect/temp_visual/damage_effect/red
	icon_state = "dam_red"
	style_text_color = "#FF0000"

/obj/effect/temp_visual/damage_effect/white
	icon_state = "dam_white"
	style_text_color = "#DEDDB6"

/obj/effect/temp_visual/damage_effect/black
	icon_state = "dam_black"
	style_text_color = "#8A4091"

/obj/effect/temp_visual/damage_effect/pale
	icon_state = "dam_pale"
	style_text_color = "#80C8ff"

/obj/effect/temp_visual/damage_effect/burn
	icon_state = "dam_burn"
	style_text_color = "#F2961D"

/obj/effect/temp_visual/damage_effect/tox
	icon_state = "dam_tox"
	style_text_color = "#1A8709"

/obj/effect/temp_visual/damage_effect/bleed
	icon_state = "dam_bleed"
	style_text_color = "#FF0000"

/obj/effect/temp_visual/damage_effect/tremor
	icon_state = "tremor"
	style_text_color = "#D0E329"

/obj/effect/temp_visual/damage_effect/sinking
	icon_state = "sinking"
	style_text_color = "#298CE3"

/obj/effect/temp_visual/damage_effect/rupture
	icon_state = "rupture"
	style_text_color = "#80C8ff"

//Creates a damage pop up
/atom/proc/DamageEffect(amount, damtype, scale = 1, extratext = "")
	var/effect_name
	var/text_color = "#FFFFFF"
	switch(damtype)
		if(RED_DAMAGE, BRUTE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE, FIRE, TOX)
			if(!amount)
				return HealingEffect("no_dam", scale)
			if(amount < 0)
				return HealingEffect("healing", scale)
		if(RED_DAMAGE, BRUTE)
			effect_name = "dam_red"
			text_color = "#FF0000"
		if(WHITE_DAMAGE)
			effect_name = "dam_white"
			text_color = "#DEDDB6"
		if(BLACK_DAMAGE)
			effect_name = "dam_black"
			text_color = "#8A4091"
		if(PALE_DAMAGE)
			effect_name = "dam_pale"
			text_color = "#80C8ff"
		if(FIRE)
			effect_name = "dam_burn"
			text_color = "#F2961D"
		if(TOX)
			effect_name = "dam_tox"
			text_color = "#FF0000"
		//Some Other non damage effects
	if(!effect_name)
		return null
	effect_name += "[rand(1,2)]"
	var/image/dam_effect = image('ModularTegustation/Teguicons/lc13_coloreffect.dmi', get_turf(src), effect_name, src.layer + 0.1)
	dam_effect.pixel_x = rand(-12, 12)
	dam_effect.pixel_y = rand(-9, 0)
	dam_effect.plane = GAME_PLANE
	dam_effect.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	if(amount)
		dam_effect.pixel_y = rand(-9, 9)
		dam_effect.pixel_x = rand(-16, 8)// Move it a bit more to the side to make way for text
		if(isnum(amount))
			dam_effect.maptext_x = 22
			dam_effect.maptext_y = 10
			dam_effect.maptext_height = 32
			dam_effect.maptext_width = 32
			var/style = "font-family: 'Better VCR'; font-size: 5px; -dm-text-outline: 1px black; color: [text_color];"
			dam_effect.maptext = "<span style=\"[style]\">[round(amount, 0.1)][extratext]</span>"
		animate(dam_effect, pixel_x = pixel_x + rand(1, 4), pixel_y = pixel_y + 10, alpha = 0, time = rand(8, 12), easing = SINE_EASING)
	if(scale != 1)
		dam_effect.transform *= scale
	if(typesof(src, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = src
		if(length(H.projectile_blockers) > 0)
			dam_effect.pixel_x += rand(-H.occupied_tiles_left_current * 32, H.occupied_tiles_right_current * 32)
			dam_effect.pixel_y += rand(-H.occupied_tiles_down_current * 32, H.occupied_tiles_up_current * 32)
	flick_overlay(dam_effect, GLOB.clients, 8)
	return dam_effect

//Creates a healing/sanity/no effect and charge effect
/atom/proc/HealingEffect(type, scale = 1)
	var/effect_name
	switch(type)
		if("healing")
			effect_name = "healing"
		if("sanity")
			effect_name = "sanity"
		if("charge")
			effect_name = "charge"
		if("no_dam")
			effect_name = "no_dam"
	if(!effect_name)
		return null
	var/image/heal_effect = image('ModularTegustation/Teguicons/lc13_coloreffect.dmi', get_turf(src), effect_name, src.layer + 0.1)
	heal_effect.pixel_x = rand(-12, 12)
	heal_effect.pixel_y = rand(-9, 0)
	heal_effect.plane = GAME_PLANE
	heal_effect.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	if(scale != 1)
		heal_effect.transform *= scale
	flick_overlay(heal_effect, GLOB.clients, 8)
	return heal_effect

