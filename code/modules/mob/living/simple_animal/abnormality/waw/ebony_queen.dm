//Coded by Coxswain sprites by mel and Sky_
/mob/living/simple_animal/hostile/abnormality/ebony_queen
	name = "Ebony Queen’s Apple"
	desc = "An Abnormality taking the form of a tall humanoid with a rotted apple for a head, wearing a regal robe."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "ebonyqueen"
	icon_living = "ebonyqueen"
	icon_dead = "ebonyqueen_dead"
	portrait = "ebony_queen"
	maxHealth = 2000
	health = 2000
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 35
	melee_damage_upper = 45
	speed = 6
	move_to_delay = 6
	ranged = TRUE
	ranged_cooldown_time = 1 //fast!
	rapid_melee = 8 // every 1/4 second
	damage_coeff = list(RED_DAMAGE = 1.0, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0, PALE_DAMAGE = 0.7)
	ranged = TRUE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/ebonyqueen/attack.ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claws"
	projectilesound = 'sound/creatures/venus_trap_hit.ogg'
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	del_on_death = FALSE
	death_message = "collapses into a pile of plantmatter."
	death_sound = 'sound/creatures/venus_trap_death.ogg'
	attacked_sound = 'sound/creatures/venus_trap_hurt.ogg'
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 0, 0),
		ABNORMALITY_WORK_INSIGHT = list(10, 20, 45, 45, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(20, 30, 55, 55, 60),
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	var/barrier_cooldown
	var/barrier_cooldown_time = 4 SECONDS
	var/barrage_cooldown
	var/barrage_cooldown_time = 8 SECONDS
	var/burst_cooldown
	var/burst_cooldown_time = 10 SECONDS
	var/barrage_range = 10

	var/can_act = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/ebony_stem,
		/datum/ego_datum/armor/ebony_stem,
	)
	gift_type =  /datum/ego_gifts/ebony_stem
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/golden_apple = 1.5,
		/mob/living/simple_animal/hostile/abnormality/snow_whites_apple = 1.5,
	)

	//PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/innate/abnormality_attack/ebony_root,
		/datum/action/innate/abnormality_attack/ebony_barrier,
		/datum/action/innate/abnormality_attack/ebony_barrage,
		/datum/action/cooldown/ebony_burst,
	)

/datum/action/innate/abnormality_attack/ebony_root
	name = "Root Spike"
	button_icon_state = "ebony_root"
	chosen_message = span_colossus("You will now shoot your roots from the ground.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/ebony_barrier
	name = "Thorn Barrier"
	button_icon_state = "ebony_barrier"
	chosen_message = span_colossus("You will now create a barrier of thorns.")
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/ebony_barrage
	name = "Root Barrage"
	button_icon_state = "ebony_barrage"
	chosen_message = span_colossus("You will now shoot a devastating line of roots.")
	chosen_attack_num = 3

/datum/action/cooldown/ebony_burst
	name = "Thorn Burst"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "ebony_burst"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/ebony_burst/Trigger()
	if(!..())
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/ebony_queen/EQ = owner
	if(!istype(EQ))
		return FALSE
	if(EQ.barrier_cooldown > world.time || !EQ.can_act)
		return FALSE
	StartCooldown()
	EQ.thornBurst()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ebony_queen/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ebony_queen/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(TryTeleport)), 5)

/mob/living/simple_animal/hostile/abnormality/ebony_queen/Move()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/ebony_queen/Goto(target, delay, minimum_distance)
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/ebony_queen/MoveToTarget(list/possible_targets)
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/ebony_queen/DestroySurroundings()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/ebony_queen/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

	//Simple behaviors
/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/TryTeleport() //stolen from knight of despair
	if(!can_act)
		return
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.xeno_spawn)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	can_act = FALSE
	var/turf/teleport_target = pick(teleport_potential)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	animate(src, alpha = 0, time = 5, easing = EASE_OUT)
	SLEEP_CHECK_DEATH(1)
	visible_message(span_boldwarning("[src] fades out!"))
	density = FALSE
	SLEEP_CHECK_DEATH(4)
	forceMove(teleport_target)
	SLEEP_CHECK_DEATH(1)
	animate(src, alpha = 255, time = 5, easing = EASE_IN)
	SLEEP_CHECK_DEATH(1)
	density = TRUE
	visible_message(span_boldwarning("[src] fades in!"))
	SLEEP_CHECK_DEATH(4)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return

	if(client)
		OpenFire()
		return

	if(target) // You'd think this should be "attacked_target" but no this shit still uses target I hate it.
		if(ismecha(target))
			if(burst_cooldown <= world.time && prob(50))
				thornBurst()
			else
				OpenFire()
			return
		else if(isliving(target))
			var/mob/living/L = target
			if(L.stat != DEAD)
				if(burst_cooldown <= world.time && prob(50))
					thornBurst()
				else
					OpenFire()
			return
	return ..()

/mob/living/simple_animal/hostile/abnormality/ebony_queen/OpenFire()
	if(!can_act)
		return

	ranged_cooldown = world.time + ranged_cooldown_time

	if(client)
		switch(chosen_attack)
			if(1)
				rootStab(target)
			if(2)
				thornBarrier(target)
			if(3)
				rootBarrage(target)
		return

	if((barrage_cooldown <= world.time) && get_dist(src, target) >= 2 && prob(50))
		rootBarrage(target)
	else if((barrier_cooldown <= world.time) && prob(50))
		thornBarrier(target)
	else
		rootStab(target)
	return

	//Effects
