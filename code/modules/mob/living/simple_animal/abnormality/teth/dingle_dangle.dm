#define STATUS_EFFECT_DANGLE /datum/status_effect/dangle
/mob/living/simple_animal/hostile/abnormality/dingledangle
	name = "Dingle-Dangle"
	desc = "A cone that goes up to the ceiling with a ribbon tied around it. Bodies are strung up around it, seeming to be tied to the ceiling."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "dangle"
	portrait = "dingle_dangle"
	maxHealth = 120
	health = 120
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 60, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(30, 40, 70, 70, 70),
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_upper = 3
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy

	ego_list = list(
		/datum/ego_datum/weapon/lutemia,
		/datum/ego_datum/armor/lutemia
	)
	gift_type = /datum/ego_gifts/lutemis
	gift_message = "Let's all become fruits. Let's hang together. Your despair, sadness... Let's all dangle down."
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "You pass by the containment cell and, in the corner of your eye, spy your comrades dangling from ribbons, furiously scratching at their necks in choked agony."
	observation_choices = list(
		"Save them" = list(TRUE, "Regardless of your resolution, you find yourself before the tree anyway as one of its ribbons wrap around your neck. <br>\
			\"Let's dangle together, let your sorrows, your pain dangle, let's all dangle down...\" <br>It whispers into your mind. <br>\
			Your comrades were never here, the life passes from your body painlessly. <br> None of this is real."),
		"Do not save them" = list(TRUE, "Regardless of your resolution, you find yourself before the tree anyway as one of its ribbons wrap around your neck. <br>\
			\"Let's dangle together, let your sorrows, your pain dangle, let's all dangle down...\" <br>It whispers into your mind. <br>\
			Your comrades were never here, the life passes from your body painlessly. <br> None of this is real."),
	)
	var/aoe_cooldown
	var/aoe_cooldown_time = 30 SECONDS
	var/aoe_range = 14

/mob/living/simple_animal/hostile/abnormality/dingledangle/PostSpawn()
	. = ..()
	for(var/turf/open/T in range(1, src)) // fill its cell with roots
		new/obj/effect/dingle_roots(T)

/mob/living/simple_animal/hostile/abnormality/dingledangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 60) // below level 3
		return ..()

	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80) // fort 4 or higher
		return ..()

	if(user)
		user.adjustSanityLoss(user.maxSanity)
		user.apply_status_effect(STATUS_EFFECT_DANGLE)

/mob/living/simple_animal/hostile/abnormality/dingledangle/Life()
	. = ..()
	if(aoe_cooldown <= world.time)
		aoe_cooldown = world.time + aoe_cooldown_time
		InflictHallucinations()

/mob/living/simple_animal/hostile/abnormality/dingledangle/proc/InflictHallucinations()
	for(var/mob/living/carbon/human/H in urange(aoe_range, src))
		if(H.stat == DEAD)
			continue
		if(!H.has_status_effect(/datum/status_effect/panicked_type/dingle) || !HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/dingle_possess) || !(H.buckled && istype(H.buckled, /obj/structure/swarming_roots)))
			if(get_attribute_level(H, PRUDENCE_ATTRIBUTE) >= 60) // at or above level 3
				H.apply_status_effect(STATUS_EFFECT_DANGLE)

/mob/living/simple_animal/hostile/abnormality/dingledangle/proc/Consume(mob/living/carbon/human/H)
	if(!H)
		return
	var/obj/structure/swarming_roots/N = new(get_turf(H))
	N.buckle_mob(H)
	QDEL_NULL(H.ai_controller)

/obj/effect/dingle_roots
	gender = PLURAL
	name = "pink roots"
	desc = "Strange pink roots.."
	icon = 'icons/effects/effects.dmi'
	icon_state = "dingle_roots"///Recolored pink shoe's ribons do look like dingle's roots
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

//On-kill visual effect
//It's easy to accidentally kill someone instead of the roots. That is intentional
/obj/structure/swarming_roots
	name = "swarming roots"
	desc = "A large amount of pink roots that are burrowing into someone!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "dingle_roots_person"
	max_integrity = 20
	buckle_lying = 90
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	layer = ABOVE_MOB_LAYER
	pixel_y = -6
	var/damage = 5
	var/damage_cooldown
	var/damage_cooldown_time = 5 SECONDS

/obj/structure/swarming_roots/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/swarming_roots/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return

/obj/structure/swarming_roots/buckle_mob(mob/living/M, force, check_loc, buckle_mob_flags)
	if(M.buckled)
		return
	M.setDir(2)
	ADD_TRAIT(M, TRAIT_INCAPACITATED, type)
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, type)
	ADD_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	return ..()

/obj/structure/swarming_roots/sleeping/post_buckle_mob(mob/living/M)
	..()
	animate(M, pixel_y = -6, time = 3)

/obj/structure/swarming_roots/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	return

/obj/structure/swarming_roots/process(delta_time)
	if(damage_cooldown < world.time)
		damage_cooldown = world.time + damage_cooldown_time
		if(has_buckled_mobs())
			var/dealt_damage = FALSE
			for(var/mob/living/carbon/human/H in buckled_mobs)
				if(H.stat == DEAD)
					continue
				H.deal_damage(damage, BRUTE)
				H.hallucination += 5
				if(H.health < 0)
					H.Drain()
				dealt_damage = TRUE
			if(dealt_damage)
				playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', 60, TRUE)

