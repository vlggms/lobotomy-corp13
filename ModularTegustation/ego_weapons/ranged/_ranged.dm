#define DUALWIELD_PENALTY_EXTRA_MULTIPLIER 1.4

/obj/item/ego_weapon/ranged
	name = "ego gun"
	desc = "Some sort of weapon..?"
	icon = 'icons/obj/ego_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
	icon_state = "detective"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=2000)
	w_class = WEIGHT_CLASS_BULKY //No more stupid 10 egos in bag
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 5
	item_flags = NEEDS_PERMIT
	attack_verb_continuous = list("strikes", "hits", "bashes")
	attack_verb_simple = list("strike", "hit", "bash")
	is_ranged = TRUE

	var/obj/item/firing_pin/pin = /obj/item/firing_pin/magic //standard firing pin for most guns
	var/fire_sound = 'sound/weapons/emitter.ogg' //What sound should play when this ammo is fired

	trigger_guard = TRIGGER_GUARD_ALLOW_ALL	//trigger guard on the weapon, hulks can't fire them with their big meaty fingers

	/// The current projectile we are shooting
	var/obj/projectile/projectile_path = null

	/// Just 'slightly' snowflakey way to modify projectile damage for projectiles fired from this gun.
	var/projectile_damage_multiplier = 1
	/// If the weapon allows dual-weilding/can be used in 1 hand/needs 2 hands
	var/weapon_weight = WEAPON_LIGHT

	/// If set, the gun will allow you to hold your mouse instead of clicking it to fire.
	/// In Rounds per decisecond
	var/autofire = 0

	//// Reload/Ammo mechanics
	/// The amount of shots we hold.
	var/shotsleft = 0
	/// How long it takes to reload this weapon, if blank it wont need to be reloaded
	var/reloadtime = 0 SECONDS
	/// Are we currently reloading?
	var/is_reloading = FALSE

	/// Vars used for when you examine a gun
	var/last_projectile_damage = 0
	var/last_projectile_type = RED_DAMAGE

	/// Controls if pacifists can use the gun or not. Should be TRUE unless you are doing something funky
	var/lethal = TRUE
	/// Should clumsy people shoot themselfes at a chance with it? Usually unused
	var/clumsy_check = TRUE

	/// Sound controls
	var/vary_fire_sound = TRUE
	var/fire_sound_volume = 50
	var/dry_fire_sound = 'sound/weapons/gun/general/dry_fire.ogg'

	var/recoil = 0						//boom boom shake the room
	var/burst_size = 1					//how large a burst is
	var/fire_delay = 0					//rate of fire for burst firing and semi auto
	var/firing_burst = 0				//Prevent the weapon from firing again while already firing
	var/semicd = 0						//cooldown handler
	var/dual_wield_spread = 24			//additional spread when dual wielding
	var/forced_melee = FALSE			//forced to melee attack. Currently only used for the ego_gun subtype

	var/spread = 0						//Spread induced by the gun itself.
	var/randomspread = 1				//Set to 0 for shotguns. This is used for weapons that don't fire all their bullets at once.

	var/ammo_x_offset = 0 //used for positioning ammo count overlay on sprite
	var/ammo_y_offset = 0
	var/flight_x_offset = 0
	var/flight_y_offset = 0

	//Zooming
	var/zoomable = FALSE //whether the gun generates a Zoom action on creation
	var/zoomed = FALSE //Zoom toggle
	var/zoom_amt = 3 //Distance in TURFs to move the user's screen forward (the "zoom" effect)
	var/zoom_out_amt = 0
	var/datum/action/toggle_scope_zoom/azoom
	var/pb_knockback = 0

/obj/item/ego_weapon/ranged/pistol
	attack_speed = 0.5
	force = 6

/obj/item/ego_weapon/ranged/Initialize()
	. = ..()
	if(pin)
		pin = new pin(src)
	build_zooming()
	if(autofire)
		AddComponent(/datum/component/automatic_fire, autofire)

	update_projectile_examine()

/obj/item/ego_weapon/ranged/Destroy()
	if(isobj(pin)) //Can still be the initial path, then we skip
		QDEL_NULL(pin)
	if(azoom)
		QDEL_NULL(azoom)
	return ..()

/obj/item/ego_weapon/ranged/handle_atom_del(atom/A)
	if(A == pin)
		pin = null
	return ..()

