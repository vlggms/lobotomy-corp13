//EO Lock -- Making it a subtype saves on copypaste
/obj/item/extraction/key/lock
	name = "Qliphoth Locking Mechanism"
	desc = "Use on a work console to raise the qliphoth suppression field of the abnormality cell, slowing down work."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "lock"
	passed_variable = EXTRACTION_LOCK
	howtouse = "This tool can only be used on a containment cell that has reached 100% understanding. This does NOT affect Qliphoth Counter."
	itemname = "Lock"

/obj/item/extraction/lock/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice("This tool seems to be upgraded, increases work chance.")

/obj/item/extraction/key/lock/update_icon()
	if(!archived_console)
		icon_state = "lock"
		return
	icon_state = "lock_active"
