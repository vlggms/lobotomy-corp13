/mob/living/simple_animal/hostile/distortion/timeripper
	name = "The Time Ripper"
	desc = "A full-body prosthetic looking guy, he feels eerie."
	icon = 'ModularTegustation/Teguicons/Ripper32x64.dmi'
	icon_state = "Ripper1"
	icon_living = "Ripper1"
	icon_dead = "Ripper1"
	faction = list("hostile")
	maxHealth = 6000
	health = 6000
	pixel_x = 0
	base_pixel_x = 0
	pixel_x = 0
	melee_damage_lower = 15
	melee_damage_upper = 25
	melee_damage_type = BLACK_DAMAGE
	rapid_melee = 2
	attack_verb_continuous = "stabs"
	attack_verb_simple = "pierces"
	attack_sound = 'sound/weapons/fixer/generic/blade4.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.3)
	move_to_delay = 3
	ranged = TRUE
//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/he/nixie,
		/datum/ego_datum/weapon/thirteen
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Jack Knife")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/silence //Both hate their time being wasted and that there is a price to it, even if this thing cannot fight back.
	egoist_attributes = 100
	loot = list(/obj/item/documents/ncorporation, /obj/item/documents/ncorporation) //Placeholder, we need more loot items

	var/can_act = TRUE
	var/current_stage = 1 //changes behaviour slightly on phase 2
	var/stage_threshold = 3000 // enters stage 2 at or below this threshold
	var/countering = FALSE //are we
	var/nodehead = FALSE
	var/nightmare_mode = FALSE
	var/counter_threshold = 500 //300 at stage 2
	var/counter_ready = FALSE //are we ready to counter?
	var/damage_down = 5
	var/counter_speed = 2 //subtracted from the movedelay when dashing
	var/finishing = FALSE
	var/damage_taken
	var/frozen_time = 600

/mob/living/simple_animal/hostile/distortion/timeripper/proc/StageTransition()
	icon = 'ModularTegustation/Teguicons/Ripper64x64.dmi'
	icon_living = "Ripper2"
	pixel_x = -20
	if(!countering && can_act)
		icon_state = icon_living
	current_stage = 2
	//Speed changed from 6 to 4
	counter_threshold = 300
	playsound(get_turf(src), 'sound/effects/clockcult_gateway_disrupted.ogg', 75, 0, 3)

/mob/living/simple_animal/hostile/distortion/timeripper/proc/DashCounter() //increases move speed greatly temporarily.
	playsound(get_turf(src), 'sound/effects/hokma_meltdown.ogg', 75, 0, 3)
	switch(current_stage)
		if(1)
			icon_state = "Ripper1"
		if(2)
			icon_state = "Ripper2"
	countering = TRUE
	counter_ready = FALSE
	//Speed becomes 4 or 2 and returns to 6 or 4 after 4 seconds.
	TemporarySpeedChange(-counter_speed, 4 SECONDS)
	visible_message(span_warning("[src] suddenly moves faster towards [target]!"), span_notice("You accelerate self!"), span_notice("You hear footsteps speed up."))
	addtimer(CALLBACK(src, PROC_REF(DisableCounter)), 4 SECONDS) //disables the counter after 4 seconds

/mob/living/simple_animal/hostile/distortion/timeripper/proc/DisableCounter() //resets the counter
	if(countering)
		countering = FALSE
		playsound(get_turf(src), 'sound/effects/hokma_meltdown.ogg', 75, 0, 3)
		SLEEP_CHECK_DEATH(10)
		icon_state = icon_living

/mob/living/simple_animal/hostile/distortion/timeripper/OpenFire(target)
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


/mob/living/simple_animal/hostile/distortion/timeripper/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= counter_threshold && !counter_ready && !countering)
		counter_ready = TRUE
		damage_taken = 0
	if((health <= stage_threshold) && (current_stage == 1))
		StageTransition()

//The warden parts.

/mob/living/simple_animal/hostile/distortion/timeripper/AttackingTarget(atom/attacked_target)
	. = ..()
	if(.)
		if(finishing)
			return FALSE
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = attacked_target

		if(H.health < 0)

			finishing = TRUE
			icon = 'ModularTegustation/Teguicons/Ripper64x64.dmi'
			icon_state = "Ripper2"
			playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 50, 1)
			SLEEP_CHECK_DEATH(5)
			melee_damage_lower += damage_down
			melee_damage_upper += damage_down
			//Mmm, head.
			if(nodehead)
				H.gib()
			else
				var/obj/item/bodypart/head/head = H.get_bodypart("head")
				if(QDELETED(head))
					return
				head.dismember()
				QDEL_NULL(head)
				H.regenerate_icons()
				visible_message(span_danger("\The [src] takes [H]'s head off into his collection!"))
				new /obj/effect/gibspawner/generic/silent(get_turf(H))
				playsound(get_turf(src), 'sound/weapons/bladeslice.ogg', 250, TRUE)
				finishing = FALSE
				switch(current_stage)
					if(1)
						icon = 'ModularTegustation/Teguicons/Ripper32x64.dmi'
						icon_state = "Ripper1"
					if(2)
						icon_state = "Ripper2"


/mob/living/simple_animal/hostile/distortion/timeripper/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/timeripper/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/timeripper/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//Melee funnies.

/mob/living/simple_animal/hostile/distortion/timeripper/AttackingTarget(atom/attacked_target)
	if(finishing)
		return
	. = ..()
	if(.)
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = attacked_target
		H.add_movespeed_modifier(/datum/movespeed_modifier/grab_slowdown/aggressive)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/grab_slowdown/aggressive), 4 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/simple_animal/hostile/distortion/timeripper/AttackingTarget(atom/attacked_target)
	if(finishing)
		return
	. = ..()
	if(nightmare_mode)
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		new /obj/effect/timestop(get_turf(src), 1, 17, list(src))

/mob/living/simple_animal/hostile/distortion/timeripper/AttackingTarget(atom/attacked_target)
	if(finishing)
		return
	. = ..()
	var/mob/living/carbon/human/H = attacked_target
	if(nightmare_mode)
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		to_chat(H, span_warning("You suddenly freeze in place..."))
		addtimer(CALLBACK (H, TYPE_PROC_REF(/mob/living, Stun), frozen_time SECONDS), 1 SECONDS)

//Freezing time.
/mob/living/simple_animal/hostile/distortion/timeripper/proc/Timestop()
	say("Your time is mine!")
	SLEEP_CHECK_DEATH(12)
	new /obj/effect/timestop(get_turf(src), 5, 40, list(src))
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/timeripper/Life()
	. = ..()
	//Passive regen when below 50% health.
	if(health <= maxHealth*1 && stat != DEAD)
		adjustBruteLoss(-2)
		if(!target)
			adjustBruteLoss(-6)

