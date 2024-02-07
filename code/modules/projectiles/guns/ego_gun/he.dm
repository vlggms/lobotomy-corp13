/obj/item/gun/ego_gun/prank
	name = "funny prank"
	desc = "The small accessory remains like the wishes of a child who yearned for happiness."
	icon_state = "prank"
	worn_icon_state = "prank"
	inhand_icon_state = "prank"
	ammo_type = /obj/item/ammo_casing/caseless/ego_prank
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	damtype = BLACK_DAMAGE
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/pistol/gaze
	name = "gaze"
	desc = "A magnum pistol featuring excellent burst firing potential."
	icon_state = "gaze"
	inhand_icon_state = "gaze"
	ammo_type = /obj/item/ammo_casing/caseless/ego_gaze
	fire_delay = 20
	fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/galaxy
	name = "galaxy"
	desc = "A shimmering wand."
	icon_state = "galaxy"
	inhand_icon_state = "galaxy"
	special = "Use in hand to turn on homing mode. This mode fires slower, but homes in on a random target within 15 metres.	\
			WARNING: This feature is not accurate."
	ammo_type =	/obj/item/ammo_casing/caseless/ego_galaxy
	fire_delay = 15
	fire_sound = 'sound/magic/wand_teleport.ogg'
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/homing = FALSE

/obj/item/gun/ego_gun/galaxy/attack_self(mob/user)
	..()
	if(homing)
		to_chat(user,"<span class='warning'>You release your energy, and turn off homing.</span>")
		ammo_type = /obj/item/ammo_casing/caseless/ego_galaxy
		fire_delay = 15
		homing = FALSE
		return
	if(!homing)
		to_chat(user,"<span class='warning'>You channel your energy, enabling homing.</span>")
		fire_delay = 20
		ammo_type = /obj/item/ammo_casing/caseless/ego_galaxy/homing
		homing = TRUE
		return

/obj/item/gun/ego_gun/unrequited
	name = "unrequited love"
	desc = "This weapon yearns for affection and will do anything to get your attention. Of course it will misunderstand your care for something else."
	icon_state = "unrequited"
	inhand_icon_state = "unrequited"
	special = "This weapon will sometimes jam. \
			Use this weapon in hand to unjam it. \
			this weapon fires faster and in a bigger burst for 15 seconds after being unjammed."
	ammo_type = /obj/item/ammo_casing/caseless/ego_unrequited
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

/obj/item/gun/ego_gun/unrequited/Initialize()
	. = ..()
	jam_cooldown_time = rand(1, 5) MINUTES
	jam_cooldown = jam_cooldown_time + world.time
	START_PROCESSING(SSobj, src)

/obj/item/gun/ego_gun/unrequited/process()
	if(jammed)
		return
	if(jam_cooldown < world.time)
		jammed = TRUE

/obj/item/gun/ego_gun/unrequited/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/ego_gun/unrequited/proc/ResetDelay()
	fire_delay = 3
	burst_size = 3

/obj/item/gun/ego_gun/unrequited/SpecialEgoCheck(mob/living/carbon/human/H)
	if(!jammed)
		return TRUE

	if(jam_noticed)
		playsound(src, dry_fire_sound, 30, TRUE)
	else
		playsound(src, 'sound/weapons/gun/general/bolt_drop.ogg', 50, TRUE)
		jam_noticed = TRUE

	to_chat(H, "<span class='notice'>[src] is jammed!</span>")
	return FALSE

/obj/item/gun/ego_gun/unrequited/attack_self(mob/user)
	to_chat(user,"<span class='notice'>You try to unjam [src].</span>")
	playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
	if(do_after(user, 3 SECONDS, src)) //it's a massive annoyance to unjam in the middle of a fight but the extra damage should make it more than worth it.
		playsound(src, 'sound/weapons/gun/general/bolt_rack.ogg', 50, TRUE)
		if(!jammed)
			to_chat(user,"<span class='notice'>Turns out the weapon is working just fine.</span>")
			return
		jammed = FALSE
		jam_noticed = FALSE
		fire_delay = 2
		burst_size = 5
		addtimer(CALLBACK(src, PROC_REF(ResetDelay)), 15 SECONDS)
		to_chat(user,"<span class='notice'>You succesfully unjammed [src]!</span>")
		jam_cooldown_time = rand(1, 5) MINUTES
		jam_cooldown = jam_cooldown_time + world.time

