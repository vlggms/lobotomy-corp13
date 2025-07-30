#define STATUS_EFFECT_FREEZING /datum/status_effect/freezing
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
	health = 2000
	maxHealth = 2000
	obj_damage = 600
	damage_coeff = list(RED_DAMAGE = 1.1, WHITE_DAMAGE = -1, BLACK_DAMAGE = 1.1, PALE_DAMAGE = 1.1)
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 20
	speed = 3
	move_to_delay = 4
	is_flying_animal = FALSE
	start_qliphoth = 1
	can_breach = TRUE
	melee_reach = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(5, 10, 15, 50, 55),
		ABNORMALITY_WORK_INSIGHT = list(5, 10, 15, 50, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(5, 10, 15, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(5, 10, 15, 50, 55),
	)
	work_damage_upper = 9
	work_damage_lower = 7
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	max_boxes = 33

	ego_list = list(
		/datum/ego_datum/weapon/seasons,
		/datum/ego_datum/armor/seasons,
	)

	gift_type =  /datum/ego_gifts //Its set later on
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

//Should be unique for each season, for now let's use Spring
	observation_prompt = "I'm standing outside a forest I both have never seen before, yet know well. <br>There is no City, no civilization on the horizon, I am utterly alone. <br>\
		Dauntlessly, I press into the forest, seeing no other path forward, and encounter a cute-looking, pink forest spirit. <br>\
		The spirits of the forest are playful, but it's best not to offend them by forgetting to make an offering"
	observation_choices = list(
		"Make an offering" = list(TRUE, "I ask the spirit to lead me to an altar to make my offering and it leads me off a beaten path... <br>\
			It felt as though I had walked for miles and days, my clothes torn and skin pricked by brambles and thorns but finally we arrived. <br>\
			Before me is a skull-headed pagan God hanging ominously over its altar, fear grips my heart as the pink spirit leads me to lay down on the altar..."),
		"Continue on" = list(FALSE, "I pass by the spirit and hear it giggle ominously... <br>\
			... <br>\
			In the end, I am never able to find a way out of the forest."),
	)

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
		"spring" = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.3),
		"summer" = list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1), //Summer is tanky
		"fall" = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 1.3),
		"winter" = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.2)
		)

	// Work Vars
	var/current_season = "winter"
	var/downgraded
	var/safe
	var/work_timer
	// Breach Vars
	var/can_act = TRUE
	var/slam_damage = 60
	var/slam_cooldown
	var/slam_cooldown_time = 20 SECONDS
	var/special_attack_damage = 30
	var/special_attack_cooldown
	var/special_attack_cooldown_time = 10 SECONDS
	var/special_hit_list = list()
	var/pulse_cooldown
	var/pulse_cooldown_time = 4 SECONDS
	var/pulse_damage = 5
	var/special_melee_attack = null
	var/special_slam_attack = null
	var/unique_special_attack = null
	var/attack_orientation = 1 // Used to flip certain attacks in a consistant pattern
	var/list/zombies = list()
	var/list/plants = list()
	// Turf Tracker
	var/list/spawned_turfs = list()

	// PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/cooldown/seasons_slam,
		/datum/action/innate/abnormality_attack/toggle/seasons_special_toggle,
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
	seasons.TrySlam()
	return TRUE

/datum/action/innate/abnormality_attack/toggle/seasons_special_toggle
	name = "Toggle Special"
	button_icon_state = "generic_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't use your special attack anymore.")
	button_icon_toggle_activated = "generic_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now breath a special attack.")
	button_icon_toggle_deactivated = "generic_toggle0"


//Spawning
/mob/living/simple_animal/hostile/abnormality/seasons/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_SEASON_CHANGE, PROC_REF(Transform))
	addtimer(CALLBACK(src, PROC_REF(TryTransform)), 1)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/TryTransform()
	dir = SOUTH
	Transform()

/mob/living/simple_animal/hostile/abnormality/seasons/PostSpawn()
	. = ..()
	work_timer = addtimer(CALLBACK(src, PROC_REF(WorkCheck)), 9 MINUTES, TIMER_OVERRIDE & TIMER_UNIQUE & TIMER_STOPPABLE)
	if((locate(/obj/effect/season_turf) in range(1, src)))
		return
	if(datum_reference != null) // Can't downgrade if GotS is not even contained.
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
		if((chance < 50) && (chance > 0)) //WAW form is a bit more lenient on work
			return chance + 35
	return chance

