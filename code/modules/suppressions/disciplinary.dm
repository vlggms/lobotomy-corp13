/obj/item/clothing/suit/armor/ego_gear/debug_armor
	name = "paradise lost"
	icon = 'icons/obj/clothing/ego_gear/abnormality/aleph.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/abnormality/aleph.dmi'
	desc = "\"My loved ones, do not worry; I have heard your prayers. \
	Have you not yet realized that pain is but a speck to a determined mind?\""
	icon_state = "paradise"
	armor = list(RED_DAMAGE = 100, WHITE_DAMAGE = 100, BLACK_DAMAGE = 100, PALE_DAMAGE = 100) // 280

// It is effectively an ordeal in how it works
/datum/suppression/disciplinary
	name = DISCIPLINARY_CORE_SUPPRESSION
	desc = "The illusion of the Red Mist will return to fight again once more."
	goal_text = "Defeat the Red Mist."
	run_text = "The core suppression of Disciplinary department has begun. The Red Mist has returned."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE

/datum/suppression/disciplinary/Run(run_white = FALSE, silent = FALSE)
	..()
	var/turf/T = pick(GLOB.department_centers)
	var/mob/living/simple_animal/hostile/megafauna/red_mist/R = new(T)
	RegisterSignal(R, COMSIG_PARENT_QDELETING, PROC_REF(OnRedMistDeath))

/datum/suppression/disciplinary/End(silent = FALSE)
	..()
	SSlobotomy_corp.core_suppression_state = max(SSlobotomy_corp.core_suppression_state, 3)
	SSticker.news_report = max(SSticker.news_report, CORE_SUPPRESSED_REDMIST_DEAD)

/datum/suppression/disciplinary/proc/OnRedMistDeath(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	End()

// The Red Mist mob
/mob/living/simple_animal/hostile/megafauna/red_mist
	name = "The Red Mist"
	desc = "A powerful color fixer; Despite being a mere imitation, it is nonetheless an intimidating foe."
	health = 7500
	maxHealth = 7500
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.7)
	icon_state = "red_mist_phase_1"
	icon_living = "red_mist_phase_1"
	icon_dead = "red_mist_phase_1"
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	faction = list("red mist") // Can be attacked by any abnormality
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_color = "#AA5555"
	light_range = 2
	movement_type = GROUND
	speak_emote = list("says")
	stat_attack = HARD_CRIT
	speed = 2.5
	move_to_delay = 2.75
	pixel_x = -16
	base_pixel_x = -16
	blood_volume = BLOOD_VOLUME_NORMAL
	del_on_death = FALSE
	footstep_type = FOOTSTEP_MOB_HEAVY
	can_patrol = TRUE
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 60
	melee_damage_upper = 70
	attack_verb_continuous = "beats"
	attack_verb_simple = "beat"
	rapid_melee = 2
	ranged = TRUE
	/// Red Mist is only defeated after dying with life_stage at 4
	var/life_stage = 1
	var/default_icon = "red_mist_phase_1"
	//combo stuff
	var/combo
	var/combo_time
	var/combo_wait = 20
	var/combo_target
	var/can_act = TRUE
	var/datum/reusable_visual_pool/RVP = null
	var/list/been_hit = list()
	var/can_do_counter = TRUE
	//used for attacks
	var/damage_taken = 0
	var/can_counter = FALSE
	//gold rush stuff
	var/gold_rush_charges = 8
	var/gold_rush_dash_damage = 100
	var/gold_rush_damage = 300
	//heaven attack
	var/heaven_cooldown
	var/heaven_cooldown_time = 12 SECONDS
	//used for phases 2 and 3
	var/attack_mode = 0
	//phase 2 melee damage
	var/mimicry_damage = 240
	var/da_capo_damage = 90
	var/da_capo_max_damage = 180
	//uses for the attack when she loses 33% hp
	var/mimicry_rush = FALSE
	var/turf/turf_target = null
	var/mimicry_rush_damage = 200
	var/mimicry_rush_damage_full = 500
	var/obj/effect/da_capo/scythe
	//for smile
	var/smile_rapid_damage = 10
	var/smile_rapid_range = 8
	var/smile_damage = 250
	//for justitia
	var/justitia_range = 25
	var/justitia_aoe_damage = 95
	var/justitia_aoe_range = 6
	//used for phase 4
	var/twilight_damage = 90
	var/phase_4_special
	var/phase_4_action = FALSE
	var/phase_4_special_cooldown = 20 SECONDS
	var/phase_4_exhausted
	var/phase_4_exhausted_duration = 10 SECONDS
	var/mob/hunted = null

