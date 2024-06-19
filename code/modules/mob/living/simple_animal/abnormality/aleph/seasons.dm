#define STATUS_EFFECT_FREEZING /datum/status_effect/freezing
#define STATUS_EFFECT_FOGBOUND /datum/status_effect/fogbound
#define SEASONS_SLAM_COOLDOWN (20 SECONDS)

/mob/living/simple_animal/hostile/abnormality/seasons
	name = "God of the Seasons"
	desc = "By jove, what is that?!?"
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "" //probably better to start off invisible than the wrong state for a decisecond or i'll get a stream of "bug reports"
	icon_living = ""
	pixel_x = -16
	base_pixel_x = -16
	speak_emote = list("intones")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/creatures/venus_trap_hurt.ogg'
	ranged = TRUE
	projectiletype = /obj/projectile/season_projectile
	projectilesound = 'sound/creatures/venus_trap_hurt.ogg'
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL
	health = 4000
	maxHealth = 4000
	obj_damage = 600
	damage_coeff = list(RED_DAMAGE = 1.1, WHITE_DAMAGE = -1, BLACK_DAMAGE = 1.1, PALE_DAMAGE = 1.1)
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 35
	melee_damage_upper = 45
	speed = 3
	move_to_delay = 4
	is_flying_animal = FALSE
	start_qliphoth = 1
	can_breach = TRUE
	light_color = COLOR_TEAL
	light_range = 0
	light_power = 0
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(5, 10, 15, 50, 55),
		ABNORMALITY_WORK_INSIGHT = list(5, 10, 15, 50, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(5, 10, 15, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(5, 10, 15, 50, 55),
	)
	work_damage_amount = 14
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/seasons,
		/datum/ego_datum/armor/seasons,
	)

	gift_type =  /datum/ego_gifts/seasons
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

//Should be unique for each season, for now let's use Spring
	observation_prompt = "I'm standing outside a forest I both have never seen before, yet know well. <br>There is no City, no civilization on the horizon, I am utterly alone. <br>\
		Dauntlessly, I press into the forest, seeing no other path forward, and encounter a cute-looking, pink forest spirit. <br>\
		The spirits of the forest are playful, but it's best not to offend them by forgetting to make an offering"
	observation_choices = list("Make an offering", "Continue on")
	correct_choices = list("Make an offering")
	observation_success_message = "I ask the spirit to lead me to an altar to make my offering and it leads me off a beaten path... <br>\
		It felt as though I had walked for miles and days, my clothes torn and skin pricked by brambles and thorns but finally we arrived. <br>\
		Before me is a skull-headed pagan God hanging ominously over its altar, fear grips my heart as the pink spirit leads me to lay down on the altar..."
	observation_fail_message = "I pass by the spirit and hear it giggle ominously... <br>\
		... <br>\
		In the end, I am never able to find a way out of the forest."

	//Var Lists
	var/list/season_stats = list(
		"spring" = list(/datum/weather/thunderstorm, WHITE_DAMAGE, "Spring God", "Spring Deity, \"Caprice\" Panz","A bashful spirit cloaked in flower pedals.","A mischievous deity."),
		"summer" = list(/datum/weather/heatwave, RED_DAMAGE, "Summer God", "Summer Deity, \"Great Heat\" T'cau", "A hot-headed spirit.","He looks angry."),
		"fall" = list(/datum/weather/fog, BLACK_DAMAGE, "Autumn God", "Fall Deity, \"Hegemon\" Ber","A calm and collected spirit cloaked in leaves.","A powerful tree spirit."),
		"winter" = list(/datum/weather/freezing_wind, PALE_DAMAGE, "Winter God", "Winter Deity, \"Quietus\" Fuyuryou","A regal-looking snow spirit.","This winter brings bitter cold.")
	)

	var/list/breaching_stats = list(
		"spring" = list('sound/creatures/venus_trap_hurt.ogg', 'sound/abnormalities/seasons/spring_change.ogg', /obj/projectile/season_projectile/spring, /obj/effect/season_effect/spring, /obj/effect/season_effect/breath/spring, /obj/effect/season_warn/spring, /obj/effect/season_warn/spring),
		"summer" = list('sound/abnormalities/seasons/summer_attack.ogg', 'sound/abnormalities/seasons/summer_change.ogg', /obj/projectile/season_projectile/summer, /obj/effect/season_effect/summer, /obj/effect/season_effect/breath/summer, /obj/effect/season_warn/summer, /obj/effect/season_warn/summer),
		"fall" = list('sound/abnormalities/seasons/fall_attack.ogg', 'sound/abnormalities/seasons/fall_change.ogg', /obj/projectile/season_projectile/fall, /obj/effect/season_effect/fall, /obj/effect/season_effect/breath/fall, /obj/effect/season_warn/fall, /obj/effect/season_warn/fall),
		"winter" = list('sound/abnormalities/seasons/winter_attack.ogg', 'sound/abnormalities/seasons/winter_change.ogg', /obj/projectile/season_projectile/winter, /obj/effect/season_effect/winter, /obj/effect/season_effect/breath/winter, /obj/effect/season_warn/winter, /obj/effect/season_warn/winterspikes)
	)

	var/list/modular_work_chance = list( //You can work anything on it! Just not all at once.
		"spring" = list(
			ABNORMALITY_WORK_INSTINCT = list(5, 10, 15, 35, 40),
			ABNORMALITY_WORK_INSIGHT = list(5, 10, 15, 50, 55),
			ABNORMALITY_WORK_ATTACHMENT = 0,
			ABNORMALITY_WORK_REPRESSION = 0,
			),

		"summer" = list(
			ABNORMALITY_WORK_INSTINCT = list(5, 10, 15, 50, 55),
			ABNORMALITY_WORK_INSIGHT = 0,
			ABNORMALITY_WORK_ATTACHMENT = list(5, 10, 15, 35, 40),
			ABNORMALITY_WORK_REPRESSION = 0,
			),

		"fall" = list(
			ABNORMALITY_WORK_INSTINCT = 0,
			ABNORMALITY_WORK_INSIGHT = 0,
			ABNORMALITY_WORK_ATTACHMENT = list(5, 10, 15, 50, 55),
			ABNORMALITY_WORK_REPRESSION = list(5, 10, 15, 35, 40),
			),

		"winter" = list(
			ABNORMALITY_WORK_INSTINCT = 0,
			ABNORMALITY_WORK_INSIGHT = list(5, 10, 15, 35, 40),
			ABNORMALITY_WORK_ATTACHMENT = 0,
			ABNORMALITY_WORK_REPRESSION = list(5, 10, 15, 50, 55),
			)
		)

	var/list/modular_damage_coeff = list(
		"spring" = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1),
		"summer" = list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.8), //Summer is tanky
		"fall" = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.8),
		"winter" = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.2)
		)

	//Work Vars
	var/current_season = "winter"
	var/downgraded
	var/safe
	var/work_timer
	//Breach Vars
	var/can_act = TRUE
	var/can_move = TRUE
	var/slam_damage = 200
	var/slam_cooldown
	var/slam_cooldown_time = 20 SECONDS
	var/cone_attack_damage = 90
	var/cone_attack_cooldown
	var/cone_attack_cooldown_time = 10 SECONDS
	var/special_attack_cooldown
	var/special_attack_cooldown_time = 15 SECONDS
	var/pulse_cooldown
	var/pulse_cooldown_time = 4 SECONDS
	var/pulse_range = 5
	var/pulse_damage = 15
	var/list/summons = list()
	var/list/structures = list()
	var/list/zombies = list()
	var/fire_wall_amount = 3
	var/fire_width = 3
	var/fire_length = 5
	var/fire_damage = 150
	var/wisp_amount = 6
	var/bomb_amount = 4
	var/trap_amount = 6
	//PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/cooldown/seasons_slam,
		/datum/action/innate/abnormality_attack/toggle/seasons_cone_toggle,
	)

