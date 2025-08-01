// 6 Peccatulum for dawn
/mob/living/simple_animal/hostile/ordeal/sin_sloth
	name = "Peccatulum Acediae"
	desc = "It resembles a rock."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "slothsin"
	icon_living = "slothsin"
	icon_dead = "slothsin_dead"
	faction = list("brown_ordeal")
	maxHealth = 100
	health = 100
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/brown/rock_attack.ogg'
	death_sound = 'sound/effects/ordeals/brown/rock_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	ranged = TRUE
	move_to_delay = 8
	var/jump_cooldown_time = 10 SECONDS
	var/jump_cooldown
	var/can_act = TRUE
	var/jump_range = 7
	var/jump_aoe = 1
	var/jump_damage = 20
	var/jump_pixels = 30
	var/jump_tremor = 5
	var/jump_tremor_burst = 10
	var/attack_tremor = 1
	var/attack_tremor_burst = 50

/mob/living/simple_animal/hostile/ordeal/sin_sloth/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	. = ..()
	if(isliving(target))
		var/mob/living/victim = target
		victim.apply_lc_tremor(attack_tremor, attack_tremor_burst)

/mob/living/simple_animal/hostile/ordeal/sin_sloth/OpenFire()
	if(!target)
		return
	Dash(target)

/mob/living/simple_animal/hostile/ordeal/sin_sloth/Move()
	if(!can_act)
		return FALSE
	. = ..()
	if(.)
		DoMoveAnimation()

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/DoMoveAnimation()
	var/para = TRUE
	if(dir in list(WEST, NORTHWEST, SOUTHWEST))
		para = FALSE
	SpinAnimation(6, 1, para)

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/Dash(mob/living/target)
	if(!istype(target))
		return
	var/dist = get_dist(target, src)
	if(dist > 2 && jump_cooldown < world.time && dist < jump_range)
		can_act = FALSE
		var/list/dash_line = getline(src, target)
		animate(src, pixel_y = (base_pixel_y + jump_pixels), time = 2)
		playsound(src, 'sound/effects/ordeals/brown/rock_kill.ogg', 50, FALSE, 4)
		for(var/turf/line_turf in dash_line) //checks if there's a valid path between the turf and the target
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				break
			forceMove(line_turf)
			SLEEP_CHECK_DEATH(0.4)
		addtimer(CALLBACK(src, PROC_REF(AnimateBack)), 8)
		SLEEP_CHECK_DEATH(10)
		for(var/turf/T in view(jump_aoe, src))
			new /obj/effect/temp_visual/mustardgas(T)
			for(var/mob/living/L in T)
				if(faction_check_mob(L))
					continue
				L.deal_damage(jump_damage, RED_DAMAGE)
				if(L.health < 0)
					L.gib()
					continue
				L.apply_lc_tremor(jump_tremor, jump_tremor_burst)
			for(var/obj/vehicle/sealed/mecha/V in T)
				V.take_damage(jump_damage, RED_DAMAGE)
		can_act = TRUE
		jump_cooldown = world.time + jump_cooldown_time


/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/AnimateBack()
	animate(src, pixel_y = base_pixel_y, time = 2)
	return TRUE

/mob/living/simple_animal/hostile/ordeal/sin_gluttony
	name = "Peccatulum Gulae"
	desc = "These \"plants\" have gnashing and gnawing mouths, resembling a rabid beast."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "gluttonysin"
	icon_living = "gluttonysin"
	icon_dead = "gluttonysin_dead"
	faction = list("brown_ordeal")
	maxHealth = 80
	health = 80
	melee_damage_type = RED_DAMAGE
	rapid_melee = 3
	melee_damage_lower = 2
	melee_damage_upper = 4
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/brown/flower_attack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	stat_attack = DEAD
	var/rupture_damage = 2
	var/dismember_probability = 20

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && isliving(attacked_target) && SSmaptype.maptype != "limbus_labs")
		var/mob/living/L = attacked_target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
				return
			new /obj/effect/temp_visual/damage_effect/rupture(get_turf(L))
			L.deal_damage(rupture_damage, BRUTE)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/proc/devour(mob/living/L)
	if(!L)
		return
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	adjustBruteLoss(-(maxHealth/2))
	playsound(get_turf(L), 'sound/effects/ordeals/brown/flower_kill.ogg', 50, 4)
	if(!iscarbon(L))
		L.gib()
		return
	var/mob/living/carbon/C = L
	for(var/obj/item/bodypart/part in C.bodyparts)
		if(part.dismemberable && prob(dismember_probability) && part.body_part != CHEST && C.stat == DEAD)
			part.dismember()
			QDEL_NULL(part)
			new /obj/effect/gibspawner/generic/silent(get_turf(C))
		if(length(C.bodyparts) <= 1)
			C.gib()
			return
	return

