/obj/item/book/granter/action/skill
	granted_action = null
	actionname = null
	var/level = 0
	var/mob/living/carbon/human/user

/obj/item/book/granter/action/skill/on_reading_finished(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/human = user
		var/user_level = get_civilian_level(human)
		if (level != user_level && level != -1)
			to_chat(user, "<span class='notice'>Your level is [user_level]. This book need level [level]!</span>")
			return FALSE
		..()

/obj/item/book/granter/action/skill/dash
	granted_action = /datum/action/cooldown/dash
	actionname = "Dash"
	name = "Dash"
	level = 1

/obj/item/book/granter/action/skill/dashback
	granted_action = /datum/action/cooldown/dash/back
	actionname = "Dash back"
	name = "Dash back"
	level = 1

/datum/action/cooldown/dash
	name = "Dash back"
	cooldown_time = 30
	var/direction = 1

/datum/action/cooldown/dash/Trigger()
	if(!..())
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
	direction = -1
