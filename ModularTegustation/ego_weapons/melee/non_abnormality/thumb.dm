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

// Thumb East weaponry below.
// These weapons use "ammo" as propellant to boost their attack power.

#define COMBO_NO_AMMO "no_ammo"
#define COMBO_LUNGE "lunge"
#define COMBO_SWEEP "sweep"
#define COMBO_SWEEP_AOE "sweep_aoe"
#define COMBO_FINISHER "finisher"


/obj/item/ego_weapon/city/thumb_east
	name = "thumb east soldato rifle"
	desc = "A rifle used by the rank and file of the Thumb in the eastern parts of the City. There is a sharp bayonet built into the front.\n"+\
	"Despite its name and appearance, it is used exclusively for melee combat. Soldatos load these rifles with a special type of propellant ammunition which enhances their strikes."
	icon_state = "thumb_soldato"
	inhand_icon_state = "thumb_soldato"
	force = 36
	damtype = RED_DAMAGE
	attack_speed = 1.4
	special = "This is a Thumb East weapon. Load it with propellant ammunition to unlock a powerful three-hit combo. Initiate the combo by attacking from range.\n"+\
	"The combo consists of a long-distance lunge towards a target, a circular AoE sweep around the user and a powerful AoE finisher on the target."
	/// This list holds the force, tremor stacks and burn stacks that our next hit should deal.
	var/next_hit_should_apply = list()
	// Combo variables.
	/// Which step in the combo are we at? COMBO_NO_AMMO means we're either out of ammo, just ended a combo, or haven't started it.
	var/combo_stage = COMBO_NO_AMMO
	/// Variable that holds the reset timer for our combo.
	var/combo_reset_timer
	/// Distance in tiles which our initial lunge reaches.
	var/lunge_range = 5
	/// Duration of the cooldown for our lunge (we don't want people spam-lunging exclusively in PVP, etc)
	var/lunge_cooldown_duration = 12 SECONDS
	/// Holds the actual world time when we can lunge again.
	var/lunge_cooldown
	/// List which holds the coefficients by which to multiply our damage on each hit depending on the state of the combo.
	var/list/motion_values = list(COMBO_NO_AMMO = 1, COMBO_LUNGE = 1.1, COMBO_SWEEP = 1.3, COMBO_FINISHER = 1.5)
	/// Coefficient for the Sweep AoE, by which damage towards secondary targets will be multiplied. Should always be less than 1.
	var/sweep_secondarytarget_coefficient = 0.5
	/// AOE radius on our finisher. It's 0 for this Soldato rifle, but the actual Capo Podao does have an AOE on it.
	var/finisher_aoe_radius = 0
	/// Coefficient for the Finisher AoE, by which damage towards secondary targets will be multiplied. Should probably be either 1 or a little under 1.
	var/finisher_aoe_secondarytarget_coefficient = 0.5
	// Ammo variables.
	var/max_ammo = 3
	var/list/obj/item/stack/thumb_east_ammo/current_ammo = list()
	var/current_ammo_type = null
	var/list/accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility
	)



/obj/item/ego_weapon/city/thumb_east/attackby(obj/item/stack/thumb_east_ammo/I, mob/living/user, params)
	. = ..()

	if(!istype(I))
		return

	if(!(I.type in accepted_ammo_table))
		to_chat(user, span_warning("The [I.name] are incompatible with the [src.name]."))
		return
	if(I.type != current_ammo_type && current_ammo_type)
		to_chat(user, span_warning("There is a different type of ammunition currently loaded. Spend or unload the ammunition first to load this round."))
		return

	if((length(current_ammo) + 1) <= max_ammo)
		var/obj/item/stack/thumb_east_ammo/new_bullet = I.split_stack(user, 1)
		if(new_bullet)
			new_bullet.forceMove(src)
			current_ammo += new_bullet
			current_ammo_type = I.type
			playsound(src, 'sound/weapons/gun/shotgun/insert_shell.ogg', 100, FALSE, 4)
			to_chat(user, span_info("You load a [I.singular_name] into the [src.name]."))
			return
	else
		to_chat(user, span_warning("The [src.name] cannot fit any more ammunition - it is fully loaded."))

/obj/item/ego_weapon/city/thumb_east/proc/SpendAmmo()
	if(AmmoDepletedCheck())
		return FALSE
	// We need to delete this round that was fired later by the way.
	var/obj/item/stack/thumb_east_ammo/fired_round = pick_n_take(current_ammo)
	if(fired_round)
		playsound(src, fired_round.detonation_sound, 75, FALSE, 8)
	if(AmmoDepletedCheck())
		current_ammo_type = null
	return fired_round

/// Returns TRUE if we're out of ammo.
/obj/item/ego_weapon/city/thumb_east/proc/AmmoDepletedCheck()
	if(length(current_ammo) <= 0)
		return TRUE
	return FALSE

