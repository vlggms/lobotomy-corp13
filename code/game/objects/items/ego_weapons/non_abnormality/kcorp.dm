/obj/item/ego_weapon/city/kcorp
	name = "K corp baton"
	desc = "A green baton used by K corp employees."
	icon_state = "kbatong"
	inhand_icon_state = "kbatong"
	force = 22
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

//Slows you to half but has really good defenses
/obj/item/ego_weapon/shield/kcorp
	name = "K corp riot shield"
	desc = "A riot shield used by K corp employees."
	special = "Slows down the user significantly."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "kshield"
	inhand_icon_state = "flashshield"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 15
	slowdown = 0.3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(60, 60, 60, 20)
	recovery_time = 5 SECONDS
	block_time = 2 SECONDS
	block_recovery = 2 SECONDS
	item_flags = SLOWS_WHILE_IN_HAND
