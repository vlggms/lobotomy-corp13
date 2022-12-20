/obj/item/gun/ego_gun/match
	name = "fourth match flame"
	desc = "The light of the match will not go out until it has burned away happiness, warmth, light, \
	and all the other good things of the world; there's no need to worry about it being quenched."
	icon_state = "match"
	inhand_icon_state = "match"
	special = "This weapon does AOE damage."
	ammo_type = /obj/item/ammo_casing/caseless/ego_match
	weapon_weight = WEAPON_HEAVY
	fire_delay = 20
	fire_sound = 'sound/weapons/ego/cannon.ogg'

/obj/item/gun/ego_gun/beak
	name = "beak"
	desc = "As if to prove that size doesn't matter when it comes to force, \
	the weapon has high firepower despite its small size."
	icon_state = "beak"
	inhand_icon_state = "beak"
	special = "This weapon fires 400 rounds per minute."
	ammo_type = /obj/item/ammo_casing/caseless/ego_beak
	weapon_weight = WEAPON_HEAVY
	spread = 8
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.15 SECONDS

/obj/item/gun/ego_gun/pistol/beakmagnum
	name = "beak mk2"
	desc = "A heavy revolver that fires at a surprisingly fast rate, and is deadly accurate."
	icon_state = "beakmagnum"
	inhand_icon_state = "beak"
	special = "This weapon has pinpoint accuracy when duel wielded."
	ammo_type = /obj/item/ammo_casing/caseless/ego_beakmagnum
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	dual_wield_spread = 0

/obj/item/gun/ego_gun/noise
	name = "noise"
	desc = "The noises take you back to the very moment of the day that everyone had forgotten."
	icon_state = "noise"
	inhand_icon_state = "noise"
	special = "This weapon fires 5 pellets."
	ammo_type = /obj/item/ammo_casing/caseless/ego_noise
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

/obj/item/gun/ego_gun/pistol/solitude
	name = "solitude"
	desc = "A classic blue revolver, that gives you feelings of loneliness."
	icon_state = "solitude"
	inhand_icon_state = "solitude"
	ammo_type = /obj/item/ammo_casing/caseless/ego_solitude
	fire_delay = 15
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/gun/ego_gun/pistol/shy
	name = "todays expression"
	desc = "Many different expressions are padded on the equipment like patches. \
	When throbbing emotions surge up from time to time, it's best to simply cover the face."
	icon_state = "shy"
	inhand_icon_state = "shy"
	special = "This weapon has autofire"
	ammo_type = /obj/item/ammo_casing/caseless/ego_shy
	fire_sound = 'sound/effects/meatslap.ogg'
	vary_fire_sound = FALSE
	autofire = 0.2 SECONDS

/obj/item/gun/ego_gun/dream
	name = "engulfing dream"
	desc = "And when the crying stops, dawn will break."
	icon_state = "dream"
	inhand_icon_state = "dream"
	special = "This weapon has autofire."
	ammo_type = /obj/item/ammo_casing/caseless/ego_dream
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	autofire = 0.22 SECONDS

