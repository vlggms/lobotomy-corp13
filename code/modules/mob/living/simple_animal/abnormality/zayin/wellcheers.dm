// A vending machine that is a mob type. My descent into madness continues.
/mob/living/simple_animal/hostile/abnormality/wellcheers
	name = "Wellcheers Vending Machine"
	desc = "A vending machine selling cans of \"Wellcheers\"."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "wellcheers_vendor"
	icon_living = "wellcheers_vendor"
	layer = BELOW_OBJ_LAYER
	threat_level = ZAYIN_LEVEL
	maxHealth = 400
	health = 400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(70, 70, 60, 60, 60),
						ABNORMALITY_WORK_INSIGHT = list(70, 70, 60, 60, 60),
						ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 40, 40, 40),
						ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40)
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
	faction = list("shrimp")
	projectiletype = /obj/projectile/wellcheers/red
	projectilesound = 'sound/machines/machine_vend.ogg'
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/soda,
		/datum/ego_datum/armor/soda
		)
	gift_type = /datum/ego_gifts/soda
	gift_message = "You feel like you've been doing this your whole life."

	var/projectile_list = list(/obj/projectile/wellcheers/red, /obj/projectile/wellcheers/white, /obj/projectile/wellcheers/purple)

/mob/living/simple_animal/hostile/abnormality/wellcheers/success_effect(mob/living/carbon/human/user, work_type, pe)
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
	return


/mob/living/simple_animal/hostile/abnormality/wellcheers/OpenFire(atom/A)
	. = ..()
	projectiletype = pick(projectile_list) // It's VENDING TIME.
	switch(projectiletype)
		if(/obj/projectile/wellcheers/red)
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
		if(/obj/projectile/wellcheers/white)
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
		if(/obj/projectile/wellcheers/purple)
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
		else
			damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

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
