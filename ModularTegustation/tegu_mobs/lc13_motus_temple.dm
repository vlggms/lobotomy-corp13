// Helper proc for checking if a mob is elliot type
/proc/is_elliot(mob/living/L)
	return istype(L, /mob/living/simple_animal/hostile/ui_npc/elliot)

// Chemical Harvesting Component - shared between mad_fly_nest and scarlet_rose
/datum/component/chemical_harvest
	var/chem_type
	var/chem_yield
	var/chem_cooldown
	var/chem_cooldown_timer

/datum/component/chemical_harvest/Initialize(chem_type = /datum/reagent/medicine/mental_stabilizator, chem_yield = 5, chem_cooldown = 3 MINUTES)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	src.chem_type = chem_type
	src.chem_yield = chem_yield
	src.chem_cooldown = chem_cooldown
	src.chem_cooldown_timer = 0

/datum/component/chemical_harvest/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))

/datum/component/chemical_harvest/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_PARENT_EXAMINE, COMSIG_PARENT_ATTACKBY))

/datum/component/chemical_harvest/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(world.time < chem_cooldown_timer)
		examine_list += span_red("[parent] is not ready to be harvested.")
	else
		examine_list += span_nicegreen("[parent] is ready to be harvested.")

/datum/component/chemical_harvest/proc/on_attackby(datum/source, obj/item/O, mob/user, params)
	if(!istype(O, /obj/item/reagent_containers))
		return // Let non-reagent containers be handled normally

	if(world.time < chem_cooldown_timer)
		to_chat(user, span_notice("You may need to wait a bit longer."))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	var/obj/item/reagent_containers/my_container = O
	var/mob/living/harvester = parent
	harvester.visible_message("[user] starts extracting some reagents from [harvester]...")

	if(do_after(user, 10 SECONDS, harvester))
		perform_harvest(my_container, user)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/chemical_harvest/proc/perform_harvest(obj/item/reagent_containers/C, mob/user)
	var/mob/living/harvester = parent
	harvester.visible_message("[user] uses [C] to extract some reagents from [harvester]")
	if(chem_type)
		C.reagents.add_reagent(chem_type, chem_yield)
	chem_cooldown_timer = world.time + chem_cooldown

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
	melee_damage_upper = 17
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/weapons/fixer/generic/spear2.ogg'
	ranged = TRUE
	charge = 5
	max_charge = 20
	clan_charge_cooldown = 1 SECONDS
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
		return stagger()
	if(charge >= 10)
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
	var/hit_target = FALSE
	for(var/turf/TT in turf_list)
		var/obj/effect/temp_visual/thrust/AoE = new(T, COLOR_GRAY)
		var/matrix/M = matrix(AoE.transform)
		M.Turn(Get_Angle(src, T)-90)
		AoE.transform = M
		for(var/mob/living/L in HurtInTurf(TT, list(), ability_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE))
			hit_target = TRUE
			L.apply_lc_tremor(attack_tremor*2, 25)
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
	maxHealth = 200
	health = 200
	move_to_delay = 1.6
	faction = list("madfly", "hostile")
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 2)
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 1
	melee_damage_upper = 1
	obj_damage = 0
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
		if(ishuman(nesting_target))
			var/mob/living/carbon/human/devouring_target = nesting_target
			if(devouring_target.sanity_lost)
				devouring_target.deal_damage(melee_damage_upper * 5, RED_DAMAGE)
				playsound(get_turf(src), 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg', 50, FALSE, 5)
				devouring_target.visible_message(span_danger("\The [src] devours [devouring_target]'s from the inside!"))
			else
				devouring_target.visible_message(span_danger("[devouring_target]'s body throws up [src]!"))
				UnregisterSignal(devouring_target, COMSIG_LIVING_DEATH)
				var/target_turf = get_turf(src)
				forceMove(target_turf)


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
	faction = list("madfly", "hostile")
	gender = NEUTER
	obj_damage = 0
	maxHealth = 800
	health = 800
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/xeno = 3)
	death_sound = 'sound/effects/ordeals/crimson/dusk_dead.ogg'
	var/spawn_progress = 10 //spawn ready to produce flies
	var/list/spawned_mobs = list()
	var/producing = FALSE
	// Chemical harvesting handled by component