/datum/action/cooldown/seasons_slam
	name = "Slam"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "generic_slam"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = SEASONS_SLAM_COOLDOWN //20 seconds

/datum/action/cooldown/seasons_slam/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/seasons))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/seasons/seasons = owner
	if(seasons.IsContained()) // No more using cooldowns while contained
		return FALSE
	StartCooldown()
	seasons.Slam()
	return TRUE

/datum/action/innate/abnormality_attack/toggle/seasons_cone_toggle
	name = "Toggle Breath"
	button_icon_state = "generic_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't use your breath anymore.")
	button_icon_toggle_activated = "generic_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now breath a cone of elemental energy.")
	button_icon_toggle_deactivated = "generic_toggle0"


//Spawning
/mob/living/simple_animal/hostile/abnormality/seasons/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_SEASON_CHANGE, PROC_REF(Transform))

/mob/living/simple_animal/hostile/abnormality/seasons/PostSpawn()
	. = ..()
	dir = SOUTH
	Transform()
	work_timer = addtimer(CALLBACK(src, PROC_REF(WorkCheck)), 9 MINUTES, TIMER_OVERRIDE & TIMER_UNIQUE & TIMER_STOPPABLE)
	if((locate(/obj/effect/season_turf) in range(1, src)))
		return
	Downgrade()

//Work Stuff
/mob/living/simple_animal/hostile/abnormality/seasons/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	if(downgraded)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/seasons/AttemptWork(mob/living/carbon/human/user, work_type)
	if(CheckWeather())
		to_chat(user, span_warning("The abnormality seems to be ignoring you!"))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/seasons/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(downgraded)
		return
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/seasons/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(!safe)
		to_chat(user, span_nicegreen("The abnormality seems to be satisfied, at least for now..."))
		safe = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(!safe)
		if(prob(25))
			to_chat(user, span_nicegreen("The abnormality seems to be satisfied, at least for now..."))
			safe = TRUE
			return
		to_chat(user, span_warning("The abnormality seems to be indifferent to this attempt at work, perhaps you should try again?"))

/mob/living/simple_animal/hostile/abnormality/seasons/WorkChance(mob/living/carbon/human/user, chance) //suspect this does not work
	if(downgraded)
		if(chance > 0) //WAW form is a bit more lenient on work
			return chance + 10
		if(chance == 0)
			return chance + 20
	return chance

//Transformations
/mob/living/simple_animal/hostile/abnormality/seasons/proc/Transform()
	current_season = SSlobotomy_events.current_season
	var/list/new_work_chances = modular_work_chance[current_season]
	work_chances = new_work_chances.Copy()
	datum_reference.available_work = work_chances
	ChangeResistances(modular_damage_coeff[current_season])
	work_damage_type = season_stats[current_season][2]
	melee_damage_type = season_stats[current_season][2]
	icon_state = current_season
	portrait = "[current_season]_deity"
	name = season_stats[current_season][4]
	desc = season_stats[current_season][6]
	attack_sound = breaching_stats[current_season][1]
	projectilesound = breaching_stats[current_season][1]
	playsound(get_turf(src), "[breaching_stats[current_season][2]]", 30, 0, 8)
	projectiletype = breaching_stats[current_season][3]
	light_range = 0
	light_power = 0
	update_light()
	if(downgraded)
		icon_state = "[current_season]_mini"
		portrait = "[current_season]"
		name = season_stats[current_season][3]
		desc = season_stats[current_season][5]
	else
		if(current_season == "fall")
			light_color = COLOR_TEAL
			light_range = 5
			light_power = 7
			update_light()
		if(current_season == "summer")
			light_color = LIGHT_COLOR_FIRE
			light_range = 5
			light_power = 7
			update_light()
	if(current_season == "winter")
		cone_attack_damage = 75
		slam_damage = 125
		pulse_damage = 10
	else
		cone_attack_damage = initial(cone_attack_damage)
		slam_damage = initial(slam_damage)
		pulse_damage = initial(pulse_damage)
	if(current_season == "summer")
		can_move = FALSE
		pulse_range = 10
	else
		can_move = TRUE
		pulse_range = 5
	update_icon()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Downgrade()
	downgraded = TRUE
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	Transform()
	can_breach = FALSE
	fear_level = WAW_LEVEL
	work_damage_amount = 7
	start_qliphoth = 1
	datum_reference.qliphoth_meter_max = 5
	datum_reference.qliphoth_change(4)
	is_flying_animal = TRUE
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Upgrade()
	downgraded = FALSE
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	Transform()
	can_breach = TRUE
	fear_level = ALEPH_LEVEL
	work_damage_amount = 14
	datum_reference.qliphoth_meter_max = 1
	datum_reference.qliphoth_change(1)
	is_flying_animal = FALSE
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	update_icon()
	for(var/turf/open/O in range(1, src))
		new /obj/effect/season_turf(O)

//Breach Stuff
/mob/living/simple_animal/hostile/abnormality/seasons/proc/WorkCheck()
	if(!CheckWeather() && !safe)
		StartWeather()
		work_timer = addtimer(CALLBACK(src, PROC_REF(WorkCheck)), 30 SECONDS, TIMER_OVERRIDE & TIMER_UNIQUE & TIMER_STOPPABLE)
		return
	work_timer = addtimer(CALLBACK(src, PROC_REF(WorkCheck)), 9 MINUTES, TIMER_OVERRIDE & TIMER_UNIQUE & TIMER_STOPPABLE)
	if(safe)
		if(CheckWeather())
			SSweather.end_weather(season_stats[current_season][1])
		safe = FALSE
		return
	if(downgraded)
		datum_reference.qliphoth_change(-5)
		return
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/seasons/ZeroQliphoth(mob/living/carbon/human/user)
	. = ..()
	if(downgraded)
		addtimer(CALLBACK(src, PROC_REF(Upgrade)), 10 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(EndWeather)), 60 SECONDS)
	if(!CheckWeather())
		StartWeather()

/mob/living/simple_animal/hostile/abnormality/seasons/death(gibbed)
	EndWeather()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//delete the zombies n stuff on death
