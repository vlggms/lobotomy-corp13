/mob/living/simple_animal/hostile/abnormality/hatred_queen
	name = "Queen of hatred"
	desc = "A an abnormality resembling pale-skinned girl in a rather bizzare outfit. \
	Right behind her is what you presume to be a magic wand."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "hatred"
	icon_living = "hatred"
	var/icon_crazy = "hatred_psycho"
	icon_dead = "hatred_dead"
	faction = list("neutral")
	is_flying_animal = TRUE

	ranged = TRUE
	minimum_distance = 3

	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	ranged_cooldown_time = 12
	projectiletype = /obj/projectile/hatred
	projectilesound = 'sound/abnormalities/hatredqueen/attack.ogg'

	//del_on_death = FALSE
	//deathsound = 'sound/abnormalities/hatredqueen/dead.ogg'

	speed = 2
	move_to_delay = 4
	threat_level = WAW_LEVEL

	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(30, 40, 40, 50, 50),
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 60),
						ABNORMALITY_WORK_REPRESSION = list(20, 20, 20, 0, 0)
						)
	work_damage_amount = 7
	work_damage_type = BLACK_DAMAGE

	can_breach = TRUE
	start_qliphoth = 2

	ego_list = list(
		/datum/ego_datum/weapon/hatred,
		/datum/ego_datum/armor/hatred
		)

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/qoh_beam,
		/datum/action/innate/abnormality_attack/qoh_teleport,
		/datum/action/innate/abnormality_attack/qoh_normal
		)

	var/chance_modifier = 1
	var/death_counter = 0
	/// Reduce qliphoth if not enough people have died for too long
	var/counter_amount = 0
	var/can_act = TRUE
	var/teleport_cooldown
	var/teleport_cooldown_time = 10 SECONDS
	var/beam_cooldown
	var/beam_cooldown_time = 30 SECONDS
	/// BLACK damage done in line each 0.5 second
	var/beam_damage = 10
	var/beam_maximum_ticks = 60
	var/datum/looping_sound/qoh_beam/beamloop
	var/datum/beam/current_beam
	var/list/spawned_effects = list()

/datum/action/innate/abnormality_attack/qoh_beam
	name = "Arcana Slave"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will now charge up a giant magic beam.</span>"
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/qoh_teleport
	name = "Teleport"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "scroll"
	chosen_message = "<span class='colossus'>You will now teleport to a random enemy.</span>"
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/qoh_normal
	name = "Normal Attack"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "lovestone"
	chosen_message = "<span class='colossus'>You will now use normal attacks.</span>"
	chosen_attack_num = 5

/mob/living/simple_animal/hostile/abnormality/hatred_queen/Initialize()
	. = ..()
	beamloop = new(list(src), FALSE)
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/on_mob_death)