/mob/living/simple_animal/hostile/mad_fly_nest/Initialize()
	. = ..()
	AddComponent(/datum/component/chemical_harvest, /datum/reagent/medicine/mental_stabilizator, 5, 1 MINUTES)

/mob/living/simple_animal/hostile/mad_fly_nest/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/mad_fly_nest/Move()
	return FALSE

/mob/living/simple_animal/hostile/mad_fly_nest/death(gibbed)
	new /obj/effect/gibspawner/xeno/bodypartless(get_turf(src))
	. = ..()

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
	maxHealth = 800
	health = 800
	del_on_death = TRUE
	faction = list("scarletrose", "hostile")
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
	// Chemical harvesting handled by component

/mob/living/simple_animal/hostile/scarlet_rose/Initialize()
	. = ..()
	AddComponent(/datum/component/chemical_harvest, /datum/reagent/medicine/sal_acid, 15, 1 MINUTES)

/mob/living/simple_animal/hostile/scarlet_rose/death(gibbed)
	new /obj/item/scarlet_rose(get_turf(src))
	..()

/mob/living/simple_animal/hostile/scarlet_rose/Destroy()
	for(var/obj/structure/spreading/scarlet_vine/vine in vine_list)
		vine.can_expand = FALSE
		var/del_time = rand(4,10) //all the vines dissapear at different interval so it looks more organic.
		animate(vine, alpha = 0, time = del_time SECONDS)
		QDEL_IN(vine, del_time SECONDS)
	vine_list.Cut()
	return ..()

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
				playsound(H, 'sound/abnormalities/rosesign/vinegrab_prep.ogg', 50, FALSE, 5)
				to_chat(H, span_danger("Scarlet vines cut into your legs!"))
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
	max_integrity = 5
	expand_cooldown = 4 SECONDS
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
	maxHealth = 400
	health = 400
	color = "#fc0f03"
	del_on_death = TRUE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	vine_range = 3
	ability_cooldown_time = 30 SECONDS
	var/growing_counter
	var/growing_cooldown = 30 SECONDS
	var/growing_cooldown_time
	var/growing_counter_max = 40

/mob/living/simple_animal/hostile/scarlet_rose/growing/Initialize()
	. = ..()
	// Override parent's chemical harvest component with lower yield
	qdel(GetComponent(/datum/component/chemical_harvest))
	AddComponent(/datum/component/chemical_harvest, /datum/reagent/medicine/sal_acid, 5, 1 MINUTES)

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

/mob/living/simple_animal/hostile/clan/stone_keeper
	name = "stone guardian"
	desc = "A monstrous machine, with a glare of hatred."
	icon = 'ModularTegustation/Teguicons/teaser_mobs3.dmi'
	icon_state = "stone_keeper"
	icon_living = "stone_keeper"
	icon_dead = ""
	pixel_x = -32
	base_pixel_x = -32
	maxHealth = 3000
	health = 3000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	melee_damage_lower = 24
	melee_damage_upper = 36
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"
	attack_sound = 'sound/weapons/fixer/generic/spear2.ogg'
	melee_queue_distance = 2 //since our attacks are AoEs, this makes it harder to kite us
	move_to_delay = 6
	ranged = TRUE
	charge = 15
	alpha = 0
	max_charge = 20
	clan_charge_cooldown = 30 SECONDS
	var/can_act = TRUE
	var/shield_ready = FALSE
	var/annihilation_ready = FALSE
	var/attack_delay = 8
	var/ranged_attack_delay = 2.5
	var/tentacle_radius = 1
	var/tentacle_damage = 50
	var/taunt_cooldown = 60 SECONDS
	var/last_taunt_update = 0
	var/ability_cooldown
	var/ability_cooldown_time = 20 SECONDS
	var/list/locked_list = list()
	var/list/locked_tiles_list = list()
	var/summoned_pillar = FALSE
	var/list/shield_lines = list(
		"Damage... Nullified...",
		"Resistance... Raised...",
		"Charge... Barrier...",
		"Shield... Order...",
		"Protection... Activated...",
	)
	var/ending = FALSE
	var/detonating = FALSE
	var/beep_time = 20
	var/talking = FALSE
	var/elliot_killed_once = FALSE

