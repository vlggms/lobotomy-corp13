/obj/item/ego_weapon/ranged/prank
	name = "funny prank"
	desc = "The small accessory remains like the wishes of a child who yearned for happiness."
	icon_state = "prank"
	worn_icon_state = "prank"
	inhand_icon_state = "prank"
	force = 16
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_prank
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	max_shots = 10
	ammo_on_reload = 1
	reloadtime = 0.3 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/pistol/gaze
	name = "gaze"
	desc = "A magnum pistol featuring excellent burst firing potential."
	icon_state = "gaze"
	inhand_icon_state = "gaze"
	force = 6
	projectile_path = /obj/projectile/ego_bullet/ego_gaze
	fire_delay = 3 //FAN THE HAMMER
	click_cooldown_override = 3
	shotsleft = 8
	reloadtime = 2 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/galaxy
	name = "galaxy"
	desc = "A shimmering wand."
	special = "This weapon's magic doesn't hit allies."
	icon_state = "galaxy"
	inhand_icon_state = "galaxy"
	projectile_path = /obj/projectile/ego_bullet/ego_galaxy
	force = 10
	attack_speed = 0.8
	damtype = BLACK_DAMAGE
	fire_delay = 10
	max_shots = 30
	passive_reload = 8 SECONDS
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/magic/wand_teleport.ogg'
	weapon_weight = WEAPON_MEDIUM
	fire_sound_volume = 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

	fire_sound = 'sound/magic/staff_change.ogg'
	alternate_fire_name = "Glimmer"
	alternate_info = "This weapon fires slower, but fires a slower moving projectile that homes in on the nearest target within a small radius."
	alternate_reload_type = RELOADTYPE_SHARED_MAGAZINE
	alternate_projectile_path = /obj/projectile/ego_bullet/ego_galaxy/homing
	alternate_fire_sound = 'sound/magic/charge.ogg'
	alternate_fire_sound_volume = 70
	alternate_toggle_sound = 'sound/magic/wand_teleport.ogg'
	alternate_toggle_sound_volume = 65
	alternate_toggle_enabled_message = span_notice("You channel your energy, enabling homing.")
	alternate_toggle_disabled_message = span_notice("You release your energy, and turn off homing.")

/obj/item/ego_weapon/ranged/galaxy/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	fire_delay = 12

/obj/item/ego_weapon/ranged/galaxy/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	fire_delay = 10

//The yandere weapon
/obj/item/ego_weapon/ranged/unrequited
	name = "unrequited love"
	desc = "This weapon yearns for affection and will do anything to get your attention. Of course it will misunderstand your care for something else."
	special = "This weapon becomes less effective if you possess any other EGO weapons."
	icon_state = "unrequited"
	inhand_icon_state = "unrequited"
	force = 16
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_unrequited
	fire_delay = 10
	burst_size = 3
	burst_delay = 5
	max_shots = 24
	reloadtime = 1.8 SECONDS
	fire_sound = 'sound/weapons/gun/l6/shot.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/unrequited/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return
	if(semicd)
		return
	var/onlyweapon = TRUE
	fire_delay = 10
	var/list/search_area = user.contents.Copy()
	for(var/obj/item/storage/spare_space in search_area)
		search_area |= spare_space.contents
	for(var/obj/item/ego_weapon/disloyal_weapon in search_area)
		if(disloyal_weapon == src)
			continue
		// You are breaking my heart player-sama </3
		onlyweapon = FALSE
		fire_delay = 13
		break
	if(onlyweapon)
		new /obj/effect/temp_visual/mermaid_drowning(get_turf(user))
	return ..()

