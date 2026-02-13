/mob/living/simple_animal/hostile/abnormality/ardor_moth
	name = "Ardor Blossom Moth"
	desc = "A moth seemingly made of fire."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	pixel_x = -8
	base_pixel_x = -8
	icon_state = "blossom_moth"
	icon_living = "blossom_moth"
	portrait = "blossom_moth"
	icon_dead = "moth_egg"
	core_icon = "moth_egg"
	del_on_death = FALSE
	maxHealth = 800
	health = 800
	blood_volume = 0
	attack_verb_continuous = "sears"
	attack_verb_simple = "sear"
	is_flying_animal = TRUE
	stat_attack = HARD_CRIT
	melee_damage_lower = 4
	melee_damage_upper = 6
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5, FIRE = 0.1)
	speak_emote = list("flutters")
	vision_range = 14
	aggro_vision_range = 20
	melee_damage_lower = 7
	melee_damage_upper = 15
	melee_damage_type = FIRE
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 35, 40, 40, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 20, 25, 30),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(10, 20, 40, 45, 50),
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	patrol_cooldown_time = 3 SECONDS

	ego_list = list(
		/datum/ego_datum/weapon/ardor_star,
		/datum/ego_datum/armor/ardor_star,
	)
	gift_type =  /datum/ego_gifts/ardor_moth
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "Orange circles float in the air before your eyes. <br>\
		The lights flutter and dance in the air, creating a haze. <br>\
		Something is burning to death within. <br>\
		Would you be scorched as well if the flames touched you?"
	observation_choices = list(
		"Reach out" = list(TRUE, "Enchanted by the haze, you extend a finger, <br>\
			waiting for one of the lights to land. <br>\
			A glimmering ball gently perches on your digit. <br>\
			Then, a fire engulfs it. <br>\
			Another glow attaches to your body, then four, then eight. <br>\
			They multiply until you have been entirely shrouded in light."),
		"Turn around" = list(FALSE, "Resisting the temptation to reach out, <br>\
			you decide itÅfs better to stay away from such dubious warmth. <br>\
			You feel a cold wave crawl up your spine in an instant, but it may be the right choice. <br>\
			Even children know not to play with fire."),
	)

	light_color = COLOR_ORANGE
	light_range = 3
	light_power = 4
	light_on = TRUE

	ranged = TRUE
	projectiletype = /obj/projectile/moth_fire
	projectilesound = 'sound/abnormalities/ardor_moth/ardor_projectile.ogg'
	ranged_cooldown_time = 2 SECONDS

	var/ember_respawn_timer = null
	var/ember_respawn_time = 5 MINUTES
	var/list/embers = list()

	var/can_act = TRUE
	var/attacking = FALSE
	var/charging = FALSE
	var/explode_charge_cooldown
	var/explode_charge_cooldown_time = 20 SECONDS
	var/explode_charge_explosion_damage = 20
	var/melee_cooldown
	var/melee_cooldown_time = 6 SECONDS
	var/melee_width = 2
	var/melee_length = 2

//Work Related Stuff
/mob/living/simple_animal/hostile/abnormality/ardor_moth/PostSpawn()
	. = ..()
	ember_respawn_timer = addtimer(CALLBACK(src, PROC_REF(SpawnEmbers)), 3 MINUTES, TIMER_STOPPABLE & TIMER_OVERRIDE)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/proc/SpawnEmbers()
	if(!IsContained())
		return
	if(LAZYLEN(embers))
		RemoveEmbers()
	playsound(get_turf(src), 'sound/effects/burn.ogg', 50, 0, 5)
	var/list/turfs = list()
	var/turf/self_turf = src.loc
	var/turf/inside = locate(self_turf.x+1, self_turf.y, self_turf.z)
	var/turf/outside = locate(self_turf.x+3, self_turf.y-4, self_turf.z)
	if(inside)//I know in limbus it mentions it only having embers outside but that looked kind of wierd.
		for(var/turf/T in range(inside, 2))
			if(!T || isclosedturf(T))
				continue
			if(locate(/obj/structure/window) in T.contents)
				continue
			if(locate(/obj/structure/table) in T.contents)
				continue
			if(locate(/obj/structure/railing) in T.contents)
				continue
			turfs += T
	if(outside)
		for(var/turf/T in range(outside, 1))
			var/dense = FALSE
			if(!T || isclosedturf(T))
				continue
			if(locate(/obj/structure/window) in T.contents)
				continue
			if(locate(/obj/structure/table) in T.contents)
				continue
			if(locate(/obj/structure/railing) in T.contents)
				continue
			for(var/obj/machinery/door/D in T.contents)
				if(D.density)
					dense = TRUE
			if(dense)
				continue
			turfs += T
	for(var/turf/T in turfs)
		var/obj/effect/embers/E = new(T)
		E.connected_abno = src
		embers += E

