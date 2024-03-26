/mob/living/simple_animal/hostile/abnormality/general_b
	name = "General Bee"
	desc = "A bee humanoid creature."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "generalbee"
	icon_living = "generalbee"
	speak_emote = list("buzzes")
	pixel_x = -8
	base_pixel_x = -8
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 45, 45, 50),
		ABNORMALITY_WORK_ATTACHMENT = 0,						//DO NOT FUCK THE BEEGIRL
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/loyalty,
		/datum/ego_datum/weapon/praetorian,
		/datum/ego_datum/armor/loyalty,
	)
	gift_type =  /datum/ego_gifts/loyalty
	loot = list(/obj/item/clothing/suit/armor/ego_gear/aleph/praetorian) // Don't think it was dropping before, this should make it do so
	//She doesn't usually breach. However, when she does, she's practically an Aleph-level threat. She's also really slow, and should pack a punch.
	health = 3000
	maxHealth = 3000
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	melee_damage_lower = 40
	melee_damage_upper = 52
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/queen_bee = 5,
	)
	//She has a Quad Artillery Cannon

	var/fire_cooldown_time = 3 SECONDS	//She has 4 cannons, fires 4 times faster than the artillery bees
	var/fire_cooldown
	var/fireball_range = 30
	var/volley_count
	//If the general has her post breach icon.
	var/static/true_breached = FALSE

/mob/living/simple_animal/hostile/abnormality/general_b/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/general_b/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/general_b/ZeroQliphoth(mob/living/carbon/human/user)
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return	//Yeah don't increase Qliphoth
	var/artillerbee_count = 0
	for(var/mob/living/simple_animal/hostile/artillery_bee/artillerbee in GLOB.mob_living_list)
		artillerbee_count++
	if(artillerbee_count < 4)
		SpawnBees()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/general_b/update_icon_state()
	icon = initial(icon)
	if(status_flags & GODMODE)
		// Not breaching
		//Normal bee or one eyed bee.
		if(true_breached)
			icon_living = "punished_bee"
		else
			icon_living = "generalbee"

	else if(stat == DEAD)
		icon_state = icon_dead
		return
	else
		icon = 'ModularTegustation/Teguicons/48x96.dmi'
		icon_living = "general_breach"
	icon_state = icon_living

/mob/living/simple_animal/hostile/abnormality/general_b/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((fire_cooldown < world.time))
		fireshell()

//Prevents special armor drop if not breached.
/mob/living/simple_animal/hostile/abnormality/general_b/drop_loot()
	if(status_flags & GODMODE)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/general_b/PostSpawn()
	..()
	update_icon()
/*
* General Bee Breach Sequence
* General Bee blurbs then puts her icon file to 48x96 before flicking her breach animation.
* Sleeps for 8 seconds so that her animation ends. Then she picks a department.
* Moves to the department, lists herself as true_breached, and spawns minions.
* Root code is called so that she is taken out of godmode. Then update_icon() is called.
*/
/mob/living/simple_animal/hostile/abnormality/general_b/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type != BREACH_PINK)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "My queen? I hear your cries...", 25))
		icon = 'ModularTegustation/Teguicons/48x96.dmi'
		flick("generalbee_", src)
		SLEEP_CHECK_DEATH(80)
	else
		//This is placed here so that her soldiers know its a party.
		faction += "pink_midnight"
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	//Call root code but with normal breach
	. = ..(null, BREACH_NORMAL)
	true_breached = TRUE
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(2, orgin)
	SpawnMinions(all_turfs, TRUE)
	datum_reference.qliphoth_change(-1)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/general_b/proc/SpawnMinions(list/spawn_turfs, copy_faction = FALSE)
	var/mob/living/simple_animal/spawn_minion
	for(var/turf/Y in spawn_turfs)
		if(prob(60))
			spawn_minion = new /mob/living/simple_animal/hostile/soldier_bee(Y)
		else if(prob(20))
			spawn_minion = new /mob/living/simple_animal/hostile/artillery_bee(Y)
		if(spawn_minion && copy_faction)
			spawn_minion.faction = faction.Copy()

