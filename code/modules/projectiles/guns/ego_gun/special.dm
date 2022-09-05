/obj/item/gun/ego_gun/sodarifle
	name = "soda rifle"
	desc = "A gun used by shrimp corp, apparently."
	icon_state = "sodarifle"
	inhand_icon_state = "sodalong"
	ammo_type = /obj/item/ammo_casing/caseless/ego_shrimprifle
	weapon_weight = WEAPON_HEAVY
	fire_delay = 3
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'

/obj/item/gun/ego_gun/sodashotty
	name = "soda shotgun"
	desc = "A gun used by shrimp corp, apparently."
	icon_state = "sodashotgun"
	inhand_icon_state = "sodalong"
	ammo_type = /obj/item/ammo_casing/caseless/ego_shrimpshotgun
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

/obj/item/gun/ego_gun/sodasmg
	name = "soda submachinegun"
	desc = "A gun used by shrimp corp, apparently."
	icon_state = "sodasmg"
	inhand_icon_state = "soda"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	weapon_weight = WEAPON_HEAVY
	spread = 8
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/item/gun/ego_gun/sodasmg/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.15 SECONDS)
