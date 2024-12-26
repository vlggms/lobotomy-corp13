/mob/living/simple_animal/hostile/abnormality/mountain
	name = "Mountain Of Smiling Bodies"
	desc = "The Mountain of Smiling Bodies is searching for the smell of a body, carrying the smiles of many."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "mosb"
	icon_living = "mosb"
	icon_dead = "mosb_dead"
	portrait = "mountain"
	maxHealth = 1500
	health = 1500
	pixel_x = -16
	base_pixel_x = -16
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)
	melee_damage_lower = 25
	melee_damage_upper = 35
	melee_damage_type = RED_DAMAGE
	rapid_melee = 2
	stat_attack = DEAD
	ranged = TRUE
	move_to_delay = 2
	generic_canpass = FALSE
	attack_sound = 'sound/abnormalities/mountain/bite.ogg'
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	del_on_death = FALSE
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 50, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 50, 55),
	)
	work_damage_amount = 16
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/smile,
		/datum/ego_datum/armor/smile,
	)
	gift_type =  /datum/ego_gifts/smile
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	secret_chance = TRUE // Kirie, why
	secret_icon_state = "amog"
	secret_gift = /datum/ego_gifts/amogus

	observation_prompt = "It smells like death itself in its containment unit, the mound of rotted, half-purtefied flesh stares at you with its many faces. <br>\
		Arms and legs bent at odd angles, entrails draped like lazy christmas decorations, innumerable limbs twisted and distorted into a sphere - all blanketed black with necrotic skin. <br>\
		Yet the faces remain intact, pale from a lack of blood, but still as recognizable as they've always been. <br>They're smiling at you."
	observation_choices = list(
		"I recognize those faces" = list(TRUE, "From the mountain of bodies; the dead give their life to be something greater. <br>Why shouldn't they be smiling? <br>You should be smiling too."),
		"I don't recognize them" = list(FALSE, "They're holding all the laughter of those who cannot be seen here. <br>The mounds begins to shamble, upon borrowed hands and feet, it has your scent now and it will never be satisfied."),
	)

	/// Is user performing work hurt at the beginning?
	var/agent_hurt = FALSE
	var/death_counter = 0
	var/finishing = FALSE
	var/belly = 0
	var/phase = 1
	var/scream_cooldown
	var/scream_cooldown_time = 6 SECONDS
	var/scream_damage = 40
	var/slam_cooldown
	var/slam_cooldown_time = 2 SECONDS
	var/slam_damage = 30
	var/spit_cooldown
	var/spit_cooldown_time = 8 SECONDS
	/// Actually it fires this amount thrice, so, multiply it by 3 to get actual amount
	var/spit_amount = 16
	patrol_cooldown_time = 10 SECONDS //stage 1 - 10s, stage 2 - 20s, stage 3 - 30s

/mob/living/simple_animal/hostile/abnormality/mountain/Initialize()		//1 in 100 chance for amogus MOSB
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death))

/mob/living/simple_animal/hostile/abnormality/mountain/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/* Movement */

/mob/living/simple_animal/hostile/abnormality/mountain/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/Goto(target, delay, minimum_distance)
	if(LAZYLEN(patrol_path)) // This is here so projectiles won't cause it to go off track
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(phase <= 1 && isliving(blocker)) // Phase 1 MoSB cannot be blocked by mobs when it's moving towards corpses
		return TRUE
	return ..()

/* Attacking */

