//ABBERATION
	//ORDEAL PETS AND BACKSTREET CREATURES

			//Amber
/datum/crafting_recipe/morsel
	name = "Reconstituted Amber Ordeal"
	result = /mob/living/simple_animal/hostile/morsel
	reqs = list(/obj/item/food/meat/slab/worm = 6, /obj/item/food/wormfood = 2, /datum/reagent/water = 20)
	time = 50
	category= CAT_ROBOT

/mob/living/simple_animal/hostile/morsel
	name = "imperfect morsel"
	desc = "A small chunky worm that resembles an amber ordeal."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "imperfect_morsel_small"
	icon_living = "imperfect_morsel_small"
	icon_dead = "amber_bug_dead"
	faction = list("amber_ordeal", "neutral") //For incomprehensable reasons they will not assist you in battles with their own ordeal.
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	verb_ask = "chitters"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	stop_automated_movement_when_pulled = 1
	environment_smash = FALSE
	density = FALSE
	maxHealth = 120
	health = 120
	speed = 2
	melee_damage_lower = 0
	melee_damage_upper = 2
	turns_per_move = 2
	butcher_difficulty = 2
	buffed = 0
	death_message = "pops."
	density = TRUE
	search_objects = 1
	tame_chance = 5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	tame_chance = 5
	bonus_tame_chance = 2
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	silk_results = list(/obj/item/stack/sheet/silk/amber_simple = 1)
	wanted_objects = list(/obj/effect/decal/cleanable/blood/gibs/, /obj/item/organ, /obj/item/bodypart/head, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	food_type = list(/obj/item/organ, /obj/item/bodypart/head, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	var/current_size = RESIZE_DEFAULT_SIZE

/mob/living/simple_animal/hostile/morsel/examine(mob/user)
	. = ..()
	. += span_notice("[src] will consume body parts and gibs to increase their maximum health. [src] will flee from hostiles if their health is below 200.")
	if(maxHealth >= 250)
		. += span_notice("Drag yourself onto [src] in order to ride them.")

/mob/living/simple_animal/hostile/morsel/AttackingTarget()
	retreat_distance = 0
	if(is_type_in_typecache(target,wanted_objects)) //we eats
		qdel(target)
		buffed = (buffed + 1)
		if(buffed >= 10)
			PustuleChurn()
	else if(!client && health < 500)
		retreat_distance = 10
	return ..()

/mob/living/simple_animal/hostile/morsel/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>There must be more than hunger?</b>")
	if("amber_ordeal" in faction)
		faction -= "amber_ordeal"

/mob/living/simple_animal/hostile/morsel/Aggro() //coward
	..()
	if(!is_type_in_typecache(target,wanted_objects) && health < 200)
		retreat_distance = 10

/mob/living/simple_animal/hostile/morsel/LoseAggro() //coward
	..()
	if(!target)
		retreat_distance = 0

/mob/living/simple_animal/hostile/morsel/AttackingTarget()
	. = ..()
	if(.)
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		animate(src, pixel_y = (base_pixel_y + 18), time = 2)
		addtimer(CALLBACK(src, PROC_REF(AnimateBack)), 2)
		for(var/i = 1 to 2)
			var/turf/T = get_step(get_turf(src), dir_to_target)
			if(T.density)
				return
			if(locate(/obj/structure/window) in T.contents)
				return
			for(var/obj/machinery/door/D in T.contents)
				if(D.density)
					return
			forceMove(T)
			SLEEP_CHECK_DEATH(2)

/mob/living/simple_animal/hostile/morsel/attackby(obj/item/O, mob/user, params)
	if(!is_type_in_list(O, food_type))
		return ..()
	if(stat == DEAD)
		to_chat(user, span_warning("[src] is dead!"))
		return
	if(!locate(user) in friends)
		if(prob(tame_chance))
			tamed(user)
			tame_chance = 5
		else
			tame_chance += bonus_tame_chance
	visible_message(span_notice("[src] bites [O] and grinds it into a digestable paste."))
	playsound(get_turf(user), 'sound/items/eatfood.ogg', 10, 3, 3)
	buffed = (buffed + 1)
	adjustBruteLoss(-5)
	if(buffed >= 10)
		PustuleChurn()
	qdel(O)

/mob/living/simple_animal/hostile/morsel/proc/PustuleChurn()
	var/newsize = current_size
	visible_message(span_notice("[src]'s grows more chitin."))
	if(maxHealth <= 2000)
		maxHealth = maxHealth + 10
	switch(maxHealth)
		if(140)
			newsize = 1.25*RESIZE_DEFAULT_SIZE
			pixel_y = 10
			resize = newsize/current_size
			current_size = newsize
			update_transform()
		if(160)
			newsize = 1.5*RESIZE_DEFAULT_SIZE
			resize = newsize/current_size
			current_size = newsize
			update_transform()
		if(180)
			newsize = 1.75*RESIZE_DEFAULT_SIZE
			resize = newsize/current_size
			current_size = newsize
			update_transform()
		if(200)
			newsize = 2*RESIZE_DEFAULT_SIZE
			resize = newsize/current_size
			current_size = newsize
			update_transform()
		if(250)
			response_help_continuous = "pets"
			response_help_simple = "pet"
			death_message = "collapses as their pustules lose their bright orange hue."
			guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 4)
			can_buckle = TRUE
			buckle_lying = 0
			mob_size = MOB_SIZE_LARGE
			visible_message(span_notice("[src] looks big enough to use as a steed now."))
			AddElement(/datum/element/ridable, /datum/component/riding/creature/no_monsteroffset)
	var/extra_meat = (maxHealth-120)/20
	extra_meat = round(extra_meat)
	butcher_results = list(/obj/item/food/meat/slab/worm = 1+extra_meat)
	buffed = buffed * 0.2
	playsound(get_turf(src), 'sound/effects/wounds/crack2.ogg', 10, 3, 3)
	return

/mob/living/simple_animal/hostile/morsel/proc/AnimateBack()
	animate(src, pixel_y = base_pixel_y, time = 2)
	return TRUE

		//Green
/datum/crafting_recipe/green_price
	name = "Modified Green Ordeal"
	tools = list(TOOL_SCREWDRIVER)
	result = /mob/living/simple_animal/hostile/price
	reqs = list(/obj/item/food/meat/slab/robot = 4,)
	time = 50
	category= CAT_ROBOT

/mob/living/simple_animal/hostile/price
	name = "price of hope"
	desc = "A slim robot draped in worn rags."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "dearmeddoubt"
	icon_living = "dearmeddoubt"
	icon_dead = "dearmeddoubt_slain"
	faction = list("green_ordeal", "neutral")
	wander = 0
	obj_damage = 5
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	environment_smash = FALSE
	mob_biotypes = MOB_ROBOTIC
	gender = NEUTER
	speech_span = SPAN_ROBOT
	emote_hear = list("creaks.", "emits the sound of grinding gears.")
	speak_chance = 1
	a_intent = "help"
	maxHealth = 300 //100 less due to loss of arm
	health = 300
	death_message = "falls to their knees as the sound of gears slowly fades."
	melee_damage_lower = 0
	melee_damage_upper = 4
	mob_size = MOB_SIZE_LARGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)

