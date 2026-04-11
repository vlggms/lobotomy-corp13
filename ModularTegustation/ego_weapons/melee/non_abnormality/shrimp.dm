// All of these are usably by clerks
/obj/item/ego_weapon/ranged/rambominigun
	name = "Shrimp Rambo's Minigun"
	desc = "A gun used by THE shrimp rambo."
	icon_state = "sodaminigun"
	inhand_icon_state = "sodaminigun"
	force = 52
	attack_speed = 1.7
	projectile_path = /obj/projectile/ego_bullet/soda_mini
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
