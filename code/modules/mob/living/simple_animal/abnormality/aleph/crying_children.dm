// Ping Chiemi for bugs, suffering
#define TCC_SORROW_COOLDOWN (5 SECONDS)
#define TCC_COMBUST_COOLDOWN (20 SECONDS)

/mob/living/simple_animal/hostile/abnormality/crying_children
	name = "\proper The Crying Children"
	desc = "A towering angel statue, setting everything on it's path ablaze"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_living = "crying_idle"
	icon_state = "crying_idle"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -15
	base_pixel_y = -15
	is_flying_animal = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	threat_level = ALEPH_LEVEL
	health = 2000
	maxHealth = 2000
	obj_damage = 600
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 45
	melee_damage_upper = 55
	move_to_delay = 5
	ranged = TRUE
	start_qliphoth = 2
	can_breach = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 45, 50),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 0, 10, 20),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 45, 50, 55),
	)
	work_damage_amount = 14
	work_damage_type = WHITE_DAMAGE
	attack_sound = 'sound/abnormalities/crying_children/attack_salvador.ogg'
	death_sound = 'sound/abnormalities/crying_children/death.ogg'
	death_message = "crumbles into pieces."
	del_on_death = FALSE
	ego_list = list(/datum/ego_datum/weapon/shield/combust, /datum/ego_datum/armor/combust)
	gift_type =  /datum/ego_gifts/inconsolable
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK // I HAVE NO IDEA LOR ORIGIN CODE
	var/list/children_list = list()
	var/charge = 0
	var/can_charge = FALSE // Prevents charging the map wide attack
	var/maxcharge = 180
	var/desperation_cooldown
	var/desperation_cooldown_time = 1 SECONDS
	var/sorrow_cooldown
	var/sorrow_cooldown_time = 5 SECONDS
	var/courage_cooldown
	var/courage_cooldown_time = 20 SECONDS
	var/desperate = FALSE
	var/can_act = TRUE
	var/death_counter = 0
	var/burn_mod = 1
	var/icon_phase = "crying"

	// Prevents spawning in normal game modes
	can_spawn = FALSE

	attack_action_types = list(
		/datum/action/cooldown/tcc_sorrow,
		/datum/action/cooldown/tcc_combust,
	)

// Sorrow is too strong to be spammed, so you can only do it when mobs are nearby as a player
/datum/action/cooldown/tcc_sorrow
	name = "Wounds Of Sorrow"
	icon_icon = 'icons/obj/projectiles_muzzle.dmi'
	button_icon_state = "muzzle_beam_heavy"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = TCC_SORROW_COOLDOWN

/datum/action/cooldown/tcc_sorrow/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/crying_children))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/crying_children/TCC = owner
	if(!(TCC.can_act))
		return FALSE
	var/list/targets_to_hit = list()
	for(var/mob/living/L in view(8, TCC))
		if(TCC.faction_check_mob(L) || L.stat == DEAD)
			continue
		if(istype(L, /mob/living/simple_animal/bot))
			continue
		targets_to_hit += L
	for(var/obj/vehicle/V in view(8, TCC))
		if(V.occupants.len <= 0)
			continue
		targets_to_hit += V
	if(targets_to_hit.len <= 0)
		to_chat(TCC, span_warning("There are no enemies nearby!"))
		return FALSE
	StartCooldown()
	TCC.Wounds_Of_Sorrow(pick(targets_to_hit))
	return TRUE

/datum/action/cooldown/tcc_combust
	name = "Combusting Courage"
	icon_icon = 'icons/mob/actions/actions_ability.dmi'
	button_icon_state = "fire0"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = TCC_COMBUST_COOLDOWN

/datum/action/cooldown/tcc_combust/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/crying_children))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/crying_children/TCC = owner
	if(!(TCC.can_act))
		return FALSE
	if(!(TCC.desperate))
		to_chat(TCC, span_warning("You're still not ready to use this!"))
		return FALSE
	StartCooldown()
	TCC.Combusting_Courage()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/crying_children/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath)) // Alright, here we go again