/mob/living/simple_animal/hostile/abnormality/mountain/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/OpenFire()
	if(finishing)
		return
	if(phase >= 2)
		if(scream_cooldown <= world.time)
			Scream()
			return TRUE
	if(phase >= 3)
		if(spit_cooldown <= world.time)
			Spit(target)
			return TRUE
		if((slam_cooldown <= world.time) && (get_dist(src, target) < 3))
			Slam(3)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/mountain/AttackingTarget(atom/attacked_target)
	if(finishing)
		return FALSE
	if(phase >= 2)
		if(prob(35) && OpenFire())
			return
	. = ..()
	if(. && isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(isliving(attacked_target) && (L.health < 0 || L.stat == DEAD))
			finishing = TRUE
			if(phase == 3)
				icon_state = "mosb_bite2"
			else
				icon_state = "mosb_bite"
			SLEEP_CHECK_DEATH(3)
			if(!targets_from.Adjacent(L) || QDELETED(L)) // They can still be saved if you move them away
				finishing = FALSE
				return
			L.gib()
			adjustBruteLoss(-maxHealth*0.1)
			finishing = FALSE
			icon_state = icon_living
			if(ishuman(L))
				belly += 1
				StageChange(TRUE)

/mob/living/simple_animal/hostile/abnormality/mountain/attacked_by(obj/item/I, mob/living/user)
	if(LAZYLEN(patrol_path) && CanAttack(user)) // Basically, it will retaliate while patrolling without stopping or chasing after them
		user.attack_animal(src)
	return ..()

/* Death and "Death" */

/mob/living/simple_animal/hostile/abnormality/mountain/death()
	//Make sure we didn't get cheesed
	if(health > 0)
		return
	if(StageChange(FALSE)) // We go down by one stage
		return
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/gib()
	if(phase > 1)
		if(health < maxHealth * 0.2) // MoSB hammer, usually
			return StageChange(FALSE)
		return
	return ..()

/* Targeting */

/mob/living/simple_animal/hostile/abnormality/mountain/GiveTarget(new_target)
	if(LAZYLEN(patrol_path))
		if(locate(/mob/living/carbon/human) in patrol_path[patrol_path.len]) // FOOD
			return // IGNORE EVERYTHING, CHARGE!!!!
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/PickTarget(list/Targets) // We attack corpses first if there are any
	if((phase <= 1) || (health <= maxHealth * 0.5))
		var/list/highest_priority = list()
		var/list/lower_priority = list()
		for(var/mob/living/L in Targets)
			if(!CanAttack(L))
				continue
			if(L.health < 0 || L.stat == DEAD)
				if(ishuman(L))
					highest_priority += L
				else
					lower_priority += L
			else if(L.health < L.maxHealth*0.5)
				lower_priority += L
		if(LAZYLEN(highest_priority))
			return pick(highest_priority)
		if(LAZYLEN(lower_priority))
			return pick(lower_priority)
	return ..()

/* Own procs */

/mob/living/simple_animal/hostile/abnormality/mountain/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	death_counter += 1
	if(death_counter >= 2)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/mountain/proc/StageChange(increase = TRUE)
	// Increase stage
	if(increase)
		if(belly >= 2)
			if(phase < 3 && SSmaptype.maptype != "limbus_labs")
				playsound(get_turf(src), 'sound/abnormalities/mountain/level_up.ogg', 75, 1)
				adjustHealth(-5000)
				maxHealth += 1000
				phase += 1
				belly = 0
			icon = 'ModularTegustation/Teguicons/96x96.dmi'
			pixel_x = -32
			base_pixel_x = -32
			if(phase == 3)
				icon_living = "mosb_breach2"
				ChangeMoveToDelay(5)
				patrol_cooldown_time = 30 SECONDS
			if(phase == 2)
				icon_living = "mosb_breach"
				ChangeMoveToDelay(4)
				patrol_cooldown_time = 20 SECONDS
			icon_state = icon_living
		return
	// Decrease stage
	if(phase <= 1) // Death
		return FALSE
	playsound(get_turf(src), 'sound/abnormalities/mountain/level_down.ogg', 75, 1)
	adjustHealth(-5000)
	maxHealth -= 1000
	phase -= 1
	icon_living = "mosb_breach"
	if(phase == 1)
		icon = 'ModularTegustation/Teguicons/64x64.dmi'
		pixel_x = -16
		base_pixel_x = -16
		ChangeMoveToDelay(2)
		patrol_cooldown_time = 10 SECONDS
	if(phase == 2)
		icon = 'ModularTegustation/Teguicons/96x96.dmi'
		pixel_x = -32
		base_pixel_x = -32
		ChangeMoveToDelay(4)
		patrol_cooldown_time = 20 SECONDS
	icon_state = icon_living
	return TRUE

/* Special attacks */

/mob/living/simple_animal/hostile/abnormality/mountain/proc/Scream()
	if(scream_cooldown > world.time)
		return
	scream_cooldown = world.time + scream_cooldown_time
	visible_message(span_danger("[src] screams wildly!"))
	new /obj/effect/temp_visual/voidout(get_turf(src))
	playsound(get_turf(src), 'sound/abnormalities/mountain/scream.ogg', 75, 1, 5)
	var/list/been_hit = list()
	for(var/turf/T in view(7, src))
		HurtInTurf(T, been_hit, scream_damage, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE)

/mob/living/simple_animal/hostile/abnormality/mountain/proc/Slam(range)
	if(slam_cooldown > world.time)
		return
	slam_cooldown = world.time + slam_cooldown_time
	visible_message(span_danger("[src] slams on the ground!"))
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, 1)
	var/list/been_hit = list()
	for(var/turf/open/T in view(2, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		HurtInTurf(T, been_hit, slam_damage, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = FALSE, hurt_structure = TRUE, break_not_destroy = TRUE)

/mob/living/simple_animal/hostile/abnormality/mountain/proc/Spit(atom/target)
	if(spit_cooldown > world.time)
		return
	finishing = TRUE
	visible_message(span_danger("[src] prepares to spit an acidic substance at [target]!"))
	SLEEP_CHECK_DEATH(4)
	spit_cooldown = world.time + spit_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/mountain/spit.ogg', 75, 1, 3)
	for(var/k = 1 to 3)
		var/turf/startloc = get_turf(targets_from)
		for(var/i = 1 to spit_amount)
			var/obj/projectile/mountain_spit/P = new(get_turf(src))
			P.starting = startloc
			P.firer = src
			P.fired_from = src
			P.yo = target.y - startloc.y
			P.xo = target.x - startloc.x
			P.original = target
			P.preparePixelProjectile(target, src)
			P.fire()
		SLEEP_CHECK_DEATH(2)
	finishing = FALSE

/* Modified patrolling */

/mob/living/simple_animal/hostile/abnormality/mountain/CanStartPatrol()
	if(phase <= 1) // Still phase one, we need corpses and can't really fight
		return !(status_flags & GODMODE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/patrol_reset()
	. = ..()
	FindTarget() // Start eating corpses IMMEDIATELLY

/mob/living/simple_animal/hostile/abnormality/mountain/patrol_select()
	if(phase >= 3) // Ignore dead stuff from now on
		return ..()

	var/list/low_priority_turfs = list() // Oh, you're wounded, how nice.
	var/list/medium_priority_turfs = list() // You're about to die and you are close? Splendid.
	var/list/high_priority_turfs = list() // IS THAT A DEAD BODY?
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4) // Way too close
			continue
		if(H.stat != DEAD) // Not dead people
			if(H.health < H.maxHealth*0.5)
				if(get_dist(src, H) > 24) // Way too far
					low_priority_turfs += get_turf(H)
					continue
				medium_priority_turfs += get_turf(H)
			continue
		if(get_dist(src, H) > 24) // Those are dead people
			medium_priority_turfs += get_turf(H)
			continue
		high_priority_turfs += get_turf(H)

	var/turf/target_turf
	if(LAZYLEN(high_priority_turfs))
		target_turf = get_closest_atom(/turf/open, high_priority_turfs, src)
		if(phase <= 1)
			target = null
	else if(LAZYLEN(medium_priority_turfs))
		target_turf = get_closest_atom(/turf/open, medium_priority_turfs, src)
	else if(LAZYLEN(low_priority_turfs))
		target_turf = get_closest_atom(/turf/open, low_priority_turfs, src)

	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()

/* Abnormality work */

/mob/living/simple_animal/hostile/abnormality/mountain/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/mountain/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.health < 0)
		datum_reference.qliphoth_change(-1)
	if(agent_hurt)
		datum_reference.qliphoth_change(-1)
		agent_hurt = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/mountain/AttemptWork(mob/living/carbon/human/user, work_type)
	if(user.health != user.maxHealth)
		agent_hurt = TRUE
	return TRUE

/* Abnormality breach */

/mob/living/simple_animal/hostile/abnormality/mountain/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)
	icon_living = "mosb_breach"
	icon_state = icon_living
