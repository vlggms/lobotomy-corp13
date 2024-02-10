#define STATUS_EFFECT_FAIRYLURE /datum/status_effect/fairy_lure
/mob/living/simple_animal/hostile/abnormality/faelantern
	name = "Faelantern"
	desc = "A small fairy with a green glow sits atop a delicate tree branch."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "faelantern"
	icon_living = "faelantern_fairy"
	icon_dead = "faelantern_egg"
	portrait = "faelantern"
	maxHealth = 1200
	health = 1200
	base_pixel_x = -16
	pixel_x = -16
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 50, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 45,
	)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	can_patrol = FALSE
	can_breach = TRUE
	del_on_death = FALSE
	death_message = "creaks and crumbles into its core."
	ranged = TRUE

	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	start_qliphoth = 1
	max_boxes = 12
	ego_list = list(
		/datum/ego_datum/weapon/faelantern,
		/datum/ego_datum/armor/faelantern,
	)

	gift_type = /datum/ego_gifts/faelantern
	gift_message = "The fairy extends an olive branch towards you."

	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/can_act = FALSE
	var/break_threshold = 450
	var/broken = FALSE
	var/fairy_enabled
	var/fairy_health = 1200
	var/lure_cooldown
	var/lure_cooldown_time = 30 SECONDS
	var/lure_damage = 20
	var/stab_cooldown
	var/stab_cooldown_time = 30
	var/lured_list = list()

/mob/living/simple_animal/hostile/abnormality/faelantern/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/faelantern/Goto(target, delay, minimum_distance)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/faelantern/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/faelantern/death(gibbed)
	. = ..()
	for(var/mob/living/carbon/human/H in lured_list)
		EndEnchant(H)
	icon_state = icon_dead
	playsound(src, 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 100, 1)
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)

/mob/living/simple_animal/hostile/abnormality/faelantern/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type == ABNORMALITY_WORK_REPRESSION && get_modified_attribute_level(user, TEMPERANCE_ATTRIBUTE) > 40)
		datum_reference.qliphoth_change(-1)
		return
	if(get_modified_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40)
		datum_reference.qliphoth_change(-1)
		return
	return

/mob/living/simple_animal/hostile/abnormality/faelantern/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/faelantern/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(BreachDig))
	return

/mob/living/simple_animal/hostile/abnormality/faelantern/OpenFire()
	if(!can_act)
		return
	if(lure_cooldown <= world.time)
		if(fairy_enabled)
			FairyLure()
		else
			RootWave()
	else
		RootBarrage(target)
	return

//Transformation and teleportation
/mob/living/simple_animal/hostile/abnormality/faelantern/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	..()
	if(stat == DEAD)
		return
	if(fairy_enabled)
		if(health < (fairy_health - 120))//the fairy effectively has 120 hp
			fairy_enabled = FALSE
			Uproot()
			adjustBruteLoss(-120)
			med_hud_set_health()
			med_hud_set_status()
			update_health_hud()
			return
	if(health < (maxHealth / 2) && !broken) //50% health or lower
		broken = TRUE
		playsound(src, 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 40, 0, 1)
		BreachDig(TRUE)

/mob/living/simple_animal/hostile/abnormality/faelantern/proc/BreachDig(broken = FALSE)
	var/turf/teletarget = pick(GLOB.xeno_spawn)
	if(teletarget in view(8, src))
		BreachDig()
		return
	if(!broken)
		icon_state = "faelantern_breaching"
	else
		icon_state = "faelantern_breaching2"
	playsound(src, 'sound/abnormalities/faelantern/faelantern_breach.ogg', 200, 1)//proper sfx goes here
	var/obj/effect/particle_effect/smoke/S = new(get_turf(src))
	S.alpha = 100
	S.lifetime = 2
	SLEEP_CHECK_DEATH(4)
	forceMove(teletarget)
	fairy_enabled = TRUE
	fairy_health = health//This needs to be updated when breachdig() is called a second time
	can_act = TRUE
	icon_state = icon_living
	desc = initial(desc)

