// All of these are usably by clerks

/obj/item/gun/ego_gun/shrimp/minigun
	name = "soda minigun"
	desc = "A gun used by shrimp corp, apparently."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaminigun"
	inhand_icon_state = "sodalong"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	weapon_weight = WEAPON_HEAVY
	drag_slowdown = 3
	slowdown = 2
	spread = 40
	projectile_damage_multiplier = 0.25
	item_flags = SLOWS_WHILE_IN_HAND
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.04 SECONDS

/obj/item/gun/ego_gun/shrimp/assault
	name = "soda assault rifle"
	desc = "A gun used by shrimp corp, apparently."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaassault"
	inhand_icon_state = "sodalong"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	weapon_weight = WEAPON_HEAVY
	burst_size = 3
	fire_delay = 5
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
