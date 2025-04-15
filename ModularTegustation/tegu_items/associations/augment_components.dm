/datum/component/augment
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/repeat = 1
	var/mob/living/last_target
	var/mob/living/carbon/human/human_parent

/datum/component/augment/Initialize(_repeat = 1)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	human_parent = parent
	repeat = _repeat

	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, PROC_REF(attack_effect))
	RegisterSignal(parent, COMSIG_MOB_ITEM_AFTERATTACK, PROC_REF(afterattack_effect))
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(take_damage_effect)) ////datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	RegisterSignal(parent, COMSIG_MOB_AFTER_APPLY_DAMGE, PROC_REF(after_take_damage_effect)) ////datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(attackedby_mob))

/datum/component/augment/proc/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	to_chat(parent, "Attack Effect Triggered, we attacked [target]")
	if(target.stat != DEAD)
		last_target = target

/datum/component/augment/proc/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, click_parameters, obj/item/item)
	to_chat(parent, "After Attack Effect Triggered, we attacked [target]")
	last_target = null

/datum/component/augment/proc/take_damage_effect(datum/source, damage, damagetype, def_zone)
	to_chat(parent, "Take Damage Effect Triggered, You have taken [damage] [damagetype] damage!")

/datum/component/augment/proc/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	to_chat(parent, "Take After Damage Effect Triggered, You have taken [damage] [damagetype] damage!")

/datum/component/augment/proc/attackedby_mob(datum/source, mob/living/simple_animal/animal)
	to_chat(parent, "Attackby Mob Effect Triggered, attacked by [animal]")


//Attacking Effects
/datum/component/augment/regeneration
	var/regen_cooldown
	var/regen_cooldown_time = 5
	var/amount = -2

/datum/component/augment/regeneration/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
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
	H.adjustBruteLoss(amount * repeat)
	to_chat(user, span_nicegreen("Your body regenerates as you rip into [target]!"))

/datum/component/augment/tranquility
	var/regen_cooldown
	var/regen_cooldown_time = 5
	var/amount = -2

/datum/component/augment/tranquility/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
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
	H.adjustSanityLoss(amount * repeat)
	to_chat(H, span_nicegreen("Your mind stabilizes as you rip into [target]!"))

/datum/component/augment/struggling_strength
	var/damage_buff = 10
	var/damage_buff_mult = 0
	var/total_damage_buff = 0

/datum/component/augment/struggling_strength/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.75)
		damage_buff_mult++
	else if(missing_hp <= 0.50)
		damage_buff_mult++
	else if(missing_hp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.physiology.red_mod -= total_damage_buff
	human_parent.physiology.white_mod -= total_damage_buff
	human_parent.physiology.black_mod -= total_damage_buff
	human_parent.physiology.pale_mod -= total_damage_buff

/datum/component/augment/struggling_strength/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	human_parent.physiology.red_mod += total_damage_buff
	human_parent.physiology.white_mod += total_damage_buff
	human_parent.physiology.black_mod += total_damage_buff
	human_parent.physiology.pale_mod += total_damage_buff
	total_damage_buff = 0
	damage_buff_mult = 0

//On Kill Effects
/datum/component/augment/absorption/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, click_parameters, obj/item/item)
	if(last_target.stat == DEAD)
		var/justice_mod = 1 + (get_modified_attribute_level(human_parent, JUSTICE_ATTRIBUTE)/100)
		var/total_damage = item.force * justice_mod
		human_parent.adjustBruteLoss(-1*total_damage)
		to_chat(human_parent, span_nicegreen("Your body regenerates has you execute [target]!"))
	. = ..()

/datum/component/augment/brutalize
	var/kill_damage = 15

/datum/component/augment/brutalize/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, click_parameters, obj/item/item)
	if(last_target.stat == DEAD)
		for(var/mob/living/L in urange(5, human_parent))
			if(faction_check(human_parent.faction, L.faction)) // I LOVE NESTING IF STATEMENTS
				continue
			L.deal_damage(kill_damage * repeat, WHITE_DAMAGE)
		new /obj/effect/gibspawner/human/bodypartless(get_turf(target))
		to_chat(human_parent, span_nicegreen("You strike fear into your foes as you brutalize [target]!"))
	. = ..()

//Reactive Damage Effects
/datum/component/augment/struggling_defense
	var/damage_resist = 10
	var/damage_resist_mult = 0
	var/total_damage_resist = 0

/datum/component/augment/struggling_defense/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.75)
		damage_resist_mult++
	else if(missing_hp <= 0.50)
		damage_resist_mult++
	else if(missing_hp <= 0.25)
		damage_resist_mult++
	total_damage_resist = damage_resist * damage_resist_mult * repeat
	human_parent.physiology.red_mod -= total_damage_resist
	human_parent.physiology.white_mod -= total_damage_resist
	human_parent.physiology.black_mod -= total_damage_resist
	human_parent.physiology.pale_mod -= total_damage_resist

/datum/component/augment/struggling_defense/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	human_parent.physiology.red_mod += total_damage_resist
	human_parent.physiology.white_mod += total_damage_resist
	human_parent.physiology.black_mod += total_damage_resist
	human_parent.physiology.pale_mod += total_damage_resist
	total_damage_resist = 0
	damage_resist_mult = 0
