//Guns that reload on melee. You can reload them, but it's really slow
/obj/item/ego_weapon/ranged/city/thumb
	name = "thumb soldato rifle"
	desc = "A 5 round magazine rifle used by The Thumb."
	icon_state = "thumb_soldato"
	inhand_icon_state = "thumb_soldato"
	force = 30
	reach = 2	//It's a spear.
	attack_speed = 1.2
	projectile_path = /obj/projectile/ego_bullet/tendamage	//Does 10 damage
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	special = "Attack an enemy with your bayonet to reload."
	projectile_damage_multiplier = 3		//30 damage per bullet
	fire_delay = 7
	shotsleft = 5		//Based off the Mas 36, That's what my Girlfriend things it looks like. Holds 5 bullets.
	reloadtime = 5 SECONDS
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/ranged/city/thumb/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(shotsleft < initial(shotsleft))
		shotsleft += 1

//Capo
/obj/item/ego_weapon/ranged/city/thumb/capo
	name = "thumb capo rifle"
	desc = "A rifle used by thumb Capos. The gun is inlaid with silver."
	icon_state = "thumb_capo"
	inhand_icon_state = "thumb_capo"
	force = 50
	projectile_damage_multiplier = 5		//50 damage per bullet
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

//Sottoacpo
/obj/item/ego_weapon/ranged/city/thumb/sottocapo
	name = "thumb sottocapo shotgun"
	desc = "A handgun used by thumb sottocapos. While expensive, it's power is rarely matched among syndicates."
	icon_state = "thumb_sottocapo"
	inhand_icon_state = "thumb_sottocapo"
	force = 20	//It's a pistol
	projectile_path = /obj/projectile/ego_bullet/tendamage // does 30 damage (odd, there's no force mod on this one)
	weapon_weight = WEAPON_MEDIUM
	pellets = 8
	variance = 16
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

//wepaons are kinda uninteresting
/obj/item/ego_weapon/city/thumbmelee
	name = "thumb brass knuckles"
	desc = "An pair of dusters sometimes used by thumb capos."
	icon_state = "thumb_duster"
	force = 44
	damtype = RED_DAMAGE

	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'

/obj/item/ego_weapon/city/thumbcane
	name = "thumb sottocapo cane"
	desc = "An cane used by thumb sottocapos."
	icon_state = "thumb_cane"
	force = 65
	damtype = RED_DAMAGE

	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")
	hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

////////////////////////////////////////////////////////////
// THUMB EAST WEAPONRY SECTION.
// Below code belongs to the Thumb East faction of the Thumb.
// These guys are special because they use weapons loaded with special ammunition. They don't fire it as projectiles, instead they use the ammo to boost their melee attacks.
// The weapons will be beatsticks, but will unlock special combos if loaded with ammo.
// These weapons will show up in City and Facility. In City, the Thumb will use them. Otherwise you'll be able to get them from the same sources as regular Thumb gear.
// The ammunition they use comes with its own special properties. Ammunition available in Facility mode should NEVER have status effects on it.

#define COMBO_NO_AMMO "no_ammo"
#define COMBO_LUNGE "lunge"
#define COMBO_ATTACK2 "attack2"
#define COMBO_ATTACK2_AOE "attack2_aoe"
#define COMBO_FINISHER "finisher"
#define COMBO_FINISHER_AOE "finisher_aoe"
#define FINISHER_PIERCE "finisher_type_pierce"
#define FINISHER_LEAP "finisher_type_leap"


