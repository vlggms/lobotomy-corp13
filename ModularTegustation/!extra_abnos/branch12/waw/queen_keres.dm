//Queen Keres
/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres
	name = "Queen Keres"
	desc = "A towering queen in combat dress. She is cloaked in purple."
	icon = 'ModularTegustation/Teguicons/branch12/48x48.dmi'
	icon_state = "keres_contained"
	icon_living = "keres_contained"
	icon_dead = "keres_dead"

	maxHealth = 2000
	health = 2000
	pixel_x = -8
	base_pixel_x = -8
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 3
	move_to_delay = 8
	minimum_distance = 2 // Don't move all the way to melee
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 50, 60, 70, 80),
		ABNORMALITY_WORK_INSIGHT = list(50, 45, 45, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(35, 40, 50, 60, 65),
		ABNORMALITY_WORK_REPRESSION = list(5, 15, 25, 35, 45),
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE
	friendly_verb_continuous = "scorns"
	friendly_verb_simple = "scorn"

	ego_list = list(
		/datum/ego_datum/weapon/branch12/degraded_honor,
		/datum/ego_datum/armor/branch12/degraded_honor,
	)
	//gift_type =  /datum/ego_gifts/honor_return
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	//Pulse stuff
	var/pulse_cooldown
	var/pulse_cooldown_time = 1.8 SECONDS
	var/pulse_damage = 30

	var/list/knights = list()
	var/no_knights = FALSE
	var/current_qliphoth

/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
		KnightAgent()
		current_qliphoth = datum_reference.qliphoth_meter

/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
		KnightAgent()
		current_qliphoth = datum_reference.qliphoth_meter

/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/PickTarget(list/Targets)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/Life()
	. = ..()
	if(!.) // Dead
		return FALSE

	//This is unhinged. I need to check if the counter was lowered. By any means necessary.
	if(current_qliphoth != datum_reference.qliphoth_meter_max && datum_reference.qliphoth_meter != current_qliphoth)
		KnightAgent()
		current_qliphoth = datum_reference.qliphoth_meter

	//Okay if you're not in godmode check if your knights are dead and if they aren't then pulse black
	if(!(status_flags & GODMODE))
		CheckKnights()
		if((pulse_cooldown < world.time))
			BlackPulse()

/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/AttackingTarget()
	return FALSE


/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/BreachEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	icon_state = "keres_contained"
	//Move to main room
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	if(!length(knights))
		no_knights = TRUE

	//Grab your knights and make them insane
	for(var/mob/living/carbon/human/H in knights)
		//Replaces AI with murder one
		if(!H.sanity_lost)
			H.adjustSanityLoss(500)
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/murder/queen_keres
		H.InitializeAIController()

		//move your knights
		var/turf/knight_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
		H.forceMove(knight_turf)


/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/proc/BlackPulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/L in livinginview(10, src))
		if(faction_check_mob(L))
			continue
		if(L in knights)
			continue
		L.deal_damage(pulse_damage, BLACK_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))


/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/proc/KnightAgent()
	var/potential_knights = list()

	//Pick a security role to knight.
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!(H.mind.assigned_role in GLOB.security_positions))
			continue
		potential_knights+=H

	var/mob/living/carbon/human/new_knight = pick(potential_knights)
	knights += new_knight

	to_chat(new_knight, span_notice("You heed the call to arms."))
	new_knight.physiology.red_mod *= 0.8
	new_knight.physiology.white_mod *= 0.8
	new_knight.physiology.black_mod *= 0.8
	new_knight.physiology.pale_mod *= 0.8

/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres/proc/CheckKnights()
	if(no_knights)
		return

	for(var/mob/living/carbon/human/H in knights)
		if(!H.sanity_lost || H.stat == DEAD)
			knights-=H
			H.physiology.red_mod /= 0.8
			H.physiology.white_mod /= 0.8
			H.physiology.black_mod /= 0.8
			H.physiology.pale_mod /= 0.8

	if(length(knights) == 0)
		death()

/datum/ai_controller/insane/murder/queen_keres
	lines_type = /datum/ai_behavior/say_line/insanity_keres
	blacklist = list(/mob/living/simple_animal/hostile/abnormality/branch12/queen_keres)

/datum/ai_behavior/say_line/insanity_keres
	lines = list(
		"My Queen, I fight for thee!",
		"I fight for Justice!",
	)
