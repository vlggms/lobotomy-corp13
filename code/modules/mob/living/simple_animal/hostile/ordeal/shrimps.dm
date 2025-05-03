// An LC13 Original. Totally.
/mob/living/simple_animal/hostile/shrimp_rifleman
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
	attack_sound = 'sound/weapons/punch2.ogg'
	speak_emote = list("burbles")
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimprifle
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	butcher_results = list(/obj/item/stack/spacecash/c100 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 10, /obj/item/stack/sheet/silk/shrimple_advanced = 5)

/mob/living/simple_animal/hostile/shrimp_rifleman/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

//friendly spawned shrimp from soda E.G.O.'s passive
/mob/living/simple_animal/hostile/shrimp/grieving
	name = "wellcheers obituary serviceman"
	desc = "A shrimp that appears to be grieving. A moment of silence, please."
	icon_state = "wellcheers_funeral"
	icon_living = "wellcheers_funeral"
	faction = list("neutral", "shrimp")

// extra buff shrimp i guess
/mob/living/simple_animal/hostile/senior_shrimp
	name = "wellcheers corp senior officer"
	desc = "An unnaturally jacked shrimp."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_ripped"
	icon_living = "wellcheers_ripped"
	icon_dead = "wellcheers_ripped_dead"
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
	butcher_results = list(/obj/item/stack/spacecash/c100 = 1, /obj/item/stack/spacecash/c50 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 12, /obj/item/stack/sheet/silk/shrimple_advanced = 6)

/mob/living/simple_animal/hostile/senior_shrimp/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

/mob/living/simple_animal/hostile/senior_shrimp/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/knockback, 3, FALSE, FALSE)

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
	attack_sound = 'sound/weapons/punch1.ogg'
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
	health = 500
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
	attack_sound = 'sound/weapons/punch3.ogg'
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
	desc = "He is here on ofishal business."
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
	attack_sound = 'sound/weapons/punch2.ogg'
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

/mob/living/simple_animal/hostile/ordeal/salmon_dusk
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	faction = list("shrimp")
	health = 1000
	maxHealth = 1000
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 18
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/punch4.ogg'
	speak_emote = list("burbles")
	can_patrol = TRUE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/Initialize(mapload)
	. = ..()
	var/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/shrimp_soldier = 1,
		/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman = 1,
		/mob/living/simple_animal/hostile/ordeal/shrimp = 1,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add)

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red
	name = "shrimp minigunner"
	desc = "A shrimp intern that watched too many rambo films."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	ranged = 5
	rapid = 20
	rapid_fire_delay = 0.4
	move_to_delay = 5
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/red_minigun
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	var/shooting = FALSE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Move()
	if(shooting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Goto(target, delay, minimum_distance)
	if(shooting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/DestroySurroundings()
	if(shooting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/OpenFire(atom/A)
	shooting = TRUE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Initialize()
	. = ..()
	color = COLOR_RED

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Life()
	. = ..()
	if(shooting)
		SLEEP_CHECK_DEATH(0.4)
		shooting = FALSE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/white
	name = "shrimp sniper"
	desc = "Known by their fellow shrimps as \"The white buoys\"."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	ranged = 2.5
	move_to_delay = 5
	vision_range = 27 //three screens away
	retreat_distance = 8
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/white_sniper
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/white/Initialize()
	. = ..()
	var/white_icon //To actually make it white I gotta do this sadly
	var/icon/modified_icon = icon("[src.icon]", src.icon_state)
	modified_icon.MapColors(0.8,0.8,0.8, 0.2,0.2,0.2, 0.8,0.8,0.8, 0,0,0)
	white_icon = modified_icon
	icon = white_icon

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black
	name = "shrimp shanker"
	desc = "Do you like fish sticks?"
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.8)
	rapid_melee = 4
	move_to_delay = 2.4
	melee_damage_lower = 10
	melee_damage_upper = 12
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slashes"
	attack_sound = 'sound/weapons/purple_tear/stab2.ogg'
	var/fast_mode = FALSE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/Initialize()
	. = ..()
	color = COLOR_PURPLE

// Modified patrolling
/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/patrol_select()
	fast_mode = TRUE
	var/list/target_turfs = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4 || H.stat != DEAD)
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, /turf/proc/Distance_cardinal, 0, 200)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/MoveToTarget(list/possible_targets)
	if(get_dist(src, target) >= 3)
		fast_mode = TRUE
	if(get_dist(src, target) <= 1)
		fast_mode = FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/Life()
	. = ..()
	if(fast_mode)
		move_to_delay = 0.6//fast as fuck boi!
	if(!fast_mode)
		move_to_delay = 2.4

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/pale
	name = "shrimp soulshot"
	desc = "One hot skillet and a side of grits and you get soul food."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 8
	melee_damage_upper = 12
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.2)
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/pale_shotgun
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/pale/Initialize()
	. = ..()
	color = COLOR_CYAN

//Easy Mode Rambo for midnight. Still gonna be rough regardless.
/mob/living/simple_animal/hostile/ordeal/salmon_midnight
	name = "shrimp rambo"
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
