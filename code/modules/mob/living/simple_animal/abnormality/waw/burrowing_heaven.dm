/mob/living/simple_animal/hostile/abnormality/burrowing_heaven
	name = "The Burrowing Heaven"
	desc = "A leafless red tree consisting of bloody muscule tissue. Its many eyes stare directly at you."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "burrowingheaven"
	icon_living = "burrowingheaven_breached"
	icon_dead = "burrowingheaven"
	portrait = "heaven"
	del_on_death = TRUE
	maxHealth = 800
	health = 800
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -16
	base_pixel_y = -16

	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT

	can_breach = TRUE
	ranged = TRUE
	vision_range = 14
	aggro_vision_range = 20
	threat_level = WAW_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 50, 55, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 45, 50, 55),
	)
	work_damage_upper = 5
	work_damage_lower = 4
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride
	max_boxes = 24

	ego_list = list(
		/datum/ego_datum/weapon/heaven,
		/datum/ego_datum/armor/heaven,
	)
	gift_type =  /datum/ego_gifts/heaven
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "Don’t look away, just keep your eyes on it. Contain it in your sight."
	observation_choices = list(
		"Return the gaze" = list(TRUE, "Keep looking at it... Steadily... It’s alive, watching you in return, is it not?"),
		"Ignore it" = list(FALSE, "If you can't see it, you can't reach it."),
	)

	var/teleport_cooldown
	var/teleport_cooldown_time = 5 SECONDS
	var/gaze_damage = 150
	var/list/scream_sounds = list('sound/abnormalities/burrowingheaven/Heaven_Scream2.ogg','sound/abnormalities/burrowingheaven/Heaven_Scream3.ogg', 'sound/abnormalities/burrowingheaven/Heaven_Scream4.ogg')
	var/seen = FALSE
	var/workticks_unseen = 0//QLIP -1 for every 8 workticks

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/Life()
	. = ..()
	if(!.)
		return
	if(IsContained())
		return
	if(teleport_cooldown <= world.time)
		TryTeleport()

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/AttemptWork(mob/living/carbon/human/user, work_type)
	seen = FALSE
	if(!CheckViewers())//If the conditions are met, this will set "seen' to TRUE
		datum_reference.qliphoth_change(-1)
	. = ..()

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/ChanceWorktickOverride(mob/living/carbon/human/user, work_chance, init_work_chance, work_type)
	if(!seen)
		to_chat(user, span_warning("Don't look away."))
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(user), pick(GLOB.alldirs))
		return 0
	return init_work_chance

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/Worktick(mob/living/carbon/human/user)
	. = ..()
	if(!CheckViewers())
		workticks_unseen += 1
		if(workticks_unseen >= 8)
			datum_reference.qliphoth_change(-1)
			workticks_unseen = 0
		seen = FALSE

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(2)

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/BreachEffect(mob/living/carbon/human/user, breach_type)
	icon_state = icon_living
	sound_to_playing_players_on_level('sound/abnormalities/burrowingheaven/Heaven_Scream1.ogg', 45, zlevel = z)
	. = ..()

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/proc/CheckViewers()
	var/seen_count = 0//we need two people observing BH for it to count here
	for(var/mob/camera/ai_eye/remote/cam in viewers(8, src))//Checking for a camera is less computationally expensive and early returns, so we do this first.
		seen = TRUE
		return TRUE
	for(var/mob/living/carbon/human/L in viewers(8, src))
		if(L.stat != DEAD)
			if(is_A_facing_B(L,src))
				seen_count +=1
	if(seen_count >= 2)
		seen = TRUE
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/proc/TryTeleport(turf/teleport_target)
	if(teleport_cooldown > world.time)
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time//so it doesn't get called twice by life()
	if(!teleport_target)
		var/list/teleport_potential = list()
		for(var/mob/living/L in GLOB.mob_living_list)
			if(L.stat == DEAD || L.z != z || L.status_flags & GODMODE || faction_check_mob(L))
				continue
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.is_working)
					continue
			teleport_potential += get_turf(L)
		if(!LAZYLEN(teleport_potential))
			return
		var/targetted_mob = pick(teleport_potential)//This is the turf associated with the mob originally picked
		var/list/possible_locations = list()
		for(var/turf/T in oview(targetted_mob, 7)) //Only place the turrets on open turfs
			if(T.is_blocked_turf())
				continue
			possible_locations += T
		if(!LAZYLEN(possible_locations))
			return
		teleport_target = pick(possible_locations)//we want to appear at the edge of our target's field of view.
	flick("burrowingheaven_down", src)
	//down animation
	playsound(src, 'sound/abnormalities/burrowingheaven/Heaven_Atk3.ogg', 100, 1)
	SLEEP_CHECK_DEATH(4)
	forceMove(teleport_target)
	playsound(src, 'sound/abnormalities/burrowingheaven/Heaven_Dead.ogg', 100)
	density = FALSE
	//up animation
	flick("burrowingheaven_up", src)
	SLEEP_CHECK_DEATH(4)
	EyeAttack()

/mob/living/simple_animal/hostile/abnormality/burrowing_heaven/proc/EyeAttack()
	playsound(get_turf(src), 'sound/abnormalities/burrowingheaven/Heaven_Atk1.ogg', 50, 0, 5)
	for(var/turf/T in view(8, src))
		if(T.density)
			continue
		new /obj/effect/temp_visual/heaven_roots(T)
	SLEEP_CHECK_DEATH(12)
	var/hit_target = FALSE//do we play the scream sound
	for(var/mob/living/carbon/human/L in oview(8,src))
		if(L.stat != DEAD)
			if(!is_A_facing_B(L,src))
				L.apply_damage(gaze_damage,BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				hit_target = TRUE
	if(hit_target)
		var/chosen_sound = pick(scream_sounds)
		sound_to_playing_players_on_level(chosen_sound, 75, zlevel = z)
	else
		teleport_cooldown += 10 SECONDS

/obj/effect/temp_visual/heaven_roots
	name = "lean, bloody wings"
	icon_state = "heaven_roots"
	duration = 2 SECONDS
	layer = BELOW_OPEN_DOOR_LAYER//This is slightly below the table layer

/obj/effect/temp_visual/heaven_roots/Initialize()
	. = ..()
	animate(src, alpha = 0, time = 20)
