//These are rare, but they all heal you
/obj/item/workshop_mod/healing
	icon_state = "healcore"
	specialmod = "health healing"
	overlay = "healing"

/obj/item/workshop_mod/healing/red
	name = "healing red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "bloodeating"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/healing/white
	name = "healing white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "sapping"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE


/obj/item/workshop_mod/healing/black
	name = "healing black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "devouring"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/healing/pale
	name = "healing pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "draining"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
