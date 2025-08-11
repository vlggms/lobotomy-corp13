/mob/living/simple_animal/hostile/ordeal/sin_sloth/noon
	name = "Peccatulum Acediae?"
	desc = "Now the rock has more rocks."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	maxHealth = 250
	health = 250
	melee_damage_lower = 6
	melee_damage_upper = 8
	melee_reach = 2 // Now it has reach attacks
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	move_to_delay = 6
	jump_aoe = 3
	jump_damage = 15
	jump_pixels = 8
	jump_tremor = 10
	attack_tremor = 2
	attack_tremor_burst = 30

/mob/living/simple_animal/hostile/ordeal/sin_sloth/noon/DoMoveAnimation()
	do_attack_animation(get_step(src, dir), no_effect = TRUE)

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon
	name = "Peccatulum Gulae?"
	desc = "Giant, hungry looking flowers. Is that blood?"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	maxHealth = 200
	health = 200
	melee_damage_lower = 4
	melee_damage_upper = 6
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	rupture_damage = 3
	dismember_probability = 100
	var/mob/living/carbon/human/grab_victim = null
	var/can_act = TRUE
	var/release_threshold = 60 //Total raw damage needed to break a player out of a grab (from any source)
	var/release_damage = 0
	var/grab_progress = 0

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	. = ..()
	if(ishuman(attacked_target))
		if(grab_progress > 5)
			GrabAttack(attacked_target)
			grab_progress = 0
			return
		grab_progress += 1

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/proc/GrabAttack(mob/living/carbon/human/victim)
	if(!istype(victim))
		return
	grab_victim = victim
	Strangle()
	can_act = FALSE

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/proc/Strangle()
	set waitfor = FALSE
	release_damage = 0
	grab_victim.Immobilize(10)
	if(grab_victim.sanity_lost)
		grab_victim.Stun(10) //Immobilize does not stop AI controllers from moving, for some reason.
	grab_victim.forceMove(get_turf(src))
	animate(grab_victim, alpha = 0, time = 2)
	SLEEP_CHECK_DEATH(5)
	to_chat(grab_victim, span_userdanger("[src] has grabbed you! Attack [src] to break free!"))
	StrangleHit(1)

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/proc/StrangleHit(count)
	if(!grab_victim)
		ReleaseGrab()
		return
	if(grab_victim.health < 0)
		grab_victim.gib()
		ReleaseGrab()
		return
	do_attack_animation(get_step(src, dir), no_effect = TRUE)
	grab_victim.deal_damage(melee_damage_upper, RED_DAMAGE)
	new /obj/effect/temp_visual/damage_effect/rupture(get_turf(src))
	grab_victim.deal_damage(rupture_damage, BRUTE)
	grab_victim.Immobilize(10)
	playsound(get_turf(src), 'sound/effects/ordeals/brown/flower_attack.ogg', 50, 0, 7)
	playsound(get_turf(src), 'sound/effects/ordeals/brown/flower_kill.ogg', 50, 0, 7)
	switch(count)
		if(0 to 3)
			playsound(get_turf(src), 'sound/effects/wounds/crack1.ogg', 200, 0, 7)
			to_chat(grab_victim, span_userdanger("You are being devoured!"))
		if(4)	//Apply double damage
			playsound(get_turf(src), 'sound/effects/wounds/crackandbleed.ogg', 200, 0, 7)
			to_chat(grab_victim, span_userdanger("It hurts so much!"))
			grab_victim.deal_damage(rupture_damage, BRUTE)
		else	//Apply ramping damage
			playsound(get_turf(src), 'sound/effects/wounds/crackandbleed.ogg', 200, 0, 7)
			grab_victim.deal_damage((rupture_damage * (3 - count)), BRUTE)
	count += 1
	if(grab_victim.sanity_lost) //This should prevent weird things like panics running away halfway through
		grab_victim.Stun(10) //Immobilize does not stop AI controllers from moving, for some reason.
	SLEEP_CHECK_DEATH(10)
	StrangleHit(count)

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/proc/ReleaseGrab()
	if(grab_victim)
		animate(grab_victim, alpha = 255, time = 2)
	grab_victim = null
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/death(gibbed)
	ReleaseGrab()
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(grab_victim)
		release_damage = clamp(release_damage + damage, 0, release_threshold)
		if(release_damage >= release_threshold)
			ReleaseGrab()

