//Kill Order
/obj/item/book/granter/action/skill/kill_order
	granted_action = /datum/action/cooldown/kill_order
	actionname = "Kill Order"
	name = "Level 0 Skill: Kill Order"
	level = 0
	custom_premium_price = 300

/datum/action/cooldown/kill_order
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "kill_order"
	name = "Kill Order"
	cooldown_time = 300
	var/list/buffed_people = list()

/datum/action/cooldown/kill_order/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	user.Immobilize(5 SECONDS)
	user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)
	to_chat(user, span_userdanger("KILL THEM ALL!"))

	buffed_people = list()

	for(var/mob/living/carbon/human/L in orange(3, get_turf(user)))
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)
		buffed_people += L

		//Visible message just didn't work here. No clue why.
		to_chat(L, span_userdanger("KILL THEM ALL!"))

	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/datum/action/cooldown/kill_order/proc/Return(mob/living/carbon/human/user)
	user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10)
	to_chat(user, span_notice("Your killing buff has expired!"))

	for(var/mob/living/carbon/human/L in buffed_people)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10)
		to_chat(L, span_notice("Your killing buff has expired!"))

	addtimer(CALLBACK(src, PROC_REF(Cooldown), user), 30 SECONDS)
