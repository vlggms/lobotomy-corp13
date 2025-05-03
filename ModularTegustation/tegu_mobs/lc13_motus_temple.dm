//Stone Guard
/mob/living/simple_animal/hostile/clan/stone_guard
	name = "stone statue"
	desc = "A humanoid looking statue wielding a spear... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "stone_guard"
	icon_living = "stone_guard"
	icon_dead = "stone_guard_dead"
	maxHealth = 1000
	health = 1000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	melee_damage_lower = 14
	melee_damage_upper = 18
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/weapons/fixer/generic/spear2.ogg'
	ranged = TRUE
	charge = 5
	max_charge = 30
	clan_charge_cooldown = 0.5 SECONDS
	var/attack_tremor = 3
	var/can_act = TRUE
	var/ability_damage = 40
	var/ability_cooldown
	var/ability_cooldown_time = 10 SECONDS
	var/ability_range = 5
	var/ability_delay = 0.5 SECONDS
	var/stun_duration = 5 SECONDS

/mob/living/simple_animal/hostile/clan/stone_guard/ChargeUpdated()
	if(charge <= 1 && can_act)
		stagger()
	if(charge >= 15)
		ChangeResistances(list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.8))
	else
		ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))
		return

/mob/living/simple_animal/hostile/clan/stone_guard/Move()
	if(!can_act)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/clan/stone_guard/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	. = ..()
	if(isliving(target))
		var/mob/living/victim = target
		victim.apply_lc_tremor(attack_tremor, 55)
	if(world.time > ability_cooldown)
		var/turf/target_turf = get_turf(attacked_target)
		for(var/i = 1 to ability_range - 2)
			target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
		RangedAbility(target_turf)

/mob/living/simple_animal/hostile/clan/stone_guard/OpenFire()
	if(!can_act)
		return
	if(get_dist(get_turf(src), get_turf(target)) > (ability_range - 1))
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	dir = dir_to_target
	RangedAbility(target)

/mob/living/simple_animal/hostile/clan/stone_guard/adjustHealth(amount, updating_health, forced)
	. = ..()
	if(amount > 0 && charge > 0)
		charge -= 1

/mob/living/simple_animal/hostile/clan/stone_guard/proc/stagger()
	can_act = FALSE
	playsound(src, 'sound/weapons/ego/devyat_overclock_death.ogg', 50, FALSE, 5)
	var/mutable_appearance/colored_overlay = mutable_appearance('ModularTegustation/Teguicons/tegumobs.dmi', "small_stagger", layer + 0.1)
	add_overlay(colored_overlay)
	ChangeResistances(list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.6, BLACK_DAMAGE = 2.4, PALE_DAMAGE = 3))
	SLEEP_CHECK_DEATH(stun_duration)
	charge = 15
	ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))
	cut_overlays()
	can_act = TRUE

/mob/living/simple_animal/hostile/clan/stone_guard/proc/RangedAbility(atom/target)
	if(!can_act)
		return
	if(world.time < ability_cooldown)
		return
	can_act = FALSE
	ability_cooldown = world.time + ability_cooldown_time
	var/turf/T = get_ranged_target_turf_direct(src, get_turf(target), ability_range, rand(-10,10))
	var/list/turf_list = list()
	say("Commencing Protocol: Transpierce")
	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, FALSE, 5)
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
	playsound(src, 'sound/weapons/fixer/hana_pierce.ogg', 75, FALSE, 5)
	for(var/turf/TT in turf_list)
		var/obj/effect/temp_visual/thrust/AoE = new(T, COLOR_GRAY)
		var/matrix/M = matrix(AoE.transform)
		M.Turn(Get_Angle(src, T)-90)
		AoE.transform = M
		var/hit_target = FALSE
		for(var/mob/living/L in HurtInTurf(TT, list(), ability_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE))
			hit_target = TRUE
			var/datum/status_effect/stacking/lc_tremor/tremor = L.has_status_effect(/datum/status_effect/stacking/lc_tremor)
			if(tremor)
				tremor.TremorBurst()
		if(!hit_target)
			charge -= 5
			playsound(src, 'sound/weapons/ego/devyat_overclock.ogg', 50, FALSE, 5)
			ChargeUpdated()
	can_act = TRUE

