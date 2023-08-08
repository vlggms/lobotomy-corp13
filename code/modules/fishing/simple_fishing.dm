//Currently simplefishing and aquarium code both are dependant on the existence of _fish.dm, fishing.dmi, aquarium.dmi, signals_fish.dm, fishing_rod_lefthand.dmi, and fishing_rod_righthand.dmi
//i hate looking at TGstation fishing since i have no clue how to port it over because modules are not as modular as they say they are.
#define ROD_SLOT_LINE "line"
#define ROD_SLOT_HOOK "hook"
#define FISHSKILLEXP(A) user.mind?.adjust_experience(/datum/skill/fishing, A)
//If we get real fishing in then just delete this stuff -IP
/obj/item/simple_fishing_rod
	name = "ramshackle fishing rod"
	desc = "A tool used to dredge up aquatic entities. Though since the pole is so weak you may as well be handline fishing, a technique where you hold the line with your hands."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "rod"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_icon_state = "rod"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_HUGE
	//Fishing Equipment
	var/obj/item/fishing_line/line
	var/obj/item/fishing_hook/hook
	//Overlay Line Color
	var/default_line_color = "gray"
	//If already fishing
	var/isfishing = FALSE
	//Fishing Visuals
	var/list/current_fishing_visuals = list()

/obj/item/simple_fishing_rod/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This rod has a effectiveness of [(FISH_RARITY_BASIC - FishCustomization(900))/10].</span>"

/obj/item/simple_fishing_rod/attackby(obj/item/attacking_item, mob/user, params)
	if(SlotCheck(attacking_item,ROD_SLOT_LINE))
		UseSlot(ROD_SLOT_LINE, user, attacking_item)
		return TRUE
	else if(SlotCheck(attacking_item,ROD_SLOT_HOOK))
		UseSlot(ROD_SLOT_HOOK, user, attacking_item)
		return TRUE
	. = ..()

/obj/item/simple_fishing_rod/afterattack(atom/target, mob/user, proximity_flag)
	if(istype(target, /turf/open/water/deep) && isliving(user) && !isfishing && user.z == target.z)
		if(istype(user.get_inactive_held_item(), /obj/item/simple_fishing_rod))
			to_chat(user, "<span class='notice'>You attempt to cast two lines at once but they get tangled together.</span>")
			return
		var/fishing_amount = input(user, "How many fish do you want to catch?", "You can choose to fish a maximum of 10 at a time.") as num|null
		fishing_amount = round(fishing_amount)
		if(fishing_amount <= 0)
			return . = ..()
		if(fishing_amount > 10)
			fishing_amount = 10
		//Multicasting is too chaotic
		if(isfishing == TRUE)
			return
		StartFishing(user, target, fishing_amount) //Maybe we can make it call something else with this proc.
		return
	. = ..()

/obj/item/simple_fishing_rod/proc/StartFishing(mob/living/user, turf/open/water/deep/fishing_spot, amount)
	isfishing = TRUE
	user.visible_message("<span class='notice'>[user] begins fishing in [fishing_spot].</span>", "<span class='notice'>You begin fishing, intent to fish up [amount] things.</span>")
	playsound(get_turf(fishing_spot), 'sound/abnormalities/piscinemermaid/bigsplash.ogg', 20, 0, 3)
	//default fishing skill
	var/fishing_skill = 1
	//fishing visuals, first make a bobber.
	FishShapes("bobber", fishing_spot)
	var/list/fishing_turf = RegisterFishingArea(fishing_spot)
	//redundant check for safety concerns.
	if(!fishing_turf.len)
		return StopFishing()
	//copy turf enviorment list
	var/things_to_fish = fishing_spot.ReturnChanceList(FishCustomization(900))
	//MAKE VISUALS
	var/list/no_overlap_fish_turf = fishing_turf.Copy()
	//do not spawn a fish visual ontop of the bobber
	no_overlap_fish_turf -= fishing_spot
	var/list/visuals_list = list("fish_dancing", "fish_pacing", "fish_pacing2", "fish_mass")
		//Polluted water should not have fish that can be seen easily.
	if(istype(fishing_spot, /turf/open/water/deep/polluted))
		visuals_list = list("fish_mass")
	for(var/visable_feesh = 0 to 3)
		if(!no_overlap_fish_turf.len)
			break
		FishShapes(pick(visuals_list), pick_n_take(no_overlap_fish_turf), TRUE)

		//~~~FISHING BEGINS~~~
	for(var/i = 1 to amount)
		//random extra time to the fishing for a unpredictable feel rather than making a chance to just not fish up anything.
		var/fishing_time = ((10 SECONDS) * fishing_skill) + (rand(1,3) SECONDS)
		if(!do_after(user, fishing_time, target = fishing_spot))
			isfishing = FALSE
			break
		//Do we have the skill? Do we even have a mind?
		if(user.mind)
			fishing_skill = (user.mind.get_skill_modifier(/datum/skill/fishing, SKILL_SPEED_MODIFIER))
			FISHSKILLEXP(5)
		//Fishing successful
		FishLoot(pickweight(things_to_fish), user, get_turf(fishing_spot))
	return StopFishing()

