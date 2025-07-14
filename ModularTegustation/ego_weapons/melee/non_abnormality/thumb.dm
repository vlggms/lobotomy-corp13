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
#define SPENT_INSTANTEJECT "spent_instanteject"
#define SPENT_RELOADEJECT "spent_reloadeject"

/// Basic weapon for Thumb East Soldatos. Stronger than the Thumb South Soldato rifle in terms of DPS, but not ranged. Requires better virtues.
/// RED beatsticks are pretty bad nevertheless, so you'll need to use ammo to unlock its full potential.
/obj/item/ego_weapon/city/thumb_east
	name = "thumb east soldato rifle"
	desc = "A rifle used by the rank and file of the Thumb in the eastern parts of the City. There is a sharp bayonet built into the front.\n"+\
	"Despite its name and appearance, it is used exclusively for melee combat. Soldatos load these rifles with a special type of propellant ammunition which enhances their strikes."
	icon_state = "thumb_soldato"
	inhand_icon_state = "thumb_soldato"
	hitsound = 'sound/weapons/ego/thumb_east_rifle_attack.ogg'
	usesound = 'sound/machines/click.ogg'
	force = 40
	damtype = RED_DAMAGE
	attack_speed = 1.3
	special = "This is a Thumb East weapon. Load it with propellant ammunition to unlock a powerful combo. Initiate the combo by attacking from range. Each hit of the combo requires 1 propellant round to trigger, and has varying attack speed. Your combo will cancel if you run out of ammo or hit without spending a round.\n"+\
	"Hit the weapon with a handful of propellant ammunition to attempt to load as much of the handful as possible. Toggle your combo on or off by using this weapon in-hand. Alt-click the weapon to unload a round.\n"+\
	"Spending ammo with this weapon generates heat. Heat increases the base damage of the weapon when not using combo attacks. It decays on each hit and is reset on reloading or unloading."
	/// This list holds the bonuses that our next hit should deal. The keys for them are ["tremor"], ["burn"], ["aoe_flat_force_bonus"] and ["aoe_radius_bonus"].
	// I wanted to use a define like NEXTHIT_PROPELLANT_TREMOR_BONUS = next_hit_should_apply["tremor"] to simplify readability and maintainability...
	// but it didn't work. Sorry.
	var/next_hit_should_apply = list()

	// 	Combo variables.
	/// Should always be TRUE unless the user manually disables combos by using the weapon in-hand.
	var/combo_enabled = TRUE
	/// Description for the combo. Explain it to the user.
	var/combo_description = "This weapon's combo consists of a long-range lunge, followed by a circular AoE sweep around the user, and ends with a powerful finisher on the target.\n"+\
	"If you trigger but miss your lunge, you can still continue the combo by landing a regular hit on-target."
	/// Which step in the combo are we at? COMBO_NO_AMMO means we're either out of ammo, just ended a combo, or haven't started it.
	var/combo_stage = COMBO_NO_AMMO
	/// Variable that holds the reset timer for our combo.
	var/combo_reset_timer
	/// List which maps the coefficients by which to multiply our damage on each hit depending on the state of the combo.
	var/list/motion_values = list(COMBO_NO_AMMO = 1, COMBO_LUNGE = 1, COMBO_ATTACK2 = 1.2, COMBO_FINISHER = 1.4, COMBO_ATTACK2_AOE = 0.5, COMBO_FINISHER_AOE = 0.5,)
	/// This variable holds a flat force increase that is only applied on COMBO_NO_AMMO hits. It increases when ammo is spent, and gets reset on reload or unload.
	/// It decays on each hit that isn't part of a combo.
	var/overheat = 0

	// Special attack variables.
	/// Distance in tiles which our initial lunge reaches.
	var/lunge_range = 3
	/// Duration of the cooldown for our lunge (we don't want people spam-lunging exclusively in PVP, etc). This also limits how often you can start a combo.
	var/lunge_cooldown_duration = 14 SECONDS
	/// Holds the actual world time when we can lunge again.
	var/lunge_cooldown
	/// Base radius in tiles for the second attack's AoE range. Should be at least 1.
	var/attack2_aoe_base_radius = 1
	/// Base radius in tiles for Finisher AoE range.
	var/finisher_aoe_base_radius = 0
	/// Type of finisher this weapon uses.
	var/finisher_type = FINISHER_PIERCE
	/// The windup our finisher has, if it has any. FINISHER_PIERCE shouldn't use this, but FINISHER_LEAP will use it. That can change in the future though.
	var/finisher_windup = 1.6 SECONDS
	/// Are we currently performing a channeled action like leaping or reloading?
	var/busy = FALSE

	// Ammo variables.
	/// Maximum ammo capacity that this weapon can hold.
	var/max_ammo = 3
	/// Does our weapon eject spent cartridges as they're fired (SPENT_INSTANTEJECT) or store them until you attempt to reload (SPENT_RELOADEJECT)?
	/// SPENT_RELOADEJECT will also eject live rounds when attempting a reload.
	var/spent_ammo_behaviour = SPENT_INSTANTEJECT
	/// This list holds a reference to every live round of ammo in our storage.
	var/list/obj/item/stack/thumb_east_ammo/current_ammo = list()
	/// We use this variable to hold the type of the current ammo, so we can reject different types.
	var/current_ammo_type = null
	/// We use this variable to hold the plural name of the current ammo. We shouldn't need a var for this, but dreamchecker is giving me a warning so I have to do it.
	var/current_ammo_name = ""
	/// This list holds a reference to every spent cartridge in the weapon. Should only be used in weapons with SPENT_RELOADEJECT.
	var/list/obj/item/stack/thumb_east_ammo/spent/spent_cartridges = list()
	/// This list holds the types of ammo this weapon can load.
	var/list/accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility,
	)

	// Sound path variables.
	var/reload_start_sound = 'sound/weapons/ego/thumb_east_rifle_reload_start.ogg'
	var/reload_load_sound = 'sound/weapons/ego/thumb_east_rifle_reload_load.ogg'
	var/reload_end_sound = 'sound/weapons/ego/thumb_east_rifle_reload_end.ogg'
	var/reload_fail_sound = 'sound/weapons/ego/thumb_east_rifle_reload_fail.ogg'
	var/lunge_sound = 'sound/weapons/ego/thumb_east_rifle_boostedlunge.ogg'
	var/sweep_sound = 'sound/weapons/ego/thumb_east_rifle_boostedsweep.ogg'
	var/finisher_sound = 'sound/weapons/ego/thumb_east_rifle_boostedfinisher.ogg'
	/// Ideally this one shouldn't even need to be stored on the weapon, and we'll change it according to the sound on round we fire, but it's convenient to store it here.
	var/detonation_sound = 'sound/weapons/ego/thumb_east_rifle_detonation.ogg'