/mob/living/simple_animal/hostile/abnormality/hatred_queen/Destroy()
	QDEL_NULL(beamloop)
	QDEL_NULL(current_beam)
	for(var/obj/effect/qoh_sygil/S in spawned_effects)
		S.fade_out()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/hatred_queen/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/hatred_queen/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/hatred_queen/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				BeamAttack(target)
			if(2)
				TryTeleport()
			if(5)
				return ..()
		return

	if(beam_cooldown <= world.time && can_act && prob(50))
		BeamAttack(target)
		return
	if(!("neutral" in faction))
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/hatred_queen/Life()
	. = ..()
	if(status_flags & GODMODE) // Contained
		if(datum_reference?.qliphoth_meter == 1)
			addtimer(CALLBACK(src, .proc/SpawnHeart), rand(4,10))
	if(.)
		if(!client)
			if(teleport_cooldown <= world.time)
				TryTeleport()

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/SpawnHeart()
	new /obj/effect/temp_visual/hatred(get_turf(src))

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	death_counter += 1
	if((datum_reference?.qliphoth_meter == 2) && (death_counter > 6)) // Omagah a lot of dead people!
		breach_effect() // We must help them!
	return TRUE

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/BeamAttack(target)
	if(beam_cooldown > world.time)
		return FALSE
	if(!can_act)
		return FALSE
	if(target)
		face_atom(target)
	var/my_dir = dir
	var/turf/my_turf = get_turf(src)
	beam_cooldown = world.time + beam_cooldown_time
	can_act = FALSE
	for(var/i = 1 to 3)
		var/obj/effect/qoh_sygil/S = new(my_turf)
		S.icon_state = "qoh[i]"
		spawned_effects += S
		playsound(target, "sound/abnormalities/hatredqueen/beam[clamp(i, 1, 2)].ogg", 50, FALSE, 4*i)
		switch(my_dir)
			if(EAST)
				S.pixel_x += i * 16
				var/matrix/new_matrix = matrix()
				new_matrix.Scale(0.5, 1)
				S.transform = new_matrix
				S.layer += i*0.1
			if(WEST)
				S.pixel_x += i * -16
				var/matrix/new_matrix = matrix()
				new_matrix.Scale(0.5, 1)
				S.transform = new_matrix
				S.layer += i*0.1
			if(SOUTH)
				S.pixel_y += i * -16
				S.layer += i*0.1
			if(NORTH)
				S.pixel_y += i * 16
				S.layer -= i*0.1 // So they appear below each other
		SLEEP_CHECK_DEATH(4.5 SECONDS)
	var/turf/MT = get_step(my_turf, my_dir)
	var/turf/TT = get_edge_target_turf(my_turf, my_dir)
	current_beam = MT.Beam(TT, "qoh")
	var/accumulated_beam_damage = 0
	var/list/hit_line = getline(MT, TT)
	beamloop.start()
	var/beam_stage = 1
	var/beam_damage_final = beam_damage
	for(var/h = 1 to beam_maximum_ticks)
		var/list/already_hit = list()
		if((h >= 20))
			if(accumulated_beam_damage < 150)
				break
			if(beam_stage < 2)
				beam_stage = 2
				beam_damage_final *= 1.5
				var/matrix/M = matrix()
				M.Scale(3, 1)
				current_beam.visuals.transform = M
				current_beam.visuals.color = COLOR_YELLOW
		if((h >= 40))
			if(accumulated_beam_damage < 300)
				break
			if(beam_stage < 3)
				beam_stage = 3
				beam_damage_final *= 1.5
				var/matrix/M = matrix()
				M.Scale(6, 1)
				current_beam.visuals.transform = M
				current_beam.visuals.color = COLOR_SOFT_RED
		for(var/turf/TF in hit_line)
			for(var/mob/living/L in range(beam_stage-1, TF))
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				already_hit += L
				if(faction_check_mob(L))
					accumulated_beam_damage += (beam_damage_final * 0.5)
					L.adjustBruteLoss(-beam_damage_final * 0.5)
					if(ishuman(L))
						var/mob/living/carbon/human/H = L
						H.adjustSanityLoss(beam_damage_final * 0.5)
					continue
				L.apply_damage(beam_damage_final, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
				accumulated_beam_damage += beam_damage_final
		SLEEP_CHECK_DEATH(5)
	beamloop.stop()
	QDEL_NULL(current_beam)
	for(var/obj/effect/qoh_sygil/S in spawned_effects)
		S.fade_out()
	SLEEP_CHECK_DEATH(5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/TryTeleport()
	if(teleport_cooldown > world.time)
		return FALSE
	if(!can_act)
		return FALSE
	if(target && !client) // Actively fighting
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time
	var/targets_in_range = 0
	for(var/mob/living/L in oview(10, src))
		if(!faction_check_mob(L) && L.stat != DEAD)
			targets_in_range += 1
			break
	if(targets_in_range >= 1)
		to_chat(src, "<span class='warning'>You cannot teleport while enemies are nearby!</span>")
		return FALSE
	var/list/teleport_potential = list()
	for(var/mob/living/L in GLOB.mob_living_list)
		if(L.stat == DEAD || L.z != z || L.status_flags & GODMODE)
			continue
		var/turf/T = get_turf(L)
		if(!faction_check_mob(L) && L.stat != DEAD)
			teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/hatred_queen/work_chance(mob/living/carbon/human/user, chance)
	return chance * chance_modifier

/mob/living/simple_animal/hostile/abnormality/hatred_queen/OnQliphothEvent()
	if(!(status_flags & GODMODE))
		return
	if(death_counter < 2)
		counter_amount += 1
		if(counter_amount >= 3)
			counter_amount = 0
			datum_reference.qliphoth_change(-1)
	death_counter = 0
	return ..()

/mob/living/simple_animal/hostile/abnormality/hatred_queen/OnQliphothChange(mob/living/carbon/human/user)
	switch(datum_reference.qliphoth_meter)
		if(1)
			GoCrazy()
		if(2)
			GoNormal()
	return

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/GoCrazy()
	icon_state = icon_crazy
	chance_modifier = 0.8
	work_damage_amount *= 2
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/GoNormal()
	icon_state = icon_living
	chance_modifier = 1
	work_damage_amount = initial(work_damage_amount)
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)

/mob/living/simple_animal/hostile/abnormality/hatred_queen/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/hatred_queen/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(datum_reference?.qliphoth_meter == 1)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/hatred_queen/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/hatred_queen/breach_effect(mob/living/carbon/human/user)
	..()
	addtimer(CALLBACK(src, .proc/TryTeleport), 5)
	death_counter = 0
	if(datum_reference?.qliphoth_meter == 2) // Helpful breach
		fear_level = TETH_LEVEL
		return
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = icon_living
	base_pixel_x = -16
	pixel_x = -16
	faction = list("hatredqueen") // Kill everyone
	return