/mob/living/simple_animal/hostile/price/examine(mob/user)
	. = ..()
	. += span_notice("Attacking [src] with a light source will attach it to them. [src] will obey simple commands when touched with a bare hand.")

/mob/living/simple_animal/hostile/price/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>Who pays the price of those made to suffer?</b>")

/mob/living/simple_animal/hostile/price/AttackingTarget()
	return

/mob/living/simple_animal/hostile/price/CanAttack(atom/the_target)
	return

/mob/living/simple_animal/hostile/price/attackby(obj/item/O, mob/user, params)
	if(!contents.len && user.a_intent == INTENT_HELP)
		if(istype(O, /obj/item/flashlight))
			O.forceMove(src)
			to_chat(user, "<notice>You hook the [O] onto [src].</notice>")
			playsound(get_turf(src), 'sound/machines/locktoggle.ogg', 10, 3, 3)
			return
	else if(O.tool_behaviour == TOOL_SCREWDRIVER && user.a_intent == INTENT_HELP)
		for(var/obj/item/I in contents)
			dropItemToGround(I)
		playsound(get_turf(src), 'sound/machines/clockcult/ocularwarden-dot2.ogg', 10, 3, 3)
		to_chat(user, "<notice>You unhook the items hanging off of [src].</notice>")
		return
	..()

/mob/living/simple_animal/hostile/price/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client)
		var/robot_ask = alert("select command", "[src] recognizes your authority.", "Follow", "Stay", "Grab", "Cancel")
		if(robot_ask == "Follow")
			walk_to(src, M, 2, move_to_delay)
			return
		if(robot_ask == "Stay")
			walk(src, 0)
			return
		if(robot_ask == "Grab")
			playsound(get_turf(src), 'sound/machines/clockcult/ocularwarden-dot2.ogg', 10, 3, 3)
			haul(M)
			return
		return
	return ..()

