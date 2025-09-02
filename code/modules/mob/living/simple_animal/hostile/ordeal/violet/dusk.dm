// Violet dusk
/mob/living/simple_animal/hostile/ordeal/violet_dusk
	name = "Rushing arms of rest"
	desc = "A monolith dedicated to unknown god from another dimension."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "violet_dusk"
	icon_living = "violet_dusk"
	icon_dead = "violet_dusk_dead"
	base_pixel_x = -16
	pixel_x = -16
	faction = list("violet_ordeal", "hostile")
	maxHealth = 1400
	health = 1400
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1)
	death_message = "falls apart."
	death_sound = 'sound/effects/ordeals/violet/midnight_dead.ogg'
	stat_attack = HARD_CRIT

	var/list/spawned_hands = list()
	var/retaliation_health = 10 // Initialized later
	var/hand_limit = 6
	var/hand_cooldown
	var/hand_cooldown_time = 30 SECONDS
	var/list/spawned_arms = list()
	var/arm_cooldown
	var/arm_cooldown_time = 45 SECONDS
	var/arm_limit = 12
	var/initial_spawn = FALSE
/mob/living/simple_animal/hostile/ordeal/violet_dusk/Initialize()
	. = ..()
	hand_cooldown = hand_cooldown_time + world.time
	arm_cooldown = arm_cooldown_time + world.time
	retaliation_health = maxHealth * 0.75

/mob/living/simple_animal/hostile/ordeal/violet_dusk/Life()
	. = ..()
	if(!.)
		return
	if(!initial_spawn)
		initial_spawn = TRUE
		SpawnHand()
		SpawnHand()
		for(var/i = 1 to 6)
			SpawnArm()
	if(hand_cooldown <= world.time && spawned_hands.len < hand_limit)
		hand_cooldown = hand_cooldown_time + world.time
		SpawnHand()
		if(prob(50))
			SpawnHand()
	if(arm_cooldown <= world.time && spawned_arms.len < arm_limit)
		arm_cooldown = arm_cooldown_time + world.time
		SpawnArm()
		SpawnArm()
		if(prob(50))
			SpawnHand()
		if(prob(50))
			SpawnHand()

