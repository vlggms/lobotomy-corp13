/obj/structure/toolabnormality/mirror
	name = "mirror of adjustment"
	desc = "A black mirror. Best not to look too long into it."
	icon_state = "mirror"
	var/list/gazers = list()

/obj/structure/toolabnormality/mirror/attack_hand(mob/living/carbon/human/user)
	. = ..()

	var/stat_total = 0 // Start from nothing.
	for(var/attribute in user.attributes)
		stat_total += get_raw_level(user, attribute)

	if(stat_total <= 80) // Don't go under 80, I want to keep this clean and keep it from
		to_chat(user, span_userdanger("You are not strong enough to use the mirror!"))
		return

	var/total_addition // Just for the message upon using it
	for(var/attribute in user.attributes)
		var/addition = rand(-20, 20)
		if(user in gazers) // Why are you rerolling your stats twice!?
			addition -= 10
		user.adjust_attribute_level(attribute, addition)
		total_addition += addition

	gazers |= user
	to_chat(user, span_userdanger("You gaze into the mirror and feel [total_addition > 0 ? "stronger!" : "weaker..."]"))
