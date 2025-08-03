/obj/item/clothing/suit/armor/ego_gear/city/thumb
	flags_inv = HIDEJUMPSUIT | HIDEGLOVES
	name = "thumb soldato armor"
	desc = "Armor worn by thumb grunts."
	icon_state = "thumb"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/thumb_capo
	name = "thumb capo armor"
	desc = "Armor worn by thumb capos."
	icon_state = "capo"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 30)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/city/thumb_sottocapo
	name = "thumb sottocapo armor"
	desc = "Armor worn by thumb sottocapos."
	icon_state = "sottocapo"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 50)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

////////////////////////////////////////////////////////////
// THUMB EAST ARMOR SECTION.
// This armor is slightly better because Thumb E don't get ranged weaponry or the ability to kite with 2 tile reach and no selfstun.
// Also, each armour's "rank" is bumped up 1 for Thumb E. So, Thumb E Soldato = Thumb S Capo in overall power and so on.
// I'm putting them all under one type in case that I want to add special interactions with this armour for the weapons later.
// I didn't see any guidelines for balancing City armour so I just based them off their equivalent Thumb S armour and bumped them up slightly. If that's not fine let me know.
/obj/item/clothing/suit/armor/ego_gear/city/thumb_east
	name = "thumb east soldato armor"
	desc = "Armor worn by thumb grunts in eastern parts of the City."
	icon = 'ModularTegustation/Teguicons/thumb_east_obj.dmi'
	worn_icon = 'ModularTegustation/Teguicons/thumb_east_worn.dmi'
	/// East Soldato armour sprites by Deadkung
	icon_state = "thumb_east_soldato"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 30) // 140 points.
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/city/thumb_east/capo
	name = "thumb east capo armor"
	desc = "Armor worn by thumb capos in eastern parts of the City. This one looks like it belongs to a particularly high rank Capo."
	/// East Capo armour sprites by Potassium_19
	icon_state = "thumb_east_capo"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 50) // 220 points.
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

// Woah, cosmetic hats
// They get melted if you vent the thumb east weapons with them on
/obj/item/clothing/head/thumb_east_hat
	name = "thumb east soldato hat"
	desc = "Looking snazzy is part of your duties as a Soldato."
	// Sprites by Deadkung
	icon = 'ModularTegustation/Teguicons/thumb_east_obj.dmi'
	worn_icon = 'ModularTegustation/Teguicons/thumb_east_worn.dmi'
	icon_state = "thumb_east_hat"

// Most of everything below this point is modified code copied from /obj/item/clothing/suit/armor/ego_gear/adjustable.
// I could also make an adjustable hat parent type, if there's demand in the codebase for it, I guess.
	var/list/alternative_styles = list("thumb_east_hat_shadowed")
	var/index = 1

/obj/item/clothing/head/thumb_east_hat/Initialize(mapload)
	. = ..()
	alternative_styles |= icon_state
	index = alternative_styles.len

/obj/item/clothing/head/thumb_east_hat/examine(mob/user)
	. = ..()
	. += span_notice("You can adjust it to obscure more of your face by right-clicking it.")

/obj/item/clothing/head/thumb_east_hat/verb/AdjustStyle()
	set name = "Adjust Hat Style"
	set category = null
	set src in usr
	Adjust()

/obj/item/clothing/head/thumb_east_hat/proc/Adjust()
	if(!ishuman(usr))
		return
	if(alternative_styles.len <= 1)
		to_chat(usr, span_notice("There's no other way to wear this hat!"))
		return
	index++
	if(index > alternative_styles.len)
		index = 1
	icon_state = alternative_styles[index]
	if(icon_state == initial(icon_state))
		to_chat(usr, span_notice("You adjust your hat to wear it normally once again."))
	else
		to_chat(usr, span_notice("You adjust your hat, lowering it to partially conceal your face."))
	var/mob/living/carbon/human/H = usr
	H.update_inv_head()
	H.update_body()

/obj/item/clothing/head/thumb_east_hat/capo
	name = "thumb east capo hat"
	desc = "Procuring these hats takes up a substantial part of your budget, since they seem to keep mysteriously melting off during combat. At least it looks nice."
	// Sprites by Deadkung
	icon = 'ModularTegustation/Teguicons/thumb_east_obj.dmi'
	worn_icon = 'ModularTegustation/Teguicons/thumb_east_worn.dmi'
	icon_state = "thumb_east_hat_capo"
	alternative_styles = list("thumb_east_hat_capo_shadowed")
