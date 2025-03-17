//The most dangerous base risk level. Can clown even on a color fixer honestly.
/mob/living/simple_animal/hostile/distortion/Oswald
	name = "8 o'Clock Ringmaster"
	desc = "A strange clown with multiple arms."
	health = 12000
	maxHealth = 12000
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.3)
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	icon_state = "Oswald"
	icon_living = "Oswald"
	icon_dead = "crimson_midnight"
	icon = 'ModularTegustation/Teguicons/Ensemble64x64.dmi'
	faction = list("hostile", "crimsonOrdeal", "bongy")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_color = COLOR_LIGHT_GRAYISH_RED
	light_range = 3
	density = TRUE
	movement_type = GROUND
	speak_emote = list("says")
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 20 // Intended to be superboss due to nature of its accessibility.
	melee_damage_upper = 30
	stat_attack = HARD_CRIT
	rapid_melee = 8
	ranged = TRUE
	ranged_cooldown_time = 300
	speed = 2
	move_to_delay = 2
	pixel_x = -8
	base_pixel_x = -8
	blood_volume = BLOOD_VOLUME_NORMAL
	del_on_death = FALSE
	death_message = "falls to the ground, decaying into glowing particles."
	death_sound = 'sound/effects/ordeals/crimson/midnight_dead.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/clown_throw
	projectilesound = 'sound/abnormalities/clownsmiling/throw.ogg'
	minimum_distance = 2
	retreat_distance = 1
	can_patrol = TRUE
//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/city/ensemble
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Oswald")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/clothing/suit/armor/ego_gear/city/ensembleweak)
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Black swan is the most strongly related to this guy, but I might make one for it later.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/clown //Clown
	egoist_attributes = 130
	can_spawn = 0
	var/unmanifesting

	var/charging = FALSE
	var/finishing = FALSE
	var/step = FALSE
	var/spawn_time
	var/spawn_time_cooldown = 28.5 SECONDS
	var/list/spawned_mobs = list()
	var/gun_cooldown
	var/gun_cooldown_time = 300 SECONDS
	var/gun_damage = 10000 //Do not get hit by his charm attack.
	var/Mermaid_spawn_number = 1
	var/Mermaid_spawn_time = 20 SECONDS
	var/Mermaid_spawn_limit = 4 // AAAAAAAAAAAAAAAAA
	//You are so cool, Kirie.
	var/Mrknife_spawn_number = 2
	var/Mrknife_spawn_time = 20 SECONDS
	var/Mrknife_spawn_limit = 4 // You get knives, everyone gets knives
	var/can_act = TRUE
	var/slash_width = 3
	var/slash_length = 5
	var/datum/looping_sound/clown_ambience/circustime

	//Circus leader code attempt
/mob/living/simple_animal/hostile/distortion/Oswald/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/MrKnife = 6,
		/mob/living/simple_animal/hostile/Mermaid = 2,
		/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_midnight = 2
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE, TRUE)



//confetti attack attempt
/mob/living/simple_animal/hostile/distortion/Oswald/face_atom() //VERY important; prevents spinning while slashing
	if(!can_act)
		return
	..()

/mob/living/simple_animal/hostile/distortion/Oswald/Move()
	if(!can_act)
		return FALSE
	return ..()


/mob/living/simple_animal/hostile/distortion/Oswald/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	return Slash(attacked_target)

