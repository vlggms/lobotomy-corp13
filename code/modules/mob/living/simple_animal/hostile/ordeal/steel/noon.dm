//More Mutated Subtype of Dawns, they are fast and hit faster.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon
	name = "gene corp corporal"
	desc = "A heavily mutated employee with two sharp insectoid arms. Gene corp utilized those who have had a more volitile reaction to the treatment as shock troops during the smoke war."
	icon_state = "gcorp5"
	icon_living = "gcorp5"
	icon_dead = "gcorp_corpse2"
	death_message = "salutes weakly before falling."
	maxHealth = 1000	//Effectively have 750 HP
	health = 1000		//Effectively have 750 HP
	rapid_melee = 2
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	death_sound = 'sound/voice/mook_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/buggy = 2)
	silk_results = list(/obj/item/stack/sheet/silk/steel_simple = 2, /obj/item/stack/sheet/silk/steel_advanced = 1)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/AttackingTarget(atom/attacked_target)
	adjustBruteLoss(-10)
	if(health <= maxHealth * 0.25 && stat != DEAD && prob(75))
		walk_to(src, 0)
		say("FOR G CORP!!!")
		animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
		addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	new /obj/effect/temp_visual/explosion(get_turf(src))
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
	for(var/mob/living/L in ohearers(3, src))
		L.apply_damage(60, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))

	//Buff allies, all of these buffs only activate once.
	//Buff the grunts around you when you die
	for(var/mob/living/simple_animal/hostile/ordeal/steel_dawn/Y in ohearers(7, src))
		if(Y.stat >= UNCONSCIOUS)
			continue
		Y.say("FOR G CORP!!!")

		//increase damage
		Y.melee_damage_lower = 18
		Y.melee_damage_upper = 22
		//And heal 50%
		Y.adjustBruteLoss(-maxHealth*0.5)

	//And any manager
	for(var/mob/living/simple_animal/hostile/ordeal/steel_dusk/Z in ohearers(7, src))
		if(Z.stat >= UNCONSCIOUS)
			continue
		Z.say("There will be full-on roll call tonight.")
		Z.screech_windup = 3 SECONDS

	gib()

//flying varient trades movement and attack speed for a sweeping attack.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying
	name = "gene corp arial scout"
	desc = "A heavily mutated employee with wings and long insectoid arms. During the smoke war, rabbit teams would get ambushed by swarms that hid in the smoke choked sky."
	icon_state = "gcorp6"
	icon_living = "gcorp6"
	environment_smash = FALSE
	is_flying_animal = TRUE
	footstep_type = null
	rapid_melee = 1
	ranged = TRUE
	ranged_cooldown_time = 15 SECONDS
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	buffed = FALSE
	move_to_delay = 3
	var/charging = FALSE

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/Move()
	if(buffed && !charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/AttackingTarget(atom/attacked_target)
	if(ranged_cooldown <= world.time && prob(30))
		if(!target)
			GiveTarget(attacked_target)
		OpenFire()
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/CanAllowThrough(atom/movable/mover, turf/target)
	if(charging && isliving(mover))
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/Shoot(atom/A)
	if(buffed || !isliving(A))
		return FALSE
	animate(src, alpha = alpha - 50, pixel_y = base_pixel_y + 25, layer = 6, time = 10)
	buffed = TRUE
	density = FALSE
	if(do_after(src, 2 SECONDS, target = src))
		ArialSupport()
	else
		visible_message(span_notice("[src] crashes to the ground."))
		apply_damage(100, RED_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	//return to the ground
	density = TRUE
	layer = initial(layer)
	buffed = FALSE
	alpha = initial(alpha)
	pixel_y = initial(pixel_y)
	base_pixel_y = initial(base_pixel_y)

	//from current location fly to the enemy and hit them. Utilizes some little helper abnormality code. Later on i should make them less accurate.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/ArialSupport()
	charging = TRUE
	var/turf/target_turf = get_turf(target)
	for(var/i=0 to 7)
		var/turf/wallcheck = get_step(src, get_dir(src, target_turf))
		if(!ClearSky(wallcheck))
			break
		var/mob/living/sweeptarget = locate(target) in wallcheck
		if(sweeptarget)
			SweepAttack(sweeptarget)
			break
		forceMove(wallcheck)
		SLEEP_CHECK_DEATH(0.5)
	charging = FALSE

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/SweepAttack(mob/living/sweeptarget)
	sweeptarget.visible_message(span_danger("[src] slams into [sweeptarget]!"), span_userdanger("[src] slams into you!"))
	sweeptarget.apply_damage(30, RED_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 50, TRUE)
	if(sweeptarget.mob_size <= MOB_SIZE_HUMAN)
		DoKnockback(sweeptarget, src, get_dir(src, sweeptarget))
		shake_camera(sweeptarget, 4, 3)
		shake_camera(src, 2, 3)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/DoKnockback(atom/target, mob/thrower, throw_dir) //stolen from the knockback component since this happens only once
	if(!ismovable(target) || throw_dir == null)
		return
	var/atom/movable/throwee = target
	if(throwee.anchored)
		return
	if(QDELETED(throwee))
		return
	var/atom/throw_target = get_edge_target_turf(throwee, throw_dir)
	throwee.safe_throw_at(throw_target, 1, 1, thrower, gentle = TRUE)
