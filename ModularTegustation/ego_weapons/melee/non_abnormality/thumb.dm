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
	desc = "A rifle used by thumb capos. The gun is inlaid with silver."
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
	desc = "A handgun used by thumb sottocapos. While expensive, its power is rarely matched among syndicates."
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
	desc = "A pair of dusters sometimes used by thumb capos."
	icon_state = "thumb_duster"
	force = 44
	damtype = RED_DAMAGE

	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'

/obj/item/ego_weapon/city/thumbcane
	name = "thumb sottocapo cane"
	desc = "A cane used by thumb sottocapos."
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
// These weapons will show up in City and Facility. City: Thumb East starting gear and Thumb crates. Facility: Thumb crates.
// The ammunition they use comes with its own "stats". Ammunition available in Facility mode should NEVER have status effects on it.
// Ammo can either be live or spent. Live ammo can be used for the weapons, spent ammo is useless garbage in Facility mode, but in City mode it can be sold or recycled.
// The lifecycle of ammo is as follows:
// 1. A live round is placed into a Thumb East weapon. It gets split from the stack it was part of and placed inside the weapon, and associated to its current_ammo list.
// 2A. You can unload the live round and retrieve it from the weapon by alt clicking it. Any live rounds in the weapon will also be ejected if you attempt a reload on a weapon with spent_ammo_behaviour = SPENT_RELOADEJECT
// 2B. If the round is used with SpendAmmo(), it is removed from the current_ammo list, its spent_type is created and the original round is deleted.
// 3. If the weapon's spent_ammo_behaviour is SPENT_INSTANTEJECT, the newly created spent round is ejected immediately. If it is SPENT_RELOADEJECT, it remains inside the weapon and the spent_cartridges list until reload/unload.

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
	// Rifle sprites by Yumi
	icon = 'ModularTegustation/Teguicons/thumb_east_obj.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/thumb_east_held_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/thumb_east_held_right.dmi'
	icon_state = "thumb_east_rifle"
	inhand_icon_state = "thumb_east_rifle"
	hitsound = 'sound/weapons/ego/thumb_east_rifle_attack.ogg'
	usesound = 'sound/machines/click.ogg'
	attack_verb_continuous = list("pierces", "skewers", "stabs")
	attack_verb_simple = list("pierce", "skewer", "stab")
	force = 40
	damtype = RED_DAMAGE
	attack_speed = 1.3
	swingstyle = WEAPONSWING_THRUST
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	special = "This is a Thumb East weapon. Load it with propellant ammunition to unlock a powerful combo. Initiate the combo by attacking from range. Each hit of the combo requires 1 propellant round to trigger, and have varying damage and attack speed. Your combo will cancel if you run out of ammo, wait more than 5 seconds between hits, or hit without spending a round.\n"+\
	"Hit the weapon with a handful of propellant ammunition to attempt to load as much of the handful as possible. Toggle your combo on or off by using this weapon in-hand. Alt-click the weapon to unload a round.\n"+\
	"Spending ammo with this weapon generates heat. Heat increases the base damage of the weapon when not using combo attacks. It decays on each hit and is reset on reloading or unloading."
	/// This list holds the bonuses that our next hit should deal. The keys for them are ["tremor"], ["burn"], ["aoe_flat_force_bonus"] and ["aoe_size_bonus"].
	// I wanted to use a define like NEXTHIT_PROPELLANT_TREMOR_BONUS = next_hit_should_apply["tremor"] to simplify readability and maintainability...
	// but it didn't work. Sorry.
	var/next_hit_should_apply = list()

	// 	Combo variables.
	/// Should always be TRUE unless the user manually disables combos by using the weapon in-hand. If it's FALSE, we won't try to combo when hitting.
	var/combo_enabled = TRUE
	/// Description for the combo. Explain it to the user.
	var/combo_description = "This weapon's combo consists of a long-range lunge, followed by a circular AoE sweep around the user, and ends with a powerful line AoE through the target.\n"+\
	"If you trigger but miss your lunge, you can still continue the combo by landing a regular hit on-target."
	/// Which step in the combo are we at? COMBO_NO_AMMO means we're either out of ammo, just ended a combo, or haven't started it.
	var/combo_stage = COMBO_NO_AMMO
	/// Variable that holds the reset timer for our combo.
	var/combo_reset_timer
	/// Variable that determines the standard combo reset timer duration. Gets +2s added onto it after COMBO_ATTACK2, so you have more time to do a finisher.
	var/combo_reset_timer_duration = 5 SECONDS
	/// List which maps the coefficients by which to multiply our damage on each hit depending on the state of the combo.
	var/list/motion_values = list(COMBO_NO_AMMO = 1, COMBO_LUNGE = 1, COMBO_ATTACK2 = 1.2, COMBO_FINISHER = 1.5, COMBO_ATTACK2_AOE = 0.8, COMBO_FINISHER_AOE = 1,)
	/// This variable holds a flat force increase that is only applied on COMBO_NO_AMMO hits. It increases when ammo is spent, and gets reset on reload or unload.
	/// It decays on each hit that isn't part of a combo.
	var/overheat = 0

	// Special attack variables.
	/// Distance in tiles which our initial lunge reaches.
	var/lunge_range = 3
	/// Duration of the cooldown for our lunge (we don't want people spam-lunging exclusively in PVP, etc). This also limits how often you can start a combo.
	var/lunge_cooldown_duration = 13 SECONDS
	/// Holds the timer for our lunge so we can clean it up later.
	var/lunge_cooldown_timer
	/// Are we ready to lunge?
	var/lunge_ready = TRUE
	/// Base radius in tiles for the second attack's AoE range. Should be at least 1.
	var/attack2_aoe_base_radius = 1
	/// Value in tiles for the radius of the Leap Finisher AoE and the length of the Pierce Finisher AoE.
	var/finisher_aoe_base_size = 2
	/// Type of finisher this weapon uses.
	var/finisher_type = FINISHER_PIERCE
	/// The windup our finisher has, if it has any. FINISHER_PIERCE shouldn't use this, but FINISHER_LEAP will use it. That can change in the future though.
	var/finisher_windup = 1.6 SECONDS
	/// Are we currently performing a channeled action like leaping or reloading?
	var/busy = FALSE

	// Ammo variables.
	/// Maximum ammo capacity that this weapon can hold.
	var/max_ammo = 3
	/// How long does the reload start phase last?
	var/reload_start_windup = 0.6 SECONDS
	/// How long does it take to load each individual round?
	var/reload_load_windup = 0.4 SECONDS
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

