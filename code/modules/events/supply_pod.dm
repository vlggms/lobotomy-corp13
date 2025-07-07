///Spawns a cargo pod containing a random cargo supply pack on a random area of the station
/datum/round_event_control/lc13/supplypod
	name = "Stray Cargo Crate"
	typepath = /datum/round_event/stray_cargo_lc
	weight = 20
	max_occurrences = 10
	earliest_start = 10 MINUTES

///Spawns a cargo pod containing a random refinery crate
/datum/round_event/stray_cargo_lc
	announceChance = 75
	var/list/possible_pack_types = list(
	/obj/structure/lootcrate/k_corp,
	/obj/structure/lootcrate/n_corp,
	/obj/structure/lootcrate/r_corp,
	/obj/structure/lootcrate/w_corp,

	)

/datum/round_event/stray_cargo_lc/announce(fake)
	priority_announce("Stray Supply Crates detected on facility scanners.", "HQ Information")

/datum/round_event/stray_cargo_lc/setup()
	startWhen = rand(20, 40)

///Spawns a random crate
/datum/round_event/stray_cargo_lc/start()
	var/spawn_amount = 3

	var/list/potential_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to spawn_amount)
		var/spawning = pick(possible_pack_types)
		new spawning (potential_locs)
