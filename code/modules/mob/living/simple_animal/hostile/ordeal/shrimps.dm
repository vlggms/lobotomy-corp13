/mob/living/simple_animal/hostile/shrimp_rifleman
	name = "wellcheers corp Rifleman"
	desc = "Best shot this side of the fishing net."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	faction = list("shrimp")
	health = 500	//They're here to help
	maxHealth = 500
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 14
	melee_damage_upper = 18
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("burbles")
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimprifle
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'


	//extra buff shrimp i guess
/mob/living/simple_animal/hostile/senior_shrimp
	name = "wellcheers corp senior officer"
	desc = "An unnaturally jacked shrimp."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_ripped"
	icon_living = "wellcheers_ripped"
	faction = list("shrimp")
	health = 1337
	maxHealth = 1337
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 20
	move_to_delay = 4
	melee_damage_upper = 24
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/effects/meteorimpact.ogg'
	speak_emote = list("burbles")

/mob/living/simple_animal/hostile/senior_shrimp/ComponentInitialize()
	..()
	AddComponent(/datum/component/knockback, 3, FALSE, FALSE)