/obj/item/ego_weapon/city/thumb_east
	name = "thumb east soldato rifle"
	desc = "A rifle used by the rank and file of the Thumb in the eastern parts of the City. There is a sharp bayonet built into the front.\n"+\
	"Despite its name and appearance, it is used exclusively for melee combat. Soldatos load these rifles with a special type of propellant ammunition which enhances their strikes."
	icon_state = "thumb_soldato"
	inhand_icon_state = "thumb_soldato"
	force = 36
	damtype = RED_DAMAGE
	attack_speed = 1.4
	special = "This is a Thumb East weapon. Load it with propellant ammunition to unlock a powerful combo. Initiate the combo by attacking from range. Each hit of the combo requires 1 propellant round to trigger."
	/// This list holds the bonuses that our next hit should deal. The keys for them are ["tremor"], ["burn"], ["aoe_flat_force_bonus"] and ["aoe_radius_bonus"].
	// I wanted to use a define like NEXTHIT_PROPELLANT_TREMOR_BONUS = next_hit_should_apply["tremor"] to simplify readability and maintainability...
	// but it didn't work. Sorry.
	var/next_hit_should_apply = list()
	// Combo variables.
	/// Should always be TRUE unless the user manually disables combos by using the weapon in-hand.
	var/combo_enabled = TRUE
	/// Description for the combo. Explain it to the user.
	var/combo_description = "This weapon's combo consists of a long-range lunge, followed by a circular AoE sweep around the user, and ending on a powerful finisher on the target.\n"+\
	"If you trigger but miss your lunge, you can still continue the combo by landing a regular hit on-target."
	/// Which step in the combo are we at? COMBO_NO_AMMO means we're either out of ammo, just ended a combo, or haven't started it.
	var/combo_stage = COMBO_NO_AMMO
	/// Variable that holds the reset timer for our combo.
	var/combo_reset_timer
	/// Distance in tiles which our initial lunge reaches.
	var/lunge_range = 3
	/// Duration of the cooldown for our lunge (we don't want people spam-lunging exclusively in PVP, etc)
	var/lunge_cooldown_duration = 12 SECONDS
	/// Holds the actual world time when we can lunge again.
	var/lunge_cooldown
	/// List which holds the coefficients by which to multiply our damage on each hit depending on the state of the combo.
	var/list/motion_values = list(COMBO_NO_AMMO = 1, COMBO_LUNGE = 1.1, COMBO_ATTACK2 = 1.2, COMBO_FINISHER = 1.4)
	/// Coefficient for the second attack's AoE, by which damage towards secondary targets will be multiplied. Should always be less than 1.
	var/attack2_secondarytarget_coefficient = 0.5
	/// Base radius in tiles for the second attack's AoE range. Should be at least 1.
	var/attack2_aoe_base_radius = 1
	/// Coefficient for the Finisher AoE, by which damage towards secondary targets will be multiplied. Should probably be either 1 or a little under 1.
	var/finisher_aoe_secondarytarget_coefficient = 0.5
	/// Base radius in tiles for Finisher AoE range.
	var/finisher_aoe_base_radius = 0
	/// Type of finisher this weapon uses.
	var/finisher_type = FINISHER_PIERCE
	// Ammo variables.
	var/max_ammo = 3
	var/list/obj/item/stack/thumb_east_ammo/current_ammo = list()
	var/current_ammo_type = null
	var/list/accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility,
	)

////////////////////////////////////////////////////////////
// OVERRIDES SECTION.
// This is all the code that overrides procs from parent types.
// Includes code for examining, starting a reload, being destroyed, attacking, and starting a lunge.

/// This Examine override just adds useful info for the player, including ammunition loaded and tips on how the combo system works.
/obj/item/ego_weapon/city/thumb_east/examine(mob/user)
	. = ..()
	. += span_nicegreen("There are [length(current_ammo)]/[max_ammo] shots of [length(current_ammo) > 0 ? pick(current_ammo).name : "propellant ammunition"] currently loaded.")
	. += span_notice(combo_description)
	. += span_danger("This weapon's AoE is indiscriminate. Watch out for friendly fire.")

/obj/item/ego_weapon/city/thumb_east/attack_self(mob/living/user)
	. = ..()
	if(combo_enabled)
		combo_enabled = FALSE
		to_chat(user, span_info("You are no longer spending ammunition to use combo attacks."))
	else
		combo_enabled = TRUE
		to_chat(user, span_info("You are now spending ammunition to use combo attacks."))



