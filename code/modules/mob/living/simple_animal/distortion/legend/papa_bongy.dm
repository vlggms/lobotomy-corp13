// Threats appropriate for a single grade 7-5 fixer, or multiple weaker fixers.

/mob/living/simple_animal/hostile/distortion/papa_bongy
	name = "Papa Bongy"
	desc = "A human with the head of a chicken and deformed arms. It appears to be carrying a sack of raw chickens."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "papa_bongy"
	maxHealth = 2500
	health = 2500
	pixel_x = -16
	base_pixel_x = -16
	fear_level = HE_LEVEL
	can_spawn = TRUE
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	melee_damage_lower = 15
	melee_damage_upper = 20
	melee_damage_type = WHITE_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/distortions/papa_bongy/PapaBongy_Coin1.ogg'
	attack_verb_continuous = "smacks"
	attack_verb_simple = "smack"
	ranged = TRUE
	ranged_cooldown_time = 10 SECONDS
	del_on_death = FALSE
	faction = list("bongy")

	ego_list = list(
		/obj/item/ego_weapon/lance/lifestew_lance,
		/obj/item/clothing/suit/armor/ego_gear/he/lifestew
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Hong Gil-Dong")//This is a korean John Doe, as the Eunbong owner is unnamed.
	gender = MALE
	egoist_attributes = 40
	egoist_outfit = /datum/outfit/job/civilian
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Lifetime stew's background has bongy's head mounted on the wall, giving an obvious connection.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/basilisoup
	loot = list(/obj/item/documents/ncorporation)

	var/can_act = TRUE
	var/ding_delay = 1.5 SECONDS
	var/throw_delay = 2 SECONDS
	var/unit_list = list()
	var/units_max = 8
	var/happy = FALSE
	var/yucky_list = list(
	/datum/reagent/consumable/enzyme,
	/datum/reagent/consumable/soymilk,
	/datum/reagent/consumable/astrotame,
	)
	var/bad_pizza_list = list(
	/obj/item/food/pizzaslice/donkpocket,
	/obj/item/food/pizzaslice/dank,
	/obj/item/food/pizzaslice/pineapple,
	/obj/item/food/pizzaslice/moldy,
	)

/mob/living/simple_animal/hostile/distortion/papa_bongy/Initialize(mapload)
	..()
	var/units_to_add = list(
		/mob/living/simple_animal/hostile/bongy_hostile = 1,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE, TRUE)

/mob/living/simple_animal/hostile/distortion/papa_bongy/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//Unmanifesting is not linked to any proc by default, if you want it to happen during gameplay, it must be called manually.
/mob/living/simple_animal/hostile/distortion/papa_bongy/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/food/fried_chicken))//Fried chicken will require certain condiments to de-manifest in the future. For now, keep it simple
		for(var/goop in I.reagents.reagent_list)
			var/datum/reagent/R = goop
			if(istype(R, /datum/reagent/consumable/capsaicin))
				if(R.volume >= 40)//is it REALLY spicy?
					say("BUGAAAAAAAAAAAAAAAAAAAAAAAAWK!")
					to_chat(user, "[src] grimaces, sputters and coughs! It begins thrashing about, and you feel the temperature around you rise...")
					new /mob/living/simple_animal/hostile/distortion/papa_bongy/spicy(get_turf(src))
					qdel(src)
					break
			if(R.type in yucky_list)
				say("BAWK BAWK!!!")
				to_chat(user, "[src] didn't like that at all.")
				adjustBruteLoss(150)
				break
		qdel(I)
	if(istype(I, /obj/item/food/pizzaslice))
		if(I.type in bad_pizza_list)
			say("BAWK BAWK!!!")
			to_chat(user, "[src] didn't like that at all.")
			adjustBruteLoss(150)
			return
		qdel(I)
		happy = TRUE
	if(happy == FALSE)
		return
	else
		qdel(I)
		can_act = FALSE
		addtimer(CALLBACK(src, PROC_REF(Unmanifest)),3 SECONDS)

/mob/living/simple_animal/hostile/distortion/papa_bongy/OpenFire(atom/A)
	if(!can_act)
		return FALSE
	if(get_dist(src, A) <= 2) //no shooty in mele
		return FALSE
	if(LAZYLEN(unit_list) >= units_max)
		return FALSE
	ThrowBongy(A)
	return ..()

