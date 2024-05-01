//Imported from Desert Rose

/////////////////
// COMPOST BIN //
/////////////////

/obj/structure/reagent_dispensers/compostbin
	name = "compost bin"
	desc = "A smelly structure made of wooden slats where refuse is thrown. Dump unwanted seeds and produce in, pull usable compost out."
	icon = 'ModularTegustation/Teguicons/farming_structures.dmi'
	icon_state = "compostbin"
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	reagent_id = /datum/reagent/compost

/obj/structure/reagent_dispensers/compostbin/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(reagent_id, 100)

/obj/structure/reagent_dispensers/compostbin/attackby(obj/item/W, mob/user, params)
	if(W.is_refillable())
		return 0 //so we can refill them via their afterattack.
	if(reagents.total_volume == tank_volume)
		to_chat(user,span_warning("The [src] is filled to capacity!"))
		return
	if(istype(W, /obj/item/seeds) || istype(W, /obj/item/food))
		if(user.transferItemToLoc(W, src))
			to_chat(user, span_notice("You load the [W] into the [src]."))
			playsound(loc, 'sound/effects/blobattack.ogg', 25, 1, -1)
			process_compost()
		else
			to_chat(user, span_warning("That's not compostable! Try seeds or flowers instead."))
	else if(istype(W, /obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/PB = W
		for(var/obj/item/G in PB.contents)// This check can be less than thorough because the bag has already authenticated the contents, hopefully
			if(SEND_SIGNAL(PB, COMSIG_TRY_STORAGE_TAKE, G, src))
				to_chat(user, "<span class='info'>You empty the [PB] into the [src].</span>")
				playsound(loc, 'sound/effects/blobattack.ogg', 25, 1, -1)
				process_compost()

/obj/structure/reagent_dispensers/compostbin/proc/process_compost()
	for(var/obj/item/C in contents)
		if(istype(C, /obj/item/seeds))
			var/obj/item/seeds/S = C
			reagents.add_reagent(/datum/reagent/compost, S.yield)
		if(istype(C, /obj/item/food))
			reagents.add_reagent(/datum/reagent/compost, 10)
		qdel(C)

////////////////////
// SEED EXTRACTOR //
////////////////////

/obj/structure/seed_grinder
	name = "seed grinder"
	desc = "A crude grinding machine repurposed from kitchen appliances. Plants go in, seeds come out."
	icon = 'ModularTegustation/Teguicons/farming_structures.dmi'
	icon_state = "sextractor_manual"
	density = FALSE
	anchored = TRUE

/obj/structure/seed_grinder/proc/seedify(obj/item/O, t_max, obj/structure/seed_grinder/extractor, mob/living/user)
	var/t_amount = 0
	var/list/seeds = list()
	if(t_max == -1)
		t_max = rand(1,2) //Slightly worse than the actual thing

	var/seedloc = O.loc
	if(extractor)
		seedloc = extractor.loc

	if(istype(O, /obj/item/food/grown/))
		var/obj/item/food/grown/F = O
		if(F.seed)
			if(user && !user.temporarilyRemoveItemFromInventory(O)) //couldn't drop the item
				return
			while(t_amount < t_max)
				var/obj/item/seeds/t_prod = F.seed.Copy()
				seeds.Add(t_prod)
				t_prod.forceMove(seedloc)
				t_amount++
			qdel(O)
			return seeds

	else if(istype(O, /obj/item/grown))
		var/obj/item/grown/F = O
		if(F.seed)
			if(user && !user.temporarilyRemoveItemFromInventory(O))
				return
			while(t_amount < t_max)
				var/obj/item/seeds/t_prod = F.seed.Copy()
				t_prod.forceMove(seedloc)
				t_amount++
			qdel(O)
		return 1

	return 0

/obj/structure/seed_grinder/attackby(obj/item/O, mob/user, params)

	if(default_unfasten_wrench(user, O)) //So we can move them around
		return

	else if(seedify(O,-1, src, user))
		to_chat(user, span_notice("You extract some seeds."))
		return
	else if(user.a_intent != INTENT_HARM)
		to_chat(user, span_warning("You can't extract any seeds from \the [O.name]!"))
	else
		return ..()