/mob/living/simple_animal/hostile/megafauna/red_mist/Initialize()
	. = ..()
	RVP = new /datum/reusable_visual_pool(450)
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT)
	var/list/blurb_list = list(
		"I’m back; the Red Mist has walked out from a sea of pain.",
		"I’m no longer weak like I used to be; I can replace any body part even if it gets cut off, and I can be repaired even if I’m broken."
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2"), (i - 1) * 11 SECONDS)

/mob/living/simple_animal/hostile/megafauna/red_mist/Life()
	. = ..()
	if(maxHealth*0.75 < health && maxHealth*0.15 > health)//Is this moronic? Yes, but this is the only way I could figure out how to stop red mist from using her special as the phase changes.
		if(can_counter && can_act)
			switch(life_stage)
				if(1)
					GoldRush()
				if(2)
					DaCapoThrow()
				if(3)
					GoldRush()

/mob/living/simple_animal/hostile/megafauna/red_mist/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/red_mist/Moved() //more damaging fog when moving
	. = ..()
	if(!.)
		return
	if(mimicry_rush)
		for(var/turf/U in range(1, src))
			if(!locate(/obj/effect/temp_visual/smash_effect) in U)
				var/obj/effect/temp_visual/smash_effect/S = new(U)
				S.color = COLOR_RED
			var/list/new_hits = HurtInTurf(U, been_hit, mimicry_rush_damage, RED_DAMAGE, hurt_mechs = TRUE) - been_hit
			been_hit += new_hits
			for(var/mob/living/LL in new_hits)
				new /obj/effect/temp_visual/kinetic_blast(get_turf(LL))
				if(LL.stat >= HARD_CRIT)
					LL.gib()
		if(locate(scythe) in get_turf(src))
			qdel(scythe)
			MimicryStop()
			scythe = null

/mob/living/simple_animal/hostile/megafauna/red_mist/OpenFire()
	if(!can_act)
		return
	if(life_stage == 2 || life_stage == 3)
		if(heaven_cooldown < world.time)
			Heaven(target)
	return ..()

/mob/living/simple_animal/hostile/megafauna/red_mist/AttackingTarget()
	if(!can_act)
		return FALSE
	//Combo Time stuff
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait

	if(combo_target != target)
		combo_target = target
		combo = 0
	switch(life_stage)
		if(1)
			//Reset these to normal
			melee_damage_type = WHITE_DAMAGE
			melee_damage_lower = 60
			melee_damage_upper = 70
			rapid_melee = 2
			combo+=1
			attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
			switch(combo)
				if(1)
					say("Penitence")
					melee_damage_lower = 60
					melee_damage_upper = 70
					melee_damage_type = WHITE_DAMAGE
				if(2)
					say("Red Eyes")
					melee_damage_lower = 60
					melee_damage_upper = 70
					melee_damage_type = RED_DAMAGE
				if(3)
					say("Get blown to pieces")
					combo = 0
					return DualAttack()
		if(2)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/red_armor = H.getarmor(null, RED_DAMAGE)
				var/white_armor = H.getarmor(null, WHITE_DAMAGE)
				if(red_armor == white_armor)//random
					attack_mode = pick(1,2)
				if(red_armor < white_armor)//mimicry
					attack_mode = 1
				if(red_armor > white_armor)//da capo
					attack_mode = 2
			else
				attack_mode = pick(1,2)
			if(attack_mode == 1)
				say("Nothing will remain", "I’ll mow you down")
				return Mimicry()
			if(attack_mode == 2)
				say("From the Overture", "Adagio e Tranquillo")
				return Da_Capo()
		if(3)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/black_armor = H.getarmor(null, BLACK_DAMAGE)
				var/pale_armor = H.getarmor(null, PALE_DAMAGE)
				if(black_armor == pale_armor)//random
					attack_mode = pick(1,2)
				if(black_armor < pale_armor)//smile
					attack_mode = 1
				if(black_armor > pale_armor)//justitia
					attack_mode = 2
			else
				attack_mode = pick(1,2)
			if(attack_mode == 1)
				say("Be eaten")
				return Smile_Slam()
			if(attack_mode == 2)
				say("Justitia, Judgment")
				return Justita_Slash()
	. = ..()

/mob/living/simple_animal/hostile/megafauna/red_mist/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= 2500)
		can_counter = TRUE//This var exists so that red mist couldn't just counter while attacking.

