//Coded and sprited by Coxswain
/mob/living/simple_animal/hostile/abnormality/fallen_amurdad
	name = "Fallen Amurdad"
	desc = "This person is unresponsive, bleeding, and covered in plants."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "amurdad"
	icon_living = "amurdad"
	portrait = "fallen_amurdad"
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(70, 60, 50, 50, 50),
	)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/nightshade,
		/datum/ego_datum/armor/nightshade,
	)
	gift_type = /datum/ego_gifts/nightshade
	gift_message = "The lifeless body of amurdad hands you a flower."
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "The sweet stench of rot and decay hit you before you noticed the source was the bleeding person covered in plants. <br>\
		His lips gape open and close like a fish's and what little strength he has in his limbs, he uses to beckons you closer..."
	observation_choices = list(
		"Get closer and listen" = list(TRUE, "You bend down and lend your ear to his mouth... <br>You hear the words you've been waiting your whole life to hear."),
		"Leave" = list(FALSE, "The man clearly needs help, you rush to find a medic."),
	)

	var/seed_list = list(
		/obj/item/seeds/grass/fairy,
		/obj/item/seeds/apple/gold,
		/obj/item/seeds/ambrosia/gaia,
		/obj/item/seeds/wheat/meat,
		/obj/item/seeds/cherry/bulb,
		/obj/item/seeds/corn/snapcorn,
		/obj/item/seeds/cocoapod/bungotree,
		/obj/item/seeds/cocoapod/vanillapod,
		/obj/item/seeds/tobacco/space,
		/obj/item/seeds/berry/glow/amurdad,
		/obj/item/seeds/cannabis/white/amurdad,
		/obj/item/seeds/harebell,
		/obj/item/seeds/amanita/amurdad,
		/obj/item/seeds/starthistle/amurdad,
		/obj/item/seeds/galaxythistle/amurdad,
		/obj/item/seeds/peas/worldpeas,
		/obj/item/seeds/corpseflower,
		/obj/item/seeds/jupitercup,
	)

	/// How many bombs are placed on breach.
	var/max_bombs = 12

//Start us off with some soil trays and grass
/mob/living/simple_animal/hostile/abnormality/fallen_amurdad/PostSpawn()
	..()
	var/list/soil_area = range(1, src)
	if((locate(/obj/machinery/hydroponics/soil/amurdad) in soil_area))
		return
	for(var/turf/open/O in soil_area)
		new /obj/effect/amurdad_grass(O)
	for(var/dir in GLOB.alldirs)
		var/turf/T = get_step(src, dir)
		new /obj/machinery/hydroponics/soil/amurdad(T)

//Work-related code
/mob/living/simple_animal/hostile/abnormality/fallen_amurdad/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	..()
	if(canceled)
		return
	for(var/obj/machinery/hydroponics/soil/amurdad/S in range(1, src))
		if(S.myseed)
			continue
		S.Fill(pick(seed_list))
		if(prob(30))
			break

// Pink Midnight stuff
/mob/living/simple_animal/hostile/abnormality/fallen_amurdad/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		var/turf/DC = pick(GLOB.department_centers)
		var/list/potential_area = spiral_range_turfs(15, DC)
		var/list/remove_list = list()
		for(var/turf/T in potential_area)
			if(T.density)
				remove_list += T
				continue
			if(T.z != z)
				remove_list += T
				continue
			if(istype(T.loc, /area/containment_zone))
				remove_list += T
				continue
			if(istype(T, /turf/open/floor/plating))
				remove_list += T
				continue
			if(istype(T, /turf/open/floor/circuit))
				remove_list += T
				continue
			for(var/obj/O in T)
				if(O.density)
					remove_list += T
					break

		potential_area -= remove_list
		var/bombs = 0
		while((bombs < max_bombs) && potential_area.len > 0)
			var/turf/open/T = pick(potential_area)
			var/list/seen_area = view(3, T)
			var/loop = FALSE
			for(var/obj/structure/amurdad_bomb/AB in seen_area)
				potential_area -= seen_area
				loop = TRUE
				break
			if(loop)
				continue
			new /obj/structure/amurdad_bomb(T)
			bombs++
		return TRUE
	return ..()

//Magic bullshit amurdad soil
/obj/machinery/hydroponics/soil/amurdad
	self_sustaining = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/machinery/hydroponics/soil/amurdad/proc/Fill(seed) //abnormality plants seeds for you
	myseed = new seed
	dead = FALSE
	age = 1
	plant_health = myseed.endurance
	lastcycle = world.time
	update_icon()
	TRAY_NAME_UPDATE
	return

/obj/machinery/hydroponics/soil/amurdad/adjustWeeds(adjustamt) //no weeds!
	return

/obj/machinery/hydroponics/soil/amurdad/pollinate(range) //Quality of Life for the initial harvest.
	return

/obj/machinery/hydroponics/soil/amurdad/attackby(obj/item/O, mob/user, params) //no manual planting
	if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/sample))
		return
	if(O.tool_behaviour == TOOL_SHOVEL && !istype(O, /obj/item/shovel/spade)) //no digging it up either
		return
	..()