// Transformations
/mob/living/simple_animal/hostile/abnormality/seasons/proc/Transform()
	current_season = SSlobotomy_events.current_season
	ChangeResistances(modular_damage_coeff[current_season]) // So basically what we're doing here is grabbing all of the stats from various associated lists
	switch(current_season)
		if("spring")
			gift_type =  /datum/ego_gifts/spring
		if("summer")
			gift_type =  /datum/ego_gifts/summer
		if("fall")
			gift_type =  /datum/ego_gifts/fall
		if("winter")
			gift_type =  /datum/ego_gifts/winter
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
	switch(current_season)
		if("spring")
			special_melee_attack = PROC_REF(SpringMelee) // I initially wanted to do these with lists like everything else, but BYOND didn't like it.
			special_slam_attack = PROC_REF(SpringSlam)
			unique_special_attack = PROC_REF(SpringSpecial)
		if("summer")
			special_melee_attack = PROC_REF(SummerMelee)
			special_slam_attack = PROC_REF(SummerSlam)
			unique_special_attack = PROC_REF(SummerSpecial)
		if("fall")
			special_melee_attack = PROC_REF(FallMelee)
			special_slam_attack = PROC_REF(FallSlam)
			unique_special_attack = PROC_REF(FallSpecial)
		if("winter")
			special_melee_attack = PROC_REF(WinterMelee)
			special_slam_attack = PROC_REF(WinterSlam)
			unique_special_attack = PROC_REF(WinterSpecial)
	if(datum_reference != null) // Do not change containment conditions if it does not have a containment cell assigned.
		var/list/new_work_chances = modular_work_chance[current_season]
		work_chances = new_work_chances.Copy()
		datum_reference.available_work = work_chances
	if(downgraded)
		icon_state = "[current_season]_mini"
		portrait = "[current_season]"
		name = season_stats[current_season][3]
		desc = season_stats[current_season][5]
	update_icon()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Downgrade()
	downgraded = TRUE
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	Transform()
	can_breach = FALSE
	fear_level = WAW_LEVEL
	work_damage_upper = 9
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
	work_damage_upper = 10
	datum_reference.qliphoth_meter_max = 1
	datum_reference.qliphoth_change(1)
	is_flying_animal = FALSE
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	update_icon()
	for(var/turf/open/O in range(1, src))
		new /obj/effect/season_turf(O) // We create this manually instead of using the proc so it is never deleted.

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
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/seasons/Destroy()
	EndWeather()
	for(var/obj/effect/season_turf/newturf in spawned_turfs)
		newturf.DoDelete()
	for(var/mob/living/simple_animal/hostile/flora_zombie/thezombie in zombies)
		thezombie.gib()
	for(var/obj/structure/thorn_bomb/thebomb in plants)
		thebomb.Wilt()
	return ..()

/mob/living/simple_animal/hostile/abnormality/seasons/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(downgraded)
		Upgrade()
		ZeroQliphoth()
		return
	. = ..()
	if(breach_type != BREACH_MINING)
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)

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
		if((special_attack_cooldown <= world.time) && prob(35))
			return TrySpecialAttack(attacked_target)
		if((slam_cooldown <= world.time) && prob(35))
			return TrySlam()
	if(ishuman(attacked_target))
		if(Finisher(attacked_target))
			return
	if(isliving(target))
		TryMeleeAttack(target)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/seasons/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				if(special_attack_cooldown <= world.time)
					TrySpecialAttack(target)
		return ..()

	if(special_attack_cooldown <= world.time)
		TrySpecialAttack(target)
		return
	if((slam_cooldown <= world.time))
		TrySlam(target)
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

