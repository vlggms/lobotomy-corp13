// Gold Dawn - Commander that heals its minions
/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion
	name = "Fallen Nepenthes"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "amurdad_corrosion"
	icon_living = "amurdad_corrosion"
	icon_dead = "amurdad_corrosion_dead"
	faction = list("gold_ordeal")
	maxHealth = 400
	health = 400
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 14
	pixel_x = -8
	base_pixel_x = -8
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/abnormalities/ebonyqueen/attack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1)
	speed = 1 //slow as balls
	move_to_delay = 20
	ranged = TRUE
	rapid = 2
	rapid_fire_delay = 10
	projectiletype = /obj/projectile/ego_bullet/ego_nightshade/healing //no friendly fire, baby!
	projectilesound = 'sound/weapons/bowfire.ogg'

/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion = 3
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE)

/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion
	name = "Beanstalk Searching for Jack"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "beanstalk"
	icon_living = "beanstalk"
	icon_dead = "beanstalk_dead"
	faction = list("gold_ordeal")
	maxHealth = 220
	health = 220
	melee_reach = 2 //Spear = long range
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 13
	attack_sound = 'sound/weapons/ego/spear1.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 1)

// Gold Noon - Boss with minions
/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion
	name = "Lady of the Lake"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "lake_corrosion"
	icon_living = "lake_corrosion"
	icon_dead = "lake_corrosion_dead"
	faction = list("gold_ordeal")
	maxHealth = 2500 //it's a boss, more or less
	health = 2500
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 18
	ranged = TRUE
	attack_verb_continuous = "bisects"
	attack_verb_simple = "bisects"
	attack_sound = 'sound/weapons/fixer/generic/blade3.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/chicken = 1)
	speed = 3
	move_to_delay = 3

	var/can_act = TRUE
	var/slash_width = 1
	var/slash_length = 3
	var/sweep_cooldown
	var/sweep_cooldown_time = 10 SECONDS
	var/sweep_damage = 50
	var/adds_spawned = FALSE

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion = 5
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE)

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/death(gibbed)
	for(var/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/A in world)
		A.BecomeVengeful()
	..()

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/face_atom() //VERY important; prevents spinning while slashing
	if(!can_act)
		return
	..()

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/OpenFire()
	if(!can_act)
		return
	if((sweep_cooldown < world.time) && (get_dist(src, target) < 3))
		AreaAttack()
		return

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/AttackingTarget()
	if(!can_act)
		return FALSE
	return Slash(target)

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/proc/Slash(target)
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, EAST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, WEST, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, SOUTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step_towards(source_turf, target), get_ranged_target_turf(source_turf, NORTH, slash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, slash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, slash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	playsound(get_turf(src), 'sound/weapons/fixer/generic/sheath2.ogg', 75, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(0.8 SECONDS)
	var/slash_damage = 35
	playsound(get_turf(src), 'sound/weapons/fixer/generic/blade3.ogg', 100, 0, 5)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T)
			if(faction_check_mob(L))
				continue
			if (L == src)
				continue
			HurtInTurf(T, list(), slash_damage, PALE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/bullet_act(obj/projectile/P)
	new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
	visible_message(span_userdanger("[P] is easily deflected by [src]!"))
	P.Destroy()
	return

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/attacked_by(obj/item/I, mob/living/user)
	var/checkdir = check_target_facings(user, src)
	if((get_dist(user, src) > 1) || checkdir == FACING_EACHOTHER)
		new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
		user.visible_message(span_danger("[user]'s attack is easily deflected by [src]!"), span_userdanger("Your attack is easily deflected by [src]!"))
		return
	CallForHelp(user)
	if(adds_spawned)
		return ..()
	if(health <= (maxHealth * 0.5))
		SpawnAdds()
	return ..()

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/proc/AreaAttack()
	if(sweep_cooldown > world.time)
		return
	sweep_cooldown = world.time + sweep_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/weapons/fixer/generic/dodge2.ogg', 100, 0, 5)
	for(var/turf/L in view(2, src))
		new /obj/effect/temp_visual/cult/sparks(L)
	SLEEP_CHECK_DEATH(12)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in HurtInTurf(T, list(), sweep_damage, PALE_DAMAGE, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE))
			if(L.health < 0)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H)) //The other way, someday.
					H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
				L.gib()
	playsound(get_turf(src), 'sound/weapons/fixer/generic/finisher1.ogg', 100, 0, 5)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/proc/CallForHelp(mob/living/attacker)
	for(var/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/girls in view(10, src))
		girls.TryTransform()
		girls.current_target = attacker
		girls.GiveTarget(attacker)
		attacker.apply_status_effect(/datum/status_effect/gold_guilty)

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/proc/SpawnAdds()
	if(QDELETED(src))
		return
	adds_spawned = TRUE
	visible_message(span_danger("[src] screams!"))
	playsound(get_turf(src), 'sound/voice/human/femalescream_3.ogg', 75, 0, 4)
	var/matrix/init_transform = transform
	animate(src, transform = transform*1.5, time = 3, easing = BACK_EASING|EASE_OUT)
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	for(var/i = 1 to 4)
		var/turf/T = get_step(get_turf(src), pick(valid_directions))
		var/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/nc = new(T)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	can_act = FALSE
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)
	SLEEP_CHECK_DEATH(50)
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion
	name = "Silent Handmaiden"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "silent_girl_corrosion"
	icon_living = "silent_girl_corrosion"
	icon_dead = "silent_girl_corrosion_dead"
	faction = list("gold_ordeal")
	maxHealth = 600
	health = 600
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 12
	melee_damage_upper = 18
	attack_sound = 'sound/weapons/fixer/generic/nail1.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list( /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	var/vengeful = FALSE
	var/current_target = null
	var/finishing = FALSE

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	if(!vengeful && the_target != current_target)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/Goto(target, delay, minimum_distance)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/DestroySurroundings()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/AttackingTarget()
	if(!vengeful && (target != current_target))
		return FALSE
	. = ..()
	if(.)
		if(!istype(target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/TH = target
		if(TH.health < 0 || TH.sanity_lost)
			finishing = TRUE
			TH.Stun(4 SECONDS)
			TH.SetImmobilized(4 SECONDS)
			forceMove(get_turf(TH))
			for(var/i = 1 to 5)
				if(!targets_from.Adjacent(TH) || QDELETED(TH) || TH.health > 0) // They can still be saved if you move them away
					finishing = FALSE
					return
				SLEEP_CHECK_DEATH(3)
				TH.attack_animal(src)
				for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
					H.deal_damage(15, WHITE_DAMAGE)
			if(!targets_from.Adjacent(TH) || QDELETED(TH) || TH.health > 0)
				finishing = FALSE
				return
			playsound(get_turf(src), 'sound/weapons/fixer/generic/nail2.ogg', 100, 1)
			TH.gib()
			finishing = FALSE

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/attacked_by(obj/item/I, mob/living/user)
	if(TryTransform())
		user.apply_status_effect(/datum/status_effect/gold_guilty)
	current_target = user
	GiveTarget(current_target)
	return ..()

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		if(TryTransform())
			M.apply_status_effect(/datum/status_effect/gold_guilty)
		current_target = M
		GiveTarget(current_target)

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/bullet_act(obj/projectile/P)
	if(!P.firer)
		return ..()
	if(!isliving(P.firer))
		return ..()
	. = ..()
	var/mob/living/firer = P.firer
	if(TryTransform())
		firer.apply_status_effect(/datum/status_effect/gold_guilty)
	current_target = firer
	GiveTarget(current_target)

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/proc/BecomeVengeful()
	TryTransform()
	vengeful = TRUE

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/proc/TryTransform()
	if(stat >= DEAD)
		return FALSE
	if(vengeful || current_target)
		return FALSE
	icon_state = "silent_girl_corrosion_angry"
	playsound(src, 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 15, FALSE)
	return TRUE

/datum/status_effect/gold_guilty
	id = "guilty"
	status_type = STATUS_EFFECT_REFRESH
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/gold_guilty
	var/mutable_appearance/guilt_icon

/atom/movable/screen/alert/status_effect/gold_guilty
	name = "Guilty"
	desc = "A heavy weight lays upon you. What have you done?\nAdditional white damage will be taken whenever damage is taken."

/datum/status_effect/gold_guilty/on_creation(mob/living/new_owner, ...)
	guilt_icon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER)
	. = ..()
	return

/datum/status_effect/gold_guilty/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_userdanger("You feel a heavy weight upon your shoulders."))
	status_holder.add_overlay(guilt_icon)
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(DealWhite))

