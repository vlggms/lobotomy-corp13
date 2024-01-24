GLOBAL_LIST_EMPTY(meat_list)

/mob/living/simple_animal/hostile/abnormality/last_shot
	name = "Til the Last Shot"
	desc = "A large ball of flesh, pulsating slowly."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "last_shot"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 3100
	health = 3100
	threat_level = ALEPH_LEVEL

	work_chances = list( //Calculated later
		ABNORMALITY_WORK_INSTINCT = 55,
		ABNORMALITY_WORK_INSIGHT = 15,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 0, 0, 0),
		ABNORMALITY_WORK_REPRESSION = 40,
	)

	work_damage_amount = 5		//Damage is low, could be doubled or quadrupled.
	work_damage_type = RED_DAMAGE
	max_boxes = 27
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	start_qliphoth = 2
	can_breach = TRUE	//can't move so you know

	ego_list = list(
		/datum/ego_datum/weapon/willing,
		/datum/ego_datum/armor/willing,
	)
	var/list/gremlins = list()	//For the meatballs
	var/list/meat = list()		//For the floors

	var/spawn_cooldown
	var/spawn_cooldown_time = 30 SECONDS	//Spawns 2 goobers every 30 seconds
	var/spawn_number = 2


//Sits in containment until killed.
/mob/living/simple_animal/hostile/abnormality/last_shot/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/last_shot/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/last_shot/PostSpawn()
	..()
	for(var/turf/open/O in range(1, src))
		new /obj/structure/meatfloor (O)

/mob/living/simple_animal/hostile/abnormality/last_shot/WorkChance(mob/living/carbon/human/user, chance)
	//Sorry bucko, give into the pleasures of flesh. Bonuses for low temp
	var/newchance = chance
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) <= 80)
		newchance += 20
	else if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 100)
		newchance -= 20

	work_damage_amount = initial(work_damage_amount)

	//Fort or justice too low? take more damage.
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) <= 100)
		work_damage_amount*=2

	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <= 100)
		work_damage_amount*=2

	return newchance

/mob/living/simple_animal/hostile/abnormality/last_shot/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return


/mob/living/simple_animal/hostile/abnormality/last_shot/Life()
	. = ..()
	if(!.)
		return FALSE
	if((spawn_cooldown < world.time) && !(status_flags & GODMODE))
		spawn_cooldown = world.time + spawn_cooldown_time
		MeatSpawn()

/mob/living/simple_animal/hostile/abnormality/last_shot/proc/MeatSpawn()
	for(var/i=spawn_number, i>=1, i--)	//This counts down.
		var/mob/living/simple_animal/hostile/meatblob/V = new(get_turf(src))
		gremlins+=V
	return

/mob/living/simple_animal/hostile/abnormality/last_shot/death()

	for(var/mob/living/simple_animal/hostile/meatblob/V in gremlins)
		QDEL_NULL(V)
		gremlins-=V

	for(var/Y in GLOB.meat_list)
		QDEL_NULL(Y)
		GLOB.meat_list-=Y
	..()

//They mostly are supposed to be slow ranged goobers
/mob/living/simple_animal/hostile/meatblob
	name = "flesh ball"
	desc = "A writhing ball of flesh."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "meatboi"
	icon_living = "meatboi"
	faction = list("hostile")
	health = 500
	maxHealth = 500
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	melee_damage_lower = 15
	melee_damage_upper = 20
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomps"
	attack_sound = 'sound/effects/attackblob.ogg'
	speak_emote = list("gargles")
	move_to_delay = 4.5
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	projectiletype = /obj/projectile/fleshblob
	projectilesound = 'sound/effects/attackblob.ogg'
	can_patrol = TRUE


/mob/living/simple_animal/hostile/meatblob/Move()
	..()
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/structure/meatfloor) in get_turf(src))
		return
	new /obj/structure/meatfloor(loc)


// The MEAT FLOOR
/obj/structure/meatfloor
	gender = PLURAL
	name = "bloodied flesh"
	desc = "some seemingly rotten meat."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "meatvine"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	base_icon_state = "meatvine"

/obj/structure/meatfloor/Initialize()
	. = ..()

	GLOB.meat_list += src

/obj/structure/meatfloor/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.Immobilize(10)