/mob/living/simple_animal/hostile/abnormality/seasons/Move()
	if(!can_act)
		return FALSE
	for(var/turf/open/O in range(1, src))
		TryCreateSeasonTurf(O)
	..()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/TryMeleeAttack(mob/living/attacked_target)
	changeNext_move(SSnpcpool.wait / rapid_melee) //Prevents attack spam
	if(attacked_target)
		. = call(src, special_melee_attack)(attacked_target)
	else
		. = call(src, special_melee_attack)()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/TrySlam(atom/attacked_target)
	if(target)
		. = call(src, special_slam_attack)(target)
	else
		. = call(src, special_slam_attack)()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/TrySpecialAttack(atom/attacked_target)
	if(target)
		. = call(src, unique_special_attack)(target)
	else
		. = call(src, unique_special_attack)()

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Pulse()//Periodic weak AOE attack
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/seasons/pulse.ogg', 30, FALSE, 3)
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(5, orgin)
	for(var/i = 0 to 5)
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
	TryCreateSeasonTurf(T)
	for(var/mob/living/L in T)
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, melee_damage_type)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Finisher(mob/living/carbon/human/H) //return TRUE to prevent attacking, as attacking causes runtimes if the target is gibbed.
	if(current_season == "spring" && H.sanity_lost) // we check for sanity, and kill em
		if(!QDELETED(H))
			if(!H.real_name)
				return FALSE
			var/mob/living/simple_animal/hostile/flora_zombie/C = new(get_turf(H))
			C.master = src
			C.name = "[H.real_name]"//applies the target's name and adds the name to its description
			C.icon_state = "flora_zombie"
			C.icon_living = "flora_zombie"
			C.desc = "What appears to be [H.real_name], only mangled by vines and decayed..."
			C.gender = H.gender
			C.faction = src.faction
			zombies += C
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
				if(H.buckled)
					return TRUE
				H.adjustBruteLoss(H.maxHealth)
				if(IsCombatMap())
					return TRUE
				var/turf/T = get_turf(H)
				if(locate(/obj/structure/seasons_ice) in T)
					T = pick_n_take(T.reachableAdjacentTurfs())//if a noose is on this tile, it'll still create another one. You probably shouldn't be letting this many people die to begin with
					H.forceMove(T)
				var/obj/structure/seasons_ice/N = new(get_turf(H))
				N.buckle_mob(H)
				playsound(get_turf(H), 'sound/abnormalities/seasons/frozen_solid.ogg', 75, FALSE, 12) // this is meant to be an easter egg of sorts
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SpringMelee(mob/living/attacked_target)
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/strongcharge.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(8)
	attack_orientation = -attack_orientation
	//check if target still exists after the sleep and bail if not
	if(QDELETED(attacked_target))
		if(!client && FindTarget())
			attacked_target = target
		else
			can_act = TRUE
			return

	//All this schizobabble is to determine the position of the second line attack
	var/turf/target_turf = get_ranged_target_turf_direct(src, attacked_target, 10)
	var/turf/myturf = get_turf(src)
	var/x_dist = abs(target_turf.x - myturf.x)
	var/y_dist = abs(target_turf.y - myturf.y)
	var/orientation = (x_dist <= y_dist)
	var/turfx = myturf.x
	var/turfy = myturf.y
	if(orientation)
		turfx += (attack_orientation)
	else
		turfy += (attack_orientation)
	var/turf/line2turf = locate(turfx, turfy, myturf.z)

	var/count = 0
	for(var/turf/T in getline(myturf, target_turf))
		if(T.density)
			break
		count = count + 1
		if(get_dist(src, T) < 1)
			continue
		addtimer(CALLBACK(src, PROC_REF(SpringMeleeWarn), T), (3 * ((count*0.30)+1)) + 0.25 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(SpringMeleeHit), T), (3 * ((count*0.30)+4)) + 0.25 SECONDS)

	count = 0
	for(var/turf/L in getline(line2turf, target_turf))
		if(L.density)
			break
		count = count + 1
		if(get_dist(src, L) < 1)
			continue
		addtimer(CALLBACK(src, PROC_REF(SpringMeleeWarn), L), (3 * ((count*0.30)+1)) + 0.25 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(SpringMeleeHit), L), (3 * ((count*0.30)+4)) + 0.25 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SpringMeleeWarn(turf/T)
	if(QDELETED(src) || stat == DEAD)
		return
	TryCreateSeasonTurf(T)
	var/warningtype = breaching_stats[current_season][7]
	new warningtype(T, src)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SpringMeleeHit(turf/T)
	if(QDELETED(src) || stat == DEAD)
		return
	var/attacktype = breaching_stats[current_season][4]
	new attacktype(T, src)
	var/been_hit = FALSE
	for(var/mob/living/L in T)
		if(faction_check_mob(L))
			continue
		L.deal_damage(melee_damage_upper * 2, melee_damage_type)
		been_hit = TRUE
	if(been_hit)
		new /mob/living/simple_animal/hostile/flytrap(T)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SpringSlam()
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
		var/obj/effect/season_effect/the_attack = new attacktype(T)
		if (istype(the_attack, /obj/effect/season_effect))
			the_attack.source = src
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			var/obj/structure/thorn_bomb/thebomb = new(get_turf(L))
			plants += thebomb
			L.deal_damage(slam_damage, melee_damage_type)
			if(ishuman(L))
				Finisher(L)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SpringSpecial(atom/at = target)
	special_attack_cooldown = world.time + special_attack_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/seasons/breath_attack.ogg', 40, FALSE, 5)
	SLEEP_CHECK_DEATH(1 SECONDS)
	var/list/turfs = list()
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
	SLEEP_CHECK_DEATH(1 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/LineTarget(offset, range, atom/at = target)
	set waitfor = FALSE
	if(!at)
		return
	var/turf/T = get_ranged_target_turf_direct(src, at, range, offset)
	return (getline(src, T) - get_turf(src))

/mob/living/simple_animal/hostile/abnormality/seasons/proc/FireLine(list/turfs)
	set waitfor = FALSE
	var/attacktype = breaching_stats[current_season][5]
	var/list/hit_list = list()
	for(var/turf/T in turfs)
		if(istype(T, /turf/closed))
			break
		var/obj/effect/season_effect/the_attack = new attacktype(T)
		if (istype(the_attack, /obj/effect/season_effect))
			the_attack.source = src
		for(var/mob/living/L in T.contents)
			if(L in hit_list || istype(L, type))
				continue
			hit_list += L
			L.deal_damage(special_attack_damage, melee_damage_type)
			new /mob/living/simple_animal/hostile/flytrap(T)
			if(ishuman(L))
				Finisher(L)
		SLEEP_CHECK_DEATH(1)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SummerMelee(mob/living/attacked_target)
	can_act = FALSE
	var/turf/TT = get_turf(get_step(src, dir))
	var/turf/T = get_turf(src)
	var/rotate_dir = attack_orientation
	attack_orientation = -attack_orientation
	var/angle_to_target = Get_Angle(T, TT)
	var/angle = angle_to_target + (300 * rotate_dir) * 0.5
	if(angle > 360)
		angle -= 360
	else if(angle < 0)
		angle += 360
	var/turf/T2 = get_turf_in_angle(angle, T, 4)
	var/list/line = getline(T, T2)
	for(var/i = 1 to 20)
		angle += ((300 / 20) * rotate_dir)
		if(angle > 360)
			angle -= 360
		else if(angle < 0)
			angle += 360
		T2 = get_turf_in_angle(angle, T, 4)
		line = getline(T, T2)
		addtimer(CALLBACK(src, PROC_REF(DoLineWarning), line, TT, src), i * 0.12)
		addtimer(CALLBACK(src, PROC_REF(DoLineAttack), line, TT, src), i * 0.12 + 8)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/DoLineWarning(list/line, mob/target, mob/living/carbon/human/user)
	playsound(src, 'sound/abnormalities/seasons/summer_change.ogg', 30, TRUE, 3)
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/cult/sparks) in T)
			continue
		new /obj/effect/temp_visual/cult/sparks(T)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/DoLineAttack(list/line, mob/target, mob/living/carbon/human/user)
	var/list/been_hit = list()
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/smash_effect) in T)
			continue
		playsound(T, 'sound/weapons/fixer/generic/fire3.ogg', 30, TRUE, 3)
		new /obj/effect/temp_visual/smash_effect(T)
		new /obj/effect/temp_visual/fire/fast(T)
		been_hit = HurtInTurf(T, been_hit, (melee_damage_upper * 0.5), FIRE, check_faction = TRUE)
		been_hit = HurtInTurf(T, been_hit, melee_damage_upper, RED_DAMAGE, check_faction = TRUE)
		TryCreateSeasonTurf(T)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SummerSlam(atom/attacked_target)//AOE attack
	can_act = FALSE
	slam_cooldown = world.time + slam_cooldown_time
	var/attacktype = /obj/effect/temp_visual/smash_effect
	var/warningtype = breaching_stats[current_season][7]
	for(var/turf/L in view(3, src))
		new warningtype(L)
	playsound(get_turf(src), 'sound/abnormalities/seasons/lava_bubble.ogg', 75, FALSE, 12)
	SLEEP_CHECK_DEATH(12)
	playsound(get_turf(src), 'sound/abnormalities/seasons/boom.ogg', 80, FALSE, 12)
	for(var/turf/T in view(3, src))
		var/obj/effect/season_effect/the_attack = new attacktype(T)
		new /obj/effect/temp_visual/fire/fast(T)
		if (istype(the_attack, /obj/effect/season_effect))
			the_attack.source = src
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.deal_damage(slam_damage, melee_damage_type)
			if(ishuman(L))
				Finisher(L)
	for(var/turf/T in view(7, src))
		if(prob(85))
			continue
		var/obj/effect/rock_fall/R = new(T)
		R.boom_damage = slam_damage
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SummerSpecial(mob/living/attacked_target)
	if(!attacked_target)
		return
	special_attack_cooldown = world.time + (6 * special_attack_cooldown_time) /// Summer has a much longer special than the others.
	can_act = FALSE
	playsound(src, "sound/abnormalities/seasons/summer_change.ogg", 75, FALSE, 8)
	SLEEP_CHECK_DEATH(20)
	SwiftDash(attacked_target, 25, 20,0)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/SwiftDash(mob/living/attacked_target, distance, wait_time,dash_amount)
	special_hit_list = list()
	//check if target still exists after the sleep and bail if not
	if(QDELETED(attacked_target))
		if(!client && FindTarget())
			attacked_target = target
		else
			can_act = TRUE
			return
	var/turf/end_turf = get_ranged_target_turf_direct(src, target, distance, 0)
	var/list/turf_list = getline(src, end_turf)
	for(var/turf/T in turf_list)
		new /obj/effect/temp_visual/cult/sparks(T)
	playsound(get_turf(src), 'sound/abnormalities/seasons/lava_bubble.ogg', 85, FALSE, 12)
	face_atom(target)
	SLEEP_CHECK_DEATH(wait_time)
	for(var/turf/T in turf_list)
		if(!istype(T))
			break
		if(T.density)//Unlike claw this dash wont get it stuck in a wall
			MegaDashAoe()
			for(var/mob/living/M in livinginrange(20, get_turf(src)))
				playsound(src, "sound/abnormalities/distortedform/slam.ogg", 100, 1)
				shake_camera(M, 2, 3)
			break
		forceMove(T)
		playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
		for(var/turf/T2 in view(1,src))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T2)
			var/list/new_hits = HurtInTurf(T2, special_hit_list, special_attack_damage * 2.5, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE) - special_hit_list
			special_hit_list += new_hits
			for(var/mob/living/carbon/L in new_hits)
				L.throw_at(get_edge_target_turf(L, dir), 5, 2, gentle = TRUE)
		if(T != turf_list[turf_list.len]) // Not the last turf
			SLEEP_CHECK_DEATH(0.25)
	if(dash_amount < 3)
		SLEEP_CHECK_DEATH(10)
		SwiftDash(target, 25, 20,dash_amount+1)
		return
	SLEEP_CHECK_DEATH(4 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/MegaDashAoe()
	for(var/turf/T in view(4, src))
		if(prob(85))
			continue
		var/obj/effect/rock_fall/R = new(T)
		R.boom_damage = slam_damage
	for(var/turf/T in view(3,src))
		new /obj/effect/temp_visual/fire/fast(T)
		for(var/mob/living/carbon/L in HurtInTurf(T, list(), special_attack_damage * 1.75, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, get_turf(src))))
			L.throw_at(throw_target, 5, 2, gentle = TRUE)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/FallMelee(mob/living/attacked_target)
	if(!attacked_target)
		return
	can_act = FALSE
	var/attacktype = breaching_stats[current_season][4]
	var/damage_dealt = rand(melee_damage_lower, melee_damage_upper)
	var/bomb_damage = melee_damage_upper * 1.5
	var/turf/target_turf
	playsound(attacked_target, 'sound/abnormalities/seasons/old_fall_attack.ogg', 90, FALSE, 10)
	attacked_target.deal_damage(damage_dealt * 0.5, BLACK_DAMAGE)
	attacked_target.apply_dark_flame(1)
	target_turf = get_turf(attacked_target)
	new /obj/effect/temp_visual/seasons_wisp_death(target_turf)
	if(!target_turf)
		can_act = TRUE
		return
	SLEEP_CHECK_DEATH(8)
	playsound(attacked_target, 'sound/abnormalities/seasons/boom.ogg', 40, FALSE, 10)
	for(var/turf/T in view(1, target_turf))
		var/obj/effect/season_effect/the_attack = new attacktype(T)
		if(istype(the_attack, /obj/effect/season_effect))
			the_attack.source = src
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.deal_damage(bomb_damage, BLACK_DAMAGE)
			if(ishuman(L))
				Finisher(L)
			L.apply_dark_flame(8)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/FallSlam(atom/attacked_target)
	can_act = FALSE
	slam_cooldown = world.time + slam_cooldown_time
	var/attacktype = breaching_stats[current_season][4]
	var/warningtype = breaching_stats[current_season][7]
	for(var/turf/L in view(3, src))
		new warningtype(L)
	playsound(get_turf(src), 'sound/abnormalities/seasons/lava_bubble.ogg', 90, FALSE, 12)
	SLEEP_CHECK_DEATH(16)
	playsound(get_turf(src), 'sound/abnormalities/seasons/boom.ogg', 80, FALSE, 12)
	for(var/turf/T in view(3, src))
		var/obj/effect/season_effect/the_attack = new attacktype(T)
		if (istype(the_attack, /obj/effect/season_effect))
			the_attack.source = src
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.deal_damage(slam_damage, melee_damage_type)
			if(ishuman(L))
				Finisher(L)
			L.apply_dark_flame(10)
	var/spawn_max = 3
	var/count = 0
	for(var/turf/T in view(7, src))
		if(count >= spawn_max)
			break
		if(prob(5))
			continue
		++count
		var/mob/living/simple_animal/hostile/willowisp/W = new(T)
		W.progenitor = src
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE


/mob/living/simple_animal/hostile/abnormality/seasons/proc/FallSpecial(mob/living/attacked_target)
	special_attack_cooldown = world.time + special_attack_cooldown_time
	can_act = FALSE
	visible_message(span_danger("[src] prepares to spew flames at [target]!"))
	playsound(get_turf(src), 'sound/abnormalities/seasons/lava_bubble.ogg', 75, FALSE, 12)
	SLEEP_CHECK_DEATH(4)
	playsound(get_turf(src), 'sound/abnormalities/seasons/fall_warning.ogg', 75, 1, 3)
	var/turf/startloc = get_turf(src)
	var/alternate = TRUE
	for(var/k = 1 to 27)
		var/intervals = 3
		if(!alternate)
			intervals = 2
		for(var/i = 1 to intervals)
			if(!target)
				break
			var/obj/projectile/fall_projectile/P = new(get_turf(src))
			P.starting = startloc
			P.firer = src
			P.fired_from = src
			P.yo = attacked_target.y - startloc.y
			P.xo = attacked_target.x - startloc.x
			P.original = target
			P.preparePixelProjectile(target, src)
			P.fire()
		alternate = -alternate
		SLEEP_CHECK_DEATH(1)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/WinterMelee(mob/living/attacked_target)
	can_act = FALSE
	var/list/target_list = list()
	for(var/mob/living/L in urange(10, src))
		if(L.z != z || (L.status_flags & GODMODE))
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		target_list += L
	var/projectile_number = (length(target_list) + 3)
	for(var/i = 1 to projectile_number)
		if(LAZYLEN(target_list))
			target = pick(target_list)
		if(!target)
			return
		var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
		if(T.density)
			i -= 1
			continue
		var/obj/projectile/season_projectile/winter/weak/P
		P = new(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = target.y - T.y
		P.xo = target.x - T.x
		P.original = target
		P.preparePixelProjectile(target, T)
		addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), i + 6)
	playsound(get_turf(src), 'sound/abnormalities/seasons/winter_change.ogg', 15, 0, 2)
	SLEEP_CHECK_DEATH(7)
	playsound(get_turf(src), 'sound/abnormalities/seasons/winter_attack.ogg', 50, 0, 4)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/WinterSlam(atom/attacked_target)
	var/warningtype = breaching_stats[current_season][7]
	slam_cooldown = world.time + slam_cooldown_time
	can_act = FALSE
	for(var/turf/L in view(1, src))
		new warningtype(L)
	playsound(get_turf(src), 'sound/abnormalities/seasons/aoe_warning.ogg', 75, FALSE, 12)
	SLEEP_CHECK_DEATH(12)
	playsound(get_turf(src), 'sound/abnormalities/seasons/aoe_attack.ogg', 80, FALSE, 12)
	for(var/i = 0 to 4)
		addtimer(CALLBACK(src, PROC_REF(WinterSlamAttack), attacked_target), (i * 4) + 0.5 SECONDS)
	SLEEP_CHECK_DEATH(35)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/WinterSlamAttack(atom/attacked_target)
	var/max_targets = 3
	var/current_targets = 0
	var/attacktype = breaching_stats[current_season][4]
	for(var/turf/T in view(1, src))
		var/obj/effect/season_effect/the_attack = new attacktype(T)
		if (istype(the_attack, /obj/effect/season_effect))
			the_attack.source = src
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.deal_damage(slam_damage, melee_damage_type)
			if(ishuman(L))
				Finisher(L)
	for(var/mob/living/T in view(9, src))
		if(current_targets >= max_targets)
			break
		if(T == attacked_target)
			continue
		if(faction_check_mob(T))
			continue
		Shoot(T)
		current_targets ++
	if(attacked_target)
		Shoot(attacked_target)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/WinterSpecial(mob/living/attacked_target)
	special_attack_cooldown = world.time + special_attack_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/babayaga/warning.ogg', 75, 0, 4)
	SLEEP_CHECK_DEATH(4)
	var/obj/projectile/season_projectile/winter/special/P = new(get_turf(src))
	P.firer = src
	P.fired_from = src
	P.preparePixelProjectile(attacked_target, src)
	P.fire()
	playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
	SLEEP_CHECK_DEATH(10)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/seasons/proc/TryCreateSeasonTurf(turf/open/O)
	if(!isturf(O) || isspaceturf(O))
		return
	if(locate(/obj/effect/season_turf) in O)
		return
	var/obj/effect/season_turf/newturf = new(O)
	spawned_turfs += newturf