////////////////////////////////////////////////////////////
// OVERRIDES SECTION.
// This is all the code that overrides procs from parent types.

/// This Examine override just adds useful info for the player, including ammunition loaded and tips on how the combo system works.
/obj/item/ego_weapon/city/thumb_east/examine(mob/user)
	. = ..()
	. += span_danger("There are [length(current_ammo)]/[max_ammo] shots of [length(current_ammo) > 0 ? current_ammo_name : "propellant ammunition"] currently loaded.")
	if(overheat > 0)
		. += span_danger("This weapon's base damage is being raised by [overheat] due to the heat generated by spent rounds.")
	. += span_info(combo_description)
	. += span_danger("This weapon's AoE is indiscriminate. Watch out for friendly fire.")

/// This override lets us toggle comboing on and off.
/obj/item/ego_weapon/city/thumb_east/attack_self(mob/living/user)
	. = ..()
	if(!busy)
		playsound(src, usesound, 100, FALSE)
		if(combo_enabled)
			combo_enabled = FALSE
			to_chat(user, span_info("You are no longer spending ammunition to use combo attacks."))
		else
			combo_enabled = TRUE
			to_chat(user, span_info("You are now spending ammunition to use combo attacks."))

/// Lets people manually unload the weapon, I guess? Maybe the Capo is ordering a Soldato to hand over all their ammo or something.
/obj/item/ego_weapon/city/thumb_east/AltClick(mob/user)
	. = ..()
	if(!busy)
		UnloadRound(user)

/// This override handles initiating a reload.
/obj/item/ego_weapon/city/thumb_east/attackby(obj/item/stack/thumb_east_ammo/I, mob/living/user, params)
	. = ..()
	if(!istype(I))
		return
	// You can't reload while reloading or leaping.
	if(busy)
		return
	// Reject rounds that aren't allowed for this weapon type. Example: don't let the Soldato rifle load Tigermark rounds.
	if(!(I.type in accepted_ammo_table))
		to_chat(user, span_warning("The [I.name] are incompatible with the [src.name]."))
		return
	// If we already have a type of ammunition loaded, and we try to load a different type, reject the round.
	if(I.type != current_ammo_type && current_ammo_type)
		to_chat(user, span_warning("There is a different type of ammunition currently loaded. Spend or unload the ammunition first to load this round."))
		return

	var/bullets_in_hand = I.amount
	// I don't foresee this happening but who knows
	if(bullets_in_hand < 1)
		return
	// If our weapon ejects all cartridges, spent and unspent, on reload, then we just load as many bullets as we have in our hand into it.
	if(spent_ammo_behaviour == SPENT_RELOADEJECT)
		INVOKE_ASYNC(src, PROC_REF(Reload), bullets_in_hand, I, user)
		return
	// Otherwise we load the remaining capacity.
	else
		// If we made it past those checks, we just have to check now if we can fit any more rounds into the gun.
		var/bullets_in_gun = length(current_ammo)
		if((bullets_in_gun + 1) <= max_ammo)
			var/remaining_magazine_capacity = max_ammo - bullets_in_gun
			var/bullet_amount_to_load = min(bullets_in_hand, remaining_magazine_capacity)
			INVOKE_ASYNC(src, PROC_REF(Reload), bullet_amount_to_load, I, user)
		else
			to_chat(user, span_warning("The [src.name] cannot fit any more ammunition - it is fully loaded."))

/// This override just makes sure we drop all our ammo and null our ammo reference list if the weapon is destroyed.
/obj/item/ego_weapon/city/thumb_east/Destroy(force)
	for(var/obj/item/stack/thumb_east_ammo/leftover in current_ammo)
		leftover.forceMove(get_turf(src))
	for(var/obj/item/stack/thumb_east_ammo/spent_leftover in spent_cartridges)
		spent_leftover.forceMove(get_turf(src))
	current_ammo = null
	spent_cartridges = null
	if(combo_reset_timer)
		deltimer(combo_reset_timer)
	return ..()

