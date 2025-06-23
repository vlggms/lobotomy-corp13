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
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_sound = 'sound/items/bikehorn.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	del_on_death = 1
	move_to_delay = 16 //very slow
	ranged = TRUE
	retreat_distance = 10
	minimum_distance = 10
	loot = list(/obj/effect/mob_spawn/human/clown/corpse)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	pressure_resistance = 200

	var/can_act = TRUE
	var/scream_cooldown
	var/scream_cooldown_time = 5 SECONDS
	var/scream_damage = 15
	var/move_speed_maskbreak = 2

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
	say(pick(scream_lines))
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
	move_to_delay = move_speed_maskbreak
	UpdateSpeed()
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/scream.ogg', 50, TRUE, 3)
	ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.2))
	SLEEP_CHECK_DEATH(25)
	ChangeResistances(list(BRUTE = 1, RED_DAMAGE = 1.6, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2))
	say(maskbreak_say_2)
	can_act = TRUE

/mob/living/simple_animal/hostile/mutant_clown/boss
	name = "'Grandfather'"
	icon = 'icons/mob/clown_mobs.dmi'
	icon_state = "mutant"
	icon_living = "mutant"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 1000
	health = 1000
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	melee_damage_lower = 35
	melee_damage_upper = 50
	scream_damage = 20
	loot = list(/obj/effect/mob_spawn/human/clown/corpse, /obj/item/organ/heart/mutant_heart)
	move_speed_maskbreak = 14
	maskbreak_say_1 = "..."
	maskbreak_say_2 = "Whe-ere... is the joy?"
	scream_lines = list(
		"For... Family...",
		"Saving... Them...",
		"Get away...",
		"Don't look... At them...",
		"Leave... Us...",
	)
	var/meat_cooldown
	var/meat_cooldown_time = 2.5 SECONDS
	var/list/spawned_hearts = list()

/mob/living/simple_animal/hostile/mutant_clown/boss/AttackingTarget()
	if(current_stage == 1)
		return OpenFire()
	else
		Slam()
		return OpenFire()

/mob/living/simple_animal/hostile/mutant_clown/boss/OpenFire()
	if(scream_cooldown <= world.time)
		Scream()
	if(meat_cooldown <= world.time)
		MeatDrop()
	return

/mob/living/simple_animal/hostile/mutant_clown/boss/proc/MeatDrop()
	meat_cooldown = world.time + meat_cooldown_time
	playsound(get_turf(target), 'sound/magic/arbiter/repulse.ogg', 20, 0, 5)
	new /obj/effect/temp_visual/meat_warning(get_turf(target), src)

/mob/living/simple_animal/hostile/mutant_clown/boss/Move()
	if(spawned_hearts.len)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/mutant_clown/boss/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(spawned_hearts.len)
		amount = 0
	. = ..()
	if(amount == 0)
		new /obj/effect/temp_visual/blood_shield(src.loc)

/mob/living/simple_animal/hostile/mutant_clown/boss/death(gibbed)
	. = ..()
	// Award achievement to all nearby players
	for(var/mob/living/L in view(7, src))
		if(L.stat || !L.client)
			continue
		L.client.give_award(/datum/award/achievement/lc13/city/mutant_clown_boss, L)

/mob/living/simple_animal/hostile/mutant_clown/boss/Destroy()
	. = ..()
	for(var/mob/living/simple_animal/hostile/mutant_clown/C in GLOB.mob_living_list)
		if(C.current_stage == 1)
			C.BreakMask()

/mob/living/simple_animal/hostile/mutant_heart
	name = "decaying heart"
	desc = "A still beating massive heart, feeding 'Grandfather'."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "meateor"
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	maxHealth = 500
	health = 500
	del_on_death = TRUE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	pressure_resistance = 200
	var/connected_mob
	var/current_connection

/mob/living/simple_animal/hostile/mutant_heart/Move()
	return FALSE

/mob/living/simple_animal/hostile/mutant_heart/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/mutant_heart/Life()
	. = ..()
	if(!connected_mob)
		for(var/mob/living/simple_animal/hostile/mutant_clown/boss/B in view(10, src))
			B.spawned_hearts += src
			connected_mob = B
			current_connection = Beam(B, icon_state="blood", time=INFINITY, maxdistance=20 * 2, beam_type=/obj/effect/ebeam/blood_connection)
			break

