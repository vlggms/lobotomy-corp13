
/**
 *
 * Modular file containing: fishing rods
 * The bread and butter of fishing, without this everything else is basically worthless
 *
 */

#define ROD_SLOT_LINE "line"
#define ROD_SLOT_HOOK "hook"
#define FISHSKILLEXP(A) user.mind?.adjust_experience(/datum/skill/fishing, A)

/obj/item/fishing_rod
	name = "ramshackle fishing rod"
	desc = "A tool used to dredge up aquatic entities. Though since the pole is so weak you may as well be handline fishing, a technique where you hold the line with your hands."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "rod"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_icon_state = "rod"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_HUGE
	//Fishing Equipment
	var/obj/item/fishing_component/line/line
	var/obj/item/fishing_component/hook/hook
	//Overlay Line Color
	var/default_line_color = "gray"
	//If already fishing
	var/isfishing = FALSE
	//Fishing Visuals
	var/list/current_fishing_visuals = list()

/obj/item/fishing_rod/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This rod has a effectiveness of [(FISH_RARITY_BASIC - FishCustomization(900))/10].</span>"

/obj/item/fishing_rod/attackby(obj/item/attacking_item, mob/user, params)
	if(SlotCheck(attacking_item,ROD_SLOT_LINE))
		UseSlot(ROD_SLOT_LINE, user, attacking_item)
		return TRUE
	else if(SlotCheck(attacking_item,ROD_SLOT_HOOK))
		UseSlot(ROD_SLOT_HOOK, user, attacking_item)
		return TRUE
	. = ..()

/obj/item/fishing_rod/afterattack(atom/target, mob/user, proximity_flag)
	if(istype(target, /turf/open/water/deep) && isliving(user) && !isfishing && user.z == target.z)
		if(istype(user.get_inactive_held_item(), /obj/item/fishing_rod))
			to_chat(user, "<span class='notice'>You attempt to cast two lines at once but they get tangled together.</span>")
			return
		//Multicasting is too chaotic
		if(isfishing == TRUE)
			return
		if(!BobberThrow(user, target))
			return
		StartFishing(user, target) //Maybe we can make it call something else with this proc.
		return
	. = ..()

/obj/item/fishing_rod/proc/StartFishing(mob/living/user, turf/open/water/deep/fishing_spot)
	isfishing = TRUE
	user.visible_message("<span class='notice'>[user] begins fishing in [fishing_spot].</span>", "<span class='notice'>You begin fishing.</span>")
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
	for(var/i = 1 to 100)
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

/*Tgstation uses signals and projectiles for their fishing rods
	but im not too familiar with signals so for now
	Bobber throw for checking if there is anything blocking the turf we fish. */
/obj/item/fishing_rod/proc/BobberThrow(mob/living/user, bobber_target)
	var/turf/target_turf = get_turf(bobber_target)
	var/fish_distance = get_dist_euclidian(get_turf(target_turf), get_turf(src))
	if(fish_distance >= 7)
		to_chat(user, "<span class='notice'>The bobber is [round(fish_distance - 7)] tiles short of its destination.</span>")
		return FALSE
	/*Cycles 7 times until it returns. Wallcheck checks the turf after
		this turf and if that turf equals the target turf we return TRUE.
		If the Wallcheck returns a false proc on ClearSky then we return FALSE.
		Clearsky checks if the turf has a window in it or a solid wall. */
	var/turf/this_turf = get_turf(src)
	var/turf/wallcheck
	for(var/i=0 to 7)
		if(this_turf == target_turf)
			return TRUE
		wallcheck = get_step(this_turf, get_dir(this_turf, target_turf))
		if(!ClearSky(wallcheck))
			to_chat(user, "<span class='notice'>The bobber donks off of an obstacle.</span>")
			return FALSE
		this_turf = wallcheck

/*For checking turf to where the bobber lands. Same check as
	/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying. -IP */
/obj/item/fishing_rod/proc/ClearSky(turf/T)
	if(!T || isclosedturf(T) || T == loc)
		return FALSE
	if(locate(/obj/structure/window) in T.contents)
		return FALSE
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			return FALSE
	return TRUE

//Unique Fish Retrieval
/obj/item/fishing_rod/proc/FishLoot(obj/item/fished_thing, mob/living/user, turf/fish_land)
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
/obj/item/fishing_rod/update_overlays()
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

/obj/item/fishing_rod/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
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
/obj/item/fishing_rod/proc/StopFishing()
	if(current_fishing_visuals.len)
		for(var/turf/T in current_fishing_visuals)
			if(!T)
				continue
			T.cut_overlay(current_fishing_visuals[T])
	isfishing = FALSE

	//Registers tiles around bobber.
/obj/item/fishing_rod/proc/RegisterFishingArea(turf/open/fishing_tile)
	if(!isturf(fishing_tile))
		return
	var/list/water_tiles = list()
	for(var/turf/T in range(2, fishing_tile))
		if(!istype(T, fishing_tile.type))
			continue
		LAZYADD(water_tiles, T)
	if(water_tiles.len)
		return water_tiles

/obj/item/fishing_rod/proc/FishShapes(icon_shape, turf/presence_in_water, underwater_shadow = FALSE)
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
/obj/item/fishing_rod/proc/UseSlot(slot, mob/user, obj/item/new_item)
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
/obj/item/fishing_rod/proc/SlotCheck(obj/item/item,slot)
	if(!istype(item))
		return FALSE
	switch(slot)
		if(ROD_SLOT_HOOK)
			if(!istype(item,/obj/item/fishing_component/hook))
				return FALSE
		if(ROD_SLOT_LINE)
			if(!istype(item,/obj/item/fishing_component/line))
				return FALSE
	return TRUE

	//Calculates fishing power
/obj/item/fishing_rod/proc/FishCustomization(fishing_rod_power = 1000)
	if(hook)
		if(istype(hook,/obj/item/fishing_component/hook))
			fishing_rod_power -= hook.fishing_value
	if(line)
		if(istype(line,/obj/item/fishing_component/line))
			fishing_rod_power -= line.fishing_value
	return fishing_rod_power

#undef ROD_SLOT_LINE
#undef ROD_SLOT_HOOK
