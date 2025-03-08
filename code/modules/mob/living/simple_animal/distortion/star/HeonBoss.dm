/mob/living/simple_animal/hostile/distortion/Jae_Heon
	name = "The Puppeteer"
	desc = "An ominous spider-like puppeteer."
	icon = 'ModularTegustation/Teguicons/Ensemble48x64.dmi'
	icon_state = "Heon"
	icon_living = "Heon"
	icon_dead = "Heon"
	del_on_death = TRUE
	speak_emote = list("intones")
	gender = MALE


	//suppression info
	maxHealth = 17000
	health = 17000
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.7)

	faction = list("hostile", "crimsonOrdeal", "bongy")
/*---Combat---*/
	//Melee stats
	attack_sound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 35
	melee_damage_upper = 45
	melee_damage_type = BLACK_DAMAGE
	rapid_melee = 2
	pixel_x = -10
	attack_verb_continuous = "pecks"
	attack_verb_simple = "peck"
	vision_range = 15
	aggro_vision_range = 30
	ranged = TRUE//allows it to attempt charging without being in melee range
	can_patrol = TRUE
//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/city/ensemblecoat,
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Jae-Heon")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/clothing/suit/armor/ego_gear/city/ensembleweak)
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Black swan is the most strongly related to this guy, but I might make one for it later.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/last_shot //Now he can bring back his son, as flesh blob that is.
	egoist_attributes = 130
	can_spawn = 0
	var/unmanifesting
	var/can_act = TRUE
	var/slash_width = 1
	var/slash_length = 30
	var/list/spawned_puppets = list()
	var/summon_cooldown
	var/summon_cooldown_time = 10 SECONDS
	var/puppets_spawn_limit = 40
	var/puppets_spawn_number = 2

/mob/living/simple_animal/hostile/distortion/Jae_Heon/Move()
	if(!can_act)
		return FALSE
	return ..()


/mob/living/simple_animal/hostile/distortion/Jae_Heon/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	return Slash(attacked_target)

/mob/living/simple_animal/hostile/distortion/Jae_Heon/proc/Slash(target)
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
	playsound(get_turf(src), 'sound/distortions/string2.ogg', 75, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(0.8 SECONDS)
	var/slash_damage = 350
	playsound(get_turf(src), 'sound/distortions/stringhurt.ogg', 100, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if (L == src)
				continue
			HurtInTurf(T, list(), slash_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/Jae_Heon/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/puppet = 40,
		/mob/living/simple_animal/hostile/lovetown/abomination = 1,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE, TRUE)

/mob/living/simple_animal/hostile/distortion/Jae_Heon/proc/PuppetSpawn() //stolen from titania
	playsound(get_turf(src), 'sound/abnormalities/pinocchio/activate.ogg', 50, 1)
	//How many we have spawned
	listclearnulls(spawned_puppets)
	for(var/mob/living/L in spawned_puppets)
		if(L.stat == DEAD)
			spawned_puppets -= L
	if(length(spawned_puppets) >= puppets_spawn_limit)
		return

	//Actually spawning them
	for(var/i=puppets_spawn_number, i>=0, i--)	//This counts down.
		var/mob/living/simple_animal/hostile/puppet/B = new(get_turf(src))
		spawned_puppets+=B
	addtimer(CALLBACK(src, PROC_REF(PuppetSpawn)), summon_cooldown_time)

/mob/living/simple_animal/hostile/distortion/Jae_Heon/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((summon_cooldown > world.time))
		return
	summon_cooldown = world.time + summon_cooldown_time
	PuppetSpawn()

	//Puppets go here.
/mob/living/simple_animal/hostile/puppet
	name = "Puppet"
	desc = "A creepy puppet that behaves as if it is an alive being of it own."
	icon = 'ModularTegustation/Teguicons/Ensemble32x32.dmi'
	icon_state = "puppetgoon"
	icon_living = "puppetgoon"
	faction = list("hostile", "crimsonOrdeal", "bongy")
	maxHealth = 500
	health = 500
	melee_damage_type = RED_DAMAGE
	vision_range = 8
	move_to_delay = 2
	melee_damage_lower = 10
	melee_damage_upper = 13
	wander = FALSE
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	footstep_type = FOOTSTEP_MOB_SHOE
	a_intent = INTENT_HELP
	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	//similar to a human
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

/mob/living/simple_animal/hostile/puppet/Initialize()
	. = ..()
	attack_sound = "sound/distortions/Doll_Stab.ogg"


/mob/living/simple_animal/hostile/puppet/Life()
	. = ..()
	//Passive regen when below 100% health.
	if(health <= maxHealth*1 && stat != DEAD)
		adjustBruteLoss(-2)
		if(!target)
			adjustBruteLoss(-6)

	//To not get puppeteer and others suck
/mob/living/simple_animal/hostile/puppet/Aggro()
	. = ..()
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/puppet/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP)
