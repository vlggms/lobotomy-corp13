// All of these are usably by clerks

/obj/item/ego_weapon/ranged/shrimp/minigun
	name = "soda minigun"
	desc = "A gun used by shrimp corp, apparently."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaminigun"
	inhand_icon_state = "sodaminigun"
	force = 15
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/ego_soda
	weapon_weight = WEAPON_HEAVY
	drag_slowdown = 3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	slowdown = 2
	spread = 40
	item_flags = SLOWS_WHILE_IN_HAND
	projectile_damage_multiplier = 0.60
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.04 SECONDS

/obj/item/ego_weapon/ranged/shrimp/assault
	name = "soda assault rifle"
	desc = "A gun used by shrimp corp, apparently."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaassault"
	inhand_icon_state = "sodaassault"
	force = 5
	projectile_path = /obj/projectile/ego_bullet/ego_soda
	weapon_weight = WEAPON_HEAVY
	burst_size = 3
	fire_delay = 5
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'

/obj/item/ego_weapon/ranged/shrimp/rambominigun
	name = "Shrimp Rambo's Minigun"
	desc = "A gun used by THE shrimp rambo."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "sodaminigun"
	inhand_icon_state = "sodaminigun"
	force = 52
	attack_speed = 1.7
	projectile_path = /obj/projectile/ego_bullet/ego_soda
	weapon_weight = WEAPON_HEAVY
	drag_slowdown = 2
	slowdown = 1.5
	item_flags = SLOWS_WHILE_IN_HAND
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.01 SECONDS
	projectile_damage_multiplier = 1.26
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)
