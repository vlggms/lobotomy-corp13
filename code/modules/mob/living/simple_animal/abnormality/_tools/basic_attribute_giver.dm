/obj/structure/toolabnormality/attribute_giver
	name = "all-natural snake oil"
	desc = "A purported panacea that will supposedly treat anything from minor scratches to Alzheimer's."
	icon_state = "snake_oil"
	/// Users that used this tool
	var/list/mob/used_by = list()
	/// The maximum boost that users can get from using this tool
	var/max_boost = 100
	/// The attribute thats given to the user
	var/given_attribute = FORTITUDE_ATTRIBUTE
	/// The status effect given to the user upon first consumption
	var/given_status_effect = null
	/// The feedback message you get from using the tool
	var/feedback_message = "You take a sip, ugh, it tastes nasty!"
	/// The message the user gets if they try to get more then possible
	var/full_boost_message = "You've had enough."

/obj/structure/toolabnormality/attribute_giver/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(user in used_by)
		if(used_by[user] == 10) // You don't need any more.
			to_chat(user, span_notice(full_boost_message))
			return FALSE

	if(!do_after(user, 0.5 SECONDS, user))
		return FALSE

	. = TRUE
	if(!(user in used_by))
		user.apply_status_effect(given_status_effect)
		used_by += user

	user.adjust_attribute_buff(given_attribute, max_boost / 10) // always 10 uses
	used_by[user] += 1

	to_chat(user, span_userdanger(feedback_message))