/// This override handles reloading.
/obj/item/ego_weapon/city/thumb_east/attackby(obj/item/stack/thumb_east_ammo/I, mob/living/user, params)
	. = ..()

	if(!istype(I))
		return
	// Reject rounds that aren't allowed for this weapon type. Example: don't let the Soldato rifle load Tigermark rounds.
	if(!(I.type in accepted_ammo_table))
		to_chat(user, span_warning("The [I.name] are incompatible with the [src.name]."))
		return
	// If we already have a type of ammunition loaded, and we try to load a different type, reject the round.
	if(I.type != current_ammo_type && current_ammo_type)
		to_chat(user, span_warning("There is a different type of ammunition currently loaded. Spend or unload the ammunition first to load this round."))
		return
	// If we made it past those checks, we just have to check now if we can fit any more rounds into the gun.
	if((length(current_ammo) + 1) <= max_ammo)
		var/obj/item/stack/thumb_east_ammo/new_bullet = I.split_stack(user, 1)
		if(new_bullet)
			// We actually store the round INSIDE the weapon. If the weapon is destroyed we'll drop them.
			new_bullet.forceMove(src)
			current_ammo += new_bullet
			current_ammo_type = I.type
			playsound(src, 'sound/weapons/gun/shotgun/insert_shell.ogg', 100, FALSE, 4)
			to_chat(user, span_info("You load a [I.singular_name] into the [src.name]."))
			return
	else
		to_chat(user, span_warning("The [src.name] cannot fit any more ammunition - it is fully loaded."))

/// This override just makes sure we drop all our ammo and null our ammo reference list if the weapon is destroyed.
/obj/item/ego_weapon/city/thumb_east/Destroy(force)
	for(var/obj/leftover in current_ammo)
		leftover.forceMove(src.loc)
	current_ammo = null
	if(combo_reset_timer)
		deltimer(combo_reset_timer)
	return ..()

/// Attacking.
/obj/item/ego_weapon/city/thumb_east/attack(mob/living/target, mob/living/user)
	if(!combo_enabled)
		ReturnToNormal()
		return ..()
	switch(combo_stage)
		// Importantly: every time we want to fire a round, we should use SpendAmmo(user).

		// This case is for attacks that haven't consumed a round.
		if(COMBO_NO_AMMO)
			// Just in case...
			ReturnToNormal(user)
			return ..()
		// This case is for an attack made out of a lunge.
		if(COMBO_LUNGE)
			// By this point we've actually already fired a round and its bonuses have been loaded already.
			. = ..()
			ApplyStatusEffects(target, COMBO_LUNGE)
			combo_stage = COMBO_ATTACK2
			return
		if(COMBO_ATTACK2)
			var/obj/item/stack/thumb_east_ammo/fired_round = SpendAmmo(user)
			if(fired_round)
				. = ..()
				ComboAOE(target, user, COMBO_ATTACK2)
				ApplyStatusEffects(target, COMBO_ATTACK2)
				combo_stage = COMBO_FINISHER
				return
			// If we didn't spend a round, end the combo and attack regularly.
			else
				ReturnToNormal(user)
				. = ..()
				return
		if(COMBO_FINISHER)
			. = ..()
			playsound(src, 'sound/effects/explosion3.ogg', 70, TRUE, 8)
			// We finished the combo! Reset it.
			deltimer(combo_reset_timer)
			ReturnToNormal(user)
			return

		else
			ReturnToNormal(user)
			. = ..()

/obj/item/ego_weapon/city/thumb_east/pre_attack(atom/A, mob/living/user, params)
	var/mob/living/target = A
	if(!CanUseEgo(user))
		return TRUE

	if(combo_stage == COMBO_FINISHER)
		if(finisher_type == FINISHER_LEAP)
			. = Leap(target, user)
		if(finisher_type == FINISHER_PIERCE)
			. = Pierce(target, user)

		return

	return . = ..()
