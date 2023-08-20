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
	deathmessage = "pops."
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
	wanted_objects = list(/obj/effect/decal/cleanable/blood/gibs/, /obj/item/organ, /obj/item/bodypart/head, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	food_type = list(/obj/item/organ, /obj/item/bodypart/head, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	var/current_size = RESIZE_DEFAULT_SIZE

/mob/living/simple_animal/hostile/morsel/examine(mob/user)
	. = ..()
	. += "<span class='notice'>[src] will consume body parts and gibs to increase their maximum health. [src] will flee from hostiles if their health is below 200.</span>"
	if(maxHealth >= 250)
		. += "<span class='notice'>Drag yourself onto [src] in order to ride them.</span>"

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
		addtimer(CALLBACK(src, .proc/AnimateBack), 2)
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
		to_chat(user, "<span class='warning'>[src] is dead!</span>")
		return
	if(!locate(user) in friends)
		if(prob(tame_chance))
			tamed(user)
			tame_chance = 5
		else
			tame_chance += bonus_tame_chance
	visible_message("<span class='notice'>[src] bites [O] and grinds it into a digestable paste.</span>")
	playsound(get_turf(user), 'sound/items/eatfood.ogg', 10, 3, 3)
	buffed = (buffed + 1)
	adjustBruteLoss(-5)
	if(buffed >= 10)
		PustuleChurn()
	qdel(O)

/mob/living/simple_animal/hostile/morsel/proc/PustuleChurn()
	var/newsize = current_size
	visible_message("<span class='notice'>[src]'s grows more chitin.</span>")
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
			deathmessage = "collapses as their pustules lose their bright orange hue."
			guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 4)
			can_buckle = TRUE
			buckle_lying = 0
			mob_size = MOB_SIZE_LARGE
			visible_message("<span class='notice'>[src] looks big enough to use as a steed now.</span>")
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
	deathmessage = "falls to their knees as the sound of gears slowly fades."
	melee_damage_lower = 0
	melee_damage_upper = 4
	mob_size = MOB_SIZE_LARGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)

/mob/living/simple_animal/hostile/price/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Attacking [src] with a light source will attach it to them. [src] will obey simple commands when touched with a bare hand.</span>"

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
			to_chat(M, "<span class='notice'>There is no objects nearby that [src] can haul...</span>")
			return
		start_pulling(A)
		visible_message("<span class='notice'>[src] begins to haul [A].</span>")
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
	. += "<span class='notice'>[src] will do a trick and heal 5 sanity when touched with a bare hand.</span>"

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
	addtimer(CALLBACK(src, .proc/DeathExplosion), 15)
	..()

/mob/living/simple_animal/hostile/smallchuckles/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && buffed <= world.time && can_act)
		can_act = FALSE
		to_chat(M, "<span class='notice'>You watch [src] do a trick!</span>")
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
	visible_message("<span class='danger'>[src] suddenly explodes!</span>")
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
	deathmessage = "screeches as it falls over." // |MESSAGE ABOVE|
	density = TRUE
	search_objects = 1
	var/current_size = RESIZE_DEFAULT_SIZE
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
	faction = list("hostile") // should target humanoids only and annoy them to no end
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
	deathmessage = "buzzes as he falls out of the air."
	density = TRUE
	search_objects = 1
	var/current_size = RESIZE_DEFAULT_SIZE
	del_on_death = TRUE

