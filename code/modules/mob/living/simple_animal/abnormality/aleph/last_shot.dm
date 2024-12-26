GLOBAL_LIST_EMPTY(meat_list)

/mob/living/simple_animal/hostile/abnormality/last_shot
	name = "Til the Last Shot"
	desc = "A large ball of flesh, pulsating slowly."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "last_shot"
	core_icon = "last_shot"
	portrait = "last_shot"
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
	gift_type = /datum/ego_gifts/willing

	observation_prompt = "The room reeks of sickly sweet rot and blood. <br>Every moment inside of here makes your head spin. <br>\
		\"Attention!\" <br>The mass of flesh in the center of the room calls out to you. <br>\
		\"You won't survive out there. <br>Every single day in this facility is a constant, unending battle.\" <br>\
		\"The only way you'll survive is if you join me. <br>To serve L-Corp til your last breath.\" <br>\
		A tendril of rotten meat is held out to you, beckoning for you to join it."
	observation_choices = list(
		"EMBRACE IT" = list(TRUE, "You grab onto the tendril. You can feel your flesh tingling. <br>\
			\"Good choice.\" <br>\
			\"Don't worry. <br>You won't regret this, you know? <br>This is the only path you had.\" <br>\
			\"You're dead meat out there. <br>Might as well accept who you are.\""),
		"REJECT IT" = list(FALSE, "You slap the tendril away. <br>\
			\"Feh. <br>So be it. <br>You won't survive out there, you know?\" <br>\
			\"When there's nothing left of the staff but blood and gore, I'll remain. <br>Do you understand?\" <br>\
			You can't help but to shudder in disgust as you exit the cell. <br>Was it right? You'll never know."),
	)

	var/list/gremlins = list()	//For the meatballs
	var/list/meat = list()		//For the floors

	var/spawn_cooldown
	var/spawn_cooldown_time = 30 SECONDS	//Spawns 2 goobers every 30 seconds and spreads vines
	var/spawn_number = 2
	var/meat_reach = 3


/mob/living/simple_animal/hostile/abnormality/last_shot/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/last_shot/BreachEffect()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	..()

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
		newchance -= 10

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
		MeatSpread() //Deliberately called after meatspawn(), so that barriers don't instantly appear

/mob/living/simple_animal/hostile/abnormality/last_shot/proc/MeatSpawn()
	var/gunnerchance = (100 / meat_reach) //Less likely to get gunners later on
	for(var/i=spawn_number, i>=1, i--)	//This counts down. - Spawn meat guards
		if(prob(gunnerchance))
			var/mob/living/simple_animal/hostile/meatblob/gunner/G = new(get_turf(src))
			gremlins+=G
			continue
		if(prob(gunnerchance))
			var/mob/living/simple_animal/hostile/meatblob/gunner/sniper/S = new(get_turf(src))
			gremlins+=S
			continue
		if(prob(gunnerchance))
			var/mob/living/simple_animal/hostile/meatblob/gunner/shotgun/SG = new(get_turf(src))
			gremlins+=SG
			continue
		else
			var/mob/living/simple_animal/hostile/meatblob/V = new(get_turf(src))
			gremlins+=V

	for(var/turf/open/L in view(7, src)) //Spawn barricades on meat
		if((get_dist(src, L) % 2 != 1))
			continue
		if(!IsSafeTurf(L))
			continue
		if(!locate(/obj/structure/meatfloor) in L) //No floor for the barricade
			continue
		if(locate(/obj/structure/barricade/meatbags) in L) //There's already a barricade there
			continue
		if(prob(100 - (10 * get_dist(src, L)))) //Less likely to spawn the further away it is
			new /obj/structure/barricade/meatbags(L)

	var/guards_count = 0 //How many armed blobs do we have nearby?
	for(var/mob/living/simple_animal/hostile/meatblob/theblob in range(meat_reach, src))
		if(!is_type_in_list(theblob, subtypesof(/mob/living/simple_animal/hostile/meatblob))) //It's unarmed
			continue
		if(theblob.can_patrol)
			continue
		guards_count += 1
		if(guards_count > 2) //We have enough guards
			theblob.can_patrol = TRUE //Send the rest out
	return