/// Includes the most immediately important info for the weapon: ammo amount and type, heat (if any), a description of the combo and a reminder that it can FF.
/obj/item/ego_weapon/city/thumb_east/examine(mob/user)
	. = ..()
	. += span_danger("There are [length(current_ammo)]/[max_ammo] shots of [length(current_ammo) > 0 ? current_ammo_name : "propellant ammunition"] currently loaded.")
	if(overheat > 0)
		. += span_danger("This weapon's base damage is being raised by [overheat] due to the heat generated by spent rounds.")
	. += span_info(combo_description)
	. += span_danger("This weapon's AoE is indiscriminate. Watch out for friendly fire.")

/// Using the weapon in-hand toggles comboing on and off.
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

/// Alt-click lets people manually unload. Should rarely if ever be used, but important for those RP moments where a Capo orders a Soldato to give them ammo, or Thumb surrenders and unloads their guns.
/obj/item/ego_weapon/city/thumb_east/AltClick(mob/user)
	. = ..()
	if(!busy)
		UnloadRound(user)

/// Initiate a reload if we hit the weapon with some ammo.
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
	if(spent_ammo_behaviour != SPENT_RELOADEJECT && I.type != current_ammo_type && current_ammo_type)
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

/// Cleans up some stuff in case the weapon is destroyed, also drops any ammo inside it.
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
		overheat = max(0, overheat - 0.2)
		return ..()
	// Here's the core of the weapon. We have to make sure the appropiate bonuses are applied to the weapon before we call ..(), which is the hit itself.
	switch(combo_stage)
		// Importantly: every time we want to fire a round, we should use SpendAmmo(user).
		// In the case of our Lunge and our Finisher, SpendAmmo has been called already before we get to the current proc.
		// You may notice that the hitsound gets nulled here a couple times. This is so we can manually play the special's own hitsound without it varying, and with extra range.

		// This case is for attacks that haven't consumed a round.
		if(COMBO_NO_AMMO)
			ReturnToNormal(user)
			// Decay our overheat bonus, but don't let it go negative...
			overheat = max(0, overheat - 0.2)
			return ..()
		// This case is for an attack made out of a lunge. Lunge() is triggered in afterattack() from range, and the fired round bonuses are applied at that point.
		if(COMBO_LUNGE)
			// We already set hitsound in Lunge().
			. = ..()
			hitsound = initial(hitsound)
			// Tiny malus on attack speed after hitting a lunge, to avoid crazy burst damage and add a feeling of "weight" to the next attack..
			user.changeNext_move(CLICK_CD_MELEE * attack_speed * 1.1)
			ApplyStatusEffects(target, COMBO_LUNGE)
			combo_stage = COMBO_ATTACK2
			return
		// This case is for when we're going to perform the second hit in our combo. We haven't spent the ammo for it yet, so we have to do it on this proc.
		if(COMBO_ATTACK2)
			var/fired_round = SpendAmmo(user)
			if(fired_round)
				hitsound = null
				. = ..()
				playsound(src, sweep_sound, 100, FALSE, 14)
				hitsound = initial(hitsound)
				user.changeNext_move(CLICK_CD_MELEE * attack_speed * 1.3)
				RadiusAOE(target, user, COMBO_ATTACK2)
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
			playsound(src, finisher_sound, 100, FALSE, 14)
			hitsound = initial(hitsound)
			user.changeNext_move(CLICK_CD_MELEE * attack_speed * 1.2)
			// We finished the combo! Reset it.
			deltimer(combo_reset_timer)
			ReturnToNormal(user)
			return

		// We should never ever reach this else block, but here is a failsafe.
		else
			ReturnToNormal(user)
			overheat = max(0, overheat - 0.2)
			. = ..()

