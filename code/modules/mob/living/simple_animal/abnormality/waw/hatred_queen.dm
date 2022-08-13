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
	del_on_death = FALSE
	projectilesound = 'sound/abnormalities/hatredqueen/attack.ogg'
	deathsound = 'sound/abnormalities/hatredqueen/dead.ogg'

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
	var/teleport_cooldown_time = 30 SECONDS
	var/beam_cooldown
	var/beam_cooldown_time = 30 SECONDS
	var/beam_startup = 3.5 SECONDS
	/// BLACK damage done in line each 0.5 second
	var/beam_damage = 10
	var/beam_maximum_ticks = 60
	var/datum/looping_sound/qoh_beam/beamloop
	var/datum/beam/current_beam
	var/list/spawned_effects = list()
	//hostile breach vars
	var/hp_teleport_counter = 3
	var/explode_damage = 35
	var/breach_max_death = 0

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

/mob/living/simple_animal/hostile/abnormality/hatred_queen/death(gibbed)
	icon = initial(icon)
	base_pixel_x = initial(base_pixel_x)
	pixel_x = initial(pixel_x)
	if(datum_reference?.qliphoth_meter == 2)
		addtimer(CALLBACK(src, .atom/movable/proc/say, "I swore I would protect everyone to the end…"))
	..()
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	QDEL_NULL(beamloop)
	QDEL_NULL(current_beam)
	for(var/obj/effect/qoh_sygil/S in spawned_effects)
		S.fade_out()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

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
				if(datum_reference?.qliphoth_meter == 2) //only able to use normal if passive
					if(prob(5))
						addtimer(CALLBACK(src, .atom/movable/proc/say, "With love!"))
					return ..()
		return

	if(beam_cooldown <= world.time && can_act && (prob(50) || datum_reference?.qliphoth_meter != 2)) //hostile breach should always be beaming
		BeamAttack(target)
		return
	if(!("neutral" in faction))
		return
	if(prob(5))
		addtimer(CALLBACK(src, .atom/movable/proc/say, "With love!"))
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
		if(datum_reference?.qliphoth_meter != 2 && can_act)
			switch(hp_teleport_counter)
				if(3)
					if(maxHealth*0.7 > health)
						hp_teleport_counter--
						TryTeleport(TRUE)
					return
				if(2)
					if(maxHealth*0.4 > health)
						hp_teleport_counter--
						TryTeleport(TRUE)
					return
				if(1)
					if(maxHealth*0.1 > health)
						hp_teleport_counter--
						TryTeleport(TRUE)
					return

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/SpawnHeart()
	new /obj/effect/temp_visual/hatred(get_turf(src))

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	death_counter += 1
	//if BREACHED, check if death_counter over the death limit
	if(breach_max_death && (death_counter >= breach_max_death))
		GoHysteric()
	//if CONTAINED and not crazy
	else if((status_flags & GODMODE) && (datum_reference?.qliphoth_meter == 2) && (death_counter > 6)) // Omagah a lot of dead people!
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
	can_act = FALSE
	var/list/beamtalk = list("Heed me, thou that are more azure than justice and more crimson than love…","In the name of those buried in destiny…","I shall make this oath to the light.","Mark the hateful beings who stand before us…","Let your strength merge with mine…", "so that we may deliver the power of love to all…")
	var/b = 1
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
		if(datum_reference?.qliphoth_meter == 2)
			addtimer(CALLBACK(src, .atom/movable/proc/say, beamtalk[b]))
			b++
			addtimer(CALLBACK(src, .atom/movable/proc/say, beamtalk[b]), beam_startup/2)
			b++
		SLEEP_CHECK_DEATH(beam_startup) //time between beam startup stage
	var/turf/MT = get_step(my_turf, my_dir)
	if(datum_reference?.qliphoth_meter != 2) //beam starts on the tile of qoh when hostile breach, allows stage 2 to hit people behind her
		MT = get_turf(my_turf)
	var/turf/TT = get_edge_target_turf(my_turf, my_dir)
	current_beam = MT.Beam(TT, "qoh")
	var/accumulated_beam_damage = 0
	var/list/hit_line = getline(MT, TT)
	beamloop.start()
	var/beam_stage = 1
	var/beam_damage_final = beam_damage
	if(datum_reference?.qliphoth_meter == 2)
		addtimer(CALLBACK(src, .atom/movable/proc/say, "ARCANA SLAVE!"))
	for(var/h = 1 to beam_maximum_ticks)
		var/list/already_hit = list()
		if(datum_reference?.qliphoth_meter != 2 && (h < 20))
			h = 20
			accumulated_beam_damage = 150
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
				if (L == src) //stop hitting yourself
					continue
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
				if((datum_reference?.qliphoth_meter != 2) && !(L.status_flags & GODMODE))
					adjustBruteLoss(-beam_damage_final) //QoH heals from laser damage when hostile
				accumulated_beam_damage += beam_damage_final
		SLEEP_CHECK_DEATH(5)
	beamloop.stop()
	QDEL_NULL(current_beam)
	for(var/obj/effect/qoh_sygil/S in spawned_effects)
		S.fade_out()
	SLEEP_CHECK_DEATH(5 SECONDS) //Rest after laser beam
	can_act = TRUE
	beam_cooldown = world.time + beam_cooldown_time

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/TryTeleport(forced = FALSE)
	if(!forced)
		if(teleport_cooldown > world.time)
			return FALSE
		if(!can_act)
			return FALSE
		if(target && !client) // Actively fighting
			return FALSE
		teleport_cooldown = world.time + teleport_cooldown_time
		var/targets_in_range = 0
		for(var/mob/living/L in view(8, src))
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
		var/turf/P = pick(GLOB.department_centers)
		teleport_potential += P
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)
	if(datum_reference?.qliphoth_meter != 2)
		TeleportExplode()
	teleport_cooldown = world.time + teleport_cooldown_time

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/TeleportExplode()
	visible_message("<span class='danger'>[src] explodes!</span>")
	new /obj/effect/temp_visual/voidout(get_turf(src))
	for(var/turf/open/T in view(3, src))
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(explode_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/abnormality/hatred_queen/work_chance(mob/living/carbon/human/user, chance)
	return chance * chance_modifier

/mob/living/simple_animal/hostile/abnormality/hatred_queen/OnQliphothEvent()
	if(!(status_flags & GODMODE)) //Breached
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

/mob/living/simple_animal/hostile/abnormality/hatred_queen/proc/GoHysteric(retries = 0)
	if(!can_act)
		if(retries < 50)
			addtimer(CALLBACK(src, .proc/GoHysteric, retries++), 2 SECONDS)
		return
	can_act = FALSE
	datum_reference.qliphoth_change(-1) //temporary visual for transformation
	visible_message("<span class='danger'>[src] falls to her knees, muttering something under her breath.</span>")
	addtimer(CALLBACK(src, .atom/movable/proc/say, "I wasn’t able to protect anyone like she did…"))
	addtimer(CALLBACK(datum_reference, .datum/abnormality/proc/qliphoth_change, -1), 10 SECONDS)

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
	death_counter = 0
	if(datum_reference?.qliphoth_meter == 2) // Helpful/Passive breach
		fear_level = TETH_LEVEL
		addtimer(CALLBACK(src, .proc/TryTeleport), 5)
		for(var/mob/living/carbon/human/saving_humans in GLOB.mob_living_list) //gets all alive people
			if((saving_humans.stat != DEAD) && saving_humans.z == z)
				breach_max_death++
		breach_max_death /= 5
		if(breach_max_death == 0) //make it 1 if it's somehow zero
			breach_max_death++
		addtimer(CALLBACK(src, .atom/movable/proc/say, "In the name of Love and Justice~ Here comes Magical Girl!"))
		return
	visible_message("<span class='danger'>[src] transforms!</span>") //Begin Hostile breach
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)
	adjustBruteLoss(-maxHealth)
	can_act = TRUE
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = icon_living
	base_pixel_x = -16
	pixel_x = -16
	faction = list("hatredqueen") // Kill everyone
	fear_level = WAW_LEVEL //fear her
	beam_startup = 1.5 SECONDS //WAW level beam
	beam_cooldown_time = 10 SECONDS //it's her only move while hostile
	teleport_cooldown_time = 15 SECONDS
	beam_maximum_ticks = 79
	breach_max_death = 0 //who cares about humans anymore?
	addtimer(CALLBACK(src, .proc/TryTeleport, TRUE), 5)
	return
