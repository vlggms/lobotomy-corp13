//Smokedash
/obj/item/book/granter/action/skill/smokedash
	granted_action = /datum/action/cooldown/smokedash
	actionname = "Smokedash"
	name = "Level 1 Skill: Smokedash"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/smokedash
	name = "Smokedash"
	desc = "Increases movement speed and drops a smoke bomb at your feet."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "smokedash"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/smokedash/Trigger()
	. = ..()
	if(!.)
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


//Mark
/obj/item/book/granter/action/skill/mark
	granted_action = /datum/action/cooldown/mark
	actionname = "Mark"
	name = "Level 1 Skill: Mark"
	level = 1
	custom_premium_price = 0

/datum/action/cooldown/mark
	name = "Mark"
	desc = "Drops a small marker at your feet."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "mark"
	cooldown_time = 7 SECONDS

/datum/action/cooldown/mark/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	new /obj/structure/marker_beacon (get_turf(owner))
	StartCooldown()


//Mark
/obj/item/book/granter/action/skill/light
	granted_action = /datum/action/cooldown/light
	actionname = "Light"
	name = "Level 1 Skill: Light"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/light
	name = "Light"
	desc = "Create a flare to give you light."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "light"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/light/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	var/obj/item/flashlight/flare/F = new (get_turf(owner))
	F.attack_self(owner)
	StartCooldown()

