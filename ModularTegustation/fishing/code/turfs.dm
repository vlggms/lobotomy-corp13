//you will sink in this. collective branch for both saltwater and freshwater turfs.
/turf/open/water/deep
	name = "water"
	desc = "Deep Water."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
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
		/obj/effect/dummy/phased_mob,
		/obj/effect/yinyang_dragon
		))

/turf/open/water/deep/Initialize()
	. = ..()
	WashedOnTheShore()

/turf/open/water/deep/CanAllowThrough(atom/movable/AM, turf/target)
	. = ..()
	return TRUE

//For fishing nets.
/turf/open/water/deep/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/fishing_net) && params)
		to_chat(user, "<span class='notice'>You start setting up the [C].</span>")
		if(do_after(user, 2 SECONDS, target = user) && C && !locate(/obj/structure/destructible/fishing_net) in src)
			new /obj/structure/destructible/fishing_net(get_turf(src))
			playsound(get_turf(src), 'sound/misc/box_deploy.ogg', 5, 0, 3)
			qdel(C)
			return
	..()

/turf/open/water/deep/Entered(atom/movable/thing, atom/oldLoc) //Sinking Code
	. = ..()
	if(SSmaptype.maptype == "city")
		return
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
		WashedOnTheShore()
	thing.forceMove(target_turf)

//Proc to randomize target_turf
/turf/open/water/deep/proc/WashedOnTheShore()
	if(!static_target)
		if(GLOB.department_centers.len > 0)
			target_turf = pick(GLOB.department_centers)
		else
			target_turf = get_turf(src)

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
		/obj/item/food/fish/fresh_water = FISH_RARITY_BASIC,
		/obj/item/food/fish/fresh_water/angelfish = FISH_RARITY_BASIC,
		/obj/item/food/fish/fresh_water/guppy = FISH_RARITY_BASIC,
		/obj/item/food/fish/fresh_water/plasmatetra = FISH_RARITY_BASIC,
		/obj/item/food/fish/fresh_water/catfish = FISH_RARITY_RARE,
		/obj/item/food/fish/fresh_water/ratfish = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/fresh_water/waterflea = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/fresh_water/yin = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/fresh_water/yang = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/emulsijack = FISH_RARITY_GOOD_LUCK_FINDING_THIS,
		//random things
		/obj/item/stack/spacecash/c1 = 700,
		/obj/item/stack/fish_points = 600,
		/obj/item/food/dough = 500,
		/obj/item/stack/sheet/leather = 500,
		/obj/item/food/canned/peaches = 300,
		/obj/item/food/breadslice/moldy = 300,
		/obj/item/stack/sheet/sinew/wolf = 300,
		/obj/item/clothing/head/beret/tegu/fishing_hat = 200,
		/obj/item/food/grown/harebell = 200,
		/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled = 200,
		/obj/item/fishing_component/hook/bone = 100,
		/mob/living/simple_animal/hostile/retaliate/frog = 50
		)

/turf/open/water/deep/saltwater
	name = "water"
	desc = "Smells of the ocean. Darkness obscures what world might be down there."
	icon_state = "water_turf2"
	environment = list(
		/obj/item/food/fish/salt_water/marine_shrimp = FISH_RARITY_BASIC,
		/obj/item/food/fish/salt_water/clownfish = FISH_RARITY_BASIC,
		/obj/item/food/fish/salt_water/greenchromis = FISH_RARITY_BASIC,
		/obj/item/food/fish/salt_water/firefish = FISH_RARITY_BASIC,
		/obj/item/food/fish/salt_water/cardinal = FISH_RARITY_RARE,
		/obj/item/food/fish/salt_water = FISH_RARITY_RARE,
		/obj/item/food/fish/salt_water/sheephead = FISH_RARITY_RARE,
		/obj/item/food/fish/salt_water/lanternfish = FISH_RARITY_VERY_RARE,
		/obj/item/food/fish/emulsijack = FISH_RARITY_GOOD_LUCK_FINDING_THIS,
		//random things
		/obj/item/stack/spacecash/c1 = 700,
		/obj/item/fishing_component/hook/bone = 700,
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
		/obj/item/food/fish/salt_water/piscine_mermaid = 200,
		/obj/item/food/fish/fresh_water/mosb = 200,
		/obj/item/food/fish/fresh_water/ratfish = 50,
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
