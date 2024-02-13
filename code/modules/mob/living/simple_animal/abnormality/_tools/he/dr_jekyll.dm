#define STATUS_EFFECT_DR_JEKYLL /datum/status_effect/dr_jekyll
/obj/structure/toolabnormality/dr_jekyll
	name = "dr jekyll's formula"
	desc = "An innocent-looking bottle."
	icon_state = "dr_jekyll"
	var/list/users = list()

	ego_list = list(
		/datum/ego_datum/weapon/hyde,
		/datum/ego_datum/armor/hyde,
	)

/obj/structure/toolabnormality/dr_jekyll/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 10, user))
		return

	if((user in users))
		to_chat(user, span_notice("There's none left."))
		return //You don't need any more.

	users += user
	to_chat(user, span_userdanger("You take a sip, it's lukewarm."))
	user.apply_status_effect(STATUS_EFFECT_DR_JEKYLL)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10,50), TRUE)

// Status Effect
/datum/status_effect/dr_jekyll
	id = "dr_jekyll"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

	var/panic_override = FALSE
	var/takeover = FALSE
	var/highest
	var/high
	var/low
	var/lowest
	var/level
	var/level_mod

/datum/status_effect/dr_jekyll/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(HydeDam))
	RegisterSignal(owner, COMSIG_FEAR_EFFECT, PROC_REF(HydeDam))
	return ..()

/datum/status_effect/dr_jekyll/on_remove()
	if(takeover)
		ReturnToNormal()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(owner, COMSIG_FEAR_EFFECT)
	return ..()

/datum/status_effect/dr_jekyll/tick() //we need to check if the user healed back up to 50% sanity if below
	if(!takeover)
		return
	SanityCheck()

/datum/status_effect/dr_jekyll/proc/HydeDam()
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(SanityCheck)), 1) //Gives sanity time to update

/datum/status_effect/dr_jekyll/proc/SanityCheck()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		if(panic_override)
			return
		QDEL_NULL(status_holder.ai_controller)
		status_holder.ai_controller = /datum/ai_controller/insane/murder/hyde
		status_holder.InitializeAIController()
		status_holder.apply_status_effect(/datum/status_effect/panicked_type/hyde)
		panic_override = TRUE
		return

	panic_override = FALSE
	if(!takeover)
		if(status_holder.sanityhealth < (status_holder.maxSanity * 0.5))
			HydeTakeover()
		return
	if(status_holder.sanityhealth > (status_holder.maxSanity * 0.5))
		ReturnToNormal()

/datum/status_effect/dr_jekyll/proc/HydeTakeover()
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_notice("You feel strange... Yet... Free?"))
	takeover = TRUE
	level = get_user_level(owner) // we only update when the debuff is inflicted
	level_mod = (level * 5)
	for(var/attribute in status_holder.attributes)
		AttributeCalc(attribute, status_holder)

	status_holder.adjust_attribute_bonus(lowest, 2 * level_mod)
	status_holder.adjust_attribute_bonus(low, 1 * level_mod)
	status_holder.adjust_attribute_bonus(high, -1 * level_mod)
	status_holder.adjust_attribute_bonus(highest, -2 * level_mod)
	if(status_holder.sanityhealth > (status_holder.maxSanity * 0.5)) //We need to check if prudence changes would cause hyde to go away
		status_holder.sanityhealth = (status_holder.maxSanity * 0.45)

/datum/status_effect/dr_jekyll/proc/AttributeCalc(attribute, mob/living/carbon/human/H)
	var/attribute_level = get_raw_level(H, attribute)
	if(attribute_level > get_raw_level(H, highest) || !highest)
		lowest = low
		low = high
		high = highest
		highest = attribute
		return
	if(attribute_level > get_raw_level(H, high) || !high)
		lowest = low
		low = high
		high = attribute
		return
	if(attribute_level > get_raw_level(H, low) || !low)
		lowest = low
		low = attribute
		return
	lowest = attribute

/datum/status_effect/dr_jekyll/proc/ReturnToNormal()
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("The strange feeling goes away."))
	takeover = FALSE
	status_holder.adjust_attribute_bonus(lowest, -2 * level_mod)
	status_holder.adjust_attribute_bonus(low, -1 * level_mod)
	status_holder.adjust_attribute_bonus(high, 1 * level_mod)
	status_holder.adjust_attribute_bonus(highest, 2 * level_mod)
	if(status_holder.sanityhealth < (status_holder.maxSanity * 0.5)) //We need to check if prudence changes would cause hyde to return
		status_holder.sanityhealth = (status_holder.maxSanity * 0.55)
	highest = 0
	high = 0
	low = 0
	lowest = 0

//AI
/datum/ai_controller/insane/murder/hyde
	lines_type = /datum/ai_behavior/say_line/insanity_hyde

/datum/ai_behavior/say_line/insanity_hyde
	lines = list(
		"If I am the chief of sinners, I am the chief of sufferers too.",
		"I incline to Cain's heresy!",
		"Finally, you've given in! This body is mine!",
		"Now, let's see what this body is good for.",
		"Hark! I'll put an end to your pitiful squealing!",
		"O, my poor old soul!",
	)

/datum/status_effect/panicked_type/hyde
	icon = "hyde"

#undef STATUS_EFFECT_DR_JEKYLL