/mob/living/simple_animal/hostile/abnormality/faelantern/proc/Uproot()//TODO: give it a varaible and condition for its broken state
	can_act = FALSE
	icon_state = "faelantern_reveal"
	playsound(src, 'sound/abnormalities/faelantern/faelantern_uproot.ogg', 200, 1)
	var/obj/effect/particle_effect/smoke/S = new(get_turf(src))
	S.alpha = 50
	S.lifetime = 1
	SLEEP_CHECK_DEATH(4)
	RootWave()//sets can_act to TRUE
	//if(health > break_threshold) for break-off
	icon_state = "faelantern_angry"
	desc = "The abnormality actually consists of a large, underground tree. We've learned the meaning of the fairy's gesture: there are no free gifts."

/mob/living/simple_animal/hostile/abnormality/faelantern/proc/RootBarrage(target) //regular attack
	can_act = FALSE
	playsound(get_turf(target), 'sound/creatures/venus_trap_hurt.ogg', 75, 0, 5)
//call flick(icon, src) here
//	SLEEP_CHECK_DEATH(3)
	var/obj/effect/root/faelantern/R = new(get_turf(target))
	R.dir = get_dir(get_turf(src), get_turf(target))
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/faelantern/proc/FairyLure(target)//lure AOE
	can_act = FALSE
	lure_cooldown = world.time +lure_cooldown_time
	playsound(src, 'sound/abnormalities/faelantern/faelantern_giggle.ogg', 100, 0)
	for(var/mob/living/carbon/human/victim in view(8, src))
		victim.apply_damage(lure_damage, WHITE_DAMAGE, null, spread_damage = TRUE)
		if(victim in lured_list || victim.stat >= SOFT_CRIT)
			continue
		if(get_attribute_level(victim, TEMPERANCE_ATTRIBUTE) > 40)
			continue
		victim.apply_status_effect(STATUS_EFFECT_FAIRYLURE)
		lured_list += victim
		victim.ai_controller = /datum/ai_controller/insane/faelantern
		victim.InitializeAIController()
		victim.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "fairy_lure", -HALO_LAYER))
		addtimer(CALLBACK(src, PROC_REF(EndEnchant), victim), 20 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	SLEEP_CHECK_DEATH(2 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/faelantern/proc/RootWave()
	can_act = FALSE
	lure_cooldown = world.time +lure_cooldown_time//This is the same timer FairyLure uses
	for(var/turf/T in oview(2, src))
		if(prob(30))
			var/obj/effect/root/faelantern/R = new(get_turf(T))
			R.dir = get_dir(get_turf(src), get_turf(T))
	playsound(src, 'sound/abnormalities/faelantern/faelantern_breach.ogg', 200, 1)
	SLEEP_CHECK_DEATH(2 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/faelantern/proc/EndEnchant(mob/living/carbon/human/victim, stunned = FALSE)//cannibalized apocalypse bird handling
	if(victim in lured_list)
		lured_list -= victim
		victim.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "fairy_lure", -HALO_LAYER))
		if(istype(victim.ai_controller,/datum/ai_controller/insane/faelantern))
			if(!stunned)
				to_chat(victim, span_boldwarning("You snap out of your trance!"))
			qdel(victim.ai_controller)

	//Effects
/obj/effect/temp_visual/faespike
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "faelantern_spike"
	duration = 10
	base_pixel_x = -16
	pixel_x = -16

/obj/effect/root/faelantern
	name = "root"
	desc = "A target warning you of incoming pain"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "vines"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/root_damage = 20 //Red Damage
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/root/faelantern/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 0.5 SECONDS)

