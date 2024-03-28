// A vending machine that is a mob type. My descent into madness continues.
/mob/living/simple_animal/hostile/abnormality/wellcheers
	name = "Wellcheers Vending Machine"
	desc = "A vending machine selling cans of \"Wellcheers\"."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "wellcheers_vendor"
	icon_living = "wellcheers_vendor"
	portrait = "wellcheers"
	layer = BELOW_OBJ_LAYER
	threat_level = ZAYIN_LEVEL
	maxHealth = 600
	health = 600
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 70, 60, 60, 60),
		ABNORMALITY_WORK_INSIGHT = list(70, 70, 60, 60, 60),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40),
	)
	work_damage_amount = 1
	work_damage_type = RED_DAMAGE
	max_boxes = 10

	blood_volume = 0

	ranged = TRUE
	ranged_message = "launches a can"
	ranged_cooldown_time = 3 SECONDS
	retreat_distance = 4
	check_friendly_fire = TRUE
	projectiletype = /obj/projectile/wellcheers
	var/projectile_list = list(
		/obj/projectile/wellcheers,
		/obj/projectile/wellcheers/white,
		/obj/projectile/wellcheers/purple,
	)
	projectilesound = 'sound/machines/machine_vend.ogg'

	faction = list("shrimp")

	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/soda,
		/datum/ego_datum/armor/soda,
	)
	gift_type = /datum/ego_gifts/soda
	gift_message = "You feel like you've been doing this your whole life."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/shrimp_exec = 1.5,
	)

	chem_type = /datum/reagent/abnormality/wellcheers_zero
	harvest_phrase = span_notice("The machine dispenses some clear-ish soda into %VESSEL.")
	harvest_phrase_third = "%PERSON holds up %VESSEL and lets %ABNO dispense some clear-ish soda into it."

/mob/living/simple_animal/hostile/abnormality/wellcheers/HandleStructures()
	. = ..()
	if(!.)
		return
	if(locate(/obj/structure/wellcheers_side_shrimp) in datum_reference.connected_structures)
		return
	SpawnConnectedStructure(/obj/structure/wellcheers_side_shrimp, 1)
	SpawnConnectedStructure(/obj/structure/wellcheers_side_shrimp, -1)

/mob/living/simple_animal/hostile/abnormality/wellcheers/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/obj/item/dropped_can
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			dropped_can = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red
		if(ABNORMALITY_WORK_INSIGHT)
			dropped_can = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white
		else
			dropped_can = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple
	if(!dropped_can)
		return
	var/turf/dispense_turf = get_step(src, pick(NORTH, SOUTH, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
	dropped_can = new dropped_can(dispense_turf)
	playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE)
	visible_message(span_notice("[src] dispenses [dropped_can]."))
	return

// Death!
/mob/living/simple_animal/hostile/abnormality/wellcheers/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	// Visual effects
	for(var/obj/structure/wellcheers_side_shrimp/shrimp in datum_reference.connected_structures)
		shrimp.ShrimpDance()
	for(var/turf/open/T in view(7, src))
		new /obj/effect/temp_visual/water_waves(T)

	// Actual effects
	playsound(get_turf(src), 'sound/abnormalities/wellcheers/ability.ogg', 75, 0)
	to_chat(user, span_userdanger("You feel sleepy..."))
	user.AdjustSleeping(10 SECONDS)
	var/shrimpspot = locate(/obj/effect/landmark/shrimpship) in world.contents
	animate(user, alpha = 0, time = 2 SECONDS)
	sleep(2 SECONDS)
	user.forceMove(get_turf(shrimpspot)) // Happy fishing!
	animate(user, alpha = 255, time = 0 SECONDS)
	return

/mob/living/simple_animal/hostile/abnormality/wellcheers/OpenFire(atom/A)
	. = ..()
	projectiletype = pick(projectile_list) // It's VENDING TIME.
	switch(projectiletype)
		if(/obj/projectile/wellcheers/white)
			ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))
		if(/obj/projectile/wellcheers/purple)
			ChangeResistances(list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1))
		if(/obj/projectile/wellcheers)
			ChangeResistances(list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))
		else
			ChangeResistances(list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))

/mob/living/simple_animal/hostile/abnormality/wellcheers/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		can_breach = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/wellcheers/AttackingTarget()
	return FALSE

// Soda cans
/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red
	name = "can of cherry 'Wellcheers' soda"
	desc = "A can of cherry-flavored soda."
	icon_state = "wellcheers_red"
	inhand_icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/wellcheers_red = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white
	name = "can of 'Wellcheers' soda"
	desc = "A can of regular soda."
	icon_state = "wellcheers_white"
	inhand_icon_state = "monkey_energy"
	list_reagents = list(/datum/reagent/consumable/wellcheers_white = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple
	name = "can of grape 'Wellcheers' soda"
	desc = "A can of grape-flavored soda."
	icon_state = "wellcheers_purple"
	inhand_icon_state = "purple_can"
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple = 10)

/datum/reagent/abnormality/wellcheers_zero
	name = "Wellcheers Zero"
	description = "Low-impact soda for the high-energy lifestyle."
	special_properties = list("substance may have erratic effects on subject's physical and mental state")
	color = "#b2e0c0"

/datum/reagent/abnormality/wellcheers_zero/on_mob_life(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.adjustBruteLoss(rand(-2, 3) * REAGENTS_EFFECT_MULTIPLIER)
	H.adjustSanityLoss(rand(-2, 3) * REAGENTS_EFFECT_MULTIPLIER)
	return ..()

/obj/projectile/wellcheers
	name = "shaken can of cherry 'Wellcheers' soda"
	desc = "A shaken can of cherry-flavored soda."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "wellcheers_red"
	nodamage = TRUE
	var/datum/status_effect/effect_type = /datum/status_effect/wellcheers_bad/red

/obj/projectile/wellcheers/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/cooler_target = target
		cooler_target.apply_status_effect(effect_type)

/obj/projectile/wellcheers/white
	name = "shaken can of 'Wellcheers' soda"
	desc = "A shaken can of soda."
	icon_state = "wellcheers_white"
	effect_type = /datum/status_effect/wellcheers_bad/white

/obj/projectile/wellcheers/purple
	name = "shaken can of grape 'Wellcheers' soda"
	desc = "A shaken can of grape-flavored soda."
	icon_state = "wellcheers_purple"
	effect_type = /datum/status_effect/wellcheers_bad/purple

/datum/status_effect/wellcheers_bad
	id = "soda_bad"
	status_type = STATUS_EFFECT_REPLACE
	duration = 10 SECONDS
	tick_interval = 1 SECONDS
	var/damage_type = null
	var/debuff_damage = 8

/datum/status_effect/wellcheers_bad/tick()
	. = ..()
	if(isnull(damage_type))
		return
	owner.apply_damage(debuff_damage, damage_type, null, owner.run_armor_check(null, damage_type))

/atom/movable/screen/alert/status_effect/wellcheers_bad
	name = "Shrimp Soda"
	desc = "Oh my god it smells like fish oil... You're constantly taking damage!"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "wellcheers_red"

/atom/movable/screen/alert/status_effect/wellcheers_bad/white
	icon_state = "wellcheers_white"

/atom/movable/screen/alert/status_effect/wellcheers_bad/purple
	icon_state = "wellcheers_purple"

/datum/status_effect/wellcheers_bad/red
	damage_type = RED_DAMAGE
	alert_type = /atom/movable/screen/alert/status_effect/wellcheers_bad

/datum/status_effect/wellcheers_bad/white
	damage_type = WHITE_DAMAGE
	alert_type = /atom/movable/screen/alert/status_effect/wellcheers_bad/white

/datum/status_effect/wellcheers_bad/purple
	damage_type = BLACK_DAMAGE
	alert_type = /atom/movable/screen/alert/status_effect/wellcheers_bad/purple

//Shrimple boat stuff
/turf/open/water/deep/saltwater/extradeep
	static_target = TRUE

/turf/open/water/deep/saltwater/extradeep/WarpSunkStuff(atom/movable/thing) //Drowning code - you won't make it back to the station alive.
	if(!target_turf)
		var/shrimpspot = locate(/obj/effect/landmark/shrimpship) in world.contents
		if(shrimpspot)
			target_turf = get_turf(shrimpspot)
		else
			qdel(thing)
			return
	if(isliving(thing))
		var/mob/living/L = thing
		if(L.movement_type & FLYING)
			return
		if(!ishuman(L))
			qdel(L)
			return
		var/mob/living/carbon/human/H = L
		/* Im not entirely sure why this is here if the shrimp boat
			is surrounded by indestructable railing. I guess if
			other mappers want to use extradeep? -IP*/
		if(target_turf)
			for(var/obj/item/fishing_net/fishnet in H.GetAllContents())
				fishnet.forceMove(target_turf)
			for(var/obj/item/fishing_rod/fishrod in H.GetAllContents())
				fishrod.forceMove(target_turf)
		INVOKE_ASYNC(src, PROC_REF(Drown), H)
	else
		//Fishing rods cant fit in bags or be worn so this may save any that fall into the water.
		if((istype(thing, /obj/item/fishing_net) || istype(thing, /obj/item/fishing_rod)) && target_turf)
			thing.forceMove(target_turf)
			return
		qdel(thing)

/turf/open/water/deep/saltwater/extradeep/proc/Drown(mob/living/carbon/human/H)
	H.Stun(30 SECONDS)
	H.visible_message(span_userdanger("[H] falls in the water and starts to squirm frantically! It looks like they're going to drown!"), span_userdanger("The sea is far too dangerous! You slip into the depths..."))
	playsound(src, 'sound/voice/human/wilhelm_scream.ogg', 50, TRUE, -3)
	animate(H, alpha = 0,pixel_x = 0, pixel_z = 0, time = 3 SECONDS)
	QDEL_IN(H, 3.5 SECONDS)
	sleep(3 SECONDS)
	playsound(src, 'sound/abnormalities/dreamingcurrent/dead.ogg', 80, TRUE, -3)

/obj/effect/landmark/shrimpship
	name = "shrimp ship"
	icon_state = "carp_spawn"

// Wellcheers Side Shrimps
/obj/structure/wellcheers_side_shrimp
	name = "wellcheers shrimp"
	desc = "A peppy shrimp accompanying the soda machine, it seems friendly."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_sideshrimp"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/wellcheers_side_shrimp/proc/ShrimpDance()
	flick("wellcheers_kidnap",src)