/mob/living/simple_animal/hostile/clan/stone_keeper/Initialize()
	. = ..()
	AcitvateChains()
	addtimer(CALLBACK(src, PROC_REF(entrance_fall)), 0)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/entrance_fall()
	playsound(get_turf(src), 'sound/abnormalities/babayaga/charge.ogg', 100, 1)
	talking = TRUE
	pixel_z = 128
	alpha = 0
	density = FALSE
	can_act = FALSE
	animate(src, pixel_z = 0, alpha = 255, time = 10)
	SLEEP_CHECK_DEATH(10)
	density = TRUE
	visible_message(span_danger("[src] drops down from the ceiling!"))
	playsound(get_turf(src), 'sound/abnormalities/babayaga/land.ogg', 100, FALSE, 20)
	for(var/mob/living/L in view(2, src))
		if(faction_check_mob(L, TRUE))
			continue
		var/dist = get_dist(src, L)
		if(ishuman(L))
			L.deal_damage(clamp((15 * (2 ** (8 - dist))), 15, 30), RED_DAMAGE)
	last_taunt_update = world.time
	SLEEP_CHECK_DEATH(10)
	say("Extermination Order... Activated")
	talking = FALSE
	can_act = TRUE

/mob/living/simple_animal/hostile/clan/stone_keeper/GainCharge()
	. = ..()
	charge = max_charge
	playsound(src, 'sound/weapons/fixer/generic/energy3.ogg', 50, FALSE, 5)
	manual_emote("electricity flows around [src]")

/mob/living/simple_animal/hostile/clan/stone_keeper/ChargeUpdated()
	if(charge >= 5)
		ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.5))
		shield_ready = TRUE
	else
		ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))
		shield_ready = FALSE
		return

/mob/living/simple_animal/hostile/clan/stone_keeper/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(shield_ready)
		var/obj/effect/temp_visual/shock_shield/AT = new /obj/effect/temp_visual/shock_shield(loc, src)
		var/random_x = rand(-25, 25)
		AT.pixel_x += random_x

		var/random_y = rand(5, 80)
		AT.pixel_y += random_y
		if(!talking)
			if (last_taunt_update < world.time - taunt_cooldown && amount < 100)
				say(pick(shield_lines))
				last_taunt_update = world.time
	if(charge > 0)
		charge--
		ChargeUpdated()
	if(health <= maxHealth/2 && !summoned_pillar)
		summoned_pillar = TRUE
		addtimer(CALLBACK(src, PROC_REF(summon_piller)), 5)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/summon_piller()
	var/spanwer_near = FALSE
	for(var/obj/effect/keeper_piller_spawn/piller in range(20, src))
		spanwer_near = TRUE
	if(!spanwer_near)
		return
	talking = TRUE
	can_act = FALSE
	GainCharge()
	adjustRedLoss(-5000)
	say("I see...")
	SLEEP_CHECK_DEATH(20)
	can_act = FALSE
	say("You are not a pushover like last time.")
	SLEEP_CHECK_DEATH(40)
	can_act = FALSE
	say("However, I have been working on something new as well.")
	SLEEP_CHECK_DEATH(40)
	icon_state = "stone_keeper_attack"
	say("Witness, one of many toys of the city...")
	for(var/obj/effect/keeper_piller_spawn/piller in range(20, src))
		var/turf/spawn_turf = get_turf(piller)
		new /mob/living/simple_animal/hostile/keeper_piller(spawn_turf)
	SLEEP_CHECK_DEATH(40)
	say("A fancy work of machinery and worship, is it not?")
	icon_state = "stone_keeper"
	talking = FALSE
	can_act = TRUE

