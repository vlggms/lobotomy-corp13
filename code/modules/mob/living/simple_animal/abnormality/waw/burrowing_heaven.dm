/mob/living/simple_animal/hostile/abnormality/burrowingheaven
	name = "Burrowing Heaven"
	desc = "A giant, bloody red tree."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "burrowingheaven_contained"
	icon_living = "burrowingheaven_contained"
	pixel_x = -32
	base_pixel_x = -32
	del_on_death = TRUE
	maxHealth = 1200		//It's really fast
	health = 1200
	move_to_delay = 0
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	melee_damage_lower = 99
	melee_damage_upper = 97
	melee_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stabs"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 4
	wander = 0
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = list(30, 40, 40, 50, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 40, 30, 20),
						ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 55, 60)
						)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
//		/datum/ego_datum/weapon/heaven,
//		/datum/ego_datum/armor/heaven
		)
//	gift_type =  /datum/ego_gifts/heaven

	var/seen	//Are you being looked at right now?
	var/solo_punish //Are you alone?

//Sight Check
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/Life()
	. = ..()
	solo_punish = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD) //Someone else is alive, just not on the Z level. Probably a manager. Thus, someone else COULD see this thing
			solo_punish = TRUE

	//Who is watching us
	var/people_watching
	for(var/mob/living/carbon/human/L in viewers(world.view + 1, src))
		if(L.client && CanAttack(L) && L.stat != DEAD)
			if(!L.is_blind())
				people_watching += 1
				seen = TRUE


	//Only gets mad if you are NOT alone.
	if(people_watching > 1)
		datum_reference.qliphoth_change(-1)
		seen = TRUE
	else
		seen = FALSE

//Stuff that needs sight check
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/Move()
	if(seen)
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are eyes on you!</span>")
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/burrowingheaven/AttackingTarget()
	if(seen)
		if(client)
			to_chat(src, "<span class='warning'>You cannot attack, there are eyes on you!</span>")
		return FALSE

	..()	//To do; Unique animation.
	if(!solo_punish)
		SLEEP_CHECK_DEATH(5 SECONDS)

	else	//If you're literally alone it's an armor check.
		SLEEP_CHECK_DEATH(120 SECONDS)

// unique patrol
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/patrol_select()
	var/list/target_turfs = list() // Stolen from Punishing Bird
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(H.stat == DEAD)//Fucking dead.
			continue
		if(get_dist(src, H) < 4) // Unnecessary for this distance
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, /turf/proc/Distance_cardinal, 0, 200)
		return
	return ..()


//Work stuff
//Need 2 people to actually work on it
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/ChanceWorktickOverride(mob/living/carbon/human/user, work_chance, init_work_chance, work_type)
	if(seen) //If you're only considered "seen" because the other living player(s) are all on another Z level, disregard it during work specifically.
		to_chat(user, "<span class='warning'>You are injured by [src]!</span>") // Keeping it clear that the bad work is from being seen and not just luck.
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(user), pick(GLOB.alldirs))
		datum_reference.qliphoth_change(-1)
		return 0
	return init_work_chance

/mob/living/simple_animal/hostile/abnormality/burrowingheaven/BreachEffect(mob/living/carbon/human/user)
	..()
	icon_living = "burrowingheaven_breach"
	icon_state = icon_living
	GiveTarget(user)