//Unique Fish Retrieval
/obj/item/simple_fishing_rod/proc/FishLoot(obj/item/fished_thing, mob/living/user, turf/fish_land)
	if(istype(fished_thing, /obj/item/food/fish))
		var/obj/item/food/fish/fishie = new fished_thing(get_turf(user))
		fishie.randomize_weight_and_size(2)
		to_chat(user, "<span class='nicegreen'>You caught [initial(fishie.name)].</span>")
		if(user.mind)
			FISHSKILLEXP(10)
	else
		new fished_thing(get_turf(user))
	playsound(fish_land, 'sound/effects/fish_splash.ogg', 18, 0, 3)

#undef FISHSKILLEXP

	//Icon Stuff
/obj/item/simple_fishing_rod/update_overlays()
	. = ..()
	var/line_color = line?.line_color || default_line_color
	/// Line part by the rod, always visible
	var/mutable_appearance/reel_overlay = mutable_appearance(icon, "reel_overlay")
	reel_overlay.color = line_color;
	. += reel_overlay

	// Line & hook is also visible when only bait is equipped but it uses default appearances then
	if(hook)
		var/mutable_appearance/line_overlay = mutable_appearance(icon, "line_overlay")
		line_overlay.color = line_color;
		. += line_overlay
		var/mutable_appearance/hook_overlay = mutable_appearance(icon, hook?.rod_overlay_icon_state || "hook_overlay")
		. += hook_overlay

/obj/item/simple_fishing_rod/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	var/line_color = line?.line_color || default_line_color
	var/mutable_appearance/reel_overlay = mutable_appearance(icon_file, "reel_overlay")
	reel_overlay.appearance_flags |= RESET_COLOR
	reel_overlay.color = line_color
	. += reel_overlay
	/// if we don't have anything hooked show the dangling hook & line
	if(isinhands)
		var/mutable_appearance/line_overlay = mutable_appearance(icon_file, "line_overlay")
		line_overlay.appearance_flags |= RESET_COLOR
		line_overlay.color = line_color
		. += line_overlay
		. += mutable_appearance(icon_file, "hook_overlay")

	//Stop Fishing
/obj/item/simple_fishing_rod/proc/StopFishing()
	if(current_fishing_visuals.len)
		for(var/turf/T in current_fishing_visuals)
			if(!T)
				continue
			T.cut_overlay(current_fishing_visuals[T])
	isfishing = FALSE

	//Registers tiles around bobber.
/obj/item/simple_fishing_rod/proc/RegisterFishingArea(turf/open/fishing_tile)
	if(!isturf(fishing_tile))
		return
	var/list/water_tiles = list()
	for(var/turf/T in range(2, fishing_tile))
		if(!istype(T, fishing_tile.type))
			continue
		LAZYADD(water_tiles, T)
	if(water_tiles.len)
		return water_tiles

/obj/item/simple_fishing_rod/proc/FishShapes(icon_shape, turf/presence_in_water, underwater_shadow = FALSE)
	if(!isturf(presence_in_water))
		return
	var/mutable_appearance/under_the_waves = mutable_appearance(icon, icon_shape)
	//IS IT A SHAPE OR IS IT A BOBBER?
	if(underwater_shadow)
		under_the_waves.color = "BLACK"
		under_the_waves.alpha = 100
	//ADD THE OVERLAY TO THE LIST
	current_fishing_visuals += presence_in_water
	current_fishing_visuals[presence_in_water] = under_the_waves
	presence_in_water.add_overlay(under_the_waves)