/obj/item/ego_weapon/ranged/examine(mob/user)
	. = ..()
	. += GunAttackInfo()
	if(!reloadtime)
		. += span_notice("This weapon has unlimited ammo.")
	else if(shotsleft>0)
		. += span_notice("Ammo Counter: [shotsleft]/[initial(shotsleft)].")
	else
		. += span_danger("Ammo Counter: [shotsleft]/[initial(shotsleft)].")

	if(reloadtime)
		switch(reloadtime)
			if(0 to 0.71 SECONDS)
				. += span_nicegreen("This weapon has a very fast reload.")
			if(0.71 SECONDS to 1.21 SECONDS)
				. += span_notice("This weapon has a fast reload.")
			if(1.21 SECONDS to 1.71 SECONDS)
				. += span_notice("This weapon has a normal reload speed.")
			if(1.71 SECONDS to 2.51 SECONDS)
				. += span_danger("This weapon has a slow reload.")
			if(2.51 to INFINITY)
				. += span_danger("This weapon has an extremely slow reload.")

	switch(weapon_weight)
		if(WEAPON_HEAVY)
			. += span_danger("This weapon requires both hands to fire.")
		if(WEAPON_MEDIUM)
			. += span_notice("This weapon can be fired with one hand.")
		if(WEAPON_LIGHT)
			. += span_nicegreen("This weapon can be dual wielded.")

	if(!autofire)
		switch(fire_delay)
			if(0 to 5)
				. += span_nicegreen("This weapon fires fast.")
			if(6 to 10)
				. += span_notice("This weapon fires at a normal speed.")
			if(11 to 15)
				. += span_notice("This weapon fires slightly slower than usual.")
			if(16 to 20)
				. += span_danger("This weapon fires slowly.")
			else
				. += span_danger("This weapon fires extremely slowly.")
	else
		//Give it to 'em in true rounds per minute, accurate to the 5s
		var/rpm = 600 / autofire
		rpm = round(rpm,5)
		. += span_nicegreen("This weapon is automatic.")
		. += span_notice("This weapon fires at [rpm] rounds per minute.")

	. += span_notice("Examine this weapon more for melee information.")

/obj/item/ego_weapon/ranged/EgoAttackInfo()
	var/damage_type = damtype
	var/damage = force
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	if(force_multiplier != 1)
		return span_notice("It deals [round(damage * force_multiplier, 0.1)] [damage_type] damage in melee. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [damage] [damage_type] damage in melee.")

/obj/item/ego_weapon/ranged/proc/GunAttackInfo()
	if(!last_projectile_damage || !last_projectile_type)
		return span_userdanger("The bullet of this EGO gun has not properly initialized, report this to coders!")
	var/damage_type = last_projectile_type
	var/damage = round(last_projectile_damage, 0.1)
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	if(pellets > 1)	//for shotguns
		return span_notice("Its bullets deal [damage] x [pellets] [damage_type] damage.[projectile_damage_multiplier != 1 ? " (+ [(projectile_damage_multiplier - 1) * 100]%)" : ""]")
	return span_notice("Its bullets deal [damage] [damage_type] damage.[projectile_damage_multiplier != 1 ? " (+ [(projectile_damage_multiplier - 1) * 100]%)" : ""]")

/// Updates the damage/type of projectiles inside of the gun
/obj/item/ego_weapon/ranged/proc/update_projectile_examine()
	if(isnull(projectile_path))
		message_admins("[src] has an invalid projectile path.")
		return
	var/obj/projectile/projectile = new projectile_path(src, src)
	last_projectile_damage = projectile.damage
	last_projectile_type = projectile.damage_type
	qdel(projectile)

/obj/item/ego_weapon/ranged/attack_self(mob/user)
	if(reloadtime && !is_reloading)
		INVOKE_ASYNC(src, PROC_REF(reload_ego), user)
	return ..()

/obj/item/ego_weapon/ranged/proc/reload_ego(mob/user)
	is_reloading = TRUE
	to_chat(user,span_notice("You start loading a new magazine."))
	playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
	if(do_after(user, reloadtime, src)) //gotta reload
		playsound(src, 'sound/weapons/gun/general/bolt_rack.ogg', 50, TRUE)
		shotsleft = initial(shotsleft)
		forced_melee = FALSE //no longer forced to resort to melee

	is_reloading = FALSE

/obj/item/ego_weapon/ranged/equipped(mob/living/user, slot)
	. = ..()
	if(zoomed && user.get_active_held_item() != src)
		zoom(user, user.dir, FALSE) //we can only stay zoomed in if it's in our hands	//yeah and we only unzoom if we're actually zoomed using the gun!!

