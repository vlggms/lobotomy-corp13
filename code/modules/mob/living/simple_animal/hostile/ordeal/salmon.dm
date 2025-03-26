//April Fools Ordeal
/mob/living/simple_animal/hostile/ordeal/shrimp
	name = "wellcheers corp liquidation intern"
	desc = "A shrimp that is extremely hostile to you."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers"
	icon_living = "wellcheers"
	icon_dead = "wellcheers_dead"
	faction = list("shrimp")
	health = 400
	maxHealth = 400
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 24
	melee_damage_upper = 27
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("burbles")
	butcher_results = list(/obj/item/stack/spacecash/c50 = 1)
	guaranteed_butcher_results = list(/obj/item/stack/spacecash/c10 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 4)

/mob/living/simple_animal/hostile/ordeal/shrimp/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

/mob/living/simple_animal/hostile/ordeal/shrimp_soldier
	name = "wellcheers corp hired liquidation officer"
	desc = "A shrimp that is there to guard an area."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	icon_dead = "wellcheers_bad_dead"
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
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimpsoldier
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	butcher_results = list(/obj/item/stack/spacecash/c50 = 1)
	guaranteed_butcher_results = list(/obj/item/stack/spacecash/c20 = 1, /obj/item/stack/spacecash/c1 = 5)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 8, /obj/item/stack/sheet/silk/shrimple_advanced = 4)

/mob/living/simple_animal/hostile/ordeal/shrimp_soldier/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman
	name = "wellcheers corp Rifleman"
	desc = "Best shot this side of the fishing net."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	icon_dead = "wellcheers_bad_dead"
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
	butcher_results = list(/obj/item/stack/spacecash/c100 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 10, /obj/item/stack/sheet/silk/shrimple_advanced = 5)

/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

/mob/living/simple_animal/hostile/ordeal/senior_shrimp
	name = "wellcheers corp senior officer captain"
	desc = "An unnaturally jacked shrimp."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_ripped"
	icon_living = "wellcheers_ripped"
	icon_dead = "wellcheers_ripped_dead"
	faction = list("shrimp")
	health = 1500
	maxHealth = 1500
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.7)
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
	color = "#ff0000"
	butcher_results = list(/obj/item/stack/spacecash/c100 = 1, /obj/item/stack/spacecash/c50 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 12, /obj/item/stack/sheet/silk/shrimple_advanced = 6)
	can_patrol = TRUE

/mob/living/simple_animal/hostile/ordeal/senior_shrimp/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

/mob/living/simple_animal/hostile/ordeal/senior_shrimp/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/knockback, 3, FALSE, FALSE)

/mob/living/simple_animal/hostile/ordeal/shrimp_soldier/white
	name = "wellcheers corp hired liquidation shotgun team captain"
	health = 1500
	maxHealth = 1500
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.7)
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimpsoldier/white
	can_patrol = TRUE

/mob/living/simple_animal/hostile/ordeal/shrimp_soldier/white/Initialize()
	. = ..()
	var/white_icon
	var/icon/modified_icon = icon("[src.icon]", src.icon_state)
	modified_icon.MapColors(0.8,0.8,0.8, 0.2,0.2,0.2, 0.8,0.8,0.8, 0,0,0)
	white_icon = modified_icon
	icon = white_icon

/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman/black
	name = "wellcheers corp Rifleman captain"
	health = 1500
	maxHealth = 1500
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	color = "#45355e"
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimprifle/black
	can_patrol = TRUE

/mob/living/simple_animal/hostile/ordeal/shrimp/pale
	name = "wellcheers corp liquidation captain"
	health = 1000
	maxHealth = 1000
	melee_damage_type = PALE_DAMAGE
	color = "#12eaf1"
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.5)
	can_patrol = TRUE

//Easy Mode Rambo for midnight. Still gonna be rough regardless.
/mob/living/simple_animal/hostile/ordeal/salmon_midnight
	name = "Shrimp Rambo"
	desc = "A Shrimp Corp taboo hunter. Will a star of the city fall tonight?"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_rambo"
	maxHealth = 4000
	health = 4000
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	melee_damage_lower = 35
	melee_damage_upper = 50
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