/mob/living/simple_animal/hostile/clan/stone_keeper/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/clan/stone_keeper/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE

	return AoeAttack()

/mob/living/simple_animal/hostile/clan/stone_keeper/OpenFire(target)
	if(!can_act)
		return

	if(ability_cooldown <= world.time)
		ability_cooldown = world.time + ability_cooldown_time
		return AnnihilationBeam(target)
	else
		return

/mob/living/simple_animal/hostile/clan/stone_keeper/Destroy()
	Unlock()
	. = ..()


/mob/living/simple_animal/hostile/clan/stone_keeper/death(gibbed)
	if(ending)
		Unlock()
		new /obj/item/keycard/motus_treasure(get_turf(src))
		return ..()
	if(!detonating)
		for(var/mob/living/simple_animal/hostile/keeper_piller/piller in range(20, src))
			qdel(piller)
		detonating = TRUE
		INVOKE_ASYNC(src, PROC_REF(Self_Detonate_Timer))
	return FALSE

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/Self_Detonate_Timer()
	var/elliot_alive = FALSE
	var/mob/living/simple_animal/hostile/ui_npc/elliot/hero
	for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in range(10, src))
		if(victim.stat != DEAD)
			elliot_alive = TRUE
			hero = victim
			INVOKE_ASYNC(hero, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ui_npc/elliot, Unstun), TRUE)
	can_act = FALSE
	status_flags |= GODMODE
	talking = TRUE
	manual_emote("gasps...")
	SLEEP_CHECK_DEATH(10)
	say("Nasty little pests... I will not let you get away with this...")
	addtimer(CALLBACK(src, PROC_REF(beep)), beep_time)
	SLEEP_CHECK_DEATH(20)
	can_act = FALSE
	manual_emote("slow beeps...")
	SLEEP_CHECK_DEATH(30)
	can_act = FALSE
	say("If I can't bring you down with this shell intact...")
	SLEEP_CHECK_DEATH(20)
	say("I WILL MAKE SURE NONE OF YOU WILL!!!")
	SLEEP_CHECK_DEATH(20)
	say("BURN IN HELL, HAHAHA!!!")
	status_flags &= ~GODMODE
	if(elliot_alive)
		hero.execute_keeper(src)
	else
		Self_Detonate()

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/Self_Detonate()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	for(var/mob/living/L in view(8, src))
		var/dist = get_dist(src, L)
		if(L == src)
			continue
		if(ishuman(L)) //Different damage formulae for humans vs mobs
			L.deal_damage(clamp((15 * (2 ** (8 - dist))), 100, 4000), RED_DAMAGE)
		if(L.health < 0)
			L.gib()
	for(var/mob/hurt_targets in range(20, src))
		if(hurt_targets.client)
			hurt_targets.playsound_local(hurt_targets, "sound/effects/explosioncreak1.ogg", 100)
			shake_camera(hurt_targets, 25, 4)
	SLEEP_CHECK_DEATH(10)
	// Trigger rubble spawners to handle their own spawning
	for(var/obj/effect/rubble_spawner/spawner in range(40, src))
		spawner.StartSpawning()
	for(var/obj/effect/pickaxe_spawner/pick_spawner in range(40, src))
		new /obj/item/pickaxe(get_turf(pick_spawner))
	// Delete self immediately
	qdel(src)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/beep()
	playsound(src, 'sound/items/timer.ogg', 40, 3, 3)
	addtimer(CALLBACK(src, PROC_REF(beep)), beep_time)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/AoeAttack() //all attacks are an AoE when not dashing
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/effects/ordeals/white/black_swing.ogg', 75, 0, 3)
	icon_state = "stone_keeper_attack"
	SLEEP_CHECK_DEATH(attack_delay)
	var/list/been_hit = list()
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/pale_eye_attack(T)
		for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in T.contents)
			if(prob(90))
				victim.SpinAnimation(7, 1)
				been_hit += victim
				victim.visible_message(span_notice("[victim] evades [src]'s attack!"))
		HurtInTurf(T, been_hit, (rand(melee_damage_lower, melee_damage_upper)), PALE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE) //30~40 damage
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, 0, 3)
	icon_state = "stone_keeper"
	SLEEP_CHECK_DEATH(0.4 SECONDS)
	EveryoneDead_Check()
	if(talking)
		return
	can_act = TRUE
	for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in range(7, src))
		if(ability_cooldown <= world.time && prob(20))
			ability_cooldown = world.time + ability_cooldown_time
			AnnihilationBeam(victim)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/AnnihilationBeam(atom/target)
	var/mob/living/cooler_target = target
	if(cooler_target.stat == DEAD)
		return
	can_act = FALSE
	icon_state = "stone_keeper_attack"
	visible_message(span_danger("[src] starts charging something at [cooler_target]!"))
	say("Tinkerer's Order...")
	var/mob/living/simple_animal/hostile/ui_npc/elliot/victim
	if(is_elliot(cooler_target))
		victim = cooler_target
	dir = get_cardinal_dir(src, target)
	if(victim)
		ranged_attack_delay += 3
	var/datum/beam/B = src.Beam(cooler_target, "light_beam", time = ((ranged_attack_delay+1.5) SECONDS))
	B.visuals.color = LIGHT_COLOR_DARK_BLUE
	if(victim)
		victim.guilt = TRUE
		victim.ending = TRUE
		victim.say("No... Get out of my head...")
		victim.add_overlay(victim.guilt_icon)
		victim.revive_time = 2 SECONDS
		INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ui_npc/elliot, Downed), FALSE)
		SLEEP_CHECK_DEATH(30)
		victim.say("Please... Help me...")
		ranged_attack_delay -= 3
	SLEEP_CHECK_DEATH(ranged_attack_delay SECONDS)
	playsound(src, 'sound/effects/ordeals/white/red_beam.ogg', 75, FALSE, 32)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(src, 'sound/effects/ordeals/white/red_beam_fire.ogg', 100, FALSE, 32)
	// cooler_target.remove_status_effect(/datum/status_effect/spirit_gun_target)
	can_act = TRUE
	annihilation_ready = FALSE
	icon_state = "stone_keeper"
	say("... Annihilation")
	if(victim)
		INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ui_npc/elliot, Unstun), FALSE)
		victim.revive_time = 4 SECONDS
	if(talking)
		return
	var/line_of_sight = getline(get_turf(src), get_turf(target)) //better simulates a projectile attack
	var/turf/last_turf = get_turf(src)
	for(var/turf/T in line_of_sight)
		if(DensityCheck(T))
			Fire(last_turf)
			if(victim)
				victim.Unguilt()
			return
		else
			last_turf = T
	Fire(cooler_target)
	if(victim)
		victim.Unguilt()

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/Fire(atom/target)
	face_atom(target)
	var/turf/beam_start = get_step(src, dir)
	var/turf/beam_end = get_turf(target)
	var/list/hitline = list()
	for(var/turf/T in getline(beam_start, beam_end))
		for(var/turf/open/TT in RANGE_TURFS(tentacle_radius, T))
			hitline |= TT
	if(!beam_end)
		can_act = TRUE
		return
	var/datum/beam/B = beam_start.Beam(beam_end, "bsa_beam", time = 8)
	var/matrix/M = matrix()
	M.Scale(tentacle_radius * 3, 1)
	B.visuals.transform = M
	var/list/been_hit = list()
	for(var/turf/T in hitline)
		for(var/mob/living/simple_animal/hostile/ui_npc/elliot/victim in T.contents)
			if(victim.guilt == FALSE)
				victim.SpinAnimation(7, 1)
				been_hit += victim
				victim.visible_message(span_notice("[victim] evades [src]'s attack!"))
		var/list/new_hits = HurtInTurf(T, been_hit, tentacle_damage, PALE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			to_chat(L, span_userdanger("A pale beam passes right through you!"))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
			// Check if we killed Elliot for the first time
			if(is_elliot(L) && L.stat == DEAD && !elliot_killed_once)
				elliot_killed_once = TRUE
				var/mob/living/simple_animal/hostile/ui_npc/elliot/elliot_victim = L
				addtimer(CALLBACK(src, PROC_REF(revive_elliot), elliot_victim), 2 SECONDS)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/revive_elliot(mob/living/simple_animal/hostile/ui_npc/elliot/elliot_victim)
	if(!elliot_victim || QDELETED(elliot_victim))
		return
	// Revive Elliot
	elliot_victim.revive(full_heal = TRUE, admin_revive = TRUE)
	elliot_victim.say("Agh... Their next shot could end me...")
	// Make sure they're standing and can act
	if(elliot_victim.stunned)
		elliot_victim.Unstun(FALSE)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/DensityCheck(turf/T) //TRUE if dense or airlocks closed
	if(T.density)
		return TRUE
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/EveryoneDead_Check()
	var/everyone_dead = TRUE
	for(var/mob/living/L in locked_list)
		if(is_elliot(L))
			continue
		if(L.stat != DEAD && !faction_check_mob(L, FALSE))
			everyone_dead = FALSE
	if(everyone_dead)
		StealElliot()

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/StealElliot()
	var/mob/living/simple_animal/hostile/ui_npc/elliot/victim
	for(var/mob/living/simple_animal/hostile/ui_npc/elliot/steal_target in range(20, src))
		victim = steal_target
		break
	status_flags |= GODMODE
	can_act = FALSE
	talking = TRUE
	if(victim)
		victim.can_act = FALSE
		say("Well, well, well...")
		SLEEP_CHECK_DEATH(30)
		say("It appears all have fallen... Dear Elliot.")
		SLEEP_CHECK_DEATH(30)
		say("Now, it's time for you to return...")
		SLEEP_CHECK_DEATH(30)
		say("And fight for the right side of history...")
		SLEEP_CHECK_DEATH(30)
		if(victim.stat != DEAD)
			victim.say("Ha... Dear Tinkerer...")
			SLEEP_CHECK_DEATH(30)
			victim.say("I... Understand the pain you went through...")
			SLEEP_CHECK_DEATH(30)
			victim.say("I learned the same once I ran away...")
			SLEEP_CHECK_DEATH(30)
			victim.say("The nightmare that was the city... The monsters that humans can be...")
			SLEEP_CHECK_DEATH(30)
			say("HAHA, So you do see... How we must exterminate them... Right?")
			SLEEP_CHECK_DEATH(30)
			victim.say("I wish I could join you so easily...")
			SLEEP_CHECK_DEATH(30)
			victim.say("But... Not all humans are a part of this nightmare...")
			SLEEP_CHECK_DEATH(30)
			victim.say("Like Joshua, or the humans in the outskirts...")
			SLEEP_CHECK_DEATH(30)
			victim.say("They showed me the kindness that can be within a human...")
			SLEEP_CHECK_DEATH(30)
			say("... What utter lies, humans can't be excused that easily...")
			SLEEP_CHECK_DEATH(30)
			victim.say("I know, but... I think I should give them a chance.")
			SLEEP_CHECK_DEATH(30)
			victim.say("For the kindness that they showed me...")
			SLEEP_CHECK_DEATH(30)
		for(var/mob/living/carbon/human/L in locked_list)
			new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(L))
			playsound(L, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
			var/turf/target_turf = get_turf(victim)
			if(victim.emergency_escape)
				target_turf = victim.emergency_escape
			L.forceMove(target_turf)
			new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(L))
			playsound(L, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
		Unlock()
		victim.gib()
		SLEEP_CHECK_DEATH(30)
		say("I see... Dear Elliot...")
		SLEEP_CHECK_DEATH(30)
		say("So you did have a plan for them if something like this happened...")
		SLEEP_CHECK_DEATH(30)
		say("Clever, Little Elliot... Even if it costed your Core...")
		SLEEP_CHECK_DEATH(30)
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(src))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
		qdel(src)
	else
		say("Well, It appears that everyone has been taken care of...")
		SLEEP_CHECK_DEATH(30)
		say("However, that little drone got away...")
		SLEEP_CHECK_DEATH(30)
		say("Annoying, But I guess I can let them go for now...")
		SLEEP_CHECK_DEATH(30)
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(src))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
		qdel(src)

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/AcitvateChains()
	for(var/obj/effect/keeper_field/DF in range(20, src))
		DF.activate(src)
		locked_tiles_list += DF

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/Unlock()
	for(var/obj/effect/keeper_field/DF in locked_tiles_list)
		if (DF.keeper == src)
			qdel(DF)
	for(var/mob/living/L in locked_list)
		var/datum/status_effect/keeper_chain/S = L.has_status_effect(/datum/status_effect/keeper_chain)
		if (S)
			L.remove_status_effect(/datum/status_effect/keeper_chain)
	locked_list = list()
	locked_tiles_list = list()