/obj/item/ego_weapon/ranged/pickup(mob/user)
	..()
	if(azoom)
		azoom.Grant(user)

/obj/item/ego_weapon/ranged/dropped(mob/user)
	. = ..()
	if(azoom)
		azoom.Remove(user)
	if(zoomed)
		zoom(user, user.dir)

//called after the gun has successfully fired its chambered ammo.
/obj/item/ego_weapon/ranged/proc/process_chamber()
	if(reloadtime && shotsleft)
		shotsleft -= 1

//check if there's enough ammo to shoot one time
//i.e if clicking would make it shoot
/obj/item/ego_weapon/ranged/proc/can_shoot()
	if(reloadtime && !shotsleft)
		visible_message(span_notice("The gun is out of ammo."))
		shoot_with_empty_chamber()
		return FALSE

	if(is_reloading)
		return FALSE

	return TRUE

/obj/item/ego_weapon/ranged/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, span_danger("*click*"))
	playsound(src, dry_fire_sound, 30, TRUE)

/// Happens before projectile creation
/obj/item/ego_weapon/ranged/proc/before_firing(atom/target, mob/user)
	return

/obj/item/ego_weapon/ranged/proc/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	if(recoil)
		shake_camera(user, recoil + 1, recoil)

	playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
	if(!message)
		return

	if(!pointblank)
		user.visible_message(span_danger("[user] fires [src]!"), \
							span_danger("You fire [src]!"), \
							span_hear("You hear a gunshot!"), COMBAT_MESSAGE_RANGE)
		return

	user.visible_message(span_danger("[user] fires [src] point blank at [pbtarget]!"), \
						span_danger("You fire [src] point blank at [pbtarget]!"), \
						span_hear("You hear a gunshot!"), COMBAT_MESSAGE_RANGE, pbtarget)
	to_chat(pbtarget, span_userdanger("[user] fires [src] point blank at you!"))
	if(pb_knockback > 0 && ismob(pbtarget))
		var/mob/PBT = pbtarget
		var/atom/throw_target = get_edge_target_turf(PBT, user.dir)
		PBT.throw_at(throw_target, pb_knockback, 2)

/obj/item/ego_weapon/ranged/afterattack(atom/target, mob/living/user, flag, params)
	. = ..()
	if(QDELETED(target))
		return
	if(firing_burst)
		return
	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target) || user.a_intent == INTENT_HARM || forced_melee) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return
		if(ismob(target) && user.a_intent == INTENT_GRAB)
			if(user.GetComponent(/datum/component/gunpoint))
				to_chat(user, span_warning("You are already holding someone up!"))
				return
			user.AddComponent(/datum/component/gunpoint, target, src)
			return
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			for(var/i in C.all_wounds)
				var/datum/wound/W = i
				if(W.try_treating(src, user))
					return // another coward cured!

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

	if(flag)
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
			handle_suicide(user, target, params)
			return

	if(!can_shoot()) //Just because you can pull the trigger doesn't mean it can shoot.
		shoot_with_empty_chamber(user)
		return

	if(check_botched(user))
		return

	var/obj/item/bodypart/other_hand = user.has_hand_for_held_index(user.get_inactive_hand_index()) //returns non-disabled inactive hands
	if(weapon_weight == WEAPON_HEAVY && (user.get_inactive_held_item() || !other_hand))
		to_chat(user, span_warning("You need two hands to fire [src]!"))
		return
	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0
	if(ishuman(user) && user.a_intent == INTENT_HARM)
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/G in H.held_items)
			if(G == src || G.weapon_weight >= WEAPON_MEDIUM)
				continue
			else if(G.can_trigger_gun(user) && G.can_shoot())
				bonus_spread += dual_wield_spread
				loop_counter++
				addtimer(CALLBACK(G, TYPE_PROC_REF(/obj/item/ego_weapon/ranged, process_fire), target, user, TRUE, params, null, bonus_spread), loop_counter)

	return process_fire(target, user, TRUE, params, null, bonus_spread)

/obj/item/ego_weapon/ranged/can_trigger_gun(mob/living/user)
	. = ..()
	if(!handle_pins(user))
		return FALSE

/obj/item/ego_weapon/ranged/proc/check_botched(mob/living/user, params)
	if(clumsy_check && istype(user))
		if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(40))
			to_chat(user, span_userdanger("You shoot yourself in the foot with [src]!"))
			var/shot_leg = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			process_fire(user, user, FALSE, params, shot_leg)
			SEND_SIGNAL(user, COMSIG_MOB_CLUMSY_SHOOT_FOOT)
			user.dropItemToGround(src, TRUE)
			return TRUE