/mob/living/simple_animal/hostile/price/proc/haul(mob/living/carbon/M)
	stop_pulling()
	for(var/obj/structure/A in oview(get_turf(src), 1))
		if(A == M || anchored == 1)
			return
		if(!A)
			to_chat(M, span_notice("There is no objects nearby that [src] can haul..."))
			return
		start_pulling(A)
		visible_message(span_notice("[src] begins to haul [A]."))
		break

		//Crimson
/datum/crafting_recipe/smallchuckles
	name = "Repaired Crimson Ordeal"
	result = /mob/living/simple_animal/hostile/smallchuckles
	reqs = list(/obj/item/food/meat/slab/crimson = 4, /obj/item/stack/medical/suture = 1)
	time = 50
	category= CAT_ROBOT

/mob/living/simple_animal/hostile/smallchuckles
	name = "small chuckles"
	desc = "A small jester with patchwork leather for skin and a painted face. Perhaps they lost their troupe."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "small_chuckles"
	icon_living = "crimson_clown"
	icon_dead = "crimson_clown_dead"
	a_intent = "disarm"
	environment_smash = FALSE
	possible_a_intents = list("help", "disarm", "grab")
	faction = list("crimson_ordeal", "neutral")
	friendly_verb_continuous = "smacks"
	friendly_verb_simple = "smack"
	speak_emote = list("chuckles", "giggles", "laughs")
	mob_biotypes = MOB_ORGANIC | MOB_UNDEAD
	speak_chance = 5
	melee_damage_lower = 0
	melee_damage_upper = 0
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/crimson = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/crimson = 1)
	stop_automated_movement_when_pulled = 1
	search_objects = 0
	mob_size = MOB_SIZE_SMALL
	tame = TRUE
	buffed = 0
	var/can_act = TRUE

/mob/living/simple_animal/hostile/smallchuckles/examine(mob/user)
	. = ..()
	. += span_notice("[src] will do a trick and heal 5 sanity when touched with a bare hand.")

/mob/living/simple_animal/hostile/smallchuckles/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>An empty stage with no audience, where did my circus go?</b>")

/mob/living/simple_animal/hostile/smallchuckles/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/smallchuckles/AttackingTarget()
	return

/mob/living/simple_animal/hostile/smallchuckles/CanAttack(atom/the_target)
	return

/mob/living/simple_animal/hostile/smallchuckles/death(gibbed)
	playsound(get_turf(src), 'sound/machines/honkbot_evil_laugh.ogg', 10, 3, 3)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	..()

/mob/living/simple_animal/hostile/smallchuckles/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && buffed <= world.time && can_act)
		can_act = FALSE
		to_chat(M, span_notice("You watch [src] do a trick!"))
		buffed = world.time + (10 SECONDS) //to avoid spamming
		if(do_after(M, 4 SECONDS, target = M))
			for(var/mob/living/carbon/human/L in oview(get_turf(src), 2)) //Even if the trick is bad hes trying his best.
				if(L.stat != DEAD)
					L.emote("laugh")
					L.adjustSanityLoss(-5)
			spin(4 SECONDS, 2)
			var/chosen_sound = pick('sound/abnormalities/bluestar/pulse.ogg', 'sound/items/bubblewrap.ogg', 'sound/creatures/monkey/monkey_screech_2.ogg', 'sound/effects/mousesqueek.ogg', 'sound/effects/meow1.ogg', 'sound/vox_fem/chuckle.ogg')
			playsound(src, chosen_sound, 10, TRUE)
		can_act = TRUE
		return
	..()

