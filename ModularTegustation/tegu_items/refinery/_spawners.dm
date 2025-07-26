GLOBAL_LIST_INIT(unspawned_sales, list(
	/obj/structure/pe_sales/l_corp,
	/obj/structure/pe_sales/w_corp,
	/obj/structure/pe_sales/r_corp,
	/obj/structure/pe_sales/k_corp,
	/obj/structure/pe_sales/s_corp,
	/obj/structure/pe_sales/n_corp,
	/obj/structure/pe_sales/limbus,
	/obj/structure/pe_sales/hana,
	/obj/structure/pe_sales/zwei,
	/obj/structure/pe_sales/shi,
	/obj/structure/pe_sales/liu,
	/obj/structure/pe_sales/seven,
	/obj/structure/pe_sales/leaflet,
	/obj/structure/pe_sales/allas,
	/obj/structure/pe_sales/zelkova,
	/obj/structure/pe_sales/rosespanner,
	/obj/structure/pe_sales/syndicate,
	/obj/structure/pe_sales/backstreet,
	/obj/structure/pe_sales/jcorp,
))

/// DELETE THIS BEFORE MERGING, this is for TESTING PURPOSES, we want to make sure these sales always get spawned so we can test them
GLOBAL_LIST_INIT(rigged_unspawned_sales, list(
	/obj/structure/pe_sales/thumb,
))

/obj/effect/landmark/salesspawn
	name = "sales machine spawner"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/// This was EDITED FOR TESTING remember to remove the rigged stuff before merging
/obj/effect/landmark/salesspawn/Initialize()
	..()
	if(!LAZYLEN(GLOB.unspawned_sales) && !LAZYLEN(GLOB.rigged_unspawned_sales)) // You shouldn't ever need this but I mean go on I guess
		return INITIALIZE_HINT_QDEL
	var/obj/structure/pe_sales/spawning
	if(length(GLOB.rigged_unspawned_sales))
		spawning = pick_n_take(GLOB.rigged_unspawned_sales)
	else
		spawning = pick_n_take(GLOB.unspawned_sales)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL

