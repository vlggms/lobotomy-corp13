#define STATUS_EFFECT_PBEACON /datum/status_effect/pbeacon
//Crates
/obj/structure/closet/crate/pcorp
	name = "P-Corp quik tm crate"
	drag_slowdown = -0.2
	desc = "A rectangular crate stamped with Pcorp's logo. This one surprisingly speeds you up as you drag it. Holds less items than you'd like however."
	icon_state = "pcorp_crate"
	allow_dense = FALSE
	storage_capacity = 3

//Belts
/obj/item/storage/belt/egopcorp
	name = "ego heavy arms belt"
	desc = "Holds a pair of large ego weapons."
	icon_state = "assaultbelt"
	inhand_icon_state = "assaultbelt"
	worn_icon_state = "assaultbelt"
	content_overlays = FALSE
	custom_premium_price = PAYCHECK_MEDIUM * 2
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbelt_pickup.ogg'
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1

/obj/item/storage/belt/egopcorp/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(list(
		/obj/item/ego_weapon/ranged,
		/obj/item/ego_weapon,
	))

/obj/item/storage/belt/egoarmor
	name = "ego armor belt"
	desc = "Holds up to 3 EGO gear."
	icon_state = "grenadebeltold"
	inhand_icon_state = "grenadebeltold"
	worn_icon_state = "grenadebeltold"
	content_overlays = FALSE
	custom_premium_price = PAYCHECK_MEDIUM * 2
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbelt_pickup.ogg'
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1

/obj/item/storage/belt/egoarmor/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(list(
		/obj/item/clothing/suit/armor/ego_gear,
	))

//Heavy backpacks
/obj/item/storage/backpack/pcorp
	name = "pcorp large backpack"
	desc = "You wear this on your back and put items into it. Holds 3 of any bulky item. Slows you down slightly."
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	slowdown = 0.1
	drag_slowdown = 1

/obj/item/storage/backpack/pcorp/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 3

/obj/item/storage/backpack/pcorpheavy
	name = "pcorp massive backpack"
	desc = "You wear this on your back and put items into it. Holds 5 of any bulky item. Slows you down."
	icon_state = "holdingpack"
	inhand_icon_state = "holdingpack"
	slowdown = 0.25
	drag_slowdown = 1

/obj/item/storage/backpack/pcorpheavy/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 50
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 5

//Pouches
/obj/item/storage/pcorp_pocket
	name = "P-Corp Deep Pocket"
	desc = "Put onto your pocket to hold any 4 small items."
	icon_state = "ppouch"
	inhand_icon_state = "ppouch"
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/pcorp_pocket/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 4


//Pouches
/obj/item/storage/pcorp_weapon
	name = "P-Corp Small Weapon Holster"
	desc = "Put onto your pocket to hold any small EGO weapon."
	icon_state = "pweapon"
	inhand_icon_state = "pweapon"
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/pcorp_weapon/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 32
	STR.set_holdable(GLOB.small_ego)


//Gloves
/obj/item/clothing/gloves/pcorp
	name = "P-Corp Dimensional Containment Gloves"
	desc = "Holds 3 small ego weapons."
	icon_state = "tackledolphin"
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1
	var/component_type = /datum/component/storage/concrete

/obj/item/clothing/gloves/pcorp/ComponentInitialize()
	. = ..()
	AddComponent(component_type)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(GLOB.small_ego)

//better gloves
/obj/item/clothing/gloves/pcorpbig
	name = "P-Corp Dimensional Containment Gloves MK2"
	desc = "Holds a single large EGO weapon."
	icon_state = "pcorp"
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1
	var/component_type = /datum/component/storage/concrete

/obj/item/clothing/gloves/pcorpbig/ComponentInitialize()
	. = ..()
	AddComponent(component_type)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(list(
		/obj/item/ego_weapon,
	))

// Food
/obj/item/food/canned/pcorp_icecream
	name = "P-corp canned ice cream"
	desc = "P corp's specialty canned ice cream."
	icon_state = "pcorp_icecream"
	trash_type = /obj/item/trash/can/food/pcorp_icecream
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/sal_acid = 5)
	tastes = list("strawberry" = 1, "mint" = 1, "chocolate" = 1,"butterscotch" = 1)
	foodtypes = DAIRY | SUGAR

/obj/item/food/canned/pcorp_burger
	name = "P-corp canned burger"
	desc = "P corp's specialty canned burger."
	icon_state = "burgercan"
	trash_type = /obj/item/trash/can/food/pcorp_burger
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("bun" = 2, "beef patty" = 4)
	foodtypes = GRAIN | MEAT

// Food Trash
/obj/item/trash/can/food/pcorp_icecream
	name = "canned ice cream"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "pcorp_icecream_empty"

/obj/item/trash/can/food/pcorp_burger
	name = "canned burger"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "burgercan_empty"

//Safety
/obj/item/pcorp_beacon
	name = "P-Corp Safety Beacon"
	desc = "P Corp device that once activated will designate a safezone, if user enters a critical state they will be reallocated to their safezone."
	icon = 'icons/obj/objects.dmi'
	icon_state = "oldshieldoff" //Placeholder

/obj/item/pcorp_beacon/attack_self(mob/living/user)
	to_chat(user, span_notice("You activate the device and it suddenly begins to whir louder and louder until it throws itself onto the ground"))
	new /obj/structure/pcorp_beacon(get_turf(user))
	if(ishuman(user))
		user.apply_status_effect(STATUS_EFFECT_PBEACON) //a status effect lets me make it automatic
	qdel(src)

/obj/structure/pcorp_beacon
	name = "pulsing P-Corp safety beacon"
	desc = "A beacon magnetically stuck to the floor, the beacon seems registered to a life signal."
	icon = 'icons/obj/objects.dmi'
	icon_state = "oldshieldon" //Placeholder
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/pcorp_beacon/Initialize()
	. = ..()

	GLOB.lobotomy_devices += src

/obj/structure/pcorp_beacon/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

/datum/status_effect/pbeacon
	id = "pcorp_beacon"
	alert_type = null

/datum/status_effect/pbeacon/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/dangersanity = (H.maxSanity * 0.2)
	if(!H.is_working)
		if(H.sanityhealth <= dangersanity || H.health <= HEALTH_THRESHOLD_CRIT) //checks if youre going down
			Preserve(H)

/datum/status_effect/pbeacon/proc/BeaconList()
	var/list/beaconspots = list()

	for(var/obj/structure/pcorp_beacon/beacon in GLOB.lobotomy_devices)
		var/turf/T = get_turf(beacon)
		if(!is_centcom_level(T.z))
			beaconspots += T

	return beaconspots

/datum/status_effect/pbeacon/proc/Preserve(mob/living/carbon/human/H)
	var/list/L = BeaconList()
	if(!L.len)
		to_chat(H, span_notice("We regret to inform you there are no existing P-Corp beacons nearby for your retrieval, if you believe this a error notify officials."))
		H.remove_status_effect(src) //You failed, tf2loss.mp3. The only way this can trigger is a admin deleted your beacon or you somehow got to centcomm.
		return
	var/chosen_beacon = pick(L)
	new /obj/effect/temp_visual/emp/pulse(get_turf(H))
	H.visible_message(span_notice("[H] is suddenly warped away by their P-Corp safety beacon!"))
	H.forceMove(chosen_beacon)
	var/turf/T = get_turf(H)
	for(var/obj/structure/pcorp_beacon/useless in T)
		qdel(useless) //Get rid of the used beacon
	H.remove_status_effect(src) //We finished everything

//Fishing
/obj/item/cannerypod
	name = "P-Corp compressed cannery pod"
	desc = "This is a entire cannery compressed into a small machine, for transport this machine has been compressed into a pod and once deployed cannot be returned to it's pod."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "prox" //Placeholder

