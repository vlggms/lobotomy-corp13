//A file for all melee weapons manufactured at L-corp that is not E.G.O.

//Contains ERA, clerk. and officer (?) weapons

///////////////////////
//ERA/AGENT EQUIPMENT//
///////////////////////

/obj/item/ego_weapon/city/lcorp
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20,
							PRUDENCE_ATTRIBUTE = 20,
							TEMPERANCE_ATTRIBUTE = 20,
							JUSTICE_ATTRIBUTE = 20
							)
	var/installed_shard
	var/equipped
	custom_price = 100

/obj/item/ego_weapon/city/lcorp/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/ego_weapon/city/lcorp/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/ego_weapon/city/lcorp/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("You need to put down [src] before attempting this!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src] already has an egoshard installed!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/ego_weapon/city/lcorp/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	force = egoshard.base_damage //base damage
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("The requirements to equip [src] have increased!"))
	to_chat(user, span_nicegreen("[src] has been successfully improved!"))
	icon_state = "[initial(icon_state)]_[egoshard.damage_type]"

/obj/item/ego_weapon/city/lcorp/examine(mob/user)
	. = ..()
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Emergency Response Agent"))
			. += span_notice("Due to your abilties, you get a +20 to your stats when equipping this weapon.")
	if(!installed_shard)
		. += span_warning("This weapon can be enhanced with an egoshard.")
	else
		. += span_nicegreen("It has a [installed_shard] installed.")

/obj/item/ego_weapon/city/lcorp/baton
	name = "l-corp combat baton"
	icon_state = "baton"
	desc = "A baton issued by L-Corp to those who cannot utilize E.G.O."
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/baton1.ogg'
	force = 22
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/machete
	name = "l-corp machete"
	icon_state = "machete"
	desc = "A sharp machete issued by L-Corp to those who cannot utilize E.G.O."
	hitsound = 'sound/weapons/fixer/generic/sword2.ogg'
	force = 13
	attack_speed = 0.5
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/machete/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = (egoshard.base_damage * 0.6)

/obj/item/ego_weapon/city/lcorp/club
	name = "l-corp club"
	icon_state = "club"
	desc = "A heavy club issued by L-Corp to those who cannot utilize E.G.O."
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'
	force = 35 //Still less DPS, replaces baseball bat
	attack_speed = 1.6
	knockback = KNOCKBACK_LIGHT
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/club/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = (egoshard.base_damage * 1.6)

/obj/item/ego_weapon/shield/lcorp_shield
	name = "l-corp shield"
	desc = "A heavy shield issued by L-Corp to those who cannot utilize E.G.O."
	special = "This weapon deals atrocious damage."
	icon_state = "shield"
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	force = 28
	damtype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(30, 0, 0, 0) // 30
	projectile_block_duration = 3 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound_volume = 30
	custom_price = 300
	var/installed_shard
	var/equipped
	attribute_requirements = list( //They need to be listed for the attributes to increase
							FORTITUDE_ATTRIBUTE = 0,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)

/obj/item/ego_weapon/shield/lcorp_shield/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/ego_weapon/shield/lcorp_shield/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/ego_weapon/shield/lcorp_shield/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("You need to put down [src] before attempting this!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src] already has an egoshard installed!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/ego_weapon/shield/lcorp_shield/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	force = (egoshard.base_damage * 1.8) //1.8* base damage, 3 attack speed for shields
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("The requirements to equip [src] have increased!"))
	var/list/new_armor_values = list( //Same as armor, +20 from armor's base 2 in red
		egoshard.red_bonus + 20,
		egoshard.white_bonus,
		egoshard.black_bonus,
		egoshard.pale_bonus
	)
	reductions =  new_armor_values.Copy()
	if(LAZYLEN(resistances_list)) //armor tags code
		resistances_list.Cut()
	if(reductions[1] != 0)
		resistances_list += list("RED" = reductions[1])
	if(reductions[2] != 0)
		resistances_list += list("WHITE" = reductions[2])
	if(reductions[3] != 0)
		resistances_list += list("BLACK" = reductions[3])
	if(reductions[4] != 0)
		resistances_list += list("PALE" = reductions[4])
	to_chat(user, span_nicegreen("[src] has been successfully improved!"))
	icon_state = "shield_[egoshard.damage_type]"

/obj/item/ego_weapon/shield/lcorp_shield/examine(mob/user)
	. = ..()
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Emergency Response Agent"))
			. += span_notice("Due to your abilties, you get a +20 to your stats when equipping this weapon.")
	if(!installed_shard)
		. += span_warning("This weapon can be enhanced with an egoshard.")
	else
		. += span_nicegreen("It has a [installed_shard] installed.")