/// This overridden proc is only called when attacking something next to us. Basically we want to intercept any possible melee attempts when we're at our finisher stage,
/// so we can do our finisher instead.
/obj/item/ego_weapon/city/thumb_east/pre_attack(atom/A, mob/living/user, params)
	var/mob/living/target = A
	// Returning "TRUE" here means we're halting the melee attack chain.
	if(busy)
		return TRUE

	if(combo_stage == COMBO_FINISHER && combo_enabled && isliving(target))
		if(finisher_type == FINISHER_LEAP && CanUseEgo(user))
			. = Leap(target, user)
		if(finisher_type == FINISHER_PIERCE && CanUseEgo(user))
			. = Pierce(target, user)
		return
	return . = ..()

/// This proc is called after an attack, but more importantly for us, it does not care about proximity. Therefore this is what we use to attempt to call a Lunge() or Leap().
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
	else
		to_chat(user, span_userdanger("Combo attacks with this weapon are currently disabled, use it in-hand to re-enable them."))
	return

/// I've been asked by several people to let you light cigars with Thumb East weapons. I mean... okay.
/// Was tempted to give this a chance to burn you but I'll be nice.
/// That being said if another coder happens to find this code and accidentally adds a prob or fortitude check to decap you, I clean my hands of it.
/obj/item/ego_weapon/city/thumb_east/ignition_effect(atom/A, mob/user)
	. = ""
	if(SpendAmmo(user))
		. = span_danger("[user] fires their [src.name], using the exhaust to nonchalantly light [A]. They don't even flinch from the recoil. Holy shit.")
		playsound(src, detonation_sound, 100, FALSE, 14)
	return .

////////////////////////////////////////////////////////////
// AMMO MANAGEMENT PROCS SECTION.
// These are the procs used to handle the loading and usage of ammunition.

/// Returns TRUE if we're out of ammo. Also resets our current ammo type and name.
/obj/item/ego_weapon/city/thumb_east/proc/AmmoDepletedCheck()
	if(length(current_ammo) <= 0)
		current_ammo_type = null
		current_ammo_name = ""
		return TRUE
	return FALSE

/// Remove one round from the weapon. Prioritizes live rounds when possible.
/obj/item/ego_weapon/city/thumb_east/proc/UnloadRound(mob/living/user)
	// If we're out of live rounds...
	if(AmmoDepletedCheck())
		// A SPENT_INSTANTEJECT weapon wouldn't have any spent rounds that we can unload, they'd have been ejected when created. There's Nothing There inside the weapon.
		if(spent_ammo_behaviour == SPENT_INSTANTEJECT)
			to_chat(user, span_warning("There's no ammo left to unload."))
			return FALSE
		// If we reach this part, then we're unloading a SPENT_RELOADEJECT weapon that has no live rounds left. Try to unload a spent round.
		var/obj/item/stack/spent_round = pick_n_take(spent_cartridges)
		if(spent_round)
			to_chat(user, span_notice("You unload a [spent_round.singular_name] from your [src.name]."))
			playsound(src, 'sound/weapons/gun/pistol/drop_small.ogg', 100, FALSE)
			user.put_in_hands(spent_round)
			VentHeat(user)
			ReturnToNormal(user)
			return TRUE
	else
		// We do have ammo left in the weapon.
		var/obj/item/stack/live_round = pick_n_take(current_ammo)
		removeNullsFromList(current_ammo)
		if(live_round)
			to_chat(user, span_notice("You unload a [live_round.singular_name] from your [src.name]."))
			playsound(src, 'sound/weapons/gun/pistol/drop_small.ogg', 100, FALSE)
			user.put_in_hands(live_round)
			VentHeat(user)
			ReturnToNormal(user)
			AmmoDepletedCheck()
			return TRUE
	// We reach this part if we had no ammo but no spent rounds either.
	to_chat(user, span_warning("There's no ammo left to unload."))
	return FALSE

/// This proc is used to eject both spent and unspent cartridges. It should be called by Reload() to eject all rounds when reloading on SPENT_RELOADEJECT weapons.
/// It will also be called for each spent cartridge created if the weapon is SPENT_INSTANTEJECT.
/// Don't mistake this for UnloadRound() - that proc puts the cartridge directly in your hands.
/obj/item/ego_weapon/city/thumb_east/proc/EjectRound(obj/item/stack/thumb_east_ammo/cartridge, mob/living/user)
	if(cartridge in current_ammo)
		current_ammo -= cartridge
	else if(cartridge in spent_cartridges)
		spent_cartridges -= cartridge

	AmmoDepletedCheck()

	// This block is adapted code from actual bullet casings for SS13 guns. We just slightly randomize its pixel offsets and throw it somewhere nearby.
	cartridge.forceMove(user.drop_location())
	cartridge.pixel_x = cartridge.base_pixel_x + rand(-7, 7)
	cartridge.pixel_y = cartridge.base_pixel_y + rand (-7, 7)
	var/turf/destination = get_ranged_target_turf(user, pick(GLOB.alldirs), 1)
	cartridge.throw_at(destination, rand(1, 2), 6, spin = TRUE)
	cartridge.setDir(pick(GLOB.alldirs))

