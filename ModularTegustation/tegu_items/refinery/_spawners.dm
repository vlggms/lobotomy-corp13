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

/obj/effect/landmark/salesspawn
	name = "sales machine spawner"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/salesspawn/Initialize()
	..()
	if(!LAZYLEN(GLOB.unspawned_sales)) // You shouldn't ever need this but I mean go on I guess
		return INITIALIZE_HINT_QDEL
	var/obj/structure/pe_sales/spawning = pick_n_take(GLOB.unspawned_sales)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL

