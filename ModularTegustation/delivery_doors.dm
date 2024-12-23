// Doors for parcels to be delivered to. Simulated mailman.
// A good way to get money without combat.
/obj/structure/delivery_door
	name = "locked door"
	desc = "A doorway to somewhere your not allowed to be."
	icon = 'icons/obj/doors/airlocks/highsec/highsec.dmi'
	icon_state = "closed"
	anchored = TRUE
	layer = CLOSED_DOOR_LAYER
	var/address = "000"
	var/list/item_order = list()

/obj/structure/delivery_door/Initialize()
	. = ..()
	address = "[x]-[y]"
	name += " ([address])"

/obj/structure/delivery_door/attackby(obj/item/I, mob/user)
	var/ordered_item = locate(I) in item_order
	if(ordered_item)
		Reward(user, I, item_order[ordered_item])
		item_order -= ordered_item
		return
	if(istype(I, /obj/item/delivery_parcel))
		// Deliver the item.
		var/obj/item/delivery_parcel/D = I
		if(D.address == address)
			Reward(user, D, 150 + rand(-1,20))
		return
	return ..()

// Create parcel to be delivered.
/obj/structure/delivery_door/proc/OrderParcel(origin)
	if(!isturf(origin) && !isatom(origin))
		return FALSE
	var/obj/item/delivery_parcel/D = new (get_turf(origin))
	D.labelParcel(address)
	return TRUE

// Order items that are not safety sealed.
/obj/structure/delivery_door/proc/OrderItems(origin, obj/item/T = /obj/item/food/pizza/margherita, delivery_payment = 30)
	if(!isturf(origin) && !isatom(origin))
		return FALSE
	item_order += T
	item_order[T] = delivery_payment
	var/obj/item/paper/P = new (get_turf(origin))
	P.setText("<br><br><center><b>[address] orders a [initial(T.name)] for [delivery_payment] Ahn.</b></center>")
	return TRUE

// Pay the pizzaman
/obj/structure/delivery_door/proc/Reward(mob/living/user, obj/item/delivery, amt)
	var/obj/item/holochip/H = new (get_turf(user), amt)
	user.put_in_hands(H)
	to_chat(user, span_notice("The parcel is taken and payment is quickly tossed into your hand before the door locks again."))
	qdel(delivery)
	playsound(get_turf(src), 'sound/effects/bin_close.ogg', 35, 3, 3)

// Delivery Object
/obj/item/delivery_parcel
	name = "delivery parcel"
	desc = "A large delivery parcel that has a J corp lock on it."
	icon = 'icons/obj/tank.dmi'
	icon_state = "plasmaman_tank"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	worn_icon = 'icons/mob/clothing/back.dmi'
	var/address = "000"

/obj/item/delivery_parcel/proc/labelParcel(num)
	address = num
	name += " ([address])"

/*
* TRACKER
*/

/obj/item/pinpointer/coordinate
	name = "coordinate pinpointer"
	desc = "Use in hand to set target cordnates."
	icon_state = "pinpointer_syndicate"
	custom_price = PAYCHECK_MEDIUM * 4
	custom_premium_price = PAYCHECK_MEDIUM * 6
	var/coords

/obj/item/pinpointer/coordinate/examine(mob/user)
	. = ..()
	if(!active || !target)
		return
	if(coords)
		. += coords

/obj/item/pinpointer/coordinate/attack_self(mob/living/user)
	if(active)
		toggle_on()
		user.visible_message(span_notice("[user] deactivates [user.p_their()] pinpointer."), span_notice("You deactivate your pinpointer."))
		return

	var/target_x = input(user, "x coordinate", "Pinpoint") as null|num
	var/target_y = input(user, "y coordinate", "Pinpoint") as null|num
	if(!target_x || !target_y || QDELETED(src) || !user || !user.is_holding(src) || user.incapacitated())
		return

	target = locate(target_x, target_y, user.z)
	coords = "X:[target_x]|Y:[target_y]"
	toggle_on()
	user.visible_message(span_notice("[user] activates [user.p_their()] pinpointer."), span_notice("You activate your pinpointer."))
