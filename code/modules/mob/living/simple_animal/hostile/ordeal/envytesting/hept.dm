// A testing
/mob/living/simple_animal/hostile/ordeal/ipar
	name = "envy peccetulum"
	icon = 'ModularTegustation/Teguicons/envy_peccetulum.dmi'
	var/can_move = TRUE

/mob/living/simple_animal/hostile/ordeal/ipar/Move()
	if(!can_move)
		return FALSE
	..()


/mob/living/simple_animal/hostile/ordeal/ipar/beak
	desc = "An envy peccetulum, wearing beak EGO."
	icon_state = "beak_envy"
	icon_living = "beak_envy"
	faction = list("ipar_ordeal")
	health = 140	//Same HP as you
	maxHealth = 140
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	melee_damage_lower = 21
	melee_damage_upper = 24
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/pbird_bite.ogg'
	speak_emote = list("says")
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = 'sound/weapons/gun/revolver/shot_alt.ogg'
	ranged_cooldown_time = 10
	projectilesound = 'sound/weapons/gun/smg/mp7.ogg'

/mob/living/simple_animal/hostile/ordeal/ipar/beak/attacked_by(obj/item/I, mob/living/user)
	if(CanAttack(user)) // Retailate when attacked
		user.attack_animal(src)
	return ..()


/mob/living/simple_animal/hostile/ordeal/ipar/daredevil
	desc = "An envy peccetulum, wearing daredevil EGO."
	icon_state = "daredevil_envy"
	icon_living = "daredevil_envy"
	faction = list("ipar_ordeal")
	health = 140
	maxHealth = 140
	melee_damage_type = PALE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 16
	melee_damage_upper = 17
	rapid_melee = 3
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	speak_emote = list("says")

/mob/living/simple_animal/hostile/ordeal/ipar/daredevil/bullet_act(obj/projectile/P)
	visible_message(span_userdanger("[src] deflects \the [P]!"))
	P.Destroy()

/mob/living/simple_animal/hostile/ordeal/ipar/fragment
	desc = "An envy peccetulum, wearing fragment EGO."
	icon_state = "fragment_envy"
	icon_living = "fragment_envy"
	faction = list("ipar_ordeal")
	health = 140
	maxHealth = 140
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 32
	melee_damage_upper = 35
	rapid_melee = 1
	melee_reach = 2
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/ego/spear1.ogg'
	speak_emote = list("says")

/mob/living/simple_animal/hostile/ordeal/ipar/fragment/AttackingTarget()
	..()
	can_move = FALSE
	addtimer(CALLBACK(src, PROC_REF(Return), src), 10)
	new /obj/effect/temp_visual/weapon_stun(get_turf(src))

/mob/living/simple_animal/hostile/ordeal/ipar/fragment/proc/Return()
	can_move = TRUE
