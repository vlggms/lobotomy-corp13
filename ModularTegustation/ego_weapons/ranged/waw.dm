/obj/item/ego_weapon/ranged/correctional
	name = "correctional"
	desc = "In here, you're with us. Forever."
	icon_state = "correctional"
	inhand_icon_state = "correctional"
	force = 24
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_correctional
	weapon_weight = WEAPON_HEAVY
	pellets = 8
	variance = 20
	fire_delay = 7
	max_shots = 12
	ammo_on_reload = 1
	reloadtime = 0.6 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/hornet
	name = "hornet"
	desc = "The kingdom needed to stay prosperous, and more bees were required for that task. \
	The projectiles relive the legacy of the kingdom as they travel toward the target."
	icon_state = "hornet"
	inhand_icon_state = "hornet"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/ego_hornet
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	fire_delay = 4
	max_shots = 10
	ammo_on_reload = 1
	reloadtime = 0.3 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)


/obj/item/ego_weapon/ranged/hatred
	name = "in the name of love and hate"
	desc = "A magic wand surging with the lovely energy of a magical girl. \
	The holy light can cleanse the body and mind of every villain, and they shall be born anew."
	icon_state = "hatred"
	inhand_icon_state = "hatred"
	special = "This weapon heals humans that it hits."
	force = 18
	attack_speed = 1
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hatred
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 10
	max_shots = 30
	passive_reload = 6 SECONDS
	reloadtime = 3
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/hatred/GunAttackInfo(mob/user)
	return span_notice("Its magic deal [last_projectile_damage] randomly chosen damage.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")

/obj/item/ego_weapon/ranged/hatred/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/heart))
		return
	new /obj/item/ego_weapon/ranged/hatred_nihil(get_turf(src))
	to_chat(user,span_warning("The [I] seems to drain all of the light away as it is absorbed into [src]!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

// Magic Bullet armour increases attack speed from 30 to 15
// Big Iron armour on the other hand increases damage by a factor of 2.5x80, which will give it 40 more damage than the magic bullet armour
/obj/item/ego_weapon/ranged/magicbullet
	name = "magic bullet"
	desc = "Though the original's power couldn't be fully extracted, the magic this holds is still potent. \
	The weapon's bullets travel across the corridor, along the horizon."
	icon_state = "magic_bullet"
	inhand_icon_state = "magic_bullet"
	special = "This weapon pierces all targets. \
		This weapon gets a 30% damage bonus when wearing the matching armor."
	force = 24
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_magicbullet
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	max_shots = 7
	ammo_on_reload = 1
	reloadtime = 0.3 SECONDS
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'

	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/magicbullet/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/he/magicbullet/Y = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		projectile_damage_multiplier *= 1.3
	if(istype(Z))
		projectile_damage_multiplier *= 3
	..()


//Funeral guns have two different names;
//Solemn Lament is the white gun, Solemn Vow is the black gun.
//Likewise, they emit butterflies of those respective colors.
//When together they should be on par with a 2 handed waw gun.
/obj/item/ego_weapon/ranged/pistol/solemnlament
	name = "solemn lament"
	desc = "A pistol which carries with it a lamentation for those that live. \
	Can feathers gain their own wings?"
	icon_state = "solemnlament"
	inhand_icon_state = "solemnlament"
	special = "While having either a second copy of this weapon or solemn vow will decrease shot spread and allow for both to reload at once.\nFiring both solemn lament and solemn vow at the same time will increase their damage by 30%"
	force = 9
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solemnlament
	fire_delay = 5
	max_shots = 18
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/abnormalities/funeral/spiritgunwhite.ogg'
	fire_sound_volume = 30
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/pistol/solemnlament/afterattack(atom/target, mob/living/user, flag, params)
	dual_wield_spread = initial(dual_wield_spread)
	if(!user.get_inactive_held_item())
		return ..()
	if(!(istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnlament) || istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnvow)))
		return ..()
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, flag, params)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, flag, params)
	//Is it stupid as hell that we're doing this? yes, But the guns were used together in lcorp and I wanted the same functionality here.
	dual_wield_spread = 12
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

	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/G in H.held_items)
			if(G == src)
				continue
			else if(G.can_trigger_gun(user) && G.can_shoot(user))
				bonus_spread += dual_wield_spread
				loop_counter+=2.5
				addtimer(CALLBACK(G, TYPE_PROC_REF(/obj/item/ego_weapon/ranged, process_fire), target, user, TRUE, params, null, bonus_spread), loop_counter)

	return process_fire(target, user, TRUE, params, null, bonus_spread)

/obj/item/ego_weapon/ranged/pistol/solemnlament/OnReload(mob/user)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnvow/Vow in myman.held_items)
		to_chat(user,span_notice("You also reloaded the [Vow]."))
		Vow.shotsleft = Vow.max_shots
		break
	for(var/obj/item/ego_weapon/ranged/pistol/solemnlament/Lament in myman.held_items)
		if(Lament != src)
			to_chat(user,span_notice("You also reloaded the other [Lament]."))
			Lament.shotsleft = Lament.max_shots
			break