//Weather and such
/datum/weather/thunderstorm //Spring weather, thunder strikes.
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
			new /obj/effect/turf_fire(T)

/datum/weather/fog //Fall weather, causes swamp decay, destroying food and dealing minor damage.
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
	if(prob(0.1))
		var/rotted
		for(var/obj/item/food/thefood in L.get_all_gear())
			if(TryRotFoodItem(thefood))
				to_chat(L, span_warning("A mysterious force decays your food!"))
				rotted = TRUE
				break
		if(!rotted)
			L.deal_damage(1, TOX)
		var/obj/effect/temp_visual/alriune_attack/vfx = new(get_turf(L))
		vfx.color = COLOR_VERY_DARK_LIME_GREEN
		to_chat(L, span_warning("A mysterious force rapidly decays you!"))
		playsound(L, 'sound/abnormalities/goldenapple/False_Attack.ogg', 75, TRUE, 10)

/datum/weather/fog/proc/TryRotFoodItem(obj/item/food)
	if(IS_EDIBLE(food))
		qdel(food)
		return TRUE
	return FALSE

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

/datum/movespeed_modifier/freezing
	multiplicative_slowdown = 0
	variable = TRUE

//Misc. Objects
/obj/effect/season_turf //Modular turf that spawnes under the abnormality with Upgrade().
	name = "grass"
	desc = "A thick layer of foilage that never seems to die down."
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	layer = TURF_LAYER
	anchored = TRUE
	var/list/season_list = list(
		"spring" = list("porccubus poppy", "A bed of toxic flowers."),
		"summer" = list("volcanic rock","Some incredibly hot igneus rock."),
		"fall" = list("swampy grass","A thick marsh, deep enough that you need to wear boots."),
		"winter" = list("snow","A patch of snow."),
	)
	var/current_season
	var/area_affected
	var/damaging
	var/list/viable_landmarks = list(
		/obj/effect/landmark/xeno_spawn,
		/obj/effect/landmark/department_center
		)

