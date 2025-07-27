
/// Turns the player into a distortion - Can be used as a reward or a punishment

///////////////////////////////////////////
//God knows this is a mistake. - Cockswain//
///////////////////////////////////////////

/datum/smite/distort
	name = "Distort"

/datum/smite/distort/effect(client/user, mob/living/target)
	. = ..()
	var/instant = FALSE
	var/forced = FALSE
	var/mob/living/simple_animal/hostile/distortion/chosen_distortion = null
	if(istype(target, /mob/living/simple_animal/hostile/distortion))
		switch(tgui_alert(user,"Target is already a distortion. Force distortion again?","GET DISTORTED",list("Yes", "No"), 0))
			if("Yes")
				forced = TRUE
			if("No")
				return

	if(tgui_alert(user,"Choose distortion?","GET DISTORTED",list("Yes", "No"), 0) == "Yes")
		chosen_distortion = tgui_input_list(user,"Which one?","Select a mob", subtypesof(/mob/living/simple_animal/hostile/distortion))

	if(tgui_alert(user,"Instant distortion?","GET DISTORTED",list("Yes", "No"), 0) == "Yes")
		instant = TRUE

	message_admins("[key_name_admin(usr)] is causing [key_name(target)] to distort.") //Extra logging to make ABSOLUTELY SURE that admins see this
	log_admin("[key_name(usr)] caused [key_name(target)] to distort.")
	target.BecomeDistortion(chosen_distortion, instant, forced)