/mob/living/simple_animal/hostile/ordeal/sin_gloom/noon
	name = "Peccatulum Morositatis?"
	desc = "A large, translucent monster full of organs. It that throws around its weight like a hammer."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	maxHealth = 250
	health = 250
	melee_damage_lower = 14
	melee_damage_upper = 16
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	ranged_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/ordeal/sin_gloom/noon/OpenFire()
	if(!can_act || !istype(target))
		return
	var/dist = get_dist(target, src)
	if(dist < 6)
		var/list/dash_line = getline(src, target)
		playsound(src, 'sound/weapons/fixer/generic/dodge2.ogg', 75, FALSE, 4)
		for(var/turf/line_turf in dash_line) //checks if there's a valid path between the turf and the target
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				break
			forceMove(line_turf)
		addtimer(CALLBACK(src, PROC_REF(AreaAttack)), 5)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/ordeal/sin_gloom/noon/AreaAttack()
	set waitfor = FALSE
	changeNext_move(SSnpcpool.wait / rapid_melee) //Prevents attack spam
	if(!can_act)
		return
	playsound(loc, 'sound/weapons/fixer/generic/dodge.ogg', 60, TRUE)
	do_attack_animation(get_step(src, dir), no_effect = TRUE)
	can_act = FALSE
	SLEEP_CHECK_DEATH(18)
	playsound(loc, 'sound/abnormalities/ichthys/hammer1.ogg', 60, TRUE)
	do_attack_animation(get_step(src, dir), no_effect = TRUE)
	var/damage_dealt = rand(melee_damage_lower, melee_damage_upper)
	for(var/turf/T in view(3, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			L.deal_damage(damage_dealt, melee_damage_type)
			new /obj/effect/temp_visual/damage_effect/sinking(get_turf(L))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.adjustSanityLoss(sinking_damage)
			else
				L.deal_damage(sinking_damage, WHITE_DAMAGE)
		for(var/obj/vehicle/sealed/mecha/V in T)
			V.take_damage(damage_dealt, melee_damage_type)
	SLEEP_CHECK_DEATH(8)
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/sin_pride/noon
	name = "Peccatulum Superbiae?"
	desc = "A spiky wheel with hands resembling claws."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	icon_dead = "pridesin_dead"
	maxHealth = 150
	health = 150
	rapid_melee = 3
	move_to_delay = 5
	melee_damage_lower = 3
	melee_damage_upper = 5
	melee_reach = 2
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	dash_cooldown_time = 4 SECONDS
	extra_dash_distance = 6
	dash_damage = 20
	dash_range = 2

/mob/living/simple_animal/hostile/ordeal/sin_lust/noon
	name = "Peccatulum Luxuriae?"
	desc = "A creature that holds up its face like a shield. Its flesh is disgustingly soft, like rotten fruit."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	maxHealth = 300
	health = 300
	move_to_delay = 10
	melee_damage_lower = 8
	melee_damage_upper = 10
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	block_chance = 50
	bleed_stacks = 10
	ability_damage = 15
	ability_range = 10
	ability_cooldown_time = 3 SECONDS
	ability_delay = 0.3 SECONDS

/mob/living/simple_animal/hostile/ordeal/sin_wrath/noon
	name = "Peccatulum Irae?"
	desc = "A much bigger version of that tentacle peccatula, now it has a tail."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 200
	health = 200
	melee_damage_lower = 4
	melee_damage_upper = 8
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	burn_stacks = 10
	charge_damage = 12
	charge_attack_delay = 7
	charging_speed = 0.8

/mob/living/simple_animal/hostile/ordeal/sin_wrath/noon/EndCharge(bump = FALSE)
	. = ..()
	var/turf/T = get_turf(src)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L.z != z)
			continue
		visible_message(span_boldwarning("[src] slams [L]!"))
		to_chat(L, span_userdanger("[src] slams you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_lc_burn(floor(burn_stacks * 0.5))
		L.apply_damage(charge_damage * 0.4, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		playsound(L, 'sound/effects/ordeals/brown/cromer_slam.ogg', 75, 1)
