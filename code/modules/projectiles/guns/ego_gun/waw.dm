/obj/item/gun/ego_gun/correctional
	name = "correctional"
	desc = "In here, you're with us. Forever."
	icon_state = "correctional"
	inhand_icon_state = "correctional"
	ammo_type = /obj/item/ammo_casing/caseless/ego_correctional
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	recoil = 3		//Shakes your screen
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'


	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/gun/ego_gun/hornet
	name = "hornet"
	desc = "The kingdom needed to stay prosperous, and more bees were required for that task. \
	The projectiles relive the legacy of the kingdom as they travel toward the target."
	icon_state = "hornet"
	inhand_icon_state = "hornet"
	ammo_type = /obj/item/ammo_casing/caseless/ego_hornet
	weapon_weight = WEAPON_HEAVY
	fire_delay = 0
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'


	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60
							)
