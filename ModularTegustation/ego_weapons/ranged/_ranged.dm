/obj/item/ego_weapon/ranged
	name = "ego gun"
	icon_state = "detective"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	flags_1 =  CONDUCT_1
	force = 6
	attack_speed = 1.3
	item_flags = NEEDS_PERMIT
	attack_verb_continuous = list("strikes", "hits", "bashes")
	attack_verb_simple = list("strike", "hit", "bash")
	is_ranged = TRUE
	///Text Stuff
	maptext = ""
	maptext_x = 0
	maptext_y = 0
	maptext_width = 48
	maptext_height = 48
	var/text_size = 5 // larger values clip when the displayed text is larger than 2 digits.

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
	/// The total amount of shots we can hold
	var/max_shots = 0
	/// The ammo lost when we shoot
	var/ammo_per_shot = 1
	/// The ammo gained when you melee something
	var/ammo_on_melee = null
	/// If set to true, the user can move during the reload at the cost of speed.
	var/mobile_reload = FALSE
	/// How long it takes to reload this weapon, if blank it wont need to be reloaded
	var/reloadtime = 0 SECONDS
	/// Are we currently reloading?
	var/is_reloading = FALSE
	/// How much ammo do we gain when we reload? If null, it'll reload the ammo amount
	var/ammo_on_reload = null

	/// If a number, the gun will passively reload its ammo based off the reload time after the time stated
	var/passive_reload = null
	var/passive_reload_timer = null


	/// Vars used for when you examine a gun
	var/last_projectile_damage = 0
	var/last_projectile_type = RED_DAMAGE

	/// The message for reloading
	var/reload_text = "You start loading a new magazine."
	/// The message for running out of ammo
	var/out_of_ammo = "The gun is out of ammo."
	// The message for loading a bullet.
	var/round_text = "You start loading a bullet."

	/// Controls if pacifists can use the gun or not. Should be TRUE unless you are doing something funky
	var/lethal = TRUE
	/// Should clumsy people shoot themselfes at a chance with it? Usually unused
	var/clumsy_check = TRUE

	/// Sound controls
	var/vary_fire_sound = TRUE
	var/fire_sound_volume = 50
	var/dry_fire_sound = 'sound/weapons/gun/general/dry_fire.ogg'
	var/reload_start_sound = 'sound/weapons/gun/general/slide_lock_1.ogg'
	var/reload_success_sound = 'sound/weapons/gun/general/bolt_rack.ogg'
	var/charge_sound = 'sound/weapons/gun/general/magazine_insert_full.ogg'
	var/charge_sound_volume = 50

	var/chargetime = null
	var/is_charging = FALSE
	var/charged = FALSE
	var/charge_timer
	var/charge_hold_time = 10

	var/recoil = 0						//boom boom shake the room
	var/burst_size = 1					//how large a burst is
	var/burst_delay = null				//the duration of the burst fire.
	var/fire_delay = 0					//rate of fire for burst firing and semi auto
	var/firing_burst = 0				//Prevent the weapon from firing again while already firing
	var/semicd = 0						//cooldown handler
	var/dual_wield_spread = 24			//additional spread when dual wielding

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

	// Alternate Fire
	// Set 'alternate_fire_name' to anything to enable this behaviour on your gun.
	// Only the bare minimum stuff is handled in this alt-fire behaviour, if you want stuff like different recoil or spread for your altfire you'll have to override some procs.
	// A gun with an alternate fire can toggle between two different magazines firing different ammo types with different stats. This toggle happens via alt-click.

	// These vars are generally unfriendly to varediting. You have been warned (copious use of initial())

	/// The name of the alternate fire type on this gun; for example "Underslung Grenade Launcher" or "High-Output Mode" or "Underslung Shotgun". If null, this alt-fire behaviour is disabled.
	var/alternate_fire_name = null
	//Information on the alt fire
	var/alternate_info
	var/alternate_selected = FALSE
	var/alternate_shotsleft = 0
	var/alternate_max_shots = 1
	var/alternate_ammo_per_shot = 1
	var/alternate_ammo_on_reload = null
	var/alternate_toggle_sound = 'sound/machines/click.ogg'
	var/alternate_toggle_sound_volume = 65
	var/alternate_toggle_spam_protection_cd
	var/alternate_toggle_enabled_message = span_notice("Alternate fire enabled.")
	var/alternate_toggle_disabled_message = span_notice("Alternate fire disabled.")
	/// The way reloading is handled for alternate firetypes. View __defines/combat.dm.
	var/alternate_reload_type = RELOADTYPE_SHARED_RELOAD
	//We switch the existing values to these values
	var/alternate_reload_time
	var/alternate_projectile_path = /obj/projectile/ego_bullet/ego_knade
	var/alternate_pellets = 1
	var/alternate_variance = 0
	var/alternate_fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	var/alternate_fire_sound_volume = 50