/obj/effect/root/faelantern/proc/explode() //repurposed code from artillary bees, a delayed attack
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/attack.ogg', 50, 0, 8)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(0, target_turf))
		var/obj/effect/temp_visual/faespike/R = new(T)
		R.dir = dir
		switch(dir)
			if(EAST)
				R.pixel_x += 16
			if(WEST)
				R.pixel_x -= 16
		for(var/mob/living/L in T)
			L.apply_damage(root_damage, RED_DAMAGE, null, spread_damage = TRUE)
	qdel(src)

//AI controller, FIXME: reduce duplicate code

/datum/ai_controller/insane/faelantern
	lines_type = /datum/ai_behavior/say_line/insanity_faelantern
	var/last_message = 0

/datum/ai_behavior/say_line/insanity_faelantern
	lines = list(
		"Please, wait for me...",
		"Okay, I'm coming.",
		"Just a moment please.",
	)

/datum/ai_controller/insane/faelantern/SelectBehaviors(delta_time)
	..()
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return

	var/mob/living/simple_animal/hostile/abnormality/faelantern/fae
	for(var/mob/living/simple_animal/hostile/abnormality/faelantern/M in GLOB.mob_living_list)
		if(!istype(M))
			continue
		fae = M
	if(fae)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/faelantern_move)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = fae

/datum/ai_controller/insane/faelantern/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(DT_PROB(30, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	if(DT_PROB(25, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

/datum/ai_behavior/faelantern_move

/datum/ai_behavior/faelantern_move/perform(delta_time, datum/ai_controller/insane/faelantern/controller)
	. = ..()

	var/mob/living/carbon/human/living_pawn = controller.pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	var/mob/living/simple_animal/hostile/abnormality/faelantern/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!istype(target))
		finish_action(controller, FALSE)
		return

	if(!LAZYLEN(controller.current_path))
		controller.current_path = get_path_to(living_pawn, target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 80)
		if(!controller.current_path.len) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
		controller.current_path.Remove(controller.current_path[1])
		Movement(controller)

/datum/ai_behavior/faelantern_move/proc/Movement(datum/ai_controller/insane/faelantern/controller)
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/faelantern/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	if(world.time > controller.last_message + 10 SECONDS)
		controller.last_message = world.time
		controller.current_behaviors += GET_AI_BEHAVIOR(controller.lines_type)

	if(LAZYLEN(controller.current_path) && !IS_DEAD_OR_INCAP(living_pawn))
		var/target_turf = controller.current_path[1]
		if(target_turf && get_dist(living_pawn, target_turf) < 3)
			if(!step_towards(living_pawn, target_turf))
				controller.pathing_attempts++
			if(controller.pathing_attempts >= MAX_PATHING_ATTEMPTS)
				finish_action(controller, FALSE)
				return FALSE
			else
				if(get_turf(living_pawn) == target_turf)
					controller.current_path.Remove(target_turf)
					controller.pathing_attempts = 0
					if(isturf(target.loc) && (target in view(1,living_pawn)))
						finish_action(controller, TRUE)
						return
				else
					controller.pathing_attempts++
			var/move_delay = living_pawn.cached_multiplicative_slowdown + 0.1
			addtimer(CALLBACK(src, PROC_REF(Movement), controller), move_delay)
			return TRUE
	finish_action(controller, FALSE)
	return FALSE

/datum/ai_behavior/faelantern_move/finish_action(datum/ai_controller/insane/faelantern/controller, succeeded)
	. = ..()
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/faelantern/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	controller.pathing_attempts = 0
	controller.current_path = list()
	if(succeeded)
		target.EndEnchant(living_pawn, stunned = TRUE)
		living_pawn.Stun(3 SECONDS)
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

// Status Effect
/datum/status_effect/fairy_lure
	id = "fairylure"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/fairy_lure

/atom/movable/screen/alert/status_effect/fairy_lure
	name = "Fairy Lure"
	desc = "Your guard is lowered."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "fairy_lure"

/datum/status_effect/fairy_lure/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 5

/datum/status_effect/fairy_lure/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 5

#undef STATUS_EFFECT_FAIRYLURE