/obj/item/ego_weapon/ranged/pistol/solemnlament/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	dual_wield_spread = initial(dual_wield_spread)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnvow/Vow in myman.held_items)
		projectile_damage_multiplier *= 1.3
		break
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		projectile_damage_multiplier *= 2

/obj/item/ego_weapon/ranged/pistol/solemnvow
	name = "solemn vow"
	desc = "A pistol which carries with it grief for those who have perished. \
	Even with wings, no feather can leave this place."
	icon_state = "solemnvow"
	inhand_icon_state = "solemnvow"
	special = "While having either a second copy of this weapon or solemn lament will cause both guns to act like one.\nFiring both solemn lament and solemn vow at the same time will increase their damage by 30%"
	force = 9
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solemnvow
	fire_delay = 5
	max_shots = 18
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/abnormalities/funeral/spiritgunblack.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/pistol/solemnvow/afterattack(atom/target, mob/living/user, flag, params)
	dual_wield_spread = initial(dual_wield_spread)
	if(!user.get_inactive_held_item())
		return ..()
	if(!(istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnlament) || istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnvow)))
		return ..()
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, flag, params)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, flag, params)
	//Is it stupid as hell that we're doing this? yes, But the guns were used together in lcorp and I wanted the same functionality here.
	dual_wield_spread = 12
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

	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/G in H.held_items)
			if(G == src)
				continue
			else if(G.can_trigger_gun(user) && G.can_shoot(user))
				bonus_spread += dual_wield_spread
				loop_counter+=2.5
				addtimer(CALLBACK(G, TYPE_PROC_REF(/obj/item/ego_weapon/ranged, process_fire), target, user, TRUE, params, null, bonus_spread), loop_counter)

	return process_fire(target, user, TRUE, params, null, bonus_spread)

/obj/item/ego_weapon/ranged/pistol/solemnvow/OnReload(mob/user)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnlament/Lament in myman.held_items)
		to_chat(user,span_notice("You also reloaded the [Lament]."))
		Lament.shotsleft = Lament.max_shots
		break
	for(var/obj/item/ego_weapon/ranged/pistol/solemnvow/Vow in myman.held_items)
		if(Vow != src)
			to_chat(user,span_notice("You also reloaded the other [Vow]."))
			Vow.shotsleft = Vow.max_shots
			break

/obj/item/ego_weapon/ranged/pistol/solemnvow/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	dual_wield_spread = initial(dual_wield_spread)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnlament/Lament in myman.held_items)
		projectile_damage_multiplier *= 1.3
		break
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		projectile_damage_multiplier *= 2


/obj/item/ego_weapon/ranged/loyalty
	name = "loyalty"
	desc = "Courtesy of the 16th Ego rifleman's brigade."
	icon_state = "loyalty"
	inhand_icon_state = "loyalty"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/ego_loyalty
	weapon_weight = WEAPON_HEAVY
	spread = 26
	max_shots = 75
	reloadtime = 3 SECONDS
	special = "This weapon's ammunition has IFF capabilities."
	fire_sound = 'sound/weapons/gun/smg/vp70.ogg'
	autofire = 0.08 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
	)
	alternate_fire_name = "Underslung Grenade Launcher"
	alternate_info = "This rifle has an underslung grenade launcher. Bee grenades deal heavy AoE damage and knockback.\nAfter firing the UGL, you'll automatically swap to the primary fire mode."
	alternate_shotsleft = 1
	alternate_pellets = 1
	alternate_reload_type = RANGEDEGO_ALTERNATEFIRE_RELOADTYPE_SHARED_RELOAD
	alternate_projectile_path = /obj/projectile/ego_bullet/loyalty_ugl
	alternate_fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	alternate_fire_sound_volume = 70
	alternate_toggle_sound = 'sound/machines/click.ogg'
	alternate_toggle_sound_volume = 65
	alternate_toggle_enabled_message = span_notice("You ready your underslung grenade launcher.")
	alternate_toggle_disabled_message = span_notice("You will no longer use your underslung grenade launcher.")
	// Need to store this to modify the autofire after firing UGL
	var/datum/component/automatic_fire/autofire_component
	var/firing_ugl_extra_shot_delay_coeff = 10

/obj/item/ego_weapon/ranged/loyalty/Initialize(mapload)
	. = ..()
	autofire_component = GetComponent(/datum/component/automatic_fire)

/obj/item/ego_weapon/ranged/loyalty/process_chamber()
	. = ..()
	if(alternate_selected)
		DisableAltfire(null, TRUE)

/obj/item/ego_weapon/ranged/loyalty/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	spread = 0
	autofire_component.autofire_shot_delay = (autofire * firing_ugl_extra_shot_delay_coeff)

/obj/item/ego_weapon/ranged/loyalty/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	spread = initial(spread)
	autofire_component.autofire_shot_delay = autofire

