
/**
 *
 * Modular file containing: the fishing bag
 * you can pick up fish with it, wow
 *
 */

/obj/item/storage/bag/fish
	name = "fish bag"
	desc = "A weird plastic bag that can hold upto 100 fish or brass pebbles."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "bag"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	resistance_flags = FLAMMABLE
	var/spam_protection = FALSE //If this is TRUE, the holder won't receive any messages when they fail to pick up ore through crossing it
	var/mob/listeningTo

/obj/item/storage/bag/fish/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.allow_quick_empty = TRUE
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_combined_w_class = 1000
	STR.max_items = 100
	STR.set_holdable(list(
		/obj/item/food/fish,
		/obj/item/fishing_component/hook/bone,
		/obj/item/stack/fish_points,
	))

/obj/item/storage/bag/fish/equipped(mob/user)
	. = ..()
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(Pickup_fish))
	listeningTo = user

/obj/item/storage/bag/fish/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		listeningTo = null

/obj/item/storage/bag/fish/proc/Pickup_fish(mob/living/user)
	var/show_message = FALSE
	var/turf/tile = user.loc
	if (!isturf(tile))
		return
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		for(var/A in tile)
			if (!is_type_in_typecache(A, STR.can_hold))
				continue
			else if(SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, user, TRUE))
				show_message = TRUE
			else
				if(!spam_protection)
					to_chat(user, span_warning("Your [name] is full and can't hold any more!"))
					spam_protection = TRUE
					continue
	if(show_message)
		playsound(user, "rustle", 50, TRUE)
		user.visible_message(span_notice("[user] scoops up the fish beneath [user.p_them()]."), \
		span_notice("You scoop up the fish beneath you with your [name]."))
	spam_protection = FALSE