/obj/item/ego_weapon/city/thumb_east/proc/HandleFiredAmmo(obj/item/stack/thumb_east_ammo/round, mob/living/user)
	if(round)
		user.say("Fired a [round.singular_name].")
		force = (initial(force) * motion_values[combo_stage]) + round.flat_force_base * motion_values[combo_stage]
		next_hit_should_apply["aoe_flat_force_bonus"] = round.flat_force_base
		if(round.tremor_base > 0)
			var/tremor_coeff = motion_values[combo_stage] / 1.25
			next_hit_should_apply["tremor"] = round.tremor_base * tremor_coeff
		if(round.burn_base > 0)
			var/burn_coeff = motion_values[combo_stage] / 1.25
			next_hit_should_apply["burn"] = round.burn_base * burn_coeff
		shake_camera(user, 1.5, 3)
		deltimer(combo_reset_timer)
		combo_reset_timer = addtimer(CALLBACK(src, PROC_REF(ReturnToNormal), user), 3.5 SECONDS, TIMER_STOPPABLE)
		qdel(round)

/obj/item/ego_weapon/city/thumb_east/proc/ApplyStatusEffects(mob/living/target, hit_type)
	var/tremorburst_threshold = 999
	var/tremor_to_apply = next_hit_should_apply["tremor"]
	var/burn_to_apply = next_hit_should_apply["burn"]
	if(hit_type == COMBO_FINISHER)
		tremorburst_threshold = 30

	if(tremor_to_apply >= 1)
		target.apply_lc_tremor(tremor_to_apply, tremorburst_threshold)
	if(burn_to_apply >= 1)
		target.apply_lc_burn(burn_to_apply)

/obj/item/ego_weapon/city/thumb_east/proc/ReturnToNormal(mob/user)
	force = initial(force)
	next_hit_should_apply = list()
	if(combo_stage != COMBO_NO_AMMO)
		combo_stage = COMBO_NO_AMMO
		to_chat(user, span_warning("Your combo resets!"))


/obj/item/ego_weapon/city/thumb_east/Destroy(force)
	for(var/obj/leftover in current_ammo)
		leftover.forceMove(src.loc)
	current_ammo = null
	return ..()

/obj/item/ego_weapon/city/thumb_east/attack(mob/living/target, mob/living/user)
	switch(combo_stage)
		if(COMBO_NO_AMMO)
			ReturnToNormal(user)
			return ..()
		if(COMBO_LUNGE)
			. = ..()
			ApplyStatusEffects(target, COMBO_LUNGE)
			combo_stage = COMBO_SWEEP
			return
		if(COMBO_SWEEP)
			var/obj/item/stack/thumb_east_ammo/fired_round = SpendAmmo()
			if(fired_round)
				HandleFiredAmmo(fired_round, user)
				. = ..()
				ComboAOE(target, user, COMBO_SWEEP)
				ApplyStatusEffects(target, COMBO_SWEEP)
				combo_stage = COMBO_FINISHER
				return
			else
				ReturnToNormal(user)
				. = ..()
				return
		if(COMBO_FINISHER)
			var/obj/item/stack/thumb_east_ammo/fired_round = SpendAmmo()
			if(fired_round)
				HandleFiredAmmo(fired_round, user)
				. = ..()
				ComboAOE(target, user, COMBO_FINISHER)
				ApplyStatusEffects(target, COMBO_FINISHER)
				deltimer(combo_reset_timer)
				ReturnToNormal(user)
				return
			else
				ReturnToNormal(user)
				. = ..()
				return
		else
			ReturnToNormal(user)
			. = ..()

// This proc is what we use to check for a possible lunge attack opener. I went off of what Dark Carnival and Limos did.
/obj/item/ego_weapon/city/thumb_east/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!CanUseEgo(user))
		return
	if(!isliving(target))
		return
	if(lunge_cooldown > world.time)
		to_chat(user, span_warning("You're not ready to lunge yet!"))
		return
	if(combo_stage != COMBO_NO_AMMO)
		return
	if((get_dist(user, target) < 2) || (!(can_see(user, target, lunge_range))))
		return
	. = ..()

	var/obj/item/stack/thumb_east_ammo/fired_round = SpendAmmo()
	if(fired_round)
		combo_stage = COMBO_LUNGE
		HandleFiredAmmo(fired_round, user)
		lunge_cooldown = world.time + lunge_cooldown_duration
		// I can only guess as to why this is "for i in 2 to distance", my best guess is that it's excluding the target's own tile and the user's own tile. That seems right?
		to_chat(user, span_warning("You lunge at [target] using the propulsion from your [src.name]!"))
		new /obj/effect/temp_visual/thumb_east_aoe_impact(get_turf(user))
		for(var/i in 2 to get_dist(user, target))
			step_towards(user, target)
			sleep(0.5)
		if((get_dist(user, target) < 2))
			target.attackby(src,user)
	else
		to_chat(user, span_warning("You try to lunge at [target], but you have no ammo left."))