/datum/status_effect/gold_guilty/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("You feel a weight lift from your shoulders."))
	playsound(get_turf(status_holder), 'sound/abnormalities/silentgirl/Guilt_Remove.ogg', 50, 0, 2)
	status_holder.cut_overlay(guilt_icon)
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)

/datum/status_effect/gold_guilty/proc/DealWhite(mob/living/carbon/human/owner, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	if(damagetype == WHITE_DAMAGE)
		return
	var/damage_amt = H.maxSanity * (damage/100) //Deals white the same way pale is dealt
	H.deal_damage(damage_amt, WHITE_DAMAGE)

// Gold Dusk - Commander that buffs its minion's attacks and wandering white damage
/mob/living/simple_animal/hostile/ordeal/centipede_corrosion
	name = "High-Voltage Centipede"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "centipede"
	icon_living = "centipede"
	icon_dead = "centipede_dead"
	faction = list("gold_ordeal")
	maxHealth = 1800
	health = 1800
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.7)
	butcher_results = list(/obj/item/food/meat/slab/robot = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 3
	var/pulse_cooldown
	var/pulse_cooldown_time = 4 SECONDS
	var/charge_level = 0
	var/charge_level_cap = 20
	var/broken = FALSE
	var/can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/CanAttack(atom/the_target)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion = 4
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE)

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/Life()
	. = ..()
	if(!.) //dead
		return FALSE
	if(pulse_cooldown <= world.time)
		Pulse()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/Pulse()//Periodic weak AOE attack, gain charge constantly
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(get_turf(src), 'sound/weapons/fixer/generic/energy2.ogg', 10, FALSE, 3)
	AdjustCharge(1)
	if(charge_level < 5 || broken)
		return
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(5, orgin)
	for(var/i = 0 to 2)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) != i)
				continue
			if(T.density)
				continue
			addtimer(CALLBACK(src, PROC_REF(PulseWarn), T), (3 * (i+1)) + 0.1 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(PulseHit), T), (3 * (i+1)) + 0.5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/PulseWarn(turf/T)
	new /obj/effect/temp_visual/cult/sparks(T)

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/PulseHit(turf/T)
	new /obj/effect/temp_visual/smash_effect(T)
	HurtInTurf(T, list(), 5, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	for(var/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/TB in T)
		if(TB.charged)
			continue
		TB.charged = TRUE
		playsound(get_turf(TB), 'sound/weapons/fixer/generic/energy3.ogg', 75, FALSE, 3)
		TB.visible_message(span_warning("[TB] absorbs the arcing electricity!"))
		new /obj/effect/temp_visual/healing/no_dam(get_turf(TB))

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/AdjustCharge(addition)
	charge_level = clamp(charge_level + addition, 0, charge_level_cap)
	update_icon()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/update_icon()
	if(stat >= DEAD)
		icon_state = icon_dead
		return
	if(!can_act) //We're recharging and want to stay in the recharging state
		return
	if(charge_level >= (charge_level_cap / 2))
		icon_state = "centipede_charged" + "[broken ? "_broken" : ""]"
		return
	icon_state = icon_living + "[broken ? "_broken" : ""]"

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/death(gibbed)
	if(!can_act) //Still recharging
		return FALSE
	if(charge_level)
		AdjustCharge(-20)
		Recharge()
		return FALSE
	..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/apply_damage(damage = 0,damagetype = RED_DAMAGE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, white_healable = FALSE)
	if(!can_act) //Prevents killing during recharge
		return FALSE
	..()

/mob/living/simple_animal/hostile/ordeal/centipede_corrosion/proc/Recharge()
	can_act = FALSE
	var/foundbattery
	for(var/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/battery in view(8, src))
		if(battery.stat == DEAD)
			continue
		if(!battery.Recharge(src))
			continue
		AdjustCharge(5)
		foundbattery = TRUE
		playsound(get_turf(battery), 'sound/weapons/fixer/generic/energy2.ogg', 10, FALSE, 3)
		break
	if(foundbattery)
		playsound(get_turf(src), 'sound/weapons/fixer/generic/energy3.ogg', 100, FALSE, 3)
		visible_message(span_warning("[src] absorbs the arcing electricity!"))
	if(!broken && !foundbattery)
		broken = TRUE
		charge_level_cap = 10
		AdjustCharge(charge_level_cap)
		pulse_cooldown_time = 60 SECONDS
	bruteloss = 0 //Prevents overkilling
	adjustBruteLoss(-25 * charge_level)
	icon_state = "centipede_blocking"
	SLEEP_CHECK_DEATH(4 SECONDS)
	can_act = TRUE
	update_icon()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion
	name = "Thunder Warrior"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "thunder_warrior"
	icon_living = "thunder_warrior"
	icon_dead = "thunder_warrior_dead"
	faction = list("gold_ordeal")
	maxHealth = 900
	health = 900
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_verb_continuous = "chops"
	attack_verb_simple = "chop"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_zombieattack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.7)
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 3
	ranged = TRUE
	projectiletype = /obj/projectile/thunder_tomahawk
	projectilesound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	var/charged = FALSE
	var/list/spawned_mobs = list()
	var/datum/beam/current_beam = null
	var/recharge_cooldown
	var/recharge_cooldown_time = 10 SECONDS