/mob/living/simple_animal/hostile/clan/stone_keeper/proc/ApplyLock(mob/living/L)
	if(!faction_check_mob(L, FALSE))
		// apply status effect
		var/datum/status_effect/keeper_chain/S = L.has_status_effect(/datum/status_effect/keeper_chain)
		if(!S)
			S = L.apply_status_effect(/datum/status_effect/keeper_chain)
		if (!S.list_of_keeper.Find(src))
			S.list_of_keeper += src
			locked_list += L
		// keep a list of everyone locked

/obj/effect/keeper_field
	name = "keeper's chain"
	desc = "You shall not run from this fight... Elliot..."
	icon = 'icons/turf/floors.dmi'
	icon_state = "locked_down"
	alpha = 0
	mouse_opacity = FALSE
	anchored = TRUE
	var/mob/living/simple_animal/hostile/clan/stone_keeper/keeper
	var/active = FALSE

/obj/effect/keeper_field/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && active)
		var/mob/living/L = AM
		keeper.ApplyLock(L)

/obj/effect/keeper_field/proc/activate(mob/living/simple_animal/hostile/clan/stone_keeper/activater)
	animate(src, alpha = 20, time = 1 SECONDS)
	mouse_opacity = TRUE
	active = TRUE
	keeper = activater