/mob/living/simple_animal/hostile/mutant_heart/Initialize()
	. = ..()
	for(var/mob/living/simple_animal/hostile/mutant_clown/boss/B in view(10, src))
		B.spawned_hearts += src
		connected_mob = B
		current_connection = Beam(B, icon_state="blood", time=INFINITY, maxdistance=20 * 2, beam_type=/obj/effect/ebeam/blood_connection)
		break

/mob/living/simple_animal/hostile/mutant_heart/Destroy()
	if(connected_mob)
		var/mob/living/simple_animal/hostile/mutant_clown/boss/father = connected_mob
		father.spawned_hearts -= src
		qdel(current_connection)
		current_connection = null
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/abomination_stagetransition.ogg', 75, 0, 3)
	. = ..()

/obj/effect/ebeam/blood_connection
	name = "bloodly connection"

/obj/effect/temp_visual/meat_warning
	name = "bloated meat"
	desc = "A pile of rotten meat, You should get away instead of reading this."
	icon = 'icons/mob/cult.dmi'
	icon_state = "meat_bomb"
	color = "#a3001e"
	duration = 10
	layer = RIPPLE_LAYER // We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	var/damage = 40 //Red Damage
	var/mob/living/caster // who made this, anyway

/obj/effect/temp_visual/meat_warning/Initialize(mapload, new_caster)
	. = ..()
	if(new_caster)
		caster = new_caster
	addtimer(CALLBACK(src, PROC_REF(explode)), 0.9 SECONDS)

/obj/effect/temp_visual/meat_warning/proc/explode()
	var/turf/target_turf = get_turf(src)
	if(!target_turf)
		return
	if(QDELETED(caster) || caster?.stat == DEAD || !caster)
		return
	for(var/turf/T in view(1, src))
		new /obj/effect/temp_visual/smash_effect(T)
		new /obj/effect/decal/cleanable/blood(T)
		caster.HurtInTurf(T, list(), damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE, hurt_structure = FALSE)
	qdel(src)

/obj/item/mutant_heart
	name = "Mutated Heart"
	desc = "It still beats... Forever in suffering..."
	icon = 'ModularTegustation/Teguicons/tier4_organs.dmi'
	icon_state = "heart-c-u3-on"

/obj/item/organ/heart/mutant_heart
	name = "Mutated Heart"
	desc = "It still beats... Forever in suffering..."
	icon = 'ModularTegustation/Teguicons/tier4_organs.dmi'
	icon_state = "heart-c-u3-on"
	organ_flags = ORGAN_SYNTHETIC
	var/min_next_adrenaline = 0
	var/regen_amount = 10
	var/regen_mult = 1.5
	var/health_threshold = 0.9

/obj/item/organ/heart/mutant_heart/Insert(mob/living/carbon/M, special = 0)
	..()
	M.gain_trauma_type(/datum/brain_trauma/mild/healthy, TRAUMA_RESILIENCE_ABSOLUTE)
	M.gain_trauma_type(/datum/brain_trauma/severe/split_personality, TRAUMA_RESILIENCE_ABSOLUTE)

/obj/item/organ/heart/mutant_heart/Remove(mob/living/carbon/M, special = 0)
	..()
	M.cure_trauma_type(/datum/brain_trauma/mild/healthy, TRAUMA_RESILIENCE_ABSOLUTE)
	M.cure_trauma_type(/datum/brain_trauma/severe/split_personality, TRAUMA_RESILIENCE_ABSOLUTE)

/obj/item/organ/heart/mutant_heart/on_life()
	. = ..()
	if(ishuman(owner) && owner.health < owner.maxHealth * health_threshold && world.time > min_next_adrenaline)
		var/mob/living/carbon/human/joyful = owner
		min_next_adrenaline = world.time + rand(10, 20)
		to_chat(joyful, "<span class='userdanger'>This pain... Brings us such joy...</span>")
		joyful.heal_overall_damage(regen_amount*regen_mult, regen_amount*regen_mult, regen_amount*regen_mult, BODYPART_ORGANIC)
		joyful.apply_damage(regen_amount, WHITE_DAMAGE)
