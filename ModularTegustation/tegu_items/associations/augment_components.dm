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
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(take_damage_effect)) ///datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	RegisterSignal(parent, COMSIG_MOB_AFTER_APPLY_DAMGE, PROC_REF(after_take_damage_effect)) ///datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(attackedby_mob))

/datum/component/augment/proc/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	to_chat(parent, "Attack Effect Triggered, we attacked [target]")
	if(target.stat != DEAD)
		last_target = target

/datum/component/augment/proc/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	to_chat(parent, "After Attack Effect Triggered, we attacked [target]")
	last_target = null

/datum/component/augment/proc/take_damage_effect(datum/source, damage, damagetype, def_zone)
	to_chat(parent, "Take Damage Effect Triggered, You have taken [damage] [damagetype] damage!")

/datum/component/augment/proc/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	to_chat(parent, "Take After Damage Effect Triggered, You have taken [damage] [damagetype] damage!")

/datum/component/augment/proc/attackedby_mob(datum/source, mob/living/simple_animal/animal)
	to_chat(parent, "Attackby Mob Effect Triggered, attacked by [animal]")


///Attacking Effects

//Regeneration
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

//Tranquility
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

//Struggling Strength
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
	human_parent.extra_damage += total_damage_buff

/datum/component/augment/struggling_strength/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage -= total_damage_buff
	total_damage_buff = 0
	damage_buff_mult = 0

//Armor Rend, RED
/datum/component/augment/ar_red
	var/inflict_cooldown
	var/inflict_cooldown_time = 10

/datum/component/augment/ar_red/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	if(item.damtype != BLACK_DAMAGE)
		return FALSE
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_black_fragile(1)

//Armor Rend, BLACK
/datum/component/augment/ar_black
	var/inflict_cooldown
	var/inflict_cooldown_time = 10

/datum/component/augment/ar_black/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	if(item.damtype != RED_DAMAGE)
		return FALSE
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_red_fragile(1)

//Shattering Mind, RED
/datum/component/augment/shattering_mind_red
	var/damage_buff = 10
	var/damage_buff_mult = 0
	var/total_damage_buff = 0