/obj/item/ego_weapon/city/thumb_east/afterattack(atom/target, mob/user, proximity_flag, click_parameters)

	if(!CanUseEgo(user))
		return TRUE
	if(!isliving(target))
		return TRUE
	. = ..()

	switch(combo_stage)
		if(COMBO_NO_AMMO)
			if((get_dist(user, target) < 2))
				return FALSE
			else
				. = Lunge(target, user)
				return
		if(COMBO_FINISHER)
			if(finisher_type == FINISHER_LEAP)
				if((get_dist(user, target) < 2))
					return FALSE
				. = Leap(target, user)
			return

	return

////////////////////////////////////////////////////////////
// AMMO MANAGEMENT PROCS SECTION.
// These are the procs used to handle the loading and usage of ammunition.
// Includes a check for ammo depletion, a proc to pick and return a round from our loaded rounds and a proc to store bonuses from a round and use it up.

/// Returns TRUE if we're out of ammo.
/obj/item/ego_weapon/city/thumb_east/proc/AmmoDepletedCheck()
	if(length(current_ammo) <= 0)
		return TRUE
	return FALSE

/// This proc tries to spend a round, and if it is able to, returns it to the caller. It will also play the round's detonation sound if successful.
/// Important: This proc doesn't delete the fired round, but removes it from our reference list. If it is not deleted later, then it will remain in the weapon's contents.
/// That being said it shouldn't cause any issues because of that.
/obj/item/ego_weapon/city/thumb_east/proc/SpendAmmo(mob/living/user)
	if(AmmoDepletedCheck())
		ReturnToNormal(user)
		return FALSE
	// We need to delete this round that was fired later by the way.
	var/obj/item/stack/thumb_east_ammo/fired_round = pick_n_take(current_ammo)

	if(AmmoDepletedCheck())
		current_ammo_type = null

	removeNullsFromList(current_ammo)

	if(fired_round)
		playsound(src, fired_round.detonation_sound, 75, FALSE, 8)
		shake_camera(user, 1.5, 3)
		PropulsionVisual(get_turf(user), fired_round.aesthetic_shockwave_distance)
		HandleFiredAmmo(fired_round, user)
		return TRUE
	return FALSE

/// This proc is passed a round, stores the bonuses it should provide to the weapon according to the current combo stage and the round's properties, then deletes the round.
/// It also sets a timer to reset the combo.
/obj/item/ego_weapon/city/thumb_east/proc/HandleFiredAmmo(obj/item/stack/thumb_east_ammo/round, mob/living/user)
	if(round)
		force = (initial(force) * motion_values[combo_stage]) + round.flat_force_base * motion_values[combo_stage]
		next_hit_should_apply["aoe_flat_force_bonus"] = round.flat_force_base
		if(round.tremor_base > 0)
			var/tremor_coeff = motion_values[combo_stage]
			next_hit_should_apply["tremor"] = round.tremor_base * tremor_coeff
		if(round.burn_base > 0)
			var/burn_coeff = motion_values[combo_stage]
			next_hit_should_apply["burn"] = round.burn_base * burn_coeff
		if(round.aoe_radius_bonus > 0)
			next_hit_should_apply["aoe_radius_bonus"] = round.aoe_radius_bonus
		deltimer(combo_reset_timer)
		combo_reset_timer = addtimer(CALLBACK(src, PROC_REF(ReturnToNormal), user), 5 SECONDS, TIMER_STOPPABLE)
		qdel(round)

////////////////////////////////////////////////////////////
// SPECIAL ATTACKS SECTION.
// These are the procs used to handle offensive actions like AoE attacks and applying status effects to the enemy.
// Includes a proc to apply status effects, a proc to reset the weapon back to normal, and a proc for doing an AoE attack.