/mob/living/simple_animal/hostile/abnormality/seasons/Destroy()
	. = ..()
	for(var/mob/living/simple_animal/hostile/flora_zombie/Z in zombies)
		QDEL_IN(Z, rand(3) SECONDS)
		zombies -= Z
	for(var/mob/living/L in summons)
		QDEL_IN(L, rand(3) SECONDS)
		summons -= L
	for(var/obj/structure/S in structures)
		QDEL_IN(S, rand(3) SECONDS)
		structures -= S

/mob/living/simple_animal/hostile/abnormality/seasons/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(downgraded)
		Upgrade()
		ZeroQliphoth()
		return
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)

/mob/living/simple_animal/hostile/abnormality/seasons/bullet_act(obj/projectile/P)
	if(current_season == "summer")
		visible_message(span_userdanger("The [P] got incinerated by [src]'s flames!"))
		P.Destroy()

//Weather controlling
/mob/living/simple_animal/hostile/abnormality/seasons/proc/CheckWeather()
	for(var/W in SSweather.processing)
		var/datum/weather/V = W
		if(V.type in SSlobotomy_events.seasons_weather_list)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/StartWeather()
	SSweather.run_weather(season_stats[current_season][1])

/mob/living/simple_animal/hostile/abnormality/seasons/proc/EndWeather()
	SSweather.end_weather(season_stats[current_season][1])

//Combat
/mob/living/simple_animal/hostile/abnormality/seasons/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(!client)
		if((cone_attack_cooldown <= world.time) && prob(35))
			return ConeAttack(target)
		if(current_season != "summer")
			if(special_attack_cooldown <= world.time  && prob(35))
				return SpecialAttack(target)
		if((slam_cooldown <= world.time) && prob(35))
			return Slam()
	if(current_season == "summer")
		return SummerMelee(target)
	if(ishuman(target))
		if(Finisher(target))
			return
	return ..()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SummerMelee(target)
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	var/warningtype = breaching_stats[current_season][7]
	var/attacktype = breaching_stats[current_season][5]
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, EAST, fire_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, fire_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, fire_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, WEST, fire_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, fire_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, fire_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, SOUTH, fire_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, fire_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, fire_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, NORTH, fire_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, fire_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, fire_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	playsound(get_turf(src), 'sound/abnormalities/seasons/breath_attack.ogg', 40, 0, 5)
	for(var/turf/T in area_of_effect)
		new warningtype(T)
	SLEEP_CHECK_DEATH(1.4 SECONDS)
	playsound(get_turf(src), "[breaching_stats[current_season][2]]", 30, 0, 8)
	playsound(src, 'sound/abnormalities/apocalypse/slam.ogg', 100, FALSE, 12)
	visible_message(span_danger("[src] slams at the floor with its hands!"))
	for(var/mob/living/M in livinginrange(10, get_turf(src)))
		shake_camera(M, 1.4, 3)
	for(var/turf/T in area_of_effect)
		new attacktype(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if (L == src)
				continue
			L.apply_damage(fire_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, T)))
			L.throw_at(throw_target, 2, 3)
			L.adjust_fire_stacks(3)
			L.IgniteMob()
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				if(cone_attack_cooldown <= world.time)
					ConeAttack(target)
		return ..()

	if(cone_attack_cooldown <= world.time)
		ConeAttack(target)
		return
	if(current_season != "summer")
		if(special_attack_cooldown <= world.time)
			SpecialAttack(target)
			return
	if((slam_cooldown <= world.time))
		Slam()
		return
	..()

/mob/living/simple_animal/hostile/abnormality/seasons/Life()
	. = ..()
	if(downgraded)
		return
	if(src.IsContained())
		return
	if((pulse_cooldown <= world.time) && prob(35))
		return Pulse()
	if(current_season == "summer")
		for(var/turf/open/O in range(3, src))
			if(!isturf(O) || isspaceturf(O))
				continue
			if(locate(/obj/effect/season_turf/temporary) in O)
				continue
			new /obj/effect/season_turf/temporary(O)
		if(special_attack_cooldown <= world.time)
			SpecialAttack(target)

/mob/living/simple_animal/hostile/abnormality/seasons/Move()
	if(!can_act || !can_move)
		return FALSE
	for(var/turf/open/O in range(1, src))
		if(!isturf(O) || isspaceturf(O))
			continue
		if(locate(/obj/effect/season_turf/temporary) in O)
			continue
		new /obj/effect/season_turf/temporary(O)
	..()