//Rod Customization
/obj/item/simple_fishing_rod/proc/UseSlot(slot, mob/user, obj/item/new_item)
	var/obj/item/current_item
	switch(slot)
		if(ROD_SLOT_HOOK)
			current_item = hook
		if(ROD_SLOT_LINE)
			current_item = line
	if(!new_item && !current_item)
		return
	// Trying to remove the item
	if(!new_item && current_item)
		user.put_in_hands(current_item)
		update_icon()
		return
	// Trying to insert item into empty slot
	if(new_item && !current_item)
		if(!SlotCheck(new_item, slot))
			return
		if(user.transferItemToLoc(new_item,src))
			switch(slot)
				if(ROD_SLOT_HOOK)
					hook = new_item
				if(ROD_SLOT_LINE)
					line = new_item
			update_icon()
	/// Trying to swap item
	if(new_item && current_item)
		if(!SlotCheck(new_item,slot))
			return
		if(user.transferItemToLoc(new_item,src))
			switch(slot)
				if(ROD_SLOT_HOOK)
					hook = new_item
				if(ROD_SLOT_LINE)
					line = new_item
		user.put_in_hands(current_item)
		update_icon()

/// Checks if the item fits the slot
/obj/item/simple_fishing_rod/proc/SlotCheck(obj/item/item,slot)
	if(!istype(item))
		return FALSE
	switch(slot)
		if(ROD_SLOT_HOOK)
			if(!istype(item,/obj/item/fishing_hook))
				return FALSE
		if(ROD_SLOT_LINE)
			if(!istype(item,/obj/item/fishing_line))
				return FALSE
	return TRUE

	//Calculates fishing power
/obj/item/simple_fishing_rod/proc/FishCustomization(fishing_rod_power = 1000)
	if(hook)
		if(istype(hook,/obj/item/fishing_hook))
			fishing_rod_power -= hook.fishin_value
	if(line)
		if(istype(line,/obj/item/fishing_line))
			fishing_rod_power -= line.fishin_value
	return fishing_rod_power

#undef ROD_SLOT_LINE
#undef ROD_SLOT_HOOK

//SIMPLE FISHING NETS EVEN MORE IDLE THAN BEFORE
/obj/item/simple_fishing_net
	name = "fishing net"
	desc = "This tool functions as a aquatic wall you can put down and just harvest the fish that get tangled in it."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "trawling_net"
	w_class = WEIGHT_CLASS_HUGE
	//Item deployment code is inside /turf/open/water/deep

/obj/structure/destructible/simple_fishing_net
	name = "fishin net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "trawling_net_empty"
	max_integrity = 5
	break_message = "<span class='notice'>The net falls apart!</span>"
	break_sound = 'sound/items/wirecutter.ogg'
	debris = list(/obj/item/simple_fishing_net = 1)
	var/list/stuff_to_catch
	var/turf/open/water/deep/open_waters

/obj/structure/destructible/simple_fishing_net/Initialize()
	. = ..()
	open_waters = get_turf(src)
	if(!istype(open_waters, /turf/open/water/deep))
		qdel(src)
		return
	stuff_to_catch = open_waters.ReturnChanceList()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/CatchFish)

/obj/structure/destructible/simple_fishing_net/examine(mob/user)
	. = ..()
	if(contents.len >= 5)
		. += "<span class='notice'>[contents.len]/5 things are caught in the [src].</span>"

/obj/structure/destructible/simple_fishing_net/AltClick(mob/user)
	. = ..()
	EmptyNet(get_turf(user))

/obj/structure/destructible/simple_fishing_net/proc/EmptyNet(turf/dropoff)
	for(var/atom/movable/harvest in contents)
		harvest.forceMove(dropoff)
	new /obj/item/simple_fishing_net(dropoff)
	qdel(src)

/obj/structure/destructible/simple_fishing_net/proc/CatchFish()
	SIGNAL_HANDLER
	if(contents.len >= 5 || !open_waters)
		return
	var/atom/thing_caught = pickweight(stuff_to_catch)
	new thing_caught(src)
	icon_state = "trawling_net_full"
	update_icon()

