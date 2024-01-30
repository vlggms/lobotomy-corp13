/mob/living/simple_animal/hostile/humanoid
	name = "humanoid"
	desc = "A miserable pile of secrets, and this is one of them, you shouldn't be seeing this!"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "humanoid_hostile"
	icon_living = "humanoid_hostile"
	faction = list("hostile")
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = TRUE
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	move_to_delay = 4
	stat_attack = HARD_CRIT
	melee_damage_type = RED_DAMAGE
	butcher_results = list(/obj/item/food/meat/slab = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 1)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL
	mob_size = MOB_SIZE_HUGE
	a_intent = INTENT_HARM

/*
RAT MOBS -
Extremely weak mobs that are a threat only if you are a unarmed civilian.
Skittish, they prefer to move in groups and will run away if the enemies are in superior numbers.
*/

//Rat - no special abilities, attacks fast
/mob/living/simple_animal/hostile/humanoid/rat
	name = "rat"
	desc = "One of the many inhabitants of the backstreets, extremely weak and skittish."
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat"
	maxHealth = 100
	health = 100
	move_to_delay = 4
	melee_damage_lower = 5
	melee_damage_upper = 6
	rapid_melee = 2
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	del_on_death = TRUE
	retreat_distance = 0
	var/retreat_distance_default = 0

/mob/living/simple_animal/hostile/humanoid/rat/GiveTarget(new_target)
	var/strength_difference = -1
	for(var/mob/living/living_mob_in_view in livinginview(7,src) - src) //Doesn't count ourselves
		if(living_mob_in_view.stat == DEAD) //Doesn't count dead mobs
			continue
		if(!faction_check_mob(living_mob_in_view)) //Not an ally...
			strength_difference += 1
			continue
		strength_difference -= 1 //An ally!

	//If outnumbered by enemies, we act skittishly
	if(strength_difference > 0)
		retreat_distance = retreat_distance_default + 3
		return ..()

	//Else act as normal
	retreat_distance = retreat_distance_default
	. = ..()

//Knife - The leader, has a pathetically weak dash, attacks fast
/mob/living/simple_animal/hostile/humanoid/rat/knife
	name = "leader rat"
	desc = "One of the many inhabitants of the backstreets, this one seems stronger than most rats, not like that's a hard feat."
	icon_state = "rat_knife"
	icon_living = "rat_knife"
	icon_dead = "rat_knife"
	maxHealth = 250
	health = 250
	move_to_delay = 3
	ranged = TRUE
	melee_damage_lower = 8
	melee_damage_upper = 9
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	var/can_act = TRUE
	var/dash_cooldown
	var/dash_cooldown_time = 10 SECONDS
	var/dash_damage = 20
	var/dash_range = 2

/mob/living/simple_animal/hostile/humanoid/rat/knife/proc/BackstreetsDash(target)
	if(dash_cooldown > world.time)
		return
	dash_cooldown = world.time + dash_cooldown_time
	can_act = FALSE
	var/turf/slash_start = get_turf(src)
	var/turf/slash_end = get_ranged_target_turf_direct(slash_start, target, dash_range)
	var/list/hitline = getline(slash_start, slash_end)
	face_atom(target)
	for(var/turf/T in hitline)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(1 SECONDS)
	forceMove(slash_end)
	for(var/turf/T in hitline)
		for(var/mob/living/L in HurtInTurf(T, list(), dash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE))
			to_chat(L, span_userdanger("[src] quickly slashes you!"))
	new /datum/beam(slash_start.Beam(slash_end, "1-full", time=3))
	playsound(src, attack_sound, 50, FALSE, 4)
	can_act = TRUE

/mob/living/simple_animal/hostile/humanoid/rat/knife/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/rat/knife/AttackingTarget()
	if(!can_act)
		return
	..()
	if(dash_cooldown < world.time)
		BackstreetsDash(target)
		return

/mob/living/simple_animal/hostile/humanoid/rat/knife/OpenFire()
	if(!can_act)
		return
	if(prob(50) && (get_dist(src, target) < dash_range) && (dash_cooldown < world.time))
		BackstreetsDash(target)
		return
	return

//Pipe - Big windup before each attack, hits very hard
/mob/living/simple_animal/hostile/humanoid/rat/pipe
	name = "brute rat"
	desc = "One of the many inhabitants of the backstreets, armed with an odd pipe."
	icon_state = "rat_pipe"
	icon_living = "rat_pipe"
	icon_dead = "rat_pipe"
	melee_damage_lower = 20
	melee_damage_upper = 25
	rapid_melee = 1
	attack_sound = 'sound/weapons/ego/pipesuffering.ogg'
	melee_damage_type = WHITE_DAMAGE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"

/mob/living/simple_animal/hostile/humanoid/rat/pipe/MeleeAction(patience = TRUE)
	playsound(get_turf(src), 'sound/abnormalities/apocalypse/swing.ogg', 75, 0, 3)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	if(!target.Adjacent(targets_from))
		return
	. = ..()

//Hammer - Tanky rat, but runs away at half health
/mob/living/simple_animal/hostile/humanoid/rat/hammer
	name = "cowardly rat"
	desc = "One of the many inhabitants of the backstreets, they seem like they're barely holding on to their weapon."
	icon_state = "rat_hammer"
	icon_living = "rat_hammer"
	icon_dead = "rat_hammer"
	maxHealth = 150
	health = 150
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 12
	melee_damage_upper = 15
	rapid_melee = 1
	attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
	attack_verb_continuous = "hammers"
	attack_verb_simple = "hammer"
	retreat_distance = 1
	retreat_distance_default = 1
	var/coward_health_threshold = 75

/mob/living/simple_animal/hostile/humanoid/rat/hammer/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(health < coward_health_threshold)
		retreat_distance_default = 4

//Zippy - Uses a gun that fires 70% of the time and has a 1% chance to explode, leaving them without a gun.
/mob/living/simple_animal/hostile/humanoid/rat/zippy
	name = "fidgety rat"
	desc = "One of the many inhabitants of the backstreets, this one is armed with a shoddy gun!"
	icon_state = "rat_zippy"
	icon_living = "rat_zippy"
	icon_dead = "rat_zippy"
	maxHealth = 80
	health = 80
	move_to_delay = 5
	melee_damage_lower = 4
	melee_damage_upper = 6
	rapid_melee = 1
	attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	ranged = TRUE
	retreat_distance = 3
	minimum_distance = 3
	retreat_distance_default = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_kcorp
	projectilesound = 'sound/weapons/gun/pistol/shot.ogg'

/mob/living/simple_animal/hostile/humanoid/rat/zippy/OpenFire(atom/A)
	switch(rand(1,100))
		if(71 to 100) //29% for jamming.
			visible_message(span_notice("[src]'s gun jams."))
			playsound(src, 'sound/weapons/gun/general/dry_fire.ogg', 30, TRUE)
			return
		if(70) //1% for gun to explode.
			ranged = FALSE
			minimum_distance = 0
			retreat_distance = 1
			retreat_distance_default = 1
			visible_message(span_notice("The gun explodes on [src]'s hands!."))
			playsound(src, 'sound/abnormalities/scorchedgirl/explosion.ogg', 30, TRUE)
			adjustBruteLoss(20)
			return
		else
			. = ..()