/datum/status_effect/keeper_chain
	id = "keeper chain"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/keeper_chain
	var/list/list_of_keeper = list()
	var/turf/last_turf

/atom/movable/screen/alert/status_effect/keeper_chain
	name = "Keeper Chain"
	desc = "You shall not run from this fight..."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "locked"

/datum/status_effect/keeper_chain/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(Moved))
	last_turf = get_turf(owner)

/datum/status_effect/keeper_chain/proc/Moved(mob/user, atom/new_location)
	SIGNAL_HANDLER
	var/turf/newloc_turf = get_turf(new_location)
	var/turf/oldloc_turf = get_turf(user)
	var/valid_tile = FALSE
	var/standing_on_locked = FALSE

	for(var/obj/effect/keeper_field/GR in oldloc_turf.contents)
		standing_on_locked = TRUE

	if (!standing_on_locked)
		owner.forceMove(last_turf)

	for(var/obj/effect/keeper_field/GR in newloc_turf.contents)
		valid_tile = TRUE

	if(!valid_tile)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE
	else
		last_turf = get_turf(owner)

/datum/status_effect/keeper_chain/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
	return ..()

/obj/effect/keeper_piller_spawn
	name = "keeper's piller spawn"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "tdome_t1"
	alpha = 0
	mouse_opacity = FALSE

