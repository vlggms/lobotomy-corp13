/mob/living/carbon/handle_status_effects()
	. = ..()

	if(mad_shaking)
		do_shaky_animation(mad_shaking)