/mob/living/simple_animal/hostile/abnormality/ardor_moth/proc/RemoveEmbers()
	for(var/obj/effect/embers/E in embers)
		qdel(E)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(70))//Removes the embers for some time
		datum_reference.qliphoth_change(1)
		if(!LAZYLEN(embers))
			return
		RemoveEmbers()
		if(ember_respawn_timer)
			deltimer(ember_respawn_timer)
		ember_respawn_timer = addtimer(CALLBACK(src, PROC_REF(SpawnEmbers)), ember_respawn_time, TIMER_STOPPABLE & TIMER_OVERRIDE)


/mob/living/simple_animal/hostile/abnormality/ardor_moth/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20))
		datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/BreachEffect(mob/living/carbon/human/user)
	. = ..()
	RemoveEmbers()
	if(ember_respawn_timer)
		deltimer(ember_respawn_timer)

//Breach Stuff
/mob/living/simple_animal/hostile/abnormality/ardor_moth/death(gibbed)
	playsound(src, 'sound/effects/limbus_death.ogg', 100, 1)
	light_on = FALSE
	color = COLOR_WHITE
	can_act = FALSE
	update_light()
	is_flying_animal = FALSE
	icon = 'ModularTegustation/Teguicons/abno_cores/waw.dmi'
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/ardor_moth/Life()
	. = ..()
	if(IsContained()) // Contained
		return
	if(charging || !can_act || src.stat == DEAD)
		return
	if(health/maxHealth <= 0.15)
		DeathExplosion()
	if(melee_cooldown <= world.time)
		if(retreat_distance > 1)
			retreat_distance = null
			minimum_distance = null
			if(target)
				MoveToTarget(list(target))

/mob/living/simple_animal/hostile/abnormality/ardor_moth/Move()
	if(charging || !can_act)
		return
	..()
	CreateFire(get_turf(src))

/mob/living/simple_animal/hostile/abnormality/ardor_moth/AttackingTarget(atom/attacked_target)
	if(charging || !can_act)
		return
	if(!isliving(attacked_target))
		return ..()
	if(explode_charge_cooldown <= world.time && prob(33))
		return ChargeExplode(attacked_target)
	if(melee_cooldown <= world.time)
		return FireSlash(attacked_target)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/proc/FireSlash(target)
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, EAST, melee_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, melee_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, melee_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, WEST, melee_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, melee_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, melee_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, SOUTH, melee_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, melee_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, melee_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, NORTH, melee_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, melee_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, melee_width)))
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
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/ardor_moth/ardor_prepair_attack.ogg', 50, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(0.8 SECONDS)
	do_attack_animation(get_step(src, dir))
	playsound(get_turf(src), 'sound/abnormalities/ardor_moth/ardor_attack.ogg', 50, 0, 5)
	for(var/turf/T in area_of_effect)
		CreateFire(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if (L == src)
				continue
			HurtInTurf(T, list(), rand(melee_damage_lower, melee_damage_upper), melee_damage_type, check_faction = TRUE, hurt_mechs = TRUE)
			L.apply_lc_burn(6)
			SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, L)
			L.visible_message(span_danger("\The [src] [attack_verb_continuous] [L]!"), \
					span_userdanger("\The [src] [attack_verb_continuous] you!"), null, COMBAT_MESSAGE_RANGE, src)
			to_chat(src, span_danger("You [attack_verb_simple] [L]!"))
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	retreat_distance = 5
	minimum_distance = 5
	can_act = TRUE
	melee_cooldown = melee_cooldown_time + world.time
	if(target)
		MoveToTarget(list(target))

/mob/living/simple_animal/hostile/abnormality/ardor_moth/OpenFire()
	if(charging || !can_act)
		return

	if(explode_charge_cooldown <= world.time && prob(33))
		ChargeExplode(target)
	if(retreat_distance > 1)
		return ..()

