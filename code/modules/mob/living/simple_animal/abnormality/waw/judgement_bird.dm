/mob/living/simple_animal/hostile/abnormality/judgement_bird
	name = "Judgement Bird"
	desc = "A bird that used to judge the living in the dark forest, carrying around an unbalanced scale."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "judgement_bird"
	icon_living = "judgement_bird"
	portrait = "judgement_bird"
	faction = list("hostile", "Apocalypse")
	speak_emote = list("chirps")

	pixel_x = -8
	base_pixel_x = -8

	ranged = TRUE
	minimum_distance = 6

	maxHealth = 2000
	health = 2000
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
	work_damage_amount = 10
	work_damage_type = PALE_DAMAGE

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

	var/judgement_cooldown = 10 SECONDS
	var/judgement_cooldown_base = 10 SECONDS
	var/judgement_damage = 45
	var/judgement_range = 12
	var/judging = FALSE
	var/list/birdlist = list()

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

/mob/living/simple_animal/hostile/abnormality/judgement_bird/AttackingTarget(atom/attacked_target)
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
	for(var/mob/living/L in livinginrange(judgement_range, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/judgement(get_turf(L))
		L.apply_damage(judgement_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)

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
				var/mob/living/simple_animal/hostile/runawaybird/V = new(get_turf(L))
				birdlist+=V
				V = new(get_turf(L))
				birdlist+=V

	icon_state = icon_living
	judging = FALSE

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
		judgement_damage = 65
		return

	var/mob/living/simple_animal/hostile/runawaybird/V = new(get_turf(src))
	birdlist+=V
	V = new(get_turf(src))
	birdlist+=V
	V = new(get_turf(src))
	birdlist+=V

//Kill all burds
//Burd down
/mob/living/simple_animal/hostile/abnormality/judgement_bird/death(gibbed)
	for(var/mob/living/V in birdlist)
		V.death()
	..()

//Runaway birds - Mini Simple Smile, 2 spawned after Jbird kills a player, and 2 on spawn.
/mob/living/simple_animal/hostile/runawaybird
	name = "runaway crow"
	desc = "A crow that has a menacing appearance.."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "runaway_bird"
	icon_living = "runaway_bird"
	pass_flags = PASSTABLE
	is_flying_animal = TRUE
	density = FALSE
	health = 100
	maxHealth = 100
	melee_damage_lower = 5
	melee_damage_upper = 8
	melee_damage_type = PALE_DAMAGE
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "pecks"
	attack_verb_simple = "peck"
	attack_sound = 'sound/weapons/fixer/generic/nail1.ogg'
	mob_size = MOB_SIZE_TINY
	del_on_death = TRUE
	a_intent = INTENT_HELP
	can_patrol = TRUE
	ranged = 1
	retreat_distance = 3
	minimum_distance = 1

/mob/living/simple_animal/hostile/runawaybird/AttackingTarget()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		L.Knockdown(20)
		var/obj/item/held = L.get_active_held_item()
		L.dropItemToGround(held) //Drop weapon

/mob/living/simple_animal/hostile/runawaybird/patrol_select()
	var/list/target_turfs = list()
	for(var/mob/living/simple_animal/hostile/abnormality/judgement_bird/J in GLOB.mob_list)
		if(J.z != z) // Not on our level
			continue
		if(get_dist(src, J) < 6) // Unnecessary for this distance
			continue
		target_turfs += get_turf(J)

	var/turf/target_turf = pick(target_turfs)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()

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