//FISHING TURFS
	//Unique Fishing Spots
/turf/open/water/deep //you will sink in this. collective branch for both saltwater and freshwater turfs.
	name = "water"
	desc = "Deep Water."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "water_turf1"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	//This is mostly for AI. CanAllowThrough still makes it passable.
	density = TRUE
	bullet_sizzle = TRUE
	bullet_bounce_sound = 'sound/effects/footstep/water1.ogg'
	//Turf that living mobs like hostiles and humans are dropped off at.
	var/turf/target_turf
	//Sound delay so we dont get splash spam.
	var/sound_delay = 0
	//Lootlist of things for fishing.
	var/list/environment = list(/obj/item/food/grown/harebell = 200)
	var/list/static/forbidden_types = typecacheof(list(
		/obj/singularity,
		/obj/energy_ball,
		/obj/narsie,
		/obj/docking_port,
		/obj/structure/lattice,
		/obj/structure/stone_tile,
		/obj/projectile,
		/obj/effect/projectile,
		/obj/effect/portal,
		/obj/effect/abstract,
		/obj/effect/hotspot,
		/obj/effect/landmark,
		/obj/effect/temp_visual,
		/obj/effect/light_emitter/tendril,
		/obj/effect/collapse,
		/obj/effect/particle_effect/ion_trails,
		/obj/effect/dummy/phased_mob
		))

/turf/open/water/deep/Initialize()
	. = ..()
	target_turf = pick(GLOB.department_centers)

/turf/open/water/deep/CanAllowThrough(atom/movable/AM, turf/target)
	. = ..()
	return TRUE

/turf/open/water/deep/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/simple_fishing_net) && params)
		to_chat(user, "<span class='notice'>You start setting up the [C].</span>")
		if(do_after(user, 2 SECONDS, target = user) && C && !locate(/obj/structure/destructible/simple_fishing_net) in src)
			new /obj/structure/destructible/simple_fishing_net(get_turf(src))
			playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0, 3)
			qdel(C)
			return
	..()

/turf/open/water/deep/Entered(atom/movable/thing, atom/oldLoc) //Sinking Code
	. = ..()
	if(!target_turf || is_type_in_typecache(thing, forbidden_types) || (thing.throwing && !istype(thing, /obj/item/food/fish || /obj/item/aquarium_prop )) || (thing.movement_type & (FLOATING|FLYING))) //replace this with a varient of chasm component sometime.
		return
	if(isliving(thing))
		var/mob/living/L = thing
		if(L.movement_type & FLYING)
			return
		//100 brute damage to living mobs. If they are human add 50 oxygen damage to them.
		L.adjustBruteLoss(100)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.Paralyze(30)
			H.adjustOxyLoss(50)
			visible_message("<span class='boldwarning'>[H] sinks into the deep!</span>")
			to_chat(H, pick("<span class='userdanger'>Something in the [src] grabs you and pulls you into the darkness. Your eyes burn as the light becomes fainter and the deep darkness begins circle around you.</span>", "<span class='userdanger'>The fluid around you starts crawling into your mouth.</span>", "<span class='userdanger'>You feel a sudden sting, then everything goes numb.</span>"))
		//Things that become lost in the deep. Objects like fish can be thrown into the deep. However some objects result in pollution.
	else if(isitem(thing) || istype(thing, /obj/effect/decal/cleanable))
		if(istype(thing, /obj/item/food/fish/emulsijack) && !istype(src, /turf/open/water/deep/polluted))
			//Become polluted.
			TerraformTurf(/turf/open/water/deep/polluted)
		qdel(thing)
	//Randomize department that the water dumps you at, and also delay sound so that several items being placed into the deep dont scream.
	if(sound_delay <= world.time)
		playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 20, 0, 3)
		sound_delay = world.time + (3 SECONDS)
	thing.forceMove(target_turf)

	//How this works is that it returns a list with a divided chance for anything lower than the maximum
/turf/open/water/deep/proc/ReturnChanceList(maximum = FISH_RARITY_BASIC)
	var/list/altered_loot_list = environment.Copy()
	for(var/atom in altered_loot_list)
		if(altered_loot_list[atom] < maximum)
			altered_loot_list[atom] /= 5
			continue
	return altered_loot_list