/// Attacking.
/obj/item/ego_weapon/city/thumb_east/attack(mob/living/target, mob/living/user)
	// Land a regular hit if the user manually disabled combos. Will also reset a combo chain and remove any bonuses from fired rounds. But we get overheat bonus.
	if(!combo_enabled)
		ReturnToNormal()
		// Decay our overheat bonus, but don't let it go negative...
		overheat = max(0, overheat - 0.5)
		return ..()
	switch(combo_stage)
		// Importantly: every time we want to fire a round, we should use SpendAmmo(user).
		// In the case of our Lunge and our Finisher, SpendAmmo has been called already before we get to the current proc.
		// You may notice that the hitsound gets nulled here a couple times. This is so we can manually play the special's own hitsound without it varying, and with extra range.

		// This case is for attacks that haven't consumed a round.
		if(COMBO_NO_AMMO)
			ReturnToNormal(user)
			// Decay our overheat bonus, but don't let it go negative...
			overheat = max(0, overheat - 0.5)
			return ..()
		// This case is for an attack made out of a lunge.
		if(COMBO_LUNGE)
			hitsound = null
			. = ..()
			playsound(src, lunge_sound, 100, FALSE, 10)
			hitsound = initial(hitsound)
			// Your next hit after the lunge will actually come out faster than normal. This is a reward for being able to handle the abrupt movement and screenshake.
			user.changeNext_move(CLICK_CD_MELEE * attack_speed * 0.9)
			ApplyStatusEffects(target, COMBO_LUNGE)
			combo_stage = COMBO_ATTACK2
			return
		// This case is for when we're going to perform the second hit in our combo. We haven't spent the ammo for it yet, so we have to do it on this proc.
		if(COMBO_ATTACK2)
			var/fired_round = SpendAmmo(user)
			if(fired_round)
				hitsound = null
				. = ..()
				playsound(src, sweep_sound, 100, FALSE, 10)
				hitsound = initial(hitsound)
				user.changeNext_move(CLICK_CD_MELEE * attack_speed * 1.3)
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
			hitsound = null
			. = ..()
			playsound(src, finisher_sound, 100, FALSE, 10)
			hitsound = initial(hitsound)
			user.changeNext_move(CLICK_CD_MELEE * attack_speed * 1.2)
			// We finished the combo! Reset it.
			deltimer(combo_reset_timer)
			ReturnToNormal(user)
			return

		// We should never ever reach this else block, but here it is, just in case.
		else
			ReturnToNormal(user)
			overheat = max(0, overheat - 0.5)
			. = ..()

/// This overridden proc is only called when attacking something next to us. Basically we want to intercept any possible melee attacks when we're at our finisher stage,
/// so we can do our finisher instead.
/obj/item/ego_weapon/city/thumb_east/pre_attack(atom/A, mob/living/user, params)
	var/mob/living/target = A
	// Returning "TRUE" here means we're halting the melee attack chain.
	if(!CanUseEgo(user))
		return TRUE
	if(busy)
		return TRUE

	if(combo_stage == COMBO_FINISHER && combo_enabled)
		if(finisher_type == FINISHER_LEAP)
			. = Leap(target, user)
		if(finisher_type == FINISHER_PIERCE)
			. = Pierce(target, user)
		return
	return . = ..()

/// This overridden proc is called even at range. So we're gonna use it to attempt to lunge (combo starter) or leap (combo finisher for podao) as appropiate.
/obj/item/ego_weapon/city/thumb_east/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	// Returning "TRUE" here means we're halting the melee attack chain.
	if(!CanUseEgo(user))
		return TRUE
	if(!isliving(target))
		return TRUE
	if(busy)
		return TRUE
	. = ..()
	if(combo_enabled)
		switch(combo_stage)
			if(COMBO_NO_AMMO)
				if((get_dist(user, target) < 2))
					return FALSE
				else
					. = Lunge(target, user)
					return
			if(COMBO_FINISHER)
				if(finisher_type == FINISHER_LEAP)
					// pre_attack actually handles the Leap() call if we're next to our target.
					if((get_dist(user, target) < 2))
						return FALSE
					. = Leap(target, user)
				return
	return

////////////////////////////////////////////////////////////
// AMMO MANAGEMENT PROCS SECTION.
// These are the procs used to handle the loading and usage of ammunition.

/// Channeled process for reloading the weapon. Can be interrupted.
/obj/item/ego_weapon/city/thumb_east/proc/Reload(amount_to_load, obj/item/stack/thumb_east_ammo/ammo_item, mob/living/carbon/user)
	// This first section is the reload start. You can cancel it, with the only consequence at this point being that you lose your overheat bonus.
	playsound(src, reload_start_sound, 100, FALSE, 10)
	to_chat(user, span_info("You begin loading your [src.name]..."))
	overheat = 0
	busy = TRUE
	if(do_after(user, 0.6 SECONDS, src, progress = TRUE, interaction_key = "thumb_east_reload", max_interact_count = 1))
		// If we reached this part, we've started the reload properly now. Being interrupted at this point causes a ReloadFailure(), you will spill the ammo you're loading.
		// This first block will eject all our spent and unspent ammo if we're using a weapon with SPENT_RELOADEJECT behaviour (the podao).
		if(spent_ammo_behaviour == SPENT_RELOADEJECT)
			var/list/all_cartridges = list()
			all_cartridges |= spent_cartridges
			all_cartridges |= current_ammo
			for(var/obj/item/stack/thumb_east_ammo/round in all_cartridges)
				INVOKE_ASYNC(src, PROC_REF(EjectRound), round, user)

		// This is the actual reload. Each round takes 0.4 seconds to load, so this will at most last 2.4 seconds if you're fully reloading the Podao.
		// I'm unsure if it's wise because it's pretty obvious when you're reloading, so people might just... shove you and cancel it. Needs some playtesting.
		// An alternative would be to have a set reload duration and divide it by the amount we're going to load. But that feels weird.
		for(var/i in 1 to amount_to_load)
			if(do_after(user, (0.4 SECONDS), src, progress = TRUE, interaction_key = "thumb_east_reload", max_interact_count = 1))
				var/obj/item/stack/thumb_east_ammo/new_bullet = ammo_item.split_stack(user, 1)
				if(new_bullet)
					// We actually store the round INSIDE the weapon. If the weapon is destroyed we'll drop them.
					new_bullet.should_merge = FALSE
					new_bullet.forceMove(src)
					current_ammo += new_bullet
					current_ammo_type = ammo_item.type
					current_ammo_name = ammo_item.name
					playsound(src, reload_load_sound, 100, FALSE, 8)
					to_chat(user, span_info("You load a [ammo_item.singular_name] into the [src.name]."))
			// If we reach this else block, it means our reload got interrupted in some way, so we drop the ammo we're trying to load into the weapon and scatter it.
			else
				INVOKE_ASYNC(src, PROC_REF(ReloadFailure), ammo_item, user)
				busy = FALSE
				return FALSE
		busy = FALSE
	else
		busy = FALSE
		to_chat(user, span_danger("You abort your reload!"))
		return FALSE

	// We only reach this part if we successfully loaded the rounds we wanted to load.
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, reload_end_sound, 100, FALSE, 10), 0.2 SECONDS)
	return TRUE

