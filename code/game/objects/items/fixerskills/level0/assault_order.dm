//Assault Order
/obj/item/book/granter/action/skill/assault_order
	granted_action = /datum/action/cooldown/assault_order
	actionname = "Assault Order"
	name = "Level 0 Skill: Assault Order"
	level = 0
	custom_premium_price = 300

/datum/action/cooldown/assault_order
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "assault_order"
	name = "Assault Order"
	cooldown_time = 300
	var/list/buffed_people = list()

/datum/action/cooldown/assault_order/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	user.Immobilize(5 SECONDS)
	user.slowdown = -0.3
	to_chat(user, span_userdanger("CHARGE!"))

	buffed_people = list()

	for(var/mob/living/carbon/human/L in orange(3, get_turf(user)))
		L.slowdown = -0.3
		buffed_people += L

		//Visible message just didn't work here. No clue why.
		to_chat(L, span_userdanger("CHARGE!"))

	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/datum/action/cooldown/assault_order/proc/Return(mob/living/carbon/human/user)
	user.slowdown = +0.3
	to_chat(user, span_notice("Your speed buff has expired!"))

	for(var/mob/living/carbon/human/L in buffed_people)
		L.slowdown = +0.3
		to_chat(L, span_notice("Your speed buff has expired!"))

	addtimer(CALLBACK(src, PROC_REF(Cooldown), user), 30 SECONDS)
// BEGIN_INTERNALS
// END_INTERNALS
// BEGIN_FILE_DIR
#define FILE_DIR .
// END_FILE_DIR
// BEGIN_PREFERENCES
// END_PREFERENCES
// BEGIN_INCLUDE
// END_INCLUDE