/obj/item/ego_weapon/shield/lcorp_shield/Topic(href, href_list) //An override to make the attribute tag only show up when upgraded
	. = ..()
	if(!installed_shard)
		to_chat(usr, span_nicegreen("This weapon can be used by anyone."))

/obj/item/ego_weapon/shield/lcorp_shield/CanUseEgo(mob/living/user)
	if(user.mind)
		if(user.mind.assigned_role in list("Disciplinary Officer", "Emergency Response Agent"))
			equip_bonus = 20
		else
			equip_bonus = 0
	. = ..()

/////////////////////
//OFFICER EQUIPMENT//
/////////////////////

//Nothing here at the moment

///////////////////
//CLERK EQUIPMENT//
///////////////////

//Agent baton
/obj/item/melee/classic_baton
	name = "agent baton"
	desc = "A cheap weapon for beating Abnormalities or Clerks."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "classic_baton"
	inhand_icon_state = "classic_baton"
	worn_icon_state = "classic_baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 12 //9 hit crit
	w_class = WEIGHT_CLASS_NORMAL

	var/cooldown_check = 0 // Used interally, you don't want to modify

	var/cooldown = 30 // Default wait time until can stun again.
	var/knockdown_time_carbon = (2 SECONDS) // Knockdown length for carbons. Only used when targeting legs.
	var/stun_time_silicon = (5 SECONDS) // If enabled, how long do we stun silicons.
	var/stamina_damage = 55 // Do we deal stamina damage.
	var/stunarmor_penetration = 1 // A modifier from 0 to 1. How much armor we can ignore. Less = Ignores more armor.
	var/affect_silicon = FALSE // Does it stun silicons.
	var/on_sound // "On" sound, played when switching between able to stun or not.
	var/on_stun_sound = 'sound/effects/woodhit.ogg' // Default path to sound for when we stun.
	var/stun_animation = TRUE // Do we animate the "hit" when stunning.
	var/on = TRUE // Are we on or off.

	var/on_icon_state // What is our sprite when turned on
	var/off_icon_state // What is our sprite when turned off
	var/on_inhand_icon_state // What is our in-hand sprite when turned on
	var/force_on // Damage when on - not stunning
	var/force_off // Damage when off - not stunning
	var/weight_class_on // What is the new size class when turned on

	wound_bonus = 15

//Examine text
/obj/item/melee/classic_baton/examine(mob/user)
	. = ..()

	. += span_notice("This weapon works differently from most weapons and can be used to disarm other players.")

	. += span_notice("It has a <a href='byond://?src=[REF(src)];'>tag</a> explaining how to use [src].")

/obj/item/melee/classic_baton/Topic(href, href_list)
	. = ..()
	var/list/readout = list("<u><b>Attacks that are not on harm intent deal nonlethal stamina damage, which will eventually cause humans to collapse from exhaustion.</u></b>")
	readout += "\nAim for a leg to attempt to trip someone over when attacking."
	readout += "\nAim for an arm to attempt to force the target to drop the item they are holding in that hand."
	to_chat(usr, "[span_notice(readout.Join())]")

// Description for trying to stun when still on cooldown.
/obj/item/melee/classic_baton/proc/get_wait_description()
	return

// Description for when turning their baton "on"
/obj/item/melee/classic_baton/proc/get_on_description()
	. = list()

	.["local_on"] = "<span class ='warning'>You extend the baton.</span>"
	.["local_off"] = "<span class ='notice'>You collapse the baton.</span>"

	return .

// Default message for stunning mob.
/obj/item/melee/classic_baton/proc/get_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visibletrip"] =  "<span class ='danger'>[user] has knocked [target]'s legs out from under them with [src]!</span>"
	.["localtrip"] = "<span class ='danger'>[user]  has knocked your legs out from under you [src]!</span>"
	.["visibledisarm"] =  "<span class ='danger'>[user] has disarmed [target] with [src]!</span>"
	.["localdisarm"] = "<span class ='danger'>[user] whacks your arm with [src], causing a coursing pain!</span>"
	.["visiblestun"] =  "<span class ='danger'>[user] beat [target] with [src]!</span>"
	.["localstun"] = "<span class ='danger'>[user] has beat you with [src]!</span>"

	return .

// Default message for stunning a silicon.
/obj/item/melee/classic_baton/proc/get_silicon_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = "<span class='danger'>[user] pulses [target]'s sensors with the baton!</span>"
	.["local"] = "<span class='danger'>You pulse [target]'s sensors with the baton!</span>"

	return .