//Mad Fly Swarm
/mob/living/simple_animal/hostile/mad_fly_swarm
	name = "mad fly swarm"
	desc = "A swarm of maddened flies... or are they mosquitoes?"
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "mad_fly_swarm"
	icon_living = "mad_fly_swarm"
	maxHealth = 300
	health = 300
	move_to_delay = 1.6
	faction = list("madfly")
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 2)
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 2
	melee_damage_upper = 4
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg'
	del_on_death = TRUE
	var/mob/living/nesting_target
	var/devouring_cooldown
	var/devouring_cooldown_time = 2 SECONDS

/mob/living/simple_animal/hostile/mad_fly_swarm/Initialize()
	. = ..()
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/mad_fly_swarm/Life()
	. = ..()
	if(world.time < devouring_cooldown)
		return
	devouring_cooldown = world.time + devouring_cooldown_time
	if(nesting_target)
		nesting_target.deal_damage(melee_damage_upper * 2, RED_DAMAGE)
		playsound(get_turf(src), 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg', 50, FALSE, 5)
		nesting_target.visible_message(span_danger("\The [src] devours [nesting_target]'s from the inside!"))

/mob/living/simple_animal/hostile/mad_fly_swarm/AttackingTarget(atom/attacked_target)
	. = ..()
	for(var/i = 1 to 4)
		attacked_target.attack_animal(src)

	var/target_turf = get_turf(attacked_target)
	forceMove(target_turf)
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/L = attacked_target
		if(L.sanity_lost && L.stat != DEAD)
			nesting_target = L
			nesting()

/mob/living/simple_animal/hostile/mad_fly_swarm/proc/nesting()
	if(nesting_target)
		visible_message(span_danger("\The [src] crawls into [nesting_target]'s skin!"))
		forceMove(nesting_target)
		RegisterSignal(nesting_target, COMSIG_LIVING_DEATH, PROC_REF(larva_burst))

/mob/living/simple_animal/hostile/mad_fly_swarm/proc/larva_burst()
	UnregisterSignal(nesting_target, COMSIG_LIVING_DEATH)
	var/target_turf = get_turf(src)
	new /obj/effect/gibspawner/generic(target_turf)
	forceMove(target_turf)
	playsound(get_turf(src), 'sound/abnormalities/fairyfestival/fairyqueen_eat.ogg', 50, FALSE, 5)
	var/fellow_fly = FALSE
	for(var/atom/movable/i in nesting_target.contents)
		if(istype(i, /mob/living/simple_animal/hostile/mad_fly_swarm))
			if(i == src)
				continue
			fellow_fly = TRUE
	if(!fellow_fly)
		visible_message(span_danger("\The [src] crawls out of [nesting_target]'s skin, creating a new nest!"))
		new /mob/living/simple_animal/hostile/mad_fly_nest(target_turf)
	else
		visible_message(span_danger("\The [src] crawls out of [nesting_target]'s skin!"))
	nesting_target = null
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

// Mad Fly Nest
/mob/living/simple_animal/hostile/mad_fly_nest
	name = "strange nest"
	desc = "Made out of some sort of gel like substance... You can see small maggots inside of it."
	icon = 'icons/mob/alien.dmi'
	icon_state = "egg"
	icon_living = "egg"
	icon_dead = "egg_hatched"
	faction = list("madfly")
	gender = NEUTER
	obj_damage = 0
	maxHealth = 1000
	health = 1000
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/xeno = 3)
	death_sound = 'sound/effects/ordeals/crimson/dusk_dead.ogg'
	var/spawn_progress = 10 //spawn ready to produce flies
	var/list/spawned_mobs = list()
	var/producing = FALSE
	var/chem_cooldown_timer
	var/chem_cooldown = 3 MINUTES
	var/chem_type = /datum/reagent/medicine/mental_stabilizator
	var/chem_yield = 5

/mob/living/simple_animal/hostile/mad_fly_nest/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/mad_fly_nest/Move()
	return FALSE

/mob/living/simple_animal/hostile/mad_fly_nest/death(gibbed)
	new /obj/effect/gibspawner/xeno/bodypartless(get_turf(src))
	. = ..()

/mob/living/simple_animal/hostile/mad_fly_nest/examine(mob/user)
	. = ..()
	if(world.time < chem_cooldown_timer)
		. += span_red("[src] is not ready to be harvensted.")
	else
		. += span_nicegreen("[src] is ready to be harvensted.")