/obj/item/ego_weapon/ranged/pistol/soda_premium
	name = "soda premium"
	desc = "A premium version of the classic soda pistol designed by Shrimp-Corp. Its bullets use patented shrimp technology to remove the soul from the body."
	icon_state = "soda_premium"
	inhand_icon_state = "soda_premium"
	special = "This weapon has pinpoint accuracy."
	force = 8
	damtype = PALE_DAMAGE
	burst_size = 1
	fire_delay = 5
	max_shots = 12
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	spread = 0
	variance = 0
	dual_wield_spread = 0
	projectile_path = /obj/projectile/ego_bullet/ego_soda_premium
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/pistol/crimson
	name = "crimson scar"
	desc = "With steel in one hand and gunpowder in the other, there's nothing to fear in this place."
	icon_state = "crimsonscar"
	inhand_icon_state = "crimsonscar"
	force = 9
	projectile_path = /obj/projectile/ego_bullet/ego_crimson
	weapon_weight = WEAPON_MEDIUM
	pellets = 3
	variance = 14
	fire_delay = 7
	max_shots = 9
	reloadtime = 1 SECONDS
	fire_sound = 'sound/abnormalities/redhood/fire.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/ecstasy
	name = "ecstasy"
	desc = "Tell the kid today's treat is going to be grape-flavored candy. It's his favorite."
	icon_state = "ecstasy"
	inhand_icon_state = "ecstasy"
	special = "This weapon fires slow bubbles with limited range."
	force = 16
	damtype = RED_DAMAGE
	attack_speed = 0.7
	projectile_path = /obj/projectile/ego_bullet/ego_ecstasy
	weapon_weight = WEAPON_MEDIUM
	spread = 30
	autofire = 0.08 SECONDS
	fire_sound = 'sound/weapons/ego/ecstasy.ogg'
	max_shots = 40
	ammo_on_reload = 1
	ammo_on_melee = 3
	passive_reload = 4 SECONDS
	reloadtime = 0.3 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/pistol/praetorian
	name = "praetorian"
	desc = "And with her guard, she conquered all."
	icon_state = "praetorian"
	inhand_icon_state = "praetorian"
	special = "This weapon fires IFF bullets that redirect towards the closest target."
	force = 9
	projectile_path = /obj/projectile/ego_bullet/ego_praetorian
	fire_sound = 'sound/weapons/gun/pistol/tp17.ogg'
	fire_delay = 5
	max_shots = 12
	reloadtime = 1 SECONDS
	fire_sound_volume = 30
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/pistol/magic_pistol
	name = "magic pistol"
	desc = "All the power of magic bullet, in a smaller package."
	icon_state = "magic_pistol"
	inhand_icon_state = "magic_pistol"
	special = "This weapon pierces all targets but loses damage the more targets it hits."
	force = 9
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_magicpistol
	fire_delay = 7
	max_shots = 7
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/magicbullet/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		projectile_damage_multiplier *= 3
	..()


/obj/item/ego_weapon/ranged/pistol/laststop
	name = "last stop"
	desc = "There are no clocks to alert the arrival times."
	icon_state = "laststop"
	inhand_icon_state = "laststop"
	force = 12
	attack_speed = 0.7
	projectile_path = /obj/projectile/ego_bullet/ego_laststop
	fire_delay = 5 SECONDS
	max_shots = 6
	ammo_on_reload = 1
	reloadtime = 1 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/intentions
	name = "good intentions"
	desc = "Go ahead and rattle 'em boys."
	special = "This weapon will periodically become more powerful as the lights on its side brighten, its spread, fire rate and eventually damage increasing. \n\
	The lights will brighten over time, and eventually dim. \n\
	Of course, nobody can know the arrival time."
	icon_state = "intentions"
	inhand_icon_state = "intentions"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/ego_intention
	weapon_weight = WEAPON_MEDIUM
	spread = 18
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.12 SECONDS
	max_shots = 50
	reloadtime = 2.1 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)
	/// Reference to our autofire component so we can modify the firerate.
	var/datum/component/automatic_fire/autofire_component
	/// Holds a timer until the next light change.
	var/light_progress_timer
	/// How long each light should last...
	var/light_duration = 1 MINUTES
	/// ...however, the duration of the light may be up to [this value] shorter or longer.
	var/light_duration_variance = 20 SECONDS

	var/current_light = 0
	/// Associate current light to corresponding firerate, projectile damage multiplier and spread.
	var/alist/lights_to_stats = alist(
		0 = list("autofire" = 0.12 SECONDS, "multiplier" = 1, spread = 18),
		1 = list("autofire" = 0.11 SECONDS, "multiplier" = 1, spread = 20),
		2 = list("autofire" = 0.10 SECONDS, "multiplier" = 1.1, spread = 24),
		3 = list("autofire" = 0.09 SECONDS, "multiplier" = 1.3, spread = 30),
		4 = list("autofire" = 0.08 SECONDS, "multiplier" = 1.6, spread = 38),
		)

/obj/item/ego_weapon/ranged/intentions/Initialize(mapload)
	. = ..()
	autofire_component = GetComponent(/datum/component/automatic_fire)
	// Prepare the next light switch
	var/next_lights = current_light == 4 ? (0) : (current_light + 1)
	var/next_light_time = light_duration + (rand(-light_duration_variance, light_duration_variance))
	light_progress_timer = addtimer(CALLBACK(src, PROC_REF(LightProgress), (next_lights)), next_light_time, TIMER_STOPPABLE)