/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/proc/Recharge(atom/A)
	if(recharge_cooldown >= world.time)
		return FALSE
	recharge_cooldown = world.time + recharge_cooldown_time
	current_beam = Beam(A, icon_state="lightning[rand(1,12)]", time = 3 SECONDS)

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/AttackingTarget()
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	if(charged)
		L.deal_damage(15, BLACK_DAMAGE)
		playsound(get_turf(src), 'sound/weapons/fixer/generic/energyfinisher1.ogg', 75, 1)
		to_chat(L,span_danger("The [src] unleashes its charge!"))
		charged = FALSE
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		Convert(H)

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	playsound(src, 'sound/abnormalities/thunderbird/tbird_zombify.ogg', 45, FALSE, 5)
	var/mob/living/simple_animal/hostile/thunder_zombie/C = new(get_turf(src))
	if(!QDELETED(H))
		C.name = "[H.real_name]"//applies the target's name and adds the name to its description
		C.desc = "What appears to be [H.real_name], only charred and screaming incoherently..."
		C.gender = H.gender
		C.faction = src.faction
		C.master = src
		spawned_mobs += C
		H.gib()

/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion/death(gibbed)
	for(var/mob/living/A in spawned_mobs)
		A.gib()
	..()

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion
	name = "680 Ham Actor"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "680_ham_actor"
	icon_living = "680_ham_actor"
	icon_dead = "ham_actor_dead"
	faction = list("gold_ordeal")
	maxHealth = 1500
	health = 1500
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 10 //they're support, so they deal low damage
	melee_damage_upper = 15
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 4
	speak = list("Kilo India Lima Lima", "Delta India Echo", "Golf Echo Tango Oscar Uniform Tango", "Oscar Mike", "Charlie Mike")
	speak_emote = list("emits", "groans")
	var/effect_cooldown
	var/effect_cooldown_time = 4 SECONDS
	var/list/radio_sounds = list(
		'sound/effects/radio/radio1.ogg',
		'sound/effects/radio/radio2.ogg',
		'sound/effects/radio/radio3.ogg'
		)
	var/list/damage_sounds = list(
		'sound/abnormalities/khz/Clip1.ogg',
		'sound/abnormalities/khz/Clip2.ogg',
		'sound/abnormalities/khz/Clip3.ogg',
		'sound/abnormalities/khz/Clip4.ogg',
		'sound/abnormalities/khz/Clip5.ogg',
		'sound/abnormalities/khz/Clip6.ogg',
		'sound/abnormalities/khz/Clip7.ogg'
	)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/Initialize()
	..()
	var/list/old_speaklist = speak.Copy()
	speak = list()
	for(var/i in old_speaklist)
		for(var/ii in list("A","E","I","O","U","R","S","T"))//All vowels, and the 3 most common consonants
			i = replacetextEx(i,ii,pick("@","!","$","%","#"))
		speak.Add(i)

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/Life()
	. = ..()
	if(health <= 0)
		return
	if(effect_cooldown <= world.time)
		whisper("[pick(speak)]")
		playsound(get_turf(src), "[pick(damage_sounds)]", 25, FALSE)
		return

