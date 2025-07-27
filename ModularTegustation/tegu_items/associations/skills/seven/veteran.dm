/datum/action/cooldown/weaknessanalyzed
	name = "Weakness Analyzed"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "solarflare"
	cooldown_time = 60 SECONDS
	var/range = 5
	var/affect_self = FALSE

/datum/action/cooldown/weaknessanalyzed/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/L in view(range, owner))
		if(L.stat == DEAD)
			continue
		if (L == owner && !affect_self)
			continue
		L.apply_status_effect(/datum/status_effect/rend_seven)
		owner.say("	I've analyzed the enemy's behavior.")
	StartCooldown()
	return ..()

/datum/status_effect/rend_seven
	id = "seven rend black armor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 150 //15 seconds
	alert_type = null

/datum/status_effect/rend_seven/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 1.4
		L.physiology.white_mod *= 1.4
		L.physiology.black_mod *= 1.4
		L.physiology.pale_mod *= 1.4
		return
	var/mob/living/simple_animal/M = owner
	M.AddModifier(/datum/dc_change/seven)

/datum/status_effect/rend_seven/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 1.4
		L.physiology.white_mod /= 1.4
		L.physiology.black_mod /= 1.4
		L.physiology.pale_mod /= 1.4
		return
	var/mob/living/simple_animal/M = owner
	M.RemoveModifier(/datum/dc_change/seven)

/datum/action/cooldown/fieldcommand
	name = "Field Command"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "warbanner"
	var/list/affected = list()
	var/range = 1
	var/affect_self = FALSE

/datum/action/cooldown/fieldcommand/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		if (human.stat == DEAD)
			continue
		if (human == owner && !affect_self)
			continue
		if(human in affected)
			owner.say("I'll give you half a day off, so go get the rest you need.")
			human.physiology.red_mod /= 0.9
			human.physiology.white_mod /= 0.9
			human.physiology.black_mod /= 0.9
			human.physiology.pale_mod /= 0.9
			human.remove_movespeed_modifier(/datum/movespeed_modifier/fieldcommand)
			affected-= human
		else
			owner.say("I'll take charge.")
			human.physiology.red_mod *= 0.9
			human.physiology.white_mod *= 0.9
			human.physiology.black_mod *= 0.9
			human.physiology.pale_mod *= 0.9
			human.add_movespeed_modifier(/datum/movespeed_modifier/fieldcommand)
			affected+= human

/datum/movespeed_modifier/fieldcommand
	variable = TRUE
	multiplicative_slowdown = -0.05
