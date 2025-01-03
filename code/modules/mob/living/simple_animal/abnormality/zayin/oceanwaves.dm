/mob/living/simple_animal/hostile/abnormality/oceanicwaves
	name = "Vending Machine and Oceanic Waves"
	desc = "An orange vending machine. Somehow reminds you of the sea."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "oceanicwaves"
	portrait = "oceanicwaves"
	maxHealth = 600
	health = 600
	threat_level = ZAYIN_LEVEL
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE
	max_boxes = 10
	success_boxes = 9
	neutral_boxes = 6

	ego_list = list(
		/datum/ego_datum/weapon/oceanic,
		/datum/ego_datum/armor/oceanic,
	)
	gift_type = /datum/ego_gifts/oceanic
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	blood_volume = 0

	ranged = TRUE
	ranged_message = "launches a can"
	ranged_cooldown_time = 3 SECONDS
	rapid = 4
	rapid_fire_delay = 6
	retreat_distance = 4
	check_friendly_fire = TRUE
	projectiletype = /obj/projectile/oceanic/special // it's like wellcheers, but crack
	projectilesound = 'sound/machines/machine_vend.ogg'

	observation_prompt = "In an empty space, you find a lone vending machine. <br>\
		Where does it get its power…? <br>Besides that, what’s with this sound of crashing waves? <br>\
		Regardless, this vacant lot looks to be a good place to take a break. <br>\
		Standing in front of the vending machine, you see rows of buttons."
	observation_choices = list(
		"Press one" = list(TRUE, "With just a single press, the machine ejected one can after another. <br>\
			All the cans are purple. You can’t fathom the meaning of the ships and grapes doodled on them, but they somehow feel familiar, and well… cheery. <br>\
			They should be okay to drink."),
	)

	var/list/goodsoders = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/unlabeled,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/cola,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/coffee,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/milk,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/ultimate,
	)
	var/list/badsoders = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/cocaine,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/lean,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/whale,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/cocktail,
		/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/hootch,
	)
	var/currentvend

//Shrimple work stuff
/mob/living/simple_animal/hostile/abnormality/oceanicwaves/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
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
	. = ..()
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
	. = ..()
	switch(rand(1, 10))
		if(1 to 6)
			currentvend = pick(badsoders)
		if(6 to 9)
			currentvend = /obj/item/reagent_containers/food/drinks/soda_cans/oceanwave
		else
			currentvend = pick(goodsoders)
	//And FIRE!
	if(!user)
		Vend(currentvend)
		return
	HostileVend(currentvend, user, 3)


//Nabbed from Wellcheers, So much faster than coding myself
/mob/living/simple_animal/hostile/abnormality/oceanicwaves/proc/Vend(obj/item/reagent_containers/food/drinks/soda_cans/VendingSoda)
	var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
	new VendingSoda(dispense_turf)
	playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE)
	visible_message(span_notice("[src] dispenses a can of soda."))
	SLEEP_CHECK_DEATH(20)

//Obvious copypaste
/mob/living/simple_animal/hostile/abnormality/oceanicwaves/proc/HostileVend(obj/item/reagent_containers/food/drinks/soda_cans/VendingSoda, mob/living/carbon/human/the_target, count)
	if(!count || !the_target)
		return
	playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE)
	SLEEP_CHECK_DEATH(20)
	if(!the_target) // Somehow, they disappeared
		return
	var/obj/projectile/oceanic/P = new(get_turf(src))
	if(VendingSoda)
		P.item_type = VendingSoda
	var/turf/proj_turf = src.loc
	P.starting = get_turf(src)
	P.firer = src
	P.fired_from = src
	P.yo = the_target.y - proj_turf.y
	P.xo = the_target.x - proj_turf.x
	P.original = the_target
	P.preparePixelProjectile(the_target, src)
	P.fire()
	visible_message(span_notice("[src] fires a can of soda!"))
	count -= 1
	HostileVend(null, the_target, count) // First arg is set to null so that only one soda actually drops

/mob/living/simple_animal/hostile/abnormality/oceanicwaves/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		can_breach = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/oceanicwaves/AttackingTarget()
	return FALSE

/obj/projectile/oceanic
	name = "shaken can of 'Oceanic Waves' soda"
	desc = "A shaken can of sketchy orange soda."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "oceanbreeze"
	spread = 15
	damage = 40
	var/item_type = null

/obj/projectile/oceanic/on_hit(atom/target, blocked = FALSE)
	. = ..()
	handle_drop()

/obj/projectile/oceanic/on_range()
	handle_drop()
	..()

/obj/projectile/oceanic/proc/handle_drop()
	if(!item_type)
		return
	var/turf/T = get_turf(src)
	new item_type(T)

/obj/projectile/oceanic/special
	nodamage = TRUE
	var/list/CIA_EASY = list(
		/datum/reagent/drug/space_drugs,
		/datum/reagent/drug/nicotine,
		/datum/reagent/drug/methamphetamine,
		/datum/reagent/toxin/mutetoxin,
	)
	var/list/CIA_HARD = list(
		/datum/reagent/toxin/lexorin,
		/datum/reagent/toxin/carpotoxin,
		/datum/reagent/toxin/mindbreaker,
		/datum/reagent/drug/crank,
	)
	var/list/current_reagents = list()

/obj/projectile/oceanic/special/Initialize()
	. = ..()
	if(prob(80))
		current_reagents += list(pick(CIA_EASY) = 4)
	if(prob(40))
		current_reagents += list(pick(CIA_HARD) = 2)

