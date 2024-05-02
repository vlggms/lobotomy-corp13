#define STATUS_EFFECT_URGE /datum/status_effect/stacking/urge
GLOBAL_LIST_EMPTY(ribbon_list)
/mob/living/simple_animal/hostile/abnormality/pink_shoes
	name = "Pink Shoes"
	desc = "A pair of girly pink shoes."
	health = 1500
	maxHealth = 1500
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "pinkshoes"
	icon_living = "pinkshoes_breach"
	icon_dead = "pinkegg"
	portrait = "pink_shoes"
	light_color = "#EA19AA"//bluish pink used for the E.G.O ribbons
	light_range = 5
	light_power = 10
//	base_pixel_x = 0
//	pixel_x = 0
	can_breach = TRUE
	can_buckle = TRUE
	threat_level = HE_LEVEL
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = list(50, 50, 45, 50, 60),
						ABNORMALITY_WORK_ATTACHMENT = list(80, 80, 50, 40, 30),
						ABNORMALITY_WORK_REPRESSION = list(50, 60, 50, 55, 60)
						)
	work_damage_amount = 9
	work_damage_type = WHITE_DAMAGE
	del_on_death = FALSE
	death_message = "falls, leaving tattered ribbons."
	attack_sound = 'sound/abnormalities/pinkshoes/Pinkshoes_Attack.ogg'
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_type = WHITE_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/roseate,
		/datum/ego_datum/armor/roseate
		)
	gift_type =  /datum/ego_gifts/roseate_desire
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/mob/living/simple_animal/hostile/grown_strong/special_possessee
	var/mutable_appearance/breach_icon
	var/mob/living/possessee
	var/list/dense_ribbon_list

//*** Simple Mob Procs ***//
/mob/living/simple_animal/hostile/abnormality/pink_shoes/Life()
	..()
	if(status_flags & GODMODE)
		return
	for(var/obj/structure/spreading/pink_ribbon/R in range(10, get_turf(src)))
		if(R.last_expand <= world.time)
			R.expand()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/death()
	density = FALSE
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Binding.ogg', 100, 1)
	for(var/obj/O in src)
		O.forceMove(loc)
	if(possessee)//hopefully this refers to the specific individual
		possessee.status_flags &= ~GODMODE
		possessee.forceMove(loc)
		possessee.faction -= "hostile"
		possessee = null
	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)//stops possessing people, prevents runtimes. Panicked players are ghosted so use mob_living_list
		UnPossess(H)
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/Initialize()
	. = ..()
	if(locate(/obj/structure/pinkshoes_cushion) in get_turf(src))
		icon_state = "pinkshoes"
		update_icon()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/PostSpawn()
	..()
	if(locate(/obj/structure/pinkshoes_cushion) in get_turf(src))
		return
	new /obj/structure/pinkshoes_cushion(get_turf(src))
	return ..()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/Move()
	if(!possessee)
		return FALSE
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(!locate(/obj/structure/spreading/pink_ribbon) in get_turf(src))
		new /obj/structure/spreading/pink_ribbon(loc)
	..()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/CanAttack(atom/the_target)//should only attack when it has fists
	return FALSE

//*** Work Mechanics ***//
/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/Apply_Urge(mob/living/carbon/human/user)
	user.apply_status_effect(STATUS_EFFECT_URGE)//instant panic
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Attack.ogg', 100, 1)
	return

/mob/living/simple_animal/hostile/abnormality/pink_shoes/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/pink_shoes/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(1)
		return
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 || (user.sanity_lost))
		say("Applying urge to [user]!")//REMOVE THIS
		Apply_Urge(user)
		user.adjustSanityLoss(500)
		user.visible_message(span_userdanger("[user] blankly stumbles towards the Pink Shoes. Now [p_theyre()] reaching out their hand to take the shoes."), span_userdanger("What lovely shoes..."))

//***Breach Mechanics***//
	//normal BreachEffect stuff