/obj/effect/rubble_spawner
	name = "rubble spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "tdome_admin"
	alpha = 0
	mouse_opacity = FALSE

/obj/effect/rubble_spawner/proc/StartSpawning()
	var/delay = rand(15, 200) // 1.5 to 20 seconds delay
	addtimer(CALLBACK(src, PROC_REF(SpawnRubble)), delay)

/obj/effect/rubble_spawner/proc/SpawnRubble()
	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	// 15% chance for cave-in effect
	if(prob(15))
		// Cave-in effect similar to MiningEvent
		visible_message(span_danger("Chunks of rubble cave in!"))
		playsound(T, 'sound/effects/lc13_environment/day_50/Shake_Start.ogg', 60, TRUE)
		for(var/turf/cave_turf in view(4, T))
			if(prob(80)) // 20% chance per tile
				continue
			var/obj/effect/rock_fall/R = new(cave_turf)
			R.boom_damage = 90 // Reasonable damage instead of instakill

	// Spawn the ash rock
	new /turf/closed/mineral/ash_rock(T)
	qdel(src)

/obj/effect/pickaxe_spawner
	name = "pickaxe spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "tdome_admin"
	alpha = 0
	mouse_opacity = FALSE

/mob/living/simple_animal/hostile/keeper_piller
	name = "mimic: pillar of the black sun"
	desc = "A glowing pillar, a mimic of a certain abnormality, created by the Tinkerer..."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "sun_pillar"
	icon_living = "sun_pillar"
	health = 1000
	maxHealth = 1000
	pixel_z = 128
	alpha = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_sound = 'sound/weapons/fixer/generic/nail1.ogg'
	mob_size = MOB_SIZE_TINY
	del_on_death = TRUE
	a_intent = INTENT_HARM
	var/active = FALSE