// Are we applying any special effects when we stun to carbon
/obj/item/melee/classic_baton/proc/additional_effects_carbon(mob/living/target, mob/living/user)
	return

// Are we applying any special effects when we stun to silicon
/obj/item/melee/classic_baton/proc/additional_effects_silicon(mob/living/target, mob/living/user)
	return

/obj/item/melee/classic_baton/attack(mob/living/target, mob/living/user)
	if(!on)
		return ..()

	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, "<span class ='userdanger'>You hit yourself over the head!</span>")

		user.Paralyze(knockdown_time_carbon * force)
		user.apply_damage(stamina_damage, STAMINA, BODY_ZONE_HEAD)

		additional_effects_carbon(user) // user is the target here
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		// We don't stun if we're on harm.
		if (user.a_intent != INTENT_HARM)
			if (affect_silicon)
				var/list/desc = get_silicon_stun_description(target, user)

				target.flash_act(affect_silicon = TRUE)
				target.Paralyze(stun_time_silicon)
				additional_effects_silicon(target, user)

				user.visible_message(desc["visible"], desc["local"])
				playsound(get_turf(src), on_stun_sound, 100, TRUE, -1)

				if (stun_animation)
					user.do_attack_animation(target)
			else
				..()
		else
			..()
		return
	if(!isliving(target))
		return
	if (user.a_intent == INTENT_HARM || !ishuman(target))
		if(!..())
			return
		if(!iscyborg(target))
			return
	else
		if(cooldown_check <= world.time)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if (H.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK))
					return
				if(check_martial_counter(H, user))
					return

			var/list/desc = get_stun_description(target, user)

			if (stun_animation)
				user.do_attack_animation(target)

			playsound(get_turf(src), on_stun_sound, 75, TRUE, -1)
			additional_effects_carbon(target, user)

			var/selected_bodypart_area = check_zone(user.zone_selected)
			var/target_limb = target.get_bodypart(selected_bodypart_area)
			var/def_check = (target.getarmor(target_limb, type = "melee") * stunarmor_penetration)
			switch(selected_bodypart_area)
				if(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
					if(target.stat || target.IsKnockdown() || (target == user) || def_check < 41) // Can't knock down someone with shit-load of armor.
						var/armor_effect = 1 - (def_check / 100)
						target.Knockdown(knockdown_time_carbon * armor_effect)
						log_combat(user, target, "tripped", src)
						target.visible_message(desc["visibletrip"], desc["localtrip"])
						target.apply_damage(stamina_damage*0.25, STAMINA, selected_bodypart_area, def_check)
					else
						log_combat(user, target, "stunned", src)
						target.visible_message(desc["visiblestun"], desc["localstun"])
						target.apply_damage(stamina_damage, STAMINA, selected_bodypart_area, def_check)

				if(BODY_ZONE_L_ARM)
					baton_disarm(user, target, LEFT_HANDS, selected_bodypart_area, def_check)

				if(BODY_ZONE_R_ARM)
					baton_disarm(user, target, RIGHT_HANDS, selected_bodypart_area, def_check)

				else // Normal effect.
					target.apply_damage(stamina_damage, STAMINA, selected_bodypart_area, def_check)
					log_combat(user, target, "stunned", src)
					target.visible_message(desc["visiblestun"], desc["localstun"])

			add_fingerprint(user)

			if(!iscarbon(user))
				target.LAssailant = null
			else
				target.LAssailant = user
			cooldown_check = world.time + cooldown
		else
			var/wait_desc = get_wait_description()
			if (wait_desc)
				to_chat(user, wait_desc)

/obj/item/melee/classic_baton/proc/baton_disarm(mob/living/carbon/user, mob/living/carbon/target, side, bodypart_target, def_check)
	var/obj/item/I = target.get_held_items_for_side(side)
	var/list/desc = get_stun_description(target, user)
	if(I && target.dropItemToGround(I)) // There is an item in this hand. Drop it and deal slightly less stamina damage.
		log_combat(user, target, "disarmed", src)
		target.visible_message(desc["visibledisarm"], desc["localdisarm"])
		target.apply_damage(stamina_damage*0.5, STAMINA, bodypart_target, def_check)
	else // No item in that hand. Deal normal stamina damage.
		log_combat(user, target, "stunned", src)
		target.visible_message(desc["visiblestun"], desc["localstun"])
		target.apply_damage(stamina_damage, STAMINA, bodypart_target, def_check)