/mob/living/simple_animal/hostile/abnormality/pink_shoes/BreachEffect(mob/living/carbon/human/user)
	if(!(status_flags & GODMODE))
		return
	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)//stops possessing people, prevents runtimes. Panicked players are ghosted so use mob_living_list
		UnPossess(H)
	..()
	if(!possessee)//normal breach
		icon = 'ModularTegustation/Teguicons/32x96.dmi'
		icon_state = "pinkshoes_breach"
		var/turf/T = pick(GLOB.xeno_spawn)
		forceMove(T)
		for(var/turf/open/T2 in oview(1, T))
			new /obj/structure/spreading/pink_ribbon/dense(get_turf(T2))
		for(var/turf/open/T3 in view(2, T))
			if(!isturf(T3) || isspaceturf(T3))
				continue
			if(locate(/obj/structure/spreading/pink_ribbon/dense)/*|| locate(/turf/closed/indestructible/reinforced)*/ in T3)
				continue
			new /obj/structure/spreading/pink_ribbon(get_turf(T3))
	light_range = 2
	update_light()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/attack_animal(mob/living/simple_animal/M)//current possession method, replace this
	. = ..()
	if(istype(M, src))
		return
	say("[M] has attacked me!")//REMOVE THIS
	if(!(status_flags & GODMODE))//if the abno is breached
		if(faction_check_mob(M))//allied units only
			AssimilateAnimal(M)
			say("[M] has procced AssimilateAnimal through attack_animal!")//REMOVE THIS
			return..()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/Assimilate(mob/living/carbon/user)
	if(possessee)//if it's already possessing someone
		return
	possessee = user
	var/mob/living/carbon/human/H = user
	QDEL_NULL(user.ai_controller)//stops it from running off
	if(ishuman(H) && (H.sanity_lost))
		user.forceMove(src)
		playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Breach.ogg', 50, 1)
		say("Breacheffect starting with arguments [user] ishuman passed!")//REMOVE THIS
		breach_icon = mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "pinkshoes_breach", -ABOVE_BODY_FRONT_LAYER)
		name = user.name
		appearance = user.appearance
		gender = user.gender
		desc = "[user.name] is making obscene gestures, covered in pink ribbons. Does [p_they()] normally wear shoes like those?"
		say("Adding overlay [breach_icon]!")//REMOVE THIS
		add_overlay(breach_icon)
		cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "panicked", -ABOVE_MOB_LAYER))
		BreachEffect(user)
		toggle_ai(AI_ON) //snipped from BreachEffect. Shouldn't apply to AssimilateAnimal
		return TRUE

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/AssimilateAnimal(mob/living/simple_animal/hostile/user)
	var/special_appearance = FALSE
	special_possessee = user
	if((istype(user, special_possessee)))//surgery almost makes this thing immortal. Make overrides so that it gibs on death() and make it place ribbons properly.
		user.icon_state = "pinkshoes_strong"
		user.update_icon()
		special_appearance = TRUE
	if(!special_appearance)
		say("[user] type mismatch with [special_possessee]!")
//		var/icon/flat_icon = user.icon
//		flat_icon.Blend(rgb(255,255,255))
//		flat_icon.BecomeAlphaMask()
//		var/icon/static_icon = icon('icons/effects/effects.dmi', "pinkribbons3")
//		static_icon.AddAlphaMask(flat_icon)
	user.SpeedChange(-1)
	user.UpdateSpeed()
	user.maxHealth += 1500
	user.melee_damage_lower += 7
	user.melee_damage_upper += 15
	user.revive(full_heal = TRUE, admin_revive = FALSE)
	user.desc += " Wait, are those high heels?"
	src.forceMove(user)
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Breach.ogg', 50, 1)
	say("Breacheffect starting with arguments [user] compatible!")//REMOVE THIS
	//remove dense ribbons here

