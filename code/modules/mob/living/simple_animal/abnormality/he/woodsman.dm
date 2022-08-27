/mob/living/simple_animal/hostile/abnormality/woodsman
	name = "Warm-Hearted Woodsman"
	desc = "A mossy old robot that reeks of iron..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "woodsman"
	icon_living = "woodsman_breach"
	layer = BELOW_OBJ_LAYER
	maxHealth = 1433
	health = 1433
	ranged = TRUE
	attack_verb_continuous = "chops"
	attack_verb_simple = "chop"
	faction = list("hostile")
	attack_sound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 15
	melee_damage_upper = 30
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	vision_range = 14
	aggro_vision_range = 20
	attack_action_types = list(/datum/action/innate/abnormality_attack/woodsman_flurry)
	can_buckle = TRUE
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 45,
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = list(50, 60, 70, 80, 90),
						ABNORMALITY_WORK_REPRESSION = 45
						)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	base_pixel_x = -16
	pixel_x = -16

	ego_list = list(
		/datum/ego_datum/weapon/logging,
		/datum/ego_datum/armor/logging
		)
	gift_type =  /datum/ego_gifts/loggging
	var/flurry_cooldown = 0
	var/flurry_cooldown_time = 15 SECONDS
	var/flurry_count = 7
	var/flurry_small = 12
	var/flurry_big = 60 // It was requested that he beats their ass harder
	var/can_act = TRUE

/datum/action/innate/abnormality_attack/woodsman_flurry
	name = "Deforestation"
	icon_icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	button_icon_state = "training_rabbit"
	chosen_message = "<span class='colossus'>You will now attempt to fell all hearts in your path.</span>"
	chosen_attack_num = 1

/mob/living/simple_animal/hostile/abnormality/woodsman/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.stat == DEAD || (H.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(H, TRAIT_NODEATH)))
			Heal(H)
			return ..()
	if(isliving(target) && flurry_cooldown <= world.time && get_dist(src, target) <= 2 && prob(30))
		Woodsman_Flurry(target)
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/PickTarget(list/Targets) // We attack corpses first if there are any
	if (health > (maxHealth * 0.75))
		return ..()
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if((L.health < 0 || L.stat == DEAD) && ishuman(L))
			highest_priority += L
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/Heal(mob/living/carbon/human/body)
	src.adjustBruteLoss(-666) // Actually just the conversion of health he heals scaled to equivalent health that Helper has.
	for(var/obj/item/organ/O in body.getorganszone(BODY_ZONE_CHEST, TRUE))
		if(istype(O,/obj/item/organ/heart))
			O.Remove(body)
			QDEL_NULL(O)
			break
	body.gib()

