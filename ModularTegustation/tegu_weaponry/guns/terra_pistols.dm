/obj/item/gun/ballistic/automatic/pistol/terragov
	name = "Makarov PM"
	desc = "A modern reproduction of the ancient 9mm handgun. Has a threaded barrel for suppressors."
	icon = 'ModularTegustation/TeguIcons/tegu_guns.dmi'
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	rack_sound = 'sound/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/slide_drop.ogg'

/obj/item/gun/ballistic/automatic/pistol/terragov/beretta
	name = "Beretta M9"
	desc = "An Italian 9mm handgun. For use against pineapple-on-pizza lovers."
	fire_sound = 'ModularTegustation/Tegusounds/weapons/guns/pistol.ogg'
	icon_state = "beretta"
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/terragov/sig
	name = "SIG Sauer"
	desc = "A classic handgun with a larger than average magazine capacity."
	fire_sound = 'ModularTegustation/Tegusounds/weapons/guns/pistol_large.ogg'
	spread = 15
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "sig"
	mag_type = /obj/item/ammo_box/magazine/m9mm_aps/sig
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/terragov/ppk
	name = "Type 64"
	desc = "The classic Chinese handgun. Chambered in .38."
	fire_sound = 'ModularTegustation/Tegusounds/weapons/guns/type64.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "ppk"
	mag_type = /obj/item/ammo_box/magazine/m38
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/terragov/glock
	name = "Glock 17"
	desc = "The well known austrian pistol. Commonly used by law enforcement."
	icon_state = "glock"
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/terragov/glock/fullauto
	name = "Glock 18"
	desc = "The well known austrian pistol. This one is fully automatic, and may break your hand."
	burst_size = 1
	spread = 30
	fire_delay = 0.5

/obj/item/gun/ballistic/automatic/pistol/terragov/glock/fullauto/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.1 SECONDS)

// Magazines
/obj/item/ammo_box/magazine/m9mm_aps/sig
	name = "SIG Sauer pistol magazine (9mm)"

/obj/item/ammo_box/magazine/m38
	name = "pistol magazine (.38)"
	ammo_type = /obj/item/ammo_casing/c38
	icon_state = "9x19p"
	caliber = CALIBER_38
	max_ammo = 6

/obj/item/gun/ballistic/automatic/proto/terragov
	name = "\improper SABR SMG"
	desc = "A three-round burst 9mm submachine gun. Used by CityGov military personnel. Has a threaded barrel for suppressors."
	w_class = WEIGHT_CLASS_NORMAL
	pin = /obj/item/firing_pin
