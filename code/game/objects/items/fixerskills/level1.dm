
/obj/item/book/granter/action/skill
	granted_action = null
	actionname = null
	var/level = 0
	var/mob/living/carbon/human/user
	var/list/datum/action/actions_levels = list(
		/datum/action/cooldown/dash = 1,
		/datum/action/cooldown/dash/back = 1,
		/datum/action/cooldown/shockwave = 2,
		/datum/action/innate/bulletproof = 3,
		/datum/action/cooldown/timestop = 4,
		/datum/action/cooldown/assault = -1
	)

/obj/item/book/granter/action/skill/on_reading_finished(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/human = user
		var/user_level = get_civilian_level(human)
		if ((level != user_level && level != -1) )
			to_chat(user, "<span class='notice'>Your level is [user_level]. This book need level [level]!</span>")
			return FALSE
		if (!(user?.mind?.assigned_role in list("Civilian", "Rat")))
			to_chat(user, "<span class='notice'>Only Civilians and Rats can use this book!</span>")
			return FALSE
		for(var/datum/action/A in user.actions)
			if (actions_levels[A.type] == level)
				to_chat(user, "<span class='notice'>You already have a skill of this level!</span>")
				return FALSE
		..()

/obj/item/book/granter/action/skill/recoil(mob/user)
	to_chat(user,"<span class='warning'>[src] suddenly vanishes!</span>")
	qdel(src)

/obj/item/book/granter/action/skill/dash
	granted_action = /datum/action/cooldown/dash
	actionname = "Dash"
	name = "Level 1 Skill: Dash"
	level = 1

/obj/item/book/granter/action/skill/dashback
	granted_action = /datum/action/cooldown/dash/back
	actionname = "Backstep"
	name = "Level 1 Skill: Backstep"
	level = 1

/datum/action/cooldown/dash
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "dash"
	name = "Dash"
	cooldown_time = 30
	var/direction = 1
	var/level = 1

/datum/action/cooldown/dash/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	var/dodgelanding
	if(owner.dir == 1)
		dodgelanding = locate(owner.x, owner.y + 5 * direction, owner.z)
	if(owner.dir == 2)
		dodgelanding = locate(owner.x, owner.y - 5 * direction, owner.z)
	if(owner.dir == 4)
		dodgelanding = locate(owner.x + 5 * direction, owner.y, owner.z)
	if(owner.dir == 8)
		dodgelanding = locate(owner.x - 5 * direction, owner.y, owner.z)
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		if (!human.IsParalyzed())
			human.adjustStaminaLoss(20, TRUE, TRUE)
			human.throw_at(dodgelanding, 3, 2, spin = TRUE)
			StartCooldown()
			return TRUE

/datum/action/cooldown/dash/back
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "backstep"
	name = "Backstep"
	direction = -1
