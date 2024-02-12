/mob/living/simple_animal/hostile/clan
	name = "scout"
	desc = "scout"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "scout"
	icon_living = "scout"
	icon_dead = "scout"
	faction = list("resurgence_clan", "neutral")
	wander = 0
	obj_damage = 5
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	environment_smash = FALSE
	mob_biotypes = MOB_ROBOTIC
	gender = NEUTER
	speech_span = SPAN_ROBOT
	emote_hear = list("creaks.", "emits the sound of grinding gears.")
	speak_chance = 1
	a_intent = "help"
	maxHealth = 300 //100 less due to loss of arm
	health = 300
	death_message = "falls to their knees as the sound of gears slowly fades."
	melee_damage_lower = 0
	melee_damage_upper = 4
	mob_size = MOB_SIZE_LARGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	var/charge = 0
	var/max_charge = 10


/mob/living/simple_animal/hostile/clan/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(GainCharge)), 2 SECONDS)

/mob/living/simple_animal/hostile/clan/proc/GainCharge()
	if (charge < max_charge)
		charge += 1
		ChargeUpdated()
	addtimer(CALLBACK(src, PROC_REF(GainCharge)), 2 SECONDS)

/mob/living/simple_animal/hostile/clan/proc/ChargeUpdate()

/mob/living/simple_animal/hostile/clan/scout
	var/max_speed = 2
	var/normal_speed = 3
	var/max_attack_speed = 3
	var/normal_attack_speed = 1

/mob/living/simple_animal/hostile/clan/scout/ChargeUpdated()
	move_to_delay = normal_speed - (normal_speed - max_speed) * charge / max_charge
	rapid_melee = normal_attack_speed + (max_attack_speed - normal_attack_speed) * charge / max_charge
	UpdateSpeed()

/mob/living/simple_animal/hostile/clan/scout/AttackingTarget()
	. = ..()
	if (charge > 0)
		charge -= 1
	say("Lost 1 Charge")