/obj/item/cannerypod/attack_self(mob/living/user)
	to_chat(user, span_notice("You activate the pod and countless components fall out then assemble themselves into a brand new machine."))
	new /obj/machinery/cannery(get_turf(user))
	qdel(src)

//This is litteraly just fish market code
/obj/machinery/cannery
	name = "P-Corp fishing cannery"
	desc = "A machine filled with whirring components. It appears that it turns the parts of a fish into raw canned Enkephalin."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "fish_cannery"
	density = FALSE
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/cannery/attackby(obj/item/I, mob/user, params)
	if(SSfishing.IsAligned(/datum/planet/uranus))
		to_chat(user, span_notice("Uranus is aligned with earth. All enkephalin output increased by 1.5x"))
	if(istype(I, /obj/item/stack/fish_points))
		var/obj/item/stack/fish_points/more_points = I
		AdjustPE(more_points.amount)
		qdel(I)
		return
	if(istype(I, /obj/item/food/fish))
		AdjustPE(ValueFish(I))
		qdel(I)
		return
	if(istype(I, /obj/item/fishing_component/hook/bone))
		AdjustPE(5)
		to_chat(user, span_notice("Thank you for notifying us of this object.Enkephalin rewarded."))
		playsound(get_turf(src), 'sound/machines/machine_vend.ogg', 10, TRUE)
		qdel(I)
		return
	if(istype(I, /obj/item/storage/bag/fish))
		var/obj/item/storage/bag/fish/bag = I
		var/fish_value = 0
		for(var/item in bag.contents)
			if(istype(item, /obj/item/stack/fish_points))
				continue

			if(istype(item, /obj/item/fishing_component/hook/bone))
				fish_value += 5

			if(istype(item, /obj/item/food/fish))
				fish_value += ValueFish(item)

			qdel(item)

		AdjustPE(fish_value)
	return ..()

/obj/machinery/cannery/proc/AdjustPE(new_pe)
	var/pe_gained
	pe_gained = (new_pe * 2) //Multiplies the value of fish to see how much PE its worth
	SSlobotomy_corp.AdjustGoalBoxes(pe_gained)

/*Values Fish im too tired to add anything like
	size and weight considerations. Today was
	a long day, the rarity values are inverted because
	its 1000 for a basic fish and 1 for the most rare fish.-IP */
/obj/machinery/cannery/proc/ValueFish(obj/item/food/fish/F)
	//Fish Value based on weight and size.
	var/fish_weight = (F.weight - F.average_weight) / F.average_weight
	var/fish_size = (F.size - F.average_size) / F.average_size
	var/fish_worth_mod = 1 + fish_weight + fish_size
	if(SSfishing.IsAligned(/datum/planet/uranus))
		fish_worth_mod *= 1.5	//Bonus if uranus is aligned

	/*Fish Value based on rarity 2 is
		the worth of fish that are basic.*/
	var/fish_worth = 2
	switch(F.random_case_rarity)
		if(0 to FISH_RARITY_GOOD_LUCK_FINDING_THIS)
			fish_worth = 100
		if((FISH_RARITY_GOOD_LUCK_FINDING_THIS + 1) to FISH_RARITY_VERY_RARE)
			fish_worth = 50
		if((FISH_RARITY_VERY_RARE + 1) to FISH_RARITY_RARE)
			fish_worth = 10
	return round(fish_worth * fish_worth_mod)

/obj/item/pondpod
	name = "P-Corp compressed pond pod"
	desc = "This P Corp pod contains a entire ecosystem compressed into a small pond, once deployed the contents of this pod cannot be returned."
	icon = 'icons/obj/aquarium.dmi' //Placeholder
	icon_state = "construction_kit" //Once more placeholder, tg has a sprite for this which we can maybe borrow