/obj/item/ego_weapon/ranged/pistol
	attack_speed = 0.5
	force = 2
	fire_delay = 5
	max_shots = 12

/// Low ammo, Long reloads, Slow fire rate, Extreme Damage
/obj/item/ego_weapon/ranged/cannon
	attack_speed = 1.8
	force = 9
	fire_delay = 10
	chargetime = 10
	max_shots = 3
	recoil = 0.1
	round_text = "You start loading a shell."
	ammo_on_reload = 1
	reloadtime = 1.25 SECONDS
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/ego/cannon.ogg'

/obj/item/ego_weapon/ranged/crossbow
	max_shots = 1
	reload_text = "You start loading an arrow."
	mobile_reload = TRUE
	fire_delay = 5
	reloadtime = 2.5 SECONDS
	spread = 0
	fire_sound = 'sound/weapons/ego/crossbow.ogg'
	weapon_weight = WEAPON_HEAVY

/obj/item/ego_weapon/ranged/crossbow/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	shotsleft = 0//Starts unloaded

/obj/item/ego_weapon/ranged/crossbow/OnReload(mob/user)
	icon_state = inhand_icon_state = "[initial(icon_state)]_loaded"
	update_icon_state()
	update_icon()

/obj/item/ego_weapon/ranged/crossbow/process_chamber(mob/living/user)
	icon_state = inhand_icon_state = "[initial(icon_state)]"
	update_icon_state()
	update_icon()
	return ..()

/obj/item/ego_weapon/ranged/Initialize()
	. = ..()
	shotsleft = max_shots
	alternate_shotsleft = alternate_max_shots
	if(!burst_delay)
		burst_delay = fire_delay * 0.8
	if(pin)
		pin = new pin(src)
	build_zooming()
	UpdateAmmoCounter()
	if(autofire)
		AddComponent(/datum/component/automatic_fire, autofire)
		fire_delay = 0

	update_projectile_examine()

	// If your gun has an altfire and uses shared reloading, the altfire reload will be the same as the normal one.
	if(alternate_fire_name && !alternate_reload_time)
		alternate_reload_time = reloadtime

/obj/item/ego_weapon/ranged/Destroy(mob/user)
	if(user)
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		if(user.has_movespeed_modifier(/datum/movespeed_modifier/reloading))
			user.remove_movespeed_modifier(/datum/movespeed_modifier/reloading)
	deltimer(passive_reload_timer)
	deltimer(charge_timer)
	if(isobj(pin)) //Can still be the initial path, then we skip
		QDEL_NULL(pin)
	if(azoom)
		QDEL_NULL(azoom)
	return ..()

/obj/item/ego_weapon/ranged/handle_atom_del(atom/A)
	if(A == pin)
		pin = null
	return ..()

/// By default, alt-click/middle click is mostly reserved for toggling alt-fire on weapons that have an alt-fire. Feel free to override. This won't do anything on most guns.
/obj/item/ego_weapon/ranged/MiddleClickAction(atom/target, mob/user)
	. = ..()
	if(.)
		return
	if(!alternate_fire_name)
		return
	if(is_reloading || charged || is_charging) // Don't want people to smuggle differing reload or charge timers
		return
	if(alternate_toggle_spam_protection_cd > world.time)
		return

	alternate_toggle_spam_protection_cd = world.time + 0.3 SECONDS

	playsound(src, alternate_toggle_sound, alternate_toggle_sound_volume)
	if(!alternate_selected)
		EnableAltfire(user, silent = FALSE)
	else
		DisableAltfire(user, silent = FALSE)

