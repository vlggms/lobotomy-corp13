#define STATUS_EFFECT_BEHAVIOR /datum/status_effect/behavior
/obj/structure/toolabnormality/behaviour
	name = "behaviour adjustment"
	desc = "A floating disk."
	icon_state = "behavior"
	var/list/activeusers = list()


/obj/structure/toolabnormality/behaviour/attack_hand(mob/living/carbon/human/user)
	..()
	if(do_after(user, 6))
		if(user in activeusers)
			activeusers -= user
			user.remove_status_effect(STATUS_EFFECT_BEHAVIOR)
			to_chat(user, "<span class='userdanger'>You put back the behavior adjustment.</span>")
			user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "behavior", -MUTATIONS_LAYER))
		else
			activeusers += user
			user.apply_status_effect(STATUS_EFFECT_BEHAVIOR)
			to_chat(user, "<span class='userdanger'>You pick up the behavior adjustment.</span>")
			user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "behavior", -MUTATIONS_LAYER))


//Behavior Adjustment
//this keeps track of dying
/datum/status_effect/behavior
	id = "behavior"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null

/datum/status_effect/behavior/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 15)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10)

/datum/status_effect/behavior/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -15)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)

/datum/status_effect/behavior/tick()
	var/mob/living/carbon/human/H = owner
	if(H.sanity_lost)
		for(var/obj/item/organ/O in owner.getorganszone(BODY_ZONE_HEAD, TRUE))
			if(istype(O,/obj/item/organ/eyes))
				O.Remove(owner)
				QDEL_NULL(O)
				break
		owner.death()

#undef STATUS_EFFECT_BEHAVIOR

