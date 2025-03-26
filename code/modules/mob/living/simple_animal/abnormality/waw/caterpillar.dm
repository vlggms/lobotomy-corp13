/mob/living/simple_animal/hostile/abnormality/caterpillar
	name = "Hookah Caterpillar"
	desc = "A pathetic bug sitting on a leaf."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "caterpillar"
	icon_living = "caterpillar"
	portrait = "caterpillar"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 2300
	health = 2300
	ranged = TRUE
	attack_verb_continuous = "scolds"
	attack_verb_simple = "scold"
	stat_attack = HARD_CRIT
	melee_damage_lower = 11
	melee_damage_upper = 12
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0)
	speak_emote = list("flutters")

	can_breach = TRUE
	threat_level = WAW_LEVEL
	faction = list("neutral", "hostile")
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 75,
		ABNORMALITY_WORK_INSIGHT = 75,
		ABNORMALITY_WORK_ATTACHMENT = 75,
		ABNORMALITY_WORK_REPRESSION = list(20, 20, 20, 20, 65),
	)
	max_boxes = 18
	work_damage_amount = 5
	work_damage_type = PALE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	patrol_cooldown_time = 3 SECONDS

	ego_list = list(
		/datum/ego_datum/weapon/havana,
		/datum/ego_datum/armor/havana,
	)
//	gift_type =  /datum/ego_gifts/caterpillar
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/darts_smoked	//how many times you didnt' work repression
	var/can_counter = TRUE

//Set a smoker timer for 15 seconds
/mob/living/simple_animal/hostile/abnormality/caterpillar/BreachEffect()
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	addtimer(CALLBACK(src, PROC_REF(Smoke_Timer)), 15 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/Smoke_Timer()
	var/datum/effect_system/smoke_spread/pale/S = new
	S.set_up(8, get_turf(src))	//Make the smoke bigger
	S.start()
	qdel(S)
	addtimer(CALLBACK(src, PROC_REF(Smoke_Timer)), 15 SECONDS)


//Counter shit if you get hit by a bullet, we want to keep them either dodging in and out or firing through the gas
/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/Counter_Timer()
	can_counter = TRUE

/mob/living/simple_animal/hostile/abnormality/caterpillar/bullet_act(obj/projectile/P)
	if(!can_counter)
		return
	can_counter = FALSE
	var/datum/effect_system/smoke_spread/pale/S = new
	S.set_up(12, get_turf(src))	//on counter, do massive amounts of smoke
	S.start()
	qdel(S)
	addtimer(CALLBACK(src, PROC_REF(Counter_Timer)), 15 SECONDS)



/mob/living/simple_animal/hostile/abnormality/caterpillar/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		darts_smoked++	//Smoke a fat stoogie if it's not repression

		if(darts_smoked<8)
			work_damage_amount+=2
			datum_reference.max_boxes+=2

		if(darts_smoked>=3)
			var/datum/effect_system/smoke_spread/pale/S = new
			S.set_up(4, get_turf(src))	//Make the smoke bigger
			S.start()
			qdel(S)

		if(darts_smoked>=5)
			if(prob(50))
				datum_reference.qliphoth_change(-1)



/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/pale
	icon_state = "palesmoke"
	lifetime = 8

//Bypasses smoke detection
/obj/effect/particle_effect/smoke/pale/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return FALSE
	if(lifetime<1)
		return FALSE
	if(C.smoke_delay)
		return FALSE

	C.smoke_delay++
	addtimer(CALLBACK(src, PROC_REF(remove_smoke_delay), C), 10)
	C.deal_damage(27, PALE_DAMAGE)
	to_chat(C, span_danger("IT BURNS!"))
	C.emote("scream")
	return TRUE

/datum/effect_system/smoke_spread/pale
	effect_type = /obj/effect/particle_effect/smoke/pale
