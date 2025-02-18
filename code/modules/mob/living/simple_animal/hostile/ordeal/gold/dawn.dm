// Gold Dawn - Commander that heals its minions
/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion
	name = "Fallen Nepenthes"
	desc = "A level 1 agent of Lobotomy Corporation that has somehow been corrupted by an abnormality."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "amurdad_corrosion"
	icon_living = "amurdad_corrosion"
	icon_dead = "amurdad_corrosion_dead"
	faction = list("gold_ordeal")
	maxHealth = 400
	health = 400
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 14
	pixel_x = -8
	base_pixel_x = -8
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/abnormalities/ebonyqueen/attack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 1)
	speed = 1 //slow as balls
	move_to_delay = 20
	ranged = TRUE
	rapid = 2
	rapid_fire_delay = 10
	projectiletype = /obj/projectile/ego_bullet/ego_nightshade/healing //no friendly fire, baby!
	projectilesound = 'sound/weapons/bowfire.ogg'

/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion = 3
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE)

/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion
	name = "Beanstalk Searching for Jack"
	desc = "A Lobotomy Corporation clerk that has been corrupted by an abnormality."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "beanstalk"
	icon_living = "beanstalk"
	icon_dead = "beanstalk_dead"
	faction = list("gold_ordeal")
	maxHealth = 220
	health = 220
	melee_reach = 2 //Spear = long range
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 7
	melee_damage_upper = 10
	attack_sound = 'sound/weapons/ego/spear1.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 1)