/obj/effect/amurdad_grass //Doesn't allow repeatable harvest plants to be repeatable.
	name = "grass"
	desc = "A thick layer of foilage that never seems to die down."
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass0"
	layer = TURF_LAYER
	anchored = TRUE

/obj/effect/amurdad_grass/Initialize()
	. = ..()
	icon_state = "grass[rand(0,3)]"

// Non-toxic varieties of normal plants
/obj/item/seeds/berry/glow/amurdad
	genes = list(/datum/plant_gene/trait/glow/white)
	reagents_add = list(
		/datum/reagent/iodine = 0.2,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1,
	)

/obj/item/seeds/cannabis/white/amurdad
	genes = list()
	reagents_add = list(
		/datum/reagent/drug/space_drugs = 0.15,
		/datum/reagent/medicine/omnizine = 0.35,
	)

/obj/item/seeds/amanita/amurdad
	reagents_add = list(
		/datum/reagent/drug/space_drugs = 0.15,
		/datum/reagent/consumable/nutriment = 0.04,
		/datum/reagent/growthserum = 0.1,
	)

// Modified Weeds
/obj/item/seeds/starthistle/amurdad
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	product = /obj/item/food/grown/starthistle
	reagents_add = list(
		/datum/reagent/consumable/nutriment = 0.05,
		/datum/reagent/medicine/silibinin = 0.1,
		)


/obj/item/food/grown/starthistle
	seed = /obj/item/seeds/starthistle/amurdad
	name = "starthistle flower head"
	desc = "This spiny cluster of florets reminds you of the backstreets."
	icon_state = "lily"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	wine_power = 35
	tastes = list("thistle" = 2, "artichoke" = 1)

/obj/item/seeds/galaxythistle/amurdad
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)

// Custom plants
/obj/item/seeds/peas/worldpeas
	name = "pack of world peas"
	desc = "These seeds look a bit odd, but they should grow into World Peas."
	icon_state = "seed-worldpeas"
	species = "worldpeas"
	plantname = "World Peas"
	product = /obj/item/food/grown/worldpeas
	maturation = 7
	potency = 10
	yield = 7
	production = 5
	growthstages = 3
	icon_grow = "worldpeas-grow"
	icon_dead = "worldpeas-dead"
	genes = list ()
	mutatelist = list ()
	reagents_add = list (
		/datum/reagent/consumable/sugar = 0.05,
		/datum/reagent/consumable/nutriment = 0.07,
		/datum/reagent/consumable/wellcheers_white = 0.03,
	)
	rarity = 30

/obj/item/food/grown/worldpeas
	seed = /obj/item/seeds/peas/worldpeas
	name = "pod of world peas"
	desc = "They make the world go round. Not sure what sort of effects eating this might have..."
	icon_state = "worldpeas"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	tastes = list ("an oyster" = 1)
	wine_power = 90
	wine_flavor = "a drunken oyster... or maybe a clam?"

/obj/item/seeds/corpseflower
	name = "pack of corpseflower"
	desc = "These seeds grow into a big, smelly flower."
	icon_state = "seed-corpse-flower"
	species = "corpseflower"
	plantname = "Corpse Flower"
	product = /obj/item/food/grown/corpseflower
	lifespan = 100
	endurance = 20
	maturation = 7
	production = 1
	yield = 2
	potency = 30
	instability = 1
	growthstages = 4
	icon_grow = "corpse-flower-grow"
	icon_dead = "corpse-flower-dead"
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	reagents_add = list(
		/datum/reagent/consumable/nutriment = 0.07,
		/datum/reagent/drug/amurdad = 0.07,
	)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/food/grown/corpseflower
	seed = /obj/item/seeds/corpseflower
	name = "corpse flower pedal"
	desc = "A gigantic corpse flower pedal, it smells disgusting. Noticably used as a spice in district 23."
	icon_state = "corpseflower"
	bite_consumption_mod = 3
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth
	tastes = list ("a corpse" = 4, "long pig" = 2)
	wine_power = 90
	wine_flavor = "a corpse, or maybe a pile of them."

/obj/item/seeds/jupitercup
	name = "pack of jupiter-cup mycelium"
	desc = "This mycelium grows into jupiter-cup mushrooms."
	icon_state = "mycelium-jupitercup"
	species = "jupitercup"
	plantname = "Jupiter-Cups"
	product = /obj/item/food/grown/mushroom/jupitercup
	maturation = 7
	production = 1
	yield = 5
	potency = 15
	instability = 10
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(
		/datum/reagent/consumable/nutriment = 0.07,
		/datum/reagent/consumable/sugar = 0.07,
		/datum/reagent/consumable/wellcheers_red = 0.03,
	)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/jupitercup
	seed = /obj/item/seeds/jupitercup
	name = "jupiter-cup"
	desc = "This has to be eaten carefully."
	icon_state = "jupitercup"

/obj/structure/amurdad_bomb
	name = "Rising Amurdad"
	desc = "A mound of soil growing something...\nIt reinforces nearby plants."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "soil"
	density = TRUE
	anchored = TRUE
	max_integrity = 300
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 0)
	var/stage = 0
	var/grow_interval = 5 SECONDS
	var/list/protected_plants = list()

/obj/structure/amurdad_bomb/Initialize()
	. = ..()
	Grow()
	proximity_monitor = new(src, 1)

/obj/structure/amurdad_bomb/proc/ProtectPlants()
	for(var/obj/structure/spreading/apple_vine/AV in view(2, src))
		if(AV in protected_plants)
			AV.obj_integrity += 50
			continue
		protected_plants += AV
		AV.max_integrity = 300
		AV.obj_integrity = 300

/obj/structure/amurdad_bomb/proc/Grow()
	stage = stage + 1 > 5 ? 5 : stage + 1
	UpdateStage()
	ProtectPlants()
	if(stage >= 5)
		return
	addtimer(CALLBACK(src, PROC_REF(Grow)), grow_interval)

/obj/structure/amurdad_bomb/proc/UpdateStage()
	cut_overlays()
	if(stage == 0)
		return
	var/mutable_appearance/plant_overlay = mutable_appearance('icons/obj/hydroponics/growing.dmi', "deathnettle-grow[stage]", layer = OBJ_LAYER + 0.01)
	add_overlay(plant_overlay)

/obj/structure/amurdad_bomb/HasProximity(atom/movable/AM)
	if(stage <= 4)
		return
	if(!isliving(AM))
		return
	if(isbot(AM))
		return
	var/mob/living/L = AM
	if(("hostile" in L.faction))
		return
	Explode()

/obj/structure/amurdad_bomb/bullet_act(obj/projectile/P)
	. = ..()
	if(stage <= 3)
		return
	Explode()

/obj/structure/amurdad_bomb/proc/Explode()
	var/list/all_the_turfs_were_gonna_lacerate = RANGE_TURFS(stage, src) - RANGE_TURFS(stage-1, src)
	stage = 0
	UpdateStage()
	for(var/turf/shootat_turf in all_the_turfs_were_gonna_lacerate)
		INVOKE_ASYNC(src, PROC_REF(FireProjectile), shootat_turf)
	addtimer(CALLBACK(src, PROC_REF(Grow)), grow_interval)

/obj/structure/amurdad_bomb/proc/FireProjectile(atom/target)
	var/obj/projectile/P = new /obj/projectile/needle(get_turf(src))

	P.spread = 0
	if(prob(25))
		P.original = target // Allows roughly 25% of them to hit the activator who's prone
	P.fired_from = src
	P.firer = src
	P.impacted = list(src = TRUE)
	P.suppressed = SUPPRESSED_QUIET
	P.preparePixelProjectile(target, src)
	P.fire()

/obj/projectile/needle
	name = "venomous needle"
	desc = "a venomous thorn from a plant"
	icon_state = "needle"
	ricochet_chance = 60
	ricochets_max = 2
	damage = 1
	damage_type = RED_DAMAGE
	eyeblur = 2
	ricochet_ignore_flag = TRUE

/obj/projectile/needle/can_hit_target(atom/target, direct_target, ignore_loc, cross_failed)
	if(!fired)
		return FALSE
	return ..()

/obj/projectile/needle/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.reagents.add_reagent(/datum/reagent/toxin/amurdad_poison, 10)

/datum/reagent/toxin/amurdad_poison
	name = "Fallen Nightshade"
	description = "A poison that corrupts the blood and turns the stomach foul."
	taste_description = "iron"
	glass_name = "glass of fallen nightshade"
	glass_desc = "It smells of roses and yet looks awful."
	color = "#433748"
	can_synth = FALSE
	harmful = TRUE
	toxpwr = 0
	metabolization_rate = REAGENTS_METABOLISM * 4

/datum/reagent/toxin/amurdad_poison/on_mob_metabolize(mob/living/L)
	. = ..()
	to_chat(L, span_warning("You feel nauseous..."))

/datum/reagent/toxin/amurdad_poison/on_mob_end_metabolize(mob/living/L)
	. = ..()
	to_chat(L, span_danger("You start to feel better."))

/datum/reagent/toxin/amurdad_poison/on_mob_life(mob/living/M)
	var/damage_mod = 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/liver/LV = locate() in H.internal_organs
		if(volume <= LV.toxTolerance)
			return ..()
		damage_mod = LV.toxLethality * 100
	metabolization_rate = max(volume * REAGENTS_METABOLISM, REAGENTS_METABOLISM)
	M.deal_damage((volume * REAGENTS_METABOLISM * damage_mod), RED_DAMAGE)
	if(ishuman(M))
		if(DT_PROB(3, 6))
			var/mob/living/carbon/human/H = M
			H.vomit(10, FALSE, FALSE, 2)
	return ..()