/obj/effect/temp_visual/thornspike
	icon = 'ModularTegustation/Teguicons/tegu_effects32x48.dmi'
	icon_state = "thornspike"
	duration = 8
	randomdir = TRUE //random spike appearance
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/root
	name = "pale stem"
	desc = "A target warning you of incoming pain"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "vines"
	duration = 6
	layer = RIPPLE_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	var/root_damage = 65 //Black Damage
	var/mob/living/caster //who made this, anyway

/obj/effect/temp_visual/root/Initialize(mapload, new_caster)
	. = ..()
	if(new_caster)
		caster = new_caster
	addtimer(CALLBACK(src, PROC_REF(explode)), 0.5 SECONDS)

/obj/effect/temp_visual/root/proc/explode()
	var/turf/target_turf = get_turf(src)
	if(!target_turf)
		return
	if(QDELETED(caster) || caster?.stat == DEAD || !caster)
		return
	playsound(target_turf, 'sound/abnormalities/ebonyqueen/attack.ogg', 40, 0, 8)
	new /obj/effect/temp_visual/thornspike(target_turf)
	var/list/hit = caster.HurtInTurf(target_turf, list(), damage = root_damage, damage_type = BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, mech_damage = root_damage/2)
	for(var/mob/living/L in hit)
		if(L.stat == DEAD || L.throwing)
			continue
		L.visible_message(span_userdanger("[src] knocks [L] away!"), span_userdanger("[src] knocks you away!"))
		var/turf/thrownat = get_ranged_target_turf(src, pick(GLOB.alldirs), 2)
		L.throw_at(thrownat, 1, 1, spin = TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
	for(var/obj/vehicle/sealed/mecha/M in hit) //also damage mechs.
		for(var/O in M.occupants)
			var/mob/living/occupant = O
			to_chat(occupant, span_userdanger("Your [M.name] is struck by [src]!"))
	qdel(src)

	//Special attacks; there are four of them
/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/rootStab(target) //single target
	if(!can_act)
		return
	can_act = FALSE
	playsound(get_turf(src), 'sound/creatures/venus_trap_hurt.ogg', 75, 0, 5)
	icon_state = "ebonyqueen_attack2"
	SLEEP_CHECK_DEATH(1)
	new /obj/effect/temp_visual/root(get_turf(target), src)
	SLEEP_CHECK_DEATH(4)
	icon_state = icon_living
	SLEEP_CHECK_DEATH(2)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/thornBarrier(target) //barrier of thorns
	if(barrier_cooldown > world.time || !can_act)
		return
	barrier_cooldown = world.time + barrier_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/charge.ogg', 175, 0, 5) //very quiet sound file
	icon_state = "ebonyqueen_attack3"
	SLEEP_CHECK_DEATH(7.75)
	var/turf/target_turf = get_turf(target)
	SLEEP_CHECK_DEATH(0.25) //slight offset
	for(var/turf/T in RANGE_TURFS(1, target_turf))
		new /obj/effect/temp_visual/root(T, src)
	SLEEP_CHECK_DEATH(7)
	icon_state = icon_living
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/thornBurst() //expanding square in melee
	if(burst_cooldown > world.time || !can_act)
		return
	burst_cooldown = world.time + burst_cooldown_time
	can_act = FALSE
	var/turf/origin = get_turf(src)
	playsound(origin, 'sound/abnormalities/ebonyqueen/strongcharge.ogg', 75, 0, 5)
	playsound(origin, 'sound/creatures/venus_trap_hurt.ogg', 75, 0, 5)
	icon_state = "ebonyqueen_attack4"
	SLEEP_CHECK_DEATH(9)
	var/last_dist = 0
	for(var/turf/T in spiral_range_turfs(2, origin))
		if(!T)
			continue
		var/dist = get_dist(origin, T)
		if(dist > last_dist)
			last_dist = dist
			SLEEP_CHECK_DEATH(1 + min(2 - last_dist, 12) * 0.25) //gets faster as it gets further out
		new /obj/effect/temp_visual/root(T, src)
	SLEEP_CHECK_DEATH(8)
	icon_state = icon_living
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/rootBarrage(target) //line attack
	if(barrage_cooldown > world.time || !can_act)
		return
	barrage_cooldown = world.time + barrage_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/strongcharge.ogg', 75, 0, 5)
	icon_state = "ebonyqueen_attack1"
	SLEEP_CHECK_DEATH(7)
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, barrage_range)
	var/count = 0
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			break
		count = count + 1
		if(get_dist(src, T) < 2)
			continue
		addtimer(CALLBACK(src, PROC_REF(stabHit), T), (3 * ((count*0.50)+1)) + 0.25 SECONDS)
	SLEEP_CHECK_DEATH(10)
	icon_state = icon_living
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ebony_queen/proc/stabHit(turf/T)
	if(QDELETED(src) || stat == DEAD)
		return
	new /obj/effect/temp_visual/root(T, src)
