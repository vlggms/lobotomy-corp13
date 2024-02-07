/mob/living/simple_animal/hostile/abnormality/kqe
	name = "KQE-1J-23"
	desc = "A mechanical puppet composed of metal plates, lights, and integrated circuits. Bare wires protrude with its every movement."
	health = 1500
	maxHealth = 1500
	attack_verb_continuous = "whips"
	attack_verb_simple = "whip"
	attack_sound = 'sound/abnormalities/kqe/hitsound1.ogg'
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "kqe"
	icon_living = "kqe"
	icon_dead = "kqe_egg"
	portrait = "KQE"
	del_on_death = FALSE
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.2)
	melee_damage_lower = 20
	melee_damage_upper = 25
	move_to_delay = 3
	ranged = TRUE
	pixel_x = -24
	base_pixel_x = -24
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 50, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = list(30, 35, 40, 45, 50),
		"Write HELLO" = 0,
		"Write GOODBYE" = 0,
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/replica,
		/datum/ego_datum/armor/replica,
	)
	gift_type =  /datum/ego_gifts/replica
	gift_message = "The abnormality hands you a pendant made from circuits and sinews."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/nothing_there = 1.5,
		/mob/living/simple_animal/hostile/abnormality/nobody_is = 1.5,
	)

	var/can_act = TRUE
	var/grab_cooldown
	var/grab_cooldown_time = 15 SECONDS
	var/grab_damage = 120
	var/work_penalty = FALSE
	var/question = FALSE
	var/work_count = 0
	var/heart = FALSE
	var/heart_threshold = 700

	//PLAYABLE ATTACKS
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/kqe_grab_toggle)

/datum/action/innate/abnormality_attack/toggle/kqe_grab_toggle
	name = "Toggle Claw Attack"
	button_icon_state = "kqe_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't grab visitors anymore.")
	button_icon_toggle_activated = "kqe_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will attempt to grab visitors.")
	button_icon_toggle_deactivated = "kqe_toggle0"


/*** Basic Procs ***/
/mob/living/simple_animal/hostile/abnormality/kqe/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/kqe/Moved()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3)
	return ..()

/mob/living/simple_animal/hostile/abnormality/kqe/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(health >= heart_threshold)
		return
	if(!heart)
		revive(full_heal = TRUE, admin_revive = FALSE)//fully heal and spawn a heart
		say("Please cooperate! Please Cooperrr... Csdk..ppra...@#@%!%^#$")
		if(!LAZYLEN(GLOB.department_centers))
			heart = TRUE
		else
			damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.2)//In regular gamemodes you are now esentially forced to suppress the heart
			var/X = pick(GLOB.department_centers)
			var/mob/living/simple_animal/hostile/kqe_heart/H = new(get_turf(X))
			heart = H
			H.abno_host = src
		Stagger()
		manual_emote("blares random letters on its terminal before turning it off.")

/mob/living/simple_animal/hostile/abnormality/kqe/death()
	if(!heart)
		return Life()//PRANKED!
	can_act = FALSE
	icon_state = icon_dead
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	if(istype(heart, /mob/living/simple_animal/hostile/kqe_heart))
		qdel(heart)
	..()

/*** Work Procs ***/
/mob/living/simple_animal/hostile/abnormality/kqe/WorkComplete(user, work_type, pe, work_time, canceled)
	. = ..()
	work_count++
	if(work_count < 3)
		work_penalty = FALSE
		return
	manual_emote("turns its terminal on.")
	to_chat(user, span_notice("A terminal on the chest of the abnormality flashes to life! You should write something on it."))
	question = TRUE
	return

/mob/living/simple_animal/hostile/abnormality/kqe/AttemptWork(mob/living/carbon/human/user, work_type)
	if((work_type != "Write HELLO") && (work_type != "Write GOODBYE") && !question)
		return TRUE
	if(((work_type == "Write HELLO") || (work_type == "Write GOODBYE")) && !question)
		to_chat(user, span_notice("The terminal is blank."))
		return FALSE
	if((work_type != "Write HELLO") && (work_type != "Write GOODBYE") && question)
		to_chat(user, span_notice("Looks like you can write something."))
		return FALSE
	if(work_type == "Write HELLO")
		if(!GiftUser(user, 18, 100))//always gives a gift
			say("Then you may not have a souvenir! Please cooperate, or you may be punished according to Rule #A62GBFE1!")
			datum_reference.qliphoth_change(-2)
			return FALSE
		say("Have you enjoyed the town tour? We’d like you to have a souvenir. :-)")
		to_chat(user, span_notice("A smile is displayed on the terminal, but the abnormality appears to be distressed."))
		datum_reference.qliphoth_change(-1)
		question = FALSE
		work_count = 0
	if(work_type == "Write GOODBYE")
		if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 60)//instant breach if below 3 justice
			datum_reference.qliphoth_change(-2)//instant breach
			to_chat(user, span_notice("The terminal’s light goes red, and warnings start to blare."))
			say("Farewell. Farewell, FarewellFarewellFarewellFarewellFarewellFarewellFarewellFarewellFarewell.")
			return FALSE
		work_penalty = TRUE
		say("Did you not take a tour of the town, Dear Guest?")
		question = FALSE
		work_count = 0
	return FALSE