/* Death and "Death" */

/mob/living/simple_animal/hostile/megafauna/red_mist/death()
	if(health > 0)
		return
	if(StageChange())
		return
	animate(src, alpha = 0, time = 20)
	QDEL_IN(src, 20)
	return ..()

/mob/living/simple_animal/hostile/megafauna/red_mist/gib()
	if(life_stage < 4)
		if(health < maxHealth * 0.2)
			return StageChange()
		return
	return ..()

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/StageChange()
	if(life_stage >= 4)
		return FALSE // Death
	life_stage += 1
	light_range += 2
	light_power += 2
	can_counter = FALSE
	adjustHealth(-maxHealth)
	damage_taken = 0
	for(var/turf/T in orange(1, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	switch(life_stage)
		if(2)
			default_icon = "red_mist_phase_2"
			icon_state = default_icon
			var/list/blurb_list = list(
				"Some things simply couldn’t be forgotten, no matter how much time has passed.",
				"Hatred is a poison that eviscerates me, and yet it makes me open my eyes once more."
				)
			for(var/i = 1 to length(blurb_list))
				var/blurb_text = blurb_list[i]
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2"), (i - 1) * 11 SECONDS)
			ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1))
		if(3)
			var/list/blurb_list = list(
				"Some things just wouldn’t cool down, no matter how long they were left in the cold.",
				"Those monsters always kill people, there is no end to this sin; I have descended to bring about their reckoning."
				)
			for(var/i = 1 to length(blurb_list))
				var/blurb_text = blurb_list[i]
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2"), (i - 1) * 11 SECONDS)
			ChangeResistances(list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.3))
		if(4)
			var/list/blurb_list = list(
				"",
				""
				)
			for(var/i = 1 to length(blurb_list))
				var/blurb_text = blurb_list[i]
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2"), (i - 1) * 11 SECONDS)
			ChangeResistances(list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1.5))
	return TRUE


/datum/relative_coordinates
	var/x
	var/y
	var/atom/movable/center

/datum/relative_coordinates/New(x, y, center)
	src.x = x
	src.y = y
	src.center = center
	return ..()

/proc/GetRelativeCoordinateTurf(datum/relative_coordinates/RC)
	return locate(RC.center.x + RC.x, RC.center.y + RC.y, RC.center.z)

