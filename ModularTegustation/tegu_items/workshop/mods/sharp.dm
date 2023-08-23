//These are rare, but they all heal you
/obj/item/workshop_mod/sharp
	icon_state = "sharpcore"
	specialmod = "sharp"
	overlay = "sharp"

/obj/item/workshop_mod/sharp/red
	name = "sharp red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "keen"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/sharp/white
	name = "sharp white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "honed"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE


/obj/item/workshop_mod/sharp/black
	name = "sharp black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "fine"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/sharp/pale
	name = "sharp pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "piercing"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
