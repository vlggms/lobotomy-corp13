//Smokedash
/obj/item/book/granter/action/skill/smokedash
	granted_action = /datum/action/cooldown/smokedash
	actionname = "Smokedash"
	name = "Level 1 Skill: Smokedash"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/smokedash
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "smokedash"
	name = "Smokedash"
	cooldown_time = 300

/datum/action/cooldown/smokedash/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//increase speed
	var/mob/living/carbon/human/human = owner
	human.add_movespeed_modifier(/datum/movespeed_modifier/assault)
	addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/assault), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

	//drop a bit of smoke
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(4, get_turf(human))	//Make the smoke bigger
	S.start()
	qdel(S)
	StartCooldown()


//Skulk
/obj/item/book/granter/action/skill/skulk
	granted_action = /datum/action/cooldown/skulk
	actionname = "Skulk"
	name = "Level 1 Skill: Skulk"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/skulk
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "smkulk"
	name = "Skulk"
	cooldown_time = 300

/datum/action/cooldown/skulk/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//become invisible
	owner.alpha = 15
	addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	StartCooldown()

/datum/action/cooldown/skulk/proc/Recall()
	owner.alpha = 255
