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
		to_chat(user, span_notice("You return the vial."))
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
	var/panic_override = FALSE
	var/datum/action/cooldown/dr_jekyll/ability = new /datum/action/cooldown/dr_jekyll()

/datum/status_effect/display/dr_jekyll/on_apply()
	. = ..()
	ability.Grant(owner)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -30)

/datum/status_effect/display/dr_jekyll/on_remove()
	. = ..()
	ability.Remove(owner)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 30)

/datum/status_effect/display/dr_jekyll/tick()
	SanityCheck()

/datum/status_effect/display/dr_jekyll/proc/SanityCheck()
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

/datum/status_effect/display/hyde
	id = "hyde"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/hyde
	var/highest
	var/high
	var/low
	var/lowest
	var/level
	var/level_mod
	examine_text = span_warning("They do not appear to be themselves.")
	var/message_cooldown
	var/message_cooldown_time = 30 SECONDS
	var/list/message_list = list(
	"Are you ready?",
	"Mankind is not truly one, but truly two.",
	"The blood quickens, the soul sickens.",
	"I am a part of you now. Just as you are a part of me.",
	"Drink.",
	"Don't concern yourself with good and evil.",
	"You could be so much more than those panting hypocrites.",
	"Take back what they took from you. Trample on their dead bodies.",
	)

/atom/movable/screen/alert/status_effect/hyde
	name = "Mr.Hyde"
	desc = "A mysterious force is guiding your actions."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "hyde"

/datum/status_effect/display/hyde/on_apply()
	HydeTakeover()
	return ..()

/datum/status_effect/display/hyde/on_remove()
	ReturnToNormal()
	return ..()

/datum/status_effect/display/hyde/tick() //we need to check if the user healed back up to 50% sanity if below
	SanityCheck()
	if(message_cooldown > world.time)
		return
	to_chat(owner, span_unconscious("<font color='red'>[pick(message_list)]</font>"))
	message_cooldown = (message_cooldown_time + rand(0, 1200)) + world.time

/datum/status_effect/display/hyde/proc/SanityCheck()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanityhealth >= status_holder.maxSanity)
		status_holder.remove_status_effect(src)
		return

/datum/status_effect/display/hyde/proc/HydeTakeover()
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_notice("You feel freed of all inhibitions."))
	level = get_user_level(owner) // we only update when the debuff is inflicted
	level_mod = (level * 5)
	for(var/attribute in status_holder.attributes)
		AttributeCalc(attribute, status_holder)
	status_holder.adjust_attribute_bonus(lowest, 2 * level_mod)
	status_holder.adjust_attribute_bonus(low, 1 * level_mod)
	status_holder.adjust_attribute_bonus(high, -1 * level_mod)
	status_holder.adjust_attribute_bonus(highest, -2 * level_mod)

/datum/status_effect/display/hyde/proc/AttributeCalc(attribute, mob/living/carbon/human/H)
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

/datum/status_effect/display/hyde/proc/ReturnToNormal()
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("The strange feeling goes away."))
	status_holder.adjust_attribute_bonus(lowest, -2 * level_mod)
	status_holder.adjust_attribute_bonus(low, -1 * level_mod)
	status_holder.adjust_attribute_bonus(high, 1 * level_mod)
	status_holder.adjust_attribute_bonus(highest, 2 * level_mod)

//AI
/datum/ai_controller/insane/murder/hyde
	lines_type = /datum/ai_behavior/say_line/insanity_hyde

/datum/ai_behavior/say_line/insanity_hyde
	lines = list(
		"If I am the chief of sinners, I am the chief of sufferers too.",
		"I incline to Cain's heresy!",
		"Finally, you've given in! This body is mine!",
		"Now, let's see what this body is good for.",
		"I'll put an end to your pitiful squealing!",
		"Hark! The devil is here!",
		"O, my poor old soul!",
	)

/datum/status_effect/panicked_type/hyde
	icon = "hyde"

//Action
/datum/action/cooldown/dr_jekyll
	icon_icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	button_icon_state = "dr_jekyll"
	name = "Drink"
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
		to_chat(H, span_userdanger("You quaff the liquid, it tastes incredibly foul."))
		playsound(H.loc, 'sound/items/drink.ogg', rand(10,50), TRUE)
		H.adjustSanityLoss(H.maxSanity * 0.5) // lose half your sanity
		H.apply_status_effect(STATUS_EFFECT_HYDE)
		StartCooldown()
		return
	to_chat(H, span_notice("You are already under the effects of this ability."))

#undef STATUS_EFFECT_DR_JEKYLL
#undef STATUS_EFFECT_HYDE