/mob/living/simple_animal/hostile/ordeal/KHz_corrosion/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	..()
	if(effect_cooldown >= world.time)
		return
	effect_cooldown = world.time + effect_cooldown_time
	var/radio_sound = pick(radio_sounds)
	var/found_radio
	for(var/mob/living/L in range(7, src))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			for(var/obj/item/radio/R in H.get_all_gear()) //less expensive than getallcontents
				R.emp_act(EMP_LIGHT)
				found_radio = TRUE
		if(!faction_check_mob(L))
			if(found_radio) //You can take off your radio to reduce the damage
				L.deal_damage(8, WHITE_DAMAGE)
				L.playsound_local(get_turf(L), "[radio_sound]",100)
			L.deal_damage(4, WHITE_DAMAGE)


//Gold Midnight
/mob/living/simple_animal/hostile/ordeal/tso_corrosion
	name = "Da Capo Al Fine"
	desc = "Improper use of E.G.O. can have serious consequences."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "al_fine"
	icon_living = "al_fine"
	icon_dead = "al_fine_dead"
	faction = list("gold_ordeal")
	maxHealth = 4000 //it's a boss, more or less
	health = 4000
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.2)
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1, /obj/item/food/meat/slab/human = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/chicken = 1)
	/// Range of the damage
	var/symphony_range = 20
	/// Amount of white damage every tick
	var/symphony_damage = 10
	/// When to perform next movement
	var/next_movement_time
	/// Current movement
	var/current_movement_num = -1
	/// List of effects currently spawned
	var/list/performers = list()

