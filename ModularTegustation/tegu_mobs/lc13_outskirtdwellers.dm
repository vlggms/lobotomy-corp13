//ABBERATION
	//ORDEAL PETS

			//Amber
/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel
	name = "imperfect morsel"
	desc = "A wormlike creature that has a large pustule emerging from its back."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "imperfect_morsel"
	icon_living = "imperfect_morsel"
	faction = list("amber_ordeal", "neutral") //For incomprehensable reasons they will not assist you in battles with their own ordeal.
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	verb_ask = "chitters"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	maxHealth = 120
	health = 120
	speed = 2
	melee_damage_lower = 0
	melee_damage_upper = 2
	turns_per_move = 2
	butcher_difficulty = 2
	butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/worm = 1)
	wanted_objects = list(/obj/effect/decal/cleanable/blood/gibs/, /obj/item/organ, /obj/item/bodypart/head, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	food_type = list(/obj/item/organ, /obj/item/bodypart/head, /obj/item/bodypart/r_arm, /obj/item/bodypart/l_arm, /obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg)
	buffed = 0
	deathmessage = "pops."
	density = TRUE
	search_objects = 1
	tame_chance = 5
	var/current_size = RESIZE_DEFAULT_SIZE

/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel/Initialize()
	..()
	base_pixel_x = 0
	pixel_x = base_pixel_x
	base_pixel_y = 0
	pixel_y = base_pixel_y
	butcher_results = initial(butcher_results)

/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel/AttackingTarget()
	retreat_distance = 0
	if(is_type_in_typecache(target,wanted_objects)) //we eats
		visible_message("<span class='notice'>[src] bites [target] and grinds it into a digestable paste with its teeth.</span>")
		qdel(target)
		buffed = (buffed + 1)
		if(buffed >= 10)
			pustule_churn()
	else if(health < 750)
		retreat_distance = 10
	return ..()

/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>Who pays the price of those made to suffer?</b>")
	if("amber_ordeal" in faction)
		faction -= "amber_ordeal"

/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel/Aggro() //coward
	..()
	if(!is_type_in_typecache(target,wanted_objects))
		retreat_distance = 10

/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel/LoseAggro() //coward
	..()
	if(!target)
		retreat_distance = 0


/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel/attackby(obj/item/O, mob/user, params)
	if(!is_type_in_list(O, food_type))
		return ..()
	if(stat == DEAD)
		to_chat(user, "<span class='warning'>[src] is dead!</span>")
		return
	if(isliving(user))
		var/mob/living/fren = user
		friends += fren
		tame = TRUE
	visible_message("<span class='notice'>[src] bites [O] and grinds it into a digestable paste with its teeth.</span>")
	buffed = (buffed + 1)
	adjustBruteLoss(-2)
	if(buffed >= 10)
		pustule_churn()
	qdel(O)

/mob/living/simple_animal/hostile/ordeal/amber_bug/morsel/proc/pustule_churn()
	var/newsize = current_size
	visible_message("<span class='notice'>The pustule on [src]'s back begins to churn.</span>")
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
	return

		//Green
/datum/crafting_recipe/green_price
	name = "Modified Green Ordeal"
	result = /mob/living/simple_animal/hostile/ordeal/green_bot/price
	reqs = list(/obj/item/food/meat/slab/robot = 4,)
	time = 50
	category= CAT_ROBOT

/mob/living/simple_animal/hostile/ordeal/green_bot/price
	name = "price of hope"
	desc = "A slim robot draped in worn rags, they seems to have lost their only arm. The robot will obey simple commands when touched with a bare hand."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "dearmeddoubt"
	icon_living = "dearmeddoubt"
	icon_dead = "dearmeddoubt_slain"
	faction = list("green_ordeal", "neutral")
	wander = 0
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
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
	vision_range = 4
	var/weapon

/mob/living/simple_animal/hostile/ordeal/green_bot/price/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<b>Who pays the price of those made to suffer?</b>")

/mob/living/simple_animal/hostile/ordeal/green_bot/price/AttackingTarget()
	return

/mob/living/simple_animal/hostile/ordeal/green_bot/price/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client)
		var/robot_ask = alert("select command", "[src] recognizes your authority.", "Follow", "Stay", "Grab", "Cancel")
		if(robot_ask == "Follow")
			Goto(M, move_to_delay, 2)
			return
		if(robot_ask == "Stay")
			LoseTarget()
			return
		if(robot_ask == "Grab")
			haul(M)
			return
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/green_bot/price/proc/haul(mob/living/carbon/M)
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
/mob/living/simple_animal/hostile/ordeal/crimson_clown/smallchuckles
	name = "small chuckles"
	desc = "A small jester with patchwork leather for skin. Perhaps they lost their troupe."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "small_chuckles"
	icon_living = "crimson_clown"
	a_intent = "disarm"
	dextrous = TRUE
	possible_a_intents = list("help", "disarm", "grab")
	faction = list("crimson_ordeal", "neutral")
	friendly_verb_continuous = "smacks"
	friendly_verb_simple = "smack"
	speak_emote = list("chuckles", "giggles", "laughs")
	mob_biotypes = MOB_ORGANIC | MOB_UNDEAD
	speak_chance = 5
	butcher_results = list(/obj/item/food/meat/steak/meatproduct = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/steak/meatproduct = 1)
	stop_automated_movement_when_pulled = 1
	search_objects = 1
	mob_size = MOB_SIZE_SMALL
	tame = TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/smallchuckles/TeleportAway()
	return

/mob/living/simple_animal/hostile/ordeal/crimson_clown/smallchuckles/CanTeleportTo(obj/machinery/computer/abnormality/CA)
	return