/datum/reusable_visual_pool/proc/NewGoldRushPortal(turf/location, duration = 0, alpha = 255)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	SET_RV_RETURN_TIMER(RV, duration)
	RV.name = "magic sygil"
	RV.desc = "A magic circle of power."
	RV.icon = 'icons/effects/64x64.dmi'
	RV.icon_state = "kog"
	RV.pixel_x = -16
	RV.base_pixel_x = -16
	RV.pixel_y = -16
	RV.base_pixel_y = -16
	RV.loc = location
	RV.alpha = alpha
	RV.layer = BYOND_LIGHTING_LAYER
	return RV

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/GetLastOpenTurfInDir(turf/start, dir)
	var/turf/T = start
	. = T
	do
		for(var/obj/machinery/door/D in T)
			if(D.density)
				return
		. = T
		T = get_open_turf_in_dir(T, dir)
	while(T)

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/GoldRush()
	can_act = FALSE
	can_counter = FALSE
	damage_taken = 0
	var/blurb_text = "The Road of Gold opens."
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2")
	var/list/warp_points = GLOB.xeno_spawn + GLOB.department_centers
	var/list/all_paths[gold_rush_charges + 2]
	var/list/portals = list()
	var/turf/T0 = GetLastOpenTurfInDir(get_turf(src), pick(NORTH, SOUTH, EAST, WEST))
	face_atom(T0)
	//icon_state = "red_mist_phase_1_goldrush"
	all_paths[1] = getline(src, T0)
	var/obj/effect/reusable_visual/P0 = RVP.NewGoldRushPortal(T0, 0, 0)
	P0.transform = turn(matrix().Scale(1.5, 0.75), Get_Angle(P0, src))
	portals += null
	portals += P0
	animate(P0, alpha = 200, time = 3 SECONDS)
	INVOKE_ASYNC(src, PROC_REF(GoldRushTelegraph), all_paths[1])
	for(var/i in 1 to gold_rush_charges)
		var/turf/picked_turf = pick_n_take(warp_points)
		var/turf/T1 = GetLastOpenTurfInDir(picked_turf, NORTH)
		var/turf/T2 = GetLastOpenTurfInDir(picked_turf, SOUTH)
		var/turf/T3 = GetLastOpenTurfInDir(picked_turf, EAST)
		var/turf/T4 = GetLastOpenTurfInDir(picked_turf, WEST)
		var/turf/portal1 = T1
		var/turf/portal2 = T2
		if(T1.y - T2.y < T3.x - T4.x)
			portal1 = T3
			portal2 = T4
		var/obj/effect/reusable_visual/P1 = RVP.NewGoldRushPortal(portal1, 0, 0)
		var/obj/effect/reusable_visual/P2 = RVP.NewGoldRushPortal(portal2, 0, 0)
		P1.transform = turn(matrix().Scale(1.5, 0.75), Get_Angle(P1, portal2))
		P2.transform = turn(matrix().Scale(1.5, 0.75), Get_Angle(P2, portal1))
		animate(P1, alpha = 200, time = 3 SECONDS)
		animate(P2, alpha = 200, time = 3 SECONDS)
		var/list/path_turfs = list()
		if(prob(50))
			path_turfs = getline(portal1, portal2)
			portals += P1
			portals += P2
		else
			path_turfs = getline(portal2, portal1)
			portals += P2
			portals += P1
		INVOKE_ASYNC(src, PROC_REF(GoldRushTelegraph), path_turfs)
		all_paths[i + 1] = path_turfs
		for(var/turf/TT in path_turfs)
			warp_points -= TT
		sleep(5)
	var/turf/end_department = pick(GLOB.department_centers)
	T0 = GetLastOpenTurfInDir(end_department, pick(NORTH, SOUTH, EAST, WEST))
	all_paths[all_paths.len] = getline(T0, end_department)
	var/obj/effect/reusable_visual/P_end = RVP.NewGoldRushPortal(T0, 0, 0)
	P_end.transform = turn(matrix().Scale(3, 1), Get_Angle(P_end, end_department))
	portals += P_end
	portals += null
	animate(P_end, alpha = 200, time = 3 SECONDS)
	INVOKE_ASYNC(src, PROC_REF(GoldRushTelegraph), all_paths[all_paths.len])
	addtimer(CALLBACK(src, PROC_REF(GoldRushCharge), all_paths, portals), 7 SECONDS)

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/GoldRushTelegraph(list/path)
	for(var/turf/T in path)
		new /obj/effect/temp_visual/cult/sparks(T)
		sleep(0.5)

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/GoldRushCharge(list/paths, list/portals)
	for(var/list/L in paths)
		RVP.ReturnToPool(popleft(portals))
		for(var/turf/T in L)
			face_atom(T)
			for(var/turf/U in range(1, T))
				if(!locate(/obj/effect/temp_visual/smash_effect) in U)
					var/obj/effect/temp_visual/smash_effect/S = new(U)
					S.color = COLOR_RED
				var/list/new_hits = HurtInTurf(U, been_hit, 0, RED_DAMAGE, hurt_mechs = TRUE) - been_hit
				been_hit += new_hits
				for(var/mob/living/LL in new_hits)
					LL.visible_message(span_boldwarning("[src] punts [LL]!"), span_userdanger("[src] pushes you out of the way with great force!"))
					new /obj/effect/temp_visual/kinetic_blast(get_turf(LL))
					if(ishuman(LL))
						var/mob/living/carbon/human/H = LL
						H.apply_damage(gold_rush_dash_damage, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
					else
						LL.adjustRedLoss(80)
					if(LL.stat >= HARD_CRIT)
						LL.gib()
					playsound(LL, 'sound/weapons/fixer/generic/gen2.ogg', 20, 1)
					playsound(LL, 'sound/abnormalities/kog/GreedHit2.ogg', 50, 1)
			for(var/obj/machinery/door/D in T)
				if(D.CanAStarPass(null))
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open), 2)
			forceMove(T)
			playsound(src,'sound/effects/bamf.ogg', 70, TRUE, 20)
			SLEEP_CHECK_DEATH(0.8)
		been_hit.Cut()
		RVP.ReturnToPool(popleft(portals))
	for(var/turf/U in range(6, src))
		var/obj/effect/temp_visual/smash_effect/S = new(U)
		S.color = COLOR_RED
		HurtInTurf(U, list(), gold_rush_damage, RED_DAMAGE, hurt_mechs = TRUE)
	sleep(5 SECONDS)
	icon_state = default_icon
	can_act = TRUE