/mob/living/simple_animal/hostile/abnormality/seasons/proc/ConeAttack(atom/at = target)
	cone_attack_cooldown = world.time + cone_attack_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/seasons/breath_attack.ogg', 40, FALSE, 5)
	SLEEP_CHECK_DEATH(1 SECONDS)
	var/list/turfs = list()
	switch (current_season)
		if("spring")
			turfs = LineTarget(-20, 15, at)
			FireLine(turfs)
			turfs = LineTarget(-10, 15, at)
			FireLine(turfs)
			turfs = LineTarget(0, 15, at)
			FireLine(turfs)
			turfs = LineTarget(10, 15, at)
			FireLine(turfs)
			turfs = LineTarget(20, 15, at)
		if("summer")
			turfs = LineTarget(90, 15, at)
			FireLine(turfs, TRUE)
			turfs = LineTarget(0, 15, at)
			FireLine(turfs, TRUE)
			turfs = LineTarget(180, 15, at)
			FireLine(turfs, TRUE)
			turfs = LineTarget(270, 15, at)
			FireLine(turfs, TRUE)
			SLEEP_CHECK_DEATH(0.75 SECONDS)
			turfs = LineTarget(135, 10, at)
			FireLine3x3(turfs, TRUE)
			turfs = LineTarget(45, 10, at)
			FireLine3x3(turfs, TRUE)
			turfs = LineTarget(225, 10, at)
			FireLine3x3(turfs, TRUE)
			turfs = LineTarget(315, 10, at)
			FireLine3x3(turfs, TRUE)
		if("fall")
			turfs = LineTarget(-40, 15, at)
			FireLine(turfs)
			turfs = LineTarget(-20, 15, at)
			FireLine(turfs)
			turfs = LineTarget(0, 15, at)
			FireLine(turfs)
			turfs = LineTarget(20, 15, at)
			FireLine(turfs)
			turfs = LineTarget(40, 15, at)
			FireLine(turfs)
		if("winter")
			turfs = LineTarget(0, 20, at)
			FireLine3x3(turfs)
	SLEEP_CHECK_DEATH(1 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/LineTarget(offset, range, atom/at = target)
	set waitfor = FALSE
	if(!at)
		return
	var/turf/T = get_ranged_target_turf_direct(src, at, range, offset)
	return (getline(src, T) - get_turf(src))

/mob/living/simple_animal/hostile/abnormality/seasons/proc/FireLine(list/turfs, warn = FALSE)
	set waitfor = FALSE
	var/warningtype = breaching_stats[current_season][7]
	var/attacktype = breaching_stats[current_season][5]
	var/list/hit_list = list()
	if (warn)
		for(var/turf/T in turfs)
			if(istype(T, /turf/closed))
				break
			for(var/turf/T2 in view(1,T))
				new warningtype(T)
		SLEEP_CHECK_DEATH(1 SECONDS)
	for(var/turf/T in turfs)
		if(istype(T, /turf/closed))
			break
		new attacktype(T)
		for(var/mob/living/L in T.contents)
			if(L in hit_list || istype(L, type))
				continue
			hit_list += L
			L.deal_damage(cone_attack_damage, melee_damage_type)
			to_chat(L, span_userdanger("You have been hit by [src]'s breath attack!"))
			if(ishuman(L))
				Finisher(L)
		SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/FireLine3x3(list/turfs, warn = FALSE)
	set waitfor = FALSE
	var/warningtype = breaching_stats[current_season][7]
	var/attacktype = breaching_stats[current_season][5]
	var/list/hit_list = list()
	if (warn)
		for(var/turf/T in turfs)
			if(istype(T, /turf/closed))
				break
			for(var/turf/T2 in view(1,T))
				new warningtype(T)
		SLEEP_CHECK_DEATH(1 SECONDS)
	for(var/turf/T in turfs)
		if(istype(T, /turf/closed))
			break
		for(var/turf/T2 in view(1,T))
			new attacktype(T2)
			for(var/mob/living/L in T2.contents)
				if(L in hit_list || istype(L, type))
					continue
				hit_list += L
				L.apply_damage(cone_attack_damage, melee_damage_type, null, L.run_armor_check(null, melee_damage_type), spread_damage = TRUE)
				to_chat(L, span_userdanger("You have been hit by [src]'s breath attack!"))
				if(ishuman(L))
					Finisher(L)
		if(current_season == "winter")
			for(var/turf/T3 in view(2,T))
				if(!locate(/obj/effect/temp_visual/winter_god) in T3)
					new/obj/effect/temp_visual/winter_god(T3,faction)
		SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Slam()//AOE attack
	slam_cooldown = world.time + slam_cooldown_time
	var/attacktype = breaching_stats[current_season][4]
	var/warningtype = breaching_stats[current_season][7]
	can_act = FALSE
	for(var/turf/L in view(7, src))
		if((get_dist(src, L) % 2 != 1))
			continue
		new warningtype(L)
	playsound(get_turf(src), 'sound/abnormalities/seasons/aoe_warning.ogg', 75, FALSE, 12)
	SLEEP_CHECK_DEATH(10)
	playsound(get_turf(src), 'sound/abnormalities/seasons/aoe_attack.ogg', 80, FALSE, 12)
	for(var/turf/T in view(7, src))
		if((get_dist(src, T) % 2 != 1))
			continue
		new attacktype(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.deal_damage(slam_damage, melee_damage_type)
			if(ishuman(L))
				Finisher(L)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Pulse()//Periodic weak AOE attack
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/seasons/pulse.ogg', 30, FALSE, 3)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(pulse_range, orgin)
	for(var/i = 0 to pulse_range)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) != i)
				continue
			if(T.density)
				continue
			addtimer(CALLBACK(src, PROC_REF(PulseWarn), T), (3 * (i+1)) + 0.1 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(PulseHit), T), (3 * (i+1)) + 0.5 SECONDS)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/PulseWarn(turf/T)
	var/attacktype = breaching_stats[current_season][6]
	new attacktype(T)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/PulseHit(turf/T)
	if(!locate(/obj/effect/season_turf/temporary) in T)
		new /obj/effect/season_turf/temporary(T)
	for(var/mob/living/L in T)
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, melee_damage_type)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Finisher(mob/living/carbon/human/H) //return TRUE to prevent attacking, as attacking causes runtimes if the target is gibbed.
	if(current_season == "spring" && (H.sanity_lost || H.stat >= HARD_CRIT || H.health < 0))
		playsound(src, 'sound/abnormalities/seasons/spring_change.ogg', 45, FALSE, 5)
		if(!QDELETED(H))
			if(!H.real_name)
				return FALSE
			var/mob/living/simple_animal/hostile/flora_zombie/C = new(get_turf(src))
			zombies += C
			C.master = src
			C.name = "[H.real_name]"//applies the target's name and adds the name to its description
			C.icon_state = "flora_zombie"
			C.icon_living = "flora_zombie"
			C.desc = "What appears to be [H.real_name], only mangled by vines and decayed..."
			C.gender = H.gender
			C.faction = src.faction
		H.gib()
		return TRUE
	if(H.stat >= HARD_CRIT || H.health < 0)
		switch(current_season)
			if("summer")
				H.adjustBruteLoss(H.maxHealth)
				H.Drain()
				H.adjust_fire_stacks(30)
				H.IgniteMob()
			if("fall")
				H.adjustBruteLoss(H.maxHealth)
				H.Drain()
			if("winter") //turn them into an ice cube
				if(HAS_TRAIT(H, TRAIT_HUSK))
					return FALSE
				var/cube = icon('icons/effects/freeze.dmi', "ice_cube")
				H.add_overlay(cube)
				H.adjustBruteLoss(H.maxHealth)
				H.Drain()
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SpecialAttack()//AOE attack
	special_attack_cooldown = world.time + special_attack_cooldown_time
	can_act = FALSE
	switch (current_season)
		if("spring")
			Spring_Special()
		if("summer")
			Summer_Special()
		if("fall")
			Fall_Special()
		if("winter")
			Winter_Special()
	SLEEP_CHECK_DEATH(10)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Spring_Special()
	playsound(get_turf(src), "[breaching_stats[current_season][2]]", 30, 0, 8)
	var/list/turfs = list()
	for(var/mob/living/L in summons)
		qdel(L)
		summons -= L
	for(var/obj/structure/S in structures)
		if(S.broken)
			qdel(S)
			structures -= S
	for(var/turf/open/T in view(6, src))
		turfs += T
	for(var/i = 1 to bomb_amount)
		var/turf/T2 = pick(turfs)
		turfs -= T2
		var/obj/structure/thorn_bomb/B = new(T2)
		structures += B
	for(var/i = 1 to trap_amount)
		var/turf/T2 = pick(turfs)
		turfs -= T2
		var/mob/living/simple_animal/hostile/flytrap/F = new(T2)
		summons += F

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Summer_Special()
	playsound(get_turf(src), "[breaching_stats[current_season][2]]", 30, 0, 8)
	var/list/turfs = list()
	for(var/turf/open/T in view(6, src))
		if(!locate(/obj/structure/fire_wall) in T)
			turfs += T
	for(var/i = 1 to fire_wall_amount)
		var/turf/T2 = pick(turfs)
		turfs -= T2
		new/obj/structure/fire_wall(T2)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Fall_Special()
	playsound(get_turf(src), "[breaching_stats[current_season][2]]", 30, 0, 8)
	var/list/turfs = list()
	for(var/turf/open/T in view(6, src))
		turfs += T
	for(var/i = 1 to wisp_amount)
		var/turf/T2 = pick(turfs)
		turfs -= T2
		new/mob/living/simple_animal/hostile/willo_wisp(T2)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Winter_Special()
	playsound(get_turf(src), "[breaching_stats[current_season][2]]", 30, 0, 8)
	var/list/target_list = list()
	for(var/mob/living/L in livinginrange(10, src))
		if(L.z != z || (L.status_flags & GODMODE))
			continue
		if(faction_check_mob(L, FALSE))
			continue
		target_list += L
	for(var/i = 1 to 10)
		if(LAZYLEN(target_list))
			target = pick(target_list)
		if(!target)
			return
		var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
		if(T.density)
			i -= 1
			continue
		var/obj/projectile/winter_spear/P
		P = new(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = target.y - T.y
		P.xo = target.x - T.x
		P.original = target
		P.preparePixelProjectile(target, T)
		addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), 30)
		var/list/hit_line = getline(T, get_turf(target)) //targetting line
		for(var/turf/TF in hit_line)
			if(TF.density)
				break
			new /obj/effect/temp_visual/cult/sparks(TF)
	SLEEP_CHECK_DEATH(30)
	playsound(get_turf(src), 'sound/abnormalities/seasons/winter_attack.ogg', 50, 0, 4)

