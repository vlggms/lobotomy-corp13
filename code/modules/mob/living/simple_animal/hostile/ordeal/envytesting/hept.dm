// A testing
/mob/living/simple_animal/hostile/ordeal/hept
	name = "envy peccetulum"
	icon = 'ModularTegustation/Teguicons/envy_peccetulum.dmi'

/mob/living/simple_animal/hostile/ordeal/hept/beak
	desc = "An envy peccetulum, wearing beak EGO."
	icon_state = "beak_envy"
	icon_living = "beak_envy"
	faction = list("hept_ordeal")
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
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("says")
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_beak
	ranged_cooldown_time = 10
	projectilesound = 'sound/weapons/gun/smg/mp7.ogg'

/mob/living/simple_animal/hostile/ordeal/hept/beak/attacked_by(obj/item/I, mob/living/user)
	if(CanAttack(user)) // Retailate when attacked
		user.attack_animal(src)
	return ..()


/mob/living/simple_animal/hostile/ordeal/hept/daredevil
	desc = "An envy peccetulum, wearing daredevil EGO."
	icon_state = "daredevil_envy"
	icon_living = "daredevil_envy"
	faction = list("hept_ordeal")
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

/mob/living/simple_animal/hostile/ordeal/hept/daredevil/bullet_act(obj/projectile/P)
	visible_message(span_userdanger("[src] deflects \the [P]!"))
	P.Destroy()

/mob/living/simple_animal/hostile/ordeal/hept/fragment
	desc = "An envy peccetulum, wearing fragment EGO."
	icon_state = "fragment_envy"
	icon_living = "fragment_envy"
	faction = list("hept_ordeal")
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

/mob/living/simple_animal/hostile/ordeal/hept/fragment/AttackingTarget()
	..()
	SLEEP_CHECK_DEATH(10)
	new /obj/effect/temp_visual/weapon_stun(get_turf(src))
