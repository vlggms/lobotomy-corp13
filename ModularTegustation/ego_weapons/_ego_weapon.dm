/obj/item/ego_weapon
	name = "ego weapon"
	desc = "You aren't meant to see this."
	icon = 'icons/obj/ego_weapons.dmi'
	worn_icon_state = "nothing" //I HATE PURPLE SPRITES, I HATE PURPLE SPRITES
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY			//No more stupid 10 egos in bag
	slot_flags = ITEM_SLOT_BELT
	drag_slowdown = 1
	swingstyle = WEAPONSWING_SMALLSWEEP
	var/list/attribute_requirements = list()
	var/special
	var/is_ranged //Is this a ranged weapon? Mostly deals with examines.
	var/is_city_gear = FALSE//If a weapon is from gatcha
	/// How much knockback does this weapon deal, if at all?
	var/knockback = FALSE

	//Is there a bonus to equipping this?
	var/equip_bonus = 0

	//How long do you stun on hit?
	var/stuntime = 0

	//If a weapon has a special attack speed changes or uses a combo system, how fast does it attack regulary?
	var/modified_attack_speed = null

/obj/item/ego_weapon/Initialize()
	. = ..()
	if(swingstyle == WEAPONSWING_SMALLSWEEP && reach > 1)
		swingstyle = WEAPONSWING_THRUST
	RegisterSignal(src, COMSIG_OBJ_PAINTED, PROC_REF(GetSwingColor))

/obj/item/ego_weapon/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return FALSE
	. = ..()

	if(charge && attack_charge_gain)
		HandleCharge(1, target)
		if(user.a_intent != INTENT_HARM) // Spear/whip/lance thrust visuals
			get_thrust_turfs(target, user)
	if(stuntime)
		if((reach >= 2 && !user.Adjacent(target)) ||  reach < 2) // Reach weapon stuff
			user.Immobilize(stuntime)
			//Visual stuff to give you better feedback
			new /obj/effect/temp_visual/weapon_stun(get_turf(user))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))

	if(target.anchored || !knockback || QDELETED(target)) // lets not throw machines around
		return TRUE

	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	switch(knockback)
		if(KNOCKBACK_LIGHT)
			var/whack_speed = (prob(60) ? 1 : 4)
			target.safe_throw_at(throw_target, rand(1, 2), whack_speed, user)

		if(KNOCKBACK_MEDIUM)
			var/whack_speed = (prob(60) ? 3 : 6)
			target.safe_throw_at(throw_target, rand(2, 3), whack_speed, user)

		if(KNOCKBACK_HEAVY) // neck status: snapped
			target.safe_throw_at(throw_target, 7, 7, user)

		else // should only be used by admins messing around in-game, please consider using above variables as a coder
			target.safe_throw_at(throw_target, (knockback * 0.5) , knockback, user)

	return TRUE

/obj/item/ego_weapon/Sweep(atom/target, mob/living/carbon/human/user, params)
	if(isturf(target) && user.a_intent == INTENT_HARM)
		if(!CanUseEgo(user))
			return TRUE
	return ..(target, user, params)

//Speed and stun stuff
/obj/item/ego_weapon/attack_obj(obj/target, mob/living/user)
	if(!CanUseEgo(user))
		return FALSE
	. = ..()
	if(attack_speed)
		user.changeNext_move(CLICK_CD_MELEE * attack_speed)
	return TRUE

//Examine shit