/obj/projectile/oceanic/special/on_hit(atom/target, blocked, pierce_hit)
	if(isliving(target))
		var/mob/living/L = target
		L.reagents?.add_reagent_list(current_reagents)
	return ..()

// Good Soders
/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave
	name = "can of 'Oceanic Waves' soda"
	desc = "A sketchy can of orange soda."
	icon_state = "oceanbreeze"
	inhand_icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/wellcheers_purple/oceanwave = 30)
	list_reagents = list(
		/datum/reagent/consumable/sodawater = 20,
		/datum/reagent/consumable/wellcheers_purple/oceanwave = 10,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/unlabeled
	name = "can of 'Canned Experience Crush' soda"
	desc = "A sketchy can of soda that seems similar to a product by N-Corp. Taste is described as calming to the mind."
	icon_state = "generic_can"
	list_reagents = list(
		/datum/reagent/medicine/mannitol = 5,
		/datum/reagent/consumable/wellcheers_white = 10,
		/datum/reagent/consumable/sodawater = 15,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/cola
	name = "can of '****-cheers' soda"
	desc = "Oddly, the label and the mascot have been partially censored out. It looks like a shrimp, but also... a polar bear? You can't be sure."
	icon_state = "cola_tallboy"
	list_reagents = list(
		/datum/reagent/consumable/wellcheers_red = 10,
		/datum/reagent/consumable/space_cola = 20,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/coffee
	name = "can of 'oceanic coffee'"
	desc = "Oceanic coffee. The idea is alright, but the execution is terrible. Carbonated and made with seawater."
	icon_state = "energy_tallboy"
	list_reagents = list(
		/datum/reagent/consumable/sodawater = 5,
		/datum/reagent/consumable/wellcheers_white = 5,
		/datum/reagent/consumable/salt = 5,
		/datum/reagent/consumable/coffee = 15,

	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/milk
	name = "can of 'Milky Port' soda"
	desc = "A can of milk with sugar-free soda to balance out the calorie count. Gross.."
	icon_state = "milk_tallboy"
	list_reagents = list(
		/datum/reagent/consumable/wellcheers_purple/oceanwave = 5,
		/datum/reagent/consumable/milk = 10,
		/datum/reagent/consumable/wellcheers_white = 5,
		/datum/reagent/consumable/sodawater = 10,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/ultimate
	name = "can of 'Wellcheers Ultimate' soda"
	desc = "A can of wellcheers 'every flavor' soda. Extra cheery."
	icon_state = "oceanbreeze_tallboy"
	list_reagents = list(
		/datum/reagent/consumable/wellcheers_purple/oceanwave = 5,
		/datum/reagent/consumable/wellcheers_white = 5,
		/datum/reagent/consumable/wellcheers_red = 5,
		/datum/reagent/consumable/wellcheers_purple = 5,
		/datum/reagent/consumable/sodawater = 10,
	)

// Bad (evil) soders
/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/cocaine
	name = "can of 'LIQUID COCAINE!!!' soda"
	desc = "An extreme-looking energy drink featuring a green skull with crossbones and strange humanoids screaming. You probably shouldn't drink this."
	icon_state = "cocaine"
	list_reagents = list(
		/datum/reagent/drug/methamphetamine = 10,
		/datum/reagent/toxin/fentanyl = 5,
		/datum/reagent/toxin/histamine = 5,
		/datum/reagent/consumable/sodawater = 15,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/lean
	name = "can of 'Oceanic Lean' soda"
	desc = "A can of soda that is possibly and most likely laced with some recreational drugs."
	icon_state = "oceanic_lean"
	list_reagents = list(
		/datum/reagent/consumable/wellcheers_purple/oceanwave = 10,
		/datum/reagent/consumable/lean = 15,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/whale
	name = "can of 'Pallid Sardine' flavored soda"
	desc = "Similar to a certain ice cream sold in U-corp. This could have some weird effects if you drink it."
	icon_state = "pallid"
	list_reagents = list(
		/datum/reagent/consumable/sodawater = 10,
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/toxin/pallidwaste = 5,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/cocktail
	name = "can of 'Shrimp Cocktail' soda"
	desc = "Cooked shrimp in a carbonated horseradish sauce. Sounds kind of gross, but some people swear by it."
	icon_state = "ice_tea_can"
	list_reagents = list(
		/datum/reagent/consumable/sodawater = 10,
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/tomatojuice = 10,
	)

/obj/item/reagent_containers/food/drinks/soda_cans/oceanwave/hootch
	name = "can of 'Oceanic Waves Extra Hard' soda"
	desc = "You can't see any indicator of the proof on this can, but it reeks of alcohol."
	icon_state = "hootch"
	list_reagents = list(
		/datum/reagent/consumable/wellcheers_purple/oceanwave = 5,
		/datum/reagent/medicine/morphine = 5,
		/datum/reagent/consumable/ethanol/bacchus_blessing = 5,
		/datum/reagent/consumable/ethanol/hooch = 20,
	)

// Chems
/datum/reagent/consumable/wellcheers_purple/oceanwave
	name = "Orange Soda"
	description = "It tastes like orange-flavored soda."
	color = "#DB03FC"
	taste_description = "orange soda"
	glass_icon_state = "lean"
	glass_name = "glass of orange soda"
	glass_desc = "A glass of orange-flavored soda."
