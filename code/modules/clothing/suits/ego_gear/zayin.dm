/obj/item/clothing/suit/armor/ego_gear/penitence
	name = "penitence"
	desc = "A piece of EGO armor intended to protect its user from mental decay. This suit will be no better than rags to those who have no sense of guilt."
	icon_state = "penitence"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 20, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tough
	name = "tough jacket"
	desc = "A leather jacket with an unusually luxurious figure. Only those who maintain a clean “hairstyle” with no impurities on their head will be deemed worthy of equipping this suit."
	icon_state = "tough"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 20, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tough/special_ego_check(mob/living/carbon/human/H)
	if(H.hairstyle in list("Bald", "Shaved"))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with clean hairstyle can use [src]!</span>")
	return FALSE