/obj/item/pondpod/attack_self(mob/living/user)
	to_chat(user, span_notice("As you open the pod you see water and countless fish spill out, when you turn your eyes to the floor you see a small bottomless pond has formed."))
	new /turf/open/water/deep/pond(get_turf(user))
	qdel(src)

//The other option for this is making a structure that replicates all the code of a water turf
/turf/open/water/deep/pond
	name = "compressed pond"
	desc = "For such a small pond there is no visible bottom, even though the water is only knee deep..."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "pcorppond"
	baseturfs = /turf/open/floor/plating/asteroid
	safe = TRUE
	//These are the fishing pools of all water turfs combined, gotta have something to make players buy it
	loot_level1 = list(
		/obj/item/food/fish/salt_water/marine_shrimp = 40,
		/obj/item/food/fish/fresh_water/guppy = 25,
		/obj/item/food/fish/salt_water/greenchromis = 20,
		/obj/item/food/fish/salt_water/firefish = 20,
		/obj/item/food/fish/fresh_water/angelfish = 20,
		/obj/item/food/fish/fresh_water/plasmatetra = 15,
		/obj/item/food/fish/fresh_water/perch = 15,
		/obj/item/food/fish/salt_water/clownfish = 10,
	)
	loot_level2 = list(
		/obj/item/food/fish/fresh_water/catfish = 35,
		/obj/item/food/fish/fresh_water/ratfish = 35,
		/obj/item/food/fish/siltcurrent = 25,
		/obj/item/food/fish/salt_water/cardinal = 25,
		/obj/item/food/fish/trout = 20,
		/obj/item/food/fish/fresh_water/salmon = 15,
		/obj/item/food/fish/fresh_water/bass = 10,
		/obj/item/food/fish/fresh_water/eel = 10,
		/obj/item/food/fish/salt_water/sheephead = 10,
		/obj/item/food/fish/salt_water/blue_tang = 10,
		/obj/item/food/fish/salt_water/tuna_pallid = 10,
		/obj/item/clothing/head/beret/fishing_hat = 10,
		/obj/item/food/fish/salt_water/seabunny = 5,
		/obj/item/food/fish/salt_water/squid = 5,
		/obj/item/food/fish/emulsijack = 1,
	)
	loot_level3 = list(
		/obj/item/food/fish/siltcurrent = 60,
		/obj/item/food/fish/salt_water/lanternfish = 45,
		/obj/item/food/fish/salt_water/piscine_mermaid = 45,
		/obj/item/food/fish/emulsijack = 40,
		/obj/item/food/fish/fresh_water/ratfish = 25,
		/obj/item/food/fish/fresh_water/mosb = 25,
		/obj/item/food/fish/salt_water/tuna_pallid = 25,
		/obj/item/food/fish/fresh_water/waterflea = 20,
		/obj/item/food/fish/fresh_water/yin = 20,
		/obj/item/food/fish/fresh_water/yang = 20,
		/obj/item/food/fish/salt_water/lobster = 15,
		/obj/item/food/fish/salt_water/smolshark = 10,
		/mob/living/simple_animal/crab = 10,
		/obj/item/food/fish/fresh_water/boxin_man = 10,
		/obj/item/food/fish/fresh_water/walkin_man = 10,
		/obj/item/food/fish/salt_water/fishmael = 8,
		/obj/item/food/fish/fresh_water/weever_blue_album = 6,
		/obj/item/food/fish/fresh_water/unidentifiedfishobject = 5,
		/obj/item/food/fish/salt_water/searabbit = 5,
		/obj/item/food/fish/fresh_water/ufo = 5,
		/obj/item/food/fish/salt_water/deep_fry = 5,
		/obj/item/food/fish/salt_water/pigfish = 5,
		/obj/item/food/fish/fresh_water/unidentifiedfishobject = 1,
	)

/turf/open/water/deep/pond/IsSafe()
	return TRUE

#undef STATUS_EFFECT_PBEACON