/// Channeled process for reloading the weapon. Can be interrupted.
/obj/item/ego_weapon/city/thumb_east/proc/Reload(amount_to_load, obj/item/stack/thumb_east_ammo/ammo_item, mob/living/carbon/user)
	// This first section is the reload start. You can cancel it, with the only consequence at this point being that you lose your overheat bonus.
	playsound(src, reload_start_sound, 100, FALSE, 10)
	to_chat(user, span_info("You begin loading your [src.name]..."))
	VentHeat(user)
	ReturnToNormal(user)
	busy = TRUE
	if(do_after(user, reload_start_windup, src, progress = TRUE, interaction_key = "thumb_east_reload", max_interact_count = 1))
		// If we reached this line, we've started the reload properly now. Being interrupted at this point causes a ReloadFailure(), you will spill the ammo you're loading.
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
		// Was also considering giving you a defensive buff while reloading.
		for(var/i in 1 to amount_to_load)
			if(do_after(user, (reload_load_windup), src, progress = TRUE, interaction_key = "thumb_east_reload", max_interact_count = 1))
				var/obj/item/stack/thumb_east_ammo/new_bullet = ammo_item.split_stack(user, 1)
				if(new_bullet)
					// We actually store the round INSIDE the weapon. If the weapon is destroyed we'll drop them.
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

	// We only reach this part if we successfully loaded the rounds we wanted to load. Play the reload_end_sound with a small delay so it sounds nicer.
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
			spilled_bullet.setDir(pick(GLOB.alldirs))
			sleep(1)

/// This proc tries to spend a round, and if it is able to, calls ApplyAmmoBonuses() and CreateSpentCartridge() with that round, then returns TRUE. If it can't, returns FALSE.
/// Important: This proc doesn't delete the fired round, but removes it from our reference list. If it is not deleted later, then it will remain in the weapon's contents.
/// That being said it shouldn't cause any issues because of that.
/obj/item/ego_weapon/city/thumb_east/proc/SpendAmmo(mob/living/user)
	// If we try to spend ammo but don't have any, we reset our combo.
	if(AmmoDepletedCheck())
		ReturnToNormal(user)
		return FALSE
	// We need to delete this round that was fired later by the way.
	var/obj/item/stack/thumb_east_ammo/fired_round = pick_n_take(current_ammo)
	// Did we run out of ammo *after* firing that last round? We just call this to clear our ammo type if we're dry.
	AmmoDepletedCheck()
	// Just in case some jank happens with our list.
	removeNullsFromList(current_ammo)

	if(fired_round)
		shake_camera(user, 1.5, 3)
		INVOKE_ASYNC(src, PROC_REF(PropulsionVisual), get_turf(user), fired_round.aesthetic_shockwave_distance)
		CreateSpentCartridge(fired_round, user)
		// This proc is the one that actually adds the bonuses to our weapon from the round that we fired.
		ApplyAmmoBonuses(fired_round, user)
		return TRUE
	return FALSE

/// This proc is passed a round, stores the bonuses it should provide to the weapon according to the current combo stage and the round's properties, then deletes the round.
/// It also sets a timer to reset the combo.
/obj/item/ego_weapon/city/thumb_east/proc/ApplyAmmoBonuses(obj/item/stack/thumb_east_ammo/round, mob/living/user)
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
		if(round.aoe_size_bonus > 0)
			next_hit_should_apply["aoe_size_bonus"] = round.aoe_size_bonus

		deltimer(combo_reset_timer)
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

/obj/item/ego_weapon/city/thumb_east/proc/VentHeat(mob/living/user)
	if(overheat > 0)
		overheat = 0
		playsound(src, 'sound/effects/ordeals/steel/gcorp_hiss.ogg', 75, FALSE, 4)
		to_chat(user, span_danger("You vent [src]'s remaining heat to access its ammo storage!"))

////////////////////////////////////////////////////////////
// SPECIAL ATTACKS SECTION.
// These are the procs used to handle offensive actions such as the special attacks in our combo, and all the auxiliary procs that they use.

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

/// This proc allows us to start a new combo by lunging and alerts the user in chat.
/obj/item/ego_weapon/city/thumb_east/proc/ReadyToLunge(mob/user)
	lunge_ready = TRUE
	lunge_cooldown_timer = null
	if(combo_stage == COMBO_NO_AMMO)
		to_chat(user, span_nicegreen("You're ready to lunge and begin a new combo again."))
	else
		to_chat(user, span_nicegreen("You're ready to lunge again, once your current combo is finished."))

