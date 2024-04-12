GLOBAL_VAR_INIT(ssd_indicator_overlay, mutable_appearance('ModularTegustation/ssd_indicator/icons/ssd_indicator.dmi', "default0", FLY_LAYER))

/mob/living
	var/ssd_indicator = FALSE
	var/lastclienttime = 0

/mob/living/proc/set_ssd_indicator(var/state)
	if(state == ssd_indicator)
		return
	ssd_indicator = state
	if(ssd_indicator)
		add_overlay(GLOB.ssd_indicator_overlay)
	else
		cut_overlay(GLOB.ssd_indicator_overlay)

/mob/living/Login()
	. = ..()
	set_ssd_indicator(FALSE)

/mob/living/Logout()
	lastclienttime = world.time
	set_ssd_indicator(TRUE)