// These two procs are very simple so you can override them easily for more custom behaviour.
/obj/item/ego_weapon/ranged/proc/EnableAltfire(mob/user, silent = TRUE)
	alternate_selected = TRUE
	reloadtime = alternate_reload_time
	projectile_path = alternate_projectile_path
	pellets = alternate_pellets
	variance = alternate_variance
	fire_sound = alternate_fire_sound
	fire_sound_volume = alternate_fire_sound_volume
	if(alternate_reload_type == RELOADTYPE_EMPTY_MAG)
		to_chat(user, span_danger("You dump your magazine to prepare the other ammo type"))
		shotsleft = 0
	if(!silent)
		to_chat(user, alternate_toggle_enabled_message)
	update_projectile_examine()
	UpdateAmmoCounter(user)

/obj/item/ego_weapon/ranged/proc/DisableAltfire(mob/user, silent = TRUE)
	alternate_selected = FALSE
	reloadtime = initial(reloadtime)
	projectile_path = initial(projectile_path)
	pellets = initial(pellets)
	variance = initial(variance)
	fire_sound = initial(fire_sound)
	fire_sound_volume = initial(fire_sound_volume)
	if(alternate_reload_type == RELOADTYPE_EMPTY_MAG)
		to_chat(user, span_danger("You dump your magazine to prepare the other ammo type"))
		shotsleft = 0
	if(!silent)
		to_chat(user, alternate_toggle_disabled_message)
	update_projectile_examine()
	UpdateAmmoCounter(user)

/obj/item/ego_weapon/ranged/examine(mob/user)
	. = ..()
	if(is_ranged)
		. += GunOtherInfo()
		. += span_notice("Examine this weapon more for melee information.")
	else
		. += span_notice("Examine this weapon more for ranged information.")

