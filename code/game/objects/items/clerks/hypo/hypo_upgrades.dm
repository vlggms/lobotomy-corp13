/datum/hypo_upgrade
	var/name = "Hypo upgrade"
	var/desc = "This upgrade does nothing, kinda neat right?"

/datum/hypo_upgrade/proc/add_upgrade(var/obj/item/reagent_containers/hypospray/emais/H,var/atom/movable/A)
	if(!istype(H))
		return FALSE
	H.upgrades += src
	return TRUE

/datum/hypo_upgrade/proc/remove_upgrade(var/obj/item/reagent_containers/hypospray/emais/H,var/atom/movable/A)
	H.upgrades -= src
	return TRUE

/datum/hypo_upgrade/cap_increase
	name = "Capacity upgrade"
	desc = "Increase injector capacity"

/datum/hypo_upgrade/cap_increase/add_upgrade(var/obj/item/reagent_containers/hypospray/emais/H,var/atom/movable/A)
	H.chem_capacity = H.chem_capacity * 2
	..()

/datum/hypo_upgrade/cap_increase/remove_upgrade(var/obj/item/reagent_containers/hypospray/emais/H,var/atom/movable/A)
	H.chem_capacity = H.chem_capacity / 2
	..()

/obj/item/hypo_upgrade
	name = "Hypo upgrade"
	desc = "This upgrade does nothing, kinda neat right?"
	icon_state = "nucleardisk"
	var/datum/hypo_upgrade/upgrade_datum

/obj/item/hypo_upgrade/proc/add_upgrade(var/obj/item/reagent_containers/hypospray/emais/H,var/atom/movable/A)
	upgrade_datum.add_upgrade(H,A)

/obj/item/hypo_upgrade/cap_increase
	name = "Capacity upgrade"
	desc = "Increase injector capacity"
	upgrade_datum = new /datum/hypo_upgrade/cap_increase