/// This proc happens if your reloading gets interrupted after you've started loading rounds into the weapon. You spill the ammo you were trying to load on the floor.
/obj/item/ego_weapon/city/thumb_east/proc/ReloadFailure(obj/item/stack/thumb_east_ammo/ammo_item, mob/living/carbon/user)
	playsound(src, reload_fail_sound, 100, FALSE, 6)
	user.visible_message(span_danger("[user] fumbles while reloading, spilling the ammo on the floor!"), span_danger("You fumble while reloading, spilling the ammo on the floor!"))
	for(var/i in 1 to ammo_item.amount)
		var/obj/item/stack/thumb_east_ammo/spilled_bullet = ammo_item.split_stack(user, 1)
		if(spilled_bullet)
			spilled_bullet.forceMove(user.drop_location())
			spilled_bullet.throw_at(get_ranged_target_turf(user, pick(GLOB.alldirs), 1), 1, 5, spin = TRUE)
			sleep(1)

/// Remove one round from the weapon. Prioritizes live rounds when possible.
/obj/item/ego_weapon/city/thumb_east/proc/UnloadRound(mob/living/user)
	// If we're out of live rounds...
	if(AmmoDepletedCheck())
		// A SPENT_INSTANTEJECT weapon wouldn't have any spent rounds that we can unload. There's nothing left inside the weapon.
		if(spent_ammo_behaviour == SPENT_INSTANTEJECT)
			to_chat(user, span_warning("There's no ammo left to unload."))
			return FALSE
		// If we reach this part, then we're unloading a SPENT_RELOADEJECT weapon that has no live rounds left. Try to unload a spent round.
		var/obj/item/stack/spent_round = pick_n_take(spent_cartridges)
		if(spent_round)
			to_chat(user, span_notice("You unload a [spent_round.singular_name] from your [src.name]."))
			playsound(src, 'sound/weapons/gun/pistol/drop_small.ogg', 100, FALSE)
			user.put_in_hands(spent_round)
			overheat = 0
			return TRUE
	else
		// We do have ammo left in the weapon.
		var/obj/item/stack/live_round = pick_n_take(current_ammo)
		removeNullsFromList(current_ammo)
		if(live_round)
			to_chat(user, span_notice("You unload a [live_round.singular_name] from your [src.name]."))
			playsound(src, 'sound/weapons/gun/pistol/drop_small.ogg', 100, FALSE)
			user.put_in_hands(live_round)
			overheat = 0
			return TRUE
	// We reach this part if we had no ammo but no spent rounds either.
	to_chat(user, span_warning("There's no ammo left to unload."))
	return FALSE

/// Returns TRUE if we're out of ammo.
/obj/item/ego_weapon/city/thumb_east/proc/AmmoDepletedCheck()
	if(length(current_ammo) <= 0)
		return TRUE
	return FALSE

/// This proc tries to spend a round, and if it is able to, calls HandleFiredAmmo() and CreateSpentCartridge() with that round, then returns TRUE. If it can't, returns FALSE.
/// Important: This proc doesn't delete the fired round, but removes it from our reference list. If it is not deleted later, then it will remain in the weapon's contents.
/// That being said it shouldn't cause any issues because of that.
/obj/item/ego_weapon/city/thumb_east/proc/SpendAmmo(mob/living/user)
	// If we try to spend ammo but don't have any, we reset our combo.
	if(AmmoDepletedCheck())
		ReturnToNormal(user)
		return FALSE
	// We need to delete this round that was fired later by the way.
	var/obj/item/stack/thumb_east_ammo/fired_round = pick_n_take(current_ammo)
	// Did we run out of ammo *after* firing that last round? Set the current type to null so we can load a different kind of ammo if we want.
	if(AmmoDepletedCheck())
		current_ammo_type = null
		current_ammo_name = ""

	// Just in case some jank happens with our list.
	removeNullsFromList(current_ammo)

	if(fired_round)
		shake_camera(user, 1.5, 3)
		INVOKE_ASYNC(src, PROC_REF(PropulsionVisual), get_turf(user), fired_round.aesthetic_shockwave_distance)
		CreateSpentCartridge(fired_round, user)
		// This proc is the one that actually adds the bonuses to our weapon from the round that we fired.
		HandleFiredAmmo(fired_round, user)
		return TRUE
	return FALSE

/// This proc is passed a round, stores the bonuses it should provide to the weapon according to the current combo stage and the round's properties, then deletes the round.
/// It also sets a timer to reset the combo.
/obj/item/ego_weapon/city/thumb_east/proc/HandleFiredAmmo(obj/item/stack/thumb_east_ammo/round, mob/living/user)
	if(round)
		force = (initial(force) * motion_values[combo_stage]) + round.flat_force_base * motion_values[combo_stage]
		overheat += round.heat_generation
		detonation_sound = round.detonation_sound
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
		var/combo_reset_timer_duration = 5 SECONDS
		// You get a tiny bit of extra time to land your finisher. This is mostly because leaping is a channeled action.
		// Why are we checking for COMBO_ATTACK2? Because that'll be when the last timer started before we attempt to do our finisher.
		if(combo_stage == COMBO_ATTACK2)
			combo_reset_timer_duration += 2 SECONDS
		combo_reset_timer = addtimer(CALLBACK(src, PROC_REF(ReturnToNormal), user), combo_reset_timer_duration, TIMER_STOPPABLE)
		qdel(round)

