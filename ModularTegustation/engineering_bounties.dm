/datum/bounty/item/engineering/gas/h2o_tank
	name = "Full Tank of Water Vapour"
	description = "Station 22's janitorial team is sick of manually moping up huge piles of blood. Send a water vapour can to help speed up cleaning. (20 Moles)"
	gas_type = /datum/gas/water_vapor
	reward = CARGO_CRATE_VALUE * 6

/datum/bounty/item/engineering/recharger
	name = "Weapons Recharger"
	description = "The security team aboard Station 34 keep yelling 'where i charge batong'. Send a recharger to shut them up."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/machinery/recharger)

/datum/bounty/item/engineering/chemical_dispenser
	name = "Portable Chemical Dispenser"
	description = "Our team are trying to figure out why your Chemistry labs keep exploding, and we think it's a fault with the dispensers. Our last one exploded, mind sending us another?"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/machinery/chem_dispenser)

/datum/bounty/item/engineering/pacman
	name = "PACMAN Power Generator"
	description = "A neighbouring outpost recently lost their Supermatter and are in need of some PACMANs for temporary power generator"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/machinery/power/port_gen/pacman)

/datum/bounty/item/engineering/rad_collector
	name = "Radiation Collector"
	description = "Large quantities of recent delaminations have run dry our supply of Radiation Collectors, and the CentCom engineers are too dumb to build more. Send one of yours."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/machinery/power/rad_collector)

/datum/bounty/item/engineering/gas/bz_can
	name = "Full Tank of BZ"
	description = "Station 45 has been having some issues with changelings and wants some BZ to help out. Send them a can."
	wanted_types = list(/datum/gas/bz)
	reward = CARGO_CRATE_VALUE * 10
