//These are rare, but they all heal you
/obj/item/workshop_mod/curing
	icon_state = "curecore"
	specialmod = "curing"
	overlay = "curing"

/obj/item/workshop_mod/curing/red
	name = "curing red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "triage"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/curing/white
	name = "curing white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "recovering"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE

/obj/item/workshop_mod/curing/black
	name = "curing black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "mending"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE

/obj/item/workshop_mod/curing/pale
	name = "curing pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "convalescent"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
