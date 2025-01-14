#define FLORAL_BARRIER_COOLDOWN 10 SECONDS

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple
	name = "Snow White’s Apple"
	desc = "An abnormality taking the form of a tall humanoid with an apple for a head."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "snowwhitesapple_inert"
	icon_living = "snowwhitesapple_inert"
	icon_dead = "snowwhitesapple_dead"
	portrait = "snow_whites_apple"
	maxHealth = 1600
	health = 1600
	blood_volume = 0
	obj_damage = 0
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.5)
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	move_to_delay = 5
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	projectilesound = 'sound/creatures/venus_trap_hit.ogg'
	ranged_message = null
	can_breach = TRUE
	threat_level = WAW_LEVEL
	wander = FALSE
	start_qliphoth = 1
	del_on_death = FALSE
	can_patrol = FALSE
	death_message = "collapses into a pile of plantmatter."
	vision_range = 15
	death_sound = 'sound/creatures/venus_trap_death.ogg'
	attacked_sound = 'sound/creatures/venus_trap_hurt.ogg'
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(10, 20, 45, 45, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 0, 0, 0),
		ABNORMALITY_WORK_REPRESSION = list(20, 30, 55, 55, 60),
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/stem,
		/datum/ego_datum/armor/stem,
	)

	gift_type =  /datum/ego_gifts/stem
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/golden_apple = 1.5,
		/mob/living/simple_animal/hostile/abnormality/ebony_queen = 1.5,
	)

	observation_prompt = "(You see and feel something.) <br>\
		The soil is solid. <br>A little bird is sitting beside me. <br>\
		No, it is not a bird. <br>It is a rotting, decaying carcass of a bird. <br>\
		Nothing is around me. <br>The prince came to wake sleeping Snow White up with a kiss. <br>\
		The deadly poison that can melt a bone with a drop proved to be useless. <br>\
		Why does no one visit me? <br>Why does no one share my pain? <br>\
		Why does no one like me? <br>I hope I had legs, no, it doesn't have to be legs. <br>\
		All I want is to be able to move. <br>Oh, redemption......"
	observation_choices = list(
		"It does not exist" = list(TRUE, "This is unfair. <br>I want to be happy. <br>It's too painful to wait. <br>\
			It is my bane that no one is around me. <br>I want this misery to crush me to nonexistence. <br>\
			Some kind of legs sprouted out of me but I have no place to go. <br>However, I do not rot. <br>I cannot stop existing. <br>\
			I have to go, although I have no place to go. <br>I have to go. <br>I go."),
		"I shall go find it" = list(FALSE, "From some moment, I realized I can walk. <br>\
			I see light. <br>I hear people. <br>I will be free from this torment. <br>For I will meet my redemption"),
	)

	initial_language_holder = /datum/language_holder/plant //essentially flavor
	var/togglemovement = FALSE
	var/toggleplants = TRUE
	var/nightmare_mode = FALSE
	var/plant_cooldown = 30
	var/hedge_cooldown = 0
	var/hedge_cooldown_delay = FLORAL_BARRIER_COOLDOWN
	var/teleport_cooldown = 0
	var/teleport_cooldown_delay = 60 SECONDS
	//Spell automatically given to the abnormality.
	var/obj/effect/proc_holder/spell/pointed/apple_barrier/barrier_spell
	//All iterations share this list between eachother.
	var/static/list/vine_list = list()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Initialize()
	. = ..()
	barrier_spell = new /obj/effect/proc_holder/spell/pointed/apple_barrier
	AddSpell(barrier_spell)

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/update_icon_state()
	if(status_flags & GODMODE)
		// Not breaching
		icon_living = initial(icon)
		icon_state = icon_living
	else if(stat == DEAD)
		icon_state = icon_dead
	else
		icon_living = "snowwhitesapple_active"
		icon_state = icon_living

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Move()
	if(!togglemovement)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Destroy()
	for(var/obj/structure/spreading/apple_vine/vine in vine_list)
		vine.can_expand = FALSE
		var/del_time = rand(4,10) //all the vines dissapear at different interval so it looks more organic.
		animate(vine, alpha = 0, time = del_time SECONDS)
		QDEL_IN(vine, del_time SECONDS)
	vine_list.Cut()
	return ..()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	togglemovement = TRUE
	to_chat(src, "<b>Snow White's Apple can only harm creatures that are ontop of her vines. \
		Your ranged attack will harm all standing on vines. \
		Your barrier spell can only be used on thick vines.</b>")

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/Life()
	. = ..()
	if(status_flags & GODMODE || stat == DEAD)
		return
	if(togglemovement)
		if(plant_cooldown <= world.time)
			plant_cooldown = world.time + (60 SECONDS)
			if(toggleplants)
				SpreadPlants()
			oldGrowth()
	var/list/area_of_influence
	if(nightmare_mode)
		area_of_influence = vine_list
	else
		area_of_influence = urange(15, get_turf(src))
	for(var/obj/structure/spreading/apple_vine/W in area_of_influence)
		if(W.last_expand <= world.time)
			W.expand()
		else if(nightmare_mode && ranged_cooldown <= world.time)
			var/list/did_we_hit = HurtInTurf(get_turf(W), list(), 30, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
			if(did_we_hit.len)
				W.VineAttack(pick(did_we_hit))
	if(teleport_cooldown <= world.time && !togglemovement && !client && !IsCombatMap())
		TryTeleport()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/OpenFire()
	if(client)
		switch(chosen_attack)
			if(1)
				if(ranged_cooldown <= world.time)
					VineSpike()
		return

	if(ranged_cooldown <= world.time)
		VineSpike()

// Branch Barrier Reaction
/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/bullet_act(obj/projectile/P)
	. = ..()
	//Is there a player? Did we actually get hit with the bullet? Is our cooldown over? Are we currently mulch?
	if(!client && . == BULLET_ACT_HIT && hedge_cooldown <= world.time && stat != DEAD)
		hedge_cooldown = world.time + hedge_cooldown_delay
		var/hunter = P.firer
		var/reaction_area
		var/blind_direction
		//If no one had fired the bullet, like mech bullets, get a turf in their direction
		if(!hunter)
			blind_direction = angle2dir_cardinal(P.Angle - 180)
			reaction_area = get_ranged_target_turf(src, blind_direction, 3)
		//General faction check thing. Honestly may remove the check since this is a "reaction"
		if(isliving(hunter))
			if(faction_check_mob(hunter))
				return
			reaction_area = get_turf(hunter)
		if(reaction_area)
			VineDefense(reaction_area)

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/TryTeleport() //stolen from knight of despair
	// Facing south for a dramatic exit.
	dir = 2
	if(teleport_cooldown > world.time)
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_delay
	var/list/teleport_potential = TeleportList()
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)

	//Effects before teleporting
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5) // TODO: Add some cool effects here
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)
	//Effects after teleporting
	SpreadPlants()
	oldGrowth()

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/TeleportList()
	. = list()
	for(var/turf/T in GLOB.xeno_spawn)
		. += T

	return

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/SpreadPlants()
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/structure/spreading/apple_vine) in get_turf(src))
		return
	new /obj/structure/spreading/apple_vine(loc)

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/VineSpike()
	playsound(get_turf(src), projectilesound, 30)
	for(var/obj/structure/spreading/apple_vine/W in view(vision_range, src))
		var/list/did_we_hit = HurtInTurf(get_turf(W), list(), 30, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
		if(did_we_hit.len)
			W.VineAttack(pick(did_we_hit))

	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/oldGrowth()
	for(var/obj/structure/spreading/apple_vine/W in urange(15, get_turf(src)))
		if(!W.old_growth)
			W.OverGrowth()

//Vine Barrier Targeting Code
/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/proc/VineDefense(atom/thing)
	var/turf/enemy_loc = get_turf(thing)
	//Get a line of old growth.
	var/turf/last_step
	var/turf/wallcheck = get_step(src, get_dir(get_turf(src), enemy_loc))
	var/list/spiteful_growth = list()
	for(var/i=0 to 3)
		last_step = wallcheck
		wallcheck = get_step(last_step, get_dir(last_step, enemy_loc))
		var/obj/structure/spreading/apple_vine/T = locate(/obj/structure/spreading/apple_vine) in wallcheck
		if(wallcheck == enemy_loc)
			break
		if(wallcheck == last_step)
			continue
		if(!T)
			continue
		if(!T.old_growth)
			continue
		spiteful_growth += T

	if(!spiteful_growth.len)
		return FALSE

	//Get a good vine.
	var/obj/structure/spreading/apple_vine/T = pick(spiteful_growth)

	//Cast Spell
	barrier_spell.perform(list(T), user = src)
	return TRUE

//VINESPIKE EFFECT
/obj/effect/temp_visual/vinespike
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "vinespike"
	duration = 10

//VINEHEDGE STRUCTURE
/obj/structure/apple_barrier
	gender = PLURAL
	name = "branch barrier"
	desc = "A twisted assortment of branches and roots."
	icon = 'ModularTegustation/Teguicons/teguobjects.dmi'
	icon_state = "vinehedge"
	anchored = TRUE
	density = TRUE
	max_integrity = 100
	resistance_flags = FLAMMABLE
	armor = list(
		MELEE = 0,
		BULLET = 0,
		FIRE = -50,
		RED_DAMAGE = 20,
		WHITE_DAMAGE = 0,
		BLACK_DAMAGE = 80,
		PALE_DAMAGE = -50,
	)

/obj/structure/apple_barrier/Initialize()
	. = ..()
	for(var/obj/structure/apple_barrier/V in get_turf(src))
		if(V != src)
			qdel(V)
			return
	playsound(get_turf(src), 'sound/creatures/venus_trap_death.ogg', 15)
	QDEL_IN(src, (15 SECONDS))

/obj/structure/apple_barrier/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(ismecha(mover))
		mover.visible_message(span_danger("[mover] stomps on the [src]!"))
		if(obj_integrity <= 50)
			qdel(src)
		else
			take_damage(50, BRUTE, "melee", 1)

	if(istype(mover, /mob/living/simple_animal/hostile/abnormality/snow_whites_apple))
		return TRUE

	if(ishuman(mover))
		//Yes we do give alot of power to the gift owner.
		var/mob/living/carbon/human/L = mover
		var/brooch = L.ego_gift_list[BROOCH]
		if(istype(brooch, /datum/ego_gifts/stem))
			to_chat(L, span_nicegreen("The branches relax."))
			qdel(src)
			return TRUE

/obj/structure/apple_barrier/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_amount > 10)
		playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', 60, TRUE)