/mob/living/simple_animal/hostile/abnormality/ardor_moth/proc/CreateFire(turf/T)
	if(locate(/obj/effect/turf_fire/ardor) in T)
		for(var/obj/effect/turf_fire/ardor/floor_fire in T)
			qdel(floor_fire)
	new /obj/effect/turf_fire/ardor(T)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/proc/ChargeExplode(dash_target)
	can_act = FALSE
	if(IsContained() || charging)
		return
	var/turf/target_turf = get_turf(dash_target)
	face_atom(dash_target)
	playsound(get_turf(src), 'sound/abnormalities/ardor_moth/ardor_charge_start.ogg', 50, 0, 5)
	SLEEP_CHECK_DEATH(1 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/ardor_moth/ardor_charge.ogg', 50, 0, 5)
	charging = TRUE
	var/should_explode = FALSE
	var/turf/end_turf = get_ranged_target_turf_direct(src, target_turf, 12, 0)
	var/list/turf_list = getline(src, end_turf) - get_turf(src)
	for(var/turf/T in turf_list)
		if(!charging)
			break
		if(T.density)
			should_explode = TRUE
		if(locate(/obj/structure/window) in T.contents)
			should_explode = TRUE
		for(var/obj/machinery/door/D in T.contents)
			if(D.density)
				should_explode = TRUE
		for(var/mob/living/L in T)
			if(!faction_check_mob(L))
				should_explode = TRUE
		if(should_explode)
			break
		SLEEP_CHECK_DEATH(1)
		forceMove(T)
		for(var/turf/T2 in orange(get_turf(src), 1))
			if(isclosedturf(T2))
				continue
			CreateFire(T2)
	charging = FALSE
	if(should_explode)
		Explode()
		return
	explode_charge_cooldown = world.time + explode_charge_cooldown_time
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ardor_moth/proc/Explode()
	playsound(get_turf(src), 'sound/abnormalities/ardor_moth/ardor_explode.ogg', 50, 0, 8)
	for(var/turf/T in view(get_turf(src), 3))
		CreateFire(T)
	for(var/mob/living/carbon/human/H in view(2, src))
		H.deal_damage(explode_charge_explosion_damage, RED_DAMAGE)
		H.deal_damage(explode_charge_explosion_damage * 0.5, FIRE)
		H.apply_lc_burn(10)
		if(H.health < 0)
			H.gib()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	SLEEP_CHECK_DEATH(4 SECONDS)
	can_act = TRUE
	explode_charge_cooldown = world.time + explode_charge_cooldown_time


/mob/living/simple_animal/hostile/abnormality/ardor_moth/proc/DeathExplosion()
	color = "#FF8888"
	light_color = COLOR_RED
	visible_message(span_userdanger("[src]'s flames are burning intensely!"), \
						span_userdanger("You're ready to go out with a bang!"), null, COMBAT_MESSAGE_RANGE, null)
	playsound(get_turf(src), 'sound/abnormalities/ardor_moth/ardor_death_boom_start.ogg', 75, 0, 5)
	can_act = FALSE
	update_light()
	SLEEP_CHECK_DEATH(3 SECONDS)
	playsound(get_turf(src), 'sound/effects/burn.ogg', 100, 0, 5)
	light_power = 10
	update_light()
	color = "#FF5555"
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/ardor_moth/ardor_explode.ogg', 100, 0, 8)
	for(var/turf/T in view(get_turf(src), 7))
		CreateFire(T)
	for(var/mob/living/carbon/human/H in view(3, src))
		H.deal_damage(explode_charge_explosion_damage * 2, RED_DAMAGE)
		H.deal_damage(explode_charge_explosion_damage, FIRE)
		H.apply_lc_burn(30)
		if(H.health < 0)
			H.gib()
	var/obj/effect/temp_visual/explosion/boom = new(get_turf(src))
	boom.transform *= 2
	adjustBruteLoss(99999)

/mob/living/simple_animal/hostile/abnormality/ardor_moth/spawn_gibs()
	return new /obj/effect/decal/cleanable/ash(drop_location(), src)

/obj/effect/turf_fire/ardor
	burn_time = 30 SECONDS

/obj/effect/turf_fire/ardor/DoDamage(mob/living/fuel)
	if(ishuman(fuel))
		fuel.deal_damage(0.5, FIRE)
		fuel.apply_lc_burn(1)

/obj/effect/embers
	gender = PLURAL
	name = "embers"
	desc = "Bunch of small flames."
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "heavy_ash"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/mob/living/simple_animal/hostile/abnormality/ardor_moth/connected_abno = null

/obj/effect/embers/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		DamageCheck(AM)

/obj/effect/embers/proc/DamageCheck(mob/living/L)
	if(!isliving(L))
		return
	var/datum/status_effect/ember_touched/E = L.has_status_effect(/datum/status_effect/ember_touched)
	if(E)
		return
	var/chance = 100
	if(L.m_intent == MOVE_INTENT_WALK)
		chance = 10//Taking your time is key to not getting scorched... most of the time
	if(prob(chance))
		to_chat(L, span_userdanger("A burning ember attaches to you!"))
		L.deal_damage(min(2, L.maxHealth/20), FIRE)//Just so Clerks won't eat shit and die
		L.apply_lc_burn(1)
		if(ishuman(L) && connected_abno)
			if(!connected_abno.datum_reference.working)
				L.apply_status_effect(/datum/status_effect/ember_touched)
				connected_abno.datum_reference?.qliphoth_change(-1)

/obj/effect/embers/Destroy()
	if(connected_abno)
		if(src in connected_abno.embers)
			connected_abno.embers -= src
	. = ..()

//This handles if someone walked through moth's embers or not
/datum/status_effect/ember_touched
	id = "ember_touched"
	status_type = STATUS_EFFECT_REPLACE
	duration = 10 SECONDS
	tick_interval = 2 SECONDS

/datum/status_effect/ember_touched/tick()
	. = ..()
	if(!isliving(owner))
		return
	if(locate(/obj/effect/embers) in owner.loc)
		duration = world.time + 10 SECONDS