/mob/living/simple_animal/hostile/distortion/papa_bongy/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/distortion/papa_bongy/CanAttack(atom/the_target)
	if(ishuman(the_target))
		var/mob/living/carbon/human/L = the_target
		if(L.sanity_lost && L.stat != DEAD)
			if(HAS_AI_CONTROLLER_TYPE(L, /datum/ai_controller/insane/murder/bongy))
				return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/papa_bongy/AttackingTarget(atom/attacked_target)
	if(!can_act || !attacked_target)
		return FALSE
	if(!isliving(attacked_target))
		return ..()
	var/mob/living/carbon/human/H = attacked_target
	if(ishuman(H))
		if(istype(H.ai_controller, /datum/ai_controller/insane/murder/bongy))
			LoseTarget()
			return//need to test whether this is still needed
		H.add_movespeed_modifier(/datum/movespeed_modifier/bongy)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/bongy), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		if(H.sanity_lost)
			BongyPanic(H)
	..()
	can_act = FALSE
	return DingAttack(attacked_target)

/mob/living/simple_animal/hostile/distortion/papa_bongy/proc/DingAttack(target)
	var/turf/target_turf = get_turf(target)
	var/list/been_hit = list()
	var/picked_sound = 'sound/distortions/papa_bongy/PapaBongy_Coin2.ogg'
	for (var/i = 1, i <= 3, i++)
		if(stat == DEAD)
			return
		sleep(ding_delay)
		switch(i)
			if(1)
				picked_sound = 'sound/distortions/papa_bongy/PapaBongy_Coin2.ogg'
			if(2)
				picked_sound = 'sound/distortions/papa_bongy/PapaBongy_Coin3.ogg'
			if(3)
				picked_sound = 'sound/distortions/papa_bongy/PapaBongy_Coin4.ogg'
		playsound(src, picked_sound, 70, FALSE)
		do_attack_animation(target_turf)
		for(var/turf/T in range(i, target_turf))
			new /obj/effect/temp_visual/smash_effect(T)
			been_hit = HurtInTurf(T, been_hit, melee_damage_lower, WHITE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, mech_damage = 15)
			if(i == 3)
				for(var/mob/living/carbon/human/H in T)
					H.Knockdown(20)
					if(H.sanity_lost)
						BongyPanic(H)
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/papa_bongy/proc/ThrowBongy(atom/A)//FIX THIS: shitcode
	playsound(src, 'sound/distortions/papa_bongy/Bongy_Throw.ogg', 70, FALSE)
	var/turf/T = get_turf(A)
	can_act = FALSE
	SLEEP_CHECK_DEATH(throw_delay)
	var/choice = rand(1, 100)
	switch(choice)
		if(1)
			var/obj/item/toy/plush/bongy/thrown_object = new(get_turf(src))
			thrown_object.throw_at(T, 10, 3, src, spin = TRUE)
		if(2 to 12)
			var/obj/item/clothing/mask/facehugger/bongy/thrown_object = new(get_turf(src))
			thrown_object.throw_at(T, 10, 3, src, spin = TRUE)
		if(13 to 100)
			var/mob/living/simple_animal/hostile/bongy_hostile/thrown_object = new(get_turf(src))
			thrown_object.throw_at(T, 10, 3, src, spin = TRUE)
			thrown_object.master = src
			unit_list += thrown_object
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/papa_bongy/proc/BongyPanic(target)
	var/mob/living/carbon/human/H = target
	if(!HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/murder/bongy))
		var/obj/item/clothing/mask/facehugger/bongy/bongymask = new(get_turf(H))
		H.equip_to_slot_if_possible(bongymask, ITEM_SLOT_MASK, FALSE, TRUE, TRUE)
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/murder/bongy
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/bongy)
		LoseTarget()
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/bongy_hostile
	name = "bongy"
	desc = "It looks like a raw chicken. A furious raw chicken!"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bongy"
	icon_living = "bongy"
	icon_dead = "bongy_dead"
	gender = NEUTER
	health = 25
	maxHealth = 25
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/distortions/papa_bongy/Bongy_Coin1.ogg'
	faction = list("bongy")
	var/mob/living/simple_animal/hostile/distortion/papa_bongy/master