/obj/item/gun/ego_gun/harmony
	name = "harmony"
	desc = "A massive blocky launcher with some suspicious stains on it."
	icon_state = "harmony"
	inhand_icon_state = "harmony"
	special = "This weapon fires bouncing, piercing shots."
	ammo_type = /obj/item/ammo_casing/caseless/ego_harmony
	fire_sound = 'sound/weapons/ego/harmony1.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	autofire = 0.35 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/transmission
	name = "broken transmission"
	desc = "It's an old wooden longrifle."
	icon_state = "transmission"
	inhand_icon_state = "transmission"
	ammo_type = /obj/item/ammo_casing/caseless/ego_transmission
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/song
	name = "song of the past"
	desc = "Nothing beats the classics."
	icon_state = "song"
	inhand_icon_state = "song"
	ammo_type = /obj/item/ammo_casing/caseless/ego_song
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	weapon_weight = WEAPON_HEAVY
	spread = 8
	autofire = 0.15 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/pistol/songmini
	name = "greatest oldies"
	desc = "The past is far behind us."
	icon_state = "songmini"
	inhand_icon_state = "songmini"
	special = "This weapon fires 3 pellets."
	ammo_type = /obj/item/ammo_casing/caseless/ego_songmini
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	spread = 8
	autofire = 0.3 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/wedge
	name = "screaming wedge"
	desc = "Hair has grown on the crossbow as if to express that the woman’s dejection will never be forgotten."
	icon_state = "screamingwedge"
	inhand_icon_state = "screamingwedge"
	ammo_type = /obj/item/ammo_casing/caseless/ego_wedge
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10

	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/pistol/swindle
	name = "swindle"
	desc = "Good for man and beast, it gives immediate relief. Snake oil is good for everything a liniment ought to be for!"
	icon = 'icons/obj/guns/projectile.dmi'//put some non-E.G.O sprites to use
	icon_state = "goldrevolver"
	inhand_icon_state = "deagleg"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	special = "This weapon fires dice that deal varying amounts of damage."
	ammo_type = /obj/item/ammo_casing/caseless/ego_swindle
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/ringing
	name = "ringing"
	desc = "Voices from your past emanate from this gun. Now they can be put into use."
	icon_state = "ringing"
	inhand_icon_state = "ringing"
	special = "This weapon can be used as a megaphone."
	ammo_type = /obj/item/ammo_casing/caseless/ego_ringing
	weapon_weight = WEAPON_HEAVY
	autofire = 0.15 SECONDS
	spread = 25
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/spamcheck = 0
	var/list/voicespan = list(SPAN_COMMAND)

/obj/item/gun/ego_gun/ringing/equipped(mob/M, slot)//megaphone code
	. = ..()
	if (slot == ITEM_SLOT_HANDS && !HAS_TRAIT(M, TRAIT_SIGN_LANG))
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/gun/ego_gun/ringing/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/gun/ego_gun/ringing/proc/handle_speech(mob/living/carbon/user, list/speech_args)
	if (user.get_active_held_item() == src)
		if(spamcheck > world.time)
			to_chat(user, "<span class='warning'>\The [src] needs to recharge!</span>")
		else
			playsound(loc, 'sound/items/megaphone.ogg', 100, FALSE, TRUE)
			spamcheck = world.time + 50
			speech_args[SPEECH_SPANS] |= voicespan

/obj/item/gun/ego_gun/syrinx
	name = "syrinx"
	desc = "What cry could be more powerful than one spurred by primal instinct?"
	icon_state = "syrinx"
	inhand_icon_state = "syrinx"
	special = "This weapon fires slow bullets with limited range."
	ammo_type = /obj/item/ammo_casing/caseless/ego_syrinx
	weapon_weight = WEAPON_HEAVY
	spread = 40
	fire_sound = 'sound/weapons/ego/ecstasy.ogg'
	autofire = 0.08 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
	)

