/mob/living/simple_animal/hostile/ordeal/hept/zwei
	desc = "An envy peccetulum, wearing zwei association gear."
	icon_state = "zwei_envy"
	icon_living = "zwei_envy"
	faction = list("hept_ordeal")
	health = 140
	maxHealth = 140
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	melee_damage_lower = 55
	melee_damage_upper = 55
	move_to_delay = 3
	rapid_melee = 1
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	speak_emote = list("says")
	ranged = 1
	var/list/buffed_envy

/mob/living/simple_animal/hostile/ordeal/hept/zwei/OpenFire()
	..()
	if(prob(30))
		return
	buffed_envy = list()
	for(var/mob/living/simple_animal/hostile/ordeal/hept/M in range(10, src))
		buffed_envy +=M
		M.ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5))
	addtimer(CALLBACK(src, PROC_REF(Return), src), 3 SECONDS)
	SLEEP_CHECK_DEATH(30)
	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/ordeal/hept/zwei/proc/Return()
	for(var/mob/living/simple_animal/hostile/ordeal/hept/M in buffed_envy)
		ChangeResistances(initial(damage_coeff))