//Weather and such
/datum/weather/thunderstorm //Spring weather, might want to add thunder strikes or make it a bit more dangerous overall.
	name = "thunderstorm"
	immunity_type = "rain"
	desc = "Extreme thunderstorms "
	telegraph_message = span_warning("It has begun to rain.")
	telegraph_duration = 300
	telegraph_overlay = "light_rain"
	weather_message = span_userdanger("<i>The rain starts coming down hard!</i>")
	weather_overlay = "rain_storm"
	weather_duration_lower = 1500
	weather_duration_upper = 3000
	perpetual = TRUE //should make it last forever
	end_duration = 100
	end_message = span_boldannounce("The rain starts to let up.")
	end_overlay = "light_rain"
	area_type = /area
	target_trait = ZTRAIT_STATION

/datum/weather/thunderstorm/weather_act(mob/living/carbon/human/L)
	if(!ishuman(L))
		return
	if(prob(1))
		var/turf/open/OT = get_turf(L)
		if(isopenturf(OT))
			OT.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)
	if(prob(1))
		new /obj/effect/thunderbolt/seasons(get_turf(L)) //Thunder!

/datum/weather/heatwave //Summer weather, sets you on fire rarely.
	name = "heatwaves"
	immunity_type = "heatwave"
	desc = "Extreme heatwaves caused by an abnormality."
	telegraph_message = span_warning("The temperature suddenly skyrockets!")
	telegraph_duration = 300
	telegraph_overlay = "light_ash"
	weather_message = span_userdanger("<i>It's too hot!</i>")
	weather_overlay = "heavy_ash"
	weather_duration_lower = 1500
	weather_duration_upper = 3000
	perpetual = TRUE //should make it last forever
	end_duration = 100
	end_message = span_boldannounce("The temperature starts to return to normal.")
	end_overlay = "light_ash"
	area_type = /area
	target_trait = ZTRAIT_STATION

/datum/weather/heatwave/weather_act(mob/living/carbon/human/L)
	if(!ishuman(L))
		return
	if(prob(3))
		L.adjust_fire_stacks(rand(0.1, 1))
		L.IgniteMob()
		to_chat(L, span_warning("You are burning alive!"))
	if(prob(1))
		SpawnFire(L)

/datum/weather/heatwave/proc/SpawnFire(mob/living/carbon/human/L) //Randomly spawn burning tiles near players
	set waitfor = FALSE
	for(var/turf/open/T in view(3, L))
		if(prob(10))
			if(prob(66))
				sleep(rand(1,5))
			new /obj/structure/turf_fire(T)

/datum/weather/fog //Fall weather, causes nearsightedness.
	name = "fog"
	immunity_type = "fog"
	desc = "An extreme surplus of humidity caused by an abnormality."
	telegraph_message = span_warning("The air is becoming damp.")
	telegraph_duration = 300
	telegraph_overlay = "light_fog"
	weather_message = span_userdanger("<i>You can't see anything with all this fog in the way!</i>")
	weather_overlay = "heavy_fog"
	weather_duration_lower = 1500
	weather_duration_upper = 3000
	perpetual = TRUE //should make it last forever
	end_duration = 100
	end_message = span_boldannounce("The fog seems to be going away.")
	end_overlay = "light_pollen"
	area_type = /area
	target_trait = ZTRAIT_STATION

/datum/weather/fog/weather_act(mob/living/carbon/human/L)
	if(!ishuman(L))
		return
	if(prob(1))
		for(var/turf/open/T in view(3, L))
			if(prob(25))
				var/datum/effect_system/smoke_spread/S = new
				S.set_up(3, T)
				S.start()
				return
	if(L.has_status_effect(STATUS_EFFECT_FOGBOUND))
		return
	L.apply_status_effect(STATUS_EFFECT_FOGBOUND)

/datum/weather/fog/end()
	..()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.remove_status_effect(STATUS_EFFECT_FOGBOUND)

/datum/weather/freezing_wind //Winter weather, causes slowdown.
	name = "freezing wind"
	immunity_type = "freezing"
	desc = "An extreme snowstorm caused by an abnormality."
	telegraph_message = span_warning("The temperature suddenly drops!")
	telegraph_duration = 300
	telegraph_overlay = "snowfall_calm"
	weather_message = span_userdanger("<i>It's so cold!</i>")
	weather_overlay = "snowfall_blizzard"
	weather_duration_lower = 1500
	weather_duration_upper = 3000
	perpetual = TRUE //should make it last forever
	end_duration = 100
	end_message = span_boldannounce("The snow starts to let up.")
	end_overlay = "snowfall_calm"
	area_type = /area
	target_trait = ZTRAIT_STATION

/datum/weather/freezing_wind/weather_act(mob/living/carbon/human/L)
	if(!ishuman(L))
		return
	if(L.has_status_effect(STATUS_EFFECT_FREEZING))
		return
	var/randomslowdown = rand(0.5,1)
	L.apply_status_effect(STATUS_EFFECT_FREEZING)
	L.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/freezing, multiplicative_slowdown = randomslowdown)
	to_chat(L, span_warning("The freezing wind chills your bones!"))

/datum/weather/freezing_wind/end()
	..()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		L.remove_status_effect(STATUS_EFFECT_FREEZING)
		L.remove_movespeed_modifier(/datum/movespeed_modifier/freezing)

//Status effects.
/datum/status_effect/freezing
	id = "freezing"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/freezing

/atom/movable/screen/alert/status_effect/freezing
	name = "Freezing"
	desc = "It's so cold!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "freezing"

/datum/status_effect/fogbound
	id = "fogbound"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/fogbound

/datum/status_effect/fogbound/on_apply()
	owner.become_nearsighted(TRAUMA_TRAIT)
	return ..()