/mob/living/simple_animal/hostile/abnormality/kqe/WorkChance(mob/living/carbon/human/user, chance)
	if(work_penalty)
		return chance -= 20
	return ..()

/mob/living/simple_animal/hostile/abnormality/kqe/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/*** Breach Procs ***/
/mob/living/simple_animal/hostile/abnormality/kqe/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(!(status_flags & GODMODE)) // Already breaching
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/kqe/proc/Stagger()
	can_act = FALSE
	icon_state = "kqe_prepare"
	SLEEP_CHECK_DEATH(10 SECONDS)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/kqe/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if ((grab_cooldown <= world.time) && prob(35) && (!client))//checks for client since you can still use the claw if you click nearby
		var/turf/target_turf = get_turf(target)
		return ClawGrab(target_turf)
	return Whip_Attack()

/mob/living/simple_animal/hostile/abnormality/kqe/proc/Whip_Attack()
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), attack_sound, 75, 0, 3)
	icon_state = "kqe_prepare"
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), melee_damage_upper, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	icon_state = "kqe_prepare2"
	SLEEP_CHECK_DEATH(3)
	icon_state = icon_living
	can_act = TRUE


/mob/living/simple_animal/hostile/abnormality/kqe/OpenFire()
	if(!can_act)
		return
	if(client)
		switch (chosen_attack)
			if (1)
				ClawGrab(target)
			if (2)
				return
		return
	if(grab_cooldown <= world.time)
		ClawGrab(target)
	return

/mob/living/simple_animal/hostile/abnormality/kqe/proc/ClawGrab(target)
	if(grab_cooldown > world.time)
		return
	grab_cooldown = world.time + grab_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/kqe/load1.ogg', 75, 0, 3)
	icon_state = "kqe_prepare"
	var/grab_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(grab_delay)
	icon_state = "kqe_grab"
	new /obj/effect/kqe_claw(get_turf(target))
	SLEEP_CHECK_DEATH(5 SECONDS)
	icon_state = icon_living
	can_act = TRUE

//Claw target object
/obj/effect/kqe_claw
	name = "approaching claw"
	desc = "LOOK OUT!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "tbird_bolt"
	color = COLOR_VIOLET
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/boom_damage = 90
	var/grabbed
	layer = POINT_LAYER//Sprite should always be visible

/obj/effect/kqe_claw/Initialize()
	..()
	addtimer(CALLBACK(src, PROC_REF(GrabAttack)), 3 SECONDS)

/obj/effect/kqe_claw/proc/GrabAttack()
	playsound(get_turf(src), 'sound/abnormalities/kqe/load2.ogg', 75, 0, 3)
	new /obj/effect/temp_visual/approaching_claw(get_turf(src))
	alpha = 1
	for(var/obj/vehicle/sealed/mecha/M in view(1, src))
		M.ejectall()
	for(var/mob/living/carbon/human/H in view(1, src))
		grabbed = TRUE
		H.apply_damage(boom_damage*1, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		H.forceMove(get_turf(src))//pulls them all to the target
		GrabStun(H)
	if(grabbed)
		sleep(10 SECONDS)
	qdel(src)

/obj/effect/kqe_claw/proc/GrabStun(mob/living/carbon/human/target)
	animate(target, pixel_x = 0, pixel_z = 12, time = 5)
	target.Stun(6 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(AnimateBack),target), 6 SECONDS)

/obj/effect/kqe_claw/proc/AnimateBack(mob/living/carbon/human/target)
	animate(target, pixel_x = 0, pixel_z = 0, time = 1 SECONDS)
	return TRUE

/obj/effect/temp_visual/approaching_claw
	name = "grabbing claw"
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "kqe_claw"
	pixel_x = -16
	base_pixel_x = -16
	duration = 6 SECONDS
	randomdir = 0
	pixel_y = 0

/mob/living/simple_animal/hostile/kqe_heart
	name = "Heart of The Townsfolk"
	desc = "A massive protrusion of wires shaped like a human heart. Arcs of electricity pulse on its surface.."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "kqe_heart"
	icon_living = "kqe_heart"
	icon_dead = "kqe_egg"
	/*Stats*/
	health = 1000
	maxHealth = 1000
	obj_damage = 50
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 2, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	speed = 5
	density = TRUE
	var/mob/living/simple_animal/hostile/abnormality/kqe/abno_host//This is KQE!

/mob/living/simple_animal/hostile/kqe_heart/Move()
	return FALSE

/mob/living/simple_animal/hostile/kqe_heart/CanAttack(atom/the_target)//should only attack when it has fists
	return FALSE

/mob/living/simple_animal/hostile/kqe_heart/death()
	if(abno_host)
		abno_host.death()
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()