//generates a slash simular to the claws attack but all at once
/mob/living/simple_animal/hostile/megafauna/red_mist/proc/Make_Slash(turf/start, turf/target_turf, distance, max_angle, iteration)
	var/list/area = list()
	var/angle_to_target = Get_Angle(start, target_turf)
	var/angle = angle_to_target + max_angle
	if(angle > 360)
		angle -= 360
	else if(angle < 0)
		angle += 360
	var/turf/T2 = get_turf_in_angle(angle, start, distance)
	area += getline(start, T2)
	for(var/i = 1 to iteration)
		angle -= (max_angle * 2) / iteration
		if(angle > 360)
			angle -= 360
		else if(angle < 0)
			angle += 360
		T2 = get_turf_in_angle(angle, start, distance)
		area += getline(start, T2)
	return uniqueList(area)

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/DualAttack()
	var/list/area = list()
	can_act = FALSE
	var/turf/TT = get_turf(target)
	face_atom(TT)
	var/turf/T = get_turf(src)
	area = Make_Slash(T,TT,4, 120,40)
	for(var/turf/T3 in area)
		new /obj/effect/temp_visual/cult/sparks(T3)
	SLEEP_CHECK_DEATH(1 SECONDS)
	playsound(src, 'sound/weapons/fixer/generic/gen1.ogg', 75, TRUE, 5)
	for(var/turf/T4 in area)
		var/obj/effect/temp_visual/smash_effect/S = new(T4)
		S.color = COLOR_SOFT_RED
		for(var/mob/living/L in T4)
			if(L.stat == DEAD)
				continue
			if(L.status_flags & GODMODE)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(120, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			L.apply_damage(120, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
			if(L.health <= 0)
				L.gib()
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.gib()
	can_act = TRUE

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/Heaven(target)
	if(!can_act)
		return
	var/turf/target_loc = get_turf(target)
	var/turf/start_loc = get_turf(src)
	heaven_cooldown = heaven_cooldown_time + world.time
	var/obj/projectile/heaven/H = new(start_loc)
	playsound(src, 'sound/abnormalities/pagoda/throw.ogg', 100, TRUE)
	H.starting = start_loc
	H.firer = src
	H.fired_from = src
	H.yo = target_loc.y - start_loc.y
	H.xo = target_loc.x - start_loc.x
	H.original = target
	H.preparePixelProjectile(target_loc, src)
	H.fire()
	say("The Burrowing Heaven")
/mob/living/simple_animal/hostile/megafauna/red_mist/proc/Mimicry()
	var/list/area = list()
	can_act = FALSE
	var/turf/TT = get_turf(target)
	face_atom(TT)
	var/turf/T = get_turf(src)
	area = Make_Slash(T,TT,6, 120,80)
	for(var/turf/T3 in area)
		new /obj/effect/temp_visual/cult/sparks(T3)
	SLEEP_CHECK_DEATH(1.2 SECONDS)
	playsound(src, 'sound/abnormalities/nothingthere/attack.ogg', 75, TRUE, 5)
	for(var/turf/T4 in area)
		new /obj/effect/temp_visual/nt_goodbye/(T4)
		for(var/mob/living/L in T4)
			if(L.stat == DEAD)
				continue
			if(L.status_flags & GODMODE)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(mimicry_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			if(L.health <= 0)
				L.gib()
	can_act = TRUE

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/Da_Capo()
	var/list/area = list()
	can_act = FALSE
	var/turf/TT = get_turf(target)
	face_atom(TT)
	var/turf/T = get_turf(src)
	area = Make_Slash(T,TT,6, 120,80)
	for(var/turf/T3 in area)
		new /obj/effect/temp_visual/cult/sparks(T3)
	SLEEP_CHECK_DEATH(1.2 SECONDS)
	playsound(src, 'sound/weapons/ego/da_capo1.ogg', 75, TRUE, 5)
	Da_Capo_Slash(area,da_capo_damage)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	playsound(src, 'sound/weapons/ego/da_capo2.ogg', 75, TRUE, 5)
	Da_Capo_Slash(area,da_capo_damage)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	playsound(src, 'sound/weapons/ego/da_capo3.ogg', 75, TRUE, 5)
	Da_Capo_Slash(area,da_capo_max_damage)
	can_act = TRUE

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/Da_Capo_Slash(list/turf_list, damage)
	for(var/turf/T in turf_list)
		new /obj/effect/temp_visual/smash_effect/(T)
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.status_flags & GODMODE)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					H.gib()

/obj/projectile/heaven
	name = "heaven"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "heaven_projectile"
	damage = 200
	speed = 0.3
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	hit_nondense_targets = TRUE

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/DaCapoThrow()
	var/list/potential_centers = list()
	var/list/turf_line = list()
	can_act = FALSE
	damage_taken = 0
	can_counter = FALSE
	for(var/pos_targ in GLOB.department_centers)
		var/possible_center_distance = get_dist(src, pos_targ)
		if(possible_center_distance > 4 && possible_center_distance < 46)
			potential_centers += pos_targ
	if(LAZYLEN(potential_centers))
		turf_target = pick(potential_centers)
		turf_line = getline(src,turf_target)
		var/blurb_text = "Legato"
		for(var/turf/T in turf_line)
			new /obj/effect/temp_visual/cult/sparks(T)
		SLEEP_CHECK_DEATH(1 SECONDS)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 2 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2")
		scythe = new/obj/effect/da_capo(get_turf(src),faction)
		scythe.turf_list = turf_line
		scythe.ScytheMove()
		scythe.been_hit += src
	SLEEP_CHECK_DEATH(2 SECONDS)
	MoveToMimicry()

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/MoveToMimicry()
	AIStatus = AI_OFF
	can_act = TRUE
	target = null
	walk_to(src, 0)
	mimicry_rush = TRUE
	color = COLOR_RED
	move_to_delay = 0.7
	var/blurb_text = "Let’s do this, partner"
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 2 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2")
	if(turf_target)
		patrol_to(turf_target)


/mob/living/simple_animal/hostile/megafauna/red_mist/proc/MimicryStop()
	mimicry_rush = FALSE
	color = COLOR_WHITE
	AIStatus = AI_ON
	move_to_delay = 2.75
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 7)
	var/blurb_text = "Only bloody mist remains"
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 2 SECONDS, blurb_text, 1 SECONDS, "black", "red", "left", "CENTER-6,BOTTOM+2")
	for(var/turf/T in view(8,src))
		new /obj/effect/temp_visual/nt_goodbye/(T)
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.status_flags & GODMODE)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(mimicry_rush_damage_full, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			if(L.health <= 0)
				L.gib()

/obj/effect/da_capo
	name = "Da Capo"
	desc = "A large musical sycthe"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "red_mist_da_capo"
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/list/faction = list("red mist")
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	var/list/turf_list = list()
	var/slash_damage = 300
	var/list/been_hit = list()

/obj/effect/da_capo/New(loc, ...)
	. = ..()
	if(args[2])
		faction = args[2]

/obj/effect/da_capo/proc/ScytheMove()
	icon_state = "red_mist_da_capo_moving"
	for(var/turf/T in turf_list)
		if(!istype(T))
			icon_state = initial(icon_state)
			break
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		forceMove(T)
		playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
		for(var/mob/living/L in view(1, src))
			if(faction_check(L.faction, src.faction))
				continue
			if(!L in been_hit)
				L.apply_damage(slash_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				been_hit += L
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.sanity_lost)
						H.gib()
			new /obj/effect/temp_visual/cleave(L.loc)
		if(T != turf_list[turf_list.len]) // Not the last turf
			sleep(0.5)
	icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/Smile_Slam()
	can_act = FALSE
	for(var/turf/T in view(smile_rapid_range, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(get_turf(src), 'sound/weapons/ego/hammer.ogg', 100, 20)
	for(var/turf/T2 in view(smile_rapid_range, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T2)
	for(var/mob/living/carbon/human/H in livinginview(smile_rapid_range, src))
		H.add_movespeed_modifier(/datum/movespeed_modifier/red_misted)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/red_misted), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	SLEEP_CHECK_DEATH(1 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 100, 20)
	for(var/turf/T3 in view(smile_rapid_range, src))
		var/obj/effect/temp_visual/smash_effect/S = new(T3)
		S.color = COLOR_VIOLET
	for(var/mob/living/L in livinginview(smile_rapid_range, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage(smile_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	for(var/i = 1 to 5)
		for(var/mob/living/L in livinginview(smile_rapid_range, src))
			if(faction_check_mob(L))
				continue
			new /obj/effect/temp_visual/revenant(get_turf(L))
			L.apply_damage(smile_rapid_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		SLEEP_CHECK_DEATH(6.25)
	SLEEP_CHECK_DEATH(4 SECONDS)
	can_act = TRUE

/datum/movespeed_modifier/red_misted
	variable = TRUE
	multiplicative_slowdown = 2

/mob/living/simple_animal/hostile/megafauna/red_mist/proc/Justita_Slash()
	can_act = FALSE
	been_hit = list()
	for(var/turf/T in view(justitia_aoe_range, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	var/turf/turf_dir = get_step(get_turf(src), dir_to_target)
	var/turf/end_turf = get_ranged_target_turf_direct(src, turf_dir, justitia_range, 0)
	var/list/turf_line = getline(src,end_turf)
	for(var/turf/T in turf_line)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(1.2 SECONDS)
	playsound(get_turf(src), 'sound/weapons/ego/justitia1.ogg', 100, 20)
	playsound(get_turf(src), 'sound/weapons/ego/justitia4.ogg', 100, 20)
	for(var/turf/T2 in view(justitia_aoe_range, src))
		if(!locate(/obj/effect/temp_visual/smash_effect) in T2)
			var/obj/effect/temp_visual/smash_effect/S = new(T2)
			S.color = COLOR_CYAN
		var/list/new_hits = HurtInTurf(T2, been_hit, justitia_aoe_damage, PALE_DAMAGE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/LL in new_hits)
			new /obj/effect/temp_visual/kinetic_blast(get_turf(LL))
			if(LL.stat >= HARD_CRIT)
				LL.gib()
	var/obj/effect/justitia_slash/JS = new(get_turf(src),faction)
	JS.turf_list = turf_line
	JS.been_hit = src.been_hit
	JS.JustitiaMove()
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	can_act = TRUE


/obj/effect/justitia_slash
	alpha = 255
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/list/faction = list("red mist")
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	var/list/turf_list = list()
	var/slash_damage = 95
	var/list/been_hit = list()

/obj/effect/justitia_slash/New(loc, ...)
	. = ..()
	if(args[2])
		faction = args[2]

/obj/effect/justitia_slash/proc/JustitiaMove()
	for(var/turf/T in turf_list)
		if(!istype(T))
			break
		if(T.density)
			break
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		forceMove(T)
		playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
		for(var/turf/T2 in view(1,src))
			var/obj/effect/temp_visual/smash_effect/S = new(T2)
			S.color = COLOR_CYAN
			for(var/mob/living/L in T2)
				if(faction_check(L.faction, src.faction))
					continue
				if(!L in been_hit)
					L.apply_damage(slash_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
					been_hit += L
					if(L.stat >= HARD_CRIT)
						L.gib()
				new /obj/effect/temp_visual/cleave(L.loc)
		if(T != turf_list[turf_list.len]) // Not the last turf
			sleep(0.25)
	qdel(src)
