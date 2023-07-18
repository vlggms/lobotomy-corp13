#define FISHSKILLEXP(A) user.mind?.adjust_experience(/datum/skill/fishing, A)
//If we get real fishing in then just delete this stuff -IP
/obj/item/ramshackle_fishing_rod //i hate looking at TGstation fishing since i have no clue how to port it over because modules are not as modular as they say they are.
	name = "ramshackle fishing rod"
	desc = "A tool used to dredge up aquatic entities. Though since the pole is so weak you may as well be handline fishing, a technique where you hold the line with your hands."
	icon = 'icons/obj/aquarium.dmi'
	icon_state = "fishing_rod"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_icon_state = "rod"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_HUGE
	var/isfishing = FALSE
	//Fishing Visuals
	var/list/current_fishing_visuals = list()

/obj/item/ramshackle_fishing_rod/afterattack(atom/target, mob/user, proximity_flag)
	if(istype(target, /turf/open/water/deep) && isliving(user) && !isfishing && user.z == target.z)
		if(istype(user.get_inactive_held_item(), /obj/item/ramshackle_fishing_rod))
			to_chat(user, "<span class='notice'>You attempt to cast two lines at once but they get tangled together.</span>")
			return
		var/fishing_amount = input(user, "How many fish do you want to catch?", "You can choose to fish a maximum of 10 at a time.") as num|null
		fishing_amount = round(fishing_amount)
		if(fishing_amount <= 0)
			return . = ..()
		if(fishing_amount > 10)
			fishing_amount = 10
		//Multicasting is too chaotic
		if(isfishing)
			return
		StartFishing(user, target, fishing_amount) //Maybe we can make it call something else with this proc.
		return
	. = ..()

/obj/item/ramshackle_fishing_rod/proc/StartFishing(mob/living/user, turf/open/water/deep/fishing_spot, amount)
	isfishing = TRUE
	user.visible_message("<span class='notice'>[user] begins fishing in [fishing_spot].</span>", "<span class='notice'>You begin fishing, intent to fish up [amount] things.</span>")
	playsound(get_turf(fishing_spot), 'sound/abnormalities/piscinemermaid/bigsplash.ogg', 20, 0, 3)
	//default fishing skill
	var/fishing_skill = 1
	//thing that is fished up
	var/atom/fished_up_thing
	//fishing visuals, first make a bobber.
	FishShapes("bobber", fishing_spot)
	var/list/fishing_turf = RegisterFishingArea(fishing_spot)
	//redundant check for safety concerns.
	if(!fishing_turf.len)
		StopFishing()
		return
	//copy turf enviorment list
	var/things_to_fish = fishing_spot.environment.Copy()
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
		var/fishing_time = ((15 SECONDS) * fishing_skill) + (rand(1,3) SECONDS)
		if(!do_after(user, fishing_time, target = fishing_spot))
			isfishing = FALSE
			break
		//Do we have the skill? Do we even have a mind?
		if(user.mind)
			fishing_skill = (user.mind.get_skill_modifier(/datum/skill/fishing, SKILL_SPEED_MODIFIER))
			FISHSKILLEXP(1)
		//Fishing successful
		fished_up_thing = pickweight(things_to_fish)
		new fished_up_thing(get_turf(src))
		if(istype(fished_up_thing, /obj/item/fish))
			to_chat(user, "<span class='nicegreen'>You caught [initial(fished_up_thing.name)].</span>")
			if(user.mind)
				FISHSKILLEXP(4)
		playsound(get_turf(src), 'sound/effects/fish_splash.ogg', 18, 0, 3)
	StopFishing()

#undef FISHSKILLEXP

	//Registers tiles around bobber.
/obj/item/ramshackle_fishing_rod/proc/RegisterFishingArea(turf/open/fishing_tile)
	var/list/water_tiles = list()
	for(var/turf/T in range(2, fishing_tile))
		if(!istype(T, fishing_tile.type))
			continue
		LAZYADD(water_tiles, T)
	if(water_tiles.len)
		return water_tiles

/obj/item/ramshackle_fishing_rod/proc/FishShapes(icon_shape, turf/presence_in_water, underwater_shadow = FALSE)
	var/mutable_appearance/under_the_waves = mutable_appearance('icons/obj/aquarium.dmi', icon_shape)
	//IS IT A SHAPE OR IS IT A BOBBER?
	if(underwater_shadow)
		under_the_waves.color = "BLACK"
		under_the_waves.alpha = 100
	//ADD THE OVERLAY TO THE LIST
	current_fishing_visuals += presence_in_water
	current_fishing_visuals[presence_in_water] = under_the_waves
	presence_in_water.add_overlay(under_the_waves)

/obj/item/ramshackle_fishing_rod/proc/StopFishing()
	if(current_fishing_visuals.len)
		for(var/turf/T in current_fishing_visuals)
			if(!T)
				continue
			T.cut_overlay(current_fishing_visuals[T])
	isfishing = FALSE

//FISHING TURFS
	//Unique Fishing Spots
/turf/open/water/deep //you will sink in this. collective branch for both saltwater and freshwater turfs.
	name = "water"
	desc = "Deep Water."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "water_turf1"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	density = TRUE //This is mostly for AI. CanAllowThrough still makes it passable.
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