/mob/living/simple_animal/hostile/ordeal/sin_gloom
	name = "Peccatulum Morositatis"
	desc = "An insect-like entity with a transparant body."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	pixel_x = -8
	base_pixel_x = -8
	icon_state = "gloomsin"
	icon_living = "gloomsin"
	icon_dead = "gloomsin_dead"
	faction = list("brown_ordeal")
	maxHealth = 100
	health = 100
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 25
	melee_damage_upper = 35
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/brown/flea_attack.ogg'
	death_sound = 'sound/effects/ordeals/brown/flea_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	is_flying_animal = TRUE
	ranged = TRUE
	ranged_cooldown_time = 5 SECONDS // Fires a laser dealing 10 white damage
	minimum_distance = 2 // Don't move all the way to melee
	projectiletype = /obj/projectile/beam/water_jet
	projectilesound = 'sound/effects/ordeals/brown/flea_attack.ogg'
	var/can_act = TRUE
	var/sinking_damage = 10

/mob/living/simple_animal/hostile/ordeal/sin_gloom/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_gloom/OpenFire()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_gloom/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	. = AreaAttack()

/mob/living/simple_animal/hostile/ordeal/sin_gloom/proc/AreaAttack()
	set waitfor = FALSE
	changeNext_move(SSnpcpool.wait / rapid_melee) //Prevents attack spam
	animate(src, transform = matrix()*1.4, time = 16)
	addtimer(CALLBACK(src, PROC_REF(AnimateBack)), 16)
	can_act = FALSE
	SLEEP_CHECK_DEATH(16)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*1.6, time = 5)
	visible_message(span_danger("[src] suddenly explodes!"))
	playsound(loc, 'sound/abnormalities/ichthys/hardslap.ogg', 60, TRUE)
	var/damage_dealt = rand(melee_damage_lower, melee_damage_upper)
	for(var/turf/T in view(2, src))
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

/mob/living/simple_animal/hostile/ordeal/sin_gloom/proc/AnimateBack()
	animate(src, transform = matrix(), time = 0)
	return TRUE

/mob/living/simple_animal/hostile/ordeal/sin_pride
	name = "Peccatulum Superbiae"
	desc = "Those spikes look sharp!"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	pixel_x = -8
	base_pixel_x = -8
	icon_state = "pridesin"
	icon_living = "pridesin"
	icon_dead = "pridesin_dead"
	faction = list("brown_ordeal")
	maxHealth = 60
	health = 60
	melee_damage_type = BLACK_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 7
	melee_damage_upper = 14
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/ego/sword1.ogg'
	death_sound = 'sound/effects/ordeals/brown/dead_generic.ogg'
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	ranged = TRUE
	var/charging = FALSE
	var/dash_num = 25
	var/extra_dash_distance = 3
	var/dash_cooldown = 0
	var/dash_cooldown_time = 6 SECONDS
	var/dash_damage = 40
	var/dash_range = 1
	var/list/been_hit = list() // Don't get hit twice.
	var/charging_icon = "pridesin_charge"

/mob/living/simple_animal/hostile/ordeal/sin_pride/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_pride/AttackingTarget(atom/attacked_target)
	if(charging)
		return
	if(dash_cooldown <= world.time && prob(10) && !client)
		PrepCharge(attacked_target)
		return
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.health < 0)
		if(SSmaptype.maptype != "limbus_labs")
			H.gib()
		playsound(src, 'sound/weapons/fixer/generic/blade4.ogg', 75, 1)
	return

/mob/living/simple_animal/hostile/ordeal/sin_pride/OpenFire()
	if(dash_cooldown <= world.time)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			PrepCharge(target)

//Dash Code
/mob/living/simple_animal/hostile/ordeal/sin_pride/proc/PrepCharge(target)
	if(charging || dash_cooldown > world.time)
		return
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	SpinAnimation(3, 10)
	dash_num = (get_dist(src, target) + extra_dash_distance)
	addtimer(CALLBACK(src, PROC_REF(Charge), dir_to_target, 0), 2 SECONDS)
	playsound(src, 'sound/effects/ordeals/brown/pridespin.ogg', 125, FALSE)
	if(charging_icon)
		icon_state = charging_icon

