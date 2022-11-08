/obj/item/gun/ego_gun/prank
	name = "funny prank"
	desc = "The small accessory remains like the wishes of a child who yearned for happiness."
	icon_state = "prank"
	inhand_icon_state = "prank"
	special = "This weapon fires as fast as you pull the trigger."
	ammo_type = /obj/item/ammo_casing/caseless/ego_prank
	weapon_weight = WEAPON_HEAVY
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/pistol/gaze
	name = "gaze"
	desc = "A magnum pistol featuring excellent burst firing potential."
	icon_state = "gaze"
	inhand_icon_state = "executive"
	special = "This weapon requires 2 hands."
	ammo_type = /obj/item/ammo_casing/caseless/ego_gaze
	fire_delay = 15
	fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70

/obj/item/gun/ego_gun/galaxy
	name = "galaxy"
	desc = "A shimmering wand."
	icon_state = "galaxy"
	special = "Use in hand to turn on homing mode. This mode homes in on a random target within 15 metres.	\
			WARNING: This feature is not accurate."
	ammo_type =	/obj/item/ammo_casing/caseless/ego_galaxy
	fire_delay = 11
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
		homing = FALSE
		return
	if(!homing)
		to_chat(user,"<span class='warning'>You channel your energy, enabling homing.</span>")
		ammo_type = /obj/item/ammo_casing/caseless/ego_galaxy/homing
		homing = TRUE
		return

/obj/item/gun/ego_gun/unrequited
	name = "unrequited love"
	desc = "A big, boxy rifle, imprinted with a heart on the back.."
	icon_state = "unrequited"
	inhand_icon_state = "unrequited"
	special = "This weapon requires 2 hands."
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

/obj/item/gun/ego_gun/harmony
	name = "harmony"
	desc = "A massive blocky launcher with some suspicious stains on it."
	icon_state = "harmony"
	ammo_type = /obj/item/ammo_casing/caseless/ego_harmony
	fire_delay = 8
	fire_sound = 'sound/weapons/ego/harmony1.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)