/mob/living/simple_animal/hostile/keeper_piller/Initialize()
	..()
	addtimer(CALLBACK(src, PROC_REF(piller_fall)), 0)

/mob/living/simple_animal/hostile/keeper_piller/proc/piller_fall()
	playsound(get_turf(src), 'sound/abnormalities/babayaga/charge.ogg', 100, 1)
	pixel_z = 128
	alpha = 0
	density = FALSE
	animate(src, pixel_z = 0, alpha = 255, time = 10)
	SLEEP_CHECK_DEATH(10)
	density = TRUE
	visible_message(span_danger("[src] drops down from the ceiling!"))
	playsound(get_turf(src), 'sound/abnormalities/babayaga/land.ogg', 100, FALSE, 20)
	for(var/mob/living/L in view(4, src))
		if(faction_check_mob(L, TRUE))
			continue
		var/dist = get_dist(src, L)
		if(ishuman(L))
			L.deal_damage(clamp((15 * (2 ** (8 - dist))), 15, 30), RED_DAMAGE)
	SLEEP_CHECK_DEATH(30)
	active = TRUE

/mob/living/simple_animal/hostile/keeper_piller/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/keeper_piller/Move()
	return FALSE

/mob/living/simple_animal/hostile/keeper_piller/Life()
	..()
	if(active)
		var/list/all_turfs = RANGE_TURFS(7, src)
		for(var/turf/open/F in all_turfs)
			if(prob(15))
				addtimer(CALLBACK(src, PROC_REF(Firelaser), F), rand(1,30))

/mob/living/simple_animal/hostile/keeper_piller/proc/Firelaser(turf/open/F)
	new /obj/effect/temp_visual/keeper_laser(F)

//Laser attack
/obj/effect/temp_visual/keeper_laser
	name = "keeper laser"
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "pillar_strike"
	duration = 15

/obj/effect/temp_visual/keeper_laser/Initialize()
	..()
	addtimer(CALLBACK(src, PROC_REF(blowup)), 10) //this is how long the animation takes

/obj/effect/temp_visual/keeper_laser/proc/blowup()
	playsound(src, 'sound/weapons/laser.ogg', 10, FALSE, 4)
	for(var/mob/living/carbon/human/H in src.loc)
		H.deal_damage(60, WHITE_DAMAGE)
		H.deal_damage(30, PALE_DAMAGE)
		if(H.sanity_lost)
			H.deal_damage(60, PALE_DAMAGE)
