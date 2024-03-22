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

/mob/living/simple_animal/hostile/humanoid/fixer
	name = "fixer"
	desc = "One of the many inhabitants of the backstreets, extremely weak and skittish."
	icon_state = "flame_fixer"
	icon_living = "flame_fixer"
	icon_dead = "flame_fixer"
	maxHealth = 1500
	health = 1500
	move_to_delay = 4
	melee_damage_lower = 11
	melee_damage_upper = 16
	rapid_melee = 2
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	del_on_death = TRUE
	var/can_act = TRUE


/mob/living/simple_animal/hostile/humanoid/fixer/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/fixer/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	. = ..()


/mob/living/simple_animal/hostile/humanoid/fixer/metal
	name = "Metal Fixer"
	desc = "A dude covered in a full white cloak and always wear a white mask. He seems to be wearing a tactical vest."
	icon_state = "metal_fixer"
	icon_living = "metal_fixer"
	icon_dead = "metal_fixer"
	var/icon_attacking = "metal_fixer_weapon"
	maxHealth = 1500
	health = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5)
	move_to_delay = 4
	melee_damage_lower = 15
	melee_damage_upper = 19
	melee_damage_type = BLACK_DAMAGE
	rapid_melee = 2
	attack_sound = 'sound/weapons/fixer/generic/blade3.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	del_on_death = TRUE
	ranged = TRUE
	var/statue_type = /mob/living/simple_animal/hostile/metal_fixer_statue
	var/shots_cooldown = 50
	var/max_statues = 12
	var/health_lost_per_statue = 100
	var/list/statues = list()
	var/current_healthloss = 0
	var/aoe_cooldown = 300
	var/last_aoe_time = 0
	var/aoe_damage = 50
	var/stun_duration = 50

/mob/living/simple_animal/hostile/humanoid/fixer/metal/Aggro()
	icon_state = icon_attacking
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/LoseTarget()
	icon_state = icon_living
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/OpenFire()
	ranged_cooldown = world.time + shots_cooldown
	say("Experience is what brought me here.")
	playsound(src, 'sound/weapons/fixer/hana_pierce.ogg', 200, TRUE, 2) // pick sound
	for(var/d in GLOB.cardinals)
		var/turf/E = get_step(src, d)
		shoot_projectile(E)

/mob/living/simple_animal/hostile/humanoid/fixer/metal/AttackingTarget(atom/attacked_target)
	if (ranged_cooldown <= world.time)
		OpenFire()

	// do AOE
	if (world.time > last_aoe_time + aoe_cooldown)
		last_aoe_time = world.time
		can_act = FALSE
		say("This is the culmination of my work.")
		SLEEP_CHECK_DEATH(8)
		var/hit_statue = FALSE
		for(var/turf/T in view(2, src))
			playsound(src, 'sound/weapons/fixer/generic/finisher2.ogg', 200, TRUE, 2)
			new /obj/effect/temp_visual/slice(T)
			for(var/mob/living/L in T)
				if (istype(L, /mob/living/simple_animal/hostile/metal_fixer_statue))
					var/mob/living/simple_animal/hostile/metal_fixer_statue/S = L
					qdel(S)
					hit_statue = TRUE
			HurtInTurf(T, list(), aoe_damage, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE)

		if (hit_statue)
			say("...")
			SLEEP_CHECK_DEATH(stun_duration)
		can_act = TRUE
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	//say("Damage taken. Current health: [health]")
	var/old_health = health
	. = ..()
	var/health_loss = old_health - health
	current_healthloss += health_loss
	if (current_healthloss > health_lost_per_statue)
		current_healthloss -= health_lost_per_statue
		spawn_statue()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/proc/spawn_statue()
	if (statues.len < max_statues)
		var/list/available_turfs = list()
		for(var/turf/T in view(4, loc))
			if(isfloorturf(T) && !T.density && !locate(/mob/living) in T)
				available_turfs += T
		visible_message("<span class='danger'>[src] start spawning a statue! Turfs: [available_turfs.len]</span>")
		say("The days of the past.")
		if(available_turfs.len)
			var/turf/statue_turf = pick(available_turfs)
			var/mob/living/simple_animal/hostile/metal_fixer_statue/S = new statue_type(statue_turf)
			statues += S
			S.metal = src
			S.icon_state = "memory_statute_grow" // Set the initial icon state to the rising animation
			flick("memory_statute_grow", S) // Play the rising animation
			spawn(10) // Wait for the animation to finish
				S.icon_state = initial(S.icon_state) // Set the icon state back to the default statue icon
			visible_message("<span class='danger'>[src] spawns a statue on [statue_turf]!</span>")