/obj/effect/season_turf/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_SEASON_CHANGE, PROC_REF(Transform))
	Transform()

/obj/effect/season_turf/proc/Transform()
	current_season = SSlobotomy_events.current_season
	icon = 'icons/turf/floors.dmi'
	name = season_list[current_season][1]
	desc = season_list[current_season][2]
	for(var/X in GLOB.department_centers) // It would make sense to check xeno spawns in an area, but that actually loops through every turf in the world.
		var/turf/T = X
		if(get_dist(T, src) < 4)
			area_affected = TRUE
			break
	if(!area_affected)
		for(var/Y in GLOB.xeno_spawn)
			var/turf/F = Y
			if(get_dist(F, src) < 2)
				area_affected = TRUE
				break
	cut_overlays()
	switch(current_season)
		if("spring")
			if(area_affected)
				var/mutable_appearance/plant_overlay = mutable_appearance('icons/obj/hydroponics/growing.dmi', "porccuflower", layer = OBJ_LAYER + 0.01)
				add_overlay(plant_overlay)
			icon_state = "grass[rand(0,3)]"
		if("summer")
			if(area_affected)
				icon_state = "lava"
				return
			icon_state = "basalt[rand(0,3)]"
		if("fall")
			if(area_affected)
				icon_state = "riverwater"
				color = COLOR_ALMOST_BLACK
				return
			icon_state = "wasteland[rand(8,11)]"
		if("winter")
			icon = 'icons/turf/snow.dmi'
			if(area_affected)
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
	if(!area_affected)
		return
	switch(current_season)
		if("spring")
			to_chat(H, span_warning("You are stung by porccubus flowers as you pass through!"))
			playsound(H, 'sound/abnormalities/porccubus/porccu_attack.ogg', 35, TRUE, 10)
			DoDamage()
		if("summer")
			to_chat(H, span_warning("You stumbled into a pool of lava!"))
			playsound(H, 'sound/effects/footstep/lava3.ogg', 100, FALSE, 10)
			DoDamage()
		if("fall")
			to_chat(H, span_warning("You get stuck in the sticky tar!"))
			playsound(H, 'sound/effects/footstep/slime1.ogg', 75, FALSE, 10)
			H.Immobilize(0.5 SECONDS)
		if("winter")
			if(H.body_position == LYING_DOWN)
				if(prob(75))
					step(H, H.dir)
				return
			if(prob(25))
				to_chat(H, span_warning("You lose your footing on the ice!"))
				H.apply_lc_tremor(1, 3)
				step(H, H.dir)
				return
			to_chat(H, span_notice("You manage to keep your balance on the slippery ice."))