/obj/item/ego_weapon/ranged/intentions/examine(mob/user)
	. = ..()
	. += span_warning("There are <b>[current_light] light(s)</b> burning on the side of the weapon.")

/obj/item/ego_weapon/ranged/intentions/proc/LightProgress(lights)
	if(!istype(autofire_component))
		return
	deltimer(light_progress_timer)
	if(!LAZYLEN(lights_to_stats))
		lights_to_stats = initial(lights_to_stats)

	// Remove whatever projectile damage multiplier we currently have on the gun, that is related to lights and not any external source
	projectile_damage_multiplier = 1

	// This is our new light value
	current_light = lights

	// Apply the new projectile damage multiplier on top of whatever we might have from EO upgrades/Faith&Promise
	projectile_damage_multiplier *= lights_to_stats[current_light]["multiplier"]

	// Set the firerate & spread to whatever is appropiate now
	autofire = lights_to_stats[current_light]["autofire"] // This shouldn't be needed but keeps things consistent
	autofire_component.autofire_shot_delay = lights_to_stats[current_light]["autofire"]
	spread = lights_to_stats[current_light]["spread"]

	// Update object sprite
	var/new_icon_state = initial(icon_state)
	if(current_light > 0)
		new_icon_state += "_[current_light]"
	icon_state = new_icon_state
	inhand_icon_state = new_icon_state

	if(istype(src.loc, /mob/living/carbon/human)) // I know this is horrifying but I sadly don't know any procs that let us pull the holder of an item.
		var/mob/living/carbon/human/holder = src.loc
		holder.regenerate_icons()

	// Play a SFX and alert people that this thing changed
	if(current_light == 0)
		playsound(src, 'sound/abnormalities/clock/end.ogg', 50, 0)
		audible_message(span_notice("The lights on [src] fizzle out."))
	else
		playsound(src, 'sound/abnormalities/clock/turn_on.ogg', 50, 0)
		audible_message(span_notice("A new light flickers on [src]."))

	// Prepare the next light switch
	var/next_lights = current_light == 4 ? (0) : (current_light + 1)
	var/next_light_time = light_duration + (rand(-light_duration_variance, light_duration_variance))
	light_progress_timer = addtimer(CALLBACK(src, PROC_REF(LightProgress), (next_lights)), next_light_time, TIMER_STOPPABLE)

/obj/item/ego_weapon/ranged/crossbow/aroma
	name = "faint aroma"
	desc = "Simply carrying it gives the illusion that you're standing in a forest in the middle of nowhere. \
			The arrowhead is dull and sprouts flowers of vivid color wherever it strikes."
	icon_state = "aroma"
	inhand_icon_state = "aroma"
	force = 24
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_aroma
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/accord
	name = "accord"
	desc = "However, the world is more than simply warmth and light. The sky exists, for so does the land; darkness exists, \
				for so does light; life exists for so does death; hope exists for so does despair."
	icon_state = "accord"
	inhand_icon_state = "accord"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	special = "Upon hitting an enemy, this weapon heals a nearby Discord weapon user."
	force = 24
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/accord
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	chargetime = 10
	spread = 0
	fire_sound = 'sound/weapons/bowfire.ogg'
	charge_sound = 'sound/weapons/bowdraw.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/accord/OnDischarge(mob/living/user)
	icon_state = "accord"

/obj/item/ego_weapon/ranged/accord/ChargeUp(mob/living/user)
	is_charging = TRUE
	projectile_path = initial(projectile_path)
	fire_sound = initial(fire_sound)
	charge_hold_time = initial(charge_hold_time)
	playsound(user, charge_sound, charge_sound_volume, vary_fire_sound)
	if(do_after(user, chargetime, src))
		icon_state = "accord_drawn"
		to_chat(user,span_notice("You draw [src] with all your might."))
		is_charging = FALSE
		charged = TRUE
		OnCharged(user)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(Uncharge), user), charge_hold_time, TIMER_STOPPABLE)
		return
	is_charging = FALSE
	to_chat(user, span_warning("You need to stand still to fully draw [src]!"))


/obj/item/ego_weapon/ranged/cannon/exuviae
	name = "exuviae"
	desc = "A chunk of the naked nest inigrated with a launching mechanism."
	icon_state = "exuviae"
	inhand_icon_state = "exuviae"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 36
	projectile_path = /obj/projectile/ego_bullet/ego_exuviae
	special = "Upon hit the targets RED vulnerability is increased by 0.2."
	damtype = RED_DAMAGE
	chargetime = 10
	fire_delay = 40 //5 less than the Rend Armor status effect
	max_shots = 6
	reloadtime = 0.3 SECONDS
	fire_sound = 'sound/misc/moist_impact.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