/obj/item/ego_weapon/ranged/proc/handle_pins(mob/living/user)
	if(pin)
		if(pin.pin_auth(user) || (pin.obj_flags & EMAGGED))
			return TRUE
		else
			pin.auth_fail(user)
			return FALSE
	else
		to_chat(user, span_warning("[src]'s trigger is locked. This weapon doesn't have a firing pin installed!"))
	return FALSE

/obj/item/ego_weapon/ranged/proc/process_burst(mob/living/user, atom/target, message = TRUE, params=null, zone_override = "", sprd = 0, randomized_gun_spread = 0, randomized_bonus_spread = 0, rand_spr = 0, iteration = 0)
	if(!user || !firing_burst)
		firing_burst = FALSE
		return FALSE

	if(!issilicon(user))
		if(iteration > 1 && !(user.is_holding(src))) //for burst firing
			firing_burst = FALSE
			return FALSE

	if(randomspread)
		sprd = round((rand() - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread))
	else //Smart spread
		sprd = round((((rand_spr/burst_size) * iteration) - (0.5 + (rand_spr * 0.25))) * (randomized_gun_spread + randomized_bonus_spread))

	before_firing(target,user)
	fire_projectile(target, user, params, 0, FALSE, zone_override, sprd, src)

	if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
		shoot_live_shot(user, 1, target, message)
	else
		shoot_live_shot(user, 0, target, message)
	if(iteration >= burst_size)
		firing_burst = FALSE

	process_chamber()
	return TRUE

/obj/item/ego_weapon/ranged/proc/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return

	if(HAS_TRAIT(user, TRAIT_PACIFISM) && lethal) // If the user has the pacifist trait, then they won't be able to fire [src] if the [lethal] var is TRUE.
		to_chat(user, span_warning("[src] is lethal! You don't want to risk harming anyone..."))
		return

	if(user)
		SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src, target, params, zone_override)

	SEND_SIGNAL(src, COMSIG_GUN_FIRED, user, target, params, zone_override)

	add_fingerprint(user)

	if(semicd)
		return

	var/sprd = 0
	var/randomized_gun_spread = 0
	var/rand_spr = rand()
	if(spread)
		randomized_gun_spread =	rand(0,spread)
	if(HAS_TRAIT(user, TRAIT_POOR_AIM)) //nice shootin' tex
		user.blind_eyes(1)
		bonus_spread += 25
	var/randomized_bonus_spread = rand(0, bonus_spread)

	if(burst_size > 1)
		firing_burst = TRUE
		for(var/i = 1 to burst_size)
			addtimer(CALLBACK(src, PROC_REF(process_burst), user, target, message, params, zone_override, sprd, randomized_gun_spread, randomized_bonus_spread, rand_spr, i), fire_delay * (i - 1))
	else
		sprd = round((rand() - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread))

		before_firing(target,user)
		fire_projectile(target, user, params, 0, FALSE, zone_override, sprd, src, temporary_damage_multiplier)

		if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
			shoot_live_shot(user, 1, target, message)
		else
			shoot_live_shot(user, 0, target, message)

		process_chamber()
		semicd = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_semicd)), fire_delay)

	if(user)
		user.update_inv_hands()
	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

	return TRUE

/obj/item/ego_weapon/ranged/proc/reset_semicd()
	semicd = FALSE

/obj/item/ego_weapon/ranged/attack(mob/M as mob, mob/user)
	if(!CanUseEgo(user))
		return FALSE

	if(!can_shoot())
		forced_melee = TRUE // Forces us to melee

	if(user.a_intent == INTENT_HARM || forced_melee) //Flogging
		return ..()

	return TRUE

