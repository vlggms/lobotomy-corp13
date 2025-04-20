/mob/living/simple_animal/hostile/abnormality/branch12/wave
	name = "Full-Wave M'aider"
	desc = "You see in the static, a broadcasting terminal"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "mhz"
	icon_living = "mhz"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	blood_volume = 0
	threat_level = ZAYIN_LEVEL
	max_boxes = 10
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 40, 45, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 65, 65, 65),
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 45, 50, 55),
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/abno_oil

	ego_list = list(
		/datum/ego_datum/weapon/branch12/signal,
		/datum/ego_datum/armor/branch12/signal,
	)
	//gift_type =  /datum/ego_gifts/signal
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/list/given_ability = list()
	var/temperance_work
	var/list/structures = list()

/mob/living/simple_animal/hostile/abnormality/branch12/wave/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		temperance_work++

		//Give players a notice
		if(temperance_work == 2)
			for(var/mob/M in GLOB.player_list)
				if(M.z == z && M.client)
					to_chat(M, span_warning("What is that noise?"))
			addtimer(CALLBACK(src, PROC_REF(WhitePulse)), 15)
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/wave/proc/WhitePulse()
	if(temperance_work>=2)
		addtimer(CALLBACK(src, PROC_REF(WhitePulse)), 15)
		//Deal minor white damage to people
		for(var/mob/living/carbon/human/H in GLOB.mob_list)
			if(H.z == z)
				H.deal_damage(2, WHITE_DAMAGE)


/mob/living/simple_animal/hostile/abnormality/branch12/wave/death()
	. = ..()
	for(var/Y in structures)
		qdel(Y)


/mob/living/simple_animal/hostile/abnormality/branch12/wave/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
			if(A.datum_reference in given_ability)
				continue
			A.datum_reference.max_boxes += 2
			given_ability+= A.datum_reference
	if(temperance_work >= 2)
		temperance_work = 0
		for(var/mob/M in GLOB.player_list)
			if(M.z == z && M.client)
				to_chat(M, span_nicegreen("You feel at ease."))


//Visuals
/mob/living/simple_animal/hostile/abnormality/branch12/wave/Initialize()
	. = ..()
	/*			//This causes shit to spawn on records cabinets. Fixing it now
	for(var/i = 1 to 3)
		var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
		var/obj/effect/wave_shadow/V = new (dispense_turf)
		structures+=V
	var/obj/effect/radio/V = new (get_turf(src))
	structures+=V
	return*/

/obj/effect/wave_shadow
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "shadow"

/obj/effect/wave_shadow/Initialize()
	. = ..()
	dir = pick(NORTH, SOUTH, EAST, WEST)

/obj/effect/radio
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "radio"

