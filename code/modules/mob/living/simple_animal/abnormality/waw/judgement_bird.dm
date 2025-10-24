/mob/living/simple_animal/hostile/abnormality/judgement_bird
	name = "Judgement Bird"
	desc = "A bird that used to judge the living in the dark forest, carrying around an unbalanced scale."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "judgement_bird"
	icon_living = "judgement_bird"
	icon_dead = "judgement_bird_dead"
	core_icon = "jbird_egg"
	portrait = "judgement_bird"
	faction = list("hostile", "Apocalypse")
	speak_emote = list("chirps")

	pixel_x = -8
	base_pixel_x = -8
	del_on_death = FALSE

	ranged = TRUE
	minimum_distance = 6

	maxHealth = 800
	health = 800
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	see_in_dark = 10
	stat_attack = HARD_CRIT

	move_to_delay = 4
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 35, 45, 45),
		ABNORMALITY_WORK_INSIGHT = list(20, 20, 40, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 20, 35, 45, 45),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 12
	work_damage_type = PALE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath

	attack_action_types = list(/datum/action/innate/abnormality_attack/judgement)

	ego_list = list(
		/datum/ego_datum/weapon/justitia,
		/datum/ego_datum/armor/justitia,
	)
	gift_type =  /datum/ego_gifts/justitia
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/big_bird = 3,
		/mob/living/simple_animal/hostile/abnormality/punishing_bird = 3,
	)

	observation_prompt = "\"Long Bird\" who lived in the forest didn't want to let creatures to be eaten by monsters. <br>\
		His initial goal was pure, at least. <br>The forest began to be saturated by darkness. <br>His long vigil is saturated with memories and regrets."
	observation_choices = list(
		"Console the bird" = list(TRUE, "Long Bird put down his scales, that had been with him for a long time. <br>\
			The long-lasting judgement finally ends. <br>Long Bird slowly realizes the secrets behind the monster, and he waits. <br>For the forest that he will never take back."),
		"Leave him be" = list(FALSE, "Long Bird sees through you, even though he is blind. <br>He is weighing your sins."),
	)

	var/judgement_cooldown = 10 SECONDS
	var/judgement_cooldown_base = 10 SECONDS
	var/judgement_damage = 70
	var/judgement_range = 12
	var/judging = FALSE

/datum/action/innate/abnormality_attack/judgement
	name = "Judgement"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = span_colossus("You will now damage all enemies around you.")
	chosen_attack_num = 1

