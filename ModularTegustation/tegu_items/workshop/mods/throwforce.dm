//These are throwforce upgrades
/obj/item/workshop_mod/throwforce
	icon_state = "throwcore"
	overlay = "throwing"
	throwforcemod = 1.4
	forcemod = 0.95

/obj/item/workshop_mod/throwforce/red
	name = "throwing red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "singing"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/throwforce/white
	name = "throwing white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "soaring"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE


/obj/item/workshop_mod/throwforce/black
	name = "throwing black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "gliding"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/throwforce/pale
	name = "throwing pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	throwforcemod = 0.8
	color = "#80c8ff"
	modname = "flying"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
