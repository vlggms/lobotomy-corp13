/obj/item/ego_weapon/ranged/prank
	name = "funny prank"
	desc = "The small accessory remains like the wishes of a child who yearned for happiness."
	icon_state = "prank"
	worn_icon_state = "prank"
	inhand_icon_state = "prank"
	force = 20
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_prank
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	shotsleft = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/pistol/gaze
	name = "gaze"
	desc = "A magnum pistol featuring excellent burst firing potential."
	icon_state = "gaze"
	inhand_icon_state = "gaze"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/ego_gaze
	fire_delay = 10
	shotsleft = 8
	reloadtime = 1.8 SECONDS
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
	icon_state = "galaxy"
	inhand_icon_state = "galaxy"
	special = "Use in hand to turn on homing mode. This mode fires slower, but homes in on a random target within 15 metres.	\
			WARNING: This feature is not accurate."
	projectile_path = /obj/projectile/ego_bullet/ego_galaxy
	force = 20
	damtype = BLACK_DAMAGE
	fire_delay = 15
	fire_sound = 'sound/magic/wand_teleport.ogg'
	weapon_weight = WEAPON_MEDIUM
	fire_sound_volume = 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/homing = FALSE

/obj/item/ego_weapon/ranged/galaxy/attack_self(mob/user)
	..()
	if(homing)
		to_chat(user,span_warning("You release your energy, and turn off homing."))
		fire_delay = 15
		projectile_path = initial(projectile_path)
		homing = FALSE
		return
	if(!homing)
		to_chat(user,span_warning("You channel your energy, enabling homing."))
		fire_delay = 20
		projectile_path = /obj/projectile/ego_bullet/ego_galaxy/homing
		homing = TRUE
		return

/obj/item/ego_weapon/ranged/unrequited
	name = "unrequited love"
	desc = "This weapon yearns for affection and will do anything to get your attention. Of course it will misunderstand your care for something else."
	icon_state = "unrequited"
	inhand_icon_state = "unrequited"
	special = "This weapon will sometimes jam. \
			Use this weapon in hand to unjam it. \
			this weapon fires faster and in a bigger burst for 15 seconds after being unjammed."
	force = 20
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_unrequited
	fire_delay = 3
	burst_size = 3
	fire_sound = 'sound/weapons/gun/l6/shot.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/jam_cooldown
	var/jam_cooldown_time //this will actually be semi-randomized just so you can get the true surprise jam experience while red buddy is chasing you
	var/jammed = FALSE
	var/jam_noticed = FALSE

/obj/item/ego_weapon/ranged/unrequited/Initialize()
	. = ..()
	jam_cooldown_time = rand(1, 5) MINUTES
	jam_cooldown = jam_cooldown_time + world.time
	START_PROCESSING(SSobj, src)

/obj/item/ego_weapon/ranged/unrequited/process()
	if(jammed)
		return
	if(jam_cooldown < world.time)
		jammed = TRUE

/obj/item/ego_weapon/ranged/unrequited/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/ego_weapon/ranged/unrequited/proc/ResetDelay()
	fire_delay = 3
	burst_size = 3

/obj/item/ego_weapon/ranged/unrequited/SpecialEgoCheck(mob/living/carbon/human/H)
	if(!jammed)
		return TRUE

	if(jam_noticed)
		playsound(src, dry_fire_sound, 30, TRUE)
	else
		playsound(src, 'sound/weapons/gun/general/bolt_drop.ogg', 50, TRUE)
		jam_noticed = TRUE

	to_chat(H, span_notice("[src] is jammed!"))
	return FALSE

/obj/item/ego_weapon/ranged/unrequited/attack_self(mob/user)
	to_chat(user,span_notice("You try to unjam [src]."))
	playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
	if(do_after(user, 3 SECONDS, src)) //it's a massive annoyance to unjam in the middle of a fight but the extra damage should make it more than worth it.
		playsound(src, 'sound/weapons/gun/general/bolt_rack.ogg', 50, TRUE)
		if(!jammed)
			to_chat(user,span_notice("Turns out the weapon is working just fine."))
			return
		jammed = FALSE
		jam_noticed = FALSE
		fire_delay = 2
		burst_size = 5
		addtimer(CALLBACK(src, PROC_REF(ResetDelay)), 15 SECONDS)
		to_chat(user,span_notice("You succesfully unjammed [src]!"))
		jam_cooldown_time = rand(1, 5) MINUTES
		jam_cooldown = jam_cooldown_time + world.time