/// This proc is our opener attack. We try to lunge at people from range by spending a round. It is actual stepping, not teleporting.
/// If we reach our target with it, we automatically hit them. If we don't, we can still benefit from the fired round's bonuses if we land a hit before the combo times out.
/obj/item/ego_weapon/city/thumb_east/proc/Lunge(mob/living/target, mob/living/user)
	// This will not stop you from trying to lunge through transparent objects, but if they are dense, you will not reach your target.
	if(!(can_see(user, target, lunge_range)))
		to_chat(user, span_warning("You can't reach your target!"))
		return FALSE
	if(!lunge_ready)
		to_chat(user, span_warning("You're not ready to lunge yet!"))
		return FALSE

	combo_stage = COMBO_LUNGE
	// Check to see if we've got a round to fire.
	var/fired_round = SpendAmmo(user)
	if(fired_round)
		lunge_ready = FALSE
		lunge_cooldown_timer = addtimer(CALLBACK(src, PROC_REF(ReadyToLunge), user), lunge_cooldown_duration)
		// Aesthetics.
		to_chat(user, span_danger("You lunge at [target] using the propulsion from your [src.name]!"))
		var/turf/takeoff_turf = get_turf(user)
		new /obj/effect/temp_visual/thumb_east_aoe_impact(takeoff_turf)
		// This code is stolen from Dark Carnival, aside from the sleep(). Why is it "for i in 2 to dist"? I think it's because it's excluding the user and target tiles.
		for(var/i in 2 to get_dist(user, target))
			step_towards(user, target)
		// If we managed to close the gap, hit the target automatically.
		if((get_dist(user, target) < 2))
			hitsound = lunge_sound
			target.attackby(src,user)
		else
			// Normally we play a boostedlunge.ogg sound when landing a lunge. If we activated lunge but didn't hit our target, play only the bullet detonation sound.
			playsound(src, detonation_sound, 100, FALSE, 14)
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
	playsound(src, 'sound/weapons/ego/thumb_east_podao_leap_prep.ogg', 100, FALSE, 14)
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
			playsound(src, detonation_sound, 100, FALSE, 14)
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
			RadiusAOE(target, user, COMBO_FINISHER)
			ApplyStatusEffects(target, COMBO_FINISHER)
			target.attackby(src, user)
			shake_camera(target, 2, 4)
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

/// This proc is the special finisher for FINISHER_PIERCE. It's a single target hit with a line AOE for secondary targets.
/obj/item/ego_weapon/city/thumb_east/proc/Pierce(mob/living/target, mob/living/user)
	// Spend a bullet.
	if(SpendAmmo(user))
		// First, determine how long the line AOE should be.
		var/aoe_length = finisher_aoe_base_size
		var/propellant_radius_bonus = next_hit_should_apply["aoe_size_bonus"]
		if(propellant_radius_bonus)
			aoe_length += floor(propellant_radius_bonus)
		var/turf/start_turf = get_turf(user)
		var/turf/end_turf = get_ranged_target_turf_direct(user, target, aoe_length)
		var/list/aoe_turfs = list()
		if(start_turf && end_turf)
			aoe_turfs = getline(start_turf, end_turf)
			aoe_turfs -= start_turf
		// Status has to be applied before hitting them, because hitting them will clear our bonuses since this is a finisher.
		ApplyStatusEffects(target, COMBO_FINISHER)
		AOEHit(aoe_turfs, target, user, COMBO_FINISHER)
		target.attackby(src, user)
		shake_camera(target, 2, 2)

		return TRUE
	// We only reach this else block if we didn't manage to spend a bullet. We will just hit them normally in this case.
	else
		user.visible_message(span_userdanger("[user] pulls the trigger on their [src.name], but nothing happens!"), span_danger("You pull the trigger on your [src.name]. Nothing happens."))
		return FALSE

/// This proc generates a range-based AoE for our sweep and our leap finisher.
/obj/item/ego_weapon/city/thumb_east/proc/RadiusAOE(mob/target, mob/user, hit_type)
	// First, determine how large the AOE should be.
	var/aoe_radius = (hit_type == COMBO_ATTACK2 ? attack2_aoe_base_radius : finisher_aoe_base_size)
	var/propellant_radius_bonus = next_hit_should_apply["aoe_size_bonus"]
	if(propellant_radius_bonus)
		aoe_radius += floor(propellant_radius_bonus)

	// We determine the tiles which should be hit. COMBO_ATTACK2 should be all tiles around the user minus the epicenter, otherwise it should
	var/list/affected_turfs = list()
	for(var/turf/T in (hit_type == COMBO_ATTACK2 ? orange(aoe_radius, user) : range(aoe_radius, target)))
		affected_turfs |= T
	AOEHit(affected_turfs, target, user, hit_type)