/mob/living/simple_animal/hostile/ordeal/sin_pride/proc/Charge(move_dir, times_ran)
	if(health <= 0)
		return
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
	for(var/obj/machinery/door/poddoor/P in T.contents)//FIXME: Still opens the "poddoor" secure shutters
		stop_charge = TRUE
		continue
	if(stop_charge)
		charging = FALSE
		icon_state = icon_living
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			D.open(2)
	forceMove(T)
	playsound(src, 'sound/weapons/fixer/generic/blade1.ogg', 100, 1)
	for(var/turf/TF in range(dash_range, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(dash_range, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		L.visible_message(span_warning("[src] shreds [L] as it passes by!"), span_boldwarning("[src] shreds you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		L.apply_damage(dash_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		been_hit += L
		playsound(L, 'sound/weapons/fixer/generic/sword4.ogg', 75, 1)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.health < 0)
			H.gib()
			playsound(src, 'sound/weapons/fixer/generic/blade4.ogg', 75, 1)
	addtimer(CALLBACK(src, PROC_REF(Charge), move_dir, (times_ran + 1)), 1)

/mob/living/simple_animal/hostile/ordeal/sin_lust //Tank that is resistant to bullets
	name = "Peccatulum Luxuriae"
	desc = "A creature made of lumps of flesh. It looks eagar to devour human flesh."
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	icon_state = "lustsin"
	icon_living = "lustsin"
	icon_dead = "lustsin_dead"
	pixel_x = -16
	base_pixel_x = -16
	faction = list("brown_ordeal")
	maxHealth = 200
	health = 200
	speed = 3
	move_to_delay = 8
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/brown/cromer_slam.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	ranged = TRUE
	var/block_chance = 10
	var/can_act = TRUE
	var/ability_damage = 25
	var/ability_cooldown
	var/ability_cooldown_time = 6 SECONDS
	var/bleed_stacks = 5
	var/ability_range = 3
	var/ability_delay = 0.5 SECONDS

/mob/living/simple_animal/hostile/ordeal/sin_lust/Initialize()
	. = ..()
	AddComponent(/datum/component/knockback, 2, FALSE, TRUE)

/mob/living/simple_animal/hostile/ordeal/sin_lust/bullet_act(obj/projectile/P)
	if(prob(25))
		visible_message(span_userdanger("[P] is blocked by [src]!"))
		P.Destroy()
	return

/mob/living/simple_animal/hostile/ordeal/sin_lust/attacked_by(obj/item/I, mob/living/user)
	var/checkdir = check_target_facings(user, src)
	if((get_dist(user, src) > 1) || checkdir == FACING_EACHOTHER)
		if(prob(block_chance))
			user.visible_message(span_danger("[user]'s attack is easily deflected by [src]!"), span_userdanger("Your attack is easily deflected by [src]!"))
			return
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_lust/face_atom() // important for directional blocking
	if(!can_act)
		return
	..()

/mob/living/simple_animal/hostile/ordeal/sin_lust/Move()
	if(!can_act)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/ordeal/sin_lust/OpenFire()
	if(!can_act)
		return
	if(get_dist(get_turf(src), get_turf(target)) > (ability_range - 1))
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	dir = dir_to_target
	RangedAbility(target)

/mob/living/simple_animal/hostile/ordeal/sin_lust/proc/RangedAbility(atom/target)
	if(!can_act)
		return
	if(world.time < ability_cooldown)
		return
	can_act = FALSE
	ability_cooldown = world.time + ability_cooldown_time
	var/turf/T = get_ranged_target_turf_direct(src, get_turf(target), ability_range, rand(-10,10))
	var/list/turf_list = list()
	playsound(src, 'sound/weapons/ego/censored2.ogg', 50, FALSE, 5)
	for(var/turf/TT in getline(src, T))
		if(TT.density)
			break
		new /obj/effect/temp_visual/cult/sparks(TT)
		turf_list += TT
		T = TT
	if(!LAZYLEN(turf_list))
		can_act = TRUE
		return
	for(var/i = 1 to 3)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		D.alpha = 100
		D.pixel_x = base_pixel_x + rand(-8, 8)
		D.pixel_y = base_pixel_y + rand(-8, 8)
		animate(D, alpha = 0, transform = matrix()*1.2, time = 8)
		SLEEP_CHECK_DEATH(0.15 SECONDS)
	SLEEP_CHECK_DEATH(ability_delay)
	Beam(T, "tentacle", time = 10)
	playsound(src, 'sound/weapons/ego/censored1.ogg', 75, FALSE, 5)
	for(var/turf/TT in turf_list)
		for(var/mob/living/L in HurtInTurf(TT, list(), ability_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
			L.apply_lc_bleed(15)
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/sin_wrath
	name = "Peccatulum Irae"
	desc = "Looks like some sort of dried tentacle with glowing red liquid inside."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "wrathsin"
	icon_living = "wrathsin"
	icon_dead = "wrathsin_dead"
	pixel_x = -8
	base_pixel_x = -8
	faction = list("brown_ordeal")
	maxHealth = 80
	health = 80
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 2
	melee_damage_upper = 6
	melee_reach = 3 // Will try to attack from this distance
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/brown/tentacle_attack.ogg'
	death_sound = 'sound/effects/ordeals/brown/dead_generic.ogg'
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	var/burn_stacks = 5
	var/charge_ready = TRUE
	var/charging
	var/revving_charge = FALSE
	var/charge_damage = 30
	var/charge_attack_cooldown = 0
	var/charge_attack_cooldown_time = 1 SECONDS
	var/charge_attack_delay = 10
	var/charging_speed = 0.6

/mob/living/simple_animal/hostile/ordeal/sin_wrath/AttackingTarget(atom/attacked_target)
	if(revving_charge || charging)
		return
	if(charge_attack_cooldown <= world.time && charge_ready && !attacked_target.Adjacent(targets_from))
		Charge(chargeat = attacked_target, delay = (charge_attack_delay))
		return
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	H.apply_lc_burn(burn_stacks)

/mob/living/simple_animal/hostile/ordeal/sin_wrath/Goto(target, delay, minimum_distance)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_wrath/MoveToTarget(list/possible_targets)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_wrath/Move()
	if(revving_charge)
		return FALSE
	if(charging)
		DestroySurroundings() //to break tables ssin the way
	return ..()

//charge code
/mob/living/simple_animal/hostile/ordeal/sin_wrath/proc/Charge(atom/chargeat = target, delay = 1 SECONDS, chargepast = 2)
	if(stat == DEAD)
		return
	if(charge_attack_cooldown > world.time || charging || revving_charge)
		return
	if(!chargeat)
		return
	face_atom(chargeat)
	var/turf/T = get_ranged_target_turf(chargeat, dir, chargepast)
	if(!T)
		return
	var/turf/chargeturf = get_turf(chargeat)
	if(chargeturf) //for some reason this can end up being null
		new /obj/effect/temp_visual/cult/sparks(chargeturf) //in case the big effect is behind a wall
	revving_charge = TRUE
	charge_ready = FALSE
	walk(src, 0)
	playsound(src, 'sound/effects/ordeals/brown/tentacle_before_explode.ogg', 150, 1)
	SLEEP_CHECK_DEATH(delay)
	if(!revving_charge) //to end charges prematurely
		return
	charging = TRUE
	revving_charge = FALSE
	walk_towards(src, T, charging_speed)
	SLEEP_CHECK_DEATH(get_dist(src, T) * charging_speed)
	EndCharge()

/mob/living/simple_animal/hostile/ordeal/sin_wrath/proc/EndCharge(bump = FALSE)
	if(!charging)
		return
	charging = FALSE
	revving_charge = FALSE
	walk(src, 0) // cancel the movement
	ResetCharge()

/mob/living/simple_animal/hostile/ordeal/sin_wrath/proc/ResetCharge()
	charge_attack_cooldown = world.time + charge_attack_cooldown_time
	charge_ready = TRUE //redundancy is good

/mob/living/simple_animal/hostile/ordeal/sin_wrath/Bump(atom/A)
	if(charging)
		if(isliving(A))
			var/mob/living/L = A
			if(!faction_check_mob(L))
				do_attack_animation(L, ATTACK_EFFECT_SLASH)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					H.apply_lc_burn(burn_stacks)
				L.deal_damage(charge_damage, RED_DAMAGE)
				if(L.health < 0)
					L.gib()
					playsound(src, 'sound/effects/ordeals/brown/tentacle_explode.ogg', 75, 1)
				else
					playsound(src, attack_sound, 125, 1)
				EndCharge(TRUE)
				ResetCharge()
		else if(isvehicle(A))
			var/obj/vehicle/V = A
			V.take_damage(charge_damage*1.5, RED_DAMAGE)
			for(var/mob/living/occupant in V.occupants)
				to_chat(occupant, span_userdanger("Your [V.name] is bit by [src]!"))
			EndCharge(FALSE)
	return ..()
