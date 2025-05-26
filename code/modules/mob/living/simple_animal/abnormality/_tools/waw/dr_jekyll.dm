#define STATUS_EFFECT_HYDE /datum/status_effect/display/hyde
#define STATUS_EFFECT_DR_JEKYLL /datum/status_effect/display/dr_jekyll
/obj/structure/toolabnormality/dr_jekyll
	name = "dr jekyll's formula"
	desc = "An innocent-looking bottle."
	icon_state = "dr_jekyll"

	ego_list = list(
		/datum/ego_datum/weapon/hyde,
		/datum/ego_datum/armor/hyde,
	)

/obj/structure/toolabnormality/dr_jekyll/attack_hand(mob/living/carbon/human/user)
	..()
	if(get_user_level(user) <= 2)
		to_chat(user, span_notice("You can't quite figure out the instructions for how to prepare this yet."))
		return
	if(!do_after(user, 10, user))
		return

	var/datum/status_effect/display/dr_jekyll/J = user.has_status_effect(STATUS_EFFECT_DR_JEKYLL)
	if(!J)
		to_chat(user, span_userdanger("You follow the instructions and create some sort of liquid."))
		user.apply_status_effect(STATUS_EFFECT_DR_JEKYLL)
		playsound(user.loc, 'sound/effects/bubbles.ogg', rand(10,50), TRUE)
		return
	var/datum/status_effect/display/hyde/H = user.has_status_effect(STATUS_EFFECT_HYDE)
	if(!H)
		to_chat(user, span_notice("You return the serum."))
		user.remove_status_effect(STATUS_EFFECT_DR_JEKYLL)
		return //You don't need any more.
	else //They messed up
		to_chat(user, span_userdanger("HA! You won't get rid of me that easily!"))
		playsound(get_turf(user), 'sound/abnormalities/someonesportrait/panic.ogg', 40, FALSE, -5)
		user.apply_damage(999, WHITE_DAMAGE, null, user.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)//DIE!
		return

// Status Effects
/datum/status_effect/display/dr_jekyll
	id = "dr_jekyll"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 30 //Check sanity every 3 seconds
	alert_type = null
	display_name = "jekyll"
	var/datum/action/cooldown/dr_jekyll/ability = new /datum/action/cooldown/dr_jekyll()

/datum/status_effect/display/dr_jekyll/on_apply()
	. = ..()
	ability.Grant(owner)

/datum/status_effect/display/dr_jekyll/on_remove()
	. = ..()
	ability.Remove(owner)

/datum/status_effect/display/dr_jekyll/tick()
	SanityCheck()

/datum/status_effect/display/dr_jekyll/proc/SanityCheck()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		QDEL_NULL(status_holder.ai_controller)
		status_holder.ai_controller = /datum/ai_controller/insane/murder/hyde
		status_holder.InitializeAIController()
		status_holder.apply_status_effect(/datum/status_effect/panicked_type/hyde)

/datum/status_effect/display/hyde
	id = "hyde"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/hyde
	examine_text = span_warning("They do not appear to be themselves.")
	var/message_cooldown
	var/message_cooldown_time = 30 SECONDS
	var/current_boost = 0
	var/list/message_list = list(
		"Are you ready?",
		"Mankind is not truly one, but truly two.",
		"The blood quickens, the soul sickens.",
		"I am a part of you now. Just as you are a part of me.",
		"Don't concern yourself with good and evil.",
		"I'll show you terrible, beautiful things.",
		"You could be so much more than those panting hypocrites.",
		"Take back what they took from you. Trample on their dead bodies.",
	)

/atom/movable/screen/alert/status_effect/hyde
	name = "Mr.Hyde"
	desc = "A mysterious force is guiding your actions."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "hyde"

/datum/status_effect/display/hyde/on_apply()
	to_chat(owner, span_notice("You feel freed of all inhibitions."))
	var/mob/living/carbon/human/status_holder = owner
	ADD_TRAIT(status_holder, TRAIT_COMBATFEAR_IMMUNE, "Jekyll")
	return ..()

