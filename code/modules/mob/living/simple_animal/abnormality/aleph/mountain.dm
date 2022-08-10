/mob/living/simple_animal/hostile/abnormality/mountain
	name = "Mountain Of Smiling Bodies"
	desc = "The Mountain of Smiling Bodies is searching for the smell of a body, carrying the smiles of many."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "mosb"
	icon_living = "mosb"
	icon_dead = "mosb_dead"
	maxHealth = 1000
	health = 1000
	pixel_x = -16
	base_pixel_x = -16
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)
	melee_damage_lower = 20
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	rapid_melee = 2
	stat_attack = DEAD
	ranged = TRUE
	speed = 2
	move_to_delay = 2
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
						ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 50, 55)
						)
	work_damage_amount = 16
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/smile,
		/datum/ego_datum/armor/smile
		)

	/// Is user performing work hurt at the beginning?
	var/agent_hurt = FALSE
	var/death_counter = 0
	var/finishing = FALSE
	var/belly = 0
	var/phase = 1
	var/scream_cooldown
	var/scream_cooldown_time = 7 SECONDS
	var/scream_damage = 40
	var/slam_cooldown
	var/slam_cooldown_time = 4 SECONDS
	var/slam_damage = 30
	var/spit_cooldown
	var/spit_cooldown_time = 18 SECONDS
	/// Actually it fires this amount thrice, so, multiply it by 3 to get actual amount
	var/spit_amount = 32

/mob/living/simple_animal/hostile/abnormality/mountain/Initialize()		//1 in 100 chance for amogus MOSB
	. = ..()
	if(prob(1)) // Kirie, why
		icon_state = "amog"

/mob/living/simple_animal/hostile/abnormality/mountain/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/Move()
	if(finishing)
		return FALSE
	return ..()

//Nabbed from Big Bird
/mob/living/simple_animal/hostile/abnormality/mountain/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	death_counter += 1
	if(death_counter >= 10)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE


/mob/living/simple_animal/hostile/abnormality/mountain/death()
	//Make sure we didn't get cheesed
	if(health > 0)
		return
	if(StageChange(FALSE)) // We go down by one stage
		return
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
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

/mob/living/simple_animal/hostile/abnormality/mountain/AttackingTarget()
	if(finishing)
		return FALSE
	if(phase >= 2)
		if(prob(35) && OpenFire())
			return
	. = ..()
	if(.)
		var/mob/living/L = target
		if(L.health < 0 || L.stat == DEAD)
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

/mob/living/simple_animal/hostile/abnormality/mountain/proc/StageChange(increase = TRUE)
	// Increase stage
	if(increase)
		if(belly >= 5)
			if(phase < 3)
				playsound(get_turf(src), 'sound/abnormalities/mountain/level_up.ogg', 75, 1)
				maxHealth += 500
				phase += 1
				belly = 0
			icon = 'ModularTegustation/Teguicons/96x96.dmi'
			pixel_x = -32
			base_pixel_x = -32
			if(phase == 3)
				icon_living = "mosb_breach2"
				speed = 4
				move_to_delay = 5
			if(phase == 2)
				icon_living = "mosb_breach"
				speed = 3
				move_to_delay = 4
			icon_state = icon_living
			adjustHealth(-maxHealth)
		return
	// Decrease stage
	if(phase <= 1) // Death
		return FALSE
	playsound(get_turf(src), 'sound/abnormalities/mountain/level_down.ogg', 75, 1)
	maxHealth -= 500
	phase -= 1
	icon_living = "mosb_breach"
	if(phase == 1)
		icon = 'ModularTegustation/Teguicons/64x64.dmi'
		pixel_x = -16
		base_pixel_x = -16
		speed = 2
		move_to_delay = 2
	if(phase == 2)
		icon = 'ModularTegustation/Teguicons/96x96.dmi'
		pixel_x = -32
		base_pixel_x = -32
		speed = 3
		move_to_delay = 4
	icon_state = icon_living
	adjustHealth(-maxHealth)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/mountain/proc/Scream()
	if(scream_cooldown > world.time)
		return
	scream_cooldown = world.time + scream_cooldown_time
	visible_message("<span class='danger'>[src] screams wildly!</span>")
	new /obj/effect/temp_visual/voidout(get_turf(src))
	playsound(get_turf(src), 'sound/abnormalities/mountain/scream.ogg', 75, 1, 5)
	for(var/mob/living/L in view(7, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(scream_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/abnormality/mountain/proc/Slam(range)
	if(slam_cooldown > world.time)
		return
	slam_cooldown = world.time + slam_cooldown_time
	visible_message("<span class='danger'>[src] slams on the ground!</span>")
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, 1)
	for(var/turf/open/T in view(2, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.apply_damage(slam_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/abnormality/mountain/proc/Spit(atom/target)
	if(spit_cooldown > world.time)
		return
	finishing = TRUE
	visible_message("<span class='danger'>[src] prepares to spit an acidic substance at [target]!</span>")
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

/mob/living/simple_animal/hostile/abnormality/mountain/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/mountain/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.health < 0)
		datum_reference.qliphoth_change(-1)
	if(agent_hurt)
		datum_reference.qliphoth_change(-1)
		agent_hurt = FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mountain/attempt_work(mob/living/carbon/human/user, work_type)
	if(user.health != user.maxHealth)
		agent_hurt = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/mountain/breach_effect(mob/living/carbon/human/user)
	..()
	GiveTarget(user)
	icon_living = "mosb_breach"
	icon_state = icon_living