/obj/item/ego_weapon/ranged/proc/GunOtherInfo()
	var/list/text = list()

	if(!autofire)
		switch(fire_delay)
			if(0 to 5)
				text += span_nicegreen("This weapon fires fast.")
			if(6 to 10)
				text += span_notice("This weapon fires at a normal speed.")
			if(11 to 15)
				text += span_notice("This weapon fires slightly slower than usual.")
			if(16 to 20)
				text += span_danger("This weapon fires slowly.")
			else
				text += span_danger("This weapon fires extremely slowly.")
	else
		//Give it to 'em in true rounds per minute, accurate to the 5s
		var/rpm = 600 / autofire
		rpm = round(rpm,5)
		text += span_nicegreen("This weapon is automatic.")
		text += span_notice("This weapon fires at [rpm*burst_size] rounds per minute.")

	if(chargetime)
		text += span_notice("This weapon needs to be charged up before firing.")
		switch(chargetime)
			if(0 to 5)
				text += span_nicegreen("This weapon charges up very fast.")
			if(6 to 10)
				text += span_notice("This weapon charges up fast.")
			if(11 to 15)
				text += span_danger("This weapon charges up slowly.")
			else
				text += span_danger("This weapon charges up extremely slowly.")

	if(burst_size > 1)
		text += span_notice("This weapon fires in a burst of [burst_size].")

	switch(weapon_weight)
		if(WEAPON_HEAVY)
			text += span_danger("This weapon requires both hands to fire.")
		if(WEAPON_MEDIUM)
			text += span_notice("This weapon can be fired with one hand.")
		if(WEAPON_LIGHT)
			text += span_nicegreen("This weapon can be dual wielded.")

	if(!reloadtime)
		text += span_notice("This weapon has unlimited ammo.")
	else if(shotsleft >= ammo_per_shot)
		text += span_notice("Ammo Counter: [shotsleft]/[max_shots].")
	else
		text += span_danger("Ammo Counter: [shotsleft]/[max_shots].")
	if(ammo_per_shot > 1)
		text += span_danger("Firing this weapon will consume [ammo_per_shot] ammo.")
	if(passive_reload)
		var/start = "This weapon passively reloads ammo with a"
		switch(passive_reload)
			if(0 to 2.01 SECONDS)
				text += span_nicegreen("[start] very short delay after firing.")
			if(2.01 SECONDS to 4.01 SECONDS)
				text += span_notice("[start] short delay after firing.")
			if(4.01 SECONDS to 6.01 SECONDS)
				text += span_notice("[start] delay after firing.")
			if(6.01 SECONDS to 9.01 SECONDS)
				text += span_danger("[start] long delay after firing.")
			if(9.01 to INFINITY)
				text += span_danger("[start]n extremely long delay after firing.")

	if(reloadtime)
		switch(reloadtime)
			if(0 to 0.71 SECONDS)
				text += span_nicegreen("This weapon has a very fast reload.")
			if(0.71 SECONDS to 1.21 SECONDS)
				text += span_notice("This weapon has a fast reload.")
			if(1.21 SECONDS to 1.71 SECONDS)
				text += span_notice("This weapon has a normal reload speed.")
			if(1.71 SECONDS to 2.51 SECONDS)
				text += span_danger("This weapon has a slow reload.")
			if(2.51 to INFINITY)
				text += span_danger("This weapon has an extremely slow reload")

		if(mobile_reload)
			text += span_notice("This weapon can be reloaded while moving at the cost of movespeed.")

		if(ammo_on_reload)
			if(ammo_on_reload > 1)
				text += span_notice("This weapon reloads [ammo_on_reload] rounds at a time.")
			else
				text += span_notice("This weapon reloads one round at a time.")
	if(ammo_on_melee)
		if(ammo_on_melee > 1)
			text += span_notice("This weapon reloads [ammo_on_melee] rounds when hitting something with its melee.")
		else
			text += span_notice("This weapon reloads one round when hitting something with its melee.")

	if(alternate_fire_name)
		text += ""
		text += span_notice("This weapon has an alternate fire mode: [alternate_fire_name]. Activate by alt-clicking or middle-clicking.")
		if(alternate_info)
			text += span_notice("Alt Fire - [alternate_info]")
		// Altfire currently active?
		if(alternate_selected)
			text += span_danger("[alternate_fire_name] is currently <b>active!</b>")
		else
			text += span_notice("[alternate_fire_name] is currently <b>disabled.</b>")

		// Ammo count for altfire.
		switch(alternate_reload_type)
			if(RELOADTYPE_SHARED_RELOAD)
				text += span_nicegreen("Reloading the magazine will reload the alternate ammo.")
				if(alternate_shotsleft >= alternate_ammo_per_shot)
					text += span_notice("[alternate_fire_name] Ammo Counter: [alternate_shotsleft]/[alternate_max_shots].")
				else
					text += span_danger("[alternate_fire_name] Ammo Counter: [alternate_shotsleft]/[alternate_max_shots].")

			if(RELOADTYPE_INDIVIDUAL_RELOAD)
				text += span_notice("This weapon requires both ammo types to be reloaded separately.")
				if(alternate_shotsleft >= alternate_ammo_per_shot)
					text += span_notice("[alternate_fire_name] Ammo Counter: [alternate_shotsleft]/[alternate_max_shots].")
				else
					text += span_danger("[alternate_fire_name] Ammo Counter: [alternate_shotsleft]/[alternate_max_shots].")


			if(RELOADTYPE_SHARED_MAGAZINE)
				text += span_notice("The alternate fire on this weapon uses the main ammo pool.")
			if(RELOADTYPE_EMPTY_MAG)
				text += span_danger("This weapon can only load one ammo type at a time. Reloading will dump the magazine.")

		text += ""
	return text

/obj/item/ego_weapon/ranged/GunAttackInfo()
	if(!last_projectile_damage || !last_projectile_type)
		return span_userdanger("The bullet of this EGO gun has not properly initialized, report this to coders!")
	var/damage_type = last_projectile_type
	var/damage = round(last_projectile_damage * force_multiplier * projectile_damage_multiplier, 0.1)
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	if(pellets > 1)	//for shotguns
		return span_notice("Its bullets deal [damage] x [pellets] [damage_type] damage.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")
	return span_notice("Its bullets deal [damage] [damage_type] damage.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")

/// Updates the damage/type of projectiles inside of the gun
/obj/item/ego_weapon/ranged/proc/update_projectile_examine()
	if(isnull(projectile_path))
		message_admins("[src] has an invalid projectile path.")
		return
	var/obj/projectile/projectile = new projectile_path(src, src)
	last_projectile_damage = projectile.damage
	last_projectile_type = projectile.damage_type
	qdel(projectile)

