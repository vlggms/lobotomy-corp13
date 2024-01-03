
/obj/effect/floating_text
	name = "floating_text"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/floating_text/Initialize()
	..()
	return INITIALIZE_HINT_NORMAL


/obj/effect/floating_text/proc/setup_floating_text(target_text)
	src.maptext = MAPTEXT(target_text)
	src.maptext_width = 256
	src.maptext_height = 256

/**
* This Global Proc creates a floating_text effect, fills the contents in via the params, animates it, and sets it to be QDEL
*
* Arguments:
* * target_loc - target location, more than likely a turf or the other things .loc
* * postcalc_damage_number_or_str - a number or string to be displayed in the second half of the text
* * damage_type_str - A string for damage type to automate placing color on it
* * damage_multiplier_percentage_number - a calculation of the total resistance percentage. Starts with 100 then everything is multiplied after in percentage (EX: 100 * 0.15 * 0.20 * 1 * 0.75)
**/
/proc/ez_dmg_numbers_text(target_loc, postcalc_damage_number_or_str, damage_type_str, damage_multiplier_percentage_number)
	var/obj/effect/floating_text/target_floating_text_effect = new(target_loc)
	var/style_text_color = ""
	var/defense_descriptor_string = "ERROR"

	target_floating_text_effect.plane = OPTIONAL_EXTRA_VISUAL_EFFECTS_PLANE

	target_floating_text_effect.pixel_x = rand(-2, 25)
	target_floating_text_effect.pixel_y = 30

	target_floating_text_effect.maptext_height = 128 //32x4
	target_floating_text_effect.maptext_width = 128

	switch(damage_type_str)
		if(RED_DAMAGE)
			target_floating_text_effect.icon = 'icons/effects/RedDamageTypeIcon.png'
			style_text_color = "#FF0000"
		if(WHITE_DAMAGE)
			target_floating_text_effect.icon = 'icons/effects/UnknownDamageTypeIcon.png'
			style_text_color = "#deddb6"
		if(BLACK_DAMAGE)
			target_floating_text_effect.icon = 'icons/effects/BlackDamageTypeIcon.png'
			style_text_color = "#8a4091"
		if(PALE_DAMAGE)
			target_floating_text_effect.icon = 'icons/effects/PaleDamageTypeIcon.png'
			style_text_color = "#80c8ff"
		else // is this wise? who knows, but you can get a readout for it. who knows you might see it in unexpected places (Or it will be removed because theres too much of it)
			target_floating_text_effect.icon = 'icons/effects/UnknownDamageTypeIcon.png'
			style_text_color = "#ffffff"

	// Spaces at the end of each lol
	switch(damage_multiplier_percentage_number)
		if(0 to 0)
			defense_descriptor_string = "Immune "
		if(100 to 100) // Normal display nothing
			defense_descriptor_string = ""
		if(-INFINITY to 0)
			defense_descriptor_string = "Absorb "
			postcalc_damage_number_or_str = abs(postcalc_damage_number_or_str) // This comes in as a negative
		if(0 to 50)
			defense_descriptor_string = "Resist "
		if(50 to 100)
			defense_descriptor_string = "Endure "
		if(100 to 150)
			defense_descriptor_string = "Weak "
		if(200 to INFINITY)
			defense_descriptor_string = "Fatal "
		if(150 to 200)
			defense_descriptor_string = "Vulnerable "

	//to_chat(world, "postcalc_damage_number_or_str: [postcalc_damage_number_or_str], damage_type_str: [damage_type_str], damage_percentage:[damage_multiplier_percentage_number]")

	var/style = "font-family: 'Small Fonts'; font-size: 6px; -dm-text-outline: 1px black; color: [style_text_color];"
	target_floating_text_effect.maptext = "<span style=\"[style]\">[defense_descriptor_string][postcalc_damage_number_or_str]</span>"

	animate(target_floating_text_effect, pixel_y = target_floating_text_effect.pixel_y + 20, alpha = 0, time = 10, easing = SINE_EASING)

	QDEL_IN(target_floating_text_effect, 2 SECONDS)