/obj/item/ego_weapon/ranged/harmony
	name = "harmony"
	desc = "A massive blocky launcher with some suspicious stains on it."
	icon_state = "harmony"
	inhand_icon_state = "harmony"
	special = "This weapon fires bouncing, piercing shots. On hitting an insane person, deals 4x damage and stops bouncing."
	force = 30
	damtype = WHITE_DAMAGE
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/ego_harmony
	fire_sound = 'sound/weapons/ego/harmony1.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	shotsleft = 18
	reloadtime = 1.6 SECONDS

	autofire = 0.35 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/transmission
	name = "broken transmission"
	desc = "It's an old wooden longrifle."
	icon_state = "transmission"
	inhand_icon_state = "transmission"
	force = 20
	projectile_path = /obj/projectile/ego_bullet/ego_transmission
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	shotsleft = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/song
	name = "song of the past"
	desc = "Nothing beats the classics."
	icon_state = "song"
	inhand_icon_state = "song"
	force = 20
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_song
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	weapon_weight = WEAPON_MEDIUM
	shotsleft = 32
	reloadtime = 1.6 SECONDS
	spread = 8
	autofire = 0.15 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/pistol/songmini
	name = "greatest oldies"
	desc = "The past is far behind us."
	icon_state = "songmini"
	inhand_icon_state = "songmini"
	force = 12
	damtype = WHITE_DAMAGE
	pellets = 4
	variance = 20
	projectile_path = /obj/projectile/ego_bullet/ego_songmini
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	shotsleft = 16
	reloadtime = 2.1 SECONDS
	spread = 8
	autofire = 0.3 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/wedge
	name = "screaming wedge"
	desc = "Hair has grown on the crossbow as if to express that the woman’s dejection will never be forgotten."
	icon_state = "screamingwedge"
	inhand_icon_state = "screamingwedge"
	force = 20
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_wedge
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10

	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
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
	force = 12
	projectile_path = /obj/projectile/ego_bullet/ego_swindle
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	shotsleft = 12
	reloadtime = 1.5 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/ringing
	name = "ringing"
	desc = "Voices from your past emanate from this gun. Now they can be put into use."
	icon_state = "ringing"
	inhand_icon_state = "ringing"
	special = "This weapon can be used as a megaphone."
	force = 20
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_ringing
	weapon_weight = WEAPON_HEAVY
	autofire = 0.15 SECONDS
	spread = 25
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
	special = "This weapon fires slow bullets with limited range."
	force = 20
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_syrinx
	weapon_weight = WEAPON_MEDIUM
	spread = 40
	shotsleft = 40
	reloadtime = 2 SECONDS
	fire_sound = 'sound/weapons/ego/ecstasy.ogg'
	autofire = 0.08 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
	)


/obj/item/ego_weapon/ranged/ardor_star
	name = "ardor blossom star"
	desc = "Though I can't guide you... I can offer a warm embrace."
	icon_state = "ardor_star"
	inhand_icon_state = "ardor_star"
	force = 30
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/ardor_star
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	fire_delay = 10
	shotsleft = 4
	reloadtime = 2.1 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/pistol/deathdealer
	name = "death dealer"
	desc = "A gilded revolver which seems to defy all known laws of gun manufacturing... Feel lucky?"
	icon_state = "deathdealer" //Placeholder sprite. Will need to comission/replace with proper sprites
	inhand_icon_state = "deathdealer"
	special = "This weapon changes its projectile each time it is reloaded. It cannot be reloaded without firing all six shots first."
	projectile_path = /obj/projectile/ego_bullet/ego_gaze
	weapon_weight = WEAPON_HEAVY
	fire_delay = 8
	shotsleft = 6
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

/obj/item/ego_weapon/ranged/squeak
	name = "squeaky toy"
	desc = "Soft to the touch, as if it's made of rubber"
	icon_state = "squeak"
	inhand_icon_state = "squeak"
	force = 18
	projectile_path = /obj/projectile/ego_bullet/ego_squeak
	weapon_weight = WEAPON_MEDIUM
	spread = 10
	shotsleft = 30
	reloadtime = 1.3 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.14 SECONDS