//Full manual bow-type E.G.O, must be loaded before firing.
/obj/item/ego_weapon/ranged/warring
	name = "feather of valor"
	desc = "A shimmering bow adorned with carved wooden panels. It crackes with arcing electricity."
	icon_state = "warring"
	inhand_icon_state = "warring"
	force = 24
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_warring
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	chargetime = 10
	spread = 0
	fire_sound = 'sound/weapons/bowfire.ogg'
	charge_sound = 'sound/weapons/bowdraw.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)
	charge = TRUE
	attack_charge_gain = FALSE
	charge_cost = 3
	ability_type = ABILITY_UNIQUE
	charge_effect = "fire a bolt of lightning that stuns and heals some sanity of humans on hit while being drawn for longer."
	visible_activation = "You will now fire a bolt of lightning."
	cancel_activation = "You will no longer fire a bolt of lightning."
	failed_activation = "You try to electrify your arrows... but your weapon does not respond!"
	var/ammo_2 = /obj/projectile/ego_bullet/ego_warring2

/obj/item/ego_weapon/ranged/warring/OnDischarge(mob/living/user)
	icon_state = "warring"

/obj/item/ego_weapon/ranged/warring/ChargeUp(mob/living/user)
	is_charging = TRUE
	projectile_path = initial(projectile_path)
	fire_sound = initial(fire_sound)
	charge_hold_time = initial(charge_hold_time)
	playsound(user, charge_sound, charge_sound_volume, vary_fire_sound)
	if(do_after(user, chargetime, src))
		icon_state = "warring_drawn"
		to_chat(user,span_notice("You draw [src] with all your might."))
		if(currently_charging)
			if(charge_amount < charge_cost)
				CancelCharge(user)
			charge_hold_time = 20
			charge_amount -= charge_cost
			fire_sound = 'sound/abnormalities/thunderbird/tbird_beam.ogg'
			projectile_path = ammo_2
			icon_state = "warring_firey"
			playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
		is_charging = FALSE
		charged = TRUE
		OnCharged(user)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(Uncharge), user), charge_hold_time, TIMER_STOPPABLE)
		return
	is_charging = FALSE
	to_chat(user, span_warning("You need to stand still to fully draw [src]!"))


/obj/item/ego_weapon/ranged/cannon/banquet
	name = "banquet"
	desc = "Time for a feast! Enjoy the blood-red night imbued with madness to your heart’s content!"
	icon_state = "banquet"
	inhand_icon_state = "banquet"
	special = "This weapon can use stored blood to fire without reloading. \
		Blood can be collected by attacking using this as a melee weapon."
	force = 36
	damtype = BLACK_DAMAGE
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/ego_banquet
	fire_delay = 20
	max_shots = 7
	reloadtime = 0.25 SECONDS
	fire_sound = 'sound/weapons/ego/cannon.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)
	var/bloodshot_ready = TRUE

/obj/item/ego_weapon/ranged/cannon/banquet/Initialize()
	. = ..()
	AddComponent(/datum/component/bloodfeast, siphon = TRUE, range = 2, starting = 150, threshold = 1500, max_amount = 1500)

/obj/item/ego_weapon/ranged/cannon/banquet/examine(mob/user)
	. = ..()
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	if(bloodfeast) // dont want to succ blood while contained
		. += "It has [bloodfeast.blood_amount] units of stored blood."

/obj/item/ego_weapon/ranged/cannon/banquet/proc/AdjustThirst(blood_amount)
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	bloodfeast.AdjustBlood(blood_amount)
	if(bloodfeast.blood_amount >= 150)
		bloodshot_ready = TRUE
		return
	bloodshot_ready = FALSE

/obj/item/ego_weapon/ranged/cannon/banquet/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/justicemod = get_attack_multiplier(user)
		AdjustThirst(force * justicemod)
	. = ..()

/obj/item/ego_weapon/ranged/cannon/banquet/can_shoot(mob/living/user)
	if(bloodshot_ready)
		return TRUE
	..()

/obj/item/ego_weapon/ranged/cannon/banquet/process_chamber(mob/living/user)
	if(bloodshot_ready && !shotsleft)
		AdjustThirst(-150)
	..()

/obj/item/ego_weapon/ranged/blind_rage
	name = "Blind Fire"
	desc = "The pain inflicted by rash action and harsh words last longer than most think."
	icon_state = "blind_gun"
	special = "This weapon fires burning bullets. Watch out for friendly fire!"
	projectile_path = /obj/projectile/ego_bullet/ego_blind_rage
	force = 24
	damtype = BLACK_DAMAGE
	weapon_weight = WEAPON_HEAVY
	pellets = 4
	variance = 30
	fire_delay = 8
	max_shots = 8
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/my_own_bride
	name = "My own Bride"
	desc = "Simply carrying it gives the illusion that you're standing in a forest in the middle of nowhere. \
			The arrowhead is dull and sprouts flowers of vivid color wherever it strikes."
	icon_state = "wife"
	inhand_icon_state = "wife"
	force = 24
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_bride
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 5
	max_shots = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
	)


/obj/item/ego_weapon/ranged/pistol/innocence
	name = "childhood memories"
	desc = "If no one had come in to get me, I would have stayed in that room, not even realizing the passing time."
	icon_state = "innocence_gun"
	inhand_icon_state = "innocence_gun"
	force = 9
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_innocence
	fire_sound = 'sound/abnormalities/orangetree/ding.ogg'
	vary_fire_sound = TRUE
	autofire = 0.2 SECONDS
	max_shots = 32
	reloadtime = 2.1 SECONDS
	fire_sound_volume = 20
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/crossbow/hypocrisy
	name = "hypocrisy"
	desc = "The tree turned out to be riddled with hypocrisy and deception; those who wear its blessing act in the name of bravery and faith."
	icon_state = "hypocrisy"
	inhand_icon_state = "hypocrisy"
	worn_icon_state = "hypocrisy"
	special = "Use the middle mouse button click/alt click to place a trap that inflicts \
		red damage and alerts the user of the area it was triggered."
	force = 24
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hypocrisy
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)
	var/trap_cooldown = 0

