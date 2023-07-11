//These are rare, but they deal two damage types
/obj/item/workshop_mod/split
	icon_state = "splitcore"
	specialmod = "split damage"
	overlay = "split"

/obj/item/workshop_mod/split/redpale
	name = "split damage mod A"
	desc = "A workshop mod to turn a weapon into red/pale damage. Throwing weapons will deal the first damage type."
	modname = "yin"
	color = "#d49c3b"
	weaponcolor = "#d49c3b"
	damagetype = RED_DAMAGE
	forcemod = 0.7

/obj/item/workshop_mod/split/whiteblack
	name = "split damage mod B"
	desc = "A workshop mod to turn a weapon into white/black damage. Throwing weapons will deal the first damage type."
	modname = "yang"
	color = "#b1e6a1"
	weaponcolor = "#b1e6a1"
	damagetype = WHITE_DAMAGE
	forcemod = 0.7