/turf/open/water/deep/freshwater
	name = "water"
	desc = "Bodies of freshwater like these usually have stories of aquatic predators that assault fishermen."
	icon_state = "water_turf1"
	environment = list(
		/obj/item/food/fish/goldfish = FISH_RARITY_BASIC,
		/obj/item/food/fish/angelfish = FISH_RARITY_BASIC,
		/obj/item/food/fish/guppy = FISH_RARITY_BASIC,
		/obj/item/food/fish/plasmatetra = FISH_RARITY_BASIC,
		/obj/item/food/fish/catfish = FISH_RARITY_RARE,
		/obj/item/food/fish/ratfish = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/waterflea = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/yin = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/yang = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/emulsijack = FISH_RARITY_GOOD_LUCK_FINDING_THIS,
		//random things
		/obj/item/food/dough = 800,
		/obj/item/stack/spacecash/c1 = 700,
		/obj/item/stack/fish_points = 600,
		/obj/item/stack/sheet/leather = 500,
		/obj/item/food/canned/peaches = 300,
		/obj/item/food/breadslice/moldy = 300,
		/obj/item/stack/sheet/sinew/wolf = 300,
		/obj/item/clothing/head/beret/tegu/fishing_hat = 200,
		/obj/item/food/grown/harebell = 200,
		/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled = 200,
		/obj/item/fishing_hook/bone = 100,
		/mob/living/simple_animal/hostile/retaliate/frog = 50
		)

/turf/open/water/deep/saltwater
	name = "water"
	desc = "Smells of the ocean. Darkness obscures what world might be down there."
	icon_state = "water_turf2"
	environment = list(
		/obj/item/food/fish/marine_shrimp = FISH_RARITY_BASIC,
		/obj/item/food/fish/clownfish = FISH_RARITY_BASIC,
		/obj/item/food/fish/greenchromis = FISH_RARITY_BASIC,
		/obj/item/food/fish/firefish = FISH_RARITY_BASIC,
		/obj/item/food/fish/cardinal = FISH_RARITY_RARE,
		/obj/item/food/fish/pufferfish = FISH_RARITY_RARE,
		/obj/item/food/fish/sheephead = FISH_RARITY_RARE,
		/obj/item/food/fish/lanternfish = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/emulsijack = FISH_RARITY_GOOD_LUCK_FINDING_THIS,
		//random things
		/obj/item/stack/spacecash/c1 = 700,
		/obj/item/fishing_hook/bone = 700,
		/obj/item/stack/fish_points = 600,
		/obj/item/food/canned/beans = 600,
		/obj/item/food/canned/peaches = 600,
		/obj/item/clothing/head/beret/tegu/fishing_hat = 200,
		/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled = 100,
		/mob/living/simple_animal/crab = 50
		)

/turf/open/water/deep/polluted
	name = "polluted water"
	desc = "An aquatic deadzone, your more likely to reel in junk due to the inhospitable enviorment."
	icon_state = "water_turf2"
	color = "GREEN"
	environment = list(
		/obj/item/food/fish/pmermaid = 200,
		/obj/item/food/fish/msob = 200,
		/obj/item/food/fish/ratfish = 50,
		/obj/item/food/fish/emulsijack = 10,
		//random things
		/obj/item/food/tofu/prison = 1000,
		/obj/item/food/meat/slab/human/mutant/zombie = 1000,
		/obj/item/food/dough = 800,
		/obj/item/stack/spacecash/c1 = 700,
		/obj/item/stack/sheet/leather = 500,
		/obj/item/food/breadslice/moldy = 300,
		/obj/item/stack/sheet/sinew/wolf = 300,
		/obj/item/food/canned/beans = 300,
		/obj/item/food/canned/peaches = 300,
		/obj/item/reagent_containers/food/drinks/bottle/small = 300,
		/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled = 300,
		/obj/item/stack/sheet/plastic = 300,
		/obj/item/stack/fish_points = 250,
		/obj/item/food/spiderling = 200,
		/obj/item/food/grown/harebell = 200,
		/obj/item/stack/sheet/mineral/wood = 200,
		/obj/item/ego_weapon/city/rats/brick = 100,
		/mob/living/simple_animal/hostile/shrimp = 100
		)