/// This is the proc that handles actually hitting targets in a list of turfs given to it. It will not hit the main target or the user with the AoE.
/obj/item/ego_weapon/city/thumb_east/proc/AOEHit(list/hit_turfs, mob/target, mob/user, hit_type)
	// Calculate the AoE damage. We get the base damage from:
	// (Initial force of the weapon + flat force bonus from the round fired) * Motion value of the AoE type
	// We later apply Justice scaling, but we also save the non-Justice-scaling damage for PvP.
	var/aoe = (initial(force) + next_hit_should_apply["aoe_flat_force_bonus"]) * motion_values[hit_type + "_aoe"]
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	aoe*=force_multiplier
	// We recently disabled Justice scaling in PvP so we also need to store a non-justice modified value to apply damage to human mobs.
	var/aoe_no_justice = aoe
	aoe*=justicemod
	// This is where the hit happens.
	for(var/turf/T in hit_turfs)
		new /obj/effect/temp_visual/thumb_east_aoe_impact(T)
		for(var/mob/living/L in T)
			if(L == user)
				continue
			if(L == target)
				continue
			L.apply_damage((ishuman(L) ? aoe_no_justice : aoe), damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
			if(hit_type == COMBO_ATTACK2)
				ApplyStatusEffects(L, COMBO_ATTACK2_AOE)
				L.visible_message(span_danger("[user] cuts through [L] with a wide, explosive sweep!"))
				shake_camera(L, 1.5, 2)
			else
				ApplyStatusEffects(L, COMBO_FINISHER_AOE)
				L.visible_message(span_danger("[L] is scorched by a powerful blast from [user]'s [src.name]!"))
				shake_camera(L, 2, 3.5)

////////////////////////////////////////////////////////////
// WEAPON SUBTYPES.

/// This is the Thumb East Capo's weapon. Obviously it's not as terrifying as the Sottocapo's shotgun since it isn't ranged, but it's stronger than the Sottocapo Cane.
/// Using ammo makes it truly fearsome, especially in PvP since it has two guaranteed hits (if you can land the clicks, and if they don't break LoS) in its combo.
/// It's a little under par in terms of DPS if you don't use ammo.
/obj/item/ego_weapon/city/thumb_east/podao
	name = "thumb east podao"
	desc = "A traditional podao fitted with a system to load specialized propellant ammunition. Even Thumb Capos can struggle to handle the impressive thrust generated by this blade."
	icon_state = "thumb_east_podao"
	inhand_icon_state = "thumb_east_podao"
	hitsound = 'sound/weapons/ego/thumb_east_podao_attack.ogg'
	reload_start_sound = 'sound/weapons/ego/thumb_east_podao_reload_start.ogg'
	reload_load_sound = 'sound/weapons/ego/thumb_east_podao_reload_load.ogg'
	reload_end_sound = 'sound/weapons/ego/thumb_east_podao_reload_end.ogg'
	lunge_sound = 'sound/weapons/ego/thumb_east_podao_boostedlunge.ogg'
	sweep_sound =  'sound/weapons/ego/thumb_east_podao_boostedsweep.ogg'
	finisher_sound = 'sound/weapons/ego/thumb_east_podao_leap_impact.ogg'
	attack_verb_continuous = list("slashes", "cuts", "chops")
	attack_verb_simple = list("slash", "cut", "chop")
	force = 60
	attack_speed = 1.1
	swingstyle = WEAPONSWING_LARGESWEEP
	swingcolor = "#9e1638"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	max_ammo = 6
	spent_ammo_behaviour = SPENT_RELOADEJECT
	finisher_aoe_base_size = 1
	finisher_type = FINISHER_LEAP
	accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility,
		/obj/item/stack/thumb_east_ammo/tigermark,
		/obj/item/stack/thumb_east_ammo/tigermark/facility,
	)
	combo_description = "This weapon's combo consists of a long-range lunge, followed by a circular AoE sweep around the user, and ends with a devastating but telegraphed AoE leap on the target.\n"+\
	"If you trigger but miss your lunge, you can still continue the combo by landing a regular hit on-target."
	motion_values = list(COMBO_NO_AMMO = 1, COMBO_LUNGE = 1, COMBO_ATTACK2 = 1.3, COMBO_FINISHER = 2, COMBO_ATTACK2_AOE = 1, COMBO_FINISHER_AOE = 1.2)

/// Lei Heng's Podao. Players should never ever be given this, it's for staff. Couldn't let the really cool sprite by DWK and Potassium_19 go to waste.
/// It will have a special ability that lets it fire off 6 bullets in a special attack like Furioso or Mirage Storm, but I haven't coded it yet.
/obj/item/ego_weapon/city/thumb_east/podao/tiantui
	name = "tiantui star's blade"
	desc = "A traditional podao fitted with a system to load specialized propellant ammunition. It inspires awe - this isn't a normal blade, is it...?"
	// Tiantui Star's Blade obj sprite by Potassium_19 and inhand sprites by DWK
	icon_state = "thumb_east_tiantuistarblade"
	inhand_icon_state = "thumb_east_tiantuistarblade"
	force = 92
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)
	max_ammo = 12
	lunge_cooldown_duration = 7 SECONDS
	/// Okay so I kinda need to let you reload it twice since handful of ammo max size is 6 and this sword can fit up to 12 bullets. It's staff only, shouldn't matter too much.
	spent_ammo_behaviour = SPENT_INSTANTEJECT
	accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility,
		/obj/item/stack/thumb_east_ammo/tigermark,
		/obj/item/stack/thumb_east_ammo/tigermark/facility,
		/obj/item/stack/thumb_east_ammo/tigermark/savage,
	)