/mob/living/simple_animal/hostile/kcorp/drone/AttackingTarget()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		icon_state = "kcorp_drone_angry"
		icon_living = "kcorp_drone_angry"
		animate(src, time = 1, loop = 0)
		playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
		L.Paralyze(3 SECONDS)
		var/obj/item/held = L.get_active_held_item()
		L.dropItemToGround(held)
		SLEEP_CHECK_DEATH(10)
		icon_state = "kcorp_drone_idle"
		icon_living = "kcorp_drone_idle"

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
Mobs that mostly focus on dealing RED damage, they are all a bit more frail than others on tier but will spawn suicidal mobs on death that deal WHITE around themselves periodically.
ZAYIN = Suicidal
TETH = Slasher, Stabber, Slammer
HE = Slumberer, Shambler, Abomination(miniboss)
*/
/mob/living/simple_animal/hostile/lovetown
	name = "love town resident"
	desc = "A mass of flesh and bulbous growths, this thing is disgusting!"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "lovetown_suicidal"
	icon_living = "lovetown_suicidal"
	icon_dead = "lovetown_suicidal"
	faction = list("hostile")
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC
	maxHealth = 100
	health = 100
	move_to_delay = 4
	stat_attack = DEAD
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1, PALE_DAMAGE = 2) //Resitant to physical damage and to psychological attacks due to their origins.
	blood_volume = BLOOD_VOLUME_NORMAL
	var/mob_spawn_amount = 1 //the weakest will spawn just one suicidal, higher tiers will spawn more

//Proc below is a modified crimson DeathExplosion()
/mob/living/simple_animal/hostile/lovetown/proc/SpawnSuicidal() //all mobs spawn at least 1 suicidal on death, except the suicidals themselves
	if(QDELETED(src))
		return
	visible_message("<span class='danger'>[src] suddenly explodes!</span>")
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/dusk_dead.ogg', 50, 1)
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	for(var/i = 1 to mob_spawn_amount)
		var/turf/T = get_step(get_turf(src), pick(valid_directions))
		var/mob/living/simple_animal/hostile/lovetown/suicidal/s = new(T)
	gib()

/mob/living/simple_animal/hostile/lovetown/death(gibbed)
	animate(src, transform = matrix()*1.2, color = "#FF0000", time = 5)
	addtimer(CALLBACK(src, .proc/SpawnSuicidal), 5)
	..()

/mob/living/simple_animal/hostile/lovetown/suicidal
	name = "love town suicidal"
	desc = "A mass of flesh and bulbous growths that flails and gurgles helplessly, this thing is disgusting!"
	icon_state = "lovetown_suicidal"
	icon_living = "lovetown_suicidal"
	maxHealth = 80
	health = 800

/mob/living/simple_animal/hostile/lovetown/suicidal/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/lovetown/suicidal/Move()
	return FALSE

/mob/living/simple_animal/hostile/lovetown/death(gibbed)
	. = ..() //should overwrite the timer so that we dont recursively spawn suicidals

/mob/living/simple_animal/hostile/lovetown/slasher
	name = "love town slasher"
	desc = "A mass of flesh and bulbous growths that flails and gurgles helplessly, this thing is disgusting!"
	icon_state = "lovetown_slasher"
	icon_living = "lovetown_slasher"
	maxHealth = 300
	health = 300
	melee_damage_lower = 20
	melee_damage_upper = 24
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"

/mob/living/simple_animal/hostile/lovetown/stabber
	name = "love town stabber"
	desc = "A mass of flesh and bulbous growths that flails and gurgles helplessly, this thing is disgusting!"
	icon_state = "lovetown_stabber"
	icon_living = "lovetown_stabber"
	maxHealth = 220 //weaker than slashers...
	health = 220
	melee_damage_lower = 10 //...not only in health, though...
	melee_damage_upper = 12
	rapid_melee = 2 //... in turn it attacks much faster.
	move_to_delay = 3
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"

/mob/living/simple_animal/hostile/lovetown/slammer
	name = "love town slammer"
	desc = "A mass of flesh and bulbous growths that flails and gurgles helplessly, this thing is disgusting!"
	icon_state = "lovetown_slammer"
	icon_living = "lovetown_slammer"
	maxHealth = 300
	health = 300
	melee_damage_lower = 42 //much higher damage...
	melee_damage_upper = 48
	rapid_melee = 0.5 //...much slower attack.
	melee_queue_distance = 2
	move_to_delay = 5
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"