/mob/living/simple_animal/hostile/smallchuckles/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	for(var/mob/living/L in view(5, src))
		if(!faction_check_mob(L))
			L.apply_damage(35, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	gib()

// bigBirdEye
/mob/living/simple_animal/hostile/ordeal/bigBirdEye
	name = "beak thing"
	desc = "A giant eye creature that has an enormous beak protruding from the pupil."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "beak_thing"
	icon_living = "beak_thing"
	faction = list("hostile") // should attack everything except its own
	response_disarm_continuous = "pushes aside"
	response_disarm_simple = "push aside"
	verb_ask = "chirps"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	maxHealth = 250
	health = 250 // easier to kill
	speed = 3
	attack_sound = 'sound/weapons/bite.ogg'
	melee_damage_lower = 5
	melee_damage_upper = 15 // crit damage
	turns_per_move = 2
	butcher_difficulty = 2
	butcher_results = list(/obj/item/food/meat/slab/chicken = 2, /obj/item/food/meat/slab/human = 1, /obj/item/food/egg = 1,) // chicken and human for what he eats, egg? |MESSAGE BELOW|
	food_type = list(/obj/item/organ, /obj/item/bodypart/head, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg, /obj/item/food/meat/slab/human, /obj/item/food/meat/slab/crimson,) // scower area for food and eat it
	death_message = "screeches as it falls over." // |MESSAGE ABOVE|
	density = TRUE
	search_objects = 1
	del_on_death = TRUE

/mob/living/simple_animal/hostile/ordeal/bigBirdEye/Life()
    . = ..()
    buffed += 1
    if(buffed >= 2) //every 2 life ticks check for cowardace.
        if(!is_type_in_typecache(target,wanted_objects) && retreat_distance < 20 && !locate(/mob/living/simple_animal/hostile/ordeal/bigBirdEye) in oview(get_turf(src), 2))
            retreat_distance = 20
        else if(retreat_distance > 1)
            retreat_distance = null
        buffed = 0

// K-Corp Drone
/mob/living/simple_animal/hostile/kcorp/drone
	name = "K-Corp survey drone"
	desc = "Medium sized drone suspensed in the air, humming as he flies."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "kcorp_drone_idle"
	icon_living = "kcorp_drone_idle"
	icon_dead = "kcorp_drone_idle"
	faction = list("hostile", "kcorp") // should target humanoids only and annoy them to no end
	response_disarm_continuous = "pushes aside"
	response_disarm_simple = "push aside"
	attack_verb_continuous = "flashes"
	attack_verb_simple = "flash"
	verb_ask = "buzzes"
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 300
	health = 300
	move_to_delay = 2
	melee_damage_lower = 1
	melee_damage_upper = 8 // should annoy, not kill
	turns_per_move = 3
	butcher_difficulty = 3
	butcher_results = list(/obj/item/ksyringe = 1, /obj/item/assembly/flash/handheld = 1)
	death_message = "buzzes as he falls out of the air."
	density = FALSE
	search_objects = 1
	del_on_death = TRUE

	var/can_act = TRUE //If flashing, turns FALSE so we don't attack/move
	var/flash_cooldown
	var/flash_cooldown_time = 10 SECONDS
	var/flash_range = 5 //Range that the flash hits

/mob/living/simple_animal/hostile/kcorp/drone/proc/Flash()
	icon_state = "kcorp_drone_angry"
	can_act = FALSE
	SLEEP_CHECK_DEATH(2 SECONDS) //Enough to run away, but not easily
	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)

	for (var/mob/living/L in viewers(flash_range,src)) //The actual flashing
		if (!ishuman(L))
			continue
		L.Paralyze(5 SECONDS) //you better dodge it
		var/obj/item/held = L.get_active_held_item()
		L.dropItemToGround(held) //Drops everyone's weapons
		to_chat(L, span_danger("[src] shines a blinding light!"))

	SLEEP_CHECK_DEATH(1 SECONDS)
	icon_state = "kcorp_drone_idle"
	can_act = TRUE

/mob/living/simple_animal/hostile/kcorp/drone/Move()
	if (!can_act)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/kcorp/drone/AttackingTarget(target)
	if (!can_act)
		return
	. = ..()
	if(flash_cooldown <= world.time)
		flash_cooldown = world.time + flash_cooldown_time
		Flash()

/mob/living/simple_animal/hostile/kcorp/drone/Aggro() //flash and push people, then run away |FLASH IS ANIMATED|
	..()
	if(!is_type_in_typecache(target,wanted_objects))
		retreat_distance = 3
		can_patrol = FALSE

/mob/living/simple_animal/hostile/kcorp/drone/LoseAggro() //fly around the town
	..()
	if(!target)
		can_patrol = TRUE
		retreat_distance = 0

/*
--LOVE TOWN--
Mobs that mostly focus on dealing RED damage, they are all a bit more frail than others on tier (one exception) but will spawn suicidal mobs on death that deal WHITE around themselves periodically.
*/
/mob/living/simple_animal/hostile/lovetown
	name = "love town resident"
	desc = "A mass of flesh and bulbous growths, this thing is disgusting!"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "lovetown_suicidal"
	icon_living = "lovetown_suicidal"
	icon_dead = "lovetown_dead"
	faction = list("hostile")
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = TRUE
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	maxHealth = 80
	health = 80
	move_to_delay = 4
	stat_attack = HARD_CRIT
	melee_damage_type = RED_DAMAGE
	butcher_results = list(/obj/item/food/meat/slab = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 1)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL
	mob_size = MOB_SIZE_HUGE
	a_intent = INTENT_HARM
	var/mob_spawn_amount = 1 //the weakest will spawn just one suicidal, higher tiers will spawn more
	var/spawn_prob = 66 //chance to spawn suicials on death, default is 33%

