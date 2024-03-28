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
		"spring" = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5),
		"summer" = list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1), //Summer is tanky
		"fall" = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 1.5),
		"winter" = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.2)
		)

	//Work Vars
	var/current_season = "winter"
	var/downgraded
	var/safe
	var/work_timer
	//Breach Vars
	var/can_act = TRUE
	var/slam_damage = 200
	var/slam_cooldown
	var/slam_cooldown_time = 20 SECONDS
	var/cone_attack_damage = 90
	var/cone_attack_cooldown
	var/cone_attack_cooldown_time = 10 SECONDS
	var/pulse_cooldown
	var/pulse_cooldown_time = 4 SECONDS
	var/pulse_damage = 15

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
		if((chance < 50) && (chance > 0)) //WAW form is a bit more lenient on work
			return chance + 35
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
	if(downgraded)
		icon_state = "[current_season]_mini"
		portrait = "[current_season]"
		name = season_stats[current_season][3]
		desc = season_stats[current_season][5]
	if(current_season == "winter")
		cone_attack_damage = 75
		slam_damage = 125
		pulse_damage = 10
	else
		cone_attack_damage = initial(cone_attack_damage)
		slam_damage = initial(slam_damage)
		pulse_damage = initial(pulse_damage)
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

/mob/living/simple_animal/hostile/abnormality/seasons/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(downgraded)
		Upgrade()
		ZeroQliphoth()
		return
	. = ..()
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
		if((cone_attack_cooldown <= world.time) && prob(35))
			return ConeAttack(target)
		if((slam_cooldown <= world.time) && prob(35))
			return Slam()
	if(ishuman(target))
		if(Finisher(target))
			return
	return ..()

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

/mob/living/simple_animal/hostile/abnormality/seasons/Move()
	if(!can_act)
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
		new attacktype(T)
		for(var/mob/living/L in T.contents)
			if(L in hit_list || istype(L, type))
				continue
			hit_list += L
			L.apply_damage(cone_attack_damage, melee_damage_type, null, L.run_armor_check(null, melee_damage_type), spread_damage = TRUE)
			to_chat(L, span_userdanger("You have been hit by [src]'s breath attack!"))
			if(ishuman(L))
				Finisher(L)
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
			L.apply_damage(slam_damage, melee_damage_type, null, L.run_armor_check(null, melee_damage_type), spread_damage = TRUE)
			if(ishuman(L))
				Finisher(L)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

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
	if(!locate(/obj/effect/season_turf/temporary) in T)
		new /obj/effect/season_turf/temporary(T)
	for(var/mob/living/L in T)
		if(faction_check_mob(L))
			continue
		L.apply_damage(pulse_damage, melee_damage_type, null, L.run_armor_check(null, melee_damage_type), spread_damage = TRUE)

/mob/living/simple_animal/hostile/abnormality/seasons/proc/Finisher(mob/living/carbon/human/H) //return TRUE to prevent attacking, as attacking causes runtimes if the target is gibbed.
	if(current_season == "spring" && H.sanity_lost)
		H.gib() //eventually we'll add some sort of effect
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
			new /obj/effect/hotspot(T)
			for(var/mob/living/M in T.contents)
				M.adjust_fire_stacks(3)
				M.IgniteMob()

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
			if(prob(5))
				to_chat(H, span_warning("Your legs are cut by brambles in the grass!"))
				H.apply_damage(5, BLACK_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = FALSE)
		if("summer")
			if(icon_state == "lava")
				to_chat(H, span_warning("You stumbled into a pool of lava!"))
				H.adjust_fire_stacks(rand(0.1, 1))
				H.IgniteMob()
		if("fall")
			if(prob(5))
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

#undef SEASONS_SLAM_COOLDOWN
