/// Safety department healing items for health, sanity, etc are covered here.
/// Injectors, bandages, and pills are the types of healing items.
/// These items take advantage of legacy code to make our own items.

// Custom medipens that delete themselves - Our janitorial staff are lazy.

/obj/item/reagent_containers/hypospray/medipen/safety
	name = "debug item"
	desc = "You shouldn't be seeing this, make a bug report."
	list_reagents = list()
	var/special

/obj/item/reagent_containers/hypospray/medipen/safety/examine(mob/user)
	. = ..()
	if(special)
		. += span_notice("[special]")

/obj/item/reagent_containers/hypospray/medipen/safety/inject(mob/living/M, mob/user)
	..()
	qdel(src)

// Bandages heal much more quickly, but have a delay. Pretty much copied off medical stacks, we just don't want to care about limbs.

/obj/item/safety_bandage
	name = "debug bandage"
	icon = 'icons/obj/stack_medical.dmi'
	icon_state = "poultice"
	desc = "A debug item. Report this to a coder."
	var/special = "Healing description goes here."
	/// How long it takes to apply it to yourself
	var/self_delay = 5 SECONDS
	/// How long it takes to apply it to someone else
	var/other_delay = 1.5 SECONDS
	var/charges = 5
	var/list/list_reagents = null
	var/requires_hurt = TRUE
	var/use_sound = 'sound/effects/rustle4.ogg'

/obj/item/safety_bandage/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	update_icon()

/obj/item/safety_bandage/examine(mob/user)
	. = ..()
	if(special)
		. += span_notice("[special]")
	if(charges)
		. += span_notice("It has [charges] uses left.")

/obj/item/safety_bandage/attack(mob/living/M, mob/user)
	if(try_heal(M, user))
		return
	. = ..()

/// In which we print the message that we're starting to heal someone, then we try healing them. Does the do_after whether or not it can actually succeed on a targeted mob
/obj/item/safety_bandage/proc/try_heal(mob/living/patient, mob/user)
	if(!patient.can_inject(user, TRUE))
		return FALSE
	if(patient == user)
		user.visible_message("<span class='notice'>[user] starts to apply [src] on [user.p_them()]self...</span>", "<span class='notice'>You begin applying [src] on yourself...</span>")
		if(!do_mob(user, patient, self_delay, extra_checks=CALLBACK(patient, TYPE_PROC_REF(/mob/living, can_inject), user, TRUE)))
			return FALSE
	else if(other_delay)
		user.visible_message("<span class='notice'>[user] starts to apply [src] on [patient].</span>", "<span class='notice'>You begin applying [src] on [patient]...</span>")
		if(!do_mob(user, patient, other_delay, extra_checks=CALLBACK(patient, TYPE_PROC_REF(/mob/living, can_inject), user, TRUE)))
			return FALSE

	if(heal(patient, user))
		log_combat(user, patient, "healed", src.name)
		charges -= 1
		update_icon()
	if(!charges || charges < 0)
		qdel(src)
		to_chat(user, span_warning("Your [src] is all used up!"))
		return TRUE
	to_chat(user, span_notice("Your [src] loses a charge."))
	playsound(get_turf(user), use_sound, 50)
	return TRUE

/// Apply the actual effects of the healing if it's a simple animal, goes to [/obj/item/stack/medical/proc/heal_carbon] if it's a carbon, returns TRUE if it works, FALSE if it doesn't
/obj/item/safety_bandage/proc/heal(mob/living/patient, mob/user)
	if(patient.stat == DEAD)
		to_chat(user, "<span class='warning'>[patient] is dead! You can not help [patient.p_them()].</span>")
		return FALSE
	if(list_reagents)
		patient.reagents?.add_reagent_list(list_reagents)
	return TRUE

/obj/item/safety_bandage/update_icon_state()
	if(charges <= 1)
		icon_state = initial(icon_state)
	else if (charges <= 3)
		icon_state = "[initial(icon_state)]_2"
	else
		icon_state = "[initial(icon_state)]_3"