//VINE CODE: stolen alien weed code
/obj/structure/spreading/apple_vine
	gender = PLURAL
	name = "bitter flora"
	desc = "Branches that grow from wilting stems."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Med1"
	base_icon_state = "Med1"
	color = "#808000"
	max_integrity = 15
	resistance_flags = FLAMMABLE
	pass_flags_self = LETPASSTHROW
	armor = list(
		MELEE = 0,
		BULLET = 0,
		FIRE = -50,
		RED_DAMAGE = 20,
		WHITE_DAMAGE = 0,
		BLACK_DAMAGE = 80,
		PALE_DAMAGE = -50,
	)
	var/old_growth = FALSE
	/* Number of tries it takes to get through the vines.
		Patrol shuts off if the creature fails to move 5 times. */
	var/tangle = 2
	//Redundant and Ineffecient abnormality teamwork var.
	var/allow_abnopass = FALSE
	//Connected Abnormality.
	var/static/mob/living/simple_animal/hostile/abnormality/snow_whites_apple/connected_abno
	//strictly for crossed proc
	var/list/static/ignore_typecache
	var/list/static/atom_remove_condition

/obj/structure/spreading/apple_vine/Initialize()
	. = ..()

	//This is to register a abnormality if we dont have one
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/snow_whites_apple) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.vine_list += src

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