/// This proc is just for a visual effect that creates a "shockwave" or some smoke at the user's location.
/obj/item/ego_weapon/city/thumb_east/proc/PropulsionVisual(turf/origin, radius)
	var/list/already_rendered = list()
	for(var/i in 1 to radius)
		var/list/turfs_to_spawn_visual_at = list()
		for(var/turf/T in orange(i, origin))
			turfs_to_spawn_visual_at |= T
		turfs_to_spawn_visual_at -= already_rendered
		for(var/turf/T2 in turfs_to_spawn_visual_at)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T2)
			already_rendered |= T2
		sleep(1)

/obj/item/ego_weapon/city/thumb_east/proc/Lunge(mob/living/target, mob/living/user)
	if(!(can_see(user, target, lunge_range)))
		to_chat(user, span_warning("You can't reach your target!"))
		return FALSE
	if(lunge_cooldown > world.time)
		to_chat(user, span_warning("You're not ready to lunge yet!"))
		return FALSE
	combo_stage = COMBO_LUNGE

	// Check to see if we've got a round to fire.
	var/obj/item/stack/thumb_east_ammo/fired_round = SpendAmmo(user)
	if(fired_round)
		// We do have a round. So let's set ourselves to lunging and add the bonuses from the fired round to the weapon with HandleFiredAmmo().
		lunge_cooldown = world.time + lunge_cooldown_duration
		// Aesthetics.
		to_chat(user, span_warning("You lunge at [target] using the propulsion from your [src.name]!"))
		var/turf/takeoff_turf = get_turf(user)
		new /obj/effect/temp_visual/thumb_east_aoe_impact(takeoff_turf)
		// This code is stolen from Dark Carnival, aside from the sleep(). Why is it "for i in 2 to dist"? I think it's because it's excluding the user and target tiles.
		for(var/i in 2 to get_dist(user, target))
			step_towards(user, target)
			sleep(0.5)
		// If we managed to close the gap, hit the target automatically.
		if((get_dist(user, target) < 2))
			target.attackby(src,user)
		else
			to_chat(user, span_warning("Your lunge falls short of hitting your target!"))
		return TRUE
	else
		to_chat(user, span_warning("You pull the trigger to lunge at [target], but you have no ammo left."))
		combo_stage = COMBO_NO_AMMO
		return FALSE

/obj/item/ego_weapon/city/thumb_east/proc/Leap(mob/living/target, mob/living/user)
	user.say("*grin")
	to_chat(user, span_userdanger("You prepare to leap at your target by using the thrust from your [src.name]'s ammunition!"))
	user.Immobilize(1.6 SECONDS)
	if(do_after(user, 1.6 SECONDS, target, IGNORE_TARGET_LOC_CHANGE, TRUE, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(can_see), user, target, 7)))
		user.say("Firing all rounds...!")
		if(SpendAmmo(user))
			var/horizontal_difference = target.x - user.x
			var/x_to_offset = 0
			switch(horizontal_difference)
				if(0)
					x_to_offset = 0
				if(1 to INFINITY)
					x_to_offset = 16
				if(-INFINITY to -1)
					x_to_offset = -16
			animate(user, 0.4 SECONDS, easing = QUAD_EASING, pixel_y = user.base_pixel_y + 32, pixel_x = user.base_pixel_x + x_to_offset, alpha = 0)
			sleep(0.4 SECONDS)
			user.forceMove(get_turf(target))
			animate(user, 0.2 SECONDS, easing = QUAD_EASING, pixel_y = user.base_pixel_y, pixel_x = user.base_pixel_x, alpha = 255)
			sleep(0.2 SECONDS)
			target.attackby(src, user)
			ComboAOE(target, user, COMBO_FINISHER)
			ApplyStatusEffects(target, COMBO_FINISHER)
			return TRUE
		else
			user.visible_message(span_userdanger("[user] pulls the trigger on their [src.name], but nothing happens!"), span_danger("You pull the trigger on your [src.name]. Nothing happens. Holy shit, you must look really dumb. Leave no witnesses standing."))
	else
		to_chat(user, span_warning("Your leap is interrupted!"))

	return FALSE

