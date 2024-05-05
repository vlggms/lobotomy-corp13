//Defend Order
/obj/item/book/granter/action/skill/defend_order
	granted_action = /datum/action/cooldown/defend_order
	actionname = "Defend Order"
	name = "Level 0 Skill: Defend Order"
	level = 0
	custom_premium_price = 300

/datum/action/cooldown/defend_order
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "defend_order"
	name = "Defend Order"
	cooldown_time = 300
	var/defense_buff_self = 0.3
	var/defense_buff_others = 0.3
	var/list/buffed_people = list()

/datum/action/cooldown/defend_order/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	user.Immobilize(5 SECONDS)
	user.physiology.red_mod *= defense_buff_self
	user.physiology.white_mod *= defense_buff_self
	user.physiology.black_mod *= defense_buff_self
	user.physiology.pale_mod *= defense_buff_self
	to_chat(user, span_userdanger("HOLD THE LINE!"))

	buffed_people = list()

	for(var/mob/living/carbon/human/L in orange(3, get_turf(user)))
		L.physiology.red_mod *= defense_buff_others
		L.physiology.white_mod *= defense_buff_others
		L.physiology.black_mod *= defense_buff_others
		L.physiology.pale_mod *= defense_buff_others
		buffed_people += L

		//Visible message just didn't work here. No clue why.
		to_chat(L, span_userdanger("HOLD THE LINE!"))

	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/datum/action/cooldown/defend_order/proc/Return(mob/living/carbon/human/user)
	user.physiology.red_mod /= defense_buff_self
	user.physiology.white_mod /= defense_buff_self
	user.physiology.black_mod /= defense_buff_self
	user.physiology.pale_mod /= defense_buff_self
	to_chat(user, span_notice("Your defense buff has expired!"))

	for(var/mob/living/carbon/human/L in buffed_people)
		L.physiology.red_mod /= defense_buff_others
		L.physiology.white_mod /= defense_buff_others
		L.physiology.black_mod /= defense_buff_others
		L.physiology.pale_mod /= defense_buff_others
		to_chat(L, span_notice("Your defense buff has expired!"))

	addtimer(CALLBACK(src, PROC_REF(Cooldown), user), 30 SECONDS)