/mob/living/simple_animal/hostile/ordeal/tso_corrosion/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/tso_corrosion/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		DamagePulse()

/mob/living/simple_animal/hostile/ordeal/tso_corrosion/death(gibbed)
	for(var/obj/effect/silent_orchestra_singer/O in performers)
		O.fade_out()
	performers.Cut()
	return ..()

/mob/living/simple_animal/hostile/ordeal/tso_corrosion/Destroy() // in case it somehow gets deleted
	for(var/obj/effect/silent_orchestra_singer/O in performers)
		O.fade_out()
	performers.Cut()
	return ..()

/mob/living/simple_animal/hostile/ordeal/tso_corrosion/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/tso_corrosion/proc/DamagePulse()
	if(current_movement_num < 5)
		for(var/mob/living/L in livinginrange(symphony_range, get_turf(src)))
			if(L.z != z)
				continue
			if(faction_check_mob(L))
				continue
			var/dealt_damage = max(6, symphony_damage - round(get_dist(src, L) * 0.1))
			L.deal_damage(dealt_damage, WHITE_DAMAGE)

	if(world.time >= next_movement_time) // Next movement
		var/movement_volume = 50
		current_movement_num += 1
		symphony_range += 5
		switch(current_movement_num)
			if(0)
				next_movement_time = world.time + 4 SECONDS
			if(1)
				next_movement_time = world.time + 22 SECONDS
				ChangeResistances(list(PALE_DAMAGE = 1))
				spawn_performer(1, WEST)
			if(2)
				next_movement_time = world.time + 14.5 SECONDS
				ChangeResistances(list(BLACK_DAMAGE = 1))
				spawn_performer(2, WEST)
			if(3)
				next_movement_time = world.time + 11.5 SECONDS
				ChangeResistances(list(WHITE_DAMAGE = 1))
				symphony_damage = 18
				movement_volume = 3 // No more tinnitus
				spawn_performer(1, EAST)
			if(4)
				next_movement_time = world.time + 23 SECONDS
				ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 0))
				symphony_damage = 12
				spawn_performer(2, EAST)
			if(5)
				next_movement_time = world.time + 80 SECONDS
				ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
				movement_volume = 65 // TA-DA!!!
		if(current_movement_num < 6)
			sound_to_playing_players_on_level("sound/abnormalities/silentorchestra/movement[current_movement_num].ogg", movement_volume, zlevel = z)
			if(current_movement_num == 5)
				for(var/mob/living/carbon/human/H in livinginrange(symphony_range, get_turf(src)))
					if(H.sanity_lost || (H.sanityhealth < H.maxSanity * 0.5))
						var/obj/item/bodypart/head/head = H.get_bodypart("head")
						if(QDELETED(head))
							continue
						head.dismember()
						QDEL_NULL(head)
						H.regenerate_icons()
						H.visible_message(span_danger("[H]'s head explodes!"))
						new /obj/effect/gibspawner/generic/silent(get_turf(H))
						playsound(get_turf(H), 'sound/abnormalities/silentorchestra/headbomb.ogg', 50, 1)
				ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.2))
				SLEEP_CHECK_DEATH(60 SECONDS)
				current_movement_num = -1
				for(var/obj/effect/silent_orchestra_singer/O in performers)
					O.fade_out()
				performers.Cut()

/mob/living/simple_animal/hostile/ordeal/tso_corrosion/proc/spawn_performer(distance = 1, direction = EAST)
	var/turf/T = get_turf(src)
	for(var/i = 1 to distance)
		T = get_step(T, direction)
	var/obj/effect/silent_orchestra_singer/O = new(T)
	var/performer_icon_num = clamp(current_movement_num, 1, 4)
	O.icon_state = "silent_[performer_icon_num]"
	O.update_icon()
	performers += O
	return
