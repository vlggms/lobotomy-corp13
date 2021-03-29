/obj/item/clothing/mask/gas/mad_clown
	name = "clown's protective mask"
	desc = "Just looking at it fills you with madness."
	clothing_flags = MASKINTERNALS
	icon = 'ModularTegustation/Teguicons/mask_item.dmi'
	worn_icon = 'ModularTegustation/Teguicons/mask_worn.dmi'
	icon_state = "mad_clown"
	armor = list(MELEE = 15, BULLET = 5, LASER = 5,ENERGY = 15, BOMB = 5, BIO = 50, RAD = 0, FIRE = 30, ACID = 10)
	slowdown = -0.25
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/gas/mad_clown/equipped(mob/living/user, slot)
	. = ..()
	if(ishuman(user) && slot == ITEM_SLOT_MASK)
		ADD_TRAIT(src, TRAIT_NODROP, "mad-mask")
		user.mad_shaking = 1

/obj/item/clothing/mask/gas/mad_clown/dropped(mob/living/user)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_NODROP, "mad-mask")
	user.mad_shaking = 0