/obj/item/ego_weapon/ranged/crossbow/hypocrisy/AltClick(mob/living/carbon/user)
	if(locate(/obj/structure/liars_trap) in range(1, get_turf(src)))
		to_chat(user,span_notice("Your too close to another trap."))
		return
	to_chat(user,span_notice("You pull out an arrow and attempt to stab it into the ground."))
	playsound(src, 'sound/items/crowbar.ogg', 50, TRUE)
	if(do_after(user, 3 SECONDS, src))
		if(trap_cooldown >= world.time)
			to_chat(user,span_notice("You cant place a sapling trap yet."))
			return
		playsound(get_turf(user), 'sound/creatures/venus_trap_hurt.ogg', 50, TRUE)
		var/obj/structure/liars_trap/c = new(get_turf(user))
		c.multiplier = get_attack_multiplier(user) * force_multiplier * projectile_damage_multiplier
		c.creator = user
		c.faction = user.faction.Copy()
		trap_cooldown = world.time + (10 SECONDS)

//Parasite Tree Ego Weapon Trap
/obj/structure/liars_trap
	gender = PLURAL
	name = "sapling trap"
	desc = "A small harmless looking sapling. Its leaves never seem to wilt."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "liars_trap"
	anchored = TRUE
	density = FALSE
	resistance_flags = FLAMMABLE
	max_integrity = 15
	var/mob/living/carbon/human/creator
	var/list/faction = list()
	var/damage = 30
	var/multiplier = 1

/obj/structure/liars_trap/Initialize()
	. = ..()
	if(creator)
		faction = creator.faction.Copy()

/obj/structure/liars_trap/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(!faction_check(faction, L.faction))
			playsound(get_turf(src), 'sound/machines/clockcult/steam_whoosh.ogg', 10, 1)
			L.apply_damage(damage * multiplier, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = FALSE)
			new /obj/effect/temp_visual/cloud_swirl(get_turf(L)) //placeholder
			to_chat(creator, span_warning("You feel a itch towards [get_area(L)]."))
			qdel(src)

/obj/item/ego_weapon/ranged/fellbullet
	name = "fell bullet"
	desc = "A Lee-Einfeld bolt-action rifle that fires cursed bullets."
	icon_state = "fell_bullet"
	inhand_icon_state = "fell_bullet"
	special = "This weapon pierces all targets. \
		Use the middle mouse button click/alt click to create a portal, which can be fired into at for doubled damage the cost of a slower fire rate."
	force = 24
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_fellbullet
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	max_shots = 10
	reloadtime = 2 SECONDS
	fire_sound = 'sound/abnormalities/fluchschutze/fell_bullet.ogg'
	reload_success_sound = 'sound/abnormalities/fluchschutze/fell_aim.ogg'
	var/portaling = FALSE
	var/shooting = FALSE
	var/portal_cooldown
	var/portal_cooldown_time = 15 SECONDS
	var/obj/effect/portal/myportal
	var/obj/effect/portal/targetportal

	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/fellbullet/afterattack(atom/target, mob/living/user, flag, params)
	if(!CanUseEgo(user))
		return
	if(semicd)//stops firing speed anomalies
		return
	if(portaling)
		portaling = FALSE
		if(!LAZYLEN(get_path_to(src,target, TYPE_PROC_REF(/turf, Distance), 0, 24)))
			to_chat(user, span_notice("Target unreachable."))
			return
		var/obj/effect/portal/fellbullet/P1 = new(user)
		var/obj/effect/portal/fellbullet/P2 = new(get_turf(target))
		P1.link_portal(P2)
		P2.link_portal(P1)
		playsound(src, 'sound/abnormalities/fluchschutze/fell_magic.ogg', 50, TRUE)
		portal_cooldown = world.time + portal_cooldown_time
		myportal = P1
		targetportal = P2
		AdjustCircle(user, P1, target)
		AdjustCircle(user, P2, target)
		return
	if(!myportal)//If myportal hasn't initialized yet, this prevents it from runtiming.
		return ..()
	if(myportal in user)//is it not qdeleted?
		if(shooting)
			return
		AdjustCircle(user, myportal, target)
		myportal.forceMove(get_turf(user))//move the portal to your turf, line 733 removes it later.
		playsound(src, 'sound/abnormalities/fluchschutze/fell_portal.ogg', 50, FALSE)
		shooting = TRUE
		if(do_after(user, 3, src)) //gotta wait
			. = ..()
		if(myportal.loc && !is_reloading)//hide the portal
			AdjustCircle(user, targetportal, target)
			myportal.forceMove(user)
		shooting = FALSE
		return
	. = ..()