/mob/living/simple_animal/hostile/mad_fly_nest/attackby(obj/O, mob/user, params)
	if(!istype(O, /obj/item/reagent_containers))
		return ..()
	if(world.time < chem_cooldown_timer)
		to_chat(user, span_notice("You may need to wait a bit longer."))
		return
	var/obj/item/reagent_containers/my_container = O
	visible_message("[user] starts extracting some reagents from [src]...")
	if(do_after(user, 10 SECONDS, src))
		HarvestChem(my_container, user)

/mob/living/simple_animal/hostile/mad_fly_nest/proc/HarvestChem(obj/item/reagent_containers/C, mob/user)
	visible_message("[user] uses [C] to extract some reagents from [src]")
	if(chem_type)
		C.reagents.add_reagent(chem_type, chem_yield)
	chem_cooldown_timer = world.time + chem_cooldown

/mob/living/simple_animal/hostile/mad_fly_nest/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD || QDELETED(L))
			spawned_mobs -= L
	if(producing)
		return
	if(length(spawned_mobs) >= 2)
		return
	if(spawn_progress < 20)
		spawn_progress += 1
		return
	Produce()

/mob/living/simple_animal/hostile/mad_fly_nest/proc/Produce()
	if(producing || stat == DEAD)
		return
	producing = TRUE
	icon_state = "egg_opening"
	SLEEP_CHECK_DEATH(10)
	visible_message(span_danger("\A new swarm climbs out of [src]!"))
	var/turf/T = get_step(get_turf(src), pick(0, EAST))
	var/mob/living/simple_animal/hostile/mad_fly_swarm/nb = new /mob/living/simple_animal/hostile/mad_fly_swarm(T)
	nb.return_to_origin = TRUE
	spawned_mobs += nb
	SLEEP_CHECK_DEATH(2)
	icon_state = "egg"
	producing = FALSE
	spawn_progress = -5

// Scarlet Rose
/mob/living/simple_animal/hostile/scarlet_rose
	name = "scarlet rose"
	desc = "A single blood red rose, connected to all nearby vines..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "rose_red"
	maxHealth = 1500
	health = 1500
	del_on_death = FALSE
	faction = list("scarletrose")
	gender = NEUTER
	obj_damage = 0
	death_message = "collapses into a pile of plantmatter."
	death_sound = 'sound/creatures/venus_trap_death.ogg'
	attacked_sound = 'sound/creatures/venus_trap_hurt.ogg'
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	initial_language_holder = /datum/language_holder/plant //essentially flavor
	var/vine_range = 10
	var/ability_cooldown
	var/ability_cooldown_time = 4 SECONDS
	//All iterations share this list between eachother.
	var/static/list/vine_list = list()
	var/chem_cooldown_timer
	var/chem_cooldown = 3 MINUTES
	var/chem_type = /datum/reagent/medicine/sal_acid
	var/chem_yield = 15

/mob/living/simple_animal/hostile/scarlet_rose/death(gibbed)
	density = FALSE
	new /obj/item/scarlet_rose(get_turf(src))
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/scarlet_rose/Destroy()
	for(var/obj/structure/spreading/scarlet_vine/vine in vine_list)
		vine.can_expand = FALSE
		var/del_time = rand(4,10) //all the vines dissapear at different interval so it looks more organic.
		animate(vine, alpha = 0, time = del_time SECONDS)
		QDEL_IN(vine, del_time SECONDS)
	vine_list.Cut()
	return ..()

/mob/living/simple_animal/hostile/scarlet_rose/examine(mob/user)
	. = ..()
	if(world.time < chem_cooldown_timer)
		. += span_red("[src] is not ready to be harvensted.")
	else
		. += span_nicegreen("[src] is ready to be harvensted.")

/mob/living/simple_animal/hostile/scarlet_rose/attackby(obj/O, mob/user, params)
	if(!istype(O, /obj/item/reagent_containers))
		return ..()
	if(world.time < chem_cooldown_timer)
		to_chat(user, span_notice("You may need to wait a bit longer."))
		return
	var/obj/item/reagent_containers/my_container = O
	visible_message("[user] starts extracting some reagents from [src]...")
	if(do_after(user, 10 SECONDS, src))
		HarvestChem(my_container, user)

/mob/living/simple_animal/hostile/scarlet_rose/proc/HarvestChem(obj/item/reagent_containers/C, mob/user)
	visible_message("[user] uses [C] to extract some reagents from [src]")
	if(chem_type)
		C.reagents.add_reagent(chem_type, chem_yield)
	chem_cooldown_timer = world.time + chem_cooldown

