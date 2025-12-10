#define STATUS_EFFECT_FLAMEKISSED	/datum/status_effect/flamekissed //You are iron, you can endure the heat
/datum/action/innate/flamekiss
	name = "Flamekissed"
	icon_icon = 'icons/hud/screen_skills.dmi'

/datum/action/innate/flamekiss/Activate()
	to_chat(owner, span_notice("You now endure the flaring heat."))
	button_icon_state = "shield_on"
	active = TRUE
	var/mob/living/carbon/human/iron = owner
	iron.physiology.burn_mod *= 0.1
	iron.apply_status_effect(STATUS_EFFECT_FLAMEKISSED)
	UpdateButtonIcon()

/datum/action/innate/flamekiss/Deactivate()
	to_chat(owner, span_notice("You now perish in the heat."))
	button_icon_state = "shield_off"
	active = FALSE
	var/mob/living/carbon/human/iron = owner
	iron.physiology.burn_mod /= 0.1
	iron.remove_status_effect(STATUS_EFFECT_FLAMEKISSED)
	UpdateButtonIcon()

/datum/action/cooldown/ember
	name = "Ember"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "shockwave"
	cooldown_time = 10 SECONDS
	var/range = 7

/datum/action/cooldown/ember/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Burn people around you
	for(var/mob/living/fuel in view(range, get_turf(src)))
		if(fuel.stat != DEAD && fuel!=owner)
			new /obj/effect/turf_fire/liu(get_turf(fuel))
	owner.visible_message(span_warning("Through masterful flow [owner] sets those around him alight!"))

	StartCooldown()

/datum/action/cooldown/doubleburn
	name = "Burn Swap"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "battleready_off"
	cooldown_time = 10 SECONDS
	var/range = 3

/datum/action/cooldown/doubleburn/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/fuel in view(range, get_turf(src)))
		if(locate(/obj/effect/turf_fire/liu) in fuel.loc)
			if(fuel.sanity_lost) //Please for the love of god do not put this at the end or the proc bursts into flames
				fuel.death()
			//this stuff is important for what youre about to do
			var/burn_holder = fuel.getFireLoss() //storing burn memories of fuel
			var/white_holder = fuel.sanityloss //storing sanity memories of fuel
			fuel.adjustSanityLoss(-1000)
			fuel.adjustFireLoss(-1000)
			fuel.adjustFireLoss(white_holder)
			fuel.adjustSanityLoss(burn_holder*2)
	owner.visible_message(span_warning("[owner] fans the flames, the fire burns brighter than ever!"))

	StartCooldown()

/obj/effect/turf_fire/liu
	burn_time = 10 SECONDS

/obj/effect/turf_fire/liu/DoDamage(mob/living/fuel)
	var/damage = 4
	if(!ishuman(fuel))
		damage = 8
	fuel.deal_damage(damage, FIRE, attack_type = (ATTACK_TYPE_ENVIRONMENT))
	fuel.adjust_fire_stacks(1)
	fuel.IgniteMob()

// status effect
/datum/status_effect/flamekissed
	id = "flamekissed"
	alert_type = null
	var/healing = 0.5

/datum/status_effect/flamekissed/tick()
	. = ..()
	if (owner.stat != DEAD)
		owner.adjustFireLoss(-healing)