/datum/status_effect/fogbound/on_remove()
	owner.cure_nearsighted(TRAUMA_TRAIT)
	return ..()

/atom/movable/screen/alert/status_effect/fogbound
	name = "Fogbound"
	desc = "You can hardly see anything!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "foggy"

#undef STATUS_EFFECT_FREEZING
#undef STATUS_EFFECT_FOGBOUND

/datum/movespeed_modifier/freezing
	multiplicative_slowdown = 0
	variable = TRUE

//Misc. Objects
/obj/effect/season_turf //Modular turf that spawnes under the abnormality with Upgrade(). This version never despawns.
	name = "grass"
	desc = "A thick layer of foilage that never seems to die down."
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	layer = TURF_LAYER
	anchored = TRUE
	var/list/season_list = list(
		"spring" = list("razorgrass", "A thick layer of razor sharp foilage that never seems to die down."),
		"summer" = list("volcanic rock","Some incredibly hot igneus rock."),
		"fall" = list("swampy grass","A thick marsh, deep enough that you need to wear boots."),
		"winter" = list("snow","A patch of snow."),
	)
	var/current_season

/obj/effect/season_turf/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_SEASON_CHANGE, PROC_REF(Transform))
	Transform()

/obj/effect/season_turf/proc/Transform()
	current_season = SSlobotomy_events.current_season
	icon = 'icons/turf/floors.dmi'
	name = season_list[current_season][1]
	desc = season_list[current_season][2]
	switch(current_season)
		if("spring")
			icon_state = "grass[rand(0,3)]"
		if("summer")
			if(prob(15))
				icon_state = "lava"
				return
			icon_state = "basalt[rand(0,3)]"
		if("fall")
			if(prob(50))
				icon_state = "junglegrass"
				return
			icon_state = "wasteland[rand(8,11)]"
		if("winter")
			icon = 'icons/turf/snow.dmi'
			if(prob(15))
				icon_state = "ice"
				name = "ice"
				desc = "A patch of slippery ice."
				return
			icon_state = "snow[rand(0,6)]"

/obj/effect/season_turf/Crossed(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	BumpEffect(H)

/obj/effect/season_turf/proc/BumpEffect(mob/living/carbon/human/H)
	switch(current_season)
		if("spring")
			if(prob(10))
				to_chat(H, span_warning("Your legs are cut by brambles in the grass!"))
				H.apply_damage(5, BLACK_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = FALSE)
				H.adjustStaminaLoss(10, TRUE, TRUE)
		if("summer")
			if(icon_state == "lava")
				to_chat(H, span_warning("You stumbled into a pool of lava!"))
				H.adjust_fire_stacks(rand(0.1, 1))
				H.IgniteMob()
		if("fall")
			H.apply_damage(2, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = FALSE)
			if(prob(10))
				to_chat(H, span_warning("You sink into the marsh!"))
				animate(H, alpha = 255,pixel_x = 0, pixel_z = -3, time = 0.5 SECONDS)
				H.pixel_z = -3
				H.Immobilize(0.5 SECONDS)
				animate(H, alpha = 255,pixel_x = 0, pixel_z = 3, time = 0.5 SECONDS)
				H.pixel_z = 0
		if("winter")
			if(icon_state == "ice")
				if(prob(25))
					to_chat(H, span_warning("You slip on the ice!"))
					H.slip(0, null, SLIDE_ICE, 0, FALSE) //might need to replace this as stuns are pretty annoying...
					H.Immobilize(0.5 SECONDS)

/obj/effect/season_turf/temporary //Season_turf but despawns, spawned by most of the abnormality's attacks.

/obj/effect/season_turf/temporary/Initialize()
	. = ..()
	animate(src, alpha = 150, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)

//Effects
/obj/effect/season_warn //warning for attacks
	icon = 'icons/effects/weather_effects.dmi'
	name = "weather warning"
	desc = "Looks like the terrain is being shifted by an abnormality."
	layer = LYING_MOB_LAYER
	alpha = 100
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/season_warn/Initialize()
	. = ..()
	QDEL_IN(src, 10)

/obj/effect/season_warn/summer
	icon_state = "ash_storm"

/obj/effect/season_warn/fall
	icon = 'icons/turf/floors.dmi'
	icon_state = "oldsmoothdarkdirt"

/obj/effect/season_warn/winter
	icon_state = "snow_storm"
	alpha = 255

/obj/effect/season_warn/winterspikes
	icon = 'icons/effects/effects.dmi'
	icon_state = "winter_warn"

/obj/effect/season_warn/spring
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Hvy1"

/obj/effect/season_warn/vines/Initialize()
	. = ..()
	icon_state = pick("Hvy1", "Hvy2", "Hvy3")

/obj/effect/season_effect //effect subtype that handles spawning season_turfs
	name = "weather warning"
	desc = "Watch out!"
	layer = POINT_LAYER

/obj/effect/season_effect/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(pop)), 0.5 SECONDS)

/obj/effect/season_effect/proc/pop()
	if(!locate(/obj/effect/season_turf/temporary) in get_turf(src))
		new /obj/effect/season_turf/temporary(get_turf(src))
	if(prob(5))
		var/list/spawn_area = range(1, get_turf(src))
		for(var/turf/open/O in spawn_area)
			if(!isturf(O) || isspaceturf(O))
				continue
			var/obj/effect/season_turf/temporary/G = (locate(/obj/effect/season_turf/temporary) in O)
			if(G)
				qdel(G)
			new /obj/effect/season_turf/temporary(O)
	QDEL_IN(src, 0.5 SECONDS)

/obj/effect/season_effect/summer
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_range = LIGHT_RANGE_FIRE
	light_power = 1
	light_color = LIGHT_COLOR_FIRE

/obj/effect/season_effect/fall
	icon = 'icons/effects/effects.dmi'
	icon_state = "universe_aflame"
	alpha = 230

/obj/effect/season_effect/winter
	icon = 'icons/effects/effects.dmi'
	icon_state = "winter_attack"

/obj/effect/season_effect/spring
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "vinespike"

/obj/effect/season_effect/breath //subtype of season_effect that spawns turf way less often, for "breath" attacks that cover a lot of ground. also looks different.
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/season_effect/breath/pop()
	if(prob(75))
		new /obj/effect/season_turf/temporary(get_turf(src))
	QDEL_IN(src, 0.5 SECONDS)

/obj/effect/season_effect/breath/summer
	icon = 'icons/effects/fire.dmi'
	icon_state = "1" //yeah its weird

/obj/effect/season_effect/breath/summer/Initialize()
	. = ..()
	icon_state = pick("1", "2", "3")

/obj/effect/season_effect/breath/fall
	icon = 'icons/effects/effects.dmi'
	icon_state = "universe_aflame"
	alpha = 100

/obj/effect/season_effect/breath/winter
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "light_fog"

/obj/effect/season_effect/breath/winter/Initialize()
	. = ..()
	color = pick("#a2d2df", "#20c3d0")