/obj/item/ego_weapon/ranged/proc/UpdateAmmoCounter(mob/living/user)
	if(!reloadtime || !user || !user.client)
		maptext = ""
		return
	var/list/search_area = user.contents.Copy()
	for(var/obj/item/storage/spare_space in search_area)
		search_area |= spare_space.contents
	if(!(src in search_area))
		maptext = ""
		return
	var/main_color = "white"
	if(alternate_selected)
		if(alternate_reload_type == RELOADTYPE_INDIVIDUAL_RELOAD || alternate_reload_type == RELOADTYPE_SHARED_RELOAD)
			main_color = "gray"
		else
			main_color = "yellow"
	if(shotsleft < ammo_per_shot)
		main_color = "red"
	var/style = "font-family: 'Better VCR'; font-size: [text_size]px; -dm-text-outline: 1px black; color: [main_color];"
	if(alternate_fire_name && (alternate_reload_type == RELOADTYPE_INDIVIDUAL_RELOAD || alternate_reload_type == RELOADTYPE_SHARED_RELOAD))
		var/alt_color = "white"
		if(!alternate_selected)
			alt_color = "gray"
		if(alternate_shotsleft < alternate_ammo_per_shot)
			alt_color = "red"
		var/style2 = "font-family: 'Better VCR'; font-size: [text_size]px; -dm-text-outline: 1px black; color: [alt_color];"
		maptext = MAPTEXT("<span style=\"[style]\">[shotsleft]/[max_shots]</span>\n<span style=\"[style2]\">[alternate_shotsleft]/[alternate_max_shots]</span>")
	else
		maptext = MAPTEXT("<span style=\"[style]\">[shotsleft]/[max_shots]</span>")

/obj/item/ego_weapon/ranged/attack_self(mob/user)
	if(passive_reload) // Passive reload doesn't care about reloading.
		return ..()
	if(reloadtime && !is_reloading)
		if(ammo_on_reload)
			playsound(src, reload_start_sound, 50, TRUE)
			INVOKE_ASYNC(src, PROC_REF(rounds_reload), user, alternate_selected)
		else
			INVOKE_ASYNC(src, PROC_REF(reload_ego), user)
	return ..()

/obj/item/ego_weapon/ranged/proc/reload_ego(mob/user)
	is_reloading = TRUE
	to_chat(user,span_notice(reload_text))
	playsound(src, reload_start_sound, 50, TRUE)
	var/flags = 0
	if(mobile_reload)
		flags = IGNORE_USER_LOC_CHANGE
		user.add_movespeed_modifier(/datum/movespeed_modifier/reloading)
	if(do_after(user, reloadtime, src, flags, extra_checks=CALLBACK(src, PROC_REF(reload_check)))) //gotta reload
		playsound(src, reload_success_sound, 50, TRUE)
		OnReload(user)
		//Alright, let's check if we're in the alternate mode, and reloading the second mag.
		if(alternate_selected && (alternate_reload_type == RELOADTYPE_INDIVIDUAL_RELOAD))
			alternate_shotsleft = alternate_max_shots
			if(user.has_movespeed_modifier(/datum/movespeed_modifier/reloading))
				user.remove_movespeed_modifier(/datum/movespeed_modifier/reloading)
			is_reloading = FALSE
			UpdateAmmoCounter(user)
			return	//Get the fuck outta here

		//We're ALWAYS reloading the main mag here. If we got this far, it means we're using a gun that wants to load the main mag
		shotsleft = max_shots

		//If we reload both at once? Set the alt shots back too.
		if(alternate_reload_type == RELOADTYPE_SHARED_RELOAD)
			alternate_shotsleft = alternate_max_shots

	if(user.has_movespeed_modifier(/datum/movespeed_modifier/reloading))
		user.remove_movespeed_modifier(/datum/movespeed_modifier/reloading)
	is_reloading = FALSE
	UpdateAmmoCounter(user)