//Proc below is a modified crimson DeathExplosion()
/mob/living/simple_animal/hostile/lovetown/proc/SpawnSuicidal() //all mobs spawn at least 1 suicidal on death, except the suicidals themselves
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] flesh rips apart!"))
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/dusk_dead.ogg', 50, 1)
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	for(var/i = 1 to mob_spawn_amount)
		if(prob(spawn_prob))
			continue
		var/turf/T = get_step(get_turf(src), pick(valid_directions))
		new/mob/living/simple_animal/hostile/lovetown/suicidal(T)
	gib()

/mob/living/simple_animal/hostile/lovetown/death(gibbed)
	if(mob_spawn_amount > 0)
		animate(src, transform = matrix()*1.2, color = "#FF0000", time = 5)
		addtimer(CALLBACK(src, PROC_REF(SpawnSuicidal)), 5)
	..()

//Love Town Suicidal - Weak, screams around itself occasionally, spawned by other enemies on death.
/mob/living/simple_animal/hostile/lovetown/suicidal
	name = "love town suicidal"
	desc = "A mass of flesh and bulbous growths that flails and gurgles helplessly."
	icon_state = "lovetown_suicidal"
	icon_living = "lovetown_suicidal"
	maxHealth = 80 //very weak
	health = 80
	move_to_delay = 8 //very slow
	ranged = TRUE
	mob_spawn_amount = 0 //so we dont recursively spawn more

	var/can_act = TRUE
	var/scream_cooldown
	var/scream_cooldown_time = 6 SECONDS

/mob/living/simple_animal/hostile/lovetown/suicidal/AttackingTarget()
	return OpenFire()

/mob/living/simple_animal/hostile/lovetown/suicidal/OpenFire()
	if(scream_cooldown <= world.time && prob(50))
		Scream()
	return

