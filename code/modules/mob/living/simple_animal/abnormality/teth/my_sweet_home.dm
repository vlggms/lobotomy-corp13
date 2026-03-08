//Brain go brrrr.
/mob/living/simple_animal/hostile/abnormality/my_sweet_home
	name = "My Sweet Home"
	desc = "This cozy little house is a safe nest built only for you. Everything is here for you..."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "sweet_home"
	icon_living = "sweet_home"
	icon_dead = "sweet_home"
	core_icon = "sweet_home"
	portrait = "my_sweet_home"
	var/can_act = TRUE
	threat_level = TETH_LEVEL
	can_breach = TRUE
	del_on_death = FALSE
	maxHealth = 150
	health = 150
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 0.9, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 8
	rapid_melee = 1//Attacks really slow
	melee_reach = 3//But it has long limbs
	melee_damage_type = RED_DAMAGE
	melee_queue_distance = 3
	retreat_distance = 0
	minimum_distance = 0
	stat_attack = CONSCIOUS
	attack_verb_continuous = "stomps"
	attack_verb_simple = "stomp"
	death_message = "crumbles."
	faction = list("hostile")

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 40, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 70, 80, 80, 90),
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 50, 40, 40),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy

	ego_list = list(
		/datum/ego_datum/weapon/hearth,
		/datum/ego_datum/weapon/home,
		/datum/ego_datum/armor/hearth,
	)
	gift_type =  /datum/ego_gifts/hearth
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB
	can_spawn = FALSE // Normally doesn't appear

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

	var/ranged_damage = 8
	var/damage_dealt = 0
	var/list/counter1 = list() //from FAN, although changed
	var/list/counter2 = list()
	var/slam_cooldown = 10 SECONDS
	var/slam_cooldown_time
	var/mob/living/carbon/human/resident = null //Who's currently living inside my sweet home?
	var/someone_entering = FALSE
	var/list/longhair = list(
		"Floorlength Bedhead",
		"Long Side Part",
		"Long Bedhead",
		"Drill Hair (Extended)",
		"Long Hair 2",
		"Silky",
	)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/Moved()
	. = ..()
	if(!(status_flags & GODMODE)) // This thing's big, it should make some noise.
		playsound(get_turf(src), 'sound/abnormalities/sweethome/walk.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/FailureEffect(mob/living/carbon/human/user, work_type, pe, canceled)
	. = ..()
	//if(canceled)
		//return
	to_chat(user, span_danger("It whispers in your mind..."))
	user.Stun(1 SECONDS)
	SLEEP_CHECK_DEATH(5)
	if(prob(50))
		to_chat(user, span_danger("...and you accept."))
		Approach(user)
	else
		to_chat(user, span_danger("...and you almost agree but refuse at the last moment."))
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/AttemptWork(mob/living/carbon/human/user, work_type)
	if(!someone_entering)
		return ..()

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time) //grabbed from FAN
	if(user.sanity_lost)
		Approach(user)
		return
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		if(user in counter2)
			Approach(user)
			return
		else if(user in counter1)
			counter2+=user
			to_chat(user, span_danger("It speaks in your mind, reassuring you, you feel safe."))
		else
			counter1+=user
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/proc/Approach(mob/living/carbon/human/user)
	if(user.stat >= SOFT_CRIT)
		return
	someone_entering = TRUE
	if(user.sanity_lost)
		QDEL_NULL(user.ai_controller)
	user.Stun(5 SECONDS)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		someone_entering = FALSE
		return
	to_chat(user, span_danger("You grip the key and approach."))
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		someone_entering = FALSE
		return
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		someone_entering = FALSE
		return
	playsound(get_turf(src), 'sound/machines/door_open.ogg', 50, 1)
	to_chat(user, span_danger("You open the door and..."))
	sleep(0.5 SECONDS)
	someone_entering = FALSE
	BreachEffect(user)

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

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/BreachEffect(mob/living/carbon/human/user, breach_type)//code grabbed from scorched_girl
	if(!user && (breach_type != BREACH_MINING && breach_type != BREACH_PINK))
		return
	. = ..()
	update_icon_state()
	desc = "A large, shadowy figure that's clearly too big to fit into the little house they're in."
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "sweet_home_breach"
	if(user)
		melee_damage_lower = 8
		melee_damage_upper = 10
		ranged_damage = 10
		maxHealth = 280
		health = 280
		desc = "A large figure that's clearly too big to fit into the little house they're in... Wait, isn't that [user]?"
		resident = user
		user.forceMove(src)
		user.death()
		var/hair_icon = "sweet_home_breach_hair"
		if(user.hairstyle in longhair)
			hair_icon = "sweet_home_breach_longhair"
		var/mutable_appearance/skin_overlay = mutable_appearance(icon, "sweet_home_breach_skin", layer + 0.1)
		var/mutable_appearance/eye_overlay = mutable_appearance(icon, "sweet_home_breach_eye", layer + 0.2)
		var/mutable_appearance/hair_overlay = mutable_appearance(icon, hair_icon, layer + 0.3)
		if(user.skin_tone)
			skin_overlay.color = "#[skintone2hex(user.skin_tone)]"
		if(user.eye_color)
			eye_overlay.color = "#[user.eye_color]"
		if(user.hair_color)
			hair_overlay.color = "#[user.hair_color]"
		add_overlay(skin_overlay)
		add_overlay(eye_overlay)
		if(user.hairstyle != "Bald")
			add_overlay(hair_overlay)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/death(gibbed)
	density = FALSE
	cut_overlays()
	icon_state = "sweet_home"
	pixel_x = 0
	base_pixel_x = 0
	animate(src, time = 10 SECONDS, alpha = 0)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/Destroy()
	if(!resident)
		return ..()
	//I know the body inside home goes back in when it dies in wonderlab, but we should probably just return the guy instead
	resident.forceMove(get_turf(src))
	resident.gib()//Poor fuck got crushed.
	resident = null
	return ..()