/obj/item/ego_weapon/ranged/proc/rounds_reload(mob/user, is_reloading_alt_mag = FALSE)
	is_reloading = TRUE
	//If it's only one mag type, you MUST load it.
	if(alternate_reload_type == RELOADTYPE_EMPTY_MAG || alternate_reload_type == RELOADTYPE_SHARED_MAGAZINE)
		is_reloading_alt_mag = FALSE
	if(((!is_reloading_alt_mag) && (shotsleft == max_shots)) || ((is_reloading_alt_mag) && (alternate_shotsleft == alternate_max_shots)))
		if(user.has_movespeed_modifier(/datum/movespeed_modifier/reloading))
			user.remove_movespeed_modifier(/datum/movespeed_modifier/reloading)
		is_reloading = FALSE
		return
	to_chat(user, span_notice(round_text))
	var/flags = 0
	if(mobile_reload)
		flags = IGNORE_USER_LOC_CHANGE
		user.add_movespeed_modifier(/datum/movespeed_modifier/reloading)
	if(do_after(user, reloadtime, src, flags, extra_checks=CALLBACK(src, PROC_REF(reload_check)))) //gotta reload
		playsound(src, reload_success_sound, 50, TRUE)
		if(is_reloading_alt_mag)
			alternate_shotsleft = min(alternate_shotsleft + alternate_ammo_on_reload, alternate_max_shots)
		else
			shotsleft = min(shotsleft + ammo_on_reload, max_shots)
		UpdateAmmoCounter(user)
		OnReload(user)
		INVOKE_ASYNC(src, PROC_REF(rounds_reload), user, is_reloading_alt_mag)	//To save you from loading all your bullets
		return
	if(user.has_movespeed_modifier(/datum/movespeed_modifier/reloading))
		user.remove_movespeed_modifier(/datum/movespeed_modifier/reloading)
	is_reloading = FALSE

//Used for some weapons to do things
/obj/item/ego_weapon/ranged/proc/OnReload(mob/user)

/obj/item/ego_weapon/ranged/proc/PassiveReload(mob/user, showmessage = FALSE)
	deltimer(passive_reload_timer)
	OnReload(user)
	if(ammo_on_reload)
		shotsleft = min(shotsleft + ammo_on_reload, max_shots)
	else
		shotsleft = max_shots
	UpdateAmmoCounter(user)
	if(shotsleft < max_shots)
		passive_reload_timer = addtimer(CALLBACK(src, PROC_REF(PassiveReload), user), reloadtime, TIMER_STOPPABLE)

/obj/item/ego_weapon/ranged/equipped(mob/living/user, slot)
	. = ..()
	if(zoomed && user.get_active_held_item() != src)
		zoom(user, user.dir, FALSE) //we can only stay zoomed in if it's in our hands	//yeah and we only unzoom if we're actually zoomed using the gun!!
	UpdateAmmoCounter(user)

/obj/item/ego_weapon/ranged/pickup(mob/user)
	..()
	if(azoom)
		azoom.Grant(user)

/obj/item/ego_weapon/ranged/dropped(mob/user)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		if(user.has_movespeed_modifier(/datum/movespeed_modifier/reloading))
			user.remove_movespeed_modifier(/datum/movespeed_modifier/reloading)
		if(charged)
			Uncharge(user)
	if(azoom)
		azoom.Remove(user)
	if(zoomed)
		zoom(user, user.dir)
	UpdateAmmoCounter()

//called after the gun has successfully fired its chambered ammo.
/obj/item/ego_weapon/ranged/proc/process_chamber(mob/living/user)
	if(passive_reload)
		if(passive_reload_timer)
			deltimer(passive_reload_timer)
		passive_reload_timer = addtimer(CALLBACK(src, PROC_REF(PassiveReload), user, TRUE), passive_reload, TIMER_STOPPABLE)

	if(!reloadtime) //You don't have ammo, no need to dump it
		return

	if(!alternate_selected && shotsleft)	//You're firing the main mag.
		shotsleft = max(0, shotsleft - ammo_per_shot)

	//Are we in alternate fire?
	if(alternate_selected)

		//What type?
		switch(alternate_reload_type)

			//If it's two mags, we check if there's ammo in the alt mag
			if(RELOADTYPE_SHARED_RELOAD)
				if(alternate_shotsleft && alternate_reload_time)
					alternate_shotsleft = max(0, alternate_shotsleft - alternate_ammo_per_shot)

			if(RELOADTYPE_INDIVIDUAL_RELOAD)
				if(alternate_shotsleft && alternate_reload_time)
					alternate_shotsleft = max(0, alternate_shotsleft - alternate_ammo_per_shot)

			//If it's one mag, we lose a main bullet
			if(RELOADTYPE_EMPTY_MAG)
				if(shotsleft && alternate_reload_time)
					shotsleft = max(0, shotsleft - ammo_per_shot)

			if(RELOADTYPE_SHARED_MAGAZINE)
				if(shotsleft && alternate_reload_time)
					shotsleft = max(0, shotsleft - ammo_per_shot)
	UpdateAmmoCounter(user)