// Took the code from this from Torn Off Wings, which it seems took it from Harvest.
/obj/item/ego_weapon/city/thumb_east/proc/ComboAOE(mob/target, mob/user, hit_type)
	playsound(src, 'sound/abnormalities/scorchedgirl/explosion.ogg', 75, FALSE, 6)
	for(var/turf/T in (hit_type == COMBO_SWEEP ? orange(1, user) : range(finisher_aoe_radius, target)))
		new /obj/effect/temp_visual/thumb_east_aoe_impact(T)
	var/aoe = (initial(force) + next_hit_should_apply["aoe_flat_force_bonus"]) * motion_values[hit_type] * (hit_type == COMBO_SWEEP ? sweep_secondarytarget_coefficient : finisher_aoe_secondarytarget_coefficient)
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	aoe*=justicemod
	aoe*=force_multiplier
	for(var/mob/living/L in (hit_type == COMBO_SWEEP ? range(1, user) : range(finisher_aoe_radius, target)))
		if(L == user)
			continue
		if(L == target)
			continue
		L.apply_damage(aoe, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
		ApplyStatusEffects(L, COMBO_SWEEP_AOE)
		L.visible_message(span_danger("[user] cuts through [L] with a wide, explosive sweep!"))

/obj/item/ego_weapon/city/thumb_east/examine(mob/user)
	. = ..()
	. += span_notice("There are [length(current_ammo)]/[max_ammo] shots of [length(current_ammo) > 0 ? current_ammo[1].name : "propellant ammunition"] currently loaded.")

/obj/item/ego_weapon/city/thumb_east/podao
	name = "thumb east podao"
	desc = "A traditional podao fitted with a system to load specialized propellant ammunition. Even Thumb Capos can struggle to handle the impressive thrust generated by this blade."
	icon_state = "salvador"
	inhand_icon_state = "salvador"
	force = 60
	attack_speed = 1.6
	max_ammo = 6
	finisher_aoe_radius = 2
	accepted_ammo_table = list(
		/obj/item/stack/thumb_east_ammo,
		/obj/item/stack/thumb_east_ammo/facility,
		/obj/item/stack/thumb_east_ammo/tigermark,
	)

/obj/item/stack/thumb_east_ammo
	name = "scorch propellant ammunition"
	desc = "Ammunition used by the Thumb in eastern parts of the City. These rounds aren't used to fire at targets, rather they provide additional propulsion to the swings and stabs of Thumb weaponry."
	singular_name = "scorch propellant round"
	max_amount = 3
	icon_state = "thumb_east"
	novariants = FALSE
	merge_type = /obj/item/stack/thumb_east_ammo
	var/detonation_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	// Varediting any of these variables on an ingame ammo stack won't actually work or change anything.
	// You would have to actually go into the weapon, into its list of ammo, and change these values *there*. But this is an adminbus-only edge case anyhow.
	/// Controls how much tremor is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/tremor_base = 5
	/// Controls how much burn is applied to a target hit with this ammo in an attack. Multiplied by a motion value coefficient depending on combo stage.
	var/burn_base = 2
	/// Adds flat force to an attack boosted with this ammo. Multiplied by a motion value coefficient depending on combo stage.
	var/flat_force_base = 6

/obj/item/stack/thumb_east_ammo/examine(mob/user)
	. = ..()
	. += span_notice("This ammunition increases weapon base damage by [flat_force_base] when fired.")
	. += span_notice("It [tremor_base >= 1 ? "applies [tremor_base]" : "does not apply"] tremor stacks on target hit after firing.")
	. += span_notice("It [burn_base >= 1 ? "applies [burn_base]" : "does not apply"] burn stacks on target hit after firing.")


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
	desc = "Some strange ammunition used in certain weapons, though it isn't actually fired as a projectile. It looks to be in pretty bad shape. You can faintly make out a Thumb insignia on it.\n"+\
	"Why would someone use a gun if not to fire a bullet? You don't really know the answer, but you might as well put this weathered, low-quality ammo to use."
	singular_name = "surplus propellant round"
	merge_type = /obj/item/stack/thumb_east_ammo/facility
	tremor_base = 0
	burn_base = 0
	flat_force_base = 15

/obj/item/stack/thumb_east_ammo/tigermark
	name = "tigermark rounds"
	desc = "Powerful propellant ammunition used by the Eastern Thumb. It greatly enhances the power of slashes, and its detonation sounds like the roar of a tiger.\n"+\
	"One of these rounds might cost more than the life of some Fixers."
	singular_name = "tigermark round"
	merge_type = /obj/item/stack/thumb_east_ammo/tigermark
	detonation_sound = 'sound/abnormalities/fluchschutze/fell_bullet.ogg'
	tremor_base = 8
	burn_base = 4
	flat_force_base = 12

/obj/effect/temp_visual/thumb_east_aoe_impact
	name = "scorched earth"
	desc = "It smells like gunpowder."
	duration = 0.6 SECONDS
	icon_state = "visual_fire"
	color = "#6e1616"

#undef COMBO_NO_AMMO
#undef COMBO_LUNGE
#undef COMBO_SWEEP
#undef COMBO_FINISHER
