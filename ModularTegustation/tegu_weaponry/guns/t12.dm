/obj/item/gun/ballistic/automatic/t12
	name = "T-12"
	desc = "A standard assault rifle used by TerraGov military."
	icon = 'ModularTegustation/Teguicons/48x32_guns.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/teguitems_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguitems_hold_right.dmi'
	icon_state = "t12"
	inhand_icon_state = "t12"
	fire_sound = "gun_t12"
	base_pixel_x = -8
	burst_size = 1
	force = 14
	actions_types = list()
	mag_display = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/t12

/obj/item/gun/ballistic/automatic/t12/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.18 SECONDS)

//MAGS
/obj/item/ammo_box/magazine/t12
	name = "T12 Magazine (10x24mm)"
	icon = 'ModularTegustation/Teguicons/magazines.dmi'
	icon_state = "t12_mag_item"
	ammo_type = /obj/item/ammo_casing/ballistic/a10_24
	caliber = "10x24mm"
	max_ammo = 50

/obj/item/ammo_casing/ballistic/a10_24
	name = "10x24mm bullet casing"
	desc = "A 10x24mm bullet casing."
	caliber = "10x24mm"
	variance = 2
	projectile_type = /obj/projectile/bullet/a10_24

/obj/projectile/bullet/a10_24
	name = "10x24mm bullet"
	damage = 24