/mob/living/simple_animal/hostile/bongy_hostile/Initialize()
	var/icon_select = rand(1, 3)
	switch(icon_select)
		if(2)
			icon_state = "bongy_2"
			icon_dead = "bongy_dead2"
		if(3)
			icon_state = "bongy_3"
			icon_dead = "bongy_dead3"
	..()

/mob/living/simple_animal/hostile/bongy_hostile/CanAttack(atom/the_target)
	if(ishuman(the_target))
		var/mob/living/carbon/human/L = the_target
		if(L.sanity_lost && L.stat != DEAD)
			if(HAS_AI_CONTROLLER_TYPE(L, /datum/ai_controller/insane/murder/bongy))
				return FALSE
	return ..()

/mob/living/simple_animal/hostile/bongy_hostile/AttackingTarget(atom/attacked_target)
	if(!attacked_target)
		return FALSE
	var/mob/living/carbon/human/H = attacked_target
	..()
	if(ishuman(H) && H.sanity_lost)
		BongyPanic(H)

/mob/living/simple_animal/hostile/bongy_hostile/proc/BongyPanic(target)
	var/mob/living/carbon/human/H = target
	if(!HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/murder/bongy))
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/murder/bongy
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/bongy)
		var/obj/item/clothing/mask/facehugger/bongy/bongymask = new(get_turf(H))
		H.equip_to_slot_if_possible(bongymask, ITEM_SLOT_MASK, FALSE, TRUE, TRUE)
		forceMove(H)
		death()
		playsound(src, 'sound/distortions/papa_bongy/Bongy_Coin2.ogg', 70, FALSE)
		QDEL_IN(src, 5 SECONDS)
		return

/mob/living/simple_animal/hostile/bongy_hostile/throw_impact(atom/hit_atom)
	playsound(src, 'sound/distortions/papa_bongy/Bongy_Coin2.ogg', 70, FALSE)
	return ..()

/mob/living/simple_animal/hostile/bongy_hostile/death(gibbed)
	if(master)
		master.unit_list -= src
	..()

//special panic
/datum/status_effect/panicked_type/bongy
	icon = "murder"

/datum/ai_controller/insane/murder/bongy
	lines_type = /datum/ai_behavior/say_line/insanity_lines

/datum/ai_controller/insane/murder/bongy/CanTarget(atom/movable/thing)
	. = ..()
	var/mob/living/living_thing = thing
	if(. && istype(living_thing))
		if(ishuman(living_thing))
			var/mob/living/carbon/human/H = living_thing
			if(HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/murder/bongy))
				return FALSE
		if(istype(living_thing, /mob/living/simple_animal/hostile/bongy_hostile) || istype(living_thing, /mob/living/simple_animal/hostile/distortion/papa_bongy))
			return FALSE

/datum/ai_controller/insane/murder/bongy/FindEnemies(range = aggro_range)
	var/list/weighted_list = PossibleEnemies(range)
	for(var/atom/movable/i in weighted_list)
		//target type weight
		if(istype(i, /mob/living/simple_animal/hostile))
			weighted_list[i] = 4
		else if(ishuman(i))
			var/mob/living/carbon/human/H = i
			if(H.sanity_lost)
				weighted_list[i] = 1
			else if(ismecha(H.loc))
				weighted_list[i] = 4
			else
				weighted_list[i] = 7
		else
			weighted_list[i] = 1
		//target distance weight
		weighted_list[i] += 10 - min(get_dist(get_turf(pawn), get_turf(i)), 10)
		//previous target weight
		if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] == i)
			weighted_list[i] = max(weighted_list[i] - 10, 1)
	if(weighted_list.len > 0)
		GiveTarget(pickweight(weighted_list))
		return TRUE
	return FALSE

/datum/ai_controller/insane/murder/bongy/on_Crossed(datum/source, atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/murder/bongy))
			return
	..()

/datum/movespeed_modifier/bongy
	variable = TRUE
	multiplicative_slowdown = 1.5