/mob/living/simple_animal/hostile/lovetown/suicidal/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/lovetown/suicidal/proc/Scream()
	scream_cooldown = world.time + scream_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/scream.ogg', 50, TRUE, 3)
	for(var/i = 1 to 3)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 4)
		SLEEP_CHECK_DEATH(6)
	for(var/mob/living/L in view(3, src))
		if(!faction_check_mob(L))
			L.apply_damage(5, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	can_act = TRUE

//Love Town Slasher - TETH goons, not much of a threat
/mob/living/simple_animal/hostile/lovetown/slasher
	name = "love town slasher"
	desc = "A mass of flesh and teeth, it has a destroyed appendage with pure muscle coming out of it, sharpened by wicked design."
	icon_state = "lovetown_slasher"
	icon_living = "lovetown_slasher"
	maxHealth = 300
	health = 300
	move_to_delay = 4
	melee_damage_lower = 18
	melee_damage_upper = 22
	attack_sound = 'sound/weapons/fixer/generic/knife2.ogg'
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"

//Love Town Stabber -
/mob/living/simple_animal/hostile/lovetown/stabber
	name = "love town stabber"
	desc = "A mass of flesh and bulbous growths with a protusion on top, flailing aggressively."
	icon_state = "lovetown_stabber"
	icon_living = "lovetown_stabber"
	maxHealth = 220 //weaker than slashers...
	health = 220
	melee_damage_lower = 8 //...weaker damage too, though...
	melee_damage_upper = 10
	rapid_melee = 2 //... in turn it attacks much faster...
	move_to_delay = 3 //...and it's faster.
	attack_sound = 'sound/effects/ordeals/green/stab.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"

//Love Town Slammer -
/mob/living/simple_animal/hostile/lovetown/slammer
	name = "love town slammer"
	desc = "A hunk of flesh that ends in a gigantic fist at the top."
	icon_state = "lovetown_slammer"
	icon_living = "lovetown_slammer"
	maxHealth = 300
	health = 300
	melee_damage_lower = 28 //much higher damage...
	melee_damage_upper = 36
	rapid_melee = 0.5 //...much slower attack...
	melee_queue_distance = 2
	move_to_delay = 6 //...and speed.
	attack_sound = 'sound/creatures/lc13/lovetown/slam.ogg'
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"

/mob/living/simple_animal/hostile/lovetown/slammer/Initialize()
	. = ..()
	AddComponent(/datum/component/knockback, 1, FALSE, TRUE) //1 is distance thrown, CAN'T stun and damage you if it hits a wall.

//Love Town Shambler - HE level, screams around for a higher chunk of damage and spawns a lot of suicidals on death
/mob/living/simple_animal/hostile/lovetown/shambler
	name = "love town shambler"
	desc = "A mass of flesh and bulbous growths that doesnt stop mumbling and screaming."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "lovetown_shambler"
	icon_living = "lovetown_shambler"
	icon_dead = "lovetown_shambler"
	maxHealth = 900
	health = 900
	move_to_delay = 6
	ranged = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.4, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_spawn_amount = 4 //on death explodes into 4 suicidals
	spawn_prob = 33 //66% chance to spawn suicidals, higher than normal

	var/scream_cooldown
	var/scream_cooldown_time = 7 SECONDS
	var/can_act = TRUE

/mob/living/simple_animal/hostile/lovetown/shambler/AttackingTarget()
	return OpenFire()

/mob/living/simple_animal/hostile/lovetown/shambler/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/lovetown/shambler/OpenFire()
	if(scream_cooldown <= world.time && prob(85))
		Scream()
	return

/mob/living/simple_animal/hostile/lovetown/shambler/proc/Scream()
	can_act = FALSE
	scream_cooldown = world.time + scream_cooldown_time
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/scream.ogg', 75, TRUE, 3)
	for(var/i = 1 to 4)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 3)
		SLEEP_CHECK_DEATH(6)
	for(var/mob/living/L in view(4, src))
		if(!faction_check_mob(L))
			L.apply_damage(33, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	can_act = TRUE

// Love Town Slumberer - HE threat,, quite damaging and can grab you, stuns you for some time.
/mob/living/simple_animal/hostile/lovetown/slumberer
	name = "love town slumberer"
	desc = "A muscular mass of flesh that has two very long arms capable of reaching far"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "lovetown_slumberer"
	icon_living = "lovetown_slumberer"
	icon_dead = "lovetown_slumberer"
	base_pixel_x = -16
	pixel_x = -16
	maxHealth = 1000
	health = 1000
	melee_damage_lower = 25
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/creatures/lc13/lovetown/slam.ogg'
	attack_verb_continuous = "grapples"
	attack_verb_simple = "grapple"
	move_to_delay = 10 //Absurdly slow
	ranged = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.4, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_spawn_amount = 2

	var/grab_ready = FALSE //are we ready to grab
	var/countering = FALSE //are we grabbing them right now
	var/counter_threshold = 350 //2 counters at most
	var/damage_taken

/mob/living/simple_animal/hostile/lovetown/slumberer/proc/DisableCounter()
	if(!countering)
		icon_state = icon_living
		grab_ready = FALSE

/mob/living/simple_animal/hostile/lovetown/slumberer/proc/CounterGrab(mob/living/carbon/human/H)
	if(!istype(H))
		return
	DisableCounter()
	countering = TRUE
	playsound(get_turf(src), attack_sound , 10, 3, 3)
	H.Stun(3.5 SECONDS) //easy to dodge, but fuck you if you get hit by this
	step_towards(H, src)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	H.forceMove(get_turf(src))
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	if(!targets_from.Adjacent(H) || QDELETED(H)) //if someone drags you away, you can cut the duration in half
		return
	H.Stun(3 SECONDS)
	SLEEP_CHECK_DEATH(3 SECONDS)
	countering = FALSE

/mob/living/simple_animal/hostile/lovetown/slumberer/Move()
	if(countering || grab_ready)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/lovetown/slumberer/AttackingTarget()
	if(countering)
		return
	if(grab_ready)
		return OpenFire(target)
	return ..()

/mob/living/simple_animal/hostile/lovetown/slumberer/OpenFire(target)
	if(countering)
		return
	if(!istype(target, /mob/living/carbon/human))
		return
	if(get_dist(target, src) <= 2 && grab_ready)
		CounterGrab(target)
		return

/mob/living/simple_animal/hostile/lovetown/slumberer/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= counter_threshold && !grab_ready)
		icon_state = "lovetown_slumberer_ready"
		playsound(get_turf(src), 'sound/abnormalities/apocalypse/swing.ogg', 75, 0, 3)
		SLEEP_CHECK_DEATH(1.5 SECONDS) //so we  dont instantly grab people
		grab_ready = TRUE
		addtimer(CALLBACK (src, PROC_REF(DisableCounter)), 4 SECONDS)
		damage_taken = 0