/obj/item/ego_weapon/city/thumb_east/proc/Pierce(mob/living/target, mob/living/user)
	if(SpendAmmo(user))
		var/turf/start_turf = get_turf(user)
		var/turf/end_turf = get_ranged_target_turf_direct(user, target, 2)
		var/list/vfx_turfs = null
		if(start_turf && end_turf)
			vfx_turfs = getline(start_turf, end_turf)
		user.visible_message(span_userdanger("[user] pierces [target] with a devastating, explosive strike!"))
		target.attackby(src, user)
		if(!end_turf.is_blocked_turf(TRUE))
			user.forceMove(end_turf)
		if(vfx_turfs)
			for(var/turf/T in vfx_turfs)
				new /obj/effect/temp_visual/thumb_east_aoe_impact(T)
		ApplyStatusEffects(target, COMBO_FINISHER)
		return TRUE
	else
		user.visible_message(span_userdanger("[user] pulls the trigger on their [src.name], but nothing happens!"), span_danger("You pull the trigger on your [src.name]. Nothing happens."))
		return FALSE

/// This proc applies status effects to a target.
/obj/item/ego_weapon/city/thumb_east/proc/ApplyStatusEffects(mob/living/target, hit_type)
	// We don't want to tremor burst targets normally.
	var/tremorburst_threshold = 999
	// We do want to tremor burst if it's a finisher.
	if(hit_type == COMBO_FINISHER || hit_type == COMBO_FINISHER_AOE)
		tremorburst_threshold = 30

	// Gather the tremor and burn stacks to apply according to the round we fired.
	var/tremor_to_apply = next_hit_should_apply["tremor"]
	var/burn_to_apply = next_hit_should_apply["burn"]
	// Halve them if the statuses are being applied to an AoE's secondary target.
	if(hit_type == COMBO_ATTACK2_AOE || hit_type == COMBO_FINISHER_AOE)
		tremor_to_apply *= 0.5
		burn_to_apply *= 0.5
	// Round them down so we don't apply 11.3 tremor stacks or something weird like that.
	tremor_to_apply = floor(tremor_to_apply)
	burn_to_apply = floor(burn_to_apply)

	if(tremor_to_apply >= 1)
		//target.say("Receiving [tremor_to_apply] stacks of Tremor and will burst at [tremorburst_threshold].")
		target.apply_lc_tremor(tremor_to_apply, tremorburst_threshold)
	if(burn_to_apply >= 1)
		//target.say("Receiving [burn_to_apply] stacks of Burn.")
		target.apply_lc_burn(burn_to_apply)

/// This proc is just cleanup on the weapon's state, and called whenever a combo ends, is cancelled or times out.
/obj/item/ego_weapon/city/thumb_east/proc/ReturnToNormal(mob/user)
	force = initial(force)
	next_hit_should_apply = list()
	if(combo_stage != COMBO_NO_AMMO && combo_stage != COMBO_LUNGE)
		combo_stage = COMBO_NO_AMMO
		to_chat(user, span_warning("Your combo resets!"))