/turf/open/water/deep/Entered(atom/movable/thing, atom/oldLoc) //Sinking Code
	. = ..()
	if(!target_turf || is_type_in_typecache(thing, forbidden_types) || (thing.throwing && !istype(thing, /obj/item/fish || /obj/item/aquarium_prop )) || (thing.movement_type & (FLOATING|FLYING))) //replace this with a varient of chasm component sometime.
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
		if(istype(thing, /obj/item/fish/emulsijack) && !istype(src, /turf/open/water/deep/polluted)) //Become polluted.
			TerraformTurf(/turf/open/water/deep/polluted)
		qdel(thing)
	//Randomize department that the water dumps you at, and also delay sound so that several items being placed into the deep dont scream.
	if(sound_delay <= world.time)
		playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 20, 0, 3)
		target_turf = pick(GLOB.department_centers)
		sound_delay = world.time + (3 SECONDS)
	thing.forceMove(target_turf)

/turf/open/water/deep/freshwater
	name = "water"
	desc = "Bodies of freshwater like these usually have stories of aquatic predators that assault fishermen."
	icon_state = "water_turf1"
	environment = list(
		/obj/item/fish/goldfish = FISH_RARITY_BASIC,
		/obj/item/fish/angelfish = FISH_RARITY_BASIC,
		/obj/item/fish/guppy = FISH_RARITY_BASIC,
		/obj/item/fish/plasmatetra = FISH_RARITY_BASIC,
		/obj/item/fish/catfish = FISH_RARITY_RARE,
		/obj/item/fish/ratfish = FISH_RARITY_VERY_RARE,
		/obj/item/fish/waterflea = FISH_RARITY_VERY_RARE,
		/obj/item/fish/yin = FISH_RARITY_VERY_RARE,
		/obj/item/fish/yang = FISH_RARITY_VERY_RARE,
		/obj/item/fish/emulsijack = FISH_RARITY_GOOD_LUCK_FINDING_THIS,
		//random things
		/obj/item/food/dough = 500,
		/obj/item/stack/sheet/leather = 500,
		/obj/item/food/canned/peaches = 300,
		/obj/item/aquarium_prop/rocks = 300,
		/obj/item/aquarium_prop/seaweed = 300,
		/obj/item/food/breadslice/moldy = 300,
		/obj/item/stack/sheet/sinew/wolf = 300,
		/obj/item/clothing/head/beret/tegu/fishing_hat = 200,
		/obj/item/food/grown/harebell = 200)

/turf/open/water/deep/saltwater
	name = "water"
	desc = "Smells of the ocean. Darkness obscures what world might be down there."
	icon_state = "water_turf2"
	environment = list(
		/obj/item/fish/marine_shrimp = FISH_RARITY_BASIC,
		/obj/item/fish/clownfish = FISH_RARITY_BASIC,
		/obj/item/fish/greenchromis = FISH_RARITY_BASIC,
		/obj/item/fish/firefish = FISH_RARITY_BASIC,
		/obj/item/fish/cardinal = FISH_RARITY_RARE,
		/obj/item/fish/pufferfish = FISH_RARITY_RARE,
		/obj/item/fish/sheephead = FISH_RARITY_RARE,
		/obj/item/fish/lanternfish = FISH_RARITY_VERY_RARE,
		/obj/item/fish/emulsijack = FISH_RARITY_GOOD_LUCK_FINDING_THIS,
		//random things
		/obj/item/food/canned/beans = 300,
		/obj/item/food/canned/peaches = 300,
		/obj/item/aquarium_prop/rocks = 300,
		/obj/item/aquarium_prop/seaweed = 300,
		/obj/item/clothing/head/beret/tegu/fishing_hat = 200,
		/mob/living/simple_animal/hostile/shrimp = 100
		)

/turf/open/water/deep/polluted
	name = "polluted water"
	desc = "An aquatic deadzone, your more likely to reel in junk due to the inhospitable enviorment."
	icon_state = "water_turf2"
	color = "GREEN"
	environment = list(
		/obj/item/fish/emulsijack = 10,
		//random things
		/obj/item/food/tofu/prison = 1000,
		/obj/item/food/meat/slab/human/mutant/zombie = 1000,
		/obj/item/food/dough = 500,
		/obj/item/stack/sheet/leather = 500,
		/mob/living/simple_animal/hostile/shrimp = 400,
		/obj/item/food/canned/peaches = 300,
		/obj/item/food/breadslice/moldy = 300,
		/obj/item/stack/sheet/sinew/wolf = 300,
		/obj/item/food/canned/beans = 300,
		/obj/item/food/canned/peaches = 300,
		/obj/item/reagent_containers/food/drinks/bottle/small = 300,
		/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled = 300,
		/obj/item/stack/sheet/plastic = 300,
		/obj/item/aquarium_prop/rocks = 300,
		/obj/item/aquarium_prop/seaweed = 300,
		/obj/item/aquarium_prop/lcorp = 300,
		/obj/item/food/spiderling = 200,
		/obj/item/food/grown/harebell = 200,
		/obj/item/stack/sheet/mineral/wood = 200,
		/obj/item/ego_weapon/city/rats/brick = 100
		)