// Silly multi icons, lets fix that! This is called each time it's spawned in containment, so it has normal sprite on adminbus spawn
/mob/living/simple_animal/hostile/abnormality/crying_children/PostSpawn()
	. = ..()
	desc = "A wax statue of an ...angel? It creepily floats around the containment room. You feel like you shouldn't be here for too long"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "unspeaking_child"
	icon_living = "unspeaking_child"
	pixel_x = 0
	base_pixel_x = 0
	pixel_y = 0
	base_pixel_y = 0
	return

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	death_counter += 1
	if(death_counter >= 2)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/crying_children/Life()
	. = ..()
	if(can_charge)
		Charge_Finale()

// DON'T IGNORE ME!!
/mob/living/simple_animal/hostile/abnormality/crying_children/proc/Charge_Finale()
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
/mob/living/simple_animal/hostile/abnormality/crying_children/proc/Scorching_Desperation()
	if(charge < maxcharge) // Cancels if he change phases or dies
		return
	charge = 0
	for(var/mob/living/L in GLOB.mob_living_list)
		if(faction_check_mob(L, FALSE) || L.z != z || L.stat == DEAD)
			continue
		to_chat(L, span_userdanger("You're boiling alive from the heat of a miniature sun!"))
		playsound(L, 'sound/abnormalities/crying_children/attack_aoe.ogg', 50, TRUE)
		L.apply_damage(300, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		L.apply_lc_burn(50)
		new /obj/effect/temp_visual/fire/fast(get_turf(L))

/mob/living/simple_animal/hostile/abnormality/crying_children/BreachEffect(mob/living/carbon/human/user, breach_type)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "No one’s going to cry on my behalf even if I’m sad.", 25))
	..()
	desc = "A towering angel statue, setting everything on it's path ablaze"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_living = "[icon_phase]_idle"
	icon_state = "[icon_phase]_idle"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -15
	base_pixel_y = -15
	can_charge = TRUE
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	return

/mob/living/simple_animal/hostile/abnormality/crying_children/Move()
	if(!can_act)
		return FALSE
	return ..()

// Gibbing just change phases
/mob/living/simple_animal/hostile/abnormality/crying_children/gib()
	if(!desperate)
		death()
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/crying_children/death(gibbed)
	if(!desperate && children_list.len <= 0)
		if(client)
			FinalPhase()
			return
		SpawnChildren()
		can_act = FALSE
		charge = 0
		maxcharge = 300 // 5 Minutes On Splitting Up
		var/turf/T = locate(1, 1, src.z)
		forceMove(T)
		return
	if(desperate)
		icon = 'ModularTegustation/Teguicons/32x32.dmi'
		icon_dead = "unspeaking_child"
		is_flying_animal = FALSE
		pixel_x = 0
		base_pixel_x = 0
		pixel_y = 0
		base_pixel_y = 0
		animate(src, alpha = 0, time = 10 SECONDS)
		charge = 0
		can_charge = FALSE
		QDEL_IN(src, 10 SECONDS)
		return ..()

/mob/living/simple_animal/hostile/abnormality/crying_children/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

	// If for some reason admeme deletes it
	for(var/mob/living/L in children_list)
		L.death()
	return ..()

/mob/living/simple_animal/hostile/abnormality/crying_children/OpenFire()
	if(!can_act || client)
		return
	if(sorrow_cooldown <= world.time && get_dist(src, target) > 2)
		Wounds_Of_Sorrow(target)
	if(desperate && courage_cooldown <= world.time && (target in view(2, src)) && prob(30)) // Make it less predictable
		Combusting_Courage()
	return

