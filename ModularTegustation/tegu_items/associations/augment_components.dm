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

/datum/component/augment/proc/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, click_parameters, obj/item/item)
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
	to_chat(H, span_nicegreen("Your mind stabilizes as you rip into [target]!"))

/datum/component/augment/absorption
	var/last_target

/datum/component/augment/absorption/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	if(target.stat != DEAD)
		last_target = target

/datum/component/augment/absorption/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, click_parameters, obj/item/item)
	if(!ishuman(parent))
		return FALSE
	var/mob/living/carbon/human/H = parent
	if(last_target.stat == DEAD)
		var/justice_mod = 1 + (get_modified_attribute_level(H, JUSTICE_ATTRIBUTE)/100)
		var/total_damage = item.force * justice_mod
		H.adjustBruteLoss(-1*total_damage)
		to_chat(H, span_nicegreen("Your body regenerates has you execute [target]!"))
	last_target = null

/datum/component/augment/brutalize
	var/last_target
	var/amount = 1
	var/kill_damage = 15

/datum/component/augment/brutalize/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	if(target.stat != DEAD)
		last_target = target

/datum/component/augment/brutalize/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, click_parameters, obj/item/item)
	if(!ishuman(parent))
		return FALSE
	var/mob/living/carbon/human/H = parent
	if(last_target.stat == DEAD)
	for(var/mob/living/L in urange(5, H))
		if(faction_check(H.faction, L.faction)) // I LOVE NESTING IF STATEMENTS
			continue
		L.deal_damage(kill_damage, WHITE_DAMAGE)
		to_chat(H, span_nicegreen("Your body regenerates has you execute [target]!"))
	last_target = null