////////////////////////////////////////////////////////////
// AMMUNITION SECTION.
// These are stackable items. They don't really do much on their own. The Thumb East weapons handle the logic for loading and firing them.
// Ammo lifecycle is explained in a comment on line 100 of this file.

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
	w_class = WEIGHT_CLASS_NORMAL
	full_w_class = WEIGHT_CLASS_BULKY
	/// Should this ammo describe its effects when examined? Set to FALSE for spent rounds.
	var/should_show_effects = TRUE
	/// What item does this turn into when it gets spent?
	var/spent_type = /obj/item/stack/thumb_east_ammo/spent
	/// This variable holds the path to the sound file played when this round is consumed.
	var/detonation_sound = 'sound/weapons/ego/thumb_east_rifle_detonation.ogg'
	/// This variable holds the distance that the aesthetic "shockwave" will travel after this round is fired.
	var/aesthetic_shockwave_distance = 2
	/// Controls how much overheat is generated when spending this round. It's a decaying flat force increase on non-combo hits that gets cleared on reload/unload.
	/// Please never make this negative.
	var/heat_generation = 2
	/// Controls how much tremor is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/tremor_base = 5
	/// Controls how much burn is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/burn_base = 2
	/// Adds flat force to an attack boosted with this ammo. Multiplied by a motion value coefficient depending on combo stage.
	var/flat_force_base = 8
	/// AOE radius bonus when spending this shell on an AOE attack. Please never let this be too high or it will cause funny incidents. This is never multiplied.
	var/aoe_size_bonus = 0


/obj/item/stack/thumb_east_ammo/examine(mob/user)
	. = ..()
	. += span_danger("This ammunition becomes bulky when the stack reaches an amount of [(max_amount / 3) * 2]. Split it to store it in your backpack.")
	if(should_show_effects)
		. += span_notice("This ammunition increases weapon base damage by [flat_force_base] when fired.")
		. += span_notice("It generates [heat_generation] heat when fired.")
		. += span_notice("It [tremor_base >= 1 ? "applies [tremor_base]" : "does not apply"] tremor stacks on target hit after firing.")
		. += span_notice("It [burn_base >= 1 ? "applies [burn_base]" : "does not apply"] burn stacks on target hit after firing.")
		. += span_notice("It [aoe_size_bonus >= 1 ? "adds [aoe_size_bonus]" : "does not add any extra"] tiles of size to AoE attacks on target hit after firing.")

/// This override is so we can use 6 sprites instead of 3 to count the bullets individually.
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

/// Override Crossed to stop them from automerging when in the same location. Should only merge with player input.
/obj/item/stack/thumb_east_ammo/Crossed(atom/movable/crossing)
	if(istype(crossing, /obj/item/stack/thumb_east_ammo))
		return FALSE
	. = ..()

/// This override is so the ammo becomes bulky and you can't store it in your bag if you're carrying too much.
/obj/item/stack/thumb_east_ammo/update_weight()
	if(amount >= (max_amount / 3) * 2)
		w_class = full_w_class
	else
		w_class = initial(w_class)

// There's a certain behaviour stack objects have where subtypes can merge to their parent types, which we really don't want for this specific item and its subtypes.
// As in, we don't want scorch propellant rounds to get mixed up with Tigermark rounds or surplus rounds.
/obj/item/stack/thumb_east_ammo/can_merge(obj/item/stack/check)
	// We need to actually check we're going to access the merge_type of a stacking object, because this proc is called on absolutely everything these items cross...
	if(istype(check, /obj/item/stack))
		if(!istype(src, check.merge_type))
			return FALSE
	. = ..()

/// Normally if you use a stack item inhand, it opens a crafting menu. We don't really want people opening the recipes menu here. You can't craft anything with this item.
/obj/item/stack/thumb_east_ammo/ui_interact(mob/user, datum/tgui/ui)
	return FALSE

/// Facility version of the basic ammunition. No status effects, but has a nice amount of force bonus to compensate. Shows up in Thumb lootcrates.
/obj/item/stack/thumb_east_ammo/facility
	name = "surplus propellant ammunition"
	desc = "Some strange ammunition used in certain weapons, though it isn't actually fired as a projectile. It looks to be in pretty bad shape.\n"+\
	"Why would someone use a gun if not to fire a bullet? You don't really know the answer, but you might as well put this weathered, low-quality ammo to use."
	singular_name = "surplus propellant round"
	merge_type = /obj/item/stack/thumb_east_ammo/facility
	tremor_base = 0
	burn_base = 0
	flat_force_base = 12
	aesthetic_shockwave_distance = 1

