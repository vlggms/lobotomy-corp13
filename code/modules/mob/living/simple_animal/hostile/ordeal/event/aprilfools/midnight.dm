/mob/living/simple_animal/hostile/ordeal/salmon_midnight
	name = "shrimp rambo"
	desc = "A Shrimp Corp taboo hunter. Will a star of the city fall tonight?"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_rambo"
	maxHealth = 1000
	health = 1000
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	melee_damage_lower = 12
	melee_damage_upper = 14
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	rapid_melee = 2
	retreat_distance = 2
	minimum_distance = 3
	ranged = TRUE
	ranged_cooldown_time = 2
	rapid = 25
	rapid_fire_delay = 0.4
	projectilesound = 'sound/weapons/gun/smg/shot.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	casingtype = /obj/item/ammo_casing/caseless/soda_mini
	attack_sound = 'sound/abnormalities/distortedform/slam.ogg'