/obj/item/ego_weapon/examine(mob/user)
	. = ..()
	if(!is_ranged)
		. += EgoAttackInfo(user)
	if(special)
		. += span_notice("[special]")
	if(tool_behaviour == TOOL_MINING)
		. += span_notice("This weapon can be used to mine at a [(100/toolspeed)]% efficiency.")

	if(LAZYLEN(attribute_requirements))
		if(!ishuman(user))	//You get a notice if you are a ghost or otherwise
			. += span_notice("It has <a href='byond://?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.")
		else if(CanUseEgo(user))	//It's green if you can use it
			. += span_nicegreen("It has <a href='byond://?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.")
		else				//and red if you cannot use it
			. += span_danger("You cannot use this EGO!")
			. += span_danger("It has <a href='byond://?src=[REF(src)];list_attributes=1'>certain requirements</a> for the wearer.")
	var/list/typecache_small = typecacheof(GLOB.small_ego)
	if(is_type_in_typecache(src, typecache_small))
		. += span_nicegreen("This weapon fits in an EGO belt.")

	//Melee stuff is NOT shown on ranged lol
	if(is_ranged)
		return
	if(reach>1)
		. += span_notice("This weapon has a reach of [reach].")

	if(throwforce>force)
		. += span_notice("This weapon deals [throwforce] [damtype] damage when thrown.")

	var/text_attack_speed = attack_speed
	if(modified_attack_speed)
		text_attack_speed = modified_attack_speed
	switch(text_attack_speed)
		if(-INFINITY to 0.39)
			. += span_notice("This weapon has a very fast attack speed.")

		if(0.4 to 0.69) // nice
			. += span_notice("This weapon has a fast attack speed.")

		if(0.7 to 0.99)
			. += span_notice("This weapon attacks slightly faster than normal.")

		if(1.01 to 1.49)
			. += span_notice("This weapon attacks slightly slower than normal.")

		if(1.5 to 1.99)
			. += span_notice("This weapon has a slow attack speed.")

		if(2 to INFINITY)
			. += span_notice("This weapon attacks extremely slow.")

	switch(swingstyle)
		if(WEAPONSWING_LARGESWEEP)
			. += span_notice("This weapon can be swung in an arc instead of at a specific target.")

		if(WEAPONSWING_THRUST)
			. += span_notice("This weapon can be thrust at tiles up to [reach] tiles away instead of a specific target.")

	switch(stuntime)
		if(1 to 2)
			. += span_notice("This weapon stuns you for a very short duration on hit.")
		if(2 to 4)
			. += span_notice("This weapon stuns you for a short duration on hit.")
		if(5 to 6)
			. += span_notice("This weapon stuns you for a moderate duration on hit.")
		if(6 to 8)
			. += span_danger("CAUTION: This weapon stuns you for a long duration on hit.")
		if(9 to INFINITY)
			. += span_danger("WARNING: This weapon stuns you for a very long duration on hit.")


	switch(knockback)
		if(KNOCKBACK_LIGHT)
			. += span_notice("This weapon has slight enemy knockback.")

		if(KNOCKBACK_MEDIUM)
			. += span_notice("This weapon has decent enemy knockback.")

		if(KNOCKBACK_HEAVY)
			. += span_notice("This weapon has neck-snapping enemy knockback.")

		else if(knockback)
			. += span_notice("This weapon has [knockback >= 10 ? "neck-snapping": ""] enemy knockback.")


/obj/item/ego_weapon/Topic(href, href_list)
	. = ..()
	if(href_list["list_attributes"])
		var/display_text = span_danger("<b>It requires the following attributes:</b>")
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 0)
				display_text += "\n <span class='danger'>[atr]: [attribute_requirements[atr]].</span>"
		display_text += SpecialGearRequirements()
		to_chat(usr, display_text)

/obj/item/ego_weapon/proc/CanUseEgo(mob/living/user)
	if(istype(user, /mob/living/simple_animal/bot/cleanbot))
		for(var/atr in attribute_requirements)
			if(attribute_requirements[atr] > 40)
				return FALSE
		return TRUE

	if(HAS_TRAIT(user, TRAIT_NOEGOWEAPONS))
		to_chat(user, span_notice("You cannot use [src]!"))
		return FALSE

	if(!ishuman(user))
		return FALSE

	if(user.mind)
		if(user.mind.assigned_role == "Sephirah") //This is an RP role
			return FALSE

	var/mob/living/carbon/human/H = user
	for(var/atr in attribute_requirements)
		if(attribute_requirements[atr] > get_attribute_level(H, atr) + equip_bonus)
			to_chat(H, span_notice("You cannot use [src]!"))
			return FALSE
	if(!SpecialEgoCheck(H))
		return FALSE
	return TRUE

/obj/item/ego_weapon/proc/SpecialEgoCheck(mob/living/carbon/human/H)
	return TRUE

/obj/item/ego_weapon/proc/SpecialGearRequirements()
	return

/obj/item/ego_weapon/proc/EgoAttackInfo(mob/user)
	var/damage_type = damtype
	var/damage = force
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	if(force_multiplier != 1)
		return span_notice("It deals [round(damage * force_multiplier, 0.1)] [damage_type] damage. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [damage] [damage_type] damage.")

/obj/item/ego_weapon/GetTarget(mob/user, list/potential_targets = list())
	if(damtype != WHITE_DAMAGE)
		return ..()

	. = null

	for(var/mob/living/carbon/human/H in potential_targets)
		if(.)
			break
		if(!H.sanity_lost)
			continue
		if(H.stat == DEAD)
			continue
		. = H

	if(.)
		return

	return ..()

/obj/item/ego_weapon/MiddleClickAction(atom/target, mob/living/user)
	. = ..()
	if(. || !CanUseEgo(user))
		return TRUE

/obj/item/ego_weapon/update_icon()
	. = ..()
	GetSwingColor()

/obj/item/ego_weapon/update_icon_state()
	. = ..()
	GetSwingColor()

/obj/item/ego_weapon/wash(clean_types)
	. = ..()
	GetSwingColor()
