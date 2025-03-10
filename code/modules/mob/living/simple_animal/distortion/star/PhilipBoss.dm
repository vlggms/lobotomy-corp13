//Do not ping Chiemi for bugs, peace.
#define TCC_SORROW_COOLDOWN (5 SECONDS)
#define TCC_COMBUST_COOLDOWN (20 SECONDS)

/mob/living/simple_animal/hostile/distortion/Philip
	name = "\proper The Unspeaking Child"
	desc = "A towering blazing statue, setting everything on it's path ablaze"
	icon = 'ModularTegustation/Teguicons/Ensemble96x96.dmi'
	icon_living = "Philip"
	icon_state = "Philip"
	pixel_x = -50
	base_pixel_x = -32
	pixel_y = 0
	base_pixel_y = -15
	is_flying_animal = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	health = 14000
	maxHealth = 14000
	obj_damage = 600
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 45
	melee_damage_upper = 55
	move_to_delay = 3
	ranged = TRUE

	attack_sound = 'sound/abnormalities/crying_children/attack_salvador.ogg'
	death_sound = 'sound/abnormalities/crying_children/death.ogg'
	death_message = "crumbles into pieces."
	del_on_death = FALSE
//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/city/ensemble,
		/obj/item/ego_weapon/shield/city/ensemble/philip
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Philip")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/clothing/suit/armor/ego_gear/city/ensembleweak)
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Black swan is the most strongly related to this guy, but I might make one for it later.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/crying_children //This makes no sense at all due to it being a downgrade, but it is what it is.
	egoist_attributes = 130
	can_spawn = 0
	var/unmanifesting
	var/list/children_list = list()
	var/charge = 0
	var/can_charge = TRUE // Prevents charging the map wide attack
	var/maxcharge = 180
	var/desperation_cooldown
	var/desperation_cooldown_time = 0.25 SECONDS
	var/sorrow_cooldown
	var/sorrow_cooldown_time = 2 SECONDS
	var/courage_cooldown
	var/courage_cooldown_time = 20 SECONDS
	var/desperate = FALSE
	var/can_act = TRUE
	var/death_counter = 0
	var/burn_mod = 1
	var/icon_phase = "Philip"
	var/pulse_cooldown
	var/pulse_cooldown_time = 200 SECONDS
	var/turned_off = FALSE

	attack_action_types = list(
		/datum/action/cooldown/tcc_sorrow,
		/datum/action/cooldown/tcc_combust,
	)


/mob/living/simple_animal/hostile/distortion/Philip/Life()
	. = ..()
	if(can_charge)
		Charge_Finale()

// DON'T IGNORE ME!!
/mob/living/simple_animal/hostile/distortion/Philip/proc/Charge_Finale()
	if(desperation_cooldown <= world.time)
		charge += 2
		desperation_cooldown = (world.time + desperation_cooldown_time)
		if(charge == maxcharge - 10) // 10 Final Seconds, You can't reduce anymore, only kill!!
			charge = 666
			addtimer(CALLBACK(src, PROC_REF(Scorching_Desperation)), 10 SECONDS)
			for(var/mob/living/L in GLOB.mob_living_list)
				if(faction_check_mob(L, FALSE) || L.z != z || L.stat == DEAD)
					continue
				to_chat(L, span_userdanger("Everything seems hazy, even metal is starting to melt. You can barely withstand the heat!"))
				flash_color(L, flash_color = COLOR_SOFT_RED, flash_time = 150)
				SEND_SOUND(L, sound('sound/ambience/acidrain_mid.ogg'))

// 300 Red + 75 Pure damage
/mob/living/simple_animal/hostile/distortion/Philip/proc/Scorching_Desperation()
	if(charge < maxcharge) // Cancels if he change phases or dies
		return
	charge = 0
	for(var/mob/living/L in GLOB.mob_living_list)
		if(faction_check_mob(L, FALSE) || L.z != z || L.stat == DEAD)
			continue
		to_chat(L, span_userdanger("You're boiling alive from the heat of a miniature sun!"))
		playsound(L, 'sound/abnormalities/crying_children/attack_aoe.ogg', 50, TRUE)
		L.deal_damage(300, RED_DAMAGE)
		L.apply_lc_burn(50)
		new /obj/effect/temp_visual/fire/fast(get_turf(L))


/mob/living/simple_animal/hostile/distortion/Philip/Move()
	if(!can_act)
		return FALSE
	return ..()

// Gibbing just change phases
/mob/living/simple_animal/hostile/distortion/Philip/gib()
	if(!desperate)
		death()
		return FALSE
	return ..()


