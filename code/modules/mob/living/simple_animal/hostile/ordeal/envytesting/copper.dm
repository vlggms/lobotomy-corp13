/mob/living/simple_animal/hostile/ordeal/ipar/zwei
	desc = "An envy peccetulum, wearing zwei association gear."
	icon_state = "zwei_envy"
	icon_living = "zwei_envy"
	faction = list("ipar_ordeal")
	health = 140
	maxHealth = 140
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	melee_damage_lower = 40
	melee_damage_upper = 40
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

/mob/living/simple_animal/hostile/ordeal/ipar/zwei/OpenFire()
	if(prob(70))
		return
	buffed_envy = list()
	for(var/mob/living/simple_animal/hostile/ordeal/ipar/M in range(10, src))
		buffed_envy +=M
		M.ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5))
	addtimer(CALLBACK(src, PROC_REF(Return), src), 3 SECONDS)
	can_move = FALSE
	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/ordeal/ipar/zwei/proc/Return()
	for(var/mob/living/simple_animal/hostile/ordeal/ipar/M in buffed_envy)
		ChangeResistances(initial(M.damage_coeff))
	can_move = TRUE

/mob/living/simple_animal/hostile/ordeal/ipar/zweiriot
	desc = "An envy peccetulum, wearing zwei association gear."
	icon_state = "riot_envy"
	icon_living = "riot_envy"
	faction = list("ipar_ordeal")
	health = 140
	maxHealth = 140
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 0.8)
	melee_damage_lower = 20
	melee_damage_upper = 25
	move_to_delay = 4
	rapid_melee = 1
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "bonks"
	attack_verb_simple = "bonk"
	attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
	speak_emote = list("says")
	ranged = 1

/mob/living/simple_animal/hostile/ordeal/ipar/zweiriot/AttackingTarget()
	..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/T = target
	T.Jitter(20)
	T.set_confusion(max(10, T.get_confusion()))
	T.stuttering = max(8, T.stuttering)
	T.adjustStaminaLoss(melee_damage_lower, TRUE, TRUE)
	SEND_SIGNAL(T, COMSIG_LIVING_MINOR_SHOCK)
	playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
