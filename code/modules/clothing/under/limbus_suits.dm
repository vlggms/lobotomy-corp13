//Limbus Company
/obj/item/clothing/under/limbus
	icon = 'icons/obj/clothing/ego_gear/lcuniform.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/under.dmi'
	can_adjust = FALSE //adjusting is mostly hardcoded. Im not messing with any of it.

/obj/item/clothing/under/limbus/shirt
	name = "LCB shirt"
	icon_state = "shirt"
	desc = "A fine cotton shirt and pants set that wouldn't look out of place in a nest."
	var/tucked = FALSE

/obj/item/clothing/under/limbus/shirt/attack_self(mob/user)
	if(!tucked)
		icon_state = "shirt_tucked"
		to_chat(user,"<span class='notice'>You tuck the shirt in.</span>")
		tucked = TRUE
	else
		icon_state = "shirt"
		to_chat(user,"<span class='notice'>You untuck the shirt.</span>")
		tucked = FALSE
	update_icon_state()
	return ..()

/obj/item/clothing/under/limbus/prison
	name = "LCB prison outfit"
	icon_state = "prison"
	desc = "For prisoners, but fancy."
