// Currently only stores the Claw Armor only intended for admin use.

/obj/item/clothing/suit/armor/ego_gear/adjustable/claw
	name = "claw armor"
	desc = "A simple suit and tie with several injectors attached. The fabric is near indestructable."
	icon_state = "claw"
	icon = 'icons/obj/clothing/ego_gear/lc13_armor.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/lc13_armor.dmi'
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 100, BLACK_DAMAGE = 90, PALE_DAMAGE = 90) // The arbiter's henchman
	equip_slowdown = 0 // In accordance of arbiter armor
	hat = /obj/item/clothing/head/ego_hat/claw_head
	alternative_styles = list("claw", "claw_baral")

/obj/item/clothing/head/ego_hat/claw_head
	name = "mask of the claw"
	desc = "A faceless mask with an injector stuck on top of it."
	icon_state = "claw"
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