/obj/structure/spreading/apple_vine/Destroy()
	if(connected_abno)
		connected_abno.vine_list -= src
	return ..()

/* Only allows the user to pass if the proc returns TRUE.
	This proc doesnt like variables that were not defined
	inside of it.*/
/obj/structure/spreading/apple_vine/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	//List of things that trample vines.
	if(is_type_in_typecache(mover, atom_remove_condition))
		qdel(src)
		return TRUE
	//If we allow passage to other abnormalities
	if(isabnormalitymob(mover) && allow_abnopass)
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

/obj/structure/spreading/apple_vine/play_attack_sound(damage_amount, damage_type = BRUTE)
	playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', 60, TRUE)

/obj/structure/spreading/apple_vine/proc/VineEffect(mob/living/L)
	// They just flew over the vines. :/
	if(L.movement_type & FLYING)
		return TRUE

	//Extra Consideration for knives and bypasses
	if(ishuman(L))
		var/mob/living/carbon/human/lonely = L
		var/obj/item/trimming = lonely.get_active_held_item()
		var/brooch = lonely.ego_gift_list[BROOCH]
		if(istype(brooch, /datum/ego_gifts/stem))
			suiterReaction(lonely)
			return TRUE
		if(!isnull(trimming))
			if(istype(trimming, /obj/item/ego_weapon/stem))
				return TRUE
			var/weeding = trimming.get_sharpness()
			if(weeding == SHARP_EDGED && trimming.force >= 5)
				if(prob(10))
					to_chat(lonely, span_warning("You cut back [name] as it reaches for you."))
				else if(prob(10) || (prob(30) && old_growth))
					to_chat(lonely, span_warning("[name] stab your legs spitefully."))
					lonely.adjustBlackLoss(5)
				take_damage(15, BRUTE, "melee", 1)
				return TRUE

	//Entangling code
	if(tangle <= 0)
		tangle = initial(tangle)
		return TRUE

	tangle--
	if(prob(10))
		to_chat(L, span_danger("[src] block your path!"))