/datum/component/augment/shattering_mind_red/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/missing_sp = (human_parent.sanityhealth/human_parent.maxSanity)
	if(missing_sp <= 0.75)
		damage_buff_mult++
	else if(missing_sp <= 0.50)
		damage_buff_mult++
	else if(missing_sp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage_red += total_damage_buff

/datum/component/augment/shattering_mind_red/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage_red -= total_damage_buff
	total_damage_buff = 0
	damage_buff_mult = 0

//Shattering Mind, WHITE
/datum/component/augment/shattering_mind_white
	var/damage_buff = 10
	var/damage_buff_mult = 0
	var/total_damage_buff = 0

/datum/component/augment/shattering_mind_white/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/missing_sp = (human_parent.sanityhealth/human_parent.maxSanity)
	if(missing_sp <= 0.75)
		damage_buff_mult++
	else if(missing_sp <= 0.50)
		damage_buff_mult++
	else if(missing_sp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage_white += total_damage_buff

/datum/component/augment/shattering_mind_white/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage_white -= total_damage_buff
	total_damage_buff = 0
	damage_buff_mult = 0

//Shattering Mind, BLACK
/datum/component/augment/shattering_mind_black
	var/damage_buff = 10
	var/damage_buff_mult = 0
	var/total_damage_buff = 0

/datum/component/augment/shattering_mind_black/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/missing_sp = (human_parent.sanityhealth/human_parent.maxSanity)
	if(missing_sp <= 0.75)
		damage_buff_mult++
	else if(missing_sp <= 0.50)
		damage_buff_mult++
	else if(missing_sp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage_black += total_damage_buff

/datum/component/augment/shattering_mind_black/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage_black -= total_damage_buff
	total_damage_buff = 0
	damage_buff_mult = 0

//Unstable
/datum/component/augment/unstable
	var/damage_buff = 30
	var/total_damage_buff = 0
	var/buffed_damage = FALSE

/datum/component/augment/unstable/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(item.damtype != BLACK_DAMAGE)
		return FALSE
	if(human_parent.sanityhealth > human_parent.maxSanity * 0.5)
		human_parent.deal_damage(human_parent.maxSanity * 0.05, WHITE_DAMAGE)
		human_parent.extra_damage_black += damage_buff
		to_chat(human_parent, span_nicegreen("You savagely attack [target]!"))
		buffed_damage = TRUE

/datum/component/augment/unstable/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	if(buffed_damage)
		human_parent.extra_damage_black -= damage_buff
		buffed_damage = FALSE

//Gashing Wounds
/datum/component/augment/gashing_wounds
	var/inflict_cooldown
	var/inflict_cooldown_time = 5

/datum/component/augment/gashing_wounds/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	if(item.damtype != RED_DAMAGE)
		return FALSE
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_bleed(2)

//Scorching Mind
/datum/component/augment/scorching_mind
	var/inflict_cooldown
	var/inflict_cooldown_time = 10

/datum/component/augment/scorching_mind/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	if(item.damtype != WHITE_DAMAGE)
		return FALSE
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_burn(3)

//Slothful Decay
/datum/component/augment/slothful_decay
	var/inflict_cooldown
	var/inflict_cooldown_time = 15

/datum/component/augment/slothful_decay/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	if(item.damtype != BLACK_DAMAGE)
		return FALSE
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_tremor(2, 55)
	if(item.attack_speed >= 1.5)
		target.apply_lc_tremor(2, 55)

//Strong Arms
/datum/component/augment/dual_wield
	var/inflict_cooldown
	var/inflict_cooldown_time = 40

/datum/component/augment/dual_wield/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(inflict_cooldown < world.time)
		if(human_parent.a_intent == INTENT_HARM)
			for(var/obj/item/ego_weapon/W in human_parent.held_items)
				if(W == item)
					continue
				else if(W.CanUseEgo(human_parent))
					inflict_cooldown = world.time + inflict_cooldown_time * W.attack_speed
					sleep(2)
					if(last_target in view(W.reach, human_parent))
						playsound(W.loc, W.hitsound)
						human_parent.do_attack_animation(last_target)
						last_target.attacked_by(W, human_parent)
						log_combat(human_parent, target, pick(W.attack_verb_continuous), W.name, "(INTENT: [uppertext(human_parent.a_intent)]) (DAMTYPE: [uppertext(W.damtype)])")
	. = ..()

///On Kill Effects

//Absorption
/datum/component/augment/absorption/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		var/justice_mod = 1 + (get_modified_attribute_level(human_parent, JUSTICE_ATTRIBUTE)/100)
		var/total_damage = item.force * justice_mod
		human_parent.adjustBruteLoss(-1*total_damage)
		to_chat(human_parent, span_nicegreen("Your body regenerates has you execute [target]!"))
	. = ..()

//Brutalize
/datum/component/augment/brutalize
	var/kill_damage = 15

/datum/component/augment/brutalize/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		for(var/mob/living/L in urange(5, human_parent))
			if(faction_check(human_parent.faction, L.faction)) // I LOVE NESTING IF STATEMENTS
				continue
			L.deal_damage(kill_damage * repeat, WHITE_DAMAGE)
		new /obj/effect/gibspawner/human/bodypartless(get_turf(target))
		to_chat(human_parent, span_nicegreen("You strike fear into your foes as you brutalize [target]!"))
	. = ..()

//Flesh-Morphing
/datum/component/augment/flesh_morphing/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		var/mob/living/carbon/potential_target
		var/potential_health_missing = 0.01
		for(var/mob/living/carbon/L in view(4, human_parent))
			if(L != human_parent && human_parent.faction_check_mob(L, FALSE) && L.stat != DEAD)
				var/missing = (L.maxHealth - L.health)/L.maxHealth
				if (missing > potential_health_missing)
					potential_target = L
					potential_health_missing = missing

		potential_target.adjustBruteLoss(last_target.maxHealth * 0.1 * repeat)
		to_chat(potential_target, span_nicegreen("You feel your flesh regrow as [human_parent] executes [target]!"))
		to_chat(human_parent, span_nicegreen("You heal [potential_target] as you execute [target]!"))
	. = ..()

///Reactive Damage Effects

//Struggling Defense
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

//Emergency Shields, RED
/datum/component/augment/ES_red
	var/ES_cooldown
	var/ES_cooldown_time = 600

/datum/component/augment/ES_red/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(human_parent.health > human_parent.maxHealth/2)
		return FALSE
	if(ES_cooldown > world.time)
		return FALSE
	ES_cooldown = world.time + ES_cooldown_time
	human_parent.apply_lc_red_protection(8)

//Emergency Shields, BLACK
/datum/component/augment/ES_black
	var/ES_cooldown
	var/ES_cooldown_time = 600

/datum/component/augment/ES_black/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(human_parent.health > human_parent.maxHealth/2)
		return FALSE
	if(ES_cooldown > world.time)
		return FALSE
	ES_cooldown = world.time + ES_cooldown_time
	human_parent.apply_lc_black_protection(8)

//Emergency Shields, White
/datum/component/augment/ES_white
	var/ES_cooldown
	var/ES_cooldown_time = 600

/datum/component/augment/ES_white/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(human_parent.sanityhealth > human_parent.maxSanity/2)
		return FALSE
	if(ES_cooldown > world.time)
		return FALSE
	ES_cooldown = world.time + ES_cooldown_time
	human_parent.apply_lc_white_protection(8)

//Defensive Preparations
/datum/component/augment/defensive_preparations
	var/defense_cooldown
	var/defense_cooldown_time = 600

/datum/component/augment/defensive_preparations/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(defense_cooldown > world.time)
		return FALSE
	defense_cooldown = world.time + defense_cooldown_time
	for(var/mob/living/carbon/human/H in urange(4, human_parent))
		H.apply_lc_protection(4)

//Reinforcement Nanties
/datum/component/augment/reinforcement_nanties
	var/damage_resist = 5
	var/damage_resist_mult = 0
	var/total_damage_resist = 0

/datum/component/augment/reinforcement_nanties/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	for(var/mob/living/carbon/human/H in view(7, human_parent))
		damage_resist_mult++
	total_damage_resist = damage_resist * damage_resist_mult * repeat
	if(total_damage_resist > 40)
		total_damage_resist = 40
	human_parent.physiology.red_mod -= total_damage_resist
	human_parent.physiology.white_mod -= total_damage_resist
	human_parent.physiology.black_mod -= total_damage_resist
	human_parent.physiology.pale_mod -= total_damage_resist

/datum/component/augment/reinforcement_nanties/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	human_parent.physiology.red_mod += total_damage_resist
	human_parent.physiology.white_mod += total_damage_resist
	human_parent.physiology.black_mod += total_damage_resist
	human_parent.physiology.pale_mod += total_damage_resist
	total_damage_resist = 0
	damage_resist_mult = 0

///Downsides

//Paranoid
/datum/component/augment/paranoid
	var/nearby_human = FALSE

/datum/component/augment/paranoid/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	for(var/mob/living/carbon/human/H in view(7, human_parent))
		nearby_human = TRUE
	if(!nearby_human)
		human_parent.deal_damage(10, WHITE_DAMAGE)

/datum/component/augment/paranoid/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	nearby_human = FALSE

//Boot Up Sequence
/datum/component/augment/bps
	var/inflict_cooldown
	var/inflict_cooldown_time = 60

/datum/component/augment/bps/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	if(!ishuman(parent))
		return FALSE
	var/mob/living/carbon/human/H = parent
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	H.apply_lc_feeble(3)

//Pacifist
/datum/component/augment/pacifist/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		human_parent.apply_lc_feeble(3)
	. = ..()

//Thanatophobia
/datum/component/augment/thanatophobia
	var/tp_cooldown
	var/tp_cooldown_time = 10

/datum/component/augment/thanatophobia/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(human_parent.health > human_parent.maxHealth/2)
		return FALSE
	if(tp_cooldown > world.time)
		return FALSE
	tp_cooldown = world.time + tp_cooldown_time
	human_parent.deal_damage(10, WHITE_DAMAGE)

//Struggling Weakness
/datum/component/augment/struggling_weakness
	var/damage_buff = 10
	var/damage_buff_mult = 0
	var/total_damage_buff = 0

/datum/component/augment/struggling_weakness/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.75)
		damage_buff_mult++
	else if(missing_hp <= 0.50)
		damage_buff_mult++
	else if(missing_hp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage -= total_damage_buff

/datum/component/augment/struggling_weakness/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage += total_damage_buff
	total_damage_buff = 0
	damage_buff_mult = 0

//Struggling Fragility
/datum/component/augment/struggling_fragility
	var/damage_resist = 10
	var/damage_resist_mult = 0
	var/total_damage_resist = 0

/datum/component/augment/struggling_fragility/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.75)
		damage_resist_mult++
	else if(missing_hp <= 0.50)
		damage_resist_mult++
	else if(missing_hp <= 0.25)
		damage_resist_mult++
	total_damage_resist = damage_resist * damage_resist_mult * repeat
	human_parent.physiology.red_mod += total_damage_resist
	human_parent.physiology.white_mod += total_damage_resist
	human_parent.physiology.black_mod += total_damage_resist
	human_parent.physiology.pale_mod += total_damage_resist

/datum/component/augment/struggling_fragility/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	human_parent.physiology.red_mod -= total_damage_resist
	human_parent.physiology.white_mod -= total_damage_resist
	human_parent.physiology.black_mod -= total_damage_resist
	human_parent.physiology.pale_mod -= total_damage_resist
	total_damage_resist = 0
	damage_resist_mult = 0

//Overheated
/datum/component/augment/overheated
	var/tp_cooldown
	var/tp_cooldown_time = 700
	var/self_burn = FALSE

/datum/component/augment/overheated/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(self_burn)
		human_parent.apply_lc_burn(2 * repeat)
	if(item.force <= 0 && target.stat == DEAD)
		return FALSE
	if(tp_cooldown > world.time)
		return FALSE
	tp_cooldown = world.time + tp_cooldown_time
	self_burn = TRUE
	addtimer(CALLBACK(src, PROC_REF(end_overheat)), 10 SECONDS)

/datum/component/augment/overheated/proc/end_overheat()
	self_burn = FALSE

//Algophobia
/datum/component/augment/algophobia
	var/tp_cooldown
	var/tp_cooldown_time = 10

/datum/component/augment/algophobia/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(damagetype != RED_DAMAGE)
		return FALSE
	if(tp_cooldown > world.time)
		return FALSE
	tp_cooldown = world.time + tp_cooldown_time
	human_parent.deal_damage(damage * repeat * 0.5, WHITE_DAMAGE)

//Weak Arms
/datum/component/augment/weak_arms
	var/old_attack_speed

/datum/component/augment/weak_arms/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	old_attack_speed = item.attack_speed
	item.attack_speed = item.attack_speed * 2

/datum/component/augment/weak_arms/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	item.attack_speed = old_attack_speed

//Annoyance
/datum/component/augment/annoyance
	var/attack_counter = 0

/datum/component/augment/annoyance/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	attack_counter++
	if(attack_counter >= 8)
		for(var/mob/living/simple_animal/hostile/H in view(3, human_parent))
			if(!H.faction_check_mob(human_parent))
				H.GiveTarget(human_parent)
		attack_counter = 0
		human_parent.apply_lc_fragile(2)

//Allodynia
/datum/component/augment/allodynia
	var/attack_counter = 0
	var/gain_bleed_cooldown
	var/gain_bleed_cooldown_time = 10
	var/bleed_damage_cooldown
	var/bleed_damage_cooldown_time = 30

/datum/component/augment/allodynia/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(bleed_damage_cooldown > world.time)
		return FALSE
	var/datum/status_effect/stacking/lc_bleed/B = human_parent.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(B.stacks > 4)
		bleed_damage_cooldown = world.time + bleed_damage_cooldown_time
		human_parent.adjustBruteLoss(max(0, B.stacks))
		to_chat(human_parent, "<span class='warning'>Your organs bleed due to your movement!!</span>")
		human_parent.playsound_local(human_parent, 'sound/effects/wounds/crackandbleed.ogg', 25, TRUE)
		new /obj/effect/temp_visual/damage_effect/bleed(get_turf(human_parent))
		B.stacks = round(B.stacks/2)

/datum/component/augment/allodynia/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(gain_bleed_cooldown > world.time)
		return FALSE
	gain_bleed_cooldown = world.time + gain_bleed_cooldown_time
	human_parent.apply_lc_bleed(2 * repeat)
