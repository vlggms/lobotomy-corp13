/obj/structure/toolabnormality/mirror
	name = "mirror of adjustment"
	desc = "A black mirror. Best not to look too long into it."
	icon_state = "mirror"
	var/list/stats = list(FORTITUDE_ATTRIBUTE,
			PRUDENCE_ATTRIBUTE,
			TEMPERANCE_ATTRIBUTE,
			JUSTICE_ATTRIBUTE)
	var/list/gazers = list()

/obj/structure/toolabnormality/mirror/attack_hand(mob/living/carbon/human/user)
	..()
	var/stat_total = 0	//start from nothing.
	for(var/attribute in stats)
		stat_total += get_raw_level(user, attribute)
	if(stat_total > 80)	//Don't go under 80, I want to keep this clean and keep it from
		if(user in gazers)	//Why are you rerolling your stats twice!?
			stat_total -= 20
			if(stat_total < 80)//Make sure that you ALWAYS have 20s in all stats.
				stat_total = 80
		stat_total -= 80// we're guaranteed to get 20 in all stats, at least.
		user.adjust_all_attribute_levels(-130)	//Set to 0s

		var/list/stat_to_change = stats		//which stats we've already done
		for(var/i = 1 to 3)
			var/attribute = pick(stat_to_change)
			var/addition = rand(stat_total)
			if(addition > 110)
				addition = 110
			stat_total -= addition
			addition +=20
			user.adjust_attribute_level(attribute, addition)
			stat_to_change -= attribute

		//Last stat gets the rest of the gamerpoints
		for(var/last in stat_to_change)
			stat_total +=20
			user.adjust_attribute_level(last, stat_total)

		gazers += user
		to_chat(user, "<span class='userdanger'>You gaze into the mirror.</span>")

	else
		to_chat(user, "<span class='userdanger'>You are not strong enough to use the mirror!</span>")
