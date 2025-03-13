/mob/living/simple_animal/hostile/mutant_clown
	name = "Mutant Clown"
	desc = "Humans who got mutated after the blast... Still clinging on their sanity..."
	icon = 'icons/mob/clown_mobs.dmi'
	icon_state = "lube"
	icon_living = "lube"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	health_doll_icon = "clown" //if >32x32, it will use this generic. for all the huge clown mobs that subtype from this
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak = list("Pa-ain..", "E-endure-e...", "Do-on't di-ie...")
	emote_see = list("honks", "squeaks")
	speak_chance = 1
	maxHealth = 1500
	health = 1500
	damage_coeff = list(RED_DAMAGE = 1.4, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL
	mob_size = MOB_SIZE_HUGE
	faction = list("hostile")
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_sound = 'sound/items/bikehorn.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	del_on_death = 1
	move_to_delay = 16 //very slow
	ranged = TRUE
	retreat_distance = 10
	minimum_distance = 10
	loot = list(/obj/effect/mob_spawn/human/clown/corpse)

	var/can_act = TRUE
	var/scream_cooldown
	var/scream_cooldown_time = 5 SECONDS
	var/scream_damage = 15

	var/maskbreak_say_1 = "No... NO-OT MY MA-ASK!!!"
	var/maskbreak_say_2 = "I WI-ILL BRE-EAK YOU!!!"
	var/list/scream_lines = list(
		"Ple-ease... E-end...",
		"Sa-ave me...",
		"Ge-et awa-ay!",
		"Do-on't loo-ok...",
		"Le-eave me...",
	)

	var/slam_delay = 5
	var/current_stage = 1

/mob/living/simple_animal/hostile/mutant_clown/AttackingTarget()
	if(current_stage == 1)
		return OpenFire()
	else
		return Slam()

/mob/living/simple_animal/hostile/mutant_clown/OpenFire()
	if(scream_cooldown <= world.time)
		Scream()
	return

/mob/living/simple_animal/hostile/mutant_clown/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/mutant_clown/proc/Scream()
	scream_cooldown = world.time + scream_cooldown_time
	can_act = FALSE
	say(pick(combat_lines))
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/scream.ogg', 50, TRUE, 3)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*1.5, time = 4)
	SLEEP_CHECK_DEATH(6)
	for(var/mob/living/L in view(7, src))
		if(!faction_check_mob(L))
			L.apply_damage(scream_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	can_act = TRUE

/mob/living/simple_animal/hostile/mutant_clown/proc/Slam()
	can_act = FALSE
	face_atom(target)
	for(var/turf/T in view(1, src))
		new /obj/effect/temp_visual/smash1(T)
		HurtInTurf(T, list(), (rand(melee_damage_lower, melee_damage_upper)), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 50, 0, 3)
	SLEEP_CHECK_DEATH(0.4 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/mutant_clown/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if((health <= (maxHealth/2)) && (current_stage == 1))
		BreakMask()

/mob/living/simple_animal/hostile/mutant_clown/proc/BreakMask()
	can_act = FALSE
	icon_living = icon_state + "_unmasked"
	icon_state = icon_living
	desc += "Now with their mask broken... You can see their mutated face."
	current_stage = 2
	new /obj/effect/gibspawner/human/bodypartless(get_turf(src))
	retreat_distance = 0
	minimum_distance = 0
	say(maskbreak_say_1)
	move_to_delay = 2
	UpdateSpeed()
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/scream.ogg', 50, TRUE, 3)
	ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.2))
	SLEEP_CHECK_DEATH(25)
	ChangeResistances(list(BRUTE = 1, RED_DAMAGE = 1.6, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2))
	say(maskbreak_say_2)
	can_act = TRUE

/mob/living/simple_animal/hostile/mutant_clown/boss
	icon = 'icons/mob/clown_mobs.dmi'
	icon_state = "mutant"
	icon_living = "mutant"
	maxHealth = 2500
	health = 2500
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	melee_damage_lower = 20
	melee_damage_upper = 30
	scream_cooldown_time = 2.5 SECONDS
	scream_damage = 20
	loot = list(/obj/effect/mob_spawn/human/clown/corpse, /obj/item/mutant_heart)

/obj/item/mutant_heart
	name = "Mutated Heart"
	desc = "It still beats... Forever in suffering..."
	icon = 'ModularTegustation/Teguicons/tier4_organs.dmi'
	icon_state = "heart-c-u3-on"