/obj/item/ego_weapon/ranged/fellbullet/MiddleClickAction(atom/target, mob/user)
	if(portaling)
		portaling = FALSE
		to_chat(user,span_notice("You will no longer create a circle."))
		return
	if(portal_cooldown > world.time)
		to_chat(user,span_warning("You cannot create a magic circle yet!"))
		return
	portaling = TRUE
	to_chat(user,span_notice("You will now create a magic circle at your target."))
	return ..()

/obj/item/ego_weapon/ranged/fellbullet/proc/AdjustCircle(mob/living/user, atom/theportal, atom/target)
	theportal.transform = initial(theportal.transform)
	theportal.layer = initial(theportal.layer)
	var/matrix/M = matrix(theportal.transform)
	var/turf/T = get_turf(user)
	var/rot_angle = Get_Angle(T, get_turf(target))
	M.Turn(rot_angle)
	switch(user.dir)
		if(EAST)
			M.Scale(0.5, 1)
			M.Translate(12, 0)
		if(WEST)
			M.Scale(0.5, 1)
			M.Translate(-16, 0)
		if(NORTH)
			M.Translate(0, 8)
			myportal.layer -= 0.2
	theportal.transform = M

/obj/effect/portal/fellbullet
	name = "magic circle"
	desc = "A circle of red magic featuring a six-pointed star "
	icon = 'icons/effects/effects.dmi'
	icon_state = "fellcircle"
	teleport_channel = TELEPORT_CHANNEL_FREE
	layer = ABOVE_MOB_LAYER

/obj/effect/portal/fellbullet/teleport(atom/movable/M, force = FALSE)
	if(!istype(M, /obj/projectile/ego_bullet/ego_fellbullet))
		return
	var/obj/projectile/ego_bullet/ego_fellbullet/B = M
	if(B.damage > 36)
		return
	B.damage *= 2
	B.ff_multiplier *= 0.5
	var/turf/real_target = get_link_target_turf()
	for(var/obj/effect/portal/fellbullet/P in real_target)
		playsound(P, 'sound/abnormalities/fluchschutze/fell_portal.ogg', 50, TRUE)
		playsound(P, 'sound/abnormalities/fluchschutze/fell_bullet2.ogg', 50, TRUE)
	..()

/obj/effect/portal/fellbullet/attack_hand(mob/user)
//the parent behavior will pull you towards it

/obj/effect/portal/fellbullet/Initialize()
	INVOKE_ASYNC(src, PROC_REF(DoAnimation))//60% uptime
	return ..()

/obj/effect/portal/fellbullet/proc/DoAnimation()
	sleep(10 SECONDS)
	animate(src, alpha = 0, time = 1 SECONDS)
	QDEL_IN(src, 1 SECONDS)

/obj/item/ego_weapon/ranged/fellscatter
	name = "fell scatter"
	desc = "A bolt-action rifle fitted with a wider barrel. It fires cursed shells."
	icon_state = "fell_scatter"
	inhand_icon_state = "fell_scatter"
	force = 24
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_fellscatter
	weapon_weight = WEAPON_HEAVY
	pellets = 7
	variance = 50
	fire_delay = 15
	max_shots = 4
	ammo_on_reload = 1
	reloadtime = 0.5 SECONDS
	fire_sound = 'sound/abnormalities/fluchschutze/fell_scatter.ogg'
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	alternate_reload_time = 2 SECONDS
	alternate_fire_name = "Designate Target"
	alternate_projectile_path = /obj/projectile/ego_bullet/special_fellbullet
	alternate_info = "This weapon fires a magical slug. \
	The slug will penetrate most targets. Shooting a human will deal half damage and produce a special effect."
	alternate_fire_sound = 'sound/abnormalities/fluchschutze/fell_bullet.ogg'
	alternate_pellets = 1
	alternate_variance  = 0
	alternate_toggle_sound = 'sound/abnormalities/fluchschutze/fell_aim.ogg'
	alternate_toggle_sound_volume = 50
	alternate_toggle_enabled_message = span_notice("You will now fire a magical slug.")
	alternate_toggle_disabled_message = span_notice("You will now fire shotgun shells.")
	alternate_reload_type = RANGEDEGO_ALTERNATEFIRE_RELOADTYPE_EMPTY_MAG
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/fellscatter/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	max_shots = 1

/obj/item/ego_weapon/ranged/fellscatter/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	max_shots = initial(max_shots)

/obj/item/ego_weapon/ranged/sodashotty
	name = "soda shotgun"
	desc = "A gun used by Shrimp-Corp, apparently."
	special = "This weapon fires a fixed spread of bullets."
	icon_state = "sodashotgun"
	inhand_icon_state = "sodashotgun"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/soda_shotty
	pellets = 8
	variance = 16
	randomspread = FALSE
	pellets = 6
	max_shots = 12
	reloadtime = 0.3 SECONDS
	ammo_on_reload = 1
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/ego_weapon/ranged/sodasmg
	name = "soda submachinegun"
	desc = "A gun used by Shrimp-Corp, apparently."
	icon_state = "sodasmg"
	inhand_icon_state = "sodasmg"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/soda_smg
	weapon_weight = WEAPON_MEDIUM
	spread = 8
	max_shots = 40
	reloadtime = 1.7 SECONDS
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.15 SECONDS