/obj/item/ego_weapon/ranged/cannon/harmony
	name = "harmony"
	desc = "It may look like a deteriorating machine at first glance, but the music it makes captures its audience more than any other instrument could."
	icon_state = "harmony"
	inhand_icon_state = "harmony"
	force = 24
	damtype = RED_DAMAGE // Its a massive chunk of metal
	projectile_path = /obj/projectile/ego_bullet/ego_harmony
	fire_delay = 15
	chargetime = 7
	max_shots = 5
	reloadtime = 0.8 SECONDS
	alternate_reload_time = 0.8 SECONDS
	alternate_fire_name = "Grinding Noise"
	alternate_reload_type = RELOADTYPE_SHARED_MAGAZINE
	alternate_projectile_path = /obj/projectile/ego_bullet/ego_harmony/strong
	alternate_info = "This weapon's shots will deal increased damage at a cost of health loss every time it fires."
	alternate_fire_sound = 'sound/weapons/ego/cannon.ogg'
	alternate_toggle_enabled_message = span_notice("You flip a switch, causing the weapon's sawblades to spin wildly.")
	alternate_toggle_disabled_message = span_notice("You flip a switch, causing the weapon's sawblades to slow down.")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/cannon/harmony/before_firing(atom/target, mob/living/user)
	if(alternate_selected)
		playsound(src, 'sound/abnormalities/singingmachine/chew.ogg', 50, TRUE)
		to_chat(user, span_danger("[src] grinds a bit of your body as it fires!"))
		user.adjustBruteLoss(user.maxHealth*0.05)

/obj/item/ego_weapon/ranged/transmission
	name = "broken transmission"
	desc = "It's an old wooden longrifle."
	icon_state = "transmission"
	inhand_icon_state = "transmission"
	force = 16
	projectile_path = /obj/projectile/ego_bullet/ego_transmission
	weapon_weight = WEAPON_HEAVY
	fire_delay = 7
	max_shots = 10
	ammo_on_reload = 1
	reloadtime = 0.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/song
	name = "song of the past"
	desc = "Nothing beats the classics."
	special = "Reloading this weapon while having an empty clip will heal the SP of everyone nearby."
	icon_state = "song"
	inhand_icon_state = "song"
	force = 16
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_song
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	weapon_weight = WEAPON_MEDIUM
	max_shots = 32
	reloadtime = 2 SECONDS
	spread = 8
	autofire = 0.15 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/currentshots = 0
	var/sanity_gain = 10

/obj/item/ego_weapon/ranged/song/reload_ego(mob/user)
	currentshots = shotsleft
	. = ..()

/obj/item/ego_weapon/ranged/song/OnReload(mob/user)
	if(currentshots == 0)
		playsound(src, 'sound/abnormalities/siren/sirenhappy.ogg', 100, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(3, get_turf(user)))
			L.adjustSanityLoss(-sanity_gain)

/obj/item/ego_weapon/ranged/pistol/songmini
	name = "greatest oldies"
	desc = "The past is far behind us."
	icon_state = "songmini"
	inhand_icon_state = "songmini"
	force = 6
	damtype = WHITE_DAMAGE
	pellets = 4
	variance = 20
	projectile_path = /obj/projectile/ego_bullet/ego_songmini
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	max_shots = 16
	reloadtime = 1 SECONDS
	autofire = 0.2 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/crossbow/wedge
	name = "screaming wedge"
	desc = "Hair has grown on the crossbow as if to express that the woman’s dejection will never be forgotten."
	icon_state = "screamingwedge"
	inhand_icon_state = "screamingwedge"
	force = 16
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_wedge
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/pistol/swindle
	name = "swindle"
	desc = "Good for man and beast, it gives immediate relief. Snake oil is good for everything a liniment ought to be for!"
	icon = 'icons/obj/guns/projectile.dmi'//put some non-E.G.O sprites to use
	icon_state = "goldrevolver"
	inhand_icon_state = "deagleg"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	special = "This weapon fires dice that deal varying amounts of damage."
	force = 6
	projectile_path = /obj/projectile/ego_bullet/ego_swindle
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 5
	max_shots = 8
	ammo_on_reload = 1
	reloadtime = 0.15 SECONDS
	reload_success_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/ringing
	name = "ringing"
	desc = "Voices from your past emanate from this gun. Now they can be put into use."
	icon_state = "ringing"
	inhand_icon_state = "ringing"
	special = "This weapon fires hitscan sound waves and can be used as a megaphone."
	force = 12
	attack_speed = 1
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_ringing
	weapon_weight = WEAPON_MEDIUM
	max_shots = 45
	reloadtime = 3 SECONDS
	autofire = 0.15 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/spamcheck = 0
	var/list/voicespan = list(SPAN_COMMAND)

