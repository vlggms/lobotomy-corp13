//Brain go brrrr.
/mob/living/simple_animal/hostile/abnormality/my_sweet_home
	name = "My Sweet Home"
	desc = "This cozy little house is a safe nest built only for you. Everything is here for you..."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "sweet_home"
	icon_living = "sweet_home"
	icon_dead = "sweet_home_death"
	portrait = "my_sweet_home"
	var/can_act = TRUE
	threat_level = TETH_LEVEL
	can_breach = TRUE
	del_on_death = FALSE
	maxHealth = 600
	health = 600
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 0.9, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 15
	melee_damage_upper = 20
	melee_damage_type = RED_DAMAGE
	melee_queue_distance = 1
	retreat_distance = 0
	minimum_distance = 0
	stat_attack = CONSCIOUS
	attack_verb_continuous = "stomps"
	attack_verb_simple = "stomp"
	death_message = "crumbles."
	faction = list("hostile")
	start_qliphoth = 1

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 40, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 70, 80, 80, 90),
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 50, 40, 40),
	)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/hearth,
		/datum/ego_datum/armor/hearth,
	)
	gift_type =  /datum/ego_gifts/hearth
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "\"I am a home.\" <br>\
		A happy little home, just for you. <br>\
		A perfect, safe place away from this scary room. <br>\
		Everything for you. <br>\
		Won't you come inside?"
	observation_choices = list(
		"Don't go inside" = list(TRUE, "Some things are too good to be true. <br>\
			You take the key from under the doormat, and leave."),
		"Go inside" = list(FALSE, "A key appears in your hand. <br>\
			You move to open the door. <br>\
			But at the last minute, you are pulled away by another agent to safety."),
	)

	var/ranged_damage = 15
	var/damage_dealt = 0
	var/list/counter1 = list() //from FAN, although changed
	var/list/counter2 = list()
	var/slam_cooldown = 10 SECONDS
	var/slam_cooldown_time


/mob/living/simple_animal/hostile/abnormality/my_sweet_home/Moved()
	. = ..()
	if(!(status_flags & GODMODE)) // This thing's big, it should make some noise.
		playsound(get_turf(src), 'sound/abnormalities/sweethome/walk.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	to_chat(user, span_danger("It whispers in your mind..."))
	if(prob(50))
		to_chat(user, span_danger("...and you accept."))
		SLEEP_CHECK_DEATH(3)
		user.Stun(10 SECONDS)
		datum_reference.qliphoth_change(-1)
		user.gib()
		BreachEffect(user)
	else
		to_chat(user, span_danger("...and you almost agree but refuse at the last moment."))
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time) //grabbed from FAN
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		if(user in counter2)
			to_chat(user, span_danger("You grip the key and approach."))
			user.Stun(10 SECONDS)
			SLEEP_CHECK_DEATH(3)
			user.gib()
			datum_reference.qliphoth_change(-1)
			BreachEffect(user)
		else if(user in counter1)
			counter2+=user
			to_chat(user, span_danger("It speaks in your mind, reassuring you, you feel safe."))
		else
			counter1+=user
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/proc/AoeAttack()
	damage_dealt = 0
	var/list/hit_turfs = list()
	var/turf/target_turf = get_turf(src)
	for(var/turf/open/T in view(target_turf, 3))
		hit_turfs |= T
		for(var/mob/living/L in HurtInTurf(T, list(), ranged_damage, RED_DAMAGE, hurt_mechs = TRUE))
			if((L.stat < DEAD) && !(L.status_flags & GODMODE))
				damage_dealt += ranged_damage
	if(damage_dealt > 0)
		slam_cooldown_time = world.time + slam_cooldown
		for(var/turf/T in hit_turfs)
			new /obj/effect/temp_visual/smash_effect(T)
		playsound(get_turf(src), 'sound/abnormalities/sweethome/smash.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/Move()
	if(slam_cooldown_time < world.time)
		AoeAttack()
	return ..()

/obj/effect/temp_visual/smash1
	icon = 'icons/effects/effects.dmi'
	icon_state = "smash1"
	duration = 3

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/BreachEffect(user)//code grabbed from scorched_girl
	. = ..()
	update_icon_state()

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/update_icon_state() //code grabbed from forsaken_murderer and smile
	if(status_flags & GODMODE)
		icon_state = initial(icon)
	else if(health<1)
		icon_state = icon_dead
	else
		pixel_x = -16
		base_pixel_x = -16
		icon_state = "sweet_home_breach"

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()
