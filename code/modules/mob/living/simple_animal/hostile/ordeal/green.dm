// Green dawn
/mob/living/simple_animal/hostile/ordeal/green_bot
	name = "doubt"
	desc = "A slim robot with a spear in place of its hand."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "green_bot"
	icon_living = "green_bot"
	icon_dead = "green_bot_dead"
	faction = list("green_ordeal")
	maxHealth = 300
	health = 300
	speed = 2
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	melee_damage_lower = 26
	melee_damage_upper = 30
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/effects/ordeals/green/stab.ogg'
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)

	/// Can't move/attack when it's TRUE
	var/finishing = FALSE

/mob/living/simple_animal/hostile/ordeal/green_bot/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot/AttackingTarget()
	. = ..()
	if(.)
		if(!istype(target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/TH = target
		if(TH.health < 0)
			finishing = TRUE
			TH.Stun(4 SECONDS)
			forceMove(get_turf(TH))
			for(var/i = 1 to 7)
				if(!targets_from.Adjacent(TH) || QDELETED(TH)) // They can still be saved if you move them away
					finishing = FALSE
					return
				TH.attack_animal(src)
				for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
					H.apply_damage(3, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE, forced = TRUE)
				SLEEP_CHECK_DEATH(2)
			if(!targets_from.Adjacent(TH) || QDELETED(TH))
				return
			playsound(get_turf(src), 'sound/effects/ordeals/green/final_stab.ogg', 50, 1)
			TH.gib()
			for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
				H.apply_damage(20, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE, forced = TRUE)
			finishing = FALSE
