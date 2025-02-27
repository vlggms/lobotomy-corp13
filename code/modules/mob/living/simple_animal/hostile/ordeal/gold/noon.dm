// Gold Noon - Boss with minions
/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion
	name = "Lady of the Lake"
	desc = "An agent captain of the central command team, corrupted by an abnormality. But how?"
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
	butcher_results = list(/obj/item/food/meat/slab/corroded = 3)
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

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	return Slash(attacked_target)

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
	if(!can_act) //Too busy attacking to block
		return ..()
	new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
	visible_message(span_userdanger("[P] is easily deflected by [src]!"))
	P.Destroy()
	return

/mob/living/simple_animal/hostile/ordeal/white_lake_corrosion/attacked_by(obj/item/I, mob/living/user)
	if(!can_act) //Too busy attacking to block
		return ..()
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
		girls.TryTransform(attacker)
		girls.current_target = attacker
		girls.GiveTarget(attacker)

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
	desc = "A level 2 agent of Lobotomy Corporation that has somehow been corrupted by an abnormality."
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
	butcher_results = list( /obj/item/food/meat/slab/corroded = 1)
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

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/AttackingTarget(atom/attacked_target)
	if(!vengeful && (attacked_target != current_target))
		return FALSE
	. = ..()
	if(.)
		if(!ishuman(attacked_target))
			return
		var/mob/living/carbon/human/TH = attacked_target
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
	TryTransform(user)
	current_target = user
	GiveTarget(current_target)
	return ..()

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		TryTransform(M)
		current_target = M
		GiveTarget(current_target)

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/bullet_act(obj/projectile/P)
	if(!P.firer)
		return ..()
	if(!isliving(P.firer))
		return ..()
	. = ..()
	TryTransform(P.firer)
	current_target = P.firer
	GiveTarget(current_target)

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum) //thrown items
	var/obj/item/I
	if(istype(AM, /obj/item))
		I = AM
		if(I.thrownby)
			TryTransform(I.thrownby)
			current_target = I.thrownby
			GiveTarget(current_target)
			return ..()
	return ..()

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/proc/BecomeVengeful()
	TryTransform()
	vengeful = TRUE

/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion/proc/TryTransform(mob/living/carbon/human/hooman)
	if(stat >= DEAD)
		return
	if(vengeful || current_target)
		return
	if(istype(hooman))
		hooman.apply_status_effect(/datum/status_effect/gold_guilty)
	icon_state = "silent_girl_corrosion_angry"
	playsound(src, 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 15, FALSE)

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