/mob/living/simple_animal/hostile/abnormality/judgement_bird/Move()
	if(judging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/judgement_bird/EscapeConfinement()
	if(!isturf(targets_from.loc) && targets_from.loc != null)//Did someone put us in something?
		if(istype(targets_from.loc, /mob/living/simple_animal/forest_portal) || istype(targets_from.loc, /mob/living/simple_animal/hostile/megafauna/apocalypse_bird))
			return
	. = ..()

/mob/living/simple_animal/hostile/abnormality/judgement_bird/AttackingTarget(atom/attacked_target)
	if(!target)
		GiveTarget(attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/judgement_bird/OpenFire()
	if(client)
		switch(chosen_attack)
			if(1)
				judgement()
		return

	if(judgement_cooldown <= world.time)
		judgement()

/mob/living/simple_animal/hostile/abnormality/judgement_bird/proc/judgement()
	if(judgement_cooldown > world.time)
		return
	judgement_cooldown = world.time + judgement_cooldown_base
	judging = TRUE
	icon_state = "judgement_bird_attack"
	playsound(get_turf(src), 'sound/abnormalities/judgementbird/pre_ability.ogg', 50, 0, 2)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/judgementbird/ability.ogg', 75, 0, 7)
	if(SSmaptype.maptype == "limbus_labs")
		for(var/obj/structure/obstacle in view(2, src))
			obstacle.take_damage(judgement_damage, PALE_DAMAGE)
		for(var/mob/living/L in oview(judgement_range, src))//Listen I need jbird to not kill people through walls if hes going to play nice
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			new /obj/effect/temp_visual/judgement(get_turf(L))
			var/dealt_damage = judgement_damage
			var/dist = get_dist(src, L)
			if(dist > 5)
				dealt_damage -= (dist - 5) * 5
			L.deal_damage(dealt_damage, PALE_DAMAGE)

	else
		for(var/mob/living/L in urange(judgement_range, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			new /obj/effect/temp_visual/judgement(get_turf(L))
			var/dealt_damage = judgement_damage
			var/dist = get_dist(src, L)
			if(dist > 5)
				dealt_damage -= (dist - 5) * 5
			L.deal_damage(dealt_damage, PALE_DAMAGE)

			if(L.stat == DEAD)	//Gotta fucking check again in case it kills you. Real moment
				if(!IsCombatMap())
					var/turf/T = get_turf(L)
					if(locate(/obj/structure/jbird_noose) in T)
						T = pick_n_take(T.reachableAdjacentTurfs())//if a noose is on this tile, it'll still create another one. You probably shouldn't be letting this many people die to begin with
						L.forceMove(T)
					var/obj/structure/jbird_noose/N = new(get_turf(L))
					N.buckle_mob(L)
					playsound(get_turf(L), 'sound/abnormalities/judgementbird/kill.ogg', 75, 0, 7)
					playsound(get_turf(L), 'sound/abnormalities/judgementbird/hang.ogg', 100, 0, 7)

	for(var/obj/vehicle/V in urange(judgement_range, src))
		for(var/mob/living/occupant in V.occupants)
			if(faction_check_mob(occupant, FALSE))
				continue
			if(occupant.stat == DEAD)
				continue
			new /obj/effect/temp_visual/judgement(get_turf(V))
			var/dealt_damage = judgement_damage
			var/dist = get_dist(src, V)
			if(dist > 5)
				dealt_damage -= (dist - 5) * 5
			occupant.deal_damage(dealt_damage, PALE_DAMAGE)

	icon_state = icon_living
	judging = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/judgement_bird/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

// Additional effects on work failure
/mob/living/simple_animal/hostile/abnormality/judgement_bird/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/judgement_bird/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(IsCombatMap())
		judgement_damage = 100
		return

//Burd down
/mob/living/simple_animal/hostile/abnormality/judgement_bird/death(gibbed)
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//On-kill visual effect
/obj/structure/jbird_noose
	name = "feathery noose"
	desc = "A structure found in the black forest."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "noose"
	pixel_x = -8
	base_pixel_x = -8
	max_integrity = 60
	buckle_lying = 0
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE

/obj/structure/jbird_noose/attack_hand(mob/user)
	if(!has_buckled_mobs())
		return ..()
	for(var/mob/living/L in buckled_mobs)
		user_unbuckle_mob(L, user)
	return

/obj/structure/jbird_noose/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(M.buckled)
		return
	var/response = alert(user,"Will you really hang [M]?","This looks painful","Yes","No")
	if(response == "Yes" && do_after(user, 10, M))
		return ..(M, user, check_loc = FALSE) //it just works
	to_chat(user, "You decide not to hang [M].")

/obj/structure/jbird_noose/buckle_mob(mob/living/M, force, check_loc, buckle_mob_flags)
	if(M.buckled)
		return
	M.adjustOxyLoss(75)
	M.adjustBruteLoss(5)
	M.setDir(2)
	M.pixel_x = M.base_pixel_x - 20
//	animate(M, pixel_z = 16, time = 30)
	addtimer(CALLBACK(src, PROC_REF(BuckleAnimation), M), 10)
	return ..()

/obj/structure/jbird_noose/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		release_mob(buckled_mob)

/obj/structure/jbird_noose/proc/release_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x
	unbuckle_mob(M,force=1)
	M.pixel_z = 0
	src.visible_message(text("<span class='danger'>[M] falls free of [src]!</span>"))
	M.update_icon()

/obj/structure/jbird_noose/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()

/obj/structure/jbird_noose/proc/BuckleAnimation(mob/living/M)
	set waitfor = FALSE
	animate(M, pixel_z = 16, time = 30)
