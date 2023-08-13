//Coded by Coxswain sprites by mel and Sky_
/mob/living/simple_animal/hostile/abnormality/ebony_queen
	name = "Ebony Queens Apple"
	desc = "An abnormality taking form of a tall humanoid in regal robe with a rotted apple for a head."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "ebonyqueen_inert"
	icon_living = "ebonyqueen_inert"
	icon_dead = "ebonyqueen_dead"
	var/icon_aggro = "ebonyqueen_active"
	maxHealth = 2000
	health = 2000
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	melee_damage_lower = 35
	melee_damage_upper = 45
	damage_coeff = list(BRUTE = 1.0, RED_DAMAGE = 1.0, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0, PALE_DAMAGE = 0.7)
	ranged = TRUE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/ebonyqueen/attack.ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claws"
	projectilesound = 'sound/creatures/venus_trap_hit.ogg'
	attack_action_types = list(
	/datum/action/innate/abnormality_attack/ebony_root,
	/datum/action/innate/abnormality_attack/ebony_barrier,
	/datum/action/innate/abnormality_attack/ebony_barrage,
	/datum/action/innate/abnormality_attack/ebony_normal
	)
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	del_on_death = FALSE
	deathmessage = "collapses into a pile of plantmatter."
	deathsound = 'sound/creatures/venus_trap_death.ogg'
	attacked_sound = 'sound/creatures/venus_trap_hurt.ogg'
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 0, 0),
						ABNORMALITY_WORK_INSIGHT = list(10, 20, 45, 45, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 40, 40),
						ABNORMALITY_WORK_REPRESSION = list(20, 30, 55, 55, 60)
						)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	var/teleport_cooldown
	var/teleport_cooldown_time = 60 SECONDS
	var/stab_cooldown
	var/stab_cooldown_time = 6 SECONDS
	var/barrier_cooldown
	var/barrier_cooldown_time = 12 SECONDS
	var/can_act = TRUE

	ego_list = list(
	/datum/ego_datum/weapon/ebony_stem,
	/datum/ego_datum/armor/ebony_stem
	)
	gift_type =  /datum/ego_gifts/ebony_stem
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/datum/action/innate/abnormality_attack/ebony_root
	name = "Root Spike"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will shoot a devastating line of roots.</span>"
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/ebony_barrier
	name = "Thorn Barrier"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will create a barrier of thorns.</span>"
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/ebony_barrage
	name = "Root Barrage"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will shoot your roots from the ground.</span>"
	chosen_attack_num = 3

/datum/action/innate/abnormality_attack/ebony_normal
	name = "Normal attacks"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will now use normal attacks.</span>"
	chosen_attack_num = 4

/mob/living/simple_animal/hostile/abnormality/ebony_queen/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ebony_queen/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ebony_queen/BreachEffect(mob/living/carbon/human/user)
	..()
	update_icon()
	addtimer(CALLBACK(src, .proc/TryTeleport), 5)

/mob/living/simple_animal/hostile/abnormality/ebony_queen/Move()
	if(!can_act)
		return FALSE
	update_icon() //prevents icons from getting stuck
	..()

/mob/living/simple_animal/hostile/abnormality/ebony_queen/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

	//Simple behaviors
/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/TryTeleport() //stolen from knight of despair
	dir = 2
	if(teleport_cooldown > world.time)
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.xeno_spawn)
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

/mob/living/simple_animal/hostile/abnormality/ebony_queen/MoveToTarget(list/possible_targets)
	if(prob(80))
		OpenFire(target)
	return ..()

/mob/living/simple_animal/hostile/abnormality/ebony_queen/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				rootStab(target)
				icon_state = icon_aggro
			if(2)
				thornBarrier(target)
			if(3)
				rootBarrage(target) //if at 4 (normal attacks) will simply continue
		return

	if((stab_cooldown <= world.time) && prob(50))
		rootStab(target)
		icon_state = icon_aggro
	if((barrier_cooldown <= world.time) && prob(50))
		thornBarrier(target)
	else
		rootBarrage(target)
	return

	//Effects
/obj/effect/temp_visual/thornspike
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "thornspike"
	duration = 10

/obj/effect/root
	name = "root"
	desc = "A target warning you of incoming pain"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "vines"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/root_damage = 65 //Black Damage
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/root/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/explode), 0.5 SECONDS)

/obj/effect/root/proc/explode() //repurposed code from artillary bees, a delayed attack
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/attack.ogg', 50, 0, 8)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(0, target_turf))
		new /obj/effect/temp_visual/thornspike(T)
		for(var/mob/living/L in T)
			L.apply_damage(root_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			if(L.health < 0)
				L.gib()
	qdel(src)

	//Special attacks; there are three of them
/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/thornBarrier(target) //barrier of thorns
	if(barrier_cooldown > world.time)
		return
	barrier_cooldown = world.time + barrier_cooldown_time
	face_atom(target)
	can_act = FALSE
	playsound(get_turf(target), 'sound/abnormalities/ebonyqueen/strongcharge.ogg', 75, 0, 5)
	icon_state = "ebonyqueen_attack1"
	SLEEP_CHECK_DEATH(12)
	var/turf/target_turf = get_turf(target)
	for(var/turf/T in view(1, target_turf))
		new /obj/effect/root(T)
	SLEEP_CHECK_DEATH(8)
	icon_state = icon_aggro
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/rootBarrage(target) //barrage
	can_act = FALSE
	playsound(get_turf(target), 'sound/creatures/venus_trap_hurt.ogg', 75, 0, 5)
	icon_state = "ebonyqueen_attack3"
	SLEEP_CHECK_DEATH(3)
	var/turf/target_turf = get_turf(target)
	for(var/turf/T in view(0, target_turf))
		new /obj/effect/root(T)
	SLEEP_CHECK_DEATH(3)
	icon_state = icon_aggro
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/rootStab(target) //line attack
	if(stab_cooldown > world.time)
		return
	stab_cooldown = world.time + stab_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/charge.ogg', 150, 0, 5) //very quiet sound file
	icon_state = "ebonyqueen_attack2"
	SLEEP_CHECK_DEATH(8)
	var/turf/target_turf = get_turf(target)
	var/list/all_turfs = RANGE_TURFS(2, target_turf)
	var/count = 0
	for(var/i = 1 to 2)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			break
		count = count + 1
		if(get_dist(src, T) < 2)
			continue
		addtimer(CALLBACK(src, .proc/stabHit, T, all_turfs), (3 * ((count*0.50)+1)) + 0.5 SECONDS)
	if(!target)
		icon_state = icon_aggro
	SLEEP_CHECK_DEATH(12)
	icon_state = icon_aggro
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/stabHit(turf/T, list/all_turfs)
	if(stat == DEAD)
		return
	new /obj/effect/root(T)