//check if there's enough ammo to shoot one time
//i.e if clicking would make it shoot
/obj/item/ego_weapon/ranged/proc/can_shoot(mob/living/user)
	//Is the gun currently charging up or reloading?
	if(is_reloading || is_charging)
		return FALSE

	//Does the main mag not need ammo?
	if(!reloadtime && !alternate_selected)
		return TRUE

	//Does the alt mag not need ammo?
	if(!alternate_reload_time && alternate_selected)
		return TRUE

	//Are we firing regular bullets, it can reload and we have no shots left?
	if(!alternate_selected && (reloadtime && shotsleft < ammo_per_shot))
		shoot_with_empty_chamber(user)
		return FALSE

	//Are we in alternate fire?
	if(alternate_selected)

		//What type?
		switch(alternate_reload_type)

			//If it's two mags, we check if there's ammo.
			if(RELOADTYPE_SHARED_RELOAD)
				if(alternate_shotsleft < alternate_ammo_per_shot)
					shoot_with_empty_chamber(user)
					return FALSE

			if(RELOADTYPE_INDIVIDUAL_RELOAD)
				if(alternate_shotsleft < alternate_ammo_per_shot)
					shoot_with_empty_chamber(user)
					return FALSE

			//If it's one mag, we check the main mag.
			if(RELOADTYPE_EMPTY_MAG)
				if(shotsleft < ammo_per_shot)
					shoot_with_empty_chamber(user)
					return FALSE

			if(RELOADTYPE_SHARED_MAGAZINE)
				if(shotsleft < ammo_per_shot)
					shoot_with_empty_chamber(user)
					return FALSE

	return TRUE

/obj/item/ego_weapon/ranged/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	user.visible_message(span_notice(out_of_ammo))
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

	if(!can_shoot(user)) //Just because you can pull the trigger doesn't mean it can shoot.
		return

	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target)) //melee attack
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

	if(check_botched(user))
		return

	var/obj/item/bodypart/other_hand = user.has_hand_for_held_index(user.get_inactive_hand_index()) //returns non-disabled inactive hands

	if(weapon_weight == WEAPON_HEAVY && (user.get_inactive_held_item() || !other_hand))
		to_chat(user, span_warning("You need two hands to fire [src]!"))
		return
	//Charge up Stuff
	if(chargetime)
		if(semicd || is_charging)//You still need to wait till it's off cooldown first
			return
		if(!charged)
			ChargeUp(user)
			return
		deltimer(charge_timer)
		charged = FALSE
		OnDischarge(user)
	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/G in H.held_items)
			if(G == src)
				continue
			//We want to make sure medium guns can't be dualwielded with light guns/semi dualwield 2 medium guns
			if(weapon_weight >= WEAPON_MEDIUM || G.weapon_weight >= WEAPON_MEDIUM)
				G.semicd = TRUE
				addtimer(CALLBACK(G, PROC_REF(reset_semicd)), fire_delay)
			else
				if(user.a_intent == INTENT_HARM && G.can_trigger_gun(user) && G.can_shoot(user))
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
		sprd = round((rand() - 0.5) * (randomized_gun_spread + randomized_bonus_spread))
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

	process_chamber(user)
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
		randomized_gun_spread = (0.5 + rand()/2) + spread
	if(HAS_TRAIT(user, TRAIT_POOR_AIM)) //nice shootin' tex
		user.blind_eyes(1)
		bonus_spread += 25
	var/randomized_bonus_spread = (0.5 + rand()/2) + bonus_spread

	if(burst_size > 1)
		firing_burst = TRUE
		for(var/i = 1 to burst_size)
			addtimer(CALLBACK(src, PROC_REF(process_burst), user, target, message, params, zone_override, sprd, randomized_gun_spread, randomized_bonus_spread, rand_spr, i), (burst_delay/burst_size) * i)
	else
		sprd = round((rand() - 0.5) * (randomized_gun_spread + randomized_bonus_spread))

		before_firing(target,user)
		fire_projectile(target, user, params, 0, FALSE, zone_override, sprd, src, temporary_damage_multiplier)

		if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
			shoot_live_shot(user, 1, target, message)
		else
			shoot_live_shot(user, 0, target, message)

		process_chamber(user)
	semicd = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_semicd)), fire_delay)

	if(user)
		user.update_inv_hands()
	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

	return TRUE