//Reaction to humans who have snow_whites_apple's gift.
/obj/structure/spreading/apple_vine/proc/suiterReaction(mob/living/carbon/human/lonely)
	var/lonelyhealth = (lonely.health / lonely.maxHealth) * 100
	if(prob(10))
		//it would be uncouth for the vines to hinder one gifted by the princess.
		to_chat(lonely, span_nicegreen("The branches open a path."))
	if(lonelyhealth <= 30 && lonely.stat != DEAD)
		lonely.adjustBruteLoss(-1)
		if(prob(2))
			lonely.whisper(pick(
				"First they had feasted upon my poisoned flesh, then I feasted upon them.",
				"Even after they left, my form would not decay.",
				"She cast me aside and left with her prince.",
				"After many days I wondered why I continued to exist.",
				"Those that trampled me would speak of a witch who casted a spell that had taken her life.",
			))

//Called by snow white when she attacks
/obj/structure/spreading/apple_vine/proc/VineAttack(hit_thing)
	if(isliving(hit_thing))
		var/mob/living/L = hit_thing
		if(L.stat != DEAD)
			new /obj/effect/temp_visual/vinespike(get_turf(L))
			return
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.stat == DEAD)
				var/obj/item/organ/eyes/B = H.getorganslot(ORGAN_SLOT_BRAIN)
				if(B)
					new /obj/effect/temp_visual/vinespike(get_turf(H))
					H.add_overlay(icon('ModularTegustation/Teguicons/tegu_effects.dmi', "f0442_victem"))
					B.Remove(H)
	else
		new /obj/effect/temp_visual/vinespike(get_turf(hit_thing))

//Makes the vines stronger and able to support protective barriers.
/obj/structure/spreading/apple_vine/proc/OverGrowth()
	name = "bitter growth"
	icon_state = "Hvy1"
	max_integrity = 45
	obj_integrity = 45
	expand_cooldown = 8 SECONDS
	conflict_damage = 30
	old_growth = TRUE

/obj/structure/spreading/apple_vine/proc/VineBarrier(vine_angle, single_spawn)
	new /obj/structure/apple_barrier(get_turf(src))
	//Spawn only 1 with this proc.
	if(single_spawn)
		return

	//Directional Calculation, only applies to cardinal directions.
	var/dir1
	var/dir2
	var/enemy_cardinal_dir = angle2dir_cardinal(vine_angle)
	switch(enemy_cardinal_dir)
		if(NORTH)
			dir1 = EAST
			dir2 = WEST
		if(SOUTH)
			dir1 = EAST
			dir2 = WEST
		if(EAST)
			dir1 = NORTH
			dir2 = SOUTH
		if(WEST)
			dir1 = NORTH
			dir2 = SOUTH

	//Additional Barriers. Barrier wont be placed if there isnt required weeds.
	var/turf/target_turf = get_step(src, dir1)
	if(!target_turf.is_blocked_turf())
		var/obj/structure/spreading/apple_vine/adjacent_vine = locate(/obj/structure/spreading/apple_vine) in target_turf
		if(adjacent_vine)
			if(adjacent_vine.old_growth)
				new /obj/structure/apple_barrier(target_turf)

	var/turf/target_turf2 = get_step(src, dir2)
	if(!target_turf2.is_blocked_turf())
		var/obj/structure/spreading/apple_vine/adjacent_vine2 = locate(/obj/structure/spreading/apple_vine) in target_turf2
		if(adjacent_vine2)
			if(adjacent_vine2.old_growth)
				new /obj/structure/apple_barrier(target_turf2)

//Special "Spell" for Player
/obj/effect/proc_holder/spell/pointed/apple_barrier
	name = "Branch Barrier"
	desc = "Twist older branches into a temporary defensive barrier."
	charge_max = FLORAL_BARRIER_COOLDOWN
	range = 9
	stat_allowed = FALSE
	clothes_req = FALSE
	player_lock = FALSE
	invocation = "none"
	invocation_type = "none"
	ranged_mousepointer = 'icons/effects/mouse_pointers/cult_target.dmi'
	action_icon = 'icons/mob/actions/actions_abnormality.dmi'
	action_background_icon_state = "bg_abnormality"
	action_icon_state = "apple_barrier"
	still_recharging_msg = "You need time to regain energy."
	active_msg = "You twist your branches..."
	deactive_msg = "You relax your branches..."

/obj/effect/proc_holder/spell/pointed/apple_barrier/can_target(atom/target, mob/user, silent = FALSE)
	if(istype(target, /obj/structure/spreading/apple_vine))
		var/obj/structure/spreading/apple_vine/A = target
		if(A.old_growth)
			return TRUE

/obj/effect/proc_holder/spell/pointed/apple_barrier/cast(list/targets, mob/user)
	if(!LAZYLEN(targets))
		to_chat(user, span_warning("No old growth in range!"))
		return FALSE
	if(!can_target(targets[1], user))
		return FALSE

	if(istype(targets[1], /obj/structure/spreading/apple_vine))
		var/obj/structure/spreading/apple_vine/vine = targets[1]
		vine.VineBarrier(Get_Angle(user, vine))

#undef FLORAL_BARRIER_COOLDOWN
