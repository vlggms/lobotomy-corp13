// All of these are usably by clerks

/obj/item/gun/ego_gun/shrimp/minigun
	name = "soda minigun"
	desc = "A gun used by shrimp corp, apparently."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaminigun"
	inhand_icon_state = "sodaminigun"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	weapon_weight = WEAPON_HEAVY
	drag_slowdown = 3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	slowdown = 2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	spread = 40
	item_flags = SLOWS_WHILE_IN_HAND
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.04 SECONDS

/obj/item/gun/ego_gun/shrimp/assault
	name = "soda assault rifle"
	desc = "A gun used by shrimp corp, apparently."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaassault"
	inhand_icon_state = "sodaassault"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	weapon_weight = WEAPON_HEAVY
	burst_size = 3
	fire_delay = 5
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'

/obj/item/gun/ego_gun/shrimp/rambominigun
	name = "Shrimp Rambo's Minigun"
	desc = "A gun used by THE shrimp rambo."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaminigun"
	inhand_icon_state = "sodaminigun"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	weapon_weight = WEAPON_HEAVY
	drag_slowdown = 2
	slowdown = 1.5
	item_flags = SLOWS_WHILE_IN_HAND
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.01 SECONDS
	projectile_damage_multiplier = 1.25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)
