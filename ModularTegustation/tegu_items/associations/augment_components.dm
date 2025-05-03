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

/datum/component/augment/RegisterWithParent()
	. = ..()

	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, PROC_REF(attack_effect))
	RegisterSignal(parent, COMSIG_MOB_ITEM_AFTERATTACK, PROC_REF(afterattack_effect))
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(take_damage_effect)) ///datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	RegisterSignal(parent, COMSIG_MOB_AFTER_APPLY_DAMGE, PROC_REF(after_take_damage_effect)) ///datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(attackedby_mob))

/datum/component/augment/proc/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	// to_chat(parent, "Attack Effect Triggered, we attacked [target]")
	if(target.stat != DEAD)
		last_target = target

/datum/component/augment/proc/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	// to_chat(parent, "After Attack Effect Triggered, we attacked [target]")
	last_target = null

/datum/component/augment/proc/take_damage_effect(datum/source, damage, damagetype, def_zone)
	// to_chat(parent, "Take Damage Effect Triggered, You have taken [damage] [damagetype] damage!")

/datum/component/augment/proc/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	// to_chat(parent, "Take After Damage Effect Triggered, You have taken [damage] [damagetype] damage!")

/datum/component/augment/proc/attackedby_mob(datum/source, mob/living/simple_animal/animal)
	// to_chat(parent, "Attackby Mob Effect Triggered, attacked by [animal]")

/datum/component/augment/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_MOB_ITEM_AFTERATTACK, COMSIG_MOB_APPLY_DAMGE,
	 COMSIG_MOB_AFTER_APPLY_DAMGE, COMSIG_ATOM_ATTACK_ANIMAL))


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
	if(item.force <= 0 || target.stat == DEAD)
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
	if(item.force <= 0 || target.stat == DEAD)
		return FALSE
	regen_cooldown = world.time + regen_cooldown_time
	H.adjustSanityLoss(amount * repeat)
	to_chat(H, span_nicegreen("Your mind stabilizes as you rip into [target]!"))

//Struggling Strength
/datum/component/augment/struggling_strength
	var/damage_buff = 5
	var/damage_buff_mult = 0
	var/total_damage_buff = 0