/// Tigermark rounds. These only fit in the Thumb East Podao, so only the Capo should be using them. Expensive, but devastating.
/// The Capo shouldn't even need to use these, they can just use the default ammo. When these get pulled out it's because things got real.
/obj/item/stack/thumb_east_ammo/tigermark
	name = "tigermark rounds"
	desc = "Powerful propellant ammunition used by the Eastern Thumb. It greatly enhances the power of slashes, and its detonation sounds like the roar of a tiger.\n"+\
	"One of these rounds might cost more than the life of some Fixers."
	singular_name = "tigermark round"
	icon_state = "thumb_east_tigermark"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark
	spent_type = /obj/item/stack/thumb_east_ammo/spent/tigermark
	detonation_sound = 'sound/weapons/ego/thumb_east_podao_detonation.ogg'
	aesthetic_shockwave_distance = 2
	heat_generation = 3
	tremor_base = 8
	burn_base = 4
	flat_force_base = 12
	aoe_size_bonus = 1

/obj/item/stack/thumb_east_ammo/tigermark/examine(mob/user)
	. = ..()
	. += span_info("This ammunition is only compatible with thumb east podaos.")

/// Off-brand Tigermark rounds. No status, but a really big chunk of force bonus on each hit, and it keeps its AoE bonus. Shows up in Thumb lootcrates.
/obj/item/stack/thumb_east_ammo/tigermark/facility
	/// Open to better ideas for the name
	name = "ligermark rounds"
	desc = "Wait... this isn't a Tigermark round at all, is it? Well... it's about the same caliber, so it would probably fit into a Thumb East podao."
	singular_name = "ligermark round"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark/facility
	tremor_base = 0
	burn_base = 0
	flat_force_base = 20
	aoe_size_bonus = 1

/// Staff only. Never ever give this to players.
/obj/item/stack/thumb_east_ammo/tigermark/savage
	name = "savage tigermark rounds"
	desc = "Extremely powerful ammunition used by a certain high-ranking Capo of the Thumb. Its detonation sounds like the roar of a tiger.\n"+\
	"You should be honoured if this is used to kill you."
	singular_name = "savage tigermark round"
	icon_state = "thumb_east_savage"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark/savage
	spent_type = /obj/item/stack/thumb_east_ammo/spent/tigermark/savage
	detonation_sound = 'sound/weapons/ego/thumb_east_podao_detonation.ogg'
	aesthetic_shockwave_distance = 3
	heat_generation = 4
	tremor_base = 14
	burn_base = 7
	flat_force_base = 20
	aoe_size_bonus = 2

// Spent ammunition types. Please don't put this on any weapon's accepted ammunition table.
// These spent cartridges can be brought back to the Thumb's ammo vendor to refund part of the cost, or they can be sold by Fixers or Rats.

/obj/item/stack/thumb_east_ammo/spent
	name = "spent propellant ammunition casings"
	desc = "A spent cartridge of some propellant ammunition used by the Thumb. Smells like gunpowder. This might be worth something."
	singular_name = "spent propellant ammunition casing"
	icon_state = "thumb_east_spent"
	merge_type = /obj/item/stack/thumb_east_ammo/spent
	should_show_effects = FALSE
	heat_generation = 0
	tremor_base = 0
	burn_base = 0
	flat_force_base = 0
	aoe_size_bonus = 0

/// The only thing this override does is prevent the spent cartridges from merging on initialize. This is so they don't merge when created inside a SPENT_RELOADEJECT weapon.
/obj/item/stack/thumb_east_ammo/spent/Initialize(mapload, new_amount, merge = FALSE, list/mat_override=null, mat_amt=1)
	. = ..()

/obj/item/stack/thumb_east_ammo/spent/tigermark
	name = "spent tigermark cartridges"
	desc = "Expensive-looking cartridges. Smells like gunpowder. This might be worth something."
	icon_state = "thumb_east_tigermark_spent"
	singular_name = "spent tigermark cartridge"
	merge_type = /obj/item/stack/thumb_east_ammo/spent/tigermark

/obj/item/stack/thumb_east_ammo/spent/tigermark/savage
	name = "spent savage tigermark cartridges"
	desc = "Very expensive looking spent cartridges. Smells like gunpowder and expensive cigars. Someone must have had a terrible day if these were used on them, huh? Be glad it wasn't you."
	icon_state = "thumb_east_savage_spent"
	singular_name = "spent savage tigermark cartridge"
	merge_type = /obj/item/stack/thumb_east_ammo/spent/tigermark/savage

////////////////////////////////////////////////////////////
// VFX SECTION.
// These are just the temporary visual effects created by Thumb East weaponry.

/obj/effect/temp_visual/thumb_east_aoe_impact
	name = "scorched earth"
	desc = "It smells like gunpowder."
	duration = 0.6 SECONDS
	icon_state = "visual_fire"
	color = "#6e162c"
	alpha = 100

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