/// This proc handles the AoE for our second attack and our finisher.
/obj/item/ego_weapon/city/thumb_east/proc/ComboAOE(mob/target, mob/user, hit_type)
	// First, determine how large the AOE should be.
	var/aoe_radius = (hit_type == COMBO_ATTACK2 ? attack2_aoe_base_radius : finisher_aoe_base_radius)
	var/propellant_radius_bonus = next_hit_should_apply["aoe_radius_bonus"]
	if(propellant_radius_bonus)
		aoe_radius += floor(propellant_radius_bonus)

	// We determine the tiles which should be hit.
	var/list/affected_turfs = list()
	for(var/turf/T in (hit_type == COMBO_ATTACK2 ? orange(aoe_radius, user) : range(aoe_radius, target)))
		affected_turfs |= T

	// Sound and visuals for the AoE attack.
	playsound(src, 'sound/abnormalities/scorchedgirl/explosion.ogg', 75, FALSE, 6)
	for(var/turf/T2 in affected_turfs)
		new /obj/effect/temp_visual/thumb_east_aoe_impact(T2)

	// Calculate the AoE damage. We get the base damage from:
	// (Initial force of the weapon + flat force bonus from the round fired) * Motion value of the AoE type * A special coefficient for secondary targets of the AoE type
	// We later multiply this value by Justice.
	var/aoe = (initial(force) + next_hit_should_apply["aoe_flat_force_bonus"]) * motion_values[hit_type] * (hit_type == COMBO_ATTACK2 ? attack2_secondarytarget_coefficient : finisher_aoe_secondarytarget_coefficient)
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	aoe*=force_multiplier
	// We recently disabled Justice scaling in PvP so we also need to store a non-justice modified value to apply damage to human mobs.
	var/aoe_no_justice = aoe
	aoe*=justicemod
	for(var/turf/T3 in affected_turfs)
		for(var/mob/living/L in T3)
			if(L == user)
				continue
			if(L == target)
				continue
			L.apply_damage((ishuman(L) ? aoe_no_justice : aoe), damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
			if(hit_type == COMBO_ATTACK2)
				ApplyStatusEffects(L, COMBO_ATTACK2_AOE)
				L.visible_message(span_danger("[user] cuts through [L] with a wide, explosive sweep!"))
			else if(hit_type == COMBO_FINISHER)
				ApplyStatusEffects(L, COMBO_FINISHER_AOE)
				L.visible_message(span_danger("[L] is scorched by a powerful blast from [user]'s [src.name]!"))


////////////////////////////////////////////////////////////
// WEAPON SUBTYPES.

/obj/item/ego_weapon/city/thumb_east/podao
	name = "thumb east podao"
	desc = "A traditional podao fitted with a system to load specialized propellant ammunition. Even Thumb Capos can struggle to handle the impressive thrust generated by this blade."
	icon_state = "salvador"
	inhand_icon_state = "salvador"
	force = 60
	attack_speed = 1.6
	max_ammo = 6
	finisher_aoe_base_radius = 1
	finisher_type = FINISHER_LEAP
	accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility,
		/obj/item/stack/thumb_east_ammo/tigermark,
		/obj/item/stack/thumb_east_ammo/tigermark/facility,
	)
	combo_description = "This weapon's combo consists of a long-range AOE dash, a circular AoE sweep around the user, and ends with a devastating AoE leap on the target."
	motion_values = list(COMBO_NO_AMMO = 1, COMBO_LUNGE = 1.2, COMBO_ATTACK2 = 1.2, COMBO_FINISHER = 1.5)

////////////////////////////////////////////////////////////
// AMMUNITION SECTION.
// These are stackable items. They don't really do much on their own. The Thumb East weapons handle the logic for loading and firing them.
// Most of this code is just for holding the properties bullets should have when fired.
/obj/item/stack/thumb_east_ammo
	name = "scorch propellant ammunition"
	desc = "Ammunition used by the Thumb in eastern parts of the City. These rounds aren't fired at targets, rather they provide additional propulsion to the swings and stabs of Thumb weaponry."
	singular_name = "scorch propellant round"
	max_amount = 3
	icon_state = "thumb_east"
	novariants = FALSE
	merge_type = /obj/item/stack/thumb_east_ammo
	/// This variable holds the path to the sound file played when this round is consumed.
	var/detonation_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	/// This variable holds the distance that the aesthetic "shockwave" will travel after this round is fired.
	var/aesthetic_shockwave_distance = 2
	// Varediting any of these variables on an ingame ammo stack won't actually work or change anything.
	// You would have to actually go into the weapon, into its list of ammo, and change these values *there*. But this is an adminbus-only edge case anyhow.
	/// Controls how much tremor is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/tremor_base = 5
	/// Controls how much burn is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/burn_base = 2
	/// Adds flat force to an attack boosted with this ammo. Multiplied by a motion value coefficient depending on combo stage.
	var/flat_force_base = 6
	/// AOE radius bonus when spending this shell on an AOE attack. Please never let this be too high or it will cause funny incidents. This is never multiplied.
	var/aoe_radius_bonus = 0

