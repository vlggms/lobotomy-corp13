/mob/living/simple_animal/hostile/abnormality/judgement_bird
	name = "Judgement Bird"
	desc = "A bird that used to judge the living in the dark forest, carrying around an unbalanced scale."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "judgement_bird"
	icon_living = "judgement_bird"
	faction = list("hostile", "Apocalypse")
	speak_emote = list("chirps")

	pixel_x = -8
	base_pixel_x = -8

	ranged = TRUE
	minimum_distance = 6

	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	see_in_dark = 10
	stat_attack = HARD_CRIT

	speed = 3
	move_to_delay = 4
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(20, 20, 35, 45, 45),
						ABNORMALITY_WORK_INSIGHT = list(20, 20, 40, 50, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(20, 20, 35, 45, 45),
						ABNORMALITY_WORK_REPRESSION = 0
						)
	work_damage_amount = 10
	work_damage_type = PALE_DAMAGE

	attack_action_types = list(/datum/action/innate/abnormality_attack/judgement)

	ego_list = list(
		/datum/ego_datum/weapon/justitia,
		/datum/ego_datum/armor/justitia
		)
	gift_type =  /datum/ego_gifts/justitia
	var/judgement_cooldown = 10 SECONDS
	var/judgement_cooldown_base = 10 SECONDS
	var/judgement_damage = 65
	var/judgement_range = 8

/datum/action/innate/abnormality_attack/judgement
	name = "Judgement"
	icon_icon = 'icons/obj/wizard.dmi'
	button_icon_state = "magicm"
	chosen_message = "<span class='colossus'>You will now damage all enemies around you.</span>"
	chosen_attack_num = 1

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
	icon_state = "judgement_bird_attack"
	playsound(get_turf(src), 'sound/abnormalities/judgementbird/pre_ability.ogg', 50, 0, 2)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(get_turf(src), 'sound/abnormalities/judgementbird/ability.ogg', 75, 0, 7)
	for(var/mob/living/L in livinginrange(judgement_range, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/judgement(get_turf(L))
		L.apply_damage(judgement_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	icon_state = icon_living

/mob/living/simple_animal/hostile/abnormality/judgement_bird/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

// Additional effects on work failure
/mob/living/simple_animal/hostile/abnormality/judgement_bird/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