/mob/living/simple_animal/hostile/abnormality/last_shot/proc/MeatSpread() //THE ROT CONSUMES ALL
	for(var/turf/L in range(meat_reach, src)) //Spread out meat like a blob does
		if(!isturf(L) || isspaceturf(L))
			continue
		if(locate(/obj/structure/meatfloor) in L)
			continue
		new /obj/structure/meatfloor(L)
	meat_reach = clamp(meat_reach + 1, 0, 10) //MEAT!!!!!

/mob/living/simple_animal/hostile/abnormality/last_shot/death()
	for(var/V in gremlins)
		QDEL_NULL(V)
		gremlins-=V

	for(var/Y in GLOB.meat_list)
		QDEL_NULL(Y)
		GLOB.meat_list-=Y
	..()

//////////////
//STRUCTURES//
//////////////

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
		if(prob(25))
			H.Immobilize(5)
			to_chat(H, span_warning("Your foot gets caught on the meat vines!"))

/obj/structure/barricade/meatbags
	name = "meat barricade"
	desc = "Bags of meat. Weird, but self explanatory."
	icon = 'icons/obj/smooth_structures/sandbags.dmi'
	icon_state = "meatbags-0"
	base_icon_state = "meatbags"
	max_integrity = 300
	density = FALSE //non-human mobs can pass through
	proj_pass_rate = 50
	pass_flags_self = LETPASSTHROW
	bar_material = 3 //Didnt want to make a meat bar_material, thankfully this one does nothing
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SANDBAGS)
	canSmoothWith = list(SMOOTH_GROUP_SANDBAGS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SECURITY_BARRICADE)
	can_buckle = TRUE //For climbing code
	max_buckled_mobs = 1
	color = COLOR_DARK_RED
	var/list/punchthrough = list(
	/obj/projectile/bonebullet,
	/obj/projectile/bonebullet/bonebullet_piercing
	)

/obj/structure/barricade/meatbags/Initialize()
	. = ..()
	GLOB.meat_list += src

/obj/structure/barricade/meatbags/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(ishuman(mover))
		return FALSE
	if(ismecha(mover))
		return FALSE
	if(is_type_in_list(mover, punchthrough))
		return TRUE
	return ..()

//I didn't want to rewrite the entire climbable datum so now climbing is hardcoded
/obj/structure/barricade/meatbags/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("You don't need to do this."))
		return
	if(M != user)
		to_chat(user, span_warning("You start pulling [M] over the wall."))
		if(do_after(user, 1.5 SECONDS)) //If you're going to throw someone else, they have to be dead first.
			M.forceMove(get_turf(src))
		return

	to_chat(user, span_warning("You start climbing over the wall."))
	if(!do_after(user, 1.5 SECONDS))
		to_chat(user, span_notice("You decide against climbing."))
		return
	M.forceMove(get_turf(src))
	return

////////
//MOBS//
////////

//They mostly are supposed to be slow goobers
/mob/living/simple_animal/hostile/meatblob
	name = "flesh ball"
	desc = "A writhing ball of flesh, vaguely humanoid in shape. This one seems unarmed."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "meatboi"
	icon_living = "meatboi"
	faction = list("hostile")
	health = 800
	maxHealth = 800
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
	can_patrol = TRUE //The stronger blobs use commander AI, these will wander if alone.


/mob/living/simple_animal/hostile/meatblob/Move()
	..()
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/structure/meatfloor) in get_turf(src))
		return
	new /obj/structure/meatfloor(loc)