/obj/item/ego_weapon/ranged/proc/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(semicd)
		return

	if(user == target)
		target.visible_message(span_warning("[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger..."), \
			span_userdanger("You stick [src] in your mouth, ready to pull the trigger..."))
	else
		target.visible_message(span_warning("[user] points [src] at [target]'s head, ready to pull the trigger..."), \
			span_userdanger("[user] points [src] at your head, ready to pull the trigger..."))

	semicd = TRUE

	if(!bypass_timer && (!do_mob(user, target, 120) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message(span_notice("[user] decided not to shoot."))
			else if(target?.Adjacent(user))
				target.visible_message(span_notice("[user] has decided to spare [target]"), span_notice("[user] has decided to spare your life!"))
		semicd = FALSE
		return

	semicd = FALSE

	target.visible_message(span_warning("[user] pulls the trigger!"), span_userdanger("[(user == target) ? "You pull" : "[user] pulls"] the trigger!"))
	process_fire(target, user, TRUE, params, BODY_ZONE_HEAD, temporary_damage_multiplier = 5)

/obj/item/ego_weapon/ranged/proc/unlock() //used in summon guns and as a convience for admins
	if(pin)
		qdel(pin)
	pin = new /obj/item/firing_pin

/////////////
// ZOOMING //
/////////////

/obj/item/ego_weapon/ranged/proc/rotate(atom/thing, old_dir, new_dir)
	SIGNAL_HANDLER

	if(ismob(thing))
		var/mob/lad = thing
		lad.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)

/obj/item/ego_weapon/ranged/proc/zoom(mob/living/user, direc, forced_zoom)
	if(!user || !user.client)
		return

	if(isnull(forced_zoom))
		zoomed = !zoomed
	else
		zoomed = forced_zoom

	if(zoomed)
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(rotate))
		user.client.view_size.zoomOut(zoom_out_amt, zoom_amt, direc)
	else
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		user.client.view_size.zoomIn()
	return zoomed

//Proc, so that gun accessories/scopes/etc. can easily add zooming.
/obj/item/ego_weapon/ranged/proc/build_zooming()
	if(azoom)
		return

	if(zoomable)
		azoom = new()
		azoom.gun = src

#undef DUALWIELD_PENALTY_EXTRA_MULTIPLIER

//Least important part: Melee attack info
//Has to be coded differently as an examine_more.
//Shoot me now - Kitsunemitsu/Kirie
/obj/item/ego_weapon/ranged/examine_more(mob/user)
	var/list/msg = list(span_notice("This weapon deals [force] [damtype] damage in melee."))

	if(reach>1)
		msg += span_notice("This weapon has a reach of [reach].")

	if(SSmaptype.chosen_trait == FACILITY_TRAIT_CRITICAL_HITS)
		if(crit_multiplier!=1)
			msg += span_notice("This weapon has a crit rate of [crit_multiplier]x  normal.")

	if(crit_info)
		msg += span_notice("[crit_info]")

	if(throwforce>force)
		msg += span_notice("This weapon deals [throwforce] [damtype] damage when thrown.")

	switch(attack_speed)
		if(-INFINITY to 0.39)
			msg += span_notice("This weapon has a very fast attack speed.")

		if(0.4 to 0.69) // nice
			msg += span_notice("This weapon has a fast attack speed.")

		if(0.7 to 0.99)
			msg += span_notice("This weapon attacks slightly faster than normal.")

		if(1.01 to 1.49)
			msg += span_notice("This weapon attacks slightly slower than normal.")

		if(1.5 to 1.99)
			msg += span_notice("This weapon has a slow attack speed.")

		if(2 to INFINITY)
			msg += span_notice("This weapon attacks extremely slow.")

	switch(swingstyle)
		if(WEAPONSWING_LARGESWEEP)
			msg += span_notice("This weapon can be swung in an arc instead of at a specific target.")

		if(WEAPONSWING_THRUST)
			msg += span_notice("This weapon can be thrust at tiles up to [reach] tiles away instead of a specific target.")

	switch(stuntime)
		if(1 to 2)
			msg += span_notice("This weapon stuns you for a very short duration on hit.")
		if(2 to 4)
			msg += span_notice("This weapon stuns you for a short duration on hit.")
		if(5 to 6)
			msg += span_notice("This weapon stuns you for a moderate duration on hit.")
		if(6 to 8)
			msg += span_warning("CAUTION: This weapon stuns you for a long duration on hit.")
		if(9 to INFINITY)
			msg += span_warning("WARNING: This weapon stuns you for a very long duration on hit.")


	switch(knockback)
		if(KNOCKBACK_LIGHT)
			msg += span_notice("This weapon has slight enemy knockback.")

		if(KNOCKBACK_MEDIUM)
			msg += span_notice("This weapon has decent enemy knockback.")

		if(KNOCKBACK_HEAVY)
			msg += span_notice("This weapon has neck-snapping enemy knockback.")

		else if(knockback)
			msg += span_notice("This weapon has [knockback >= 10 ? "neck-snapping": ""] enemy knockback.")
	return msg