/mob/living/simple_animal/hostile/abnormality/crying_children/AttackingTarget()
	if(!can_act)
		return FALSE
	if(!client)
		if(desperate && (courage_cooldown <= world.time) && prob(30))
			return Combusting_Courage()
		if(sorrow_cooldown <= world.time && prob(25))
			return Wounds_Of_Sorrow(target)

	if(prob(35))
		return Bygone_Illusion(target)

	// Distorted Illusion
	can_act = FALSE
	icon_state = "[icon_phase]_salvador"
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_lc_burn(5*burn_mod)
	SLEEP_CHECK_DEATH(10)
	icon_state = "[icon_phase]_idle"
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/Bygone_Illusion(mob/living/target)
	can_act = FALSE
	var/turf/slash_start = get_turf(src)
	var/turf/slash_end = get_ranged_target_turf_direct(slash_start, target, 2)
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
	icon_state = "[icon_phase]_yuna"
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
	icon_state = "[icon_phase]_idle"
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/Wounds_Of_Sorrow(mob/living/target)
	if(sorrow_cooldown > world.time)
		return
	sorrow_cooldown = world.time + sorrow_cooldown_time
	can_act = FALSE
	icon_state = "[icon_phase]_sorrow"
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
	icon_state = "[icon_phase]_idle"
	SLEEP_CHECK_DEATH(20)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/Combusting_Courage()
	if(courage_cooldown > world.time || !desperate)
		return
	courage_cooldown = world.time + courage_cooldown_time
	can_act = FALSE
	playsound(src, 'sound/effects/ordeals/white/pale_teleport_out.ogg', 50, FALSE)
	icon_state = "[icon_phase]_sorrow"
	var/list/been_hit = list()
	for(var/turf/T in view(4, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	icon_state = "[icon_phase]_idle"
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

// Work Stuff
/mob/living/simple_animal/hostile/abnormality/crying_children/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20))
		Curse(user)
	return

/mob/living/simple_animal/hostile/abnormality/crying_children/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	Curse(user)
	return

/mob/living/simple_animal/hostile/abnormality/crying_children/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		datum_reference.qliphoth_change(1)
	return

// Decrease charge for every 20% HP lost
/mob/living/simple_animal/hostile/abnormality/crying_children/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	var/oldhealth = health
	..()
	for(var/i = 1, i < 4, i++)
		if(health < (maxHealth * 0.2 * i) && oldhealth >= (maxHealth * 0.2 * i))
			charge -= 10

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/Curse(mob/living/carbon/human/user)
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

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/RemoveCurse(mob/living/carbon/human/user, type)
	REMOVE_TRAIT(user, type, GENETIC_MUTATION)
	user.update_blindness()
	user.update_sight()

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/SpawnChildren()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "Seeing, hearing, and speaking evil are all deeds that I can consciously prevent myself from doing.", 25))
	sound_to_playing_players_on_level('sound/abnormalities/crying_children/seperate.ogg', 50, zlevel = z)
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		if(get_dist(src, T) < 7)
			continue
		teleport_potential += T
	for(var/turf/T in GLOB.xeno_spawn)
		if(get_dist(src, T) < 7)
			continue
		teleport_potential += T
	var/teleport_target = pick(teleport_potential)

	//I tried using subtype loop for this, but it ends a bit buggy
	var/mob/living/simple_animal/hostile/child/unseeing/SE = new(teleport_target)
	RegisterSignal(SE, COMSIG_LIVING_DEATH, PROC_REF(DeadChild), SE)
	teleport_potential -= teleport_target
	teleport_target = pick(teleport_potential)
	var/mob/living/simple_animal/hostile/child/unhearing/HE = new(teleport_target)
	RegisterSignal(HE, COMSIG_LIVING_DEATH, PROC_REF(DeadChild), HE)
	teleport_potential -= teleport_target
	teleport_target = pick(teleport_potential)
	var/mob/living/simple_animal/hostile/child/unspeaking/PE = new(teleport_target)
	RegisterSignal(PE, COMSIG_LIVING_DEATH, PROC_REF(DeadChild), PE)
	children_list = list(SE, HE, PE)

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/DeadChild(mob/living/deadchild)
	children_list -= deadchild
	charge = max(0, charge - 30) // Extra 30 Sec Per Kill
	if(children_list.len <= 0)
		SLEEP_CHECK_DEATH(50)
		FinalPhase()
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)

/mob/living/simple_animal/hostile/abnormality/crying_children/proc/FinalPhase()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "I don’t want to hear anything. I don’t want to see anything, or speak anything…", 25))
	icon_phase = "desperation"
	icon_living = "[icon_phase]_idle"
	icon_state = "[icon_phase]_idle"
	desperate = TRUE
	maxHealth = 4000
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1)
	revive(full_heal = TRUE, admin_revive = FALSE)
	move_to_delay = 4
	burn_mod = 2
	can_act = TRUE
	charge = 0
	maxcharge = 90 // Becomes 1 Minute 30 sec
	sound_to_playing_players_on_level('sound/abnormalities/crying_children/final_phase.ogg', 50, zlevel = z)