/obj/effect/season_effect/breath/spring
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Light1"

/obj/effect/season_effect/breath/spring/Initialize()
	. = ..()
	icon_state = pick("Light1", "Light1", "Light3")

/obj/effect/thunderbolt/seasons

/obj/effect/thunderbolt/seasons/Convert(mob/living/carbon/human/H) //haha, it doesn't actually convert.
	return

/obj/structure/fire_wall
	gender = PLURAL
	name = "Mini Vulcano"
	desc = "It's spewing fire!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "summer_attack"
	anchored = TRUE
	density = TRUE
	max_integrity = 10000
	resistance_flags = INDESTRUCTIBLE
	light_range = 6
	light_power = 3
	light_color = LIGHT_COLOR_FIRE

/obj/structure/fire_wall/Initialize()
	. = ..()
	QDEL_IN(src, (20 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(Fire_Spew)), 5 SECONDS)

/obj/structure/fire_wall/proc/Fire_Spew()
	set waitfor = FALSE
	for(var/turf/open/T in view(1, src))
		new /obj/effect/season_effect/summer(T)
		for(var/mob/living/M in T.contents)
			M.adjust_fire_stacks(3)
			M.IgniteMob()
			M.apply_damage(20, RED_DAMAGE, null, M.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	addtimer(CALLBACK(src, PROC_REF(Fire_Spew)), 5 SECONDS)

/obj/projectile/winter_spear
	name = "icicle spear"
	desc = "A fridged icicle formed in a shape of a spear."
	icon_state = "winter_spear"
	damage_type = PALE_DAMAGE
	damage = 40
	alpha = 0
	spread = 20

/obj/projectile/winter_spear/Initialize()
	. = ..()
	hitsound = "sound/weapons/ego/rapier[pick(1,2)].ogg"
	animate(src, alpha = 255, time = 3)

/obj/projectile/winter_spear/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	if(!ishuman(target))
		return ..()
	var/mob/living/carbon/human/H = target
	. = ..()
	if(.) // Hit passed and damage applied
		if(H.stat >= HARD_CRIT || H.health < 0)
			if(HAS_TRAIT(H, TRAIT_HUSK))
				return FALSE
			var/cube = icon('icons/effects/freeze.dmi', "ice_cube")
			H.add_overlay(cube)
			H.adjustBruteLoss(H.maxHealth)
			H.Drain()

/obj/effect/temp_visual/winter_god
	name = "pale mist"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke2"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	color = COLOR_CYAN
	duration = 8 SECONDS
	var/list/faction = list("hostile")

/obj/effect/temp_visual/winter_god/New(loc, ...)
	. = ..()
	if(args[2])
		faction = args[2]

/obj/effect/temp_visual/winter_god/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(Ice_Damage)), 1 SECONDS)

/obj/effect/temp_visual/winter_god/proc/Ice_Damage()
	addtimer(CALLBACK(src, PROC_REF(Ice_Damage)), 1 SECONDS)
	for(var/mob/living/L in get_turf(src))
		if(faction_check(faction, L.faction, FALSE))
			continue
		L.apply_damage(8, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.become_nearsighted(TRAUMA_TRAIT)
			addtimer(CALLBACK(src, PROC_REF(Revert),H), 3 SECONDS)
			if(H.stat >= HARD_CRIT || H.health < 0)
				if(HAS_TRAIT(H, TRAIT_HUSK))
					return FALSE
				var/cube = icon('icons/effects/freeze.dmi', "ice_cube")
				H.add_overlay(cube)
				H.adjustBruteLoss(H.maxHealth)
				H.Drain()

/obj/effect/temp_visual/winter_god/proc/Revert(mob/living/carbon/human/H)
	H.cure_nearsighted(TRAUMA_TRAIT)

/mob/living/simple_animal/hostile/willo_wisp
	name = "Willo-O-Wisp"
	desc = "A blue fire."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "willo_wisp"
	icon_living = "willo_wisp"
	icon_dead = "willo_wisp"
	faction = list("hostile")
	light_color = COLOR_TEAL
	light_range = 3
	light_power = 2
	is_flying_animal = TRUE
	density = FALSE
	speak_emote = list("wispers")
	attack_verb_continuous = "explodes"
	attack_verb_simple = "explodes"
	attack_sound = 'sound/abnormalities/seasons/aoe_attack.ogg'
	del_on_death = TRUE
	health = 10
	maxHealth = 10
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 20
	move_to_delay = 1.3 //very fast, very weak.
	stat_attack = HARD_CRIT
	ranged = 1
	retreat_distance = 3
	minimum_distance = 1

/mob/living/simple_animal/hostile/willo_wisp/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(Boom)), 30 SECONDS)

