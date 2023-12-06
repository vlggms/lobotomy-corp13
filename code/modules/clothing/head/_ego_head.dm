// EGO hat type, attached to whatever armor that manifests it.
/obj/item/clothing/head/ego_hat
	name = "ego hat"
	desc = "an ego hat that you shouldn't be seeing!"
	icon = 'icons/obj/clothing/ego_gear/head.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/head.dmi'
	icon_state = ""
	flags_inv = HIDEMASK
	var/perma = FALSE // So we can stack all LC13 related hats under the same obj path

/obj/item/clothing/head/ego_hat/Destroy()
	if(perma)
		return ..()
	dropped()
	return ..()

/obj/item/clothing/head/ego_hat/equipped(mob/user, slot)
	if(perma)
		return ..()
	if(slot != ITEM_SLOT_HEAD)
		Destroy()
		return
	. = ..()

/obj/item/clothing/head/ego_hat/helmet // Subtype to cover the entire head
	flags_inv = HIDEHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