/mob/living/simple_animal/hostile/scarlet_rose/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/scarlet_rose/Move()
	return FALSE

/mob/living/simple_animal/hostile/scarlet_rose/Life()
	. = ..()
	var/list/area_of_influence
	area_of_influence = urange(vine_range, get_turf(src))
	for(var/obj/structure/spreading/scarlet_vine/W in area_of_influence)
		if(W.last_expand <= world.time)
			W.expand()
		if(ability_cooldown <= world.time)
			var/list/did_we_hit = HurtInTurf(get_turf(W), list(), 10, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
			if(did_we_hit.len)
				W.VineAttack(pick(did_we_hit))
			for(var/mob/living/carbon/human/H in did_we_hit)
				H.apply_lc_bleed(5)
				to_chat(H, span_danger("Scarlet vines cuts into your legs!"))
	if(ability_cooldown <= world.time)
		ability_cooldown = world.time + ability_cooldown_time
	SpreadPlants()

/mob/living/simple_animal/hostile/scarlet_rose/proc/SpreadPlants()
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/structure/spreading/scarlet_vine) in get_turf(src))
		return
	new /obj/structure/spreading/scarlet_vine(loc)

//VINE CODE: stolen alien weed code
/obj/structure/spreading/scarlet_vine
	gender = PLURAL
	name = "scarlet flora"
	desc = "Bloody vines, yearning for blood..."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Med1"
	base_icon_state = "Med1"
	color = "#800000"
	max_integrity = 15
	resistance_flags = FLAMMABLE
	pass_flags_self = LETPASSTHROW
	armor = list(
		MELEE = 0,
		BULLET = 0,
		FIRE = -50,
		RED_DAMAGE = 80,
		WHITE_DAMAGE = 0,
		BLACK_DAMAGE = 40,
		PALE_DAMAGE = -50,
	)
	var/old_growth = FALSE
	/* Number of tries it takes to get through the vines.
		Patrol shuts off if the creature fails to move 5 times. */
	var/tangle = 2
	//Redundant and Ineffecient abnormality teamwork var.
	var/allow_abnopass = FALSE
	//Connected Abnormality.
	var/static/mob/living/simple_animal/hostile/scarlet_rose/connected_rose
	//strictly for crossed proc
	var/list/static/ignore_typecache
	var/list/static/atom_remove_condition


/obj/structure/spreading/scarlet_vine/Initialize()
	. = ..()

	//This is to register a abnormality if we dont have one
	if(!connected_rose)
		for(var/mob/living/simple_animal/hostile/scarlet_rose/R in urange(16, get_turf(src)))
			connected_rose = R
			break
	if(connected_rose)
		connected_rose.vine_list += src

	if(!atom_remove_condition)
		atom_remove_condition = typecacheof(list(
			/obj/projectile/ego_bullet/ego_match,
			/obj/projectile/ego_bullet/ego_warring2,
			/obj/projectile/ego_bullet/flammenwerfer,
			/obj/effect/decal/cleanable/wrath_acid,
			/mob/living/simple_animal/hostile/abnormality/fire_bird,
			/mob/living/simple_animal/hostile/abnormality/helper,
			/mob/living/simple_animal/hostile/abnormality/greed_king,
			/mob/living/simple_animal/hostile/abnormality/dimensional_refraction,
			/mob/living/simple_animal/hostile/abnormality/wrath_servant,
			/obj/vehicle/sealed/mecha,
		))

	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/mob/dead,
			/mob/living/simple_animal/hostile/abnormality/snow_whites_apple,
			/mob/living/simple_animal/hostile/abnormality/golden_apple,
			/mob/living/simple_animal/hostile/abnormality/ebony_queen,
			/mob/living/simple_animal/hostile/abnormality/seasons,
		))

/obj/structure/spreading/scarlet_vine/Destroy()
	if(connected_rose)
		connected_rose.vine_list -= src
	return ..()

/* Only allows the user to pass if the proc returns TRUE.
	This proc doesnt like variables that were not defined
	inside of it.*/
/obj/structure/spreading/scarlet_vine/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	//List of things that trample vines.
	if(is_type_in_typecache(mover, atom_remove_condition))
		qdel(src)
		return TRUE
	//If we just ignore the creature.
	if(is_type_in_typecache(mover, ignore_typecache))
		return TRUE
	//Vine effect and extra considerations.
	if(isliving(mover))
		if(isliving(mover.pulledby))
			return TRUE
		return VineEffect(mover)
	return TRUE

