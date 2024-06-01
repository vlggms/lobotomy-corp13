//Warbanner
/obj/item/book/granter/action/skill/warbanner
	granted_action = /datum/action/cooldown/warbanner
	actionname = "Warbanner"
	name = "Level 4 Skill: Warbanner"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/warbanner
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "warbanner"
	name = "Warbanner"
	cooldown_time = 1800
	var/range = 2
	var/list/affected = list()

/datum/action/cooldown/warbanner/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		human.physiology.red_mod *= 0.6
		human.physiology.white_mod *= 0.6
		human.physiology.black_mod *= 0.6
		human.physiology.pale_mod *= 0.6
		affected+= human
	addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	StartCooldown()

/datum/action/cooldown/warbanner/proc/Recall()
	for(var/mob/living/carbon/human/human in affected)
		human.physiology.red_mod /= 0.6
		human.physiology.white_mod /= 0.6
		human.physiology.black_mod /= 0.6
		human.physiology.pale_mod /= 0.6





	//Warcry
/obj/item/book/granter/action/skill/warcry
	granted_action = /datum/action/cooldown/warcry
	actionname = "Warcry"
	name = "Level 4 Skill: Warcry"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/warcry
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "warcry"
	name = "Warcry"
	cooldown_time = 1800
	var/range = 2
	var/list/affected = list()

/datum/action/cooldown/warcry/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		human.add_movespeed_modifier(/datum/movespeed_modifier/retreat)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/retreat), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	StartCooldown()