/mob/living/simple_animal/hostile/humanoid/fixer/metal/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/metal_fixer(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	if(target)
		P.original = target
	P.fire(set_angle)

/mob/living/simple_animal/hostile/humanoid/fixer/metal/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if (istype(P, /obj/projectile/metal_fixer))
		adjustHealth(-P.damage)
		playsound(src, 'sound/abnormalities/voiddream/skill.ogg', 200, TRUE, 2)
		visible_message("<span class='warning'>[P]  contacts with [src] and heals them!</span>")
		DamageEffect(P.damage, P.damage_type)
	else
		. = ..()

/obj/projectile/metal_fixer
	name ="metal bolt"
	icon_state= "chronobolt"
	damage = 15
	speed = 2
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	ricochets_max = 3
	ricochet_chance = 100
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	ricochet_incidence_leeway = 0

/obj/projectile/metal_fixer/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	return FALSE

/obj/projectile/metal_fixer/on_hit(atom/target, blocked = FALSE)
	if(firer==target)
		//var/mob/living/simple_animal/hostile/humanoid/fixer/metal/M = target
		qdel(src)
		return BULLET_ACT_BLOCK
	. = ..()


/mob/living/simple_animal/hostile/metal_fixer_statue
	name = "Statue"
	desc = "A statue spawned by the Metal Fixer."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "memory_statute"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	health = 100
	maxHealth = 100
	speed = 0
	move_resist = INFINITY
	mob_size = MOB_SIZE_HUGE
	var/mob/living/simple_animal/hostile/humanoid/fixer/metal/metal
	var/heal_cooldown = 50
	var/heal_timer
	var/heal_per_tick = 25
	var/self_destruct_timer


/mob/living/simple_animal/hostile/metal_fixer_statue/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if (istype(P, /obj/projectile/metal_fixer))
		DamageEffect(P.damage, P.damage_type)
	else
		. = ..()


/mob/living/simple_animal/hostile/metal_fixer_statue/Initialize()
	. = ..()
	heal_timer = addtimer(CALLBACK(src, .proc/heal_metal_fixer), heal_cooldown, TIMER_STOPPABLE)
	self_destruct_timer = addtimer(CALLBACK(src, .proc/self_destruct), 1 MINUTES, TIMER_STOPPABLE)
	AIStatus = AI_OFF
	stop_automated_movement = TRUE
	anchored = TRUE

/mob/living/simple_animal/hostile/metal_fixer_statue/Destroy()
	deltimer(heal_timer)
	deltimer(self_destruct_timer)
	return ..()

/mob/living/simple_animal/hostile/metal_fixer_statue/proc/self_destruct()
	visible_message("<span class='danger'>The statue crumbles and self-destructs!</span>")
	qdel(src)

/mob/living/simple_animal/hostile/metal_fixer_statue/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(health <= 0)
		visible_message("<span class='danger'>The statue crumbles into pieces!</span>")
		qdel(src)

/mob/living/simple_animal/hostile/metal_fixer_statue/proc/heal_metal_fixer()
	if(metal)
		metal.adjustHealth(-heal_per_tick)
		visible_message("<span class='notice'>The statue heals the Metal Fixer!</span>")
		playsound(src, 'sound/abnormalities/voiddream/skill.ogg', 200, TRUE, 2)
	heal_timer = addtimer(CALLBACK(src, .proc/heal_metal_fixer), heal_cooldown, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/metal_fixer_statue/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/metal_fixer_statue/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/humanoid/fixer/flame
	name = "Flame Fixer"
	desc = "Flame Fixer"
	icon_state = "flame_fixer"
	icon_living = "flame_fixer"
	icon_dead = "flame_fixer"
	maxHealth = 1500
	health = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5)
	move_to_delay = 4
	melee_damage_lower = 1
	melee_damage_upper = 2
	melee_damage_type = RED_DAMAGE
	//rapid_melee = 2
	attack_sound = 'sound/weapons/fixer/generic/blade3.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	del_on_death = TRUE
	ranged = TRUE
	melee_reach = 2
	var/burn_stacks = 2
	projectiletype = /obj/projectile/flame_fixer
	var/damage_reflection = FALSE

/mob/living/simple_animal/hostile/humanoid/fixer/flame/Aggro()
	. = ..()
	// if dash is off cooldown stun until the end of dashes and say quote
	// wait 2 sec for the first dash
	// after 2 sec dash towards the target dealing red dmg and applying burn
	// repeat 3 times with 1 sec delay between each
	// unstun

// /mob/living/simple_animal/hostile/abnormality/big_wolf/proc/ScratchDash(dash_target)
/mob/living/simple_animal/hostile/humanoid/fixer/flame/proc/Dash(dash_target)
	can_act = FALSE
	var/turf/target_turf = get_turf(dash_target)
	var/list/hit_mob = list()
	do_shaky_animation(2)
	if(do_after(src, 1 SECONDS, target = src))
		var/turf/wallcheck = get_turf(src)
		var/enemy_direction = get_dir(src, target_turf)
		for(var/i=0 to 7)
			if(get_turf(src) != wallcheck || stat == DEAD || IsContained())
				break
			wallcheck = get_step(src, enemy_direction)
			if(!ClearSky(wallcheck))
				break
			//without this the attack happens instantly
			sleep(1)
			forceMove(wallcheck)
			playsound(wallcheck, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 20, 0, 4)
			for(var/turf/T in orange(get_turf(src), 1))
				if(isclosedturf(T))
					continue
				new /obj/effect/temp_visual/slice(T)
				for(var/mob/living/L in T)
					if(!faction_check_mob(L, FALSE) || locate(L) in hit_mob)
						L.apply_damage(50, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
						LAZYADD(hit_mob, L)
	can_act = TRUE

/mob/living/simple_animal/hostile/humanoid/fixer/flame/OpenFire(atom/A)
	if (!can_act)
		return
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/flame/Shoot(atom/targeted_atom)
	var/obj/projectile/flame_fixer/P = ..()
	P.set_homing_target(target)

/mob/living/simple_animal/hostile/humanoid/fixer/flame/AttackingTarget(atom/attacked_target)
	// check cooldown and start countering
	// stop melee start stun for 4 sec
	// animate windup  for 1 sec
	// change icon_state to counter
	// if they hit after wind up during counter deal RED damage and stamina damage
	// counter has random cooldown 15-40 sec


	. = ..()
	if (istype(target, /mob/living))
		var/mob/living/L = target
		L.apply_lc_burn(burn_stacks)

/mob/living/simple_animal/hostile/humanoid/fixer/flame/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(damage_reflection && Proj.firer)
		if(get_dist(Proj.firer, src) < 5)
			ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/humanoid/fixer/flame/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!damage_reflection)
		return
	ReflectDamage(user, I.damtype, I.force)

//Breach Mechanics
// All damage reflection stuff is down here
/mob/living/simple_animal/hostile/humanoid/fixer/flame/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	var/turf/jump_turf = get_step(attacker, pick(GLOB.alldirs))
	if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
		jump_turf = get_turf(attacker)
	forceMove(jump_turf)
	//playsound(src, 'sound/abnormalities/so_that_no_cry/counter.ogg', min(15 + damage, 100), TRUE, 4)
	attacker.visible_message(span_danger("[src] hits [attacker] with a barrage of punches!"), span_userdanger("[src] counters your attack!"))
	do_attack_animation(attacker)
	attacker.apply_damage(damage * 2, attack_type, null, attacker.getarmor(null, attack_type))
	attacker.apply_damage(damage, STAMINA, null, null)



/obj/projectile/flame_fixer
	name ="flame bolt"
	icon_state= "helios_fire"
	damage = 15
	speed = 8
	damage_type = RED_DAMAGE
	//projectile_piercing = PASSMOB
	ricochets_max = 20
	ricochet_chance = 100
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	ricochet_incidence_leeway = 0
	homing = TRUE
	homing_turn_speed = 10		//Angle per tick.
	var/stun_duration = 50
	var/burn_stacks = 20


/obj/projectile/flame_fixer/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	return FALSE

/obj/projectile/flame_fixer/on_hit(atom/target, blocked = FALSE)
	if (istype(target, /mob/living))
		var/mob/living/L = target
		L.apply_lc_burn(burn_stacks)
	if(firer==target)
		var/mob/living/simple_animal/hostile/humanoid/fixer/flame/F = target
		qdel(src)
		F.can_act = FALSE
		F.say("Im stunned")
		sleep(stun_duration)
		F.can_act = TRUE
		return BULLET_ACT_BLOCK
	. = ..()