/mob/living/simple_animal/hostile/abnormality/woodsman/CanAttack(atom/the_target)
	if(isliving(target) && !ishuman(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/woodsman/OpenFire()
	if(!can_act)
		return FALSE
	if(client)
		switch(chosen_attack)
			if(1)
				Woodsman_Flurry(target)
		return

	if(flurry_cooldown <= world.time)
		if(prob(75))
			Woodsman_Flurry(target)

/mob/living/simple_animal/hostile/abnormality/woodsman/proc/Woodsman_Flurry(target)
	if(flurry_cooldown > world.time)
		return
	if (get_dist(src, target) > 3)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/upper_bound
	var/turf/lower_bound
	switch(dir_to_target)
		if(EAST)
			for (var/i = 0; i < 3; i++)
				source_turf = get_step(source_turf, EAST)
				if (source_turf.density)
					break
				upper_bound = source_turf
				lower_bound = source_turf
				for (var/k = 0; k < 2; k++)
					if (get_step(upper_bound, NORTH).density)
						break
					upper_bound = get_step(upper_bound, NORTH)
				for (var/m = 0; m < 2; m++)
					if (get_step(lower_bound, SOUTH).density)
						break
					lower_bound = get_step(lower_bound, SOUTH)
				for(var/turf/T in getline(upper_bound, lower_bound))
					if (T.density || (T in area_of_effect))
						continue
					area_of_effect += T
		if(WEST)
			for (var/i = 0; i < 3; i++)
				source_turf = get_step(source_turf, WEST)
				if (source_turf.density)
					break
				upper_bound = source_turf
				lower_bound = source_turf
				for (var/k = 0; k < 2; k++)
					if (get_step(upper_bound, NORTH).density)
						break
					upper_bound = get_step(upper_bound, NORTH)
				for (var/m = 0; m < 2; m++)
					if (get_step(lower_bound, SOUTH).density)
						break
					lower_bound = get_step(lower_bound, SOUTH)
				for(var/turf/T in getline(upper_bound, lower_bound))
					if (T.density || (T in area_of_effect))
						continue
					area_of_effect += T
		if(SOUTH)
			for (var/i = 0; i < 3; i++)
				source_turf = get_step(source_turf, SOUTH)
				if (source_turf.density)
					break
				upper_bound = source_turf
				lower_bound = source_turf
				for (var/k = 0; k < 2; k++)
					if (get_step(upper_bound, EAST).density)
						break
					upper_bound = get_step(upper_bound, EAST)
				for (var/m = 0; m < 2; m++)
					if (get_step(lower_bound, WEST).density)
						break
					lower_bound = get_step(lower_bound, WEST)
				for(var/turf/T in getline(upper_bound, lower_bound))
					if (T.density || (T in area_of_effect))
						continue
					area_of_effect += T
		if(NORTH)
			for (var/i = 0; i < 3; i++)
				source_turf = get_step(source_turf, NORTH)
				if (source_turf.density)
					break
				upper_bound = source_turf
				lower_bound = source_turf
				for (var/k = 0; k < 2; k++)
					if (get_step(upper_bound, EAST).density)
						break
					upper_bound = get_step(upper_bound, EAST)
				for (var/m = 0; m < 2; m++)
					if (get_step(lower_bound, WEST).density)
						break
					lower_bound = get_step(lower_bound, WEST)
				for(var/turf/T in getline(upper_bound, lower_bound))
					if (T.density || (T in area_of_effect))
						continue
					area_of_effect += T
		else
			return
	if (!LAZYLEN(area_of_effect))
		return
	flurry_cooldown = world.time + flurry_cooldown_time
	can_act = FALSE
	face_atom(dir_to_target)
	playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 75, 0, 5)
	icon_state = "woodsman_prepare"
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	for (var/i = 0; i < flurry_count; i++)
		icon_state = icon_living
		var/list/been_hit = list()
		for(var/turf/T in area_of_effect)
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in T)
				if(faction_check_mob(L) || (L in been_hit))
					continue
				if (L == src)
					continue
				been_hit += L
				if (i > 6)
					L.apply_damage(flurry_big, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				else
					L.apply_damage(flurry_small, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if (i > 6)
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_strong.ogg', 100, 0, 8) // BAM
		else
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_attack.ogg', 75, 0, 5)
		SLEEP_CHECK_DEATH(0.25 SECONDS)
		icon_state = "woodsman_prepare"
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/woodsman/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	. = ..()
	if (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/woodsman/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/woodsman/OnQliphothChange(mob/living/carbon/human/user)
	. = ..()
	switch(datum_reference.qliphoth_meter)
		if(1)
			icon_state = "woodsman_prepare"
			playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 75, 0, 5)
		if(2)
			icon_state = "woodsman"

/mob/living/simple_animal/hostile/abnormality/woodsman/attempt_work(mob/living/carbon/human/user, work_type)
	. = ..()
	if (GODMODE in user.status_flags)
		return
	if(datum_reference.qliphoth_meter == 1)
		to_chat(user, "<span class='userdanger'>The Woodsman swings his axe down!</span>")
		datum_reference.qliphoth_change(-1)
		user.gib()

/mob/living/simple_animal/hostile/abnormality/woodsman/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if (!ishuman(M) || (GODMODE in M.status_flags))
		return FALSE
	. = ..()
	to_chat(user, "<span class='userdanger'>The Woodsman swings his axe down and...!</span>")
	SLEEP_CHECK_DEATH(2 SECONDS)
	for(var/obj/item/organ/O in M.getorganszone(BODY_ZONE_CHEST, TRUE))
		if(istype(O,/obj/item/organ/heart))
			O.Remove(M)
			QDEL_NULL(O)
			break
	M.gib()
	if (datum_reference.qliphoth_meter == 1)
		to_chat(user, "<span class='nicegreen'>Rests it on the ground.</span>")
		datum_reference.qliphoth_change(1)
		icon_state = "woodsman"
	else
		to_chat(user, "<span class='userdanger'>Stands up!</span>")
		datum_reference.qliphoth_change(-2)

/mob/living/simple_animal/hostile/abnormality/woodsman/breach_effect(mob/living/carbon/human/user)
	.=..()
	layer = LARGE_MOB_LAYER
	icon_state = icon_living
	if (!isnull(user))
		GiveTarget(user)