/* The Children */
/mob/living/simple_animal/hostile/child
	name = "Punt The Child"
	desc = "My child would never commit arson!"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	is_flying_animal = TRUE
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/crying_children/attack_child.ogg'
	health = 1500
	maxHealth = 1500
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 25
	melee_damage_upper = 40
	move_to_delay = 2
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	var/tagged = FALSE

// Tag, You're it (Doesn't chase you until they lose hp)
/mob/living/simple_animal/hostile/child/Initialize()
	. = ..()
	toggle_ai(AI_OFF)

/mob/living/simple_animal/hostile/child/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	..()
	if(!tagged)
		toggle_ai(initial(src.AIStatus))
		for(var/mob/living/carbon/human/H in view(src, 10)) // Immediately attacks on getting tagged
			if(get_dist(src, H) < get_dist(src, target))
				target = H
			if(!target)
				target = H
		if(target in view(1, src))
			AttackingTarget()
		tagged = TRUE

// Unseeing
/mob/living/simple_animal/hostile/child/unseeing
	name = "Unseeing Child"
	desc = "Turn a blind eye to all that tries to hurt me."
	icon_state = "unseeing_child"
	icon_living = "unseeing_child"
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	var/list/blinded = list()

/mob/living/simple_animal/hostile/child/unseeing/Initialize()
	. = ..()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(faction_check_mob(H, FALSE) || H.z != z || H.stat == DEAD || HAS_TRAIT(H, TRAIT_BLIND))
			continue
		ADD_TRAIT(H, TRAIT_BLIND, GENETIC_MUTATION)
		H.update_blindness()
		H.update_sight()
		blinded += H

/mob/living/simple_animal/hostile/child/unseeing/death(gibbed)
	for(var/mob/living/carbon/human/H in blinded)
		REMOVE_TRAIT(H, TRAIT_BLIND, GENETIC_MUTATION)
		H.update_blindness()
		H.update_sight()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "The World Was Beautiful, Yet The Child Can't See It.", 25))
	..()

// Unhearing
/mob/living/simple_animal/hostile/child/unhearing
	name = "Unhearing Child"
	desc = "Turn a deaf ear to words that will lead me down the wrong path."
	icon_state = "unhearing_child"
	icon_living = "unhearing_child"
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.8)
	var/list/deafened = list()

/mob/living/simple_animal/hostile/child/unhearing/Initialize()
	. = ..()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(faction_check_mob(H, FALSE) || H.z != z || H.stat == DEAD || HAS_TRAIT(H, TRAIT_DEAF))
			continue
		ADD_TRAIT(H, TRAIT_DEAF, GENETIC_MUTATION)
		deafened += H

/mob/living/simple_animal/hostile/child/unhearing/death(gibbed)
	for(var/mob/living/carbon/human/H in deafened)
		REMOVE_TRAIT(H, TRAIT_DEAF, GENETIC_MUTATION)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "Words Of Love And Encouragement Was Spoken, Yet The Child Can't Hear Them.", 25))
	..()

// Unspeaking
/mob/living/simple_animal/hostile/child/unspeaking
	name = "Unspeaking Child"
	desc = "Turn a mute mouth to unnecessary evil."
	icon_state = "unspeaking_child"
	icon_living = "unspeaking_child"
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	var/list/muted = list()

/mob/living/simple_animal/hostile/child/unspeaking/Initialize()
	. = ..()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(faction_check_mob(H, FALSE) || H.z != z || H.stat == DEAD || HAS_TRAIT(H, TRAIT_MUTE))
			continue
		ADD_TRAIT(H, TRAIT_MUTE, GENETIC_MUTATION)
		muted += H

/mob/living/simple_animal/hostile/child/unspeaking/death(gibbed)
	for(var/mob/living/carbon/human/H in muted)
		REMOVE_TRAIT(H, TRAIT_MUTE, GENETIC_MUTATION)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "His Mind, Full Of Pain And Suffering, Yet The Child Can't Tell A Soul.", 25))
	..()

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

#undef TCC_SORROW_COOLDOWN
#undef TCC_COMBUST_COOLDOWN
