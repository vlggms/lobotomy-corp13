//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/clown
	name = "Clown Smiling at Me"
	desc = "An unnerving clown."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "clown_smiling"
	icon_living = "clown_smiling"
	var/icon_aggro = "clown_breach"
	icon_dead = "clown_breach"
	portrait = "clown_smiling"
	pixel_y = 64
	base_pixel_y = 64
	speak_emote = list("honks")
	maxHealth = 1800
	health = 1800
	rapid_melee = 4
	melee_queue_distance = 4
	damage_coeff = list(BRUTE = 1.0, RED_DAMAGE = 1.0, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 1.5)
	melee_damage_lower = 15
	melee_damage_upper = 15
	melee_damage_type = RED_DAMAGE
	see_in_dark = 10
	stat_attack = DEAD
	move_to_delay = 3
	threat_level = WAW_LEVEL
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	friendly_verb_continuous = "honks"
	friendly_verb_simple = "honk"
	can_breach = TRUE
	patrol_cooldown_time = 5 SECONDS
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 55, 60, 65, 65),
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	death_message = "blows up like a balloon!"
	speak_chance = 2
	emote_see = list("honks.")
	emote_hear = list("honks.")
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/clown_throw
	projectilesound = 'sound/abnormalities/clownsmiling/throw.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/mini/mirth,
		/datum/ego_datum/weapon/mini/malice,
		/datum/ego_datum/armor/darkcarnival,
	)
	gift_type =  /datum/ego_gifts/darkcarnival
	gift_message = "Life isn't scary when you don't fear death."
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	del_on_death = FALSE //for explosions
	var/finishing = FALSE
	var/step = FALSE

//A clown isn't a clown without his shoes
/mob/living/simple_animal/hostile/abnormality/clown/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()
	pixel_y = 0
	base_pixel_y = 0
	AddElement(/datum/element/waddling)
	playsound(get_turf(src), 'sound/abnormalities/clownsmiling/announce.ogg', 75, 1)
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/clown/Moved()
	. = ..()
	if(step)
		playsound(get_turf(src), 'sound/effects/clownstep2.ogg', 30, 0, 3)
		step = FALSE
		return
	playsound(get_turf(src), 'sound/effects/clownstep1.ogg', 30, 0, 3)
	step = TRUE

/mob/living/simple_animal/hostile/abnormality/clown/update_icon_state()
	if(status_flags & GODMODE)	// Not breaching
		icon_state = initial(icon)
	else
		icon_state = icon_aggro

//Execution code from green dawn with inflated damage numbers
/mob/living/simple_animal/hostile/abnormality/clown/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/clown/AttackingTarget()
	. = ..()
	if(.)
		if(!ishuman(target))
			return
		var/mob/living/carbon/human/TH = target
		if(TH.health < 0)
			finishing = TRUE
			TH.Stun(4 SECONDS)
			forceMove(get_turf(TH))
			for(var/i = 1 to 7)
				if(!targets_from.Adjacent(TH) || QDELETED(TH))
					finishing = FALSE
					return
				TH.attack_animal(src)
				for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
					H.apply_damage(5, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				SLEEP_CHECK_DEATH(2)
			if(!targets_from.Adjacent(TH) || QDELETED(TH))
				finishing = FALSE
				return
			playsound(get_turf(src), 'sound/abnormalities/clownsmiling/final_stab.ogg', 50, 1)
			TH.gib()
			for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
				H.apply_damage(30, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/abnormality/clown/MoveToTarget(list/possible_targets)
	if(ranged_cooldown <= world.time)
		OpenFire(target)
	return ..()

// Prevents knife throwing in mele range
/mob/living/simple_animal/hostile/abnormality/clown/OpenFire(atom/A)
	if(get_dist(src, A) <= 2) //no shooty in mele
		return FALSE
	return ..()

// Modified patrolling
/mob/living/simple_animal/hostile/abnormality/clown/patrol_select()
	var/list/target_turfs = list() // Stolen from Punishing Bird
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4) // Unnecessary for this distance
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()

//When the work result was good...
/mob/living/simple_animal/hostile/abnormality/clown/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/clown/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//Death explosion
/mob/living/simple_animal/hostile/abnormality/clown/death(gibbed)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 20)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 20)
	..()

/mob/living/simple_animal/hostile/abnormality/clown/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	playsound(get_turf(src), 'sound/abnormalities/clownsmiling/announcedead.ogg', 75, 1)
	for(var/mob/living/L in view(5, src))
		if(!faction_check_mob(L))
			L.apply_damage(50, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	gib()

//Clown picture-related code
/mob/living/simple_animal/hostile/abnormality/clown/PostSpawn()
	..()
	if(locate(/obj/structure/clown_picture) in get_turf(src))
		return
	new /obj/structure/clown_picture(get_turf(src))

/obj/structure/clown_picture
	name = "clown picture"
	desc = "A picture of a clown, torn at the seams."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "clown_picture"
	anchored = TRUE
	density = FALSE
	layer = WALL_OBJ_LAYER
	resistance_flags = INDESTRUCTIBLE
	pixel_y = 64
	base_pixel_y = 64
	var/datum/looping_sound/clown_ambience/circustime

/obj/structure/clown_picture/Initialize()
	. = ..()
	circustime = new(list(src), TRUE)