/mob/living/simple_animal/hostile/ordeal/violet_dusk/AttackingTarget(atom/attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_dusk/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_dusk/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(health < retaliation_health)
		retaliation_health -= maxHealth * 0.5
		Retaliation()

/mob/living/simple_animal/hostile/ordeal/violet_dusk/proc/Retaliation()
	icon_state = "violet_dusk_counter"
	for(var/turf/T in range(4, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_portal_on.ogg', 75, TRUE, 16)
	for(var/i = 1 to 4)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 7)
		SLEEP_CHECK_DEATH(8)
	icon_state = icon_living
	playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_white_attack.ogg', 50, FALSE, 32)
	for(var/turf/T in range(4, src))
		HurtInTurf(T, list(), 30, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
		new /obj/effect/temp_visual/revenant(T)
	var/list/turfs = list()
	var/list/arms = list()
	var/list/arms_near = list()
	for(var/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/S in spawned_arms)
		if (get_dist(S, src) > 4)
			arms += S
		else
			arms_near += S
	for(var/turf/T in view(3, src))
		if(locate(/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm) in T)
			continue
		if(!T.is_blocked_turf_ignore_climbable())
			turfs |= T
	if(arms_near.len <= 3)
		for(var/i=0 to 3)
			if(turfs.len == 0)
				return
			if(arms.len == 0)
				var/turf/T = pick(turfs)
				var/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/S = new(T)
				spawned_arms+=S
				S.pillar = src
				if(ordeal_reference)
					S.ordeal_reference = ordeal_reference
					ordeal_reference.ordeal_mobs += S
				turfs -= T
			else
				var/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/S  = pick(arms)
				var/turf/T = pick(turfs)
				S.DoDash(T)
				arms -= S
				turfs -= T

/mob/living/simple_animal/hostile/ordeal/violet_dusk/proc/SpawnHand()
	var/list/turfs = list()
	for(var/turf/T in view(2, src))
		if(locate(/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand) in T)
			continue
		if(T.is_blocked_turf_ignore_climbable())
			continue
		turfs += T
	if(turfs.len <= 0)
		return
	var/turf/T = pick(turfs)
	var/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/S = new(T)
	spawned_hands+=S
	S.pillar = src
	if(ordeal_reference)
		S.ordeal_reference = ordeal_reference
		ordeal_reference.ordeal_mobs += S
	for(var/mob/living/L in view(4, src))
		if(!faction_check_mob(L, TRUE)) //so it doesn't attack its spawner
			S.Attacking = TRUE
			S.TeleportAttack(T)
		return

/mob/living/simple_animal/hostile/ordeal/violet_dusk/proc/SpawnArm()
	var/starting_turf = get_turf(src)
	var/list/turfs = list()
	if(prob(50))
		if(length(GLOB.xeno_spawn))
			loc = pick(GLOB.xeno_spawn)
	for(var/turf/T in view(3, src))
		if(locate(/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm) in T)
			continue
		if(T.is_blocked_turf_ignore_climbable())
			continue
		turfs += T
	loc = starting_turf
	if(turfs.len <= 0)
		return
	var/turf/T = pick(turfs)
	new /obj/effect/temp_visual/revenant(T)
	var/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/S = new(T)
	spawned_arms+=S
	S.pillar = src
	if(ordeal_reference)
		S.ordeal_reference = ordeal_reference
		ordeal_reference.ordeal_mobs += S


/mob/living/simple_animal/hostile/ordeal/violet_spawn
	name = "hand of redemption"
	desc = "A portal with a hand coming out of it."
	icon = 'ModularTegustation/Teguicons/48x96.dmi'
	faction = list("violet_ordeal")
	maxHealth = 440
	health = 440
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
	density = FALSE
	del_on_death = TRUE
	var/mob/living/simple_animal/hostile/ordeal/violet_dusk/pillar

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm
	name = "arm of rest"
	desc = "A purple tentacle coming out the ground."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "violet_dusk_tentacle"
	icon_living = "violet_dusk_tentacle"
	base_pixel_x = -8
	pixel_x = -8
	ranged = TRUE
	density = TRUE
	alpha = 0
	maxHealth = 280
	health = 280
	ranged_cooldown_time = 10 SECONDS //will dash at people if they get out of range but not too often
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 10
	melee_reach = 2
	attack_sound = 'sound/abnormalities/fairy_longlegs/attack.ogg'
	attack_verb_continuous = "thrashes"
	attack_verb_simple = "thrashs"
	var/in_charging = FALSE
	var/next_pulse = INFINITY
	var/in_pulse = FALSE
	var/thrash_range = 2
	var/thrash_damage = 22
	var/thrash_cooldown
	var/thrash_cooldown_time = 10 SECONDS
	var/thrash_count = 6

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/Destroy()
	if(pillar)
		pillar.spawned_arms -= src
		pillar = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/Initialize()
	. = ..()
	new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(src))
	animate(src, alpha = 255, time = 5)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dawn_dig_out.ogg', 25, 1)
	visible_message(span_bolddanger("[src] burrows out from the ground!"))
	thrash_cooldown = world.time + 2 SECONDS
	next_pulse = world.time + 30 SECONDS + rand(15 SECONDS, 30 SECONDS)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(world.time > next_pulse && !in_charging)
		PulseAttack()
		return
	if(in_pulse)
		for(var/mob/living/L in view(4, src))
			if(!faction_check_mob(L))
				new /obj/effect/temp_visual/revenant(get_turf(L))
				L.apply_damage(5, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/AttackingTarget(atom/attacked_target)
	if(in_pulse || in_charging)
		return
	if(thrash_cooldown > world.time)
		return
	if(attacked_target)
		thrash_cooldown = world.time + thrash_cooldown_time
		face_atom(attacked_target)
		visible_message(span_danger("[src] is thrashing about!"))
		. = Thrash(attacked_target)
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/OpenFire(atom/A)
	if(in_pulse)
		return
	if(!target)
		return
	if(!isliving(target))
		return
	DashChecker(A)

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/proc/Thrash(atom/attacked_target)
	changeNext_move(10)
	do_attack_animation(attacked_target)
	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/attack.ogg', 75, 0, 5)
	for(var/turf/T in view(thrash_range,src))
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), thrash_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/proc/DashChecker(atom/target)
	if(in_pulse)
		return
	var/dist = get_dist(target, src)
	if(dist > 3 && dist <= 8 && ranged_cooldown < world.time)
		ranged_cooldown = world.time + ranged_cooldown_time
		DoDash(target)

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/proc/DoDash(atom/target)
	if(in_charging)
		return
	in_charging = TRUE
	density = FALSE
	visible_message(span_danger("[src] burrows into the ground!"))
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dawn_dig_in.ogg', 25, 1)
	animate(src, alpha = 0, time = 5)
	SLEEP_CHECK_DEATH(1 SECONDS)
	Teleport(get_turf(target))

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/proc/Teleport(turf/T)
	if(locate(/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm) in T || T.is_blocked_turf_ignore_climbable() || !isopenturf(T))
		var/list/directions = list()
		for(var/dir in (GLOB.alldirs))
			var/turf/dispense_turf = get_step(src, T)
			if(isopenturf(dispense_turf))
				directions += dispense_turf
		if(directions.len > 0)
			T = pick(directions)
	forceMove(T)
	new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	animate(src, alpha = 255, time = 5)
	playsound(get_turf(src), 'sound/effects/ordeals/amber/dawn_dig_out.ogg', 25, 1)
	visible_message(span_bolddanger("[src] burrows out from the ground!"))
	density = TRUE
	SLEEP_CHECK_DEATH(1 SECONDS)
	ranged_cooldown = world.time + ranged_cooldown_time
	in_charging = FALSE

/mob/living/simple_animal/hostile/ordeal/violet_spawn/arm/proc/PulseAttack()
	in_pulse = TRUE
	next_pulse = world.time + 20 SECONDS
	icon_state = "violet_dusk_tentacle_ability"
	for(var/i = 1 to 8)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 7)
		SLEEP_CHECK_DEATH(8)
	var/obj/machinery/computer/abnormality/CA
	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/A in urange(24, src))
		if(A.can_meltdown && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			potential_computers += A
	if(LAZYLEN(potential_computers))
		CA = pick(potential_computers)
		CA.datum_reference.qliphoth_change(-1)
	in_pulse = FALSE
	in_charging = FALSE
	icon_state = "violet_dusk_tentacle"

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand
	icon = 'ModularTegustation/Teguicons/48x96.dmi'
	icon_state = "violet_dusk_hand_portal"
	icon_living = "violet_dusk_hand_portal"
	base_pixel_x = -8
	pixel_x = -8
	var/slam_damage = 80
	var/teleport_cooldown
	var/teleport_cooldown_time = 5 SECONDS
	var/Attacking = FALSE
	var/Vulnerable = FALSE

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/Destroy()
	if(pillar)
		pillar.spawned_hands -= src
		pillar = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/Initialize()
	. = ..()
	alpha = 0
	teleport_cooldown = world.time + rand(2 SECONDS, 12 SECONDS)

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/Life()
	. = ..()
	if(!.)
		return
	if(teleport_cooldown <= world.time)
		INVOKE_ASYNC(src, PROC_REF(TryTeleport))
	return

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/AttackingTarget(atom/attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/Move()
	return FALSE

//a lot of checks to prevent players from harming/interacting with it before it's vulnerable
/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(!Vulnerable)
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/attack_hand(mob/living/carbon/human/M)
	if(!Vulnerable)
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/attack_paw(mob/living/carbon/human/M)
	if(!Vulnerable)
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/attack_animal(mob/living/simple_animal/M)
	if(!Vulnerable)
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	if(!Vulnerable)
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/attackby(obj/item/I, mob/living/user, params)
	if(!Vulnerable)
		return
	. = ..()

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/proc/TryTeleport(atom/target)
	if(teleport_cooldown >= world.time || Attacking)
		return
	Attacking = TRUE
	SLEEP_CHECK_DEATH(0.1 SECONDS)
	var/list/potentialmarked = list()
	var/list/marked = list()
	var/mob/living/carbon/human/Y
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(locate(/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand) in get_turf(L))
			continue
		potentialmarked += L
	var/numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
	for(var/i = numbermarked, i>=1, i--)
		if(potentialmarked.len <= 0)
			break
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(Y.stat == DEAD || Y.is_working)
			continue
		marked+=Y
	if(marked.len <= 0) //Oh no, everyone's dead!
		teleport_cooldown = world.time
		Attacking = FALSE
		return
	var/mob/living/carbon/human/final_target = pick(marked)
	TeleportAttack(get_turf(final_target))

/mob/living/simple_animal/hostile/ordeal/violet_spawn/hand/proc/TeleportAttack(turf/target_turf)
	forceMove(target_turf) //look out, someone is comming!
	playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_portal_on.ogg', 100, 1)
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/fistwarning(target_turf)
	SLEEP_CHECK_DEATH(2 SECONDS)
	icon_state = "violet_dusk_hand_attack"
	SLEEP_CHECK_DEATH(7)
	Vulnerable = TRUE
	density = TRUE
	visible_message(span_danger("[src] slams down!"))
	playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_red_attack.ogg', 100, FALSE, 20)
	for(var/turf/open/T in view(2, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in view(2, src))
		if(faction_check_mob(L, TRUE)) //so it doesn't kill its partners
			continue
		L.deal_damage(slam_damage, BLACK_DAMAGE)
		if(L.health < 0)
			L.gib()
	SLEEP_CHECK_DEATH(8 SECONDS)
	icon_state = "violet_dusk_hand_leave"
	density = FALSE
	Vulnerable = FALSE
	SLEEP_CHECK_DEATH(7)
	icon_state = "violet_dusk_hand_portal"
	Attacking = FALSE
	animate(src, alpha = 0, time = 5)
	playsound(get_turf(src), 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 100, 1)
	teleport_cooldown = world.time + teleport_cooldown_time

/obj/effect/temp_visual/fistwarning
	name = "fist warning"
	icon_state = "fistwarning"
	duration = 2 SECONDS