/mob/living/simple_animal/hostile/meatblob/gunner
	name = "suppressing flesh ball"
	desc = "A writhing ball of flesh, vaguely humanoid in shape. This one has a rifle."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "meatboi_rifle"
	icon_living = "meatboi_rifle"
	health = 400
	maxHealth = 400
	melee_damage_lower = 20
	melee_damage_upper = 25
	ranged = 1
	retreat_distance = 3
	minimum_distance = 4
	projectiletype = /obj/projectile/bonebullet
	rapid = 4
	rapid_fire_delay = 0.8
	projectilesound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	can_patrol = FALSE //They're sent out in waves
	var/guntimer //takes time to reload after 20 shots
	var/can_act = TRUE
	var/reload_time = 15
	var/remaining_bullets = 20
	var/maximum_bullets = 20
	var/reload_sound = 'sound/weapons/gun/general/bolt_rack.ogg'

/mob/living/simple_animal/hostile/meatblob/gunner/Initialize(mapload)
	..()
	var/units_to_add = list(
		/mob/living/simple_animal/hostile/meatblob = 1,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 3, TRUE, TRUE)

/mob/living/simple_animal/hostile/meatblob/gunner/OpenFire(atom/A)
	if(!can_act)
		return FALSE
	if(get_dist(src, A) < 2) // We can't fire normal ranged attack if we're too busy trying to run away
		return FALSE
	. = ..()
	if(remaining_bullets >= 0)
		can_act = FALSE
		guntimer = addtimer(CALLBACK(src, PROC_REF(FinishReload)), (reload_time), TIMER_STOPPABLE)
		remaining_bullets = maximum_bullets
		playsound(get_turf(src), "[reload_sound]", 50, FALSE)

/mob/living/simple_animal/hostile/meatblob/gunner/Shoot()
	. = ..()
	remaining_bullets -= 1

/mob/living/simple_animal/hostile/meatblob/gunner/proc/FinishReload()
	can_act = TRUE
	deltimer(guntimer)

/mob/living/simple_animal/hostile/meatblob/gunner/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/meatblob/gunner/AttackingTarget()
	if(!can_act)
		return FALSE
	..()


/mob/living/simple_animal/hostile/meatblob/gunner/shotgun
	name = "trailblazing flesh ball"
	desc = "A writhing ball of flesh, vaguely humanoid in shape. This one has a shotgun."
	icon_state = "meatboi_shotgun"
	icon_living = "meatboi_shotgun"
	health = 600
	maxHealth = 600
	melee_damage_lower = 30
	melee_damage_upper = 45
	projectiletype = null
	casingtype = /obj/item/ammo_casing/caseless/last_shot
	rapid = 1
	projectilesound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	remaining_bullets = 1
	maximum_bullets = 1
	reload_time = 5
	reload_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'

/mob/living/simple_animal/hostile/meatblob/gunner/sniper
	name = "cowering flesh ball"
	desc = "A writhing ball of flesh, vaguely humanoid in shape. This one has a sniper rifle."
	icon_state = "meatboi_sniper"
	icon_living = "meatboi_sniper"
	health = 300
	maxHealth = 300
	retreat_distance = 5
	minimum_distance = 4
	projectiletype = /obj/projectile/bonebullet/bonebullet_piercing
	rapid = 1
	projectilesound = 'sound/weapons/gun/sniper/shot.ogg'
	remaining_bullets = 1
	maximum_bullets = 1
	reload_time = 30
	var/datum/beam/current_beam = null

/mob/living/simple_animal/hostile/meatblob/gunner/sniper/OpenFire(atom/A)
	if(!can_act)
		return
	if(PrepareToFire(A))
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/meatblob/gunner/sniper/proc/PrepareToFire(atom/A)
	current_beam = Beam(A, icon_state="blood", time = 3 SECONDS)
	can_act = FALSE
	SLEEP_CHECK_DEATH(30)
	if(!(A in view(9, src)))
		can_act = TRUE
		return FALSE
	can_act = TRUE
	return TRUE