/obj/effect/season_turf/proc/DoDamage()
	var/dealt_damage = FALSE
	for(var/mob/living/L in get_turf(src))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(current_season == "summer")
				H.deal_damage(2, FIRE)
				H.apply_lc_burn(3)
				dealt_damage = TRUE
			else if(current_season == "spring")
				H.apply_damage(4, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = FALSE)
	if(!dealt_damage)
		damaging = FALSE
		return
	addtimer(CALLBACK(src, PROC_REF(DoDamage)), 4)

/obj/effect/season_turf/proc/DoDelete()
	var/randomtimer = rand(3,15)
	animate(src, alpha = 150, time = randomtimer SECONDS)
	QDEL_IN(src, randomtimer SECONDS)

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
	var/mob/living/simple_animal/hostile/abnormality/seasons/source

/obj/effect/season_effect/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(pop)), 0.5 SECONDS)

/obj/effect/season_effect/proc/pop()
	if(!source)
		QDEL_IN(src, 0.5 SECONDS)
		return
	if(!locate(/obj/effect/season_turf) in get_turf(src))
		var/obj/effect/season_turf/newturf = new(get_turf(src))
		source.spawned_turfs += newturf
	if(prob(5))
		var/list/spawn_area = range(1, get_turf(src))
		for(var/turf/open/O in spawn_area)
			if(!isturf(O) || isspaceturf(O))
				continue
			var/obj/effect/season_turf/G = (locate(/obj/effect/season_turf) in O)
			if(G)
				qdel(G)
			var/obj/effect/season_turf/anewturf = new(O)
			source.spawned_turfs += anewturf
	QDEL_IN(src, 0.5 SECONDS)

/obj/effect/season_effect/summer
	icon = 'icons/effects/effects.dmi'
	icon_state = "summer_attack"

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
	if(prob(25))
		..()
		return
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

/obj/effect/thunderbolt/seasons/Convert(mob/living/carbon/human/H) // no conversion - ripped from thunderbird's code.
	return

//Summons
/mob/living/simple_animal/hostile/willowisp
	name = "corpse light"
	desc = "Will-o the wisp."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "seasons_wisp"
	icon_living = "seasons_wisp"
	icon_dead = "seasons_wisp_death"
	health = 100
	maxHealth = 100
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 3)
	stat_attack = HARD_CRIT
	is_flying_animal = TRUE
	death_sound = 'sound/abnormalities/seasons/old_fall_attack.ogg'
	speak_emote = list("entones")
	del_on_death = TRUE
	light_color = "#6496FA"
	light_power = 3
	var/can_act = TRUE
	var/bomb_damage = 75
	var/mob/living/simple_animal/hostile/abnormality/seasons/progenitor

/mob/living/simple_animal/hostile/willowisp/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/willowisp/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	LightFuse()

/mob/living/simple_animal/hostile/willowisp/proc/LightFuse()
	can_act = FALSE
	if(!progenitor)
		qdel(src)
	addtimer(CALLBACK(src, PROC_REF(Detonate)), 1.2 SECONDS)
	del_on_death = FALSE
	death()

