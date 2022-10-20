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

		for(var/attribute in stats)
			var/addition = 20-rand(40)
			if(user in gazers)	//Why are you rerolling your stats twice!?
				addition -= 10
			user.adjust_attribute_level(attribute, addition)

		gazers += user
		to_chat(user, "<span class='userdanger'>You gaze into the mirror.</span>")

	else
		to_chat(user, "<span class='userdanger'>You are not strong enough to use the mirror!</span>")