/obj/effect/ribbon_mask
	name = "Pink Ribbons"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "pinkshoes_overlay"
	vis_flags = VIS_INHERIT_DIR

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/UnPossess(mob/living/carbon/human/user)//called on death() and BreachEffect()
	var/datum/status_effect/panicked_type/desirous/S = user.has_status_effect(/datum/status_effect/panicked_type/desirous)
	if(S)
		user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "pinkshoes_desirous", -MUTATIONS_LAYER))
		user.SanityLossEffect(JUSTICE_ATTRIBUTE)
//		user.add_overlay(mutable_appearance('icons/effects/effects.dmi', "breach", -ABOVE_MOB_LAYER))

//***Debuff Definition***/
//Urge
/datum/status_effect/stacking/urge
	id = "urge"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 10 SECONDS//Lasts for ten seconds
	max_stacks = 5
	stacks = 1
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/urge
	consumed_on_threshold = FALSE
	var/prud_mod = 0
	var/temp_mod = 0
	var/mutable_appearance/desire_icon

/atom/movable/screen/alert/status_effect/urge
	name = "Urge"
	desc = "The knot of desires must be undone."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "urge"

/datum/status_effect/stacking/urge/on_creation(mob/living/new_owner, ...)
	desire_icon = mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "pinkshoes_desirous", -ABOVE_MOB_LAYER)
	return..()

/datum/status_effect/stacking/urge/refresh()//applies funny red text every time it gets reapplied
	..()
	var/mob/living/carbon/human/H = owner
	switch(stacks)
		if(1)
			return
		if(2)
			to_chat(owner, "<span class='userdanger'>Put me on.</span>")
			ApplyBuff()
		if(3)
			to_chat(owner, "<span class='userdanger'>I'll carry you wherever you wish to go..</span>")
			ApplyBuff()
		if(4)
			to_chat(owner, "<span class='userdanger'>For some reason, you're struggling to decide what to do....</span>")
			ApplyBuff()
		if(5)
			duration += 30 SECONDS//die
			if(!istype(owner, H))//for simple mobs. They cannot panic.
				return
			if(prud_mod > -25)
				ApplyBuff()

/datum/status_effect/stacking/urge/proc/ApplyBuff()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(owner))//still causes runtimes on abnormalities???
		return
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -5)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -10)
	prud_mod -= 5
	temp_mod -= 10

/datum/status_effect/stacking/urge/on_apply()
	var/mob/living/carbon/human/status_holder = owner
	if(!ishuman(owner))
		return
	ApplyBuff()
	to_chat(owner, "A voice travels between the fluttering ribbons. \
	What is your desire?")
	if(status_holder.sanity_lost)
		owner.say("Desirous is calling on_remove!")
		qdel(src)
		return
	return ..()

/datum/status_effect/stacking/urge/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(ishuman(owner))
		if(owner.stat == DEAD)//dead players turn into zombies
			Convert(owner)
			return
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -prud_mod)
		H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -temp_mod)
		if(H.sanity_lost)//if you panic from urge. Caused runtimes without the istype check for some reason
			H.apply_status_effect(/datum/status_effect/panicked_type/desirous)//this causes a runtime!!!
			QDEL_NULL(owner.ai_controller)
			H.ai_controller = /datum/ai_controller/insane/pink_possess
			H.InitializeAIController()
			H.add_overlay(desire_icon)
			H.add_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "pinkshoes_desirous", -ABOVE_MOB_LAYER))//TODO: remove the overlay on un-panic
	return ..()