/datum/component/augment/struggling_strength/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.875)
		damage_buff_mult++
	if(missing_hp <= 0.75)
		damage_buff_mult++
	if(missing_hp <= 0.625)
		damage_buff_mult++
	if(missing_hp <= 0.50)
		damage_buff_mult++
	if(missing_hp <= 0.375)
		damage_buff_mult++
	if(missing_hp <= 0.25)
		damage_buff_mult++
	if(missing_hp <= 0.125)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage += total_damage_buff
	to_chat(human_parent, span_nicegreen("You deal [total_damage_buff]% more damage!, Due to Struggling Strength"))

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
	if(item.force <= 0 || target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	to_chat(human_parent, span_nicegreen("You inflict 3 BLACK fragility to [target], Due to Armor Rend, RED!"))
	target.apply_lc_black_fragile(3)

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
	if(item.force <= 0 || target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	to_chat(human_parent, span_nicegreen("You inflict 3 RED fragility to [target], Due to Armor Rend, BLACK!"))
	target.apply_lc_red_fragile(3)

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
	if(missing_sp <= 0.50)
		damage_buff_mult++
	if(missing_sp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage_red += total_damage_buff
	if(item.damtype == RED_DAMAGE)
		to_chat(human_parent, span_nicegreen("You dealt [total_damage_buff]% more RED damage! Due to Shattering Mind, RED"))

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
	if(missing_sp <= 0.50)
		damage_buff_mult++
	if(missing_sp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage_white += total_damage_buff
	if(item.damtype == WHITE_DAMAGE)
		to_chat(human_parent, span_nicegreen("You dealt [total_damage_buff]% more WHITE damage! Due to Shattering Mind, WHITE"))

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
	if(missing_sp <= 0.50)
		damage_buff_mult++
	if(missing_sp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage_black += total_damage_buff
	if(item.damtype == BLACK_DAMAGE)
		to_chat(human_parent, span_nicegreen("You dealt [total_damage_buff]% more BLACK damage! Due to Shattering Mind, BLACK"))

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
		to_chat(human_parent, span_nicegreen("You savagely attack [target], losing a bit of your mind... Due to Unstable"))
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
	if(item.force <= 0 || target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_bleed(2)
	to_chat(human_parent, span_nicegreen("You inflict 2 bleed to [target]! Due to Gashing Wounds"))

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
	if(item.force <= 0 || target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_overheat(3)
	to_chat(human_parent, span_nicegreen("You inflict 3 burn to [target]! Due to Scorching Mind"))

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
	if(item.force <= 0 || target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	target.apply_lc_tremor(2, 55)
	to_chat(human_parent, span_nicegreen("You inflict 2 tremor to [target]! Due to Slothful Decay"))
	if(item.attack_speed >= 1.5)
		target.apply_lc_tremor(2, 55)
		to_chat(human_parent, span_nicegreen("You inflict 2 tremor to [target]! Due to Slothful Decay"))
//Strong Arms
/datum/component/augment/dual_wield
	var/inflict_cooldown
	var/inflict_cooldown_time = 40

/datum/component/augment/dual_wield/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(inflict_cooldown < world.time)
		for(var/obj/item/ego_weapon/W in human_parent.held_items)
			if(W == item)
				continue
			else if(W.CanUseEgo(human_parent))
				inflict_cooldown = world.time + inflict_cooldown_time * W.attack_speed
				if(last_target in view(W.reach, human_parent))
					playsound(W.loc, W.hitsound)
					human_parent.do_attack_animation(last_target, null, W)
					last_target.attacked_by(W, human_parent)
					log_combat(human_parent, target, pick(W.attack_verb_continuous), W.name, "(INTENT: [uppertext(human_parent.a_intent)]) (DAMTYPE: [uppertext(W.damtype)])")
	. = ..()

//Strong Grip
/datum/component/augment/strong_grip
	var/obj/item/gripped_item

/datum/component/augment/strong_grip/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	if(human_parent.a_intent == INTENT_HARM)
		gripped_item = human_parent.get_active_held_item()
		to_chat(human_parent, span_nicegreen("You tighten your grip on [gripped_item] due to you having HARM INTENT on! Due to Strong Grip"))
		ADD_TRAIT(gripped_item, TRAIT_NODROP, src)
	else
		REMOVE_TRAIT(gripped_item, TRAIT_NODROP, src)
		to_chat(human_parent, span_nicegreen("You release your grip on [gripped_item] due to you not having HARM INTENT on! Due to Strong Grip"))
		gripped_item = null

///On Kill Effects

//Absorption
/datum/component/augment/absorption/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		var/justice_mod = 1 + (get_modified_attribute_level(human_parent, JUSTICE_ATTRIBUTE)/100)
		var/total_damage = item.force * justice_mod
		if(total_damage > 50)
			total_damage = 50
		human_parent.adjustBruteLoss(-1*total_damage)
		to_chat(human_parent, span_nicegreen("Your body regenerates has you execute [target]! Due to Absorption"))
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
		to_chat(human_parent, span_nicegreen("You strike fear into your foes as you brutalize [target]! Due to Brutalize"))
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
		to_chat(human_parent, span_nicegreen("You heal [potential_target] as you execute [target]! Due to Flesh-Morphing"))
	. = ..()

///Reactive Damage Effects

/datum/component/augment/resisting_augment
	var/total_damage_resist = 0
	var/armor_changed = FALSE
	var/can_update_armor = TRUE

/datum/component/augment/resisting_augment/proc/get_total_damage_resist(datum/source, damage, damagetype, def_zone)
	return 0

/datum/component/augment/resisting_augment/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(can_update_armor)
		can_update_armor = FALSE
		var/armor = human_parent.getarmor(null, damagetype)
		total_damage_resist = get_total_damage_resist(source, damage, damagetype, def_zone)

		if (armor > 0)
			if (armor > 95)
				total_damage_resist = 0
			else if((total_damage_resist + armor) > 95)
				total_damage_resist = armor - 95

			armor += total_damage_resist
			switch(damagetype)
				if (RED_DAMAGE)
					human_parent.physiology.armor.setRating(red=armor)
				if (WHITE_DAMAGE)
					human_parent.physiology.armor.setRating(white=armor)
				if (BLACK_DAMAGE)
					human_parent.physiology.armor.setRating(black=armor)
				if (PALE_DAMAGE)
					human_parent.physiology.armor.setRating(pale=armor)
			armor_changed = TRUE
			return

		// if mod < 5% - DO NOT CHANGE IT
		// IF mod - res < 5% change mod to 5% and remember the res
		switch(damagetype)
			if (RED_DAMAGE)
				if (human_parent.physiology.red_mod < 0.05)
					total_damage_resist = 0
				else if((human_parent.physiology.red_mod - total_damage_resist) < 0.05)
					total_damage_resist = human_parent.physiology.red_mod - 0.05
				human_parent.physiology.red_mod -= total_damage_resist
			if (WHITE_DAMAGE)
				if (human_parent.physiology.white_mod < 0.05)
					total_damage_resist = 0
				else if((human_parent.physiology.white_mod - total_damage_resist) < 0.05)
					total_damage_resist = human_parent.physiology.white_mod - 0.05
				human_parent.physiology.white_mod -= total_damage_resist
			if (BLACK_DAMAGE)
				if (human_parent.physiology.black_mod < 0.05)
					total_damage_resist = 0
				else if((human_parent.physiology.black_mod - total_damage_resist) < 0.05)
					total_damage_resist = human_parent.physiology.black_mod - 0.05
				human_parent.physiology.black_mod -= total_damage_resist
			if (PALE_DAMAGE)
				if (human_parent.physiology.pale_mod < 0.05)
					total_damage_resist = 0
				else if((human_parent.physiology.pale_mod - total_damage_resist) < 0.05)
					total_damage_resist = human_parent.physiology.pale_mod - 0.05
				human_parent.physiology.pale_mod -= total_damage_resist

/datum/component/augment/resisting_augment/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if (armor_changed)
		var/armor = human_parent.getarmor(null, damagetype) - total_damage_resist
		switch(damagetype)
			if (RED_DAMAGE)
				human_parent.physiology.armor.setRating(red=armor)
			if (WHITE_DAMAGE)
				human_parent.physiology.armor.setRating(white=armor)
			if (BLACK_DAMAGE)
				human_parent.physiology.armor.setRating(black=armor)
			if (PALE_DAMAGE)
				human_parent.physiology.armor.setRating(pale=armor)
		can_update_armor = TRUE
		return

	switch(damagetype)
		if (RED_DAMAGE)
			human_parent.physiology.red_mod += total_damage_resist
		if (WHITE_DAMAGE)
			human_parent.physiology.white_mod += total_damage_resist
		if (BLACK_DAMAGE)
			human_parent.physiology.black_mod += total_damage_resist
		if (PALE_DAMAGE)
			human_parent.physiology.pale_mod += total_damage_resist
	can_update_armor = TRUE

//Struggling Defense
/datum/component/augment/resisting_augment/struggling_defense
	var/damage_resist = 0.05

/datum/component/augment/resisting_augment/struggling_defense/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	to_chat(human_parent, span_nicegreen("You take [total_damage_resist * 100]% less damage! Due to Struggling Defense"))

/datum/component/augment/resisting_augment/struggling_defense/get_total_damage_resist(datum/source, damage, damagetype, def_zone)
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	var/damage_resist_mult = 0
	if(missing_hp <= 0.875)
		damage_resist_mult++
	if(missing_hp <= 0.75)
		damage_resist_mult++
	if(missing_hp <= 0.625)
		damage_resist_mult++
	if(missing_hp <= 0.50)
		damage_resist_mult++
	if(missing_hp <= 0.375)
		damage_resist_mult++
	if(missing_hp <= 0.25)
		damage_resist_mult++
	if(missing_hp <= 0.125)
		damage_resist_mult++
	return damage_resist * damage_resist_mult * repeat

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
	to_chat(human_parent, span_nicegreen("Emergency RED Shields, Activated!"))

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
	to_chat(human_parent, span_nicegreen("Emergency BLACK Shields, Activated!"))

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
	to_chat(human_parent, span_nicegreen("Emergency WHITE Shields, Activated!"))

//Defensive Preparations
/datum/component/augment/defensive_preparations
	var/defense_cooldown
	var/defense_cooldown_time = 600

/datum/component/augment/defensive_preparations/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(defense_cooldown > world.time)
		return FALSE
	defense_cooldown = world.time + defense_cooldown_time
	to_chat(human_parent, span_nicegreen("You protect all nearby allies! Due to Defensive Preparations"))
	for(var/mob/living/carbon/human/H in urange(4, human_parent))
		to_chat(H, span_nicegreen("You feel protected by [human_parent], gaining 4 Protection!"))
		H.apply_lc_protection(4)

//Reinforcement Nanties
/datum/component/augment/resisting_augment/reinforcement_nanties
	var/damage_resist = 0.05

/datum/component/augment/resisting_augment/reinforcement_nanties/get_total_damage_resist(datum/source, damage, damagetype, def_zone)
	var/damage_resist_mult = 0
	for(var/mob/living/carbon/human/H in view(7, human_parent))
		damage_resist_mult++
	var/resist = damage_resist * damage_resist_mult * repeat
	if(resist > 40)
		resist = 40
	return resist

/datum/component/augment/resisting_augment/reinforcement_nanties/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()

	to_chat(human_parent, span_nicegreen("You took [total_damage_resist*100]% less damage! Due to Reinforcement Nanties"))

//Stalwart Form
/datum/component/augment/stalwart_form/Initialize()
	. = ..()
	human_parent.physiology.stun_mod -= 0.9
	human_parent.physiology.red_mod += 0.15
	human_parent.physiology.black_mod += 0.15

/datum/component/augment/stalwart_form/Destroy()
	. = ..()
	human_parent.physiology.stun_mod += 0.9
	human_parent.physiology.red_mod -= 0.15
	human_parent.physiology.black_mod -= 0.15

///Status

//Double check if vigors work
//Make augments work with gauntlets
//Time Mortarium and Reflictive Tremor

//Burn Vigor
/datum/component/augment/burn_vigor
	var/damage_buff = 10
	var/total_damage_buff = 0

/datum/component/augment/burn_vigor/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_overheat/UB = user.has_status_effect(/datum/status_effect/stacking/lc_overheat)
	if(UB)
		total_damage_buff = round(UB.stacks/5) * damage_buff * repeat
	else
		total_damage_buff = 0
	human_parent.extra_damage += total_damage_buff
	to_chat(human_parent, span_nicegreen("You dealt [total_damage_buff]% more damage! Due to Burn Vigor"))

/datum/component/augment/burn_vigor/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage -= total_damage_buff
	total_damage_buff = 0

//Burn Vigor
/datum/component/augment/bleed_vigor
	var/damage_buff = 10
	var/total_damage_buff = 0

/datum/component/augment/bleed_vigor/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_bleed/UB = user.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(UB)
		total_damage_buff = round(UB.stacks/5) * damage_buff * repeat
	else
		total_damage_buff = 0
	human_parent.extra_damage += total_damage_buff
	to_chat(human_parent, span_nicegreen("You dealt [total_damage_buff]% more damage! Due to Bleed Vigor"))

/datum/component/augment/bleed_vigor/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage -= total_damage_buff
	total_damage_buff = 0

//Tremor Defense
/datum/component/augment/resisting_augment/tremor_defense
	var/damage_resist = 0.05

/datum/component/augment/resisting_augment/tremor_defense/get_total_damage_resist(datum/source, damage, damagetype, def_zone)
	var/datum/status_effect/stacking/lc_tremor/UT = human_parent.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	var/resist = 0
	if(UT && (damagetype == RED_DAMAGE || damagetype == BLACK_DAMAGE))
		resist = round(UT.stacks/10) * damage_resist * repeat
	if(resist > (0.3 + (0.2 * (repeat - 1))))
		resist = 0.3 + (0.2 * (repeat - 1))

	return resist

/datum/component/augment/resisting_augment/tremor_defense/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	to_chat(human_parent, span_nicegreen("You took [total_damage_resist * 100]% less damage! Due to Tremor Defense"))

//Earthquake
/datum/component/augment/earthquake
	var/inflict_cooldown
	var/inflict_cooldown_time = 300

/datum/component/augment/earthquake/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/TT = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(TT)
		if(TT.stacks >= 20)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			TT.TremorBurst()
			new /obj/effect/temp_visual/explosion(get_turf(target))
			playsound(get_turf(target), 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
			for(var/mob/living/simple_animal/hostile/H in view(3, target))
				H.apply_damage((TT.stacks * 6), RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE))

//Tremor Break
/datum/component/augment/tremor_break
	var/inflict_cooldown
	var/inflict_cooldown_time = 300

/datum/component/augment/tremor_break/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/TT = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(TT)
		if(TT.stacks >= 15)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			TT.TremorBurst()
			target.apply_lc_feeble(round(TT.stacks/5))
			to_chat(human_parent, span_nicegreen("You inflicted [round(TT.stacks/5)] feeble to [target]! Due to Tremor Break"))

//Tremor Break
/datum/component/augment/tremor_burst
	var/inflict_cooldown
	var/inflict_cooldown_time = 100

/datum/component/augment/tremor_burst/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/TT = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(TT)
		if(TT.stacks >= 10)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			TT.TremorBurst()

//Reflective Tremor
/datum/component/augment/reflective_tremor
	var/inflict_cooldown
	var/inflict_cooldown_time = 10

/datum/component/augment/reflective_tremor/attackedby_mob(datum/source, mob/living/simple_animal/animal)
	. = ..()
	if(animal.melee_damage_type == RED_DAMAGE || animal.melee_damage_type == BLACK_DAMAGE)
		if(inflict_cooldown > world.time)
			return FALSE
		inflict_cooldown = world.time + inflict_cooldown_time
		animal.apply_lc_tremor(repeat * 2, 55)
		human_parent.apply_lc_tremor(repeat, 55)
		to_chat(human_parent, span_nicegreen("You inflicted [repeat * 2] tremor to [animal], and gained [repeat] tremor! Due to Reflective Tremor"))

//Blood Jaunt
/datum/component/augment/blood_jaunt
	var/inflict_cooldown
	var/inflict_cooldown_time = 600

/datum/component/augment/blood_jaunt/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	if(human_parent.a_intent != INTENT_HARM)
		return FALSE
	if(get_dist(human_parent, target) > 3)
		return FALSE
	if(inflict_cooldown > world.time)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	new /obj/effect/temp_visual/dir_setting/cult/phase/out (get_turf(human_parent))
	human_parent.forceMove(get_turf(target))
	new /obj/effect/temp_visual/dir_setting/cult/phase (get_turf(human_parent))
	playsound(src, 'sound/magic/exit_blood.ogg', 100, FALSE, 4)
	human_parent.apply_lc_bleed(10)
	for(var/mob/living/simple_animal/hostile/H in view(2, human_parent))
		H.apply_lc_bleed(10)

//Sanguine Desire
/datum/component/augment/sanguine_desire
	var/inflict_cooldown
	var/inflict_cooldown_time = 100

/datum/component/augment/sanguine_desire/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_bleed/TB = target.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(TB)
		if(inflict_cooldown > world.time)
			return FALSE
		if(item.force <= 0 || target.stat == DEAD)
			return FALSE
		inflict_cooldown = world.time + inflict_cooldown_time
		human_parent.adjustSanityLoss(-3 + (target.status_effects.len * -2))
		to_chat(human_parent, span_nicegreen("You healed [-3 + (target.status_effects.len * -2)] SP! Due to Sanguine Desire"))

//Pyromaniac
/datum/component/augment/pyromaniac/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_overheat/UB = user.has_status_effect(/datum/status_effect/stacking/lc_overheat)
	if(UB)
		if(UB.stacks >= 5)
			target.apply_lc_overheat(2)
			UB.stacks -= 2
			to_chat(human_parent, span_nicegreen("You transferred 2 burn to [target]! Due to Pyromaniac"))

//Hemomaniac
/datum/component/augment/hemomaniac/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_bleed/UB = user.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(UB)
		if(UB.stacks >= 5)
			target.apply_lc_bleed(2)
			UB.stacks -= 2
			to_chat(human_parent, span_nicegreen("You transferred 2 bleed to [target]! Due to Hemomaniac"))

//Spreading Embers
/datum/component/augment/spreading_embers
	var/inflict_cooldown
	var/inflict_cooldown_time = 300

/datum/component/augment/spreading_embers/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_overheat/TB = target.has_status_effect(/datum/status_effect/stacking/lc_overheat)
	if(TB)
		if(TB.stacks >= 10)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			to_chat(human_parent, span_userdanger("You incinerate [target]! Due to Spreading Embers"))
			playsound(target, 'sound/abnormalities/crying_children/attack_aoe.ogg', 50, TRUE)
			human_parent.apply_lc_overheat(15)
			for(var/mob/living/simple_animal/hostile/H in view(2, target))
				H.apply_lc_overheat(10)

//Regenerative Warmth
/datum/component/augment/regenerative_warmth/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(damagetype != BURN)
		return FALSE
	human_parent.adjustBruteLoss(-damage/2)
	human_parent.adjustFireLoss(-damage/2)
	to_chat(human_parent, span_nicegreen("You regenerate [damage/2] HP from the burn! Due to Regenerative Warmth"))

//Stoneward Form
/datum/component/augment/stoneward_form
	var/inflict_cooldown
	var/inflict_cooldown_time = 300

/datum/component/augment/stoneward_form/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	var/list/available_turfs = list()
	for(var/turf/T in view(2, human_parent.loc))
		if(isfloorturf(T) && !T.density && !locate(/mob/living) in T)
			available_turfs += T
	human_parent.visible_message("<span class='danger'>[human_parent] starts spawning a statue! Due to Stoneward Form</span>")
	if(available_turfs.len)
		var/turf/statue_turf = pick(available_turfs)
		var/mob/living/simple_animal/hostile/stoneward_statue/S = new /mob/living/simple_animal/hostile/stoneward_statue(statue_turf)
		S.icon_state = "memory_statute_grow" // Set the initial icon state to the rising animation
		flick("memory_statute_grow", S) // Play the rising animation
		spawn(10) // Wait for the animation to finish
			S.icon_state = initial(S.icon_state) // Set the icon state back to the default statue icon
		human_parent.visible_message("<span class='danger'>[human_parent] spawns a statue. </span>")

/mob/living/simple_animal/hostile/stoneward_statue
	name = "Stoneward Statue"
	desc = "A statue created by an Augment User."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "memory_statute"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	health = 100
	maxHealth = 100
	speed = 0
	move_resist = INFINITY
	mob_size = MOB_SIZE_HUGE
	var/heal_cooldown = 50
	var/heal_timer
	var/heal_per_tick = 10
	var/self_destruct_timer

/mob/living/simple_animal/hostile/stoneward_statue/Initialize()
	. = ..()
	heal_timer = addtimer(CALLBACK(src, .proc/heal), heal_cooldown, TIMER_STOPPABLE)
	self_destruct_timer = addtimer(CALLBACK(src, .proc/self_destruct), 0.5 MINUTES, TIMER_STOPPABLE)
	AIStatus = AI_OFF
	stop_automated_movement = TRUE
	anchored = TRUE

/mob/living/simple_animal/hostile/stoneward_statue/Destroy()
	deltimer(heal_timer)
	deltimer(self_destruct_timer)
	return ..()

/mob/living/simple_animal/hostile/stoneward_statue/proc/self_destruct()
	visible_message("<span class='danger'>The statue crumbles and self-destructs!</span>")
	qdel(src)

/mob/living/simple_animal/hostile/stoneward_statue/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(health <= 0)
		visible_message("<span class='danger'>The statue crumbles into pieces!</span>")
		qdel(src)

/mob/living/simple_animal/hostile/stoneward_statue/proc/heal()
	for(var/mob/living/carbon/human/H in view(2, src))
		H.adjustBruteLoss(-heal_per_tick)
		H.apply_lc_tremor(3, 55)
	visible_message("<span class='notice'>The statue heals everyone around it!</span>")
	playsound(src, 'sound/abnormalities/rosesign/rose_summon.ogg', 75, TRUE, 2)
	icon_state = "memory_statute_heal" // Set the initial icon state to the rising animation
	flick("memory_statute_heal", src) // Play the rising animation
	spawn(10) // Wait for the animation to finish
		icon_state = initial(icon_state) // Set the icon state back to the default statue icon
	heal_timer = addtimer(CALLBACK(src, .proc/heal), heal_cooldown, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/stoneward_statue/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/stoneward_statue/CanAttack(atom/the_target)
	return FALSE

//Ink Over
/datum/component/augment/ink_over
	var/damage_buff = 10
	var/total_damage_buff = 0

/datum/component/augment/ink_over/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_bleed/TB = target.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(TB)
		total_damage_buff += (damage_buff * 2)
		total_damage_buff += (target.status_effects.len - 1) * damage_buff
		human_parent.extra_damage += total_damage_buff
		to_chat(human_parent, span_nicegreen("You dealt [total_damage_buff]% more damage to [target]! Due to Ink Over"))
	else
		total_damage_buff = 0

/datum/component/augment/ink_over/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage -= total_damage_buff
	total_damage_buff = 0

//Blood Rush
/datum/component/augment/blood_rush
	var/blood_rush_timer

/datum/component/augment/blood_rush/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		human_parent.apply_lc_bleed(5)
		to_chat(human_parent, span_nicegreen("You accelerate as you execute [last_target]! Due to Blood Rush"))
		if(blood_rush_timer)
			deltimer(blood_rush_timer)
		else
			human_parent.add_movespeed_modifier(/datum/movespeed_modifier/blood_rush)
		blood_rush_timer = addtimer(CALLBACK(src, PROC_REF(remove_rush)), 50, TIMER_STOPPABLE)
	. = ..()

/datum/component/augment/blood_rush/proc/remove_rush()
	human_parent.remove_movespeed_modifier(/datum/movespeed_modifier/blood_rush)

/datum/movespeed_modifier/blood_rush
	variable = TRUE
	multiplicative_slowdown = -1.5

//Time Moratorium
/datum/component/augment/time_moratorium
	var/inflict_cooldown
	var/inflict_cooldown_time = 300

/datum/component/augment/time_moratorium/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/TT = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(TT)
		if(TT.stacks >= 15)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			TT.TremorBurst()
			TT.stacks -= 10
			new /obj/effect/timestop(get_turf(target), 2, 40, list(human_parent))

//Tremor Everlasting
/datum/component/augment/tremor_everlasting
	var/inflict_cooldown
	var/inflict_cooldown_time = 300

/datum/component/augment/tremor_everlasting/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/TT = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(TT)
		if(TT.stacks >= 10)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			TT.TremorBurst()
			target.apply_lc_tremor(TT.stacks*0.5, 55)
			to_chat(human_parent, span_nicegreen("You preformed a tremor burst on target and inflicted [TT.stacks*0.5] tremor! Due to Tremor Everlasting"))

//Tremor Deterioration
/datum/component/augment/tremor_deterioration
	var/inflict_cooldown
	var/inflict_cooldown_time = 25

/datum/component/augment/tremor_deterioration/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/UT = human_parent.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(UT)
		if(UT.stacks >= 4)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			UT.stacks -= 3
			var/justice_mod = 1 + (get_modified_attribute_level(human_parent, JUSTICE_ATTRIBUTE)/100)
			var/total_damage = item.force * justice_mod * 0.5
			for(var/mob/living/simple_animal/hostile/H in view(1, target))
				H.deal_damage(total_damage, item.damtype)
				H.apply_lc_tremor(repeat, 55)
			to_chat(human_parent, span_nicegreen("You consumed 3 tremor from yourself, deal an 3x3 AoE around your target! Due to Tremor Deterioration"))

//Vibroweld Morph-combat effect
/datum/component/augment/vibroweld_morph_combat_effect
	var/inflict_cooldown
	var/inflict_cooldown_time = 300

/datum/component/augment/vibroweld_morph_combat_effect/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/UT = human_parent.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	var/datum/status_effect/stacking/lc_tremor/TT = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(UT && TT)
		if(UT.stacks >= 16)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			UT.stacks -= 15
			TT.TremorBurst()
			TT.TremorBurst()
			TT.TremorBurst()
			to_chat(human_parent, span_nicegreen("You consumed 15 tremor from yourself, to perform 3 Tremor Bursts on the target! Due to Vibroweld Morph-combat effect"))

//Tremor Ruin
/datum/component/augment/tremor_ruin
	var/inflict_cooldown
	var/inflict_cooldown_time = 150

/datum/component/augment/tremor_ruin/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/datum/status_effect/stacking/lc_tremor/TT = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(TT)
		if(TT.stacks >= 10)
			if(inflict_cooldown > world.time)
				return FALSE
			if(item.force <= 0 || target.stat == DEAD)
				return FALSE
			inflict_cooldown = world.time + inflict_cooldown_time
			TT.TremorBurst()
			target.apply_lc_black_fragile(round(TT.stacks/5))
			to_chat(human_parent, span_nicegreen("You inflicted [round(TT.stacks/5)] black fragile to [target]! Due to Tremor Ruin"))

//Rekindled Flame
/datum/component/augment/rekindled_flame
	var/inflict_buff_mult = 0

/datum/component/augment/rekindled_flame/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.75)
		inflict_buff_mult++
	else if(missing_hp <= 0.50)
		inflict_buff_mult++
	else if(missing_hp <= 0.25)
		inflict_buff_mult++
	target.apply_lc_overheat(inflict_buff_mult * repeat)
	to_chat(human_parent, span_nicegreen("You inflict [inflict_buff_mult * repeat] burn to [target]! Due to Rekindled Flame"))
	inflict_buff_mult = 0

//Force of a Wildfire
/datum/component/augment/force_of_a_wildfire/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		var/datum/status_effect/stacking/lc_overheat/TB = last_target.has_status_effect(/datum/status_effect/stacking/lc_overheat)
		if(TB)
			for(var/mob/living/simple_animal/hostile/H in view(3, human_parent))
				H.apply_lc_overheat(TB.stacks)
	. = ..()

//Unstable Inertia
/datum/component/augment/unstable_inertia
	var/inflict_mult = 0

/datum/component/augment/unstable_inertia/attackedby_mob(datum/source, mob/living/simple_animal/animal)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.75)
		inflict_mult++
	else if(missing_hp <= 0.50)
		inflict_mult++
	else if(missing_hp <= 0.25)
		inflict_mult++
	animal.apply_lc_tremor(repeat * inflict_mult, 55)
	to_chat(human_parent, span_nicegreen("You inflict [repeat * inflict_mult] tremor to [animal]! Due to Unstable Inertia"))
	inflict_mult = 0

//Blood Cycler
/datum/component/augment/blood_cycler/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_STATUS_BLEED_DAMAGE, PROC_REF(bleed_regen))

/datum/component/augment/blood_cycler/proc/bleed_regen(datum/source, mob/living/bleeder, bleed_stack)
	if(get_dist(human_parent, bleeder) > 4)
		return FALSE
	var/regen_amount = bleed_stack/2
	if(!ishuman(bleeder))
		regen_amount *= 4
	if(regen_amount > 100)
		regen_amount = 100
	human_parent.adjustBruteLoss(-regen_amount)
	to_chat(human_parent, span_nicegreen("You regen [regen_amount] HP due to [bleeder] bleeding! Due to Blood Cycler"))

/datum/component/augment/blood_cycler/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_STATUS_BLEED_DAMAGE)

//Acidic Blood
/datum/component/augment/acidic_blood/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_STATUS_BLEED_DAMAGE, PROC_REF(bleed_regen))

/datum/component/augment/acidic_blood/proc/bleed_regen(datum/source, mob/living/bleeder, bleed_stack)
	if(human_parent != bleeder)
		return FALSE
	for(var/mob/living/simple_animal/S in view(3, human_parent))
		S.deal_damage(bleed_stack * 2 * repeat, BLACK_DAMAGE)
	to_chat(human_parent, span_nicegreen("You dealt [bleed_stack * 4] BLACK damage to all nearby mobs due to you bleeding! Due to Acidic Blood"))

//Reclaimed Flame
/datum/component/augment/reclaimed_flame
	var/blood_rush_timer

/datum/component/augment/reclaimed_flame/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		human_parent.adjustFireLoss(-20 * repeat)
		to_chat(human_parent, span_nicegreen("You heal some BURN damage as you execute [last_target]! Due to Reclaimed Flame"))
	. = ..()

//Cooling Systems
/datum/component/augment/cooling_systems/Initialize()
	. = ..()
	human_parent.physiology.burn_mod -= 0.75
	human_parent.physiology.red_mod += 0.25

/datum/component/augment/cooling_systems/Destroy()
	. = ..()
	human_parent.physiology.burn_mod += 0.75
	human_parent.physiology.red_mod -= 0.25

//Fireproof
/datum/component/augment/fireproof
	var/proofing_fire = FALSE

/datum/component/augment/fireproof/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	var/missing_hp = ((human_parent.health - damage)/human_parent.maxHealth)
	if(missing_hp <= 0.15 && damagetype == BURN)
		human_parent.physiology.burn_mod -= 1
		proofing_fire = TRUE
		to_chat(human_parent, span_nicegreen("You ignore the BURN damage, due to being under or equal 15% health! Due to Fireproof"))

/datum/component/augment/fireproof/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(proofing_fire)
		human_parent.physiology.burn_mod += 1
		proofing_fire = FALSE

///Downsides

//Paranoid
/datum/component/augment/paranoid
	var/nearby_human = FALSE

/datum/component/augment/paranoid/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	for(var/mob/living/carbon/human/H in view(7, human_parent))
		if(H.stat == DEAD)
			continue
		nearby_human = TRUE
	if(!nearby_human)
		to_chat(human_parent, span_warning("You take 10 WHITE damage, as there are no humans near you! Due to Paranoid"))
		human_parent.deal_damage(10, WHITE_DAMAGE)

/datum/component/augment/paranoid/after_take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	nearby_human = FALSE

//Boot Up Sequence
/datum/component/augment/bus
	var/inflict_cooldown
	var/inflict_cooldown_time = 60

/datum/component/augment/bus/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(inflict_cooldown > world.time)
		return FALSE
	if(!ishuman(parent))
		return FALSE
	var/mob/living/carbon/human/H = parent
	if(item.force <= 0 || target.stat == DEAD)
		return FALSE
	inflict_cooldown = world.time + inflict_cooldown_time
	to_chat(H, span_warning("You gain 3 Feeble, as you start combat! Due to Boot Up Sequence"))
	H.apply_lc_feeble(3)

//Pacifist
/datum/component/augment/pacifist/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	if(last_target.stat == DEAD)
		human_parent.apply_lc_feeble(3)
		to_chat(human_parent, span_warning("You gain 3 Feeble, as execute [last_target]! Due to Pacifist"))
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
	to_chat(human_parent, span_warning("As you take damage under 50% HP, you also take 10 WHITE damage! Due to Thanatophobia"))

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
	if(missing_hp <= 0.50)
		damage_buff_mult++
	if(missing_hp <= 0.25)
		damage_buff_mult++
	total_damage_buff = damage_buff * damage_buff_mult * repeat
	human_parent.extra_damage -= total_damage_buff
	to_chat(human_parent, span_warning("You deal [total_damage_buff]% less damage! Due to Struggling Weakness"))

/datum/component/augment/struggling_weakness/afterattack_effect(datum/source, atom/target, mob/user, proximity_flag, obj/item/item)
	. = ..()
	human_parent.extra_damage += total_damage_buff
	total_damage_buff = 0
	damage_buff_mult = 0

//Struggling Fragility
/datum/component/augment/struggling_fragility
	var/damage_resist = 0.1
	var/damage_resist_mult = 0
	var/total_damage_resist = 0

/datum/component/augment/struggling_fragility/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	var/missing_hp = (human_parent.health/human_parent.maxHealth)
	if(missing_hp <= 0.75)
		damage_resist_mult++
	if(missing_hp <= 0.50)
		damage_resist_mult++
	if(missing_hp <= 0.25)
		damage_resist_mult++
	total_damage_resist = damage_resist * damage_resist_mult * repeat
	human_parent.physiology.red_mod += total_damage_resist
	human_parent.physiology.white_mod += total_damage_resist
	human_parent.physiology.black_mod += total_damage_resist
	human_parent.physiology.pale_mod += total_damage_resist
	to_chat(human_parent, span_warning("You take [total_damage_resist*10]% more damage! Due to Struggling Fragility"))

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
		human_parent.apply_lc_overheat(2 * repeat)
		to_chat(human_parent, span_warning("You gain [2 * repeat] burn! Due to Overheated"))
	if(item.force <= 0 || target.stat == DEAD)
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
	to_chat(human_parent, span_warning("You take [damage * repeat * 0.5] WHITE damage, as you take RED damage! Due to Algophobia"))

//Weak Arms
/datum/component/augment/weak_arms
	var/old_attack_speed

/datum/component/augment/weak_arms/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	old_attack_speed = item.attack_speed
	item.attack_speed = item.attack_speed * 2
	to_chat(human_parent, span_warning("Your attack is 100% slower! Due to Weak Arms"))

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
		to_chat(human_parent, span_warning("All of your nearby foes target you! Due to Annoyance"))
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
		for(var/mob/living/L in view(5, human_parent))
			SEND_SIGNAL(L, COMSIG_STATUS_BLEED_DAMAGE, human_parent, B.stacks)
		new /obj/effect/temp_visual/damage_effect/bleed(get_turf(human_parent))
		B.stacks = round(B.stacks/2)

/datum/component/augment/allodynia/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(gain_bleed_cooldown > world.time)
		return FALSE
	gain_bleed_cooldown = world.time + gain_bleed_cooldown_time
	human_parent.apply_lc_bleed(2 * repeat)
	to_chat(human_parent, span_warning("As you take damage, you gain [2 * repeat] bleed! Due to Allodynia"))

//Internal Vibrations
/datum/component/augment/internal_vibrations
	var/gain_tremor_cooldown
	var/gain_tremor_cooldown_time = 5

/datum/component/augment/internal_vibrations/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(gain_tremor_cooldown > world.time)
		return FALSE
	gain_tremor_cooldown = world.time + gain_tremor_cooldown_time
	human_parent.apply_lc_tremor(2 * repeat, 55)
	to_chat(human_parent, span_warning("As you take damage, you gain [2 * repeat] tremor! Due to Internal Vibrations"))
	if(damagetype == WHITE_DAMAGE)
		human_parent.apply_lc_tremor(2 * repeat, 55)
		to_chat(human_parent, span_warning("As you take damage, you gain [2 * repeat] tremor! Due to Internal Vibrations"))

//Scalding Skin
/datum/component/augment/scalding_skin
	var/gain_burn_cooldown
	var/gain_burn_cooldown_time = 30

/datum/component/augment/scalding_skin/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(gain_burn_cooldown > world.time)
		return FALSE
	gain_burn_cooldown = world.time + (gain_burn_cooldown_time/repeat)
	human_parent.apply_lc_overheat(round(damage/5))
	to_chat(human_parent, span_warning("As you take damage, you gain [round(damage/5)] burn! Due to Scalding Skin"))
	if(damagetype == RED_DAMAGE)
		human_parent.apply_lc_overheat(round(damage/5))
		to_chat(human_parent, span_warning("As you take damage, you gain [round(damage/5)] tremor! Due to Scalding Skin"))

//Open Wound
/datum/component/augment/open_wound
	var/tp_cooldown
	var/tp_cooldown_time = 200
	var/self_bleed = FALSE

/datum/component/augment/open_wound/take_damage_effect(datum/source, damage, damagetype, def_zone)
	. = ..()
	if(damagetype != BLACK_DAMAGE)
		return FALSE
	if(tp_cooldown > world.time)
		return FALSE
	tp_cooldown = world.time + tp_cooldown_time
	self_bleed = TRUE
	addtimer(CALLBACK(src, PROC_REF(end_wound)), 10 SECONDS)

/datum/component/augment/open_wound/attack_effect(datum/source, mob/living/target, mob/living/user, obj/item/item)
	. = ..()
	if(self_bleed)
		human_parent.apply_lc_bleed(2 * repeat)
		to_chat(human_parent, span_warning("You gain [2 * repeat] bleed! Due to Open Wound"))

/datum/component/augment/open_wound/proc/end_wound()
	self_bleed = FALSE