/// Creates a spent cartridge, then ejects it if the weapon is SPENT_INSTANTEJECT or stores it if the weapon is SPENT_RELOADEJECT.
/obj/item/ego_weapon/city/thumb_east/proc/CreateSpentCartridge(obj/item/stack/thumb_east_ammo/round, mob/living/user)
	var/obj/item/stack/thumb_east_ammo/spent/new_spent_cartridge = null
	new_spent_cartridge = new round.spent_type(src)
	// Do I really need to null check here? I'm not sure.
	if(new_spent_cartridge)
		// Store the spent cartridge if our behaviour is SPENT_RELOADEJECT. Otherwise, instantly eject it.
		if(spent_ammo_behaviour == SPENT_RELOADEJECT)
			spent_cartridges |= new_spent_cartridge
		else
			INVOKE_ASYNC(src, PROC_REF(EjectRound), new_spent_cartridge, user)

/// This proc is used to eject both spent and unspent cartridges. It should be called by Reload() to eject all rounds when reloading on SPENT_RELOADEJECT weapons.
/// It will also be called for each spent cartridge created if the weapon is SPENT_INSTANTEJECT.
/// Don't mistake this for UnloadRound() - that proc puts the cartridge directly in your hands.
/obj/item/ego_weapon/city/thumb_east/proc/EjectRound(obj/item/stack/thumb_east_ammo/cartridge, mob/living/user)
	if(cartridge in current_ammo)
		current_ammo -= cartridge
	else if(cartridge in spent_cartridges)
		spent_cartridges -= cartridge

	if(AmmoDepletedCheck())
		current_ammo_type = null
		current_ammo_name = ""

	// This block is adapted code from actual bullet casings for SS13 guns. We just slightly randomize its pixel offsets and throw it somewhere nearby.
	// The cartridge's should_merge should be set to FALSE, so they won't automatically stack up with eachother until some overworked Soldato deigns to stack them manually.
	cartridge.forceMove(user.drop_location())
	cartridge.pixel_x = cartridge.base_pixel_x + rand(-5, 5)
	cartridge.pixel_y = cartridge.base_pixel_y + rand (-5, 5)
	cartridge.setDir(pick(GLOB.alldirs))
	var/turf/destination = get_ranged_target_turf(user, pick(GLOB.alldirs), 1)
	cartridge.throw_at(destination, rand(1, 2), 6, spin = TRUE)

////////////////////////////////////////////////////////////
// SPECIAL ATTACKS SECTION.
// These are the procs used to handle offensive actions like AoE attacks and applying status effects to the enemy, and all the auxiliary procs they use.

/// This proc is just for a visual effect that creates a "shockwave" or some smoke at the user's location.
/obj/item/ego_weapon/city/thumb_east/proc/PropulsionVisual(turf/origin, radius)
	var/list/already_rendered = list()
	// There may be a less expensive way to do this. I'm open to ideas.
	for(var/i in 1 to radius)
		var/list/turfs_to_spawn_visual_at = list()
		for(var/turf/T in orange(i, origin))
			turfs_to_spawn_visual_at |= T
		turfs_to_spawn_visual_at -= already_rendered
		for(var/turf/T2 in turfs_to_spawn_visual_at)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T2)
			already_rendered |= T2
		sleep(1)

/// This proc is our opener attack. We try to lunge at people from range by spending a round. It is actual stepping, not teleporting.
/// If we reach our target with it, we automatically hit them. If we don't, we can still benefit from the fired round's bonuses if we land a hit before the combo times out.
/obj/item/ego_weapon/city/thumb_east/proc/Lunge(mob/living/target, mob/living/user)
	// This will not stop you from trying to lunge through transparent objects, but if they are dense, you will not reach your target.
	if(!(can_see(user, target, lunge_range)))
		to_chat(user, span_warning("You can't reach your target!"))
		return FALSE
	if(lunge_cooldown > world.time)
		to_chat(user, span_warning("You're not ready to lunge yet!"))
		return FALSE

	combo_stage = COMBO_LUNGE
	// Check to see if we've got a round to fire.
	var/fired_round = SpendAmmo(user)
	if(fired_round)
		lunge_cooldown = world.time + lunge_cooldown_duration
		// Aesthetics.
		to_chat(user, span_danger("You lunge at [target] using the propulsion from your [src.name]!"))
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
		// We return TRUE regardless of whether we hit them with the lunge or not. What we care about is if we spent the round to lunge at the target.
		return TRUE
	else
		to_chat(user, span_warning("You pull the trigger to lunge at [target], but you have no ammo left."))
		combo_stage = COMBO_NO_AMMO
		return FALSE