/mob/living/simple_animal/hostile/willo_wisp/AttackingTarget() //they explode
	for(var/turf/T in view(2, src))
		new/obj/effect/season_effect/breath/fall(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(50, melee_damage_type, null, L.run_armor_check(null, melee_damage_type), spread_damage = TRUE)
	qdel(src)
	return ..()

/mob/living/simple_animal/hostile/willo_wisp/death(gibbed)
	Boom()
	..()

/mob/living/simple_animal/hostile/willo_wisp/proc/Boom(gibbed)
	for(var/turf/T in view(1, src))
		new/obj/effect/season_effect/breath/fall(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(30, melee_damage_type, null, L.run_armor_check(null, melee_damage_type), spread_damage = TRUE)
	qdel(src)

//spring mobs

/mob/living/simple_animal/hostile/flora_zombie
	name = "Flora Zombie"
	desc = "What appears to be human, only mangled by vines and decayed..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "flora_zombie"
	icon_living = "flora_zombie"
	icon_dead = "flora_zombie_dead"
	speak_emote = list("groans", "moans", "howls", "screeches", "grunts")
	gender = NEUTER
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/effects/hit_kick.ogg'
	projectilesound = 'sound/machines/clockcult/steam_whoosh.ogg'
	death_sound = 'sound/creatures/venus_trap_death.ogg'
	health = 500
	maxHealth = 500
	obj_damage = 120
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.2)//no mind to break
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 60
	melee_damage_upper = 80
	rapid_melee = 1
	speed = 5
	move_to_delay = 4
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = FALSE
	density = TRUE
	guaranteed_butcher_results = list(/obj/item/food/badrecipe = 1)
	var/list/breach_affected = list()
	var/can_act = TRUE
	var/mob/living/simple_animal/hostile/abnormality/seasons/master

/mob/living/simple_animal/hostile/flora_zombie/OpenFire()
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(get_turf(src), projectilesound, 10, 1)
	var/smoke_test = locate(/obj/effect/particle_effect/smoke) in view(1, src)
	if(!smoke_test)
		var/datum/effect_system/smoke_spread/spring/S = new(get_turf(src))
		S.set_up(5, get_turf(src))
		S.start()
		return TRUE
	ranged_cooldown += 1 SECONDS

//Zombie conversion from zombie kills
/mob/living/simple_animal/hostile/flora_zombie/AttackingTarget()
	. = ..()
	if(!can_act)
		return
	if(!ishuman(target))
		return
	OpenFire()
	var/mob/living/carbon/human/H = target
	H.apply_venom(3)
	if(H.stat >= SOFT_CRIT || H.health < 0 || H.sanity_lost)
		Convert(H)

/mob/living/simple_animal/hostile/flora_zombie/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/attack.ogg', 50, 1, 4)
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/flora_zombie/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE

//reanimated if god isn't suppressed within 30 seconds
/mob/living/simple_animal/hostile/flora_zombie/death(gibbed)
	addtimer(CALLBACK(src, PROC_REF(resurrect)), 30 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/flora_zombie/proc/resurrect()
	if(QDELETED(src))
		return
	revive(full_heal = TRUE, admin_revive = FALSE)
	visible_message(span_boldwarning("[src] staggers back on their feet!"))
	playsound(get_turf(src), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, 0, 8)

//Zombie conversion from other zombies
/mob/living/simple_animal/hostile/flora_zombie/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!can_act)
		return
	can_act = FALSE
	forceMove(get_turf(H))
	playsound(src, 'sound/abnormalities/seasons/spring_change.ogg', 45, FALSE, 5)
	SLEEP_CHECK_DEATH(3)
	if(!QDELETED(H))
		if(!H.real_name)
			return FALSE
		var/mob/living/simple_animal/hostile/flora_zombie/C = new(get_turf(src))
		if(master)
			master.zombies += C
			C.master = master
		C.name = "[H.real_name]"//applies the target's name and adds the name to its description
		C.icon_state = "flora_zombie"
		C.icon_living = "flora_zombie"
		C.desc = "What appears to be [H.real_name], only mangled by vines and decayed..."
		C.gender = H.gender
		C.faction = src.faction
		H.gib()
	can_act = TRUE

/obj/effect/particle_effect/smoke/spring
	name = "thick noxious fumes"
	color = "#AAFF00"
	lifetime = 5
	opaque = TRUE

/obj/effect/particle_effect/smoke/spring/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return FALSE
	if(lifetime<1)
		return FALSE
	if(C.internal != null || C.has_smoke_protection())
		return FALSE
	if(C.smoke_delay)
		return FALSE
	if(!ishuman(C))
		return FALSE
	C.smoke_delay++
	addtimer(CALLBACK(src, PROC_REF(remove_smoke_delay), C), 10)
	return smoke_mob_effect(C)


/obj/effect/particle_effect/smoke/spring/proc/smoke_mob_effect(mob/living/carbon/human/M)
	if(!M.sanity_lost)
		M.deal_damage(30, WHITE_DAMAGE)
	else
		M.adjustStaminaLoss(15, TRUE, TRUE)
	if(prob(15))
		M.emote("cough")
	return TRUE

/datum/effect_system/smoke_spread/spring
	effect_type = /obj/effect/particle_effect/smoke/spring

/mob/living/simple_animal/hostile/flytrap
	name = "Flytrap"
	desc = "A massive fly trap..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "flytrap"
	icon_living = "flytrap"
	del_on_death = TRUE
	health = 500
	maxHealth = 500
	obj_damage = 120
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 60
	melee_damage_upper = 80
	faction = list("hostile")
	speak_emote = list("screeches")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.2)//no mind to break
	speed = 5
	attack_sound = 'sound/abnormalities/nosferatu/bat_attack.ogg'
	density = FALSE
	var/attack_time
	var/attack_time_cooldown = 5 SECONDS

/mob/living/simple_animal/hostile/flytrap/Move()
	return FALSE

/mob/living/simple_animal/hostile/flytrap/AttackingTarget(atom/attacked_target)
	if(attack_time > world.time)
		return FALSE
	. = ..()
	attack_time = world.time + attack_time_cooldown
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.Immobilize(3 SECONDS)

/obj/structure/thorn_bomb
	name = "Thorn Plant"
	desc = "A mound of soil growing something..."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "soil"
	density = FALSE
	anchored = TRUE
	max_integrity = 300
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 100, BLACK_DAMAGE = -50, PALE_DAMAGE = 50)
	var/stage = 0
	var/grow_interval = 5 SECONDS

/obj/structure/thorn_bomb/Initialize()
	. = ..()
	QDEL_IN(src, 45 SECONDS)
	Grow()
	proximity_monitor = new(src, 1)

/obj/structure/thorn_bomb/proc/Grow()
	stage = stage + 1 > 5 ? 5 : stage + 1
	UpdateStage()
	if(stage >= 5)
		return
	addtimer(CALLBACK(src, PROC_REF(Grow)), grow_interval)

/obj/structure/thorn_bomb/proc/UpdateStage()
	cut_overlays()
	if(stage == 0)
		return
	var/mutable_appearance/plant_overlay = mutable_appearance('icons/obj/hydroponics/growing.dmi', "deathnettle-grow[stage]", layer = OBJ_LAYER + 0.01)
	add_overlay(plant_overlay)

/obj/structure/thorn_bomb/HasProximity(atom/movable/AM)
	if(stage <= 4)
		return
	if(!isliving(AM))
		return
	if(isbot(AM))
		return
	var/mob/living/L = AM
	if(("hostile" in L.faction))
		return
	Explode()

/obj/structure/thorn_bomb/bullet_act(obj/projectile/P)
	. = ..()
	if(stage <= 3)
		return
	Explode()

/obj/structure/thorn_bomb/proc/Explode()
	var/list/all_the_turfs_were_gonna_lacerate = RANGE_TURFS(stage, src) - RANGE_TURFS(stage-1, src)
	stage = 0
	UpdateStage()
	for(var/turf/shootat_turf in all_the_turfs_were_gonna_lacerate)
		INVOKE_ASYNC(src, PROC_REF(FireProjectile), shootat_turf)
	addtimer(CALLBACK(src, PROC_REF(Grow)), grow_interval)

/obj/structure/thorn_bomb/proc/FireProjectile(atom/target)
	var/obj/projectile/P = new /obj/projectile/needle_spring(get_turf(src))

	P.spread = 0
	if(prob(25))
		P.original = target // Allows roughly 25% of them to hit the activator who's prone
	P.fired_from = src
	P.firer = src
	P.impacted = list(src = TRUE)
	P.suppressed = SUPPRESSED_QUIET
	P.preparePixelProjectile(target, src)
	P.fire()

/obj/projectile/needle_spring
	name = "needle"
	desc = "a thorn from a plant"
	icon_state = "needle"
	ricochet_chance = 60
	ricochets_max = 2
	damage = 5
	damage_type = BLACK_DAMAGE
	eyeblur = 2
	ricochet_ignore_flag = TRUE

/obj/projectile/needle_spring/can_hit_target(atom/target, direct_target, ignore_loc, cross_failed)
	if(!fired)
		return FALSE
	return ..()

/obj/projectile/needle_spring/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.adjustStaminaLoss(10, TRUE, TRUE)

#undef SEASONS_SLAM_COOLDOWN
