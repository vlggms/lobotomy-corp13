//These all heal sanity instead
/obj/item/workshop_mod/sapping
	icon_state = "sapcore"
	specialmod = "sanity healing"
	overlay = "sapping"

/obj/item/workshop_mod/sapping/red
	name = "sapping red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "releaving"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/sapping/white
	name = "sapping white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "mindeating"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE


/obj/item/workshop_mod/sapping/black
	name = "sapping black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "enjoyable"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/sapping/pale
	name = "sapping pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "soothing"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
