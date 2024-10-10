/obj/item/ego_weapon/ranged/proc/on_autofire_start(mob/living/shooter)
	if(semicd || shooter.stat || !can_trigger_gun(shooter))
		return FALSE
	if(!can_shoot())
		shoot_with_empty_chamber(shooter)
		return FALSE
	var/obj/item/bodypart/other_hand = shooter.has_hand_for_held_index(shooter.get_inactive_hand_index())
	if(weapon_weight == WEAPON_HEAVY && (shooter.get_inactive_held_item() || !other_hand))
		to_chat(shooter, span_warning("You need two hands to fire [src]!"))
		return FALSE
	return TRUE

/obj/item/ego_weapon/ranged/proc/autofire_bypass_check(datum/source, client/clicker, atom/target, turf/location, control, params)
	SIGNAL_HANDLER
	if(clicker.mob.get_active_held_item() != src)
		return COMPONENT_AUTOFIRE_ONMOUSEDOWN_BYPASS

/obj/item/ego_weapon/ranged/proc/do_autofire(datum/source, atom/target, mob/living/shooter, params)
	SIGNAL_HANDLER
	if(semicd || shooter.stat)
		return NONE
	if(!can_shoot())
		shoot_with_empty_chamber(shooter)
		return NONE
	INVOKE_ASYNC(src, PROC_REF(do_autofire_shot), source, target, shooter, params)
	return COMPONENT_AUTOFIRE_SHOT_SUCCESS //All is well, we can continue shooting.

/obj/item/ego_weapon/ranged/proc/do_autofire_shot(datum/source, atom/target, mob/living/shooter, params)
	var/obj/item/ego_weapon/ranged/akimbo_gun = shooter.get_inactive_held_item()
	var/bonus_spread = 0
	if(istype(akimbo_gun) && weapon_weight < WEAPON_MEDIUM)
		if(akimbo_gun.weapon_weight < WEAPON_MEDIUM && akimbo_gun.can_trigger_gun(shooter))
			bonus_spread = dual_wield_spread
			addtimer(CALLBACK(akimbo_gun, TYPE_PROC_REF(/obj/item/ego_weapon/ranged, process_fire), target, shooter, TRUE, params, null, bonus_spread), 1)
	process_fire(target, shooter, TRUE, params, null, bonus_spread)
