//you will sink in this. collective branch for both saltwater and freshwater turfs.
/turf/open/water/deep
	name = "water"
	desc = "Deep Water."
	icon = 'icons/turf/floors/water.dmi'
	icon_state = "water_turf1"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	//This is mostly for AI. CanAllowThrough still makes it passable.
	density = TRUE
	bullet_sizzle = TRUE
	bullet_bounce_sound = 'sound/effects/footstep/water1.ogg'
	/*Turf that living mobs like hostiles and humans are dropped off at.
		This is a variable because some people may want water to work as
		a portal to somewhere.*/
	var/turf/target_turf
	//If the target_turf is randomized.
	var/static_target = FALSE
	//Sound delay so we dont get splash spam.
	var/sound_delay = 0
	/* Loottable of things for fishing. Making these balanced
		has actually been difficult so im going to simply make
		the total amount of chance for each thing equal 100.
		Fishing rods use pickweight which goes through each
		of the items in the table and uses their assigned
		chance to choose amongst them. This obviously becomes
		a issue when level 1 has 10 objects each worth 5 and
		level 2 has 5 objects each worth 5 meaning there is a
		5/50 chance for individual level 1 objects and a 5/25
		chance for level 2 objects.*/
	var/list/loot_level1 = list()
	var/list/loot_level2 = list()
	var/list/loot_level3 = list(
		/obj/item/food/grown/harebell = 100,
	)
	//Things that just cant sink. Dont bother trying to sink them.
	var/static/list/cant_sink_types = typecacheof(list(
		/obj/effect,
		/obj/singularity,
		/obj/energy_ball,
		/obj/narsie,
		/obj/docking_port,
		/obj/item/jammer/self_activated,
		/obj/structure/lattice,
		/obj/projectile,
	))

	var/safe = FALSE

/turf/open/water/deep/Initialize()
	. = ..()
	WashedOnTheShore()

/* These three procs are stolen from lava.dm. Basically when something enters the turf starts processing
	and checking if the thing can have the turfs ability used on it IE melting things. If sink stuff returns
	False it stops checking and accepts that the thing is immune to its ability. If it returns true it will
	use its ability until that thing is gone.*/
/turf/open/water/deep/Entered(atom/movable/AM)
	if(is_type_in_typecache(AM, cant_sink_types))
		return
	if(SinkStuff(AM))
		START_PROCESSING(SSobj, src)

/turf/open/water/deep/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(is_type_in_typecache(AM, cant_sink_types))
		return
	if(SinkStuff(AM))
		START_PROCESSING(SSobj, src)

/turf/open/water/deep/process(delta_time)
	if(!SinkStuff(null, delta_time))
		STOP_PROCESSING(SSobj, src)

//This is to prevent Mob AI from just walking into it. Works some of the time. -IP
/turf/open/water/deep/CanAllowThrough(atom/movable/AM, turf/target)
	. = ..()
	return TRUE

//For fishing nets.
/turf/open/water/deep/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/fishing_net) && params)
		to_chat(user, span_notice("You start setting up the [C]."))
		if(do_after(user, 2 SECONDS, target = user) && C && !locate(/obj/structure/destructible/fishing_net) in src)
			new /obj/structure/destructible/fishing_net(get_turf(src))
			playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0, 3)
			qdel(C)
			return
	..()

	//This IsSafe proc checks if there is a structure in place that will prevent the proc after this from running.
/turf/open/water/deep/proc/IsSafe()
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/water_safeties_typecache = typecacheof(list(
		/obj/vehicle/ridden/lavaboat,
		/obj/vehicle/ridden/simple_boat,
		/obj/structure/lattice/catwalk,
		/obj/structure/lattice/lava,
		/obj/structure/stone_tile,
		/obj/structure/flora,
		//If anyone asks yes walking on nets is SORT of intended. -IP
		/obj/structure/destructible/fishing_net,
	))
	var/list/found_safeties = typecache_filter_list(contents, water_safeties_typecache)
	return LAZYLEN(found_safeties)

	//If this proc returns TRUE then the turf will continue rerunning the proc until the item is gone or immune.
