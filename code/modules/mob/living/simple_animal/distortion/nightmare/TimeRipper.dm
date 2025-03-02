//He is too weak to go into Star but he is also a major pain in the ass, so Urban Nightmare seems right.
/mob/living/simple_animal/hostile/distortion/Timeripper
	name = "The Time Ripper"
	desc = "Looks like a prosthetic user from T-Corp."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "Ripper"
	icon_living = "Ripper"
	maxHealth = 6000 //Decently high. 2 phase boss. 3000 for each.
	health = 6000
	fear_level = HE_LEVEL
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.2)
	melee_damage_lower = 25
	melee_damage_upper = 30
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	ranged = TRUE
	attack_sound = 'sound/weapons/fixer/generic/nail2.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "pierces"
	var/can_act = TRUE
	var/current_stage = 1 //changes behaviour slightly on phase 2
	var/counter_threshold = 300
	var/stage_threshold = 3000 // enters stage 2 at or below this threshold
	var/finishing = FALSE
	var/countering = FALSE //are we //Are you?
	var/counter_speed = 2 //subtracted from the movedelay when dashing
	var/counter_ready = FALSE
	var/damage_taken

	loot = list(/obj/item/documents/ncorporation, /obj/item/documents/ncorporation)

/mob/living/simple_animal/hostile/distortion/Timeripper/proc/DashCounter() //increases move speed and hits with a powerful attack that knocks back far away
	playsound(get_turf(src), 'sound/effects/hokma_meltdown.ogg', 75, 0, 3)
	switch(current_stage)
		if(1)
			icon_state = "Ripper"
		if(2)
			icon_state = "Ripper2"
	countering = TRUE
	counter_ready = FALSE
	//Speed becomes 4 or 2 and returns to 6 or 4 after 4 seconds.
	TemporarySpeedChange(-counter_speed, 4 SECONDS)
	visible_message(span_warning("[src] sprints toward [target] with accelerated speed!"), span_notice("You accelerate self!"), span_notice("You hear footsteps speed up."))
	addtimer(CALLBACK(src, PROC_REF(DisableCounter)), 4 SECONDS) //disables the counter after 4 seconds

/mob/living/simple_animal/hostile/distortion/Timeripper/proc/DisableCounter() //resets the counter
	if(countering)
		countering = FALSE
		playsound(get_turf(src), 'sound/effects/hokma_meltdown.ogg', 75, 0, 3)
		SLEEP_CHECK_DEATH(10)
		icon_state = icon_living

/mob/living/simple_animal/hostile/distortion/Timeripper/OpenFire(target)
	if(!can_act)
		return

	if(counter_ready)
		switch(current_stage)
			if(1)
				return DashCounter()
			if(2)
				if(prob(80))
					if(isliving(target))
						return Timestop(target)
				return DashCounter()
		return



//Phase 2
/mob/living/simple_animal/hostile/distortion/Timeripper/proc/StageTransition()
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_living = "Ripper2"
	if(!countering && can_act)
		icon_state = icon_living
	current_stage = 2
	counter_threshold = 300
	playsound(get_turf(src), 'sound/effects/clockcult_gateway_disrupted.ogg', 75, 0, 3)

/mob/living/simple_animal/hostile/distortion/Timeripper/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= counter_threshold && !counter_ready && !countering)
		counter_ready = TRUE
		damage_taken = 0
	if((health <= stage_threshold) && (current_stage == 1))
		StageTransition()



/mob/living/simple_animal/hostile/distortion/Timeripper/AttackingTarget(atom/attacked_target)
	. = ..()
	if(.)
		if(finishing)
			return FALSE
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = attacked_target

		if(H.health < 0)

			finishing = TRUE
			icon_state = "Ripper2"
			playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 50, 1)
			SLEEP_CHECK_DEATH(5)

			//Steals your brain and time, dusting your body, borrowed from Warden.
			H.dust()
			melee_damage_lower += damage_up
			melee_damage_upper += damage_up
			finishing = FALSE
			switch(current_stage)
				if(1)
					icon_state = "Ripper"
				if(2)
					icon_state = "Ripper2"


/mob/living/simple_animal/hostile/distortion/Timeripper/Life()
	. = ..()
	//Passive regen.
	if(health <= maxHealth*0.99 && stat != DEAD)
		adjustBruteLoss(-2)
		if(!target)
			adjustBruteLoss(-6)

	
/mob/living/simple_animal/hostile/distortion/Timeripper/AttackingTarget(atom/attacked_target) //His blades are pretty fucked up but this is better than freezing you in time each melee hit.
	if(finishing)
		return
	. = ..()
	if(.)
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = attacked_target
		H.add_movespeed_modifier(/datum/movespeed_modifier/grab_slowdown/aggressive)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/grab_slowdown/aggressive), 4 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		
		