/mob/living/simple_animal/hostile/willowisp/proc/Detonate()
	playsound(src, 'sound/abnormalities/seasons/boom.ogg', 40, FALSE, 10)
	new /obj/effect/temp_visual/explosion(get_turf(src))
	for(var/turf/T in view(2, src))
		var/obj/effect/season_effect/the_attack = new /obj/effect/season_effect/breath/fall(T)
		if(istype(the_attack, /obj/effect/season_effect))
			the_attack.source = progenitor
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.deal_damage(bomb_damage, BLACK_DAMAGE)
			L.apply_dark_flame(10)

/mob/living/simple_animal/hostile/willowisp/death()
	. = ..()
	if(!del_on_death)
		QDEL_IN(src, 13)

/mob/living/simple_animal/hostile/flytrap
	name = "Spring Triffid"
	desc = "A massive fly trap..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "flytrap"
	icon_living = "flytrap"
	del_on_death = TRUE
	health = 70
	maxHealth = 70
	obj_damage = 10
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 10
	faction = list("hostile")
	speak_emote = list("screeches")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.2)//no mind to break
	speed = 5
	attack_sound = 'sound/abnormalities/nosferatu/bat_attack.ogg'
	density = FALSE
	var/attack_count = 0

/mob/living/simple_animal/hostile/flytrap/AttackingTarget(atom/attacked_target)
	. = ..()
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		H.apply_venom(5)
	++attack_count
	if(attack_count >= 5)
		death()

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
	health = 100
	maxHealth = 100
	obj_damage = 20
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.2)//no mind to break
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 20
	rapid_melee = 1
	speed = 5
	move_to_delay = 3.75
	ranged = TRUE
	ranged_cooldown_time = 1.5 SECONDS
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = FALSE
	density = TRUE
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 1)
	var/list/breach_affected = list()
	var/can_act = TRUE
	var/mob/living/simple_animal/hostile/abnormality/seasons/master

//Zombie conversion from zombie kills
/mob/living/simple_animal/hostile/flora_zombie/AttackingTarget()
	. = ..()
	if(!can_act)
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.stat >= SOFT_CRIT || H.health < 0 || H.sanity_lost)
		Convert(H)
		return
	H.apply_venom(5)

/mob/living/simple_animal/hostile/flora_zombie/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/attack.ogg', 50, 1, 4)

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

/obj/structure/thorn_bomb
	name = "Thorn Plant"
	desc = "Something flippant grows here..."
	icon = 'icons/obj/hydroponics/growing.dmi'
	icon_state = "fairygrass-grow2"
	density = FALSE
	anchored = TRUE
	max_integrity = 300
	armor = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.5)
	var/stage = 0
	var/grow_interval = 5 SECONDS
	var/growing = TRUE

/obj/structure/thorn_bomb/Initialize()
	. = ..()
	Grow()
	proximity_monitor = new(src, 1)
	addtimer(CALLBACK(src, PROC_REF(Wilt)), 45 SECONDS)

/obj/structure/thorn_bomb/proc/Grow()
	if(!growing)
		return
	stage = stage + 1 > 4 ? 4 : stage + 1
	UpdateStage()
	if(stage >= 4)
		return
	addtimer(CALLBACK(src, PROC_REF(Grow)), grow_interval)

/obj/structure/thorn_bomb/proc/UpdateStage()
	cut_overlays()
	if(stage == 0)
		return
	var/mutable_appearance/plant_overlay = mutable_appearance('icons/obj/hydroponics/growing_fruits.dmi', "bungotree-grow[stage]", layer = OBJ_LAYER + 0.01)
	add_overlay(plant_overlay)

/obj/structure/thorn_bomb/HasProximity(atom/movable/AM)
	if(stage <= 3)
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
	if(stage <= 2)
		return
	Explode()

/obj/structure/thorn_bomb/proc/Explode()
	if(!growing)
		return
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

/obj/structure/thorn_bomb/proc/Wilt() // Should delete on its own
	if(!growing) // should prevent wierdness
		return
	stage = 0
	UpdateStage()
	growing = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)

// On-kill visual effect
/obj/structure/seasons_ice
	name = "ice cube"
	desc = "Sure glad they're in there and we're out here!"
	icon = 'icons/effects/freeze.dmi'
	icon_state = "ice_cube"
	max_integrity = 60
	buckle_lying = 0
	layer = ABOVE_ALL_MOB_LAYER
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE

/obj/structure/seasons_ice/attack_hand(mob/user)
	if(!has_buckled_mobs())
		return ..()
	for(var/mob/living/L in buckled_mobs)
		user_unbuckle_mob(L, user)
	return

/obj/structure/seasons_ice/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return

/obj/structure/seasons_ice/buckle_mob(mob/living/M, force, check_loc, buckle_mob_flags)
	if(M.buckled)
		return
	M.adjustBruteLoss(100)
	M.setDir(2)
	return ..()

// No, you can't destroy ice cubes by unbuckling someone.
/obj/structure/seasons_ice/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	return

/obj/structure/seasons_ice/proc/release_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x
	unbuckle_mob(M,force=1)
	src.visible_message(text("<span class='danger'>[M] falls free of the [src]!</span>"))
	qdel(src)

/obj/structure/seasons_ice/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()

#undef SEASONS_SLAM_COOLDOWN