/// This proc is the implementation for FINISHER_LEAP. Telegraphed, channeled windup into a teleport hit that causes an AoE.
/// Currently, this is able to go through non-opaque but dense turfs (glass). I think it's fine like this, but if it isn't, I could copy can_see's code and alter it so it ignores transparency.
/obj/item/ego_weapon/city/thumb_east/proc/Leap(mob/living/target, mob/living/user)
	// Telegraph the beginning of the leap to give some chance for counterplay.
	user.say("*grin")
	user.visible_message(span_userdanger("[user] prepares to leap towards [target]...!"), span_danger("You prepare to leap towards [target]...!"))
	playsound(src, 'sound/weapons/ego/thumb_east_podao_leap_prep.ogg', 100, FALSE, 10)
	// We root the user in place to prevent them from accidentally breaking their combo.
	user.Immobilize(finisher_windup)
	// Set this to make sure we can't do some goofy stuff while preparing to leap.
	busy = TRUE
	// This is a slightly modified do_after from the Deepscan Kit. This shouldn't fail unless you get disarmed or swap hands or do something weird.
	// We also check here to ensure our combo didn't expire before it goes off.
	if(do_after(user, finisher_windup, target, IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE, TRUE, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(can_see), user, target, 7), "thumb_finisher_leap", 1) && combo_stage == COMBO_FINISHER)
		user.say("Firing all rounds!")
		// Spend a round.
		if(SpendAmmo(user))
			playsound(src, detonation_sound, 100, FALSE, 10)
			// This block of code is for aesthetics regarding the leaping animation.
			// We figure out whether the target is to our left or right through this (or in the same x).
			var/horizontal_difference = target.x - user.x
			var/x_to_offset = 0
			// We figure out in which horizontal direction we should animate the leap.
			switch(horizontal_difference)
				if(0)
					x_to_offset = 0
				if(1 to INFINITY)
					x_to_offset = 32
				if(-INFINITY to -1)
					x_to_offset = -32
			animate(user, 0.4 SECONDS, easing = QUAD_EASING, pixel_y = user.base_pixel_y + 16, pixel_x = user.base_pixel_x + x_to_offset, alpha = 0)
			sleep(0.4 SECONDS)
			// It's okay if we're on top of the target or next to them, get_ranged_target_turf_direct will just return our own turf anyways.
			var/turf/landing_zone = get_ranged_target_turf_direct(user, target, get_dist(user, target) - 1)
			// Janky way to leap at someone? Yes, I guess it is. It can always be made into a "dash" like the lunge is, but I think this is better.
			landing_zone.is_blocked_turf(TRUE) ? user.forceMove(get_turf(target)) : user.forceMove(landing_zone)
			// Make us appear as though we're coming in really fast from the direction of our starting point.
			user.pixel_x *= 2.5
			user.pixel_x *= -1
			user.pixel_y += 16
			animate(user, 0.2 SECONDS, easing = QUAD_EASING, pixel_y = user.base_pixel_y, pixel_x = user.base_pixel_x, alpha = 255)
			sleep(0.2 SECONDS)
			busy = FALSE
			// Hit the target. We do our AoE and statuses before the attackby() because hitting the target with a finisher clears our bonuses and resets our combo.
			ComboAOE(target, user, COMBO_FINISHER)
			ApplyStatusEffects(target, COMBO_FINISHER)
			target.attackby(src, user)

			return TRUE
		// Uh oh. We didn't have ammo.
		else
			user.visible_message(span_userdanger("[user] pulls the trigger on their [src.name], but nothing happens!"), span_danger("You pull the trigger on your [src.name]. Nothing happens. Holy shit, you must look really dumb. Leave no witnesses standing."))

	// We only reach this block if the do_after fails or we're no longer in our COMBO_FINISHER stage.
	// The do_after can fail if our target isn't in sight anymore, we swap hands, we get stunned or something of the sort.
	else
		to_chat(user, span_warning("Your leap is interrupted!"))
		combo_stage = COMBO_NO_AMMO
	busy = FALSE
	return FALSE

/// This proc is the special finisher for FINISHER_PIERCE. It's just a single target hit with flavour. Thought about adding a line AOE to it, but I think it's fine as is.
/obj/item/ego_weapon/city/thumb_east/proc/Pierce(mob/living/target, mob/living/user)
	// Spend a bullet.
	if(SpendAmmo(user))
		// All this gathering of turfs is purely for VFX purposes. But if we ever want to add AoE to this, we'd use them for that purpose.
		var/turf/start_turf = get_turf(user)
		var/turf/end_turf = get_ranged_target_turf_direct(user, target, 2)
		var/list/vfx_turfs = null
		if(start_turf && end_turf)
			vfx_turfs = getline(start_turf, end_turf)
		// The following three lines are the only ones that actually matter for the attack.
		user.visible_message(span_userdanger("[user] pierces [target] with a devastating, explosive strike!"), span_danger("You pierce [target] with a devastating, explosive strike!"))
		// Status has to be applied before hitting them, because hitting them will clear our bonuses since this is a finisher.
		ApplyStatusEffects(target, COMBO_FINISHER)
		target.attackby(src, user)
		if(vfx_turfs)
			vfx_turfs -= start_turf
			INVOKE_ASYNC(src, PROC_REF(PierceVFX), vfx_turfs)
		return TRUE
	// We only reach this else block if we didn't manage to spend a bullet. We will just hit them normally in this case.
	else
		user.visible_message(span_userdanger("[user] pulls the trigger on their [src.name], but nothing happens!"), span_danger("You pull the trigger on your [src.name]. Nothing happens."))
		return FALSE

/// Creates visual effects in given turf list for Pierce finisher.
/obj/item/ego_weapon/city/thumb_east/proc/PierceVFX(list/turf/vfx_turfs)
	sleep(0.3 SECONDS)
	for(var/turf/T in vfx_turfs)
		new /obj/effect/temp_visual/thumb_east_aoe_impact(T)
		sleep(0.1 SECONDS)

/// This proc applies status effects to a target. Make sure to pass it the hit type that is causing the statuses: finishers can tremor-burst and AOEs apply half the stacks.
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
		target.apply_lc_tremor(tremor_to_apply, tremorburst_threshold)
	if(burn_to_apply >= 1)
		target.apply_lc_burn(burn_to_apply)

/// This proc is just cleanup on the weapon's state, and called whenever a combo ends, is cancelled or times out.
/// Importantly, it will also apply our overheat bonus to our force, if we have any.
/obj/item/ego_weapon/city/thumb_east/proc/ReturnToNormal(mob/user)
	force = initial(force) + overheat
	next_hit_should_apply = list()
	if(combo_stage != COMBO_NO_AMMO && combo_stage != COMBO_LUNGE)
		combo_stage = COMBO_NO_AMMO
		to_chat(user, span_warning("Your combo resets!"))