/obj/item/ego_weapon/ranged/ringing/equipped(mob/M, slot)//megaphone code
	. = ..()
	if (slot == ITEM_SLOT_HANDS && !HAS_TRAIT(M, TRAIT_SIGN_LANG))
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/ego_weapon/ranged/ringing/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/ego_weapon/ranged/ringing/proc/handle_speech(mob/living/carbon/user, list/speech_args)
	if (user.get_active_held_item() == src)
		if(!shotsleft)
			user.visible_message(span_notice(out_of_ammo))
			return
		process_chamber(user)
		if(spamcheck > world.time)
			to_chat(user, span_warning("\The [src] needs to recharge!"))
		else
			playsound(loc, 'sound/items/megaphone.ogg', 100, FALSE, TRUE)
			spamcheck = world.time + 50
			speech_args[SPEECH_SPANS] |= voicespan

/obj/item/ego_weapon/ranged/syrinx
	name = "syrinx"
	desc = "What cry could be more powerful than one spurred by primal instinct?"
	icon_state = "syrinx"
	inhand_icon_state = "syrinx"
	special = "This weapon fires hitscan sound waves."
	force = 10
	attack_speed = 0.7
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_syrinx
	weapon_weight = WEAPON_MEDIUM
	spread = 0
	max_shots = 40
	ammo_on_reload = 1
	ammo_on_melee = 3
	passive_reload = 4 SECONDS
	reloadtime = 0.5 SECONDS
	fire_sound = 'sound/weapons/ego/syrinx1.ogg'
	fire_sound_volume = 25
	autofire = 0.2 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
	)


/obj/item/ego_weapon/ranged/syrinx/before_firing(atom/target, mob/living/user)
	fire_sound = "sound/weapons/ego/syrinx[rand(1,3)].ogg"
	return ..()

/obj/item/ego_weapon/ranged/pistol/deathdealer
	name = "death dealer"
	desc = "A gilded revolver which seems to defy all known laws of gun manufacturing... Feel lucky?"
	icon_state = "deathdealer" //Placeholder sprite. Will need to comission/replace with proper sprites
	inhand_icon_state = "deathdealer"
	special = "This weapon changes its projectile each time it is reloaded. It cannot be reloaded without firing all six shots first."
	projectile_path = /obj/projectile/ego_bullet/ego_gaze
	weapon_weight = WEAPON_HEAVY
	fire_delay = 8
	max_shots = 6
	reloadtime = 1.3 SECONDS
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	var/list/ammotypes = list(
		/obj/projectile/ego_bullet/ego_magicbullet,
		/obj/projectile/ego_bullet/ego_supershotgun,
		/obj/projectile/ego_bullet/ego_solemnlament,
		/obj/projectile/ego_bullet/ego_harmony,
		/obj/projectile/ego_bullet/ego_match,
		/obj/projectile/ego_bullet/ego_gaze,
	)
	//TODO: Make it so that the fire_sound manages to match the bullet, I.E. magic bullet shots use the magic bullet sound.

/obj/item/ego_weapon/ranged/pistol/deathdealer/reload_ego(mob/user)
	if(shotsleft != 0)
		to_chat(user,span_warning("You cannot reload this gun without an empty cylinder!"))
		return
	projectile_path = pick(ammotypes)
	update_projectile_examine()
	if(projectile_path == /obj/projectile/ego_bullet/ego_supershotgun)
		pellets = 10
		variance = 35
	else
		pellets = initial(pellets)
		variance = initial(variance)
	return ..()

/obj/item/ego_weapon/ranged/sodarifle
	name = "soda rifle"
	desc = "A gun used by shrimp corp, apparently."
	icon_state = "sodarifle"
	inhand_icon_state = "sodarifle"
	force = 16
	projectile_path = /obj/projectile/ego_bullet/soda_rifle
	weapon_weight = WEAPON_HEAVY
	fire_delay = 6
	max_shots = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							)

