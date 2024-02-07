//Coded and sprited by Coxswain, E.G.O. sprites by Rotipik#8251
/mob/living/simple_animal/hostile/abnormality/orange_tree
	name = "My Sweet Orange Tree"
	desc = "A formless being of yellow, light blue and green particles. They are floating around, lazily."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "orange_tree"
	icon_living = "orange_tree"
	portrait = "orange_tree"
	faction = list("hostile")
	speak_emote = list("hums")
	is_flying_animal = TRUE
	pixel_x = -8
	base_pixel_x = -8

	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 50, 45, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 55, 55, 60),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 45, 45, 45),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7

	ego_list = list(
		/datum/ego_datum/weapon/innocence,
		/datum/ego_datum/weapon/innocence/gun,
		/datum/ego_datum/armor/innocence,
	)
	gift_type =  /datum/ego_gifts/innocence
	gift_message = "Everyone has their own sweet orange tree in their heart."
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	var/datum/looping_sound/orangetree_ambience/soundloop

//Spawn/Del Procs
/mob/living/simple_animal/hostile/abnormality/orange_tree/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/orange_tree/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/abnormality/orange_tree/PostSpawn()
	..()
	var/list/machine_area = range(2, src)
	if((locate(/obj/structure/flamethrowercabinet) in machine_area))
		return
	for(var/dir in GLOB.alldirs)
		if((dir != NORTHEAST) && (dir != NORTH))
			continue
		var/turf/F = get_step(src,dir)
		var/turf/T = get_step(F, NORTH)
		new /obj/structure/flamethrowercabinet(T)

//Work/Breach
/mob/living/simple_animal/hostile/abnormality/orange_tree/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		var/datum/disease/orange_tree/D = new()
		user.ForceContractDisease(D, FALSE, TRUE)
	return

/mob/living/simple_animal/hostile/abnormality/orange_tree/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	var/datum/disease/orange_tree/D = new()
	user.ForceContractDisease(D, FALSE, TRUE)
	return

/mob/living/simple_animal/hostile/abnormality/orange_tree/ZeroQliphoth(mob/living/carbon/human/user)
	Spread()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/orange_tree/proc/Spread()
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	turf_list = spiral_range_turfs(36, target_c)
	playsound(target_c, 'sound/abnormalities/orangetree/ding.ogg', 50, 1, 5)
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/dancing_lights(T)
		for(var/mob/living/carbon/human/H in T.contents)
			if(prob(90))
				var/datum/disease/orange_tree/D = new()
				H.ForceContractDisease(D, FALSE, TRUE)

//Special Panic
/datum/ai_controller/insane/murder/orangetree
	lines_type = /datum/ai_behavior/say_line/insanity_wander/orangetree //We use the wander subtype so that it drains sanity

/datum/status_effect/panicked_type/orangetree
	icon = "orangetree"

/datum/ai_controller/insane/murder/orangetree/TryFindWeapon()
	return FALSE

/datum/ai_controller/insane/murder/orangetree/SelectBehaviors(delta_time)
	var/mob/living/living_pawn = pawn
	var/mob/living/selected_enemy = blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	if(selected_enemy)
		if(!(selected_enemy in livinginrange(10, living_pawn)))
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(selected_enemy.status_flags & GODMODE)
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
			return
		if(selected_enemy.stat != DEAD)
			if(!ishuman(selected_enemy))
				blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
				return
			var/mob/living/carbon/human/H = selected_enemy
			if(H.sanity_lost) //Should prevent them from hug spamming each other
				for(var/datum/disease/orange_tree/T in H.diseases)
					blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
					return
			current_movement_target = selected_enemy
			if(DT_PROB(50, delta_time))
				current_behaviors += GET_AI_BEHAVIOR(lines_type)
			current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/insanity_chase_mob)
			return
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
		return

	for(var/mob/living/L in view(9, living_pawn))
		if(L == living_pawn)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		if(prob(33))
			blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = L
			return

//Panic Ai Behavior
/datum/ai_behavior/say_line/insanity_wander/orangetree //this subtype should make the lines cause white damage... probably.
	lines = list(
		"Come with me! I've got to introduce you to my new friend!",
		"Where are you going? We're going to be late for supper!",
		"Would you like an adventure now, or would like to have your tea first?",
		"We're off to Neverland!",
	)

/datum/ai_behavior/insanity_chase_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/insanity_chase_mob/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn

	if(!target || target.stat == DEAD || !ishuman(target))
		finish_action(controller, TRUE) //Target's dead jim :(
		return

	if(isturf(target.loc) && !IS_DEAD_OR_INCAP(living_pawn))
		if(!living_pawn.Adjacent(target))
			return
		living_pawn.a_intent = INTENT_HELP //FREE HUGS!
		attack(controller, target, delta_time)

/datum/ai_behavior/insanity_chase_mob/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	walk(living_pawn, 0)
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

/datum/ai_behavior/insanity_chase_mob/proc/attack(datum/ai_controller/insane/murder/orangetree/controller, mob/living/target, delta_time)
	var/mob/living/living_pawn = controller.pawn
	if(!living_pawn.Adjacent(target))
		return
	if(living_pawn.next_move > world.time)
		return
	living_pawn.changeNext_move(CLICK_CD_MELEE * 5) //No need to be so liberal with it
	living_pawn.face_atom(target) // AAATTAAACK!
	living_pawn.UnarmedAttack(target)
	finish_action(controller, TRUE)

//Effects
/obj/effect/temp_visual/dancing_lights
	icon_state = "dancing_lights"
	alpha = 0
	duration = 50

/obj/effect/temp_visual/dancing_lights/Initialize()
	..()
	animate(src, alpha = rand(125,200), time = 5)
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 5)

/obj/effect/temp_visual/dancing_lights/proc/fade_out()
	animate(src, alpha = 0, time = duration-5)

//Its the gun storage cabinet! Aww, it's just a reskinned fire axe cabinet...
/obj/structure/flamethrowercabinet
	name = "flamethrower"
	desc = "There is a small label that reads \"For use in abnormality breach\" along with details for safe use of the thing. As if."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "flamethrower"
	anchored = TRUE
	density = FALSE

	resistance_flags = INDESTRUCTIBLE
	var/open = FALSE
	var/obj/item/gun/ego_gun/flammenwerfer/flamethrower

/obj/structure/flamethrowercabinet/Initialize()
	. = ..()
	flamethrower = new
	update_icon()

/obj/structure/flamethrowercabinet/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(open)
		if(flamethrower)
			user.put_in_hands(flamethrower)
			flamethrower = null
			to_chat(user, span_notice("You take the flamethrower from the [name]."))
			src.add_fingerprint(user)
			update_icon()
			return
	else
		open = !open
		update_icon()
		return

/obj/structure/flamethrowercabinet/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/flamethrowercabinet/update_overlays()
	. = ..()
	if(flamethrower)
		. += "thrower"
	if(open)
		. += "glass_raised"
	else
		. += "glass"

/obj/structure/flamethrowercabinet/verb/toggle_open()
	set name = "Open/Close"
	set category = "Object"
	set src in oview(1)
	open = !open
	update_icon()
	return

/obj/structure/flamethrowercabinet/attackby(obj/item/I, mob/user, params)
	if(open)
		if(istype(I, /obj/item/gun/ego_gun/flammenwerfer) && !flamethrower)
			var/obj/item/gun/ego_gun/flammenwerfer/F = I
			if(!user.transferItemToLoc(F, src))
				return
			flamethrower = F
			to_chat(user, span_notice("You place the [F.name] back in the [name]."))
			update_icon()
			return
	else
		toggle_open()
	return ..()
