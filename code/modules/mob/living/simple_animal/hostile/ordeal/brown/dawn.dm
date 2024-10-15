// 6 Peccatulum for dawn
/mob/living/simple_animal/hostile/ordeal/sin_sloth
	name = "Peccatulum Acediae"
	desc = "It resembles a rock."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sinrock"
	icon_living = "sinrock"
	icon_dead = "sin_dead"
	faction = list("brown_ordeal")
	maxHealth = 200
	health = 200
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 24
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/brown/rock_attack.ogg'
	death_sound = 'sound/effects/ordeals/brown/rock_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/golem = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/golem = 1)
	ranged = TRUE
	var/list/movement_path = list()
	var/list/been_hit = list()
	var/charging = FALSE
	var/charging_cooldown
	var/charging_cooldown_time = 8 SECONDS //apparantly charge is already used in /hostile.dm
	var/charge_damage = 20
	/// Delay between each subsequent move when charging
	var/charge_speed = 1
	/// How many paths do we create between several landmarks?
	var/charge_nodes = 3
	/// Maximum AStar pathfinding distances from one point to another
	var/charge_max_distance = 40
	var/dash_cooldown_time = 15 SECONDS //will dash at people if they get out of range but not too often
	var/dash_cooldown

/mob/living/simple_animal/hostile/ordeal/sin_sloth/Life()
	. = ..()
	if(.)
		if((charging_cooldown <= world.time) && prob(15))
			ChargeStart()

/mob/living/simple_animal/hostile/ordeal/sin_sloth/OpenFire()
	if(!target || charging)
		return
	Dash(target)

/mob/living/simple_animal/hostile/ordeal/sin_sloth/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/Dash(mob/living/target)
	if(!istype(target))
		return
	var/dist = get_dist(target, src)
	if(dist > 2 && dash_cooldown < world.time)
		var/list/dash_line = getline(src, target)
		for(var/turf/line_turf in dash_line) //checks if there's a valid path between the turf and the target
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				break
			forceMove(line_turf)
			SLEEP_CHECK_DEATH(0.8)
		playsound(src, 'sound/effects/ordeals/brown/rock_runover.ogg', 50, FALSE, 4)
		dash_cooldown = world.time + dash_cooldown_time

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/ChargeStart(target)
	if(charging || charging_cooldown > world.time)
		return
	charging = TRUE
	movement_path = list()
	var/list/initial_turfs = GLOB.xeno_spawn.Copy() + GLOB.department_centers.Copy()
	var/list/potential_turfs = list()
	for(var/turf/open/T in initial_turfs)
		if(get_dist(src, T) > 3)
			potential_turfs += T
	for(var/mob/living/L in livinginrange(32, src))
		if(prob(50))
			continue
		if((L.status_flags & GODMODE) || faction_check_mob(L))
			continue
		if(L.stat == DEAD)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.is_working)
				continue
		potential_turfs += get_turf(L)
	var/turf/picking_from = get_turf(src)
	var/turf/path_start = get_turf(src)
	if(target)
		var/turf/open/target_turf = get_turf(target)
		if(istype(target_turf))
			picking_from = target_turf
			potential_turfs |= target_turf
		face_atom(target)
	for(var/i = 1 to charge_nodes)
		if(!LAZYLEN(potential_turfs))
			break
		var/turf/T = get_closest_atom(/turf/open, potential_turfs, picking_from)
		if(!T)
			break
		var/list/our_path = list()
		for(var/o = 1 to 3) // Grand total of 3 retries
			our_path = get_path_to(path_start, T, TYPE_PROC_REF(/turf, Distance_cardinal), charge_max_distance)
			if(islist(our_path) && LAZYLEN(our_path))
				break
			potential_turfs -= T // Couldn't find path to it, don't try again
			if(!LAZYLEN(potential_turfs))
				break
			T = get_closest_atom(/turf/open, potential_turfs, picking_from)
		if(!islist(our_path) || !LAZYLEN(our_path))
			continue
		movement_path += our_path
		picking_from = T
		path_start = T
		potential_turfs -= T
	if(!LAZYLEN(movement_path))
		return FALSE
	playsound(src, 'sound/effects/ordeals/brown/rock_runover.ogg', 50, TRUE, 7)
	for(var/turf/T in movement_path) // Warning before charging
		new /obj/effect/temp_visual/mustardgas(T)
	SLEEP_CHECK_DEATH(18)
	been_hit = list()
	SpinAnimation(3, 10)
	for(var/turf/T in movement_path)
		if(QDELETED(T))
			break
		if(!Adjacent(T))
			break
		ChargeAt(T)
		SLEEP_CHECK_DEATH(charge_speed)
	charging = FALSE
	icon_state = icon_living
	charging_cooldown = world.time + charging_cooldown_time

