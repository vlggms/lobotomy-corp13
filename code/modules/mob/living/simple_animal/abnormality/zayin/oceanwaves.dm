/mob/living/simple_animal/hostile/abnormality/oceanicwaves
	name = "Vending Machine and Oceanic Waves"
	desc = "An orange vending machine. Reminds you of home."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "oceanicwaves"
	maxHealth = 600
	health = 600
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 50
		)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE
	max_boxes = 10
	success_boxes = 9
	neutral_boxes = 6

//to do: EGO
	ego_list = list(
		/datum/ego_datum/weapon/oceanic,
		/datum/ego_datum/armor/oceanic
		)
	gift_type = /datum/ego_gifts/oceanic
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	var/list/goodsoders = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/oxan,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/omni,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/penacid,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/sali,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/mental,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/morphine,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/mannitol,)

	var/list/badsoders = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/spacedrugs,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/nicotine,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/crank,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/meth,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/lexorin,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/lsd,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/clh,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/mute,)
	var/currentvend

//Shrimple work stuff
/mob/living/simple_animal/hostile/abnormality/oceanicwaves/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	for(var/i = 1 to 3)
		//Randomize the soders then vend.
		switch(rand(1, 10))
			if(1 to 2)
				currentvend = pick(badsoders)
			if(2 to 5)
				currentvend = /obj/item/reagent_containers/food/drinks/soda_cans/oceanwave
			else
				currentvend = pick(goodsoders)
		//And Vend
		Vend(currentvend)
	return

/mob/living/simple_animal/hostile/abnormality/oceanicwaves/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	for(var/i = 1 to 3)
		//Randomize the soders then vend.
		switch(rand(1, 10))
			if(1 to 4)
				currentvend = pick(badsoders)
			if(4 to 7)
				currentvend = /obj/item/reagent_containers/food/drinks/soda_cans/oceanwave
			else
				currentvend = pick(goodsoders)
		//And Vend
		Vend(currentvend)
	return

/mob/living/simple_animal/hostile/abnormality/oceanicwaves/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	for(var/i = 1 to 3)
		//Randomize the soders then vend.
		switch(rand(1, 10))
			if(1 to 6)
				currentvend = pick(badsoders)
			if(6 to 9)
				currentvend = /obj/item/reagent_containers/food/drinks/soda_cans/oceanwave
			else
				currentvend = pick(goodsoders)
		//And Vend
		Vend(currentvend)
	return


//Nabbed from Wellcheers, So much faster than coding myself
/mob/living/simple_animal/hostile/abnormality/oceanicwaves/proc/Vend(obj/item/reagent_containers/food/drinks/soda_cans/VendingSoda)
	var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
	new VendingSoda(dispense_turf)
	playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE)
	visible_message(span_notice("[src] dispenses a can of soda."))
	SLEEP_CHECK_DEATH(20)


// Soda cans
/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave
	name = "can of 'Oceanic Waves' soda"
	desc = "A sketchy can of orange soda."
	icon_state = "oceanbreeze"
	inhand_icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 15)


/datum/reagent/consumable/wellcheers_purple/oceanwave
	name = "Orange Soda"
	description = "It tastes like orange-flavored soda."
	color = "#DB03FC"
	taste_description = "orange soda"
	glass_icon_state = "lean"
	glass_name = "glass of orange soda"
	glass_desc = "A glass of orange-flavored soda."


//Drugged up soders
/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/spacedrugs
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/drug/space_drugs = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/nicotine
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/drug/nicotine = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/crank
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/drug/crank = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/meth
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/drug/methamphetamine = 10)

//Toxic Sodas
/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/lexorin
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 10, /datum/reagent/toxin/lexorin = 5)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/carpotoxin
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 10, /datum/reagent/toxin/carpotoxin = 5)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/lsd
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/toxin/mindbreaker = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/clh
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/toxin/chloralhydrate = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/mute
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/toxin/mutetoxin = 10)

//Random healign soders
/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/oxan
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/medicine/oxandrolone = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/omni
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 10, /datum/reagent/medicine/omnizine = 5)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/penacid
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/medicine/pen_acid = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/sali
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/medicine/sal_acid = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/mental
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/medicine/mental_stabilizator = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/morphine
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/medicine/morphine = 10)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/mannitol
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 5, /datum/reagent/medicine/mannitol = 10)

