/datum/hypo_upgrade
	var/name = "Hypo upgrade"
	var/desc = "This upgrade does nothing, kinda neat right?"
	var/stackable = FALSE

/datum/hypo_upgrade/proc/add_upgrade(obj/item/reagent_containers/hypospray/emais/H,atom/movable/A)
	H.upgrades += src
	return TRUE

/datum/hypo_upgrade/proc/upgrade_check(obj/item/reagent_containers/hypospray/emais/H)
	if(!istype(H))
		return FALSE
	if(!stackable && (src in H?.upgrades))
		to_chat(H,"<span class='warning'>This upgrade is already effective!</span>")
		return FALSE
	return TRUE

/datum/hypo_upgrade/proc/remove_upgrade(obj/item/reagent_containers/hypospray/emais/H,var/atom/movable/A)
	H.upgrades -= src
	return TRUE

/datum/hypo_upgrade/cap_increase
	name = "Capacity upgrade"
	desc = "Increase injector capacity"
	var/cap_multiplier = 2

/datum/hypo_upgrade/cap_increase/add_upgrade(obj/item/reagent_containers/hypospray/emais/H,atom/movable/A)
	if(!upgrade_check(H))
		return FALSE
	H.chem_capacity = H.chem_capacity * cap_multiplier
	for(var/datum/reagents/R in H.reagent_list)
		R.maximum_volume = R.maximum_volume * cap_multiplier
	..()

/datum/hypo_upgrade/cap_increase/remove_upgrade(obj/item/reagent_containers/hypospray/emais/H,atom/movable/A)
	H.chem_capacity = initial(H.chem_capacity)
	for(var/datum/reagents/R in H.reagent_list)
		R.maximum_volume = initial(H.chem_capacity)
	..()

/obj/item/hypo_upgrade
	name = "Hypo upgrade"
	desc = "This upgrade does nothing, kinda neat right?"
	icon_state = "nucleardisk"
	var/datum/hypo_upgrade/upgrade_datum
	var/reusable = FALSE

/obj/item/hypo_upgrade/proc/add_upgrade(obj/item/reagent_containers/hypospray/emais/H,atom/movable/A)
	upgrade_datum.add_upgrade(H,A)
	if(!reusable)
		qdel(src)

/obj/item/hypo_upgrade/cap_increase
	name = "Capacity upgrade"
	desc = "Increase injector capacity"
	upgrade_datum = new /datum/hypo_upgrade/cap_increase