/mob/living/simple_animal/hostile/distortion/Philip/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

	// If for some reason admeme deletes it
	for(var/mob/living/L in children_list)
		L.death()
	return ..()

/mob/living/simple_animal/hostile/distortion/Philip/OpenFire()
	if(!can_act)
		return
	if(sorrow_cooldown <= world.time && get_dist(src, target) > 2)
		Wounds_Of_Sorrow(target)
	if(desperate && courage_cooldown <= world.time && (target in view(2, src)) && prob(30)) // Make it less predictable
		Combusting_Courage()
	return

/mob/living/simple_animal/hostile/distortion/Philip/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(!client)
		if(desperate && (courage_cooldown <= world.time) && prob(30))
			return Combusting_Courage()
		if(sorrow_cooldown <= world.time && prob(25))
			return Wounds_Of_Sorrow(attacked_target)

	if(prob(35))
		return Bygone_Illusion(attacked_target)

	// Distorted Illusion
	can_act = FALSE
	icon_state = "Philip"
	. = ..()
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		L.apply_lc_burn(5*burn_mod)
	SLEEP_CHECK_DEATH(10)
	icon_state = "Philip"
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/Philip/proc/Bygone_Illusion(mob/living/target)
	can_act = FALSE
	var/turf/slash_start = get_turf(src)
	var/turf/slash_end = get_ranged_target_turf_direct(slash_start, target, 4)
	var/dir_to_target = get_dir(slash_start, slash_end)
	face_atom(target)
	var/list/hitline = list()
	var/list/been_hit = list()
	for(var/turf/T in getline(slash_start, slash_end))
		if(T.density)
			break
		for(var/turf/open/TT in range(1, T))
			hitline |= TT
	for(var/turf/open/T in hitline)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(5)
	playsound(src, 'sound/abnormalities/crying_children/attack_yuna.ogg', 50, FALSE)
	icon_state = "Philip"
	for(var/turf/open/T in hitline)
		var/obj/effect/temp_visual/dir_setting/slash/S = new(T, dir_to_target)
		S.pixel_x = rand(-8, 8)
		S.pixel_y = rand(-8, 8)
		animate(S, alpha = 0, time = 1.5)
		var/list/new_hits = HurtInTurf(T, been_hit, 60, RED_DAMAGE, null, TRUE, FALSE, TRUE, TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			to_chat(L, span_userdanger("[src] stabs you!"))
			L.apply_lc_burn(4*burn_mod)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), dir_to_target)
	SLEEP_CHECK_DEATH(10)
	icon_state = "Philip"
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/Philip/proc/Wounds_Of_Sorrow(mob/living/target)
	if(sorrow_cooldown > world.time)
		return
	sorrow_cooldown = world.time + sorrow_cooldown_time
	can_act = FALSE
	icon_state = "Philip"
	var/list/targets_to_hit = list()
	if(desperate)
		for(var/mob/living/L in view(8, src))
			if(faction_check_mob(L) || L.stat == DEAD)
				continue
			if(istype(L, /mob/living/simple_animal/bot))
				continue
			targets_to_hit += L
		for(var/obj/vehicle/V in view(8, src))
			if(V.occupants.len <= 0)
				continue
			targets_to_hit += V
	else
		targets_to_hit += target
	playsound(src, 'sound/abnormalities/crying_children/sorrow_charge.ogg', 50, FALSE)
	SLEEP_CHECK_DEATH(10)
	for(var/targets in targets_to_hit)
		var/obj/projectile/beam/sorrow_beam/P = new(get_turf(src))
		P.firer = src
		P.fired_from = src
		P.preparePixelProjectile(targets, src)
		P.fire()
	playsound(src, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 50, FALSE)
	icon_state = "Philip"
	SLEEP_CHECK_DEATH(20)
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/Philip/proc/Combusting_Courage()
	if(courage_cooldown > world.time || !desperate)
		return
	courage_cooldown = world.time + courage_cooldown_time
	can_act = FALSE
	playsound(src, 'sound/effects/ordeals/white/pale_teleport_out.ogg', 50, FALSE)
	icon_state = "Philip"
	var/list/been_hit = list()
	for(var/turf/T in view(4, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	icon_state = "Philip"
	playsound(src, 'sound/abnormalities/crying_children/attack_aoe.ogg', 50, FALSE)
	for(var/turf/T in view(4, src))
		new /obj/effect/temp_visual/fire/fast(T)
		var/list/new_hits = HurtInTurf(T, been_hit, 250, RED_DAMAGE, null, TRUE, FALSE, TRUE, TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			to_chat(L, span_userdanger("You were scorched by [src]'s flames!"))
			L.apply_lc_burn(20)
	SLEEP_CHECK_DEATH(10)
	can_act = TRUE

// Decrease charge for every 20% HP lost
/mob/living/simple_animal/hostile/distortion/Philip/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	var/oldhealth = health
	..()
	for(var/i = 1, i < 4, i++)
		if(health < (maxHealth * 0.2 * i) && oldhealth >= (maxHealth * 0.2 * i))
			charge -= 10

/mob/living/simple_animal/hostile/distortion/Philip/proc/Curse(mob/living/carbon/human/user)
	var/list/possible_curses = list()
	if(!HAS_TRAIT(user, TRAIT_BLIND))
		possible_curses += TRAIT_BLIND
	if(!HAS_TRAIT(user, TRAIT_DEAF))
		possible_curses += TRAIT_DEAF
	if(!HAS_TRAIT(user, TRAIT_MUTE))
		possible_curses += TRAIT_MUTE
	if(possible_curses.len > 0)
		var/type = pick(possible_curses)
		ADD_TRAIT(user, type, GENETIC_MUTATION)
		user.update_blindness()
		user.update_sight()
		to_chat(user, span_warning("You were cursed by [src]!"))
		addtimer(CALLBACK(src, PROC_REF(RemoveCurse), user, type), 3 MINUTES)

/mob/living/simple_animal/hostile/distortion/Philip/proc/RemoveCurse(mob/living/carbon/human/user, type)
	REMOVE_TRAIT(user, type, GENETIC_MUTATION)
	user.update_blindness()
	user.update_sight()

/obj/projectile/beam/sorrow_beam
	name = "wounds of sorrow"
	icon_state = "heavylaser"
	damage = 100
	damage_type = RED_DAMAGE

	hitscan = TRUE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB) & (~PASSCLOSEDTURF))
	muzzle_type = /obj/effect/projectile/muzzle/laser/sorrow
	tracer_type = /obj/effect/projectile/tracer/laser/sorrow
	impact_type = /obj/effect/projectile/impact/laser/sorrow

/obj/projectile/beam/sorrow_beam/on_hit(atom/target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_lc_burn(10)

/obj/effect/projectile/muzzle/laser/sorrow
	name = "wounds of sorrow"
	icon_state = "muzzle_beam_heavy"

/obj/effect/projectile/tracer/laser/sorrow
	name = "wounds of sorrow"
	icon_state = "beam_heavy"

/obj/effect/projectile/impact/laser/sorrow
	name = "wounds of sorrow"
	icon_state = "impact_beam_heavy"

/mob/living/simple_animal/hostile/distortion/Philip/Move()
	..()
	for(var/turf/open/T in range(1, src))
		if(locate(/obj/structure/turf_fire) in T)
			for(var/obj/structure/turf_fire/floor_fire in T)
				qdel(floor_fire)
		new /obj/structure/turf_fire(T)



//Ash drake stuff goes here in attempt to make this more unique.

/datum/weather/heatwave //Summer weather, sets you on fire rarely.
	name = "heatwaves"
	immunity_type = "heatwave"
	desc = "Extreme heatwaves caused by an abnormality."
	telegraph_message = span_warning("The temperature suddenly skyrockets!")
	telegraph_duration = 300
	telegraph_overlay = "light_ash"
	weather_message = span_userdanger("<i>It's too hot!</i>")
	weather_overlay = "heavy_ash"
	weather_duration_lower = 3000
	weather_duration_upper = 3000
	perpetual = FALSE //should make it last forever
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
		SpawnFireP(L)

/datum/weather/heatwave/proc/SpawnFireP(mob/living/carbon/human/L) //Randomly spawn burning tiles near players
	set waitfor = FALSE
	for(var/turf/open/T in view(3, L))
		if(prob(10))
			if(prob(66))
				sleep(rand(1,5))
			new /obj/structure/turf_fire(T)

/mob/living/simple_animal/hostile/distortion/Philip/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown > world.time))
		return
	pulse_cooldown = world.time + pulse_cooldown_time
	SSweather.run_weather(/datum/weather/heatwave)


/mob/living/simple_animal/hostile/distortion/Philip/proc/StartWeather()
	SSweather.run_weather(/datum/weather/heatwave)



#undef TCC_SORROW_COOLDOWN
#undef TCC_COMBUST_COOLDOWN