/mob/living/simple_animal/hostile/abnormality/general_b/proc/fireshell()
	fire_cooldown = world.time + fire_cooldown_time
	var/list/targets = list()
	for(var/mob/living/L in livinginrange(fireball_range, src))
		if(L.z != z)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		targets += L
	if(!targets)
		return
	new /obj/effect/beeshell(get_turf(pick(targets)), faction)
	volley_count+=1
	if(volley_count>=4)
		volley_count=0
		fire_cooldown = world.time + fire_cooldown_time*3	//Triple cooldown every 4 shells

/mob/living/simple_animal/hostile/abnormality/general_b/proc/SpawnBees()
	var/X = pick(GLOB.xeno_spawn)
	var/turf/T = get_turf(X)
	new /mob/living/simple_animal/hostile/artillery_bee(T)
	for(var/y = 1 to 5)
		new /mob/living/simple_animal/hostile/soldier_bee(T)

/* Soldier bees */
/mob/living/simple_animal/hostile/soldier_bee
	name = "soldier bee"
	desc = "A disfigured creature with nasty fangs, and a snazzy cap"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "soldier_bee"
	icon_living = "soldier_bee"
	base_pixel_x = -8
	pixel_x = -8
	health = 450
	maxHealth = 450
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 14
	melee_damage_upper = 18
	rapid_melee = 2
	obj_damage = 200
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	death_sound = 'sound/abnormalities/bee/death.ogg'
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("buzzes")

/* Artillery bees */
/mob/living/simple_animal/hostile/artillery_bee
	name = "artillery bee"
	desc = "A disfigured creature with nasty fangs, and an oversized thorax"
	icon = 'ModularTegustation/Teguicons/48x96.dmi'
	icon_state = "artillerysergeant"
	icon_living = "artillerysergeant"
	friendly_verb_continuous = "scorns"
	friendly_verb_simple = "scorns"
	pixel_x = -8
	base_pixel_x = -8
	pixel_y = -8
	base_pixel_y = -8
	health = 200
	maxHealth = 200
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1) // Just so it's declared.
	del_on_death = TRUE
	death_sound = 'sound/abnormalities/bee/death.ogg'
	speak_emote = list("buzzes")

	var/fire_cooldown_time = 10 SECONDS
	var/fire_cooldown
	var/fireball_range = 30

/mob/living/simple_animal/hostile/artillery_bee/Initialize()
	fire_cooldown = world.time + fire_cooldown_time
	..()

/mob/living/simple_animal/hostile/artillery_bee/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((fire_cooldown < world.time))
		fireshell()

/mob/living/simple_animal/hostile/artillery_bee/proc/fireshell()
	fire_cooldown = world.time + fire_cooldown_time
	var/list/targets = list()
	for(var/mob/living/L in livinginrange(fireball_range, src))
		if(L.z != z)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		targets += L
	if(targets.len > 0)
		new /obj/effect/beeshell(get_turf(pick(targets)), faction)

/obj/effect/beeshell
	name = "bee shell"
	desc = "A target warning you of incoming pain"
	icon = 'icons/effects/effects.dmi'
	icon_state = "beetillery"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/boom_damage = 160 //Half Red, Half Black
	var/list/faction = list("hostile")
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/beeshell/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 3.5 SECONDS)

/obj/effect/beeshell/New(loc, ...)
	. = ..()
	if(args[2])
		faction = args[2]

//Smaller Scorched Girl bomb
/obj/effect/beeshell/proc/explode()
	playsound(get_turf(src), 'sound/effects/explosion2.ogg', 50, 0, 8)
	for(var/mob/living/L in view(2, src))
		if(faction_check(faction, L.faction, FALSE))
			continue
		L.apply_damage(boom_damage*0.5, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		L.apply_damage(boom_damage*0.5, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		if(L.health < 0)
			L.gib()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(4, get_turf(src))	//Make the smoke bigger
	S.start()
	qdel(src)