/// This proc handles the AoE for our second attack and our finisher. It's indiscriminate - hopefully people don't FF too much with it? That could be changed if needed.
/obj/item/ego_weapon/city/thumb_east/proc/ComboAOE(mob/target, mob/user, hit_type)
	// First, determine how large the AOE should be.
	var/aoe_radius = (hit_type == COMBO_ATTACK2 ? attack2_aoe_base_radius : finisher_aoe_base_radius)
	var/propellant_radius_bonus = next_hit_should_apply["aoe_radius_bonus"]
	if(propellant_radius_bonus)
		aoe_radius += floor(propellant_radius_bonus)

	// Calculate the AoE damage. We get the base damage from:
	// (Initial force of the weapon + flat force bonus from the round fired) * Motion value of the AoE type * A special coefficient for secondary targets of the AoE type
	// We later apply Justice scaling, but we also save the non-Justice-scaling damage for PvP.
	var/aoe = (initial(force) + next_hit_should_apply["aoe_flat_force_bonus"]) * motion_values[hit_type + "_aoe"]
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	aoe*=force_multiplier
	// We recently disabled Justice scaling in PvP so we also need to store a non-justice modified value to apply damage to human mobs.
	var/aoe_no_justice = aoe
	aoe*=justicemod

	// We determine the tiles which should be hit.
	var/list/affected_turfs = list()
	for(var/turf/T in (hit_type == COMBO_ATTACK2 ? orange(aoe_radius, user) : range(aoe_radius, target)))
		affected_turfs |= T

	// This is where the hit happens.
	for(var/turf/T2 in affected_turfs)
		new /obj/effect/temp_visual/thumb_east_aoe_impact(T2)
		for(var/mob/living/L in T2)
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

/// This is the Thumb East Capo's weapon. Obviously it's not as terrifying as the Sottocapo's shotgun since it isn't ranged, but it's stronger than the Sottocapo Cane.
/// Using ammo makes it truly fearsome, especially in PvP since it has two guaranteed hits (if you can land the clicks, and if they don't break LoS) in its combo.
/// It's a little under par in terms of DPS if you don't use ammo.
/obj/item/ego_weapon/city/thumb_east/podao
	name = "thumb east podao"
	desc = "A traditional podao fitted with a system to load specialized propellant ammunition. Even Thumb Capos can struggle to handle the impressive thrust generated by this blade."
	icon_state = "salvador"
	inhand_icon_state = "salvador"
	hitsound = 'sound/weapons/ego/thumb_east_podao_attack.ogg'
	reload_start_sound = 'sound/weapons/ego/thumb_east_podao_reload_start.ogg'
	reload_load_sound = 'sound/weapons/ego/thumb_east_podao_reload_load.ogg'
	reload_end_sound = 'sound/weapons/ego/thumb_east_podao_reload_end.ogg'
	lunge_sound = 'sound/weapons/ego/thumb_east_podao_boostedlunge.ogg'
	sweep_sound =  'sound/weapons/ego/thumb_east_podao_boostedsweep.ogg'
	finisher_sound = 'sound/weapons/ego/thumb_east_podao_leap_impact.ogg'
	force = 60
	attack_speed = 1.1
	max_ammo = 6
	spent_ammo_behaviour = SPENT_RELOADEJECT
	finisher_aoe_base_radius = 1
	finisher_type = FINISHER_LEAP
	accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility,
		/obj/item/stack/thumb_east_ammo/tigermark,
		/obj/item/stack/thumb_east_ammo/tigermark/facility,
	)
	combo_description = "This weapon's combo consists of a long-range lunge, followed by a circular AoE sweep around the user, and ends with a devastating but telegraphed AoE leap on the target.\n"+\
	"If you trigger but miss your lunge, you can still continue the combo by landing a regular hit on-target."
	motion_values = list(COMBO_NO_AMMO = 1, COMBO_LUNGE = 1, COMBO_ATTACK2 = 1.2, COMBO_FINISHER = 2, COMBO_ATTACK2_AOE = 0.7, COMBO_FINISHER_AOE = 1)

////////////////////////////////////////////////////////////
// AMMUNITION SECTION.
// These are stackable items. They don't really do much on their own. The Thumb East weapons handle the logic for loading and firing them.
// Most of this code is just for holding the properties bullets should have when fired.

/// This is the standard ammo type. Thumb East Soldatos will use it for their rifles, and the Capo may use it for their Podao as well.
/// It's nothing crazy, but it adds force to their attacks, and of course, tremor and burn. These could combo in a really nasty way with Augments.
/// NEVER PUT THESE IN FACILITY MODES.
/obj/item/stack/thumb_east_ammo
	name = "scorch propellant ammunition"
	desc = "Ammunition used by the Thumb in eastern parts of the City. These rounds aren't fired at targets, rather they provide additional propulsion to the swings and stabs of Thumb weaponry."
	singular_name = "scorch propellant round"
	max_amount = 6
	icon_state = "thumb_east"
	novariants = FALSE
	merge_type = /obj/item/stack/thumb_east_ammo

	/// What item does this turn into when it gets spent?
	var/spent_type = /obj/item/stack/thumb_east_ammo/spent
	/// We need this var for some stack item shenanigans, they will try to merge at very inconvenient times just to spite you.
	/// Such as inside your weapon, filling your ammo list with nulls...
	var/should_merge = TRUE
	/// This variable holds the path to the sound file played when this round is consumed.
	var/detonation_sound = 'sound/weapons/ego/thumb_east_rifle_detonation.ogg'
	/// This variable holds the distance that the aesthetic "shockwave" will travel after this round is fired.
	var/aesthetic_shockwave_distance = 2
	/// Controls how much overheat is generated when spending this round. It's a decaying flat force increase on non-combo hits that gets cleared on reload/unload.
	/// Please never make this negative.
	var/heat_generation = 1
	/// Controls how much tremor is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/tremor_base = 5
	/// Controls how much burn is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/burn_base = 2
	/// Adds flat force to an attack boosted with this ammo. Multiplied by a motion value coefficient depending on combo stage.
	var/flat_force_base = 5
	/// AOE radius bonus when spending this shell on an AOE attack. Please never let this be too high or it will cause funny incidents. This is never multiplied.
	var/aoe_radius_bonus = 0