/obj/structure/spreading/scarlet_vine/play_attack_sound(damage_amount, damage_type = BRUTE)
	playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', 60, TRUE)

/obj/structure/spreading/scarlet_vine/proc/VineEffect(mob/living/L)
	// They just flew over the vines. :/
	if(L.movement_type & FLYING)
		return TRUE

	if(ishuman(L))
		var/mob/living/carbon/human/lonely = L
		var/obj/item/trimming = lonely.get_active_held_item()
		if(!isnull(trimming))
			var/weeding = trimming.get_sharpness()
			if(weeding == SHARP_EDGED && trimming.force >= 5)
				if(prob(10))
					to_chat(lonely, span_warning("You cut back [name] as it reaches for you."))
				else if(prob(10) || (prob(30) && old_growth))
					to_chat(lonely, span_warning("[name] stab your legs spitefully."))
					lonely.adjustRedLoss(5)
				take_damage(15, BRUTE, "melee", 1)
				return TRUE

	//Entangling code
	if(tangle <= 0)
		tangle = initial(tangle)
		return TRUE

	tangle--
	if(prob(10))
		to_chat(L, span_danger("[src] block your path, and cuts into your legs!"))
		L.apply_lc_bleed(5)

//Called by snow white when she attacks
/obj/structure/spreading/scarlet_vine/proc/VineAttack(hit_thing)
	if(isliving(hit_thing))
		var/mob/living/L = hit_thing
		if(L.stat != DEAD)
			new /obj/effect/temp_visual/vinespike(get_turf(L))
			return
		// if(ishuman(L))
		// 	var/mob/living/carbon/human/H = L
		// 	if(H.stat == DEAD)
		// 		var/obj/item/organ/eyes/B = H.getorganslot(ORGAN_SLOT_BRAIN)
		// 		if(B)
		// 			new /obj/effect/temp_visual/vinespike(get_turf(H))
		// 			H.add_overlay(icon('ModularTegustation/Teguicons/tegu_effects.dmi', "f0442_victem"))
		// 			B.Remove(H)
	else
		new /obj/effect/temp_visual/vinespike(get_turf(hit_thing))

/mob/living/simple_animal/hostile/scarlet_rose/growing
	name = "scarlet sprout"
	desc = "A single blood red sprout, connected to all nearby vines... It appears to be still be growing..."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "poppy"
	maxHealth = 500
	health = 500
	color = "#fc0f03"
	del_on_death = TRUE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	vine_range = 3
	chem_yield = 5
	ability_cooldown_time = 30 SECONDS
	var/growing_counter
	var/growing_cooldown = 30 SECONDS
	var/growing_cooldown_time
	var/growing_counter_max = 40

/mob/living/simple_animal/hostile/scarlet_rose/growing/Life()
	. = ..()
	if(world.time > growing_cooldown_time)
		growing_cooldown_time = world.time + growing_cooldown
		growing_counter++
		playsound(src, 'sound/abnormalities/rosesign/vinegrab_prep.ogg', 50, FALSE, 5)
		if(growing_counter >= growing_counter_max)
			visible_message(span_danger("\The [src] blossoms it's scarlet petals!"))
			new /mob/living/simple_animal/hostile/scarlet_rose(get_turf(src))
			qdel(src)

/mob/living/simple_animal/hostile/scarlet_rose/growing/examine(mob/user)
	. = ..()
	if(growing_counter >= 35)
		. += span_red("[src] is about to blossom!")
	else if(growing_counter >= 25)
		. += span_red("[src] is rooting itself into the ground...")
	else if(growing_counter >= 15)
		. += span_nicegreen("[src] is a scarlet flower...")
	else if(growing_counter >= 5)
		. += span_nicegreen("[src] is a small sprout...")
	else
		. += span_nicegreen("[src] is but a sprout...")

/obj/item/scarlet_rose
	name = "scarlet rose"
	desc = "The remains of the scarlet rose, they shall remain unrooted, until they are returned to the earth..."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "poppy"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/scarlet_rose/attack_self(mob/user)
	. = ..()
	new /mob/living/simple_animal/hostile/scarlet_rose/growing(get_turf(src))
	to_chat(user, "You plant the [src] into the ground, and it quickly sprouts!")
	qdel(src)