/mob/living/simple_animal/hostile/ordeal/sin_sloth/proc/ChargeAt(turf/T)
	face_atom(T)
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("teeth")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK (D, TYPE_PROC_REF(/obj/machinery/door, open)))
	forceMove(T)
	if(prob(33))
		playsound(T, 'sound/effects/ordeals/brown/rock_attack.ogg', 10, TRUE, 3)
	for(var/turf/TF in view(1, T))
		new /obj/effect/temp_visual/mustardgas(TF)
		for(var/mob/living/L in TF)
			if(!faction_check_mob(L))
				if(L in been_hit)
					continue
				L.visible_message(span_warning("[src] rams [L]!"), span_boldwarning("[src] rams into you!"))
				L.apply_damage(charge_damage, BLACK_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				new /obj/effect/temp_visual/cleave(get_turf(L))
				playsound(L, 'sound/effects/ordeals/brown/rock_kill.ogg', 50, TRUE)
				if(L.health < 0)
					L.gib()
				if(!QDELETED(L))
					been_hit += L
					if(ishuman(L))
						var/mob/living/carbon/human/H = L
						H.Knockdown(4)

/mob/living/simple_animal/hostile/ordeal/sin_gluttony
	name = "Peccatulum Gulae"
	desc = "These \"plants\" are like a rabid beast!"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sinflower"
	icon_living = "sinflower"
	icon_dead = "sin_dead"
	faction = list("brown_ordeal")
	maxHealth = 150
	health = 150
	melee_damage_type = RED_DAMAGE
	rapid_melee = 3
	melee_damage_lower = 4
	melee_damage_upper = 6
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/brown/flower_attack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1)
	stat_attack = DEAD

/mob/living/simple_animal/hostile/ordeal/sin_gluttony/AttackingTarget()
	. = ..()
	if(. && isliving(target) && SSmaptype.maptype != "limbus_labs")
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
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
		if(part.dismemberable && prob(20) && part.body_part != CHEST && C.stat == DEAD)
			part.dismember()
			QDEL_NULL(part)
			new /obj/effect/gibspawner/generic/silent(get_turf(C))
		if(C.bodyparts.len <= 1)
			C.gib()
			return
	return

/mob/living/simple_animal/hostile/ordeal/sin_gloom
	name = "Peccatulum Morositatis"
	desc = "An insect-like entity with a transparant body."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	pixel_x = -8
	base_pixel_x = -8
	icon_state = "sinflea"
	icon_living = "sinflea"
	icon_dead = "flea_dead"
	faction = list("brown_ordeal")
	maxHealth = 200
	health = 200
	melee_damage_type = WHITE_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 14
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/brown/flea_attack.ogg'
	death_sound = 'sound/effects/ordeals/brown/flea_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/slime = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/slime = 1)
	is_flying_animal = TRUE
	ranged = TRUE
	minimum_distance = 2 // Don't move all the way to melee
	projectiletype = /obj/projectile/beam/water_jet
	projectilesound = 'sound/effects/ordeals/brown/flea_attack.ogg'