//WAW(?) miniboss, takes quite a lot of firepower to take down
/mob/living/simple_animal/hostile/lovetown/abomination
	name = "love town abomination"
	desc = "A mass of flesh and bulbous growths that flails and gurgles helplessly, this thing is disgusting!"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "lovetown_abomination"
	icon_living = "lovetown_abomination"
	icon_dead = "lovetown_abomination"
	base_pixel_x = -32
	pixel_x = -32
	maxHealth = 6000 //CHONKY
	health = 6000
	melee_queue_distance = 2 //since our attacks are AoEs, this makes it harder to kite us
	move_to_delay = 6
	ranged = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5)
	melee_damage_lower = 60
	melee_damage_upper = 80
	attack_sound = 'sound/creatures/lc13/lovetown/slam.ogg'
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"
	footstep_type = FOOTSTEP_MOB_HEAVY
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_spawn_amount = 2 //:(
	spawn_prob = 0 //100%, always spawn them

	var/can_act = TRUE
	var/current_stage = 1 //changes behaviour slightly on phase 2
	var/stage_threshold = 3000 // enters stage 2 at or below this threshold
	var/attack_delay = 0.5 SECONDS //0.5 seconds at stage 1, 1 second at stage 2
	var/countering = FALSE //are we

	var/counter_threshold = 500 //300 at stage 2
	var/counter_ready = FALSE //are we ready to counter?

	var/counter_speed = 2 //subtracted from the movedelay when dashing

	var/lovewhip_damage = 100
	var/damage_taken

/mob/living/simple_animal/hostile/lovetown/abomination/proc/StageTransition()
	icon_living = "lovetown_abomination2"
	if(!countering && can_act)
		icon_state = icon_living
	current_stage = 2
	//Speed changed from 6 to 4
	SpeedChange(-counter_speed)
	attack_delay = 1 SECONDS
	counter_threshold = 300
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/abomination_stagetransition.ogg', 75, 0, 3)

/mob/living/simple_animal/hostile/lovetown/abomination/proc/AoeAttack() //all attacks are an AoE when not dashing
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/apocalypse/swing.ogg', 75, 0, 3)
	switch(current_stage)
		if(1)
			icon_state = "lovetown_abomination_slamwindup"
		if(2)
			icon_state = "lovetown_abomination_slamwindup2"
	SLEEP_CHECK_DEATH(attack_delay) //takes longer to slam on phase 2
	for(var/turf/T in view(current_stage, src))//scales with stage, at stage 2 hits 2 tiles around
		new /obj/effect/temp_visual/lovetown_shapes(T)
		HurtInTurf(T, list(), (rand(melee_damage_lower, melee_damage_upper)/2), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE) //30~40 damage
	switch(current_stage)
		if(1)
			icon_state = "lovetown_abomination_slam"
		if(2)
			icon_state = "lovetown_abomination_slam2"
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, 0, 3)
	SLEEP_CHECK_DEATH(0.4 SECONDS)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/lovetown/abomination/proc/DashCounter() //increases move speed and hits with a powerful attack that knocks back far away
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/abomination_counter_start.ogg', 75, 0, 3)
	switch(current_stage)
		if(1)
			icon_state = "lovetown_abomination_dash"
		if(2)
			icon_state = "lovetown_abomination_dash2"
	countering = TRUE
	counter_ready = FALSE
	//Speed becomes 4 or 2 and returns to 6 or 4 after 4 seconds.
	TemporarySpeedChange(-counter_speed, 4 SECONDS)
	visible_message(span_warning("[src] sprints toward [target]!"), span_notice("You quickly dash!"), span_notice("You hear heavy footsteps speed up."))
	addtimer(CALLBACK(src, PROC_REF(DisableCounter)), 4 SECONDS) //disables the counter after 4 seconds

/mob/living/simple_animal/hostile/lovetown/abomination/proc/DisableCounter() //resets the counter
	if(countering)
		countering = FALSE
		playsound(get_turf(src), 'sound/creatures/lc13/lovetown/abomination_counter_end.ogg', 75, 0, 3)
		SLEEP_CHECK_DEATH(10)
		icon_state = icon_living