/obj/item/stack/thumb_east_ammo/examine(mob/user)
	. = ..()
	. += span_notice("This ammunition increases weapon base damage by [flat_force_base] when fired.")
	. += span_notice("It [tremor_base >= 1 ? "applies [tremor_base]" : "does not apply"] tremor stacks on target hit after firing.")
	. += span_notice("It [burn_base >= 1 ? "applies [burn_base]" : "does not apply"] burn stacks on target hit after firing.")
	. += span_notice("It [aoe_radius_bonus >= 1 ? "adds [aoe_radius_bonus]" : "does not add any extra"] tiles of radius to AoE attacks on target hit after firing.")


// I know this override looks weird, but there's a good reason for it. There's a certain behaviour stack objects have where subtypes can merge to their parent types,
// which we really don't want for this specific item and its subtypes. As in, we don't want scorch propellant rounds to get mixed up with Tigermark rounds or surplus rounds.
/obj/item/stack/thumb_east_ammo/can_merge(obj/item/stack/check)
	// We need to actually check we're going to access the merge_type of a stacking object, because this proc is called on absolutely everything these items cross...
	if(istype(check, /obj/item/stack))
		if(!istype(src, check.merge_type))
			return FALSE
	. = ..()



/obj/item/stack/thumb_east_ammo/facility
	name = "surplus propellant ammunition"
	desc = "Some strange ammunition used in certain weapons, though it isn't actually fired as a projectile. It looks to be in pretty bad shape.\n"+\
	"Why would someone use a gun if not to fire a bullet? You don't really know the answer, but you might as well put this weathered, low-quality ammo to use."
	singular_name = "surplus propellant round"
	merge_type = /obj/item/stack/thumb_east_ammo/facility
	tremor_base = 0
	burn_base = 0
	flat_force_base = 10
	aesthetic_shockwave_distance = 1

/obj/item/stack/thumb_east_ammo/tigermark
	name = "tigermark rounds"
	desc = "Powerful propellant ammunition used by the Eastern Thumb. It greatly enhances the power of slashes, and its detonation sounds like the roar of a tiger.\n"+\
	"One of these rounds might cost more than the life of some Fixers."
	singular_name = "tigermark round"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark
	detonation_sound = 'sound/abnormalities/fluchschutze/fell_bullet.ogg'
	aesthetic_shockwave_distance = 3
	tremor_base = 8
	burn_base = 4
	flat_force_base = 12
	aoe_radius_bonus = 1

/obj/item/stack/thumb_east_ammo/tigermark/examine(mob/user)
	. = ..()
	. += span_info("This ammunition is only compatible with thumb east podaos.")

/obj/item/stack/thumb_east_ammo/tigermark/facility
	name = "ligermark rounds"
	desc = "Wait... this isn't a Tigermark round at all, is it? Well... it's about the same caliber, so it would probably fit into a Thumb East podao."
	singular_name = "ligermark round"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark/facility
	tremor_base = 0
	burn_base = 0
	flat_force_base = 16
	aoe_radius_bonus = 1

////////////////////////////////////////////////////////////
// VFX SECTION.
// These are just the temporary visual effects created by Thumb East weaponry.

/obj/effect/temp_visual/thumb_east_aoe_impact
	name = "scorched earth"
	desc = "It smells like gunpowder."
	duration = 0.6 SECONDS
	icon_state = "visual_fire"
	color = "#6e1616"

#undef COMBO_NO_AMMO
#undef COMBO_LUNGE
#undef COMBO_ATTACK2
#undef COMBO_ATTACK2_AOE
#undef COMBO_FINISHER
#undef COMBO_FINISHER_AOE
#undef FINISHER_PIERCE
#undef FINISHER_LEAP
