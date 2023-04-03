#define STATUS_EFFECT_DR_JEKYLL /datum/status_effect/dr_jekyll
/obj/structure/toolabnormality/dr_jekyll
	name = "dr jekyll's formula"
	desc = "An innocent-looking bottle sitting on a table."
	icon_state = "dr_jekyll"
	var/list/users = list()

/obj/structure/toolabnormality/dr_jekyll/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 6, user))
		return
	if(get_level_buff(user, FORTITUDE_ATTRIBUTE) >= 100)
		to_chat(user, "<span class='notice'>It's empty.</span>")
		return //You don't need any more.

	user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 10)
	if(!(user in users))
		users += user
	else
		user.physiology.red_mod *= 1.15

	user.apply_status_effect(STATUS_EFFECT_DR_JEKYLL)
	to_chat(user, "<span class='userdanger'>You take a sip, it's lukewarm.</span>")

// Status Effect //TODO: make it spawn a hosite copy of you somehow.
/datum/status_effect/dr_jekyll
	id = "dr_jekyll"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/dr_jekyll/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, .proc/HydeDam)
	RegisterSignal(owner, COMSIG_FEAR_EFFECT, .proc/HydeFear)
	return ..()

/datum/status_effect/dr_jekyll/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(owner, COMSIG_FEAR_EFFECT)
	return ..()

/datum/status_effect/dr_jekyll/proc/HydeDam(mob/living/carbon/human/owner, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	if(damagetype == WHITE_DAMAGE)
		H.adjustBruteLoss(damage)

/datum/status_effect/dr_jekyll/proc/HydeFear(mob/living/carbon/human/owner, fear_level, sanity_damage)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	var/sanity_percent = (sanity_damage / H.maxSanity) //we have sanity damage already, but lets convert it to %health
	sanity_damage = (H.maxHealth*(sanity_percent))
	H.adjustBruteLoss(sanity_damage)
#undef STATUS_EFFECT_DR_JEKYLL
