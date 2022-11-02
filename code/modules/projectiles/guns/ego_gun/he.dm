/obj/item/gun/ego_gun/prank
	name = "funny prank"
	desc = "The small accessory remains like the wishes of a child who yearned for happiness."
	icon_state = "prank"
	inhand_icon_state = "prank"
	special = "This weapon does 20 black melee damage."
	ammo_type = /obj/item/ammo_casing/caseless/ego_prank
	weapon_weight = WEAPON_HEAVY
	force = 20
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	fire_delay = 3
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/gun/ego_gun/prank/EgoAttackInfo(mob/user)
	if(chambered && chambered.BB)
		return "<span class='notice'>Its bullets deal [chambered.BB.damage] [chambered.BB.damage_type] damage, and [force] [damtype] melee damage</span>"
	return

/obj/item/gun/ego_gun/pistol/gaze
	name = "gaze"
	desc = "A magnum pistol featuring excellent burst firing potential."
	icon_state = "gaze"
	inhand_icon_state = "executive"
	special = "This weapon requires 2 hands."
	ammo_type = /obj/item/ammo_casing/caseless/ego_gaze
	fire_delay = 15
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70

/obj/item/gun/ego_gun/galaxy
	name = "galaxy"
	desc = "A shimmering wand."
	icon_state = "galaxy"
	special = "This weapon homes in on a random target within 15 metres.	\
			WARNING: This feature is not accurate."
	ammo_type = /obj/item/ammo_casing/caseless/ego_galaxy
	fire_delay = 11
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