/datum/status_effect/stacking/urge/tick()
	..()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(owner))
		owner.adjustBruteLoss(stacks * -1)//heals abnormalities
		return
	H.apply_damage(stacks * 0.5, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
	if(H.sanity_lost)//if you panic from urge. Runtimes on abnos!
		qdel(src)

/datum/status_effect/stacking/urge/proc/Convert(mob/living/target)//Turns human corpses into pink shoes enchantees when desirous is applied
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Binding.ogg', 100, 1)
	var/mob/living/simple_animal/hostile/pink_zombie/Z = new(get_turf(target), target)
	Z.name = target.name

/datum/status_effect/panicked_type/desirous//doesn't do anything special

/datum/status_effect/panicked/panicked_type/desirous/on_remove()
	owner.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "pinkshoes_desirous", -ABOVE_MOB_LAYER))
	return ..()

/datum/status_effect/panicked/panicked_type/desirous/be_replaced()
	owner.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "pinkshoes_desirous", -ABOVE_MOB_LAYER))
	return ..()

//***Custom Panic Definiton***
/datum/ai_controller/insane/pink_possess//define AI controller
	lines_type = /datum/ai_behavior/say_line/insanity_desirous

/datum/ai_behavior/say_line/insanity_desirous
	lines = list(
				"It feels so good...",
				"They're in the way...",
				"I'm getting so close...",
				"I can't stop..."
				)

/datum/ai_controller/insane/pink_possess/SelectBehaviors(delta_time)//Selects pink shoes as the target
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return
	var/mob/living/simple_animal/hostile/abnormality/pink_shoes/shoes
	for(var/mob/living/simple_animal/hostile/abnormality/pink_shoes/M in GLOB.mob_living_list)
		if(!istype(M))
			continue
		shoes = M
	if (!shoes)
		return
	if(shoes.status_flags & GODMODE)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/roseate_move)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = shoes

/datum/ai_behavior/roseate_move//define AI behavior
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	var/list/current_path = list()

/datum/ai_behavior/roseate_move/perform(delta_time, datum/ai_controller/controller)//Paths the pancicked to pink shoes, causes runtimes if it's dead
	. = ..()
	var/walkspeed = 1
	var/mob/living/carbon/human/living_pawn = controller.pawn//the panicked
	if(IS_DEAD_OR_INCAP(living_pawn))//stop if the panicked is dead
		return
	var/mob/living/simple_animal/hostile/abnormality/pink_shoes/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!istype(target))
		finish_action(controller, FALSE)
		return
	if(!LAZYLEN(current_path))
		current_path = get_path_to(living_pawn, target, /turf/proc/Distance_cardinal, 0, 80)
		if(!current_path) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
	if(!ishuman(living_pawn))
		return
	walkspeed -= (max(0.95,((get_attribute_level(living_pawn, JUSTICE_ATTRIBUTE)) * 0.01)))//same behavior as red shoes
	addtimer(CALLBACK(src, .proc/Movement, controller), 1.25 SECONDS, TIMER_UNIQUE)
	if(isturf(target.loc) && living_pawn.Adjacent(target))
		finish_action(controller, TRUE)
		return

/datum/ai_behavior/roseate_move/proc/Movement(datum/ai_controller/controller)//Ditto
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/pink_shoes/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!target)
		if(living_pawn)//there's a runtime if you panic right next to it
			living_pawn.SanityLossEffect(JUSTICE_ATTRIBUTE)//switch to a murder panic
		return
	if(!LAZYLEN(current_path))
		living_pawn.SanityLossEffect(JUSTICE_ATTRIBUTE)//ditto
		return
	var/target_turf = current_path[1]
	step_towards(living_pawn, target_turf)
	current_path.Cut(1, 2)
	if(target)
		if(isturf(target.loc) && living_pawn.Adjacent(target))
			finish_action(controller, TRUE)
			return

/datum/ai_behavior/roseate_move/finish_action(datum/ai_controller/controller, succeeded)//When the panicked reach Pink Shoes
	. = ..()
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/obj/item/held = living_pawn.get_active_held_item()
	var/mob/living/simple_animal/hostile/abnormality/pink_shoes/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(succeeded)
		living_pawn.dropItemToGround(held)
		target.Assimilate(living_pawn)//breaches red shoes with target as the argument for user
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