/mob/living/simple_animal/hostile/lovetown/abomination/proc/LoveWhip(target) //loosely conical AoE that on hit throws the target towards us, stolen and modified from Ppodae, hits in a 3x3 + 5x5 for a total range of 8 tiles
	icon_state = "lovetown_abomination_whipwind"
	counter_ready = FALSE
	countering = TRUE
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/abomination_lovewhip_start.ogg', 75, 0, 3)
	var/smash_width = 1 //we change this to 2 later
	var/smash_length = 3 //we change this to 4 later
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	var/second_line = get_ranged_target_turf(source_turf, dir_to_target, smash_length-2)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	icon_state = "lovetown_abomination_whip"
	switch(dir_to_target)
		if(EAST)
			for(var/i = 0, i<2, i++)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
				source_turf = get_ranged_target_turf(second_line, EAST, smash_length)
				smash_length += 2
				smash_width ++
		if(WEST)
			for(var/i = 0, i<2, i++)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
				source_turf = get_ranged_target_turf(second_line, WEST, smash_length)
				smash_length += 2
				smash_width ++
		if(NORTH)
			for(var/i = 0, i<2, i++)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
				source_turf = get_ranged_target_turf(second_line, NORTH, smash_length)
				smash_length += 2
				smash_width ++
		if(SOUTH)
			for(var/i = 0, i<2, i++)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
				source_turf = get_ranged_target_turf(second_line, SOUTH, smash_length)
				smash_length += 2
				smash_width ++

		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T

	if (!LAZYLEN(area_of_effect))
		icon_state = icon_living
		can_act = TRUE
		return
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/lovetown_whip(T)
		HurtInTurf(T, list(), lovewhip_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
		for(var/mob/living/L in T)
			var/atom/throw_target = get_edge_target_turf(L, get_dir(L, src))
			L.throw_at(throw_target, 200, 4)

	playsound(get_turf(src), 'sound/creatures/lc13/lovetown/abomination_lovewhip_hit.ogg', 75, 0, 3)
	SLEEP_CHECK_DEATH(1 SECONDS)
	icon_state = icon_living
	can_act = TRUE
	if(prob(20)) //small chance to go into a dash after
		DashCounter()
	else
		DisableCounter()
	return

/mob/living/simple_animal/hostile/lovetown/abomination/proc/Finisher(mob/living/carbon/human/TH) //return TRUE to prevent attacking, as attacking causes runtimes if the target is gibbed.
	if(TH.stat >= HARD_CRIT || TH.health < 0)
		switch(current_stage)
			if(1)
				icon_state = "lovetown_abomination_execute"
			if(2)
				icon_state = "lovetown_abomination_execute2"
		can_act = FALSE
		TH.Stun(8 SECONDS)
		forceMove(get_turf(TH))
		var/pixel_y_before = TH.pixel_y
		animate(TH, pixel_y = 16, time = 15, easing = SINE_EASING | EASE_IN)
		SLEEP_CHECK_DEATH(25)
		if(!targets_from.Adjacent(TH) || QDELETED(TH)) //Can save the target if you move them away
			animate(TH, pixel_y = pixel_y_before, time = 10, , easing = BACK_EASING | EASE_OUT, flags = ANIMATION_END_NOW)
			icon_state = icon_living
			can_act = TRUE
			return
		for(var/mob/living/carbon/human/H in view(7, get_turf(src)))
			H.apply_damage(50, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/lovetown_shapes(get_turf(TH))
		TH.gib()
//		animate(TH, pixel_y = pixel_y_before, time = 10, , easing = BACK_EASING | EASE_OUT, flags = ANIMATION_END_NOW) //animate the shape back when you add it Mel
		SLEEP_CHECK_DEATH(1 SECONDS)
		icon_state = icon_living
		can_act = TRUE
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/lovetown/abomination/Initialize()
	. = ..()
	AddComponent(/datum/component/knockback, 6, FALSE, TRUE) //6 is distance thrown, CAN'T stun and damage you if it hits a wall, only relevant for counter hits.

/mob/living/simple_animal/hostile/lovetown/abomination/Move()
	if((!can_act) && (countering)) //only applies to love whip
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/lovetown/abomination/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE

	if(current_stage == 2)
		adjustBruteLoss(-40) //self damages at stage 2

	if(ishuman(target))
		if(Finisher(target))
			return

	if(countering)
		switch(current_stage)
			if(1)
				icon_state = "lovetown_abomination_dashhit"
			if(2)
				icon_state = "lovetown_abomination_dashhit2"
		. = ..()
		DisableCounter()
		return
	if(counter_ready)
		return OpenFire(target)
	return AoeAttack()

/mob/living/simple_animal/hostile/lovetown/abomination/OpenFire(target)
	if(!can_act)
		return

	if(counter_ready)
		switch(current_stage)
			if(1)
				return DashCounter()
			if(2)
				if(prob(80))
					if(isliving(target))
						return LoveWhip(target)
				return DashCounter()
		return

/mob/living/simple_animal/hostile/lovetown/abomination/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= counter_threshold && !counter_ready && !countering)
		counter_ready = TRUE
		damage_taken = 0
	if((health <= stage_threshold) && (current_stage == 1))
		StageTransition()
