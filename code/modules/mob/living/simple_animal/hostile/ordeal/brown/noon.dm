/mob/living/simple_animal/hostile/ordeal/sin_sloth/noon
	name = "Peccatulum Acediae?"
	desc = "Now the rock has more rocks."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	maxHealth = 750
	health = 750
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_reach = 2 // Now it has reach attacks
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	move_to_delay = 6
	jump_aoe = 3
	jump_damage = 35
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
	maxHealth = 600
	health = 600
	melee_damage_lower = 4
	melee_damage_upper = 8
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	rupture_damage = 4

/mob/living/simple_animal/hostile/ordeal/sin_gloom/noon
	name = "Peccatulum Morositatis?"
	desc = "A large, translucent monster full of organs. It that throws around its weight like a hammer."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	maxHealth = 750
	health = 750
	melee_damage_lower = 55
	melee_damage_upper = 75
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
	maxHealth = 450
	health = 450
	rapid_melee = 3
	move_to_delay = 5
	melee_damage_lower = 3
	melee_damage_upper = 9
	melee_reach = 2
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	dash_cooldown_time = 4 SECONDS
	extra_dash_distance = 6
	dash_damage = 60
	dash_range = 2

/mob/living/simple_animal/hostile/ordeal/sin_lust/noon
	name = "Peccatulum Luxuriae?"
	desc = "A creature that holds up its face like a shield. Its flesh is disgustingly soft, like rotten fruit."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -24
	base_pixel_x = -24
	maxHealth = 900
	health = 900
	move_to_delay = 10
	melee_damage_lower = 20
	melee_damage_upper = 30
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	block_chance = 50
	bleed_stacks = 10
	ability_damage = 50
	ability_range = 10
	ability_cooldown_time = 3 SECONDS
	ability_delay = 0.3 SECONDS

/mob/living/simple_animal/hostile/ordeal/sin_wrath/noon
	name = "Peccatulum Irae?"
	desc = "A much bigger version of that tentacle peccatula, now it has a tail."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 600
	health = 600
	melee_damage_lower = 4
	melee_damage_upper = 12
	melee_reach = 2 // Now it has reach attacks
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 2)
