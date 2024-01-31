/mob/living/simple_animal/hostile/abnormality/burrowingheaven
	name = "Burrowing Heaven"
	desc = "A giant, bloody red tree."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "burrowingheaven_contained"
	icon_living = "burrowingheaven_contained"
	pixel_x = -32
	base_pixel_x = -32
	del_on_death = TRUE
	maxHealth = 600		//It normally just counters
	health = 600
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
		/datum/ego_datum/weapon/heaven,
		/datum/ego_datum/armor/heaven
		)
//	gift_type =  /datum/ego_gifts/heaven

	var/seen	//Are you being looked at right now?
	var/solo_punish //Are you alone?
	var/abno_seen //Is an abnormality in view?
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

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


	//Only gets mad if you are NOT alone.
	if(people_watching > 1)
		seen = TRUE
	else
		seen = FALSE

	//Checking for abnos.
	abno_seen = FALSE
	for(var/mob/living/simple_animal/hostile/abnormality/B in view(10))
		abno_seen = TRUE
		break


//Stuff that needs sight check
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/burrowingheaven/AttackingTarget()
	return FALSE



//Counter
//Ranged stuff
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/bullet_act(obj/projectile/Proj)
	..()
	var/mob/living/carbon/human/H = Proj.firer
	if(abno_seen)
		Punishment(H)


/mob/living/simple_animal/hostile/abnormality/burrowingheaven/attacked_by(obj/item/I, mob/living/user)
	..()
	if(!user)
		return
	if(abno_seen)
		Punishment(user)

/mob/living/simple_animal/hostile/abnormality/burrowingheaven/proc/Punishment(mob/living/sinner)
	to_chat(sinner, span_userdanger("Burrowing Heaven sears into your skull!"))
	sinner.apply_damage(30, BLACK_DAMAGE, null, sinner.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(sinner), pick(GLOB.alldirs))

//Chufflin around
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	teleport()

/mob/living/simple_animal/hostile/abnormality/burrowingheaven/proc/teleport()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	addtimer(CALLBACK(src, .proc/aoe), 2 SECONDS)

//The actual attack
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/proc/aoe()
	for(var/mob/living/carbon/human/H in view(7))
		to_chat(H, span_userdanger("Burrowing Heaven burns into your skull!"))
		H.apply_damage(70, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(H), pick(GLOB.alldirs))
	addtimer(CALLBACK(src, .proc/teleport), 50 SECONDS)

//Work stuff
//Need 2 people to actually work on it
/mob/living/simple_animal/hostile/abnormality/burrowingheaven/ChanceWorktickOverride(mob/living/carbon/human/user, work_chance, init_work_chance, work_type)
	if(!seen) //If you're only considered "seen" because the other living player(s) are all on another Z level, disregard it during work specifically.
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
