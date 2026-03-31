#define STATUS_EFFECT_DANGLE /datum/status_effect/dangle
GLOBAL_LIST_INIT(dingle_hallucination_list, list(
	/datum/hallucination/chat = 30,
	/datum/hallucination/fake_meltdown/dingle = 17,
	/datum/hallucination/hudscrew = 12,
	/datum/hallucination/fake_alert = 12,
	/datum/hallucination/delusion = 7,
	/datum/hallucination/stationmessage = 4,
	/datum/hallucination/self_delusion = 2
	))

/mob/living/simple_animal/hostile/abnormality/dingledangle
	name = "Dingle-Dangle"
	desc = "A cone that goes up to the ceiling with a ribbon tied around it."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "dangle"
	portrait = "dingle_dangle"
	maxHealth = 120
	health = 120
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 60, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 20, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	start_qliphoth = 3
	pixel_x = -16
	base_pixel_x = -16
	work_damage_upper = 3
	work_damage_lower = 2
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
	var/list/delirious_people = list()
	var/list/entangled_people = list()
	//We want to make sure we don't cause someone to instantly panic after it "breaches"
	var/safe = FALSE

/mob/living/simple_animal/hostile/abnormality/dingledangle/PostSpawn()
	. = ..()
	for(var/turf/open/T in range(1, src)) // fill its cell with roots
		new/obj/effect/dingle_roots(T)

/mob/living/simple_animal/hostile/abnormality/dingledangle/examine(mob/living/user)
	if(user.has_status_effect(STATUS_EFFECT_DANGLE))
		desc = "A cone that goes up to the ceiling with a ribbon tied around it. Bodies are strung up around it, seeming to be tied to the ceiling."
	. = ..()
	desc = initial(desc)

/mob/living/simple_animal/hostile/abnormality/dingledangle/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE, PROC_REF(OnHumanInsane))

/mob/living/simple_animal/hostile/abnormality/dingledangle/proc/OnHumanInsane(datum/source, mob/living/carbon/human/H, attribute)
	SIGNAL_HANDLER
	if(!IsContained())
		return FALSE
	if(!H.mind) // That wasn't a player at all...
		return FALSE
	if(H.z != z)
		return FALSE
	datum_reference.qliphoth_change(-1)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/dingledangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 60 && work_type != ABNORMALITY_WORK_INSIGHT)
		user.adjustSanityLoss(user.maxSanity)
	if(user.sanity_lost)
		user.apply_status_effect(STATUS_EFFECT_DANGLE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/dingledangle/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(3)
	safe = TRUE
	var/mob/living/carbon/human/marked = null
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(z != H.z)
			continue
		if(H.stat == DEAD || H.sanity_lost)
			continue
		if(get_attribute_level(H, PRUDENCE_ATTRIBUTE) < 60)
			continue
		if(!H.mind)
			continue
		//If we don't have someone selected, we select the first guy that has the requirements
		if(!marked)
			marked = H
			continue
		var/H_dist = get_dist(src, H)
		var/marked_dist = get_dist(src, H)
		//First we make sure the guy we're checking isn't further away than the selected guy
		if(marked_dist < H_dist)
			continue
		else if(marked_dist == H_dist)
			//Then we see if the current guy we're checking has higher prudence
			if(get_attribute_level(H, PRUDENCE_ATTRIBUTE) > get_attribute_level(marked, PRUDENCE_ATTRIBUTE))
				marked = H
			//If both of them are the same distance away from dingle and have the same amount of prudence, it should be random
			else if(get_attribute_level(H, PRUDENCE_ATTRIBUTE) == get_attribute_level(marked, PRUDENCE_ATTRIBUTE))
				if(prob(50))
					marked = H
			//Otherwise we don't changed the selected guy
		else
			//If the guy we're checking is closer to dingle than the guy already selected, they will be selected instead
			marked = H
	if(marked)
		var/datum/status_effect/dangle/D = marked.has_status_effect(STATUS_EFFECT_DANGLE)
		if(!D)
			marked.apply_status_effect(STATUS_EFFECT_DANGLE)
		else
			D.duration = initial(D.duration) + world.time

/mob/living/simple_animal/hostile/abnormality/dingledangle/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/dingledangle/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/dingledangle/Life()
	. = ..()
	if(IsContained())
		CheckView()

/mob/living/simple_animal/hostile/abnormality/dingledangle/proc/CheckView()
	var/list/humans = list()
	for(var/mob/living/carbon/human/H in view(5, src))
		if(!H.has_status_effect(STATUS_EFFECT_DANGLE))
			continue
		if(H.stat == DEAD || H.sanity_lost)
			continue
		humans += H
	if(LAZYLEN(humans))
		if(safe)
			return
		for(var/mob/living/carbon/human/H in humans)
			H.adjustSanityLoss(H.maxSanity)
		return
	safe = FALSE

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
	max_integrity = 40
	buckle_lying = 90
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	layer = ABOVE_MOB_LAYER
	pixel_y = -6
	var/damage = 8
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
				H.deal_damage(damage * H.maxHealth/100, BRUTE)
				if(H.health < 0)
					H.Drain()
				dealt_damage = TRUE
			if(dealt_damage)
				playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', 60, TRUE)

/obj/structure/swarming_roots/proc/release_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x
	unbuckle_mob(M,force=1)
	M.pixel_z = 0
	src.visible_message(text("<span class='danger'>[M] is free from [src]!</span>"))
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

/atom/movable/screen/alert/status_effect/dangle
	name = "Delirious"
	desc = "Your weakened mental state is causing you to see and hear things!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "delirious"

/datum/status_effect/dangle
	id = "dangle"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 4 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/dangle
	var/tries = 0
	var/list/dingles = list()


/datum/status_effect/dangle/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.white_mod *= 1.3
	if(status_holder.sanity_lost)
		qdel(src)
		return
	for(var/mob/living/simple_animal/hostile/abnormality/dingledangle/M in GLOB.mob_living_list)
		var/image/A = image('ModularTegustation/Teguicons/64x96.dmi', M, "dangle_delirious")
		A.override = 1
		if(status_holder.client)
			dingles |= A
			status_holder.client.images |= A

/datum/status_effect/dangle/tick()
	. = ..()
	if(!ishuman(owner))
		return
	//It should cause a hallucination eventually without spamming it.
	if(tries >= 5 && (prob(4) || tries >= 20))
		tries = 0
		var/halpick = pickweight(GLOB.dingle_hallucination_list)
		new halpick(owner, FALSE)
	else
		tries ++
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		qdel(src)

/datum/status_effect/dangle/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	for(var/image/I in dingles)
		if(status_holder.client)
			status_holder.client.images.Remove(I)
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
	walkspeed -= (min(0.95,((get_attribute_level(living_pawn, JUSTICE_ATTRIBUTE)) * 0.01)))//one-hundreth of a second for every point of justice, capped at 95
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
