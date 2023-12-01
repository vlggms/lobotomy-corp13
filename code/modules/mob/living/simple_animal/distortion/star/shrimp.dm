//The most dangerous base risk level. These should be almost exclusively bosses meant for multiple grade 1 fixers or a color.

//Coded by Coxswain, sprited by Coxswain
/mob/living/simple_animal/hostile/distortion/shrimp_rambo
	name = "Shrimp Rambo"
	desc = "A Shrimp Corp taboo hunter. Will a star of the city fall tonight?"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_rambo"
	maxHealth = 9001 //you asked for a star of the city
	health = 9001
	fear_level = ALEPH_LEVEL
	move_to_delay = 3
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	melee_damage_lower = 45
	melee_damage_upper = 80
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	rapid_melee = 2
	retreat_distance = 2
	minimum_distance = 3
	ranged = TRUE
	ranged_cooldown_time = 2
	rapid = 50
	rapid_fire_delay = 0.4
	projectilesound = 'sound/weapons/gun/smg/shot.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	casingtype = /obj/item/ammo_casing/caseless/soda_mini
	attack_sound = 'sound/abnormalities/distortedform/slam.ogg'

	ego_list = list(
		/obj/item/gun/ego_gun/shrimp/minigun,
		/obj/item/clothing/suit/armor/ego_gear/realization/wellcheers
		)

	egoist_names = list("Prawnold Schwarzenegger", "Swim Shady", "Shrimpy Smalls", "Shaqkrill O'Neill")
	gender = MALE
	egoist_outfit = /datum/outfit/job/fishing
	egoist_attributes = 100
	loot = list(/obj/item/gun/ego_gun/shrimp/minigun)
	unmanifest_effect = /obj/effect/temp_visual/water_waves
	can_spawn = 0

	var/unmanifesting

/mob/living/simple_animal/hostile/distortion/shrimp_rambo/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	FearEffect()
	if(unmanifesting)
		return
	if((health < (maxHealth * 0.03)))
		unmanifesting = TRUE
		Unmanifest() //Surrenders at about 270 hp - assuming it survives long enough

/mob/living/simple_animal/hostile/distortion/shrimp_rambo/PostUnmanifest(mob/living/carbon/human/egoist)
	playsound(get_turf(src), 'sound/abnormalities/wellcheers/ability.ogg', 75, 0)
	egoist.set_species(/datum/species/shrimp)
	return

/obj/item/ammo_casing/caseless/soda_mini
	name = "9mm soda casing"
	desc = "A 9mm soda casing."
	projectile_type = /obj/projectile/ego_bullet/ego_soda
	variance = 45