/turf/open/water/deep/proc/SinkStuff(AM, delta_time = 1)
	. = 0

	if(IsSafe())
		return FALSE
	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)
	else
		return FALSE
	for(var/thing in thing_to_check)
		//Conditional check for objects.
		if(isobj(thing))
			var/obj/O = thing
			if(O.anchored)
				continue
			if(O.throwing)
				continue
			ObjSink(thing)
			if(istype(O, /obj/item/food/fish || /obj/item/aquarium_prop))
				//Fish exit the game world and enter the water world.
				qdel(O)
				continue
			//Most closets are not watertight.
			if(istype(O, /obj/structure/closet))
				var/obj/structure/closet/locker = O
				visible_message(span_notice("[locker] is not watertight."))
				for(var/I in locker.contents)
					if(isliving(I))
						MobSink(I)
			/* This may cause issues later on. Without this people can sit on office chairs
				and push themselves into water with no negative effects except being warped.
				This appears to just leave people on the shore with the item being teleported. -IP */
			if(O.has_buckled_mobs())
				O.unbuckle_all_mobs()
				visible_message(span_notice("[O] capsizes."))
			if(O && O.loc == src)
				WarpSunkStuff(O)
				return FALSE

		else if (isliving(thing))
			. = 1
			var/mob/living/L = thing
			if(L.movement_type & (FLOATING|FLYING))
				continue	//YOU'RE FLYING OVER IT
			if(L.throwing)
				continue	//You can jump over water
			var/buckle_check = L.buckled
			//Your stuck to something that isnt sinking
			if(isobj(buckle_check))
				continue
			if(L)
				MobSink(L)
				WarpSunkStuff(L)
				return FALSE

	//Overridable Unique Reaction. Currently only used to pollute water.
/turf/open/water/deep/proc/ObjSink(atom/movable/sinkin_thing)
	if(istype(sinkin_thing, /obj/item/food/fish/emulsijack))
		//Become polluted.
		TerraformTurf(/turf/open/water/deep/polluted)
		return TRUE

	//Overridable Mob Reaction
/turf/open/water/deep/proc/MobSink(mob/living/drowner)
	//50 brute damage to living mobs. If they are human add 50 oxygen damage to them. May change this later on.
	drowner.adjustBruteLoss(50)
	if(ishuman(drowner))
		var/mob/living/carbon/human/H = drowner
		H.Paralyze(30)
		H.adjustOxyLoss(50)

/* Currently water warps things to a random department but for other non Lobotomy Corp maps
	It would be more helpful if the items were kept at sea for a few moments before teleporting
	to a shore tile. But this also requires the existance of shore tiles and a place to fit
	shore tiles. It would be funny to just go to the beach and corpses and items are just
	teleported there because they fell into the water. -IP */
/turf/open/water/deep/proc/WarpSunkStuff(atom/movable/thing)
	//Randomize department that the water dumps you at, and also delay sound so that several items being placed into the deep dont scream.
	if(sound_delay <= world.time)
		playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 20, 0, 3)
		sound_delay = world.time + (3 SECONDS)
		//Might be redundant to randomize the location every time. -IP
		WashedOnTheShore()
	if(thing && !QDELETED(thing))
		if(ishuman(thing))
			visible_message(span_boldwarning("[thing] sinks into the deep!"))
			to_chat(thing, pick(
				span_userdanger("Something in the [src] grabs you and pulls you into the darkness. Your eyes burn as the light becomes fainter and the deep darkness begins circle around you."),
				span_userdanger("The fluid around you starts crawling into your mouth."),
				span_userdanger("You feel a sudden sting, then everything goes numb.")))
		//Redundant check just in the case of extreme error.
		if(target_turf)
			thing.forceMove(target_turf)
		else
			qdel(thing)

	//Proc to randomize target_turf
/turf/open/water/deep/proc/WashedOnTheShore()
	if(!static_target)
		if(GLOB.department_centers.len > 0)
			target_turf = pick(GLOB.department_centers)
		else
			target_turf = get_turf(src)

	//FOR FISHING: This will be remotely called by the fishing rod in order to get the tiles loottable.
/turf/open/water/deep/proc/ReturnChanceList(skill_amount)
	var/thefishnumber = ItemHowRare(skill_amount)

	switch(thefishnumber)
		if(0)
			return loot_level1.Copy()
		if(1)
			return loot_level2.Copy()
		if(2 to INFINITY)
			return loot_level3.Copy()

/* Randomized Rarity Chance. Each consecutive success
	results in a rarity level increase. */
/turf/open/water/deep/proc/ItemHowRare(rarity_mod = 1)
	. = 0
	for(var/i=0 to 3)
		/* This formula inside prob is a base chance of 15 * rarity mod.
			Each success reduces the base chance by 5. The clamp proc
			is to set a max and minimum to the chance levels so the
			highest level of chance you can get is 95%.*/
		if(prob(clamp((15-(5*i))*rarity_mod,1,95)))
			. = i
			continue
		break
	return

