//Small visuals used for indicating damage or healing or similar
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

/// Creates a damage pop up
/// Amount - the amount of damage
/// Damtype - The damage type or other misc icons
/// Scale - How big the text is
/// Extratext - any extra text stapled on to the end
/// Forced - whether or not it should spawn in certain situations
/atom/proc/DamageEffect(amount, damtype, scale = 1, extratext = "", forced = FALSE)
	var/effect_name
	var/text_color = "#FFFFFF"
	if(amount <= 0 && !forced)
		return
	switch(damtype)
		if(BRUTE)
			effect_name = "rupture"
			text_color = "#80C8ff"
		if(RED_DAMAGE)
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
			text_color = "#1A8709"
	if(!effect_name)
		return null
	effect_name += "[rand(1,2)]"
	var/image/dam_effect = image('ModularTegustation/Teguicons/lc13_coloreffect.dmi', get_turf(src), effect_name, EMISSIVE_LAYER)
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
	if(scale != 1)
		dam_effect.transform *= scale
	animate(dam_effect, pixel_x = dam_effect.pixel_x + rand(1, 4), pixel_y = dam_effect.pixel_y + 10, alpha = 0, time = rand(8, 12), easing = SINE_EASING)
	flick_overlay(dam_effect, GLOB.clients, 12)
	return dam_effect

/// Creates a non standard damage pop up
/// Amount - the amount of damage
/// type - The damage type
/// Scale - How big the text is
/// Extratext - any extra text stapled on to the end
/atom/proc/OtherDamageEffect(amount, type, scale = 1, extratext = "")
	var/effect_name
	var/text_color = "#FFFFFF"
	switch(type)
		if("bleed")
			effect_name = "dam_bleed"
			text_color = "#FF0000"
		if("sinking")
			effect_name = "sinking"
			text_color = "#298CE3"
		if("tremor")
			effect_name = "tremor"
			text_color = "#D0E329"
	if(!effect_name)
		return null
	effect_name += "[rand(1,2)]"
	var/image/other_effect = image('ModularTegustation/Teguicons/lc13_coloreffect.dmi', get_turf(src), effect_name, EMISSIVE_LAYER)
	other_effect.pixel_x = rand(-12, 12)
	other_effect.pixel_y = rand(-9, 0)
	other_effect.plane = GAME_PLANE
	other_effect.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	if(amount)
		other_effect.pixel_y = rand(-9, 9)
		other_effect.pixel_x = rand(-16, 8)// Move it a bit more to the side to make way for text
		if(isnum(amount))
			other_effect.maptext_x = 22
			other_effect.maptext_y = 10
			other_effect.maptext_height = 32
			other_effect.maptext_width = 32
			var/style = "font-family: 'Better VCR'; font-size: 5px; -dm-text-outline: 1px black; color: [text_color];"
			other_effect.maptext = "<span style=\"[style]\">[round(amount, 0.1)][extratext]</span>"
	if(scale != 1)
		other_effect.transform *= scale
	animate(other_effect, pixel_x = other_effect.pixel_x + rand(1, 4), pixel_y = other_effect.pixel_y + 10, alpha = 0, time = rand(8, 12), easing = SINE_EASING)
	flick_overlay(other_effect, GLOB.clients, 12)
	return other_effect

///Creates a healing/sanity/no effect and charge effect
/// Type - The type of icon it uses
/// Scale - How big it is
/atom/proc/HealingEffect(type, scale = 1)
	var/effect_name
	var/variance = FALSE
	switch(type)
		if("healing")
			effect_name = "healing"
			variance = TRUE
		if("sanity")
			effect_name = "sanity"
			variance = TRUE
		if("charge")
			effect_name = "charge"
			variance = TRUE
		if("no_dam")
			effect_name = "no_dam"
			variance = TRUE
		if("stun")
			effect_name = "stun"
		if("tremorburst")
			effect_name = "tremorburst"
	if(!effect_name)
		return null
	var/image/heal_effect = image('ModularTegustation/Teguicons/lc13_coloreffect.dmi', get_turf(src), effect_name, EMISSIVE_LAYER)
	if(variance)
		heal_effect.pixel_x = rand(-12, 12)
		heal_effect.pixel_y = rand(-9, 0)
	heal_effect.plane = GAME_PLANE
	heal_effect.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	if(scale != 1)
		heal_effect.transform *= scale
	flick_overlay(heal_effect, GLOB.clients, 8)
	return heal_effect

//These Are Legacy versions. I ported and expanded the flick versions to be better and more versitle
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
	style_text_color = "#"

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

//Stuntime visual for when you're stunned by your weapon, so you know what happened.
/obj/effect/temp_visual/weapon_stun
	icon = 'ModularTegustation/Teguicons/lc13_coloreffect.dmi'
	icon_state = "stun"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 9

/obj/effect/temp_visual/weapon_stun/tremorburst
	icon_state = "tremorburst"
