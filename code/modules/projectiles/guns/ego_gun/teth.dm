/obj/item/gun/ego_gun/match
	name = "fourth match flame"
	desc = "The light of the match will not go out until it has burned away happiness, warmth, light, \
	and all the other good things of the world; there's no need to worry about it being quenched."
	icon_state = "match"
	inhand_icon_state = "match"
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
	ammo_type = /obj/item/ammo_casing/caseless/ego_beak
	weapon_weight = WEAPON_HEAVY
	spread = 8
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/item/gun/ego_gun/beak/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.15 SECONDS)

/obj/item/gun/ego_gun/noise
	name = "noise"
	desc = "The noises take you back to the very moment of the day that everyone had forgotten."
	icon_state = "noise"
	inhand_icon_state = "noise"
	ammo_type = /obj/item/ammo_casing/caseless/ego_noise
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	recoil = 1		//Shakes your screen
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

/obj/item/gun/ego_gun/solitude
	name = "solitude"
	desc = "A pistol painted in a refreshing purple. Whenever this EGO is used, a faint scent of grapes wafts through the air."
	icon_state = "solitude"
	inhand_icon_state = "solitude"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/caseless/ego_solitude
	fire_delay = 15
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