//***Simple Mob Definition***//
/mob/living/simple_animal/hostile/pink_zombie
	name = "Pink Shoes Enchantee"
	desc = "A humanoid covered in pink ribbons that reeks of decay."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "pinkshoes_zombie"
	icon_living = "pinkshoes_zombie"
	icon_dead = ""//leave the corpse behind
	speak_emote = list("groans", "moans", "howls", "screeches", "grunts")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/pinkshoes/Pinkshoes_Attack.ogg'
	health = 250
	maxHealth = 250
	obj_damage = 300
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 10
	speed = 5
	move_to_delay = 5
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	density = TRUE
	var/mob/living/possessed_mob

/mob/living/simple_animal/hostile/pink_zombie/Initialize(loc, mob/living/H)//based on petrification code
	..()
	if(H)
		possessed_mob = H
		if(H.buckled)
			H.buckled.unbuckle_mob(H,force=1)
		H.forceMove(src)
		H.faction += "hostile"
		H.status_flags |= GODMODE
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/pink_zombie/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE

/mob/living/simple_animal/hostile/pink_zombie/death(gibbed)
	for(var/obj/O in src)
		O.forceMove(loc)
	if(possessed_mob)
		possessed_mob.status_flags &= ~GODMODE
		possessed_mob.forceMove(loc)
		possessed_mob.faction -= "hostile"
		possessed_mob = null
	return ..()

//***Ribbon Definition***//
/obj/structure/spreading/pink_ribbon
	gender = PLURAL
	name = "pink ribbons"
	desc = "A garish mass of pink ribbons."
	icon = 'icons/effects/effects.dmi'
	icon_state = "pinkribbons"
	anchored = TRUE
	density = FALSE
	can_buckle = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = FLAMMABLE
	max_integrity = 45//They're hard to break
	color = COLOR_PINK
	buckle_prevents_pull = TRUE
	last_expand = 0 //last world.time this weed expanded
	expand_cooldown = 1.5 SECONDS
	can_expand = TRUE
	var/list/static/ignore_typecache
	var/list/static/atom_remove_condition

/obj/structure/spreading/pink_ribbon/Initialize()//edit of snow white's vines
	. = ..()
	GLOB.ribbon_list += src
	if(!atom_remove_condition)
		atom_remove_condition = typecacheof(list(
			/obj/projectile/ego_bullet/ego_match,
			/mob/living/simple_animal/hostile/abnormality/helper,))
	if(!blacklisted_turfs)
		blacklisted_turfs = typecacheof(list(
			/turf/open/space,
			/turf/open/chasm,
			/turf/open/lava,
			/turf/open/openspace))
	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/mob/dead,
			/mob/living/simple_animal/hostile/abnormality/pink_shoes,
			/mob/living/simple_animal/hostile/pink_zombie))

/obj/structure/spreading/pink_ribbon/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	VineEffect(user)

/obj/structure/spreading/pink_ribbon/attack_hand(mob/living/carbon/human/H)
	. = ..()
	if(H.a_intent == INTENT_HARM)
		VineEffect(H)

/obj/structure/spreading/pink_ribbon/attack_animal(mob/living/simple_animal/M)
	. = ..()
	VineEffect(M)

/obj/structure/spreading/pink_ribbon/Crossed(atom/movable/AM)
	. = ..()
	if(is_type_in_typecache(AM, ignore_typecache))// Don't want the traps triggered by sparks, ghosts or projectiles.
		return
	if(!isliving(AM))
		return
	if(prob(5))
		VineEffect(AM)

