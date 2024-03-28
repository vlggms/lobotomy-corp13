//Dash and backstep
/obj/item/book/granter/action/skill/dash
	granted_action = /datum/action/cooldown/dash
	actionname = "Dash"
	name = "Level 1 Skill: Dash"
	level = 1
	custom_premium_price = 600

/obj/item/book/granter/action/skill/dashback
	granted_action = /datum/action/cooldown/dash/back
	actionname = "Backstep"
	name = "Level 1 Skill: Backstep"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/dash
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "dash"
	name = "Dash"
	cooldown_time = 30
	var/direction = 1

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

//Assault
/obj/item/book/granter/action/skill/assault
	granted_action = /datum/action/cooldown/assault
	name = "Level 1 Skill: Assault"
	actionname = "Assault"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/assault
	cooldown_time = 200
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "assault"


/datum/action/cooldown/assault/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/assault)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/assault), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/movespeed_modifier/assault
	variable = TRUE
	multiplicative_slowdown = -0.1

//Retreat
/obj/item/book/granter/action/skill/retreat
	granted_action = /datum/action/cooldown/retreat
	name = "Level 1 Skill: Retreat"
	actionname = "Retreat"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/retreat
	cooldown_time = 200
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "retreat"


/datum/action/cooldown/retreat/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/retreat)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/retreat), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.physiology.red_mod *= 1.3
		human.physiology.white_mod *= 1.3
		human.physiology.black_mod *= 1.3
		human.physiology.pale_mod *= 1.3
		addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/retreat/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 1.3
	human.physiology.white_mod /= 1.3
	human.physiology.black_mod /= 1.3
	human.physiology.pale_mod /= 1.3

/datum/movespeed_modifier/retreat
	variable = TRUE
	multiplicative_slowdown = -0.3