/mob/living/simple_animal/hostile/distortion/Oswald/proc/Slash(target)
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, EAST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, WEST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, SOUTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, NORTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
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
	playsound(get_turf(src), 'sound/abnormalities/clownsmiling/throw.ogg', 75, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(0.8 SECONDS)
	var/slash_damage = 125
	playsound(get_turf(src), 'sound/distortions/Confettiburst.ogg', 100, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if (L == src)
				continue
			HurtInTurf(T, list(), slash_damage, WHITE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE


/mob/living/simple_animal/hostile/distortion/Oswald/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/Oswald/AttackingTarget(atom/attacked_target)
	. = ..()
	if(.)
		if(!ishuman(attacked_target))
			return
		var/mob/living/carbon/human/TH = attacked_target
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
					H.deal_damage(5, WHITE_DAMAGE)
				SLEEP_CHECK_DEATH(2)
			if(!targets_from.Adjacent(TH) || QDELETED(TH))
				finishing = FALSE
				return
			playsound(get_turf(src), 'sound/abnormalities/clownsmiling/final_stab.ogg', 50, 1)
			TH.gib()
			for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
				H.deal_damage(150, WHITE_DAMAGE)


//Charm attack attempt goes here.
/mob/living/simple_animal/hostile/distortion/Oswald/Move()
	if(buffed && !charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/Oswald/MeleeAction()
	if(ranged_cooldown <= world.time && prob(30))
		OpenFire()
		return
	return ..()

/mob/living/simple_animal/hostile/distortion/Oswald/CanAllowThrough(atom/movable/mover, turf/target)
	if(charging && isliving(mover))
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/distortion/Oswald/Shoot(atom/A)
	if(buffed || !isliving(A))
		return FALSE
	animate(src, alpha = alpha - 50, pixel_y = base_pixel_y + 25, layer = 6, time = 10)
	buffed = TRUE
	density = FALSE
	if(do_after(src, 2 SECONDS, target = src))
		ArialSupport()
	else
		visible_message(span_notice("[src] crashes to the ground."))
		apply_damage(100, WHITE_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	//return to the ground
	density = TRUE
	layer = initial(layer)
	buffed = FALSE
	alpha = initial(alpha)
	pixel_y = initial(pixel_y)
	base_pixel_y = initial(base_pixel_y)

/mob/living/simple_animal/hostile/distortion/Oswald/proc/ArialSupport()
	charging = TRUE
	var/turf/target_turf = get_turf(target)
	for(var/i=0 to 7)
		var/turf/wallcheck = get_step(src, get_dir(src, target_turf))
		if(!ClearSky(wallcheck))
			break
		var/mob/living/sweeptarget = locate(target) in wallcheck
		if(sweeptarget)
			SweepAttack(sweeptarget)
			break
		forceMove(wallcheck)
		SLEEP_CHECK_DEATH(0.5)
	charging = FALSE

/mob/living/simple_animal/hostile/distortion/Oswald/proc/SweepAttack(mob/living/sweeptarget)
	sweeptarget.visible_message(span_danger("[src] needs [sweeptarget] you know~!"), span_userdanger("[src] needs you, you know~"))
	sweeptarget.apply_damage(2000, WHITE_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	BongyPanic(sweeptarget)
	playsound(get_turf(src), 'sound/effects/ordeals/crimson_end.ogg', 50, TRUE)
	if(sweeptarget.mob_size <= MOB_SIZE_HUMAN)
		DoKnockback(sweeptarget, src, get_dir(src, sweeptarget))
		shake_camera(sweeptarget, 4, 3)
		shake_camera(src, 2, 3)

/mob/living/simple_animal/hostile/distortion/Oswald/proc/DoKnockback(atom/target, mob/thrower, throw_dir) //stolen from the knockback component since this happens only once
	if(!ismovable(target) || throw_dir == null)
		return
	var/atom/movable/throwee = target
	if(throwee.anchored)
		return
	if(QDELETED(throwee))
		return
	var/atom/throw_target = get_edge_target_turf(throwee, throw_dir)
	throwee.safe_throw_at(throw_target, 1, 1, thrower, gentle = TRUE)

/mob/living/simple_animal/hostile/distortion/Oswald/AttackingTarget(atom/attacked_target)
	if(!attacked_target)
		return FALSE
	var/mob/living/carbon/human/H = attacked_target
	..()
	if(ishuman(H) && H.sanity_lost)
		BongyPanic(H)

/mob/living/simple_animal/hostile/distortion/Oswald/proc/BongyPanic(target)
	var/mob/living/carbon/human/H = target
	if(!HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/murder/bongy))
		var/obj/item/clothing/mask/gas/mime/M = new(get_turf(H))
		H.equip_to_slot_if_possible(M, ITEM_SLOT_MASK, FALSE, TRUE, TRUE)
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/murder/bongy
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/bongy)
		LoseTarget()
		return TRUE
	return FALSE

//Spawning the circus to town
/mob/living/simple_animal/hostile/distortion/Oswald/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	update_icon()
	if(length(spawned_mobs) >= 8)
		return
	if((spawn_time > world.time))
		return
	spawn_time = world.time + spawn_time_cooldown
	visible_message(span_danger("\The [src] Calls forth the circus!"))
	playsound(get_turf(src), 'sound/abnormalities/clownsmiling/final_stab.ogg', 75, FALSE)
	playsound(get_turf(src), 'sound/abnormalities/clownsmiling/clownloop.ogg', 75, FALSE)
	var/spawnchance = pick(1,2)
	for(var/i = 1 to spawnchance)
		var/turf/T = get_step(get_turf(src), pick(0, EAST))
		var/picked_mob = pick(/mob/living/simple_animal/hostile/Mermaid, /mob/living/simple_animal/hostile/MrKnife, /mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_midnight, /mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk/spawned)
		var/mob/living/simple_animal/hostile/ordeal/nb = new picked_mob(T)
		spawned_mobs += nb

/mob/living/simple_animal/hostile/MrKnife
	name = "Mr Knife"
	desc = "A weird bladed clown with knives that seem to never run out."
	icon = 'ModularTegustation/Teguicons/Ensemble64x64.dmi'
	icon_state = "MrKnife"
	icon_living = "MrKnife"
	is_flying_animal = FALSE
	density = TRUE
	a_intent = INTENT_HARM
	health = 1200
	maxHealth = 1200
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	melee_damage_lower = 12
	melee_damage_upper = 15
	pixel_x = -10
	faction = list("hostile", "crimsonOrdeal", "bongy")
	rapid_melee = 6
	melee_damage_type = RED_DAMAGE
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	projectiletype = /obj/projectile/clown_throw
	projectilesound = 'sound/abnormalities/clownsmiling/throw.ogg'

#define FRAGMENT_SONG_COOLDOWN (14 SECONDS)

/mob/living/simple_animal/hostile/Mermaid
	name = "Ms Mermaid"
	desc = "It looks disgusting, and also like a fish."
	icon = 'ModularTegustation/Teguicons/Ensemble64x64.dmi'
	icon_state = "Mermaid"
	icon_living = "Mermaid"
	is_flying_animal = FALSE
	density = TRUE
	a_intent = INTENT_HARM
	health = 1600
	maxHealth = 1600
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1)
	melee_damage_lower = 12
	melee_damage_upper = 15
	pixel_x = -15
	melee_damage_type = RED_DAMAGE
	obj_damage = 20
	speed = 5
	move_to_delay = 3
	faction = list("hostile", "crimsonOrdeal", "bongy")
	var/screech_cooldown = 0
	var/screech_windup = 5 SECONDS
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "slices"
	attack_verb_simple = "slices"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	var/pulse_cooldown
	var/pulse_cooldown_time = 1.8 SECONDS
	var/pulse_damage = 5

/mob/living/simple_animal/hostile/Mermaid/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown > world.time))
		return
	pulse_cooldown = world.time + pulse_cooldown_time
	WhitePulse()


/mob/living/simple_animal/hostile/Mermaid/proc/WhitePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/distortions/Mermaidsinging.ogg', 50, FALSE, 4)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, WHITE_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
