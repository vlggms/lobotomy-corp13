/datum/component/augment
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/augment/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, PROC_REF(attack_effect))
	RegisterSignal(parent, COMSIG_MOB_ITEM_AFTERATTACK, PROC_REF(afterattack_effect))
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(take_damage_effect))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(attackedby_mob))

/datum/component/augment/proc/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	to_chat(parent, "Attack Effect Triggered, we attacked [target]")

/datum/component/augment/proc/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, click_parameters)
	to_chat(parent, "After Attack Effect Triggered, we attacked [target]")

/datum/component/augment/proc/take_damage_effect(datum/source, damage, damagetype, def_zone)
	to_chat(parent, "Take Damage Effect Triggered, You have taken [damage] [damagetype] damage!")

/datum/component/augment/proc/attackedby_mob(datum/source, mob/living/simple_animal/animal)
	to_chat(parent, "Attackby Mob Effect Triggered, attacked by [animal]")

/datum/component/augment/regeneration
	var/regen_cooldown
	var/regen_cooldown_time = 5
	var/amount = 1

/datum/component/augment/regeneration/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	if(regen_cooldown > world.time)
		return FALSE
	if(item.damtype != RED_DAMAGE)
		return FALSE
	if(!ishuman(parent))
		return FALSE
	var/mob/living/carbon/human/H = parent
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	regen_cooldown = world.time + regen_cooldown_time
	H.adjustBruteLoss(-2*amount)
	to_chat(user, span_nicegreen("Your body regenerates as you rip into [target]!"))

/datum/component/augment/tranquility
	var/regen_cooldown
	var/regen_cooldown_time = 5
	var/amount = 1

/datum/component/augment/tranquility/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	if(regen_cooldown > world.time)
		return FALSE
	if(item.damtype != WHITE_DAMAGE)
		return FALSE
	if(!ishuman(parent))
		return FALSE
	var/mob/living/carbon/human/H = parent
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	regen_cooldown = world.time + regen_cooldown_time
	H.adjustSanityLoss(-2*amount)
	to_chat(user, span_nicegreen("Your mind stabilizes as you rip into [target]!"))