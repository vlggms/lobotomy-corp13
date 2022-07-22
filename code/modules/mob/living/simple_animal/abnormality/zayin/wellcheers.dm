// A vending machine that is a mob type. My descent into madness continues.
/mob/living/simple_animal/hostile/abnormality/wellcheers
	name = "Wellcheers vending machine"
	desc = "A vending machine selling cans of \"Wellcheers\"."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "wellcheers_vendor"
	icon_living = "wellcheers_vendor"
	layer = BELOW_OBJ_LAYER
	threat_level = ZAYIN_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(70, 65, 60, 55, 50),
						ABNORMALITY_WORK_INSIGHT = list(70, 65, 60, 55, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(45, 40, 35, 30, 25),
						ABNORMALITY_WORK_REPRESSION = list(45, 40, 35, 30, 25)
						)
	work_damage_amount = 1
	work_damage_type = RED_DAMAGE
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/soda,
		/datum/ego_datum/armor/soda
		)

	// Chance will be decreasing if you work on it too much. Don't abuse "free" healing, lads!
	var/success_counter = 0

/mob/living/simple_animal/hostile/abnormality/wellcheers/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/wellcheers/success_effect(mob/living/carbon/human/user, work_type, pe)
	success_counter += 1
	var/obj/item/dropped_can
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			dropped_can = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red
		if(ABNORMALITY_WORK_INSIGHT)
			dropped_can = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white
		if(ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION)
			dropped_can = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple
	if(!dropped_can)
		return
	var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
	dropped_can = new dropped_can(dispense_turf)
	playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE)
	visible_message("<span class='notice'>[src] dispenses [dropped_can].</span>")
	return

// Death!
/mob/living/simple_animal/hostile/abnormality/wellcheers/failure_effect(mob/living/carbon/human/user, work_type, pe)
	for(var/turf/open/T in view(7, src))
		new /obj/effect/temp_visual/water_waves(T)
	playsound(get_turf(src), 'sound/abnormalities/wellcheers/ability.ogg', 75, 0)
	to_chat(user, "<span class='userdanger'>You feel sleepy...</span>")
	user.AdjustSleeping(10 SECONDS)
	animate(user, alpha = 0, time = 2 SECONDS)
	QDEL_IN(user, 3.5 SECONDS) // Bye bye!
	success_counter = 0 // Reset counter, you can get more soda safely now
	return

/mob/living/simple_animal/hostile/abnormality/wellcheers/work_chance(mob/living/carbon/human/user, chance)
	return chance - success_counter

/mob/living/simple_animal/hostile/abnormality/wellcheers/meltdown_start()
	..()
	success_counter = 0

// Soda cans
/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red
	name = "can of cherry 'Wellcheers' soda"
	desc = "A can of cherry-flavored soda."
	icon_state = "wellcheers_red"
	inhand_icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/wellcheers_red = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white
	name = "can of 'Wellcheers' soda"
	desc = "A can of soda."
	icon_state = "wellcheers_white"
	inhand_icon_state = "monkey_energy"
	list_reagents = list(/datum/reagent/consumable/wellcheers_white = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple
	name = "can of grape 'Wellcheers' soda"
	desc = "A can of grape-flavored soda."
	icon_state = "wellcheers_purple"
	inhand_icon_state = "purple_can"
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple = 10)
