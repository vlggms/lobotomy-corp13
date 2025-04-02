/datum/action/cooldown/finalburn
	name = "Final Burn"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "battleready_on"
	cooldown_time = 80 SECONDS
	var/range = 3

/datum/action/cooldown/finalburn/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/fuel in view(range, get_turf(src)))
		if(locate(/obj/structure/turf_fireliu) in fuel.loc)
			//this stuff is important for what youre about to do
			var/burn_holder = fuel.getFireLoss() //storing burn memories of fuel
			fuel.adjustFireLoss(burn_holder)
	owner.visible_message(span_warning("[owner] fans the flames, scorching those within!"))

	StartCooldown()