/obj/item/ego_weapon/ranged/proc/reset_semicd()
	semicd = FALSE

/obj/item/ego_weapon/ranged/proc/ChargeUp(mob/living/user)
	if(!CanUseEgo(user))
		return
	is_charging = TRUE
	playsound(user, charge_sound, charge_sound_volume, vary_fire_sound)
	if(do_after(user, chargetime, src))
		to_chat(user, span_nicegreen("You charge up [src]."))
		is_charging = FALSE
		charged = TRUE
		OnCharged(user)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(Uncharge), user), charge_hold_time, TIMER_STOPPABLE)
		return
	is_charging = FALSE
	to_chat(user, span_warning("You need to wait before charging up [src]!"))

/obj/item/ego_weapon/ranged/proc/Uncharge(mob/living/user)
	charged = FALSE
	OnDischarge(user)
	if(user)
		to_chat(user, span_warning("The [src] loses its charge!"))
	deltimer(charge_timer)

/obj/item/ego_weapon/ranged/proc/OnCharged(mob/living/user)
	return

/obj/item/ego_weapon/ranged/proc/OnDischarge(mob/living/user)
	return

/obj/item/ego_weapon/ranged/attack(mob/living/target, mob/living/user)
	if(is_charging)
		return FALSE
	if(is_reloading)
		is_reloading = FALSE
	. = ..()
	if(!.)
		return
	if(ammo_on_melee)
		if((target.stat == DEAD) || target.status_flags & GODMODE) // lets not give them ammo for beating up contained abnormalities
			return
		if(passive_reload)
			if(passive_reload_timer)
				deltimer(passive_reload_timer)
			passive_reload_timer = addtimer(CALLBACK(src, PROC_REF(PassiveReload), user, TRUE), passive_reload, TIMER_STOPPABLE)
		if(alternate_selected && (alternate_reload_type == RELOADTYPE_INDIVIDUAL_RELOAD))
			alternate_shotsleft = min(alternate_shotsleft + ammo_on_melee, alternate_max_shots)
			UpdateAmmoCounter(user)
			return
		shotsleft = min(shotsleft + ammo_on_melee, max_shots)
		if(alternate_reload_type == RELOADTYPE_SHARED_RELOAD)
			alternate_shotsleft = min(alternate_shotsleft + ammo_on_melee, alternate_max_shots)
		UpdateAmmoCounter(user)

//We redo this proc to hide the maptext since it looks bad with the attack animation
/obj/item/ego_weapon/ranged/melee_attack_chain(mob/user, atom/target, params)
	maptext = ""
	if(tool_behaviour && target.tool_act(user, src, tool_behaviour))
		UpdateAmmoCounter(user)
		return TRUE
	if(pre_attack(target, user, params))
		UpdateAmmoCounter(user)
		return TRUE
	if(Sweep(target, user, params))
		UpdateAmmoCounter(user)
		return TRUE
	if(QDELETED(src) || QDELETED(target))
		attack_qdeleted(target, user, TRUE, params)
		UpdateAmmoCounter(user)
		return TRUE
	UpdateAmmoCounter(user)
	return afterattack(target, user, TRUE, params)

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

//Least important part: Melee attack info
//Has to be coded differently as an examine_more.
//Shoot me now - Kitsunemitsu/Kirie
//Now it can display ranged stuff for more melee focused ranged weapons - Crabby
/obj/item/ego_weapon/ranged/examine_more(mob/user)
	if(!is_ranged)
		var/list/msg = list()
		msg += GunAttackInfo()
		msg += GunOtherInfo()
		return msg
	var/list/msg = list(span_notice("This weapon deals [force] [damtype] damage in melee."))

	if(reach>1)
		msg += span_notice("This weapon has a reach of [reach].")

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

/obj/item/ego_weapon/ranged/proc/reload_check()
	return is_reloading

/datum/movespeed_modifier/reloading
	multiplicative_slowdown = 1
	variable = TRUE
