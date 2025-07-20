
//Peacekeeper Office Stuff
/obj/structure/peacemachine
	name = "peacekeeper's funds machine"
	desc = "A machine used by peacekeeper offices to be funded for their efforts."
	icon = 'icons/obj/money_machine.dmi'
	icon_state = "bogdanoff"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	var/list/allowed_players = list()
	var/printing_interval = 0.5
	var/printed_counter = 0
	var/list/rewards = list(
			/obj/item/tresmetal/steel,
			/obj/item/tresmetal/cobalt,
			/obj/item/tresmetal/copper,
			/obj/item/tresmetal/bloodiron,
			/obj/item/tresmetal/goldsteel,
			/obj/item/tresmetal/silversteel,
			/obj/item/tresmetal/electrum,
			/obj/item/tresmetal/darksteel)

/obj/structure/peacemachine/examine(mob/user)
	. = ..()
	. += span_notice("[src] currently has [printed_counter * 300] ahn resting inside of it.")

/obj/structure/peacemachine/attack_hand(mob/living/user)
	if(user in allowed_players)
		if(printed_counter > 0)
			say("Payment collected!")
			playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
			for(var/i = 1 to printed_counter)
				new /obj/item/stack/spacecash/c200(get_turf(src))
				new /obj/item/stack/spacecash/c100(get_turf(src))
			printed_counter = 0
		else
			say("There is no payment to be collected!")
			playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 35, 3, 3)
	else
		say("[user] is not registered to [src] to collect cash!")
		playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 35, 3, 3)

/obj/structure/peacemachine/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(add_cash)), printing_interval MINUTES)

/obj/structure/peacemachine/proc/add_cash()
	printed_counter++
	say("Peacekeeping payment, delivered!")
	playsound(get_turf(src), 'sound/machines/beep.ogg', 35, 3, 3)
	addtimer(CALLBACK(src, PROC_REF(add_cash)), printing_interval MINUTES)
	if(prob(5))
		var/I = pick(rewards)
		new I (get_turf(src))

/obj/item/peacemachine_connector
	name = "peacekeeper funds machine linker"
	desc = "A device that can give access to a connected peacekeeper's funds machine."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/obj/structure/peacemachine/linked_machine

/obj/item/peacemachine_connector/examine(mob/user)
	. = ..()
	if(linked_machine)
		. += span_notice("[src] is currently linked to [linked_machine].")

/obj/item/peacemachine_connector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(istype(target, /obj/structure/peacemachine))
		var/obj/structure/peacemachine/M = target
		linked_machine = M
		to_chat(user, span_notice("[M.name] has been linked to [src]."))
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(linked_machine)
			linked_machine.allowed_players += H
			to_chat(user, span_notice("[H.name] has been linked to [linked_machine.name]."))
		else
			to_chat(user, span_notice("[src] does not have a peacekeeper's funds machine linked up! Find one first!"))

//Recon Office Stuff
/obj/item/recon_upgrader
	name = "recon implanter"
	desc = "A device that can give fixers a 'recon' upgrade, which lets them have night vision at the cost of their attack speed."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "prox-radio0"
	var/max_uses = 5
	var/uses = 0

/obj/item/recon_upgrader/examine(mob/user)
	. = ..()
	. += span_notice("[src] currently has [uses] charges out of [max_uses] left.")

/obj/item/recon_upgrader/attack_self(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_TRUE_NIGHT_VISION))
			to_chat(user, span_notice("You have already have night vision"))
			playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 35, 3, 3)
		else
			ADD_TRAIT(H, TRAIT_WEAK_MELEE, "Recon Implanter")
			ADD_TRAIT(H, TRAIT_TRUE_NIGHT_VISION, "Recon Implanter")
			H.update_sight() //Nightvision trait wont matter without it
			playsound(get_turf(src), 'sound/machines/beep.ogg', 35, 3, 3)
			to_chat(user, span_nicegreen("You gain night vision, at the cost of your attack speed!"))
			uses++
		if(max_uses == uses)
			to_chat(user, span_warning("[src] fizzles away, as all of it's charges are used up!"))
			playsound(get_turf(src), 'sound/effects/wounds/sizzle1.ogg', 35, 3, 3)
			qdel(src)

//Delivery Office Stuff
/obj/structure/delivery_radio
	name = "delivery's office radio"
	desc = "A radio used by delivery offices to get their deliveries."
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/list/currently_delivering = list()
	var/payback_price = 600

/obj/structure/delivery_radio/attack_hand(mob/living/user)
	if(user in currently_delivering)
		say("[user], you are currently delivering a package. Please deliver the package first or pay the lost fee.")
		playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 35, 3, 3)
		return
	else
		OrderParcel(user)

/obj/structure/delivery_radio/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/user_cash = I
		if(user_cash && istype(user_cash))
			var/credits = user_cash.get_item_credit_value()
			var/amount = user_cash.spend(payback_price)
			if (amount > 0)
				currently_delivering -= user
				say("Lost payment received, [user] is removed from 'currently delivering' list.")
				playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
			else
				say("Not enough ahn to pay the payback price, you still need " + "[(payback_price - credits)] more ahn...")
				playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 35, 3, 3)

/obj/structure/delivery_radio/proc/OrderParcel(mob/living/deliveryman)
	var/door = pick(GLOB.delivery_doors)
	if(istype(door, /obj/structure/delivery_door))
		var/obj/structure/delivery_door/D = door
		var/mob/living/user = deliveryman
		D.OrderParcel(user.loc)
		say("Delivery package gathered, please send it to it's destination to receive payment.")
		user.playsound_local(get_turf(src), 'sound/effects/cashregister.ogg', 25, 3, 3)
		currently_delivering += user

		// Set up signal handling for parcel delivery
		RegisterSignal(D, COMSIG_PARCEL_DELIVERED, PROC_REF(ParcelDelivered))
		return TRUE
	return FALSE

/obj/structure/delivery_radio/proc/ParcelDelivered(door, mob/user)
	SIGNAL_HANDLER

	// Clear the parcel job flag for this user when delivered
	if(user in currently_delivering)
		currently_delivering -= user

	// Unregister the signal
	UnregisterSignal(door, COMSIG_PARCEL_DELIVERED)
