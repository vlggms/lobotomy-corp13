/obj/item/ego_weapon/city/kcorp
	name = "K corp baton"
	desc = "A green baton used by K corp employees."
	icon_state = "kbatong"
	inhand_icon_state = "kbatong"
	force = 22
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

/obj/item/ego_weapon/city/kcorp/axe
	name = "K corp axe"
	desc = "A green axe used by K corp employees."
	icon_state = "kaxe"
	inhand_icon_state = "kaxe"
	force = 35
	attack_speed = 1.7
	attack_verb_continuous = list("bashes", "crushes", "cleaves")
	attack_verb_simple = list("bash", "crush", "cleave")

//High level Kcorp weapons are grade 5
/obj/item/ego_weapon/city/kcorp/spear
	name = "K corp spear"
	desc = "A green spear used by K corp Code 3 employees."
	icon_state = "kspear"
	inhand_icon_state = "kspear"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 44
	reach = 2
	attack_speed = 1.2
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/kcorp1.ogg'
	attack_verb_continuous = list("whacks", "slashes")
	attack_verb_simple = list("whack", "slash")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/kcorp/dspear
	name = "K corp blast spear"
	desc = "A double bladed spear used by K corp Code 3 employees."
	icon_state = "kdualspear"
	inhand_icon_state = "kdualspear"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 22
	reach = 2
	attack_speed = 0.6
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/kcorp1.ogg'
	attack_verb_continuous = list("whacks", "slashes")
	attack_verb_simple = list("whack", "slash")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//Slows you to half but has really good defenses. This is Kcorp Bread and butter, because it's really good
/obj/item/ego_weapon/shield/kcorp
	name = "K corp riot shield"
	desc = "A riot shield used by K corp employees."
	special = "Slows down the user significantly."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "kshield"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 15
	slowdown = 0.7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(50, 40, 40, 20) // 150, WAW?
	projectile_block_duration = 5 SECONDS
	block_cooldown = 4 SECONDS
	block_duration = 2 SECONDS
	item_flags = SLOWS_WHILE_IN_HAND

// Guns below
/obj/item/gun/ego_gun/pistol/kcorp
	name = "Kcorp pistol"
	desc = "A lime green pistol used by Kcorp."
	icon_state = "kpistol"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	inhand_icon_state = "kpistol"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	ammo_type = /obj/item/ammo_casing/caseless/ego_kcorp
	fire_delay = 5
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	fire_sound_volume = 70


// Guns below
/obj/item/gun/ego_gun/pistol/kcorp/smg
	name = "Kcorp Machinepistole"
	desc = "A lime green machinepistol used by Kcorp."
	icon_state = "ksmg"
	inhand_icon_state = "ksmg"
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.08 SECONDS
	fire_delay = 1
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)


/obj/item/gun/ego_gun/pistol/kcorp/nade
	name = "Kcorp grenade launcher"
	desc = "A short grenade launcher used by Kcorp."
	icon_state = "kgrenade"
	inhand_icon_state = "kgrenade"
	ammo_type = /obj/item/ammo_casing/caseless/ego_knade
	fire_delay = 15
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	fire_sound_volume = 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