/obj/item/ego_weapon/ranged/sodaminigun
	name = "soda minigun"
	desc = "A gun used by Shrimp-Corp, apparently."
	icon_state = "sodaminigun"
	inhand_icon_state = "sodaminigun"
	force = 34
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/soda_mini
	weapon_weight = WEAPON_HEAVY
	drag_slowdown = 3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)
	slowdown = 2
	spread = 24
	max_shots = 800
	reloadtime = 6 SECONDS
	item_flags = SLOWS_WHILE_IN_HAND
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	burst_size = 4
	autofire = 0.05 SECONDS

/obj/item/ego_weapon/ranged/sodaassault
	name = "soda assault rifle"
	desc = "A gun used by Shrimp-Corp, apparently."
	icon_state = "sodaassault"
	inhand_icon_state = "sodaassault"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/soda_assault
	weapon_weight = WEAPON_HEAVY
	burst_size = 3
	burst_delay = 6
	autofire = 0.8 SECONDS
	max_shots = 51
	reloadtime = 1.5 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/ego_weapon/ranged/ebony_stem
	name = "ebony stem"
	desc = "An apple does not culminate when it ripens to bright red; \
	only when the apple shrivels up and attracts lowly creatures."
	special = "This weapon creates spikey roots in an area instead of shooting."
	icon_state = "ebony_stem"
	force = 18
	attack_speed = 1
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("admonishes", "rectifies", "conquers")
	attack_verb_simple = list("admonish", "rectify", "conquer")
	hitsound = 'sound/weapons/ego/rapier2.ogg'
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 12
	max_shots = 12
	passive_reload = 6 SECONDS
	reloadtime = 3
	chargetime = 5
	charge_sound = 'sound/creatures/venus_trap_hurt.ogg'
	projectile_name = "root"
	projectile_name_plural = "roots"
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	alternate_fire_name = "Barrage Roots"
	alternate_info = "This weapon will cast a trailing line of weaker roots starting from the user."
	alternate_reload_type = RANGEDEGO_ALTERNATEFIRE_RELOADTYPE_SHARED_MAGAZINE
	alternate_toggle_sound = 'sound/creatures/venus_trap_hurt.ogg'
	alternate_toggle_sound_volume = 65
	alternate_toggle_enabled_message = span_notice("You channel your energy, you will now cast Barrage Roots.")
	alternate_toggle_disabled_message = span_notice("You release your energy, you will now cast Root Burst")
	var/ranged_damage = 50

/obj/item/ego_weapon/ranged/ebony_stem/GunAttackInfo()
	var/damage_type = damtype
	var/base_damage = ranged_damage
	if(alternate_selected)
		base_damage = 40
	var/damage = round(base_damage * force_multiplier * projectile_damage_multiplier, 0.1)
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	return span_notice("Its [projectile_name_plural] deal [damage] [damage_type] damage.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")

/obj/item/ego_weapon/ranged/ebony_stem/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
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
	if(!alternate_selected)
		DoAOE(user, target)
	else
		var/obj/effect/rootline/R = new(get_step_towards(user, target), user)
		R.damage *= force_multiplier * get_attack_multiplier(user)
		R.rootBarrage(target)
	process_chamber(user)
	semicd = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_semicd)), fire_delay)

	if(user)
		user.update_inv_hands()
	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

	return TRUE

/obj/item/ego_weapon/ranged/ebony_stem/proc/DoAOE(mob/living/user, mob/living/target)
	var/turf/target_turf = get_turf(target)
	var/damage_dealt = ranged_damage * force_multiplier * get_attack_multiplier(user)
	playsound(target_turf, 'sound/abnormalities/ebonyqueen/attack.ogg', 50, TRUE)
	for(var/turf/open/T in RANGE_TURFS(1, target_turf))
		new /obj/effect/temp_visual/thornspike(T)
		user.HurtInTurf(T, list(), damage_dealt, BLACK_DAMAGE, hurt_mechs = TRUE)


/obj/effect/rootline
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/damage = 40
	var/mob/living/spawner
	var/barrage_range = 12
	var/broken = 0
	layer = POINT_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/rootline/New(loc, ...)
	. = ..()
	if(args[2])
		spawner = args[2]

/obj/effect/rootline/proc/rootBarrage(atom/attack_target) //line attack
	var/turf/target_turf = get_ranged_target_turf_direct(src, attack_target, barrage_range)
	var/count = 0
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			broken = count
			break
		count = count + 1
		addtimer(CALLBACK(src, PROC_REF(stabHit), T, count), (3 * (((count-1)*0.50)+1)) + 0.25 SECONDS)

/obj/effect/rootline/proc/stabHit(turf/T, count)
	if(QDELETED(src))
		return
	playsound(T, 'sound/abnormalities/ebonyqueen/attack.ogg', 50, TRUE)
	new /obj/effect/temp_visual/thornspike(T)
	for(var/mob/living/L in T)
		if(spawner == L)
			continue
		L.deal_damage(damage, BLACK_DAMAGE)
	if(count == barrage_range || count == broken)
		qdel(src)
