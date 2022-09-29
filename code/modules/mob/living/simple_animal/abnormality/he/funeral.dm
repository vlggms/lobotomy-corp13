/mob/living/simple_animal/hostile/abnormality/funeral
	name = "Funeral of the Dead Butterflies"
	desc = "An towering abnormality possessing a white butterfly for a head and a coffin on its back."
	icon = 'ModularTegustation/Teguicons/64x96.dmi' //HOW DO I TURN A PNG INTO THE DMI SPRITES AAAAAAAAAAAAAAA
	icon_state = "funeral"
	icon_living = "funeral"
	icon_dead = "funeral_dead"
	del_on_death = FALSE
	maxHealth = 1350 //I am a menace to society.
	health = 1350

	ranged = TRUE

	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 2)
	stat_attack = HARD_CRIT
	attack_action_types = list(/datum/action/innate/abnormality_attack/SpiritGun, /datum/action/innate/abnormality_attack/ButterflySwarm)

	faction = list("hostile")
	can_breach = TRUE
	can_buckle = FALSE
	vision_range = 14
	aggro_vision_range = 20
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(50, 45, 40, 0, 0),
						ABNORMALITY_WORK_INSIGHT = 50,
						ABNORMALITY_WORK_ATTACHMENT = 0,
						ABNORMALITY_WORK_REPRESSION = list(0, 0, 60, 60, 60),
						)
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	max_boxes = 16
	deathmessage = "floats into the air, descending into its own coffin."
	base_pixel_x = -16
	pixel_x = -16

	ego_list = list(
		/datum/ego_datum/weapon/solemnvow,
		/datum/ego_datum/weapon/solemnlament,
		/datum/ego_datum/armor/solemnlament
		)
	gift_type =  /datum/ego_gifts/solemnlament
	var/gun_cooldown
	var/gun_cooldown_time = 5 SECONDS
	var/gun_damage = 60
	var/swarm_cooldown
	var/swarm_cooldown_time = 30 SECONDS
	var/swarm_damage = 12
	var/swarm_length = 24
	var/swarm_width = 3
	var/can_act = TRUE
/datum/action/innate/abnormality_attack/SpiritGun
	name = "Bring to Rest"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "scroll"
	chosen_message = "<span class='colossus'>You will now fire butterflies.</span>"
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/ButterflySwarm
	name = "Empty Casket"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "scroll"
	chosen_message = "<span class='colossus'>You will now unleash a swarm of butterflies.</span>"
	chosen_attack_num = 2
/mob/living/simple_animal/hostile/abnormality/funeral/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/funeral/OpenFire()
	if(!can_act)
		return
	if(client)
		switch(chosen_attack)
			if(1)
				SpiritGun(target)
			if(2)
				ButterflySwarm(target)
		return
	if(swarm_cooldown <= world.time && prob(75))
		ButterflySwarm(target)
	else
		SpiritGun(target)
	return

/mob/living/simple_animal/hostile/abnormality/funeral/proc/SpiritGun(atom/target)
	if(!isliving(target)||gun_cooldown > world.time)
		return
	var/mob/living/cooler_target = target
	can_act = FALSE
	visible_message("<span class='userdanger'>[src] levels one of its arms at [cooler_target]!</span>")
	cooler_target.apply_status_effect(/datum/status_effect/spirit_gun_target) // Re-used for visual indicator
	gun_cooldown = world.time + gun_cooldown_time
	dir = get_cardinal_dir(src, target)
	SLEEP_CHECK_DEATH(1.75 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/funeral/spiritgun.ogg', 75, 1, 3)
	if(cooler_target in oview(src, 12))
		cooler_target.apply_damage(60, WHITE_DAMAGE, null, cooler_target.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		//No longer because fuck you.
		if(ishuman(target))
			var/mob/living/carbon/human/kickass_grade1_target = target
			//I'm not sorry.
			if(kickass_grade1_target.sanity_lost)
				kickass_grade1_target.apply_damage(9999, PALE_DAMAGE, null, kickass_grade1_target.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	//This should be brute. But also, it's funny.
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/funeral/proc/ButterflySwarm(target)
	if(swarm_cooldown > world.time)
		return
	if (get_dist(src, target) < 5)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, EAST, swarm_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, swarm_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, swarm_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, WEST, swarm_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, swarm_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, swarm_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, SOUTH, swarm_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, swarm_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, swarm_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, SOUTH, swarm_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, swarm_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, swarm_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			return
	if (!LAZYLEN(area_of_effect))
		return
	swarm_cooldown += world.time
	can_act = FALSE
	dir = dir_to_target
	visible_message("<span class='danger'>[src] prepares to open its coffin!</span>")
	icon_state = "funeral_coffin"
	SLEEP_CHECK_DEATH(3 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/funeral/coffin.ogg', 75, extrarange = 10, ignore_walls = TRUE) // bwiiiiiiinng >flapping
	for (var/i = 0; i < 24; i++)
		var/list/been_hit = list()
		for(var/turf/T in area_of_effect)
			new /obj/effect/temp_visual/funeral_swarm(T)
			for(var/mob/living/L in T)
				if(faction_check_mob(L) || (L in been_hit))
					continue
				if (L == src)
					continue
				been_hit += L
				L.apply_damage(swarm_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				if(ishuman(L))
					var/mob/living/carbon/human/cooler_L = L
					if(cooler_L.sanity_lost)
						cooler_L.apply_damage(9999, PALE_DAMAGE, null, cooler_L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		SLEEP_CHECK_DEATH(0.5 SECONDS)
	icon_state = icon_living
	can_act = TRUE
	//Do I know how to code instant death? Yes. Can I just do an absurd amount of pale damage? Also yes.
	//the spaghetti would be hilarious if this does spaghetti, though.
/mob/living/simple_animal/hostile/abnormality/funeral/Move()
	if(!can_act)
		return FALSE
	return ..()
//he walk

/mob/living/simple_animal/hostile/abnormality/funeral/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//he die
/mob/living/simple_animal/hostile/abnormality/funeral/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(70))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/funeral/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80)
		datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/funeral/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
	return ..()
//But most importantly
/mob/living/simple_animal/hostile/abnormality/funeral/breach_effect(mob/living/carbon/human/user)
	..()
	GiveTarget(user)
//He breach
	//I have no idea what i'm doing. All I know is that by some fucking miracle, this works.

/datum/status_effect/spirit_gun_target
	id = "butterfly_target"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = 1.75 SECONDS

/datum/status_effect/spirit_gun_target/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "funeral_swarm", -MUTATIONS_LAYER))

/datum/status_effect/spirit_gun_target/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "funeral_swarm", -MUTATIONS_LAYER))