/obj/structure/swarming_roots/proc/release_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x
	unbuckle_mob(M,force=1)
	M.pixel_z = 0
	src.visible_message(text("<span class='danger'>[M] falls free of [src]!</span>"))
	M.Knockdown(10, FALSE)
	REMOVE_TRAIT(M, TRAIT_INCAPACITATED, type)
	REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, type)
	REMOVE_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjustSanityLoss(-H.maxSanity)
	M.update_icon()

/obj/structure/swarming_roots/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()


//A simple 30 second increased white damage taken
/datum/status_effect/dangle
	id = "dangle"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = null

/datum/status_effect/dangle/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.hallucination += 10
	status_holder.physiology.white_mod *= 1.3
	if(status_holder.sanity_lost)
		qdel(src)

/datum/status_effect/dangle/tick()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		qdel(src)

/datum/status_effect/dangle/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.white_mod /= 1.3
	if(status_holder.sanity_lost)
		QDEL_NULL(owner.ai_controller)
		status_holder.ai_controller = /datum/ai_controller/insane/dingle_possess
		status_holder.InitializeAIController()
		owner.apply_status_effect(/datum/status_effect/panicked_type/dingle)
	return ..()


//***Custom Panic Definiton***
/datum/status_effect/panicked_type/dingle
	icon = "dingle"

//***Custom Panic Definiton***
/datum/ai_controller/insane/dingle_possess//define AI controller
	lines_type = /datum/ai_behavior/say_line/insanity_dingle

/datum/ai_behavior/say_line/insanity_dingle
	lines = list(
		"It's trying to escape...!",
		"I got to stop it from breaching!",
	)

/datum/ai_controller/insane/dingle_possess/SelectBehaviors(delta_time)//Selects red shoes as the target
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return
	var/mob/living/simple_animal/hostile/abnormality/dingledangle/dingle
	for(var/mob/living/simple_animal/hostile/abnormality/dingledangle/M in GLOB.mob_living_list)
		if(!istype(M))
			continue
		dingle = M
	if (!dingle)//No runtimes after suppression, woohoo!
		return
	if(dingle.status_flags & GODMODE)//don't get possessed if it's already breaching
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/dingle_move)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = dingle

/datum/ai_controller/insane/dingle_possess/PerformIdleBehavior(delta_time)
	if(DT_PROB(20, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

/datum/ai_behavior/dingle_move//define AI behavior
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	var/list/current_path = list()
	var/should_be_finished = FALSE

/datum/ai_behavior/dingle_move/perform(delta_time, datum/ai_controller/controller)//Paths the pancicked to red shoes, causes runtimes if it's dead
	. = ..()
	var/walkspeed = 1
	var/mob/living/carbon/human/living_pawn = controller.pawn//the panicked
	if(IS_DEAD_OR_INCAP(living_pawn))//stop if the panicked is dead
		return
	if(!living_pawn.sanity_lost)
		QDEL_NULL(living_pawn.ai_controller)
		return
	var/mob/living/simple_animal/hostile/abnormality/dingledangle/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!istype(target))
		finish_action(controller, FALSE)
		return
	if(!LAZYLEN(current_path))
		current_path = get_path_to(living_pawn, target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 80)
		if(!current_path) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
	if(!ishuman(living_pawn))
		return
	walkspeed -= (max(0.95,((get_attribute_level(living_pawn, JUSTICE_ATTRIBUTE)) * 0.01)))//one-hundreth of a second for every point of justice, capped at 95
	addtimer(CALLBACK(src, PROC_REF(Movement), controller), walkspeed SECONDS, TIMER_UNIQUE)
	if(isturf(target.loc) && living_pawn.Adjacent(target))
		finish_action(controller, TRUE)
		return

/datum/ai_behavior/dingle_move/proc/Movement(datum/ai_controller/controller)//Ditto
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/dingledangle/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!target)
		if(living_pawn)//there's a runtime if you panic right next to it
			QDEL_NULL(living_pawn.ai_controller)
			living_pawn.SanityLossEffect(PRUDENCE_ATTRIBUTE)//switch to a suicide panic due to hanging yourself
		return
	if(!LAZYLEN(current_path))
		QDEL_NULL(living_pawn.ai_controller)
		living_pawn.SanityLossEffect(PRUDENCE_ATTRIBUTE)//ditto
		return
	var/target_turf = current_path[1]
	step_towards(living_pawn, target_turf)
	current_path.Cut(1, 2)
	if(target)
		if(isturf(target.loc) && living_pawn.Adjacent(target))
			finish_action(controller, TRUE)
			return

/datum/ai_behavior/dingle_move/finish_action(datum/ai_controller/controller, succeeded)//When the panicked reach Red Shoes
	. = ..()
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/obj/item/held = living_pawn.get_active_held_item()
	var/mob/living/simple_animal/hostile/abnormality/dingledangle/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!target)
		QDEL_NULL(living_pawn.ai_controller)
		return
	if(succeeded)
		living_pawn.dropItemToGround(held)
		target.Consume(living_pawn)
		QDEL_NULL(living_pawn.ai_controller)
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