/datum/status_effect/display/hyde/on_remove()
	var/mob/living/carbon/human/status_holder = owner
	REMOVE_TRAIT(status_holder, TRAIT_COMBATFEAR_IMMUNE, "Jekyll")
	ReturnToNormal()
	return ..()

/datum/status_effect/display/hyde/tick()
	var/mob/living/carbon/human/status_holder = owner
	var/sanitytolose = clamp(status_holder.maxSanity * 0.025, 0, status_holder.sanityhealth - 1)
	status_holder.adjustSanityLoss(sanitytolose) // hopefully keeps them at at least 1 sanity
	new /obj/effect/temp_visual/damage_effect/sinking(get_turf(status_holder))
	var/new_boost = (status_holder.maxSanity - status_holder.sanityhealth) * 0.5
	var/boost_difference = new_boost - current_boost
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, boost_difference)
	current_boost = new_boost
	SanityCheck()
	if(message_cooldown > world.time)
		return
	to_chat(owner, span_unconscious("<font color='red'>[pick(message_list)]</font>"))
	message_cooldown = (message_cooldown_time + rand(0, 1200)) + world.time

/datum/status_effect/display/hyde/proc/SanityCheck()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanityhealth <= 1 || status_holder.sanity_lost)
		qdel(src)

/datum/status_effect/display/hyde/proc/ReturnToNormal()
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("The strange feeling goes away."))
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -current_boost)

//Action
/datum/action/cooldown/dr_jekyll
	icon_icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	button_icon_state = "dr_jekyll"
	name = "Switch"
	cooldown_time = 300

/datum/action/cooldown/dr_jekyll/Trigger()
	if(!..())
		return FALSE
	if (owner.stat == DEAD)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/display/hyde/effect = H.has_status_effect(STATUS_EFFECT_HYDE)
	if(!effect)
		to_chat(H, span_userdanger("You drink some of your serum."))
		H.playsound_local(get_turf(H), 'sound/abnormalities/someonesportrait/panic.ogg', 40, FALSE)
		H.adjustSanityLoss(H.maxSanity * 0.25) // lose a quarter your sanity insantly
		new /obj/effect/temp_visual/damage_effect/sinking(get_turf(H))
		H.apply_status_effect(STATUS_EFFECT_HYDE)
		StartCooldown()
		return
	to_chat(H, span_notice("You are already under the effects of this ability. It will wear off when your sanity is reduced to 1."))

//AI
/datum/ai_controller/insane/murder/hyde
	lines_type = /datum/ai_behavior/say_line/insanity_hyde

/datum/ai_behavior/say_line/insanity_hyde
	lines = list(
		"You insolent, pitiful, insignificant ant!",
		"Must I do everything myself?",
		"Finally, you've given in! This body is mine!",
		"Now, let's see what this body is good for.",
		"I'll put an end to your pitiful squealing!",
		"Hark! The devil is here!",
		"You're not worth my time!",
	)

// The panic loses regained sanity over time, and is tougher to deal with by other players.
/datum/status_effect/panicked_type/hyde
	icon = "hyde"

/datum/status_effect/panicked_type/hyde/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	ADD_TRAIT(status_holder, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(status_holder, TRAIT_PUSHIMMUNE, type)

/datum/status_effect/panicked_type/hyde/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	REMOVE_TRAIT(status_holder, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(status_holder, TRAIT_PUSHIMMUNE, type)

/datum/status_effect/panicked_type/hyde/tick()
	var/mob/living/carbon/human/status_holder = owner
	var/sanitytolose = (status_holder.maxSanity * 0.05)
	status_holder.adjustSanityLoss(sanitytolose) // hopefully keeps them at at least 1 sanity
	new /obj/effect/temp_visual/damage_effect/sinking(get_turf(status_holder))

#undef STATUS_EFFECT_DR_JEKYLL
#undef STATUS_EFFECT_HYDE