/turf/open/water/deep/freshwater
	name = "water"
	desc = "Bodies of freshwater like these usually have stories of aquatic predators that assault fishermen."
	icon_state = "water_turf1"
	loot_level1 = list(
		//75% chance bulk
		/obj/item/food/fish/fresh_water/guppy = 35,
		/obj/item/food/fish/fresh_water/angelfish = 20,
		/obj/item/food/fish/fresh_water/plasmatetra = 20,
		//25% chance
		/obj/item/stack/sheet/mineral/wood = 13,
		/obj/item/fishing_component/hook/bone = 5,
		/obj/item/food/grown/harebell = 5,
		/obj/item/food/breadslice/moldy = 2,
	)
	loot_level2 = list(
		/obj/item/food/fish/fresh_water/catfish = 50,
		/obj/item/stack/sheet/sinew/wolf = 20,
		/obj/item/stack/sheet/leather = 15,
		/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled = 10,
		/obj/item/clothing/head/beret/fishing_hat = 5,
	)
	loot_level3 = list(
		/obj/item/food/fish/fresh_water/ratfish = 25,
		/obj/item/food/fish/fresh_water/waterflea = 20,
		/obj/item/food/fish/fresh_water/yin = 20,
		/obj/item/food/fish/fresh_water/yang = 20,
		/mob/living/simple_animal/hostile/retaliate/frog = 10,
		/obj/item/food/fish/emulsijack = 5,
	)

/turf/open/water/deep/saltwater
	name = "water"
	desc = "Smells of the ocean. Darkness obscures what world might be down there."
	icon_state = "water_turf2"
	loot_level1 = list(
		/obj/item/food/fish/salt_water/marine_shrimp = 40,
		/obj/item/food/fish/salt_water/greenchromis = 20,
		/obj/item/food/fish/salt_water/firefish = 20,
		/obj/item/food/fish/salt_water/clownfish = 10,
		/obj/item/stack/sheet/mineral/wood = 10,
	)
	loot_level2 = list(
		/obj/item/food/fish/salt_water/cardinal = 45,
		/obj/item/food/fish/salt_water/sheephead = 40,
		/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled = 10,
		/obj/item/clothing/head/beret/fishing_hat = 5,
	)
	loot_level3 = list(
		/obj/item/food/fish/salt_water/lanternfish = 85,
		/mob/living/simple_animal/crab = 10,
		/obj/item/food/fish/emulsijack = 5,
	)

/turf/open/water/deep/polluted
	name = "polluted water"
	desc = "An aquatic deadzone, your more likely to reel in junk due to the inhospitable enviorment."
	icon_state = "water_turf2"
	color = "GREEN"
	loot_level1 = list(
		/obj/item/food/meat/slab/human/mutant/zombie = 45,
		/obj/item/food/breadslice/moldy = 40,
		/obj/item/stack/sheet/mineral/wood = 5,
		/obj/item/food/grown/harebell = 5,
		/obj/item/food/spiderling = 5,
	)
	loot_level2 = list(
		/obj/item/food/fish/fresh_water/ratfish = 35,
		/obj/item/food/canned/peaches = 15,
		/obj/item/food/canned/beans = 10,
		/obj/item/reagent_containers/food/drinks/bottle/small = 10,
		/obj/item/stack/sheet/plastic = 15,
		/obj/item/ego_weapon/city/rats/brick = 10,
		/obj/item/food/tofu/prison = 3,
		/mob/living/simple_animal/hostile/shrimp = 2,
	)
	loot_level3 = list(
		/obj/item/food/fish/fresh_water/mosb = 50,
		/obj/item/food/fish/salt_water/piscine_mermaid = 45,
		/obj/item/food/fish/emulsijack = 5,
	)

/turf/open/water/deep/polluted/ObjSink(atom/movable/sinkin_thing)
	return TRUE

/* Change this later so that it is not a subtype since the variable is in the deep type.
	Safe subtype isnt nessesary since it pre sets safe to TRUE when we can just set it to
	true individually.-IP*/

/**
 * Safe turfs, they wont sink you when you enter them
 */

/turf/open/water/deep/saltwater/safe/IsSafe()
	return TRUE

/turf/open/water/deep/obsessing_water
	safe = TRUE
	name = "Obsessing water"
	desc = "A strange black and teal water."
	icon_state = "obsessing_water"
	loot_level1 = list(
		/obj/item/stack/sheet/mineral/wood = 30,
		/obj/item/food/grown/harebell = 35,
		/obj/item/food/spiderling = 25,
		/obj/item/food/fish/siltcurrent = 10
		)
	loot_level2 = list(
		/obj/item/food/fish/siltcurrent = 35,
		/obj/item/ego_weapon/city/rats/brick = 25,
		/obj/item/stack/sheet/plastic = 10,
		/obj/item/stack/fish_points = 10,
		/obj/item/clothing/head/beret/fishing_hat = 10,
		/obj/item/fishing_component/hook/bone = 9,
		/obj/item/food/fish/emulsijack = 1,
		)
	loot_level3 = list(
		/obj/item/food/fish/siltcurrent = 60,
		/obj/item/food/fish/emulsijack = 40,
		)

/turf/open/water/deep/obsessing_water/IsSafe()
	return TRUE
