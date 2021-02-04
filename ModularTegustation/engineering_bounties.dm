/datum/bounty/item/engineering/gas/oxygen_tank
	name = "Full Tank of Oxygen"
	description = "Station 17 recently underwent a catastrophic gas chamber breach and lost all their oxygen. Ship them a tank full to help out. (20 Moles)"
	gas_type = /datum/gas/oxygen
	reward = CARGO_CRATE_VALUE * 4

/datum/bounty/item/engineering/gas/nitrogen_tank
	name = "Full Tank of Nitrogen"
	description = "Station 32 is running low on coolant for their Supermatter Engine. Send them a tank full of Nitrogen to help them keep running. (20 Moles)"
	gas_type = /datum/gas/nitrogen
	reward = CARGO_CRATE_VALUE * 4

/datum/bounty/item/engineering/gas/h2o_tank
	name = "Full Tank of Water Vapour"
	description = "Station 22's janitorial team is sick of manually moping up huge piles of blood. Send a water vapour can to help speed up cleaning. (20 Moles)"
	gas_type = /datum/gas/water_vapor
	reward = CARGO_CRATE_VALUE * 6

/datum/bounty/item/engineering/gas/co2_tank
	name = "Full Tank of Carbon Dioxide"
	description = "Station 11 is running some experiments on efficiently carbonating drinks. Send them a can of Carbon Dioxide to help with research. (20 Moles)"
	gas_type = /datum/gas/carbon_dioxide
	reward = CARGO_CRATE_VALUE * 5

/datum/bounty/item/engineering/gas/plasma_tank
	name = "Full Tank of Plasma"
	description = "The plasmamen aboard Station 16 are running low on internals. Send a tank to keep them breathing. (20 Moles)"
	gas_type = /datum/gas/plasma
	reward = CARGO_CRATE_VALUE * 5

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