/obj/structure/spreading/pink_ribbon/proc/VineEffect(mob/living/L)
	if(is_type_in_typecache(L, ignore_typecache))
		return
	var/temperance_value
	var/mob/living/carbon/human/H = L
	if(L.has_status_effect(/datum/status_effect/stacking/urge))
		return
	if(ishuman(H))//also assimilates fortitude panics
		var/obj/item/clothing/suit/armor/ego_gear/EQ = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)//copies all resistances from worn E.G.O
		if(EQ)
			if(EQ.armor[WHITE_DAMAGE] == 100)
				return
		temperance_value = (get_attribute_level(L, TEMPERANCE_ATTRIBUTE))
		if(prob(40 - (temperance_value / 5)))//at 180 temperance this is only 4%
			entangle_mob(L)
	else if(prob(30))//simple mobs
		entangle_mob(L)

/obj/structure/spreading/pink_ribbon/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message("<span class='notice'>[user] tries to pull [M] free of the [src]!</span>",\
				"<span class='notice'>[user] is trying to untie the [src] around you!</span>")
			if(!do_after(user, 20, target = src))
				if(M?.buckled)
					M.visible_message("<span class='notice'>[user] fails to free [M] from the [src]!</span>",\
					"<span class='notice'>[user] fails to pull you away from the [src].</span>")
				return
		else
			M.visible_message("<span class='warning'>[M] yanks and tears at the [src]!</span>",\
			"<span class='notice'>You try to escape the [src]!</span>")
			if(!do_after(M, 10, target = src))
				to_chat(M, "Put me on.</span>")
				return
		if(!M.buckled)
			return
		Release_Mob(M)
		update_icon()

/obj/structure/spreading/pink_ribbon/proc/Release_Mob(mob/living/M)
	unbuckle_mob(M,force = 1)

/obj/structure/spreading/pink_ribbon/proc/entangle_mob(mob/living/target)//verygay station vine code
	if(!target) //How much of this is actually necessary, I wonder
		return
	if(target.stat == DEAD)
		if(!ishuman(target))//ignore dead simple mobs
			return
		target.apply_status_effect(STATUS_EFFECT_URGE)
		return
	Apply_Urge(target)
	to_chat(target, "<span class='danger'>The ribbons [pick("wind", "tangle", "tighten")] around you!</span>")
	if(Grab_Mob(target))
		return
	buckle_mob(target)

/obj/structure/spreading/pink_ribbon/proc/Grab_Mob(mob/living/target)
	if(!target || !Adjacent(target))
		return
	target.forceMove(get_turf(src))
	buckle_mob(target)
	src.visible_message("<span class='danger'>The [src] lash out and drag \the [target] in!</span>")

/obj/structure/spreading/pink_ribbon/proc/Apply_Urge(mob/living/L)
	var/datum/status_effect/stacking/urge/G = L.has_status_effect(/datum/status_effect/stacking/urge)
	if(!G)//applying the buff for the first time (it lasts for one minute)
		to_chat(L, "<span class='warning'>The [name] tighten around you.</span>")
		L.apply_status_effect(STATUS_EFFECT_URGE)
	else//if the employee already has the buff
		to_chat(L, "<span class='warning'>The [name] around your body tighten.</span>")
		G.add_stacks(1)
		G.refresh()

/obj/structure/spreading/pink_ribbon/dense
	gender = PLURAL
	name = "dense pink ribbons"
	desc = "A massive pile of ribbons."
	icon_state = "pinkribbons3"
	max_integrity = 1000//They're harder to break
	can_expand = FALSE

/obj/structure/spreading/pink_ribbon/dense/Initialize()
	for (var/turf/T in view(2, src))
		if(!isturf(loc) || isspaceturf(T))
			return
		if(locate(/obj/structure/spreading/pink_ribbon) in get_turf(T))
			return
		new /obj/structure/spreading/pink_ribbon(T)
	..()

//*** Cushion***//
/obj/structure/pinkshoes_cushion
	name = "pink cushion"
	desc = "A dainty little cushion."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "pinkshoes_cushion"
	anchored = TRUE
	density = FALSE
	layer = BELOW_MOB_LAYER//above the ribbons but beneath the shoes
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE

#undef STATUS_EFFECT_URGE