/obj/item/stack/thumb_east_ammo/examine(mob/user)
	. = ..()
	. += span_notice("This ammunition increases weapon base damage by [flat_force_base] when fired.")
	. += span_notice("It generates [heat_generation] heat when fired.")
	. += span_notice("It [tremor_base >= 1 ? "applies [tremor_base]" : "does not apply"] tremor stacks on target hit after firing.")
	. += span_notice("It [burn_base >= 1 ? "applies [burn_base]" : "does not apply"] burn stacks on target hit after firing.")
	. += span_notice("It [aoe_radius_bonus >= 1 ? "adds [aoe_radius_bonus]" : "does not add any extra"] tiles of radius to AoE attacks on target hit after firing.")

/// This override is so we can use 6 sprites instead of 3 to count the bullets individually. I basically just copy pasted the old code.
/obj/item/stack/thumb_east_ammo/update_icon_state()
	if(novariants)
		return
	if(amount == 1)
		icon_state = initial(icon_state)
		return
	if(amount >= 6)
		icon_state = "[initial(icon_state)]_6"
		return
	else
		icon_state = "[initial(icon_state)]_[amount]"


// I know this override looks weird, but there's a good reason for it. There's a certain behaviour stack objects have where subtypes can merge to their parent types,
// which we really don't want for this specific item and its subtypes. As in, we don't want scorch propellant rounds to get mixed up with Tigermark rounds or surplus rounds.
/obj/item/stack/thumb_east_ammo/can_merge(obj/item/stack/check)
	// We need to actually check we're going to access the merge_type of a stacking object, because this proc is called on absolutely everything these items cross...
	if(istype(check, /obj/item/stack))
		if(!istype(src, check.merge_type))
			return FALSE
	if(!should_merge)
		return FALSE
	. = ..()

/// We set their should_merge to FALSE when loading them into a weapon or spilling them on the floor. This override lets players manually stack them despite this.
/obj/item/stack/thumb_east_ammo/attackby(obj/item/W, mob/user, params)
	if(W.type == src.type)
		var/obj/item/stack/thumb_east_ammo/we_hit = W
		we_hit.should_merge = TRUE
		src.should_merge = TRUE
	. = ..()


/// Facility version of the basic ammunition. No status effects, but has a nice amount of force bonus to compensate.
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

/// Tigermark rounds. These only fit in the Thumb East Podao, so only the Capo should be using them. Expensive, but devastating.
/// The Capo shouldn't even need to use these, they can just use the default ammo. When these get pulled out it's because things got real.
/obj/item/stack/thumb_east_ammo/tigermark
	name = "tigermark rounds"
	desc = "Powerful propellant ammunition used by the Eastern Thumb. It greatly enhances the power of slashes, and its detonation sounds like the roar of a tiger.\n"+\
	"One of these rounds might cost more than the life of some Fixers."
	singular_name = "tigermark round"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark
	spent_type = /obj/item/stack/thumb_east_ammo/spent/tigermark
	detonation_sound = 'sound/weapons/ego/thumb_east_podao_detonation.ogg'
	aesthetic_shockwave_distance = 2
	heat_generation = 2
	tremor_base = 8
	burn_base = 4
	flat_force_base = 12
	aoe_radius_bonus = 1

/obj/item/stack/thumb_east_ammo/tigermark/examine(mob/user)
	. = ..()
	. += span_info("This ammunition is only compatible with thumb east podaos.")

/// Off-brand Tigermark rounds. For lucky Agents in Facility mode, basically. No status, but a really big chunk of force bonus on each hit, and it keeps it AoE bonus.
/obj/item/stack/thumb_east_ammo/tigermark/facility
	name = "ligermark rounds"
	desc = "Wait... this isn't a Tigermark round at all, is it? Well... it's about the same caliber, so it would probably fit into a Thumb East podao."
	singular_name = "ligermark round"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark/facility
	tremor_base = 0
	burn_base = 0
	flat_force_base = 16
	aoe_radius_bonus = 1

// Spent ammunition types. Please don't put this on any weapon's accepted ammunition table.
// These spent cartridges can be brought back to the Thumb's ammo vendor to refund part of the cost, or they can be sold by Fixers or Rats.

/obj/item/stack/thumb_east_ammo/spent
	name = "spent propellant ammunition casings"
	desc = "A spent cartridge of some propellant ammunition used by the Thumb. Smells like gunpowder. This might be worth something."
	singular_name = "spent propellant ammunition casing"
	icon_state = "thumb_east_spent"
	merge_type = /obj/item/stack/thumb_east_ammo/spent
	// Don't let them merge until someone picks them up.
	should_merge = FALSE
	heat_generation = 0
	tremor_base = 0
	burn_base = 0
	flat_force_base = 0
	aoe_radius_bonus = 0

/obj/item/stack/thumb_east_ammo/spent/tigermark
	name = "spent tigermark cartridges"
	desc = "Expensive-looking cartridges. Smells like gunpowder. This might be worth something."
	singular_name = "spent tigermark cartridge"
	merge_type = /obj/item/stack/thumb_east_ammo/spent/tigermark


////////////////////////////////////////////////////////////
// VFX SECTION.
// These are just the temporary visual effects created by Thumb East weaponry.

/obj/effect/temp_visual/thumb_east_aoe_impact
	name = "scorched earth"
	desc = "It smells like gunpowder."
	duration = 0.7 SECONDS
	icon_state = "visual_fire"
	color = "#6e1616"
	alpha = 80

#undef COMBO_NO_AMMO
#undef COMBO_LUNGE
#undef COMBO_ATTACK2
#undef COMBO_ATTACK2_AOE
#undef COMBO_FINISHER
#undef COMBO_FINISHER_AOE
#undef FINISHER_PIERCE
#undef FINISHER_LEAP
#undef SPENT_INSTANTEJECT
#undef SPENT_RELOADEJECT