/mob/living/simple_animal/hostile/ordeal/sin_gloom/MeleeAction()
	if(health <= maxHealth*0.5 && stat != DEAD)
		walk_to(src, 0)
		animate(src, transform = matrix()*1.8, time = 15)
		addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/sin_gloom/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	playsound(loc, 'sound/effects/ordeals/brown/tentacle_explode.ogg', 60, TRUE)
	new /obj/effect/temp_visual/explosion(get_turf(src))
	for(var/mob/living/L in viewers(2, src))
		L.apply_damage(40, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	animate(src, transform = matrix(), time = 0)
	death()

/mob/living/simple_animal/hostile/ordeal/sin_pride
	name = "Peccatulum Superbiae"
	desc = "Those spikes look sharp!"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	pixel_x = -8
	base_pixel_x = -8
	icon_state = "sinwheel"
	icon_living = "sinwheel"
	icon_dead = "sin_dead"
	faction = list("brown_ordeal")
	maxHealth = 100
	health = 100
	melee_damage_type = RED_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 7
	melee_damage_upper = 14
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/ego/sword1.ogg'
	death_sound = 'sound/effects/ordeals/brown/dead_generic.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/rawcrab = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/rawcrab = 1)
	ranged = TRUE
	var/charging = FALSE
	var/dash_num = 25
	var/dash_cooldown = 0
	var/dash_cooldown_time = 6 SECONDS
	var/dash_damage = 40
	var/list/been_hit = list() // Don't get hit twice.

/mob/living/simple_animal/hostile/ordeal/sin_pride/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/sin_pride/AttackingTarget()
	if(charging)
		return
	if(dash_cooldown <= world.time && prob(10) && !client)
		PrepCharge(target)
		return
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
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
	dash_num = (get_dist(src, target) + 3)
	addtimer(CALLBACK(src, PROC_REF(Charge), dir_to_target, 0), 2 SECONDS)
	playsound(src, 'sound/effects/ordeals/brown/pridespin.ogg', 125, FALSE)

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
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			D.open(2)
	forceMove(T)
	playsound(src, 'sound/weapons/fixer/generic/blade1.ogg', 100, 1)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		L.visible_message(span_warning("[src] shreds [L] as it passes by!"), span_boldwarning("[src] shreds you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		L.apply_damage(dash_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
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
	desc = "It looks like a creature made of lumps of flesh. It looks eagar to devour human flesh."
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	icon_state = "sincromer"
	icon_living = "sincromer"
	icon_dead = "sincromer_dead"
	pixel_x = -16
	base_pixel_x = -16
	faction = list("brown_ordeal")
	maxHealth = 250
	health = 250
	speed = 3
	move_to_delay = 8
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/ordeals/brown/cromer_slam.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/lizard = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/lizard = 1)

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
		if(prob(10))
			user.visible_message(span_danger("[user]'s attack is easily deflected by [src]!"), span_userdanger("Your attack is easily deflected by [src]!"))
			return
	return ..()

#define STATUS_EFFECT_FUMING /datum/status_effect/stacking/fuming
/mob/living/simple_animal/hostile/ordeal/sin_wrath //High damage dealer capable of blowing up humans
	name = "Peccatulum Irae"
	desc = "Looks like some sort of dried tentacle with bits of red liquid inside."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "sintentacle"
	icon_living = "sintentacle"
	icon_dead = "sin_dead"
	pixel_x = -8
	base_pixel_x = -8
	faction = list("brown_ordeal")
	maxHealth = 150
	health = 150
	melee_damage_type = RED_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 2
	melee_damage_upper = 6
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/brown/tentacle_attack.ogg'
	death_sound = 'sound/effects/ordeals/brown/dead_generic.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/carpmeat/icantbeliveitsnotcarp = 1)
	guaranteed_butcher_results = list(/obj/item/food/carpmeat/icantbeliveitsnotcarp = 1) //should make its own kind of meat when I get around to it

/mob/living/simple_animal/hostile/ordeal/sin_wrath/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	var/datum/status_effect/stacking/fuming/F = H.has_status_effect(/datum/status_effect/stacking/fuming)
	if(!F)
		to_chat(H, span_userdanger("You start to feel overcome with rage!"))
		H.apply_status_effect(STATUS_EFFECT_FUMING)
	else
		to_chat(H, span_userdanger("You feel angrier!!"))
		F.add_stacks(1)
		F.refresh()
	return

/datum/status_effect/stacking/fuming
	id = "stacking_fuming"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/fuming
	duration = 30 SECONDS
	stack_decay = 0
	stacks = 1
	stack_threshold = 0
	max_stacks = 20
	consumed_on_threshold = FALSE
	var/exploding

/atom/movable/screen/alert/status_effect/fuming
	name = "Fuming Wrath"
	desc = "You feel so angry that your head might explode! You take additional BURN damage whenever you are hurt, which is reduced by WHITE armor."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "sin_wrath"

/datum/status_effect/stacking/fuming/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(DealBurn))

/datum/status_effect/stacking/fuming/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)

/datum/status_effect/stacking/fuming/add_stacks(stacks_added)
	..()
	linked_alert.desc = initial(linked_alert.desc)+"\nYou are recieving [stacks * 10]% of damage taken as extra burn damage."

/datum/status_effect/stacking/fuming/proc/DealBurn(mob/living/carbon/human/owner, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	if(damagetype == BURN)
		return
	var/damage_amt = ((damage/100) * (stacks * 10)) //10-200% of damage taken is dealt as additional burn
	H.apply_damage(damage_amt, BURN, blocked = H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE) //Damage reduced by white armor

#undef STATUS_EFFECT_FUMING
