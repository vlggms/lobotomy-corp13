#define STATUS_EFFECT_URGE /datum/status_effect/stacking/urge
#define STATUS_EFFECT_PINKSHOES /datum/status_effect/display/pinkshoes
GLOBAL_LIST_EMPTY(ribbon_list)
/mob/living/simple_animal/hostile/abnormality/pink_shoes
	name = "Pink Shoes"
	desc = "A pair of girly pink shoes."
	health = 500
	maxHealth = 500
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "pinkshoes"
	icon_living = "pinkshoes_breach"
	icon_dead = "pinkshoes_egg"
	core_icon = "pinkshoes_egg"
	portrait = "pink_shoes"
	light_color = "#EA19AA"
	light_range = 5
	light_power = 10
	can_breach = TRUE
	can_buckle = TRUE
	threat_level = HE_LEVEL
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = list(50, 50, 45, 50, 60),
						ABNORMALITY_WORK_ATTACHMENT = list(80, 50, 50, 40, 30),
						ABNORMALITY_WORK_REPRESSION = list(50, 60, 50, 55, 60)
						)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE
	del_on_death = FALSE
	death_message = "falls, leaving tattered ribbons."
	attack_sound = 'sound/abnormalities/pinkshoes/Pinkshoes_Attack.ogg'
	melee_damage_lower = 6
	melee_damage_upper = 8
	melee_damage_type = WHITE_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/roseate,
		/datum/ego_datum/armor/roseate
		)
	gift_type =  /datum/ego_gifts/roseate_desire
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "Strips of pink ribbons float this way. <br>\
		A voice travels between the fluttering ribbons. <br>\
		\"What is your desire?\" <br>\"Put me on.\" <br>\
		\"I'll carry you wherever you wish to go.\" <br>\
		The suggestions are incredibly suspicious, but for some reason, you are struggling to do decide what do do. <br>What do you say?"
	observation_choices = list(
		"Put on the ribbons" = list(FALSE, "Oh, yeah... This feels good. <br>The ribbons magically turn into shiny pairs of shoes.  <br>Now you can go wherever you want. <br>Probably."),
		"Refuse" = list(TRUE, "\"Snap out of it! It's all a lie!\" <br>A haggard employee manages to stop you at the last second. <br>Thanks to that warning, you avoided the desire-laden ribbons."),
	)

	ranged = TRUE
	environment_smash = FALSE//this stops it from smashing its own ribbons when breaching independently
	minimum_distance = 1
	attack_same = TRUE
	var/mutable_appearance/breach_icon
	var/mob/living/possessee
	var/list/dense_ribbon_list = list()
	var/static/list/ribbon_list = list()
	var/mob/living/simple_animal/hostile/grown_strong/special_possessee

//*** Simple Mob Procs ***//
/mob/living/simple_animal/hostile/abnormality/pink_shoes/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return
	for(var/obj/structure/spreading/pink_ribbon/R in range(10, get_turf(src)))
		if(R.last_expand <= world.time)
			R.expand()
	if(locate(/obj/structure/spreading/pink_ribbon) in get_turf(src))
		return
	new /obj/structure/spreading/pink_ribbon(get_turf(src))

/mob/living/simple_animal/hostile/abnormality/pink_shoes/death()
	density = FALSE
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Binding.ogg', 100, 0)
	for(var/mob/living/carbon/human/H in src)
		H.forceMove(loc)
		H.SanityLossEffect(JUSTICE_ATTRIBUTE)
	if(possessee)//current host
		possessee.status_flags &= ~GODMODE
		possessee.forceMove(loc)
		possessee.faction -= "hostile"
		possessee = null
	appearance = initial(appearance)
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	pixel_x = -16
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/Destroy()
	CutDenseRibbons()
	CutRibbons()
	return ..()

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

/mob/living/simple_animal/hostile/abnormality/pink_shoes/CanAttack(atom/the_target)
	if(ishuman(the_target))
		var/mob/living/carbon/human/L = the_target
		if(L.sanity_lost && L.stat != DEAD)
			if(HAS_AI_CONTROLLER_TYPE(L, /datum/ai_controller/insane/pink_possess))
				return FALSE
	return ..()


/mob/living/simple_animal/hostile/abnormality/pink_shoes/AttackingTarget(atom/attacked_target)
	if(possessee)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.sanity_lost)
				..()
				LoseTarget()
				Convert(H)
				return
		return ..()
	if(!isliving(target))
		return
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/OpenFire()
	if(possessee)//if it's already possessing someone
		return
	..()
	RibbonAttack(target)
	return

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/RibbonAttack(target)//ranged attack attack
	playsound(get_turf(target), 'sound/abnormalities/pinkshoes/Pinkshoes_Binding.ogg', 75, 0, 5)
	var/obj/effect/root/pinkshoes/R = new(get_turf(target))
	R.master = src

//*** Work Mechanics ***//

/mob/living/simple_animal/hostile/abnormality/pink_shoes/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/pink_shoes/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(1)
		return
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 || (user.sanity_lost))
		Apply_Urge(user)
		user.adjustSanityLoss(500)
		user.visible_message(span_userdanger("[user] blankly stumbles towards the Pink Shoes. Now [p_theyre()] reaching out their hand to take the shoes."), span_userdanger("What lovely shoes..."))

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/Apply_Urge(mob/living/carbon/human/user)
	user.apply_status_effect(STATUS_EFFECT_URGE)
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Attack.ogg', 100, 1)
	return

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/CutDenseRibbons()
	for(var/obj/structure/dense_ribbon/R in dense_ribbon_list)
		var/del_time = rand(4,10)
		animate(R, alpha = 0, time = del_time SECONDS)
		QDEL_IN(R, del_time SECONDS)
	dense_ribbon_list.Cut()
	return

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/CutRibbons()
	for(var/obj/structure/spreading/pink_ribbon/R in ribbon_list)
		R.can_expand = FALSE
		var/del_time = rand(4,10)
		animate(R, alpha = 0, time = del_time SECONDS)
		QDEL_IN(R, del_time SECONDS)
	ribbon_list.Cut()
	return

//***Breach Mechanics***//
//normal BreachEffect stuff
/mob/living/simple_animal/hostile/abnormality/pink_shoes/BreachEffect(mob/living/carbon/human/user)
	..()
	var/mob/living/carbon/human/H = user
	if(ishuman(H) && H.sanity_lost)//let them grab it instead
		light_range = 2
		update_light()
		return
	if(!possessee)//normal breach
		icon = 'ModularTegustation/Teguicons/32x96.dmi'
		icon_state = "pinkshoes_breach"
		var/turf/T = pick(GLOB.xeno_spawn)
		forceMove(T)
		for(var/turf/open/T2 in oview(1, T))
			var/obj/structure/dense_ribbon/R = new(get_turf(T2))
			dense_ribbon_list += R
		for(var/turf/open/T3 in view(2, T))
			if(!isturf(T3) || isspaceturf(T3))
				continue
			if(locate(/obj/structure/dense_ribbon) in T3)
				continue
			new /obj/structure/spreading/pink_ribbon(get_turf(T3))
	light_range = 2
	update_light()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/Assimilate(mob/living/carbon/user)
	if(possessee)//if it's already possessing someone
		return
	if(stat == DEAD || user.stat == DEAD || user == src)
		return
	if(user.status_flags & GODMODE)
		return FALSE
	possessee = user
	ranged = FALSE
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	attack_same = FALSE
	var/mob/living/carbon/human/H = user
	QDEL_NULL(user.ai_controller)//stops it from running off
	if(ishuman(H) && (H.sanity_lost))
		user.SetImmobilized(100)
		user.forceMove(src)
		playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Breach.ogg', 50, 1)
		breach_icon = mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "pinkshoes_breach", -ABOVE_BODY_FRONT_LAYER)
		name = user.name
		appearance = user.appearance
		gender = user.gender
		desc = "[user.name] is making obscene gestures, covered in pink ribbons. Does [p_they()] normally wear shoes like those?"
		add_overlay(breach_icon)
		cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "panicked", -ABOVE_MOB_LAYER))
		BreachEffect(user)
		toggle_ai(AI_ON)
		CutDenseRibbons()
		return TRUE

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/AssimilateAnimal(mob/living/simple_animal/hostile/user)
	if(possessee)//prevents stacking bonuses
		return
	if(stat == DEAD || user.stat == DEAD)
		return
	if(user.status_flags & GODMODE)
		return FALSE
	toggle_ai(AI_OFF)
	special_possessee = user
	if((istype(special_possessee)))//Is the user a YMBS minion?
		special_possessee.icon_state = "pinkshoes_strong"
		special_possessee.update_icon()
		special_possessee.gear = 10
		special_possessee.UpdateGear()
		special_possessee.gear_health = 1//Sets the gear to 10 and prevents surgery from triggering more than once. We'll give it more HP to compensate on 257
		special_possessee.name = pick("Clippity-cloppity", "Tap-tap", "Twinkle")+pick("? Tap away!", "? Thoroughly?!", "? Sprinkle Spinny!?")
	else
		RibbonVisual(user)
	user.maxHealth += 500
	user.melee_damage_lower += 3
	user.melee_damage_upper += 4
	user.revive(full_heal = TRUE, admin_revive = FALSE)
	user.desc += "Wait, are those pink shoes?"
	user.faction = faction
	forceMove(user)
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Breach.ogg', 50, 1)
	ranged = FALSE
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	attack_same = FALSE
	user.apply_status_effect(STATUS_EFFECT_PINKSHOES)
	CutDenseRibbons()

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/RibbonVisual(mob/living/simple_animal/hostile/user)
	var/icon/result_icon = new('ModularTegustation/Teguicons/128x128.dmi')
	var/icon/mobicon = icon(user.icon, user.icon_state)
	var/icon_width = mobicon.Width()
	var/icon_height = mobicon.Height()
	var/icon_dirs = list(NORTH, SOUTH, EAST, WEST)
	for(var/i = 1, i <= LAZYLEN(icon_dirs), i++)
		if(!user.dir == icon_dirs[i])
			continue
		var/icon/I = icon(user.icon, user.icon_state, icon_dirs[i])
		I = getRibbonIcon(I)//apply the ribbons onto the user's sprite silhouette
		result_icon.Insert(I,user.icon_state,icon_dirs[i])//plug the individual directions of I onto a single icon state
	result_icon.Crop(user.pixel_x, user.pixel_y, icon_width, icon_height)//crops it to be the same size!
	result_icon.Shift(EAST, user.pixel_x, wrap = 0)//these two will make adjustments for pixel offets
	result_icon.Shift(NORTH, user.pixel_y, wrap = 0)
	user.add_overlay(mutable_appearance(result_icon, -MUTATIONS_LAYER))//apply the final image to the mob

/mob/living/simple_animal/hostile/abnormality/pink_shoes/proc/Convert(mob/living/target)
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Binding.ogg', 100, 1)
	var/mob/living/simple_animal/hostile/pink_zombie/Z = new(get_turf(target), target)
	Z.name = target.name

//this is essentially GetStaticIcon() with a different icon.
/proc/getRibbonIcon(icon/A, safety = TRUE)
	var/icon/flat_icon = safety ? A : new(A)
	flat_icon.Blend(rgb(255,255,255))
	flat_icon.BecomeAlphaMask()
	var/icon/static_icon = icon('ModularTegustation/Teguicons/128x128.dmi', "pinkshoes_overlay")
	static_icon.AddAlphaMask(flat_icon)
	return static_icon

/datum/status_effect/display/pinkshoes//shoe buff icon
	id = "pinkshoes"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "pink_shoe"

//***Debuff Definition***/
//Urge
/datum/status_effect/stacking/urge
	id = "urge"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 15 SECONDS//Lasts for fifteen seconds
	max_stacks = 5
	stacks = 1
	stack_decay = 0
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/urge
	consumed_on_threshold = FALSE
	var/prud_mod = 0
	var/temp_mod = 0

/atom/movable/screen/alert/status_effect/urge
	name = "Urge"
	desc = "The knot of desires must be undone."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "urge"

/datum/status_effect/stacking/urge/refresh()//applies funny red text every time it gets reapplied
	..()
	var/mob/living/carbon/human/H = owner
	switch(stacks)
		if(1)
			return
		if(2)
			to_chat(owner, span_userdanger("Put me on."))
			ApplyBuff()
		if(3)
			to_chat(owner, span_userdanger("I'll carry you wherever you wish to go.."))
			ApplyBuff()
		if(4)
			to_chat(owner, span_userdanger("For some reason, you're struggling to decide what to do...."))
			ApplyBuff()
		if(5)
			duration += 30 SECONDS//die
			if(!istype(owner, H))
				return
			if(prud_mod > -25)
				ApplyBuff()

/datum/status_effect/stacking/urge/proc/ApplyBuff()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(owner))
		return
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -5)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -10)
	prud_mod -= 5
	temp_mod -= 10

/datum/status_effect/stacking/urge/on_apply()
	stacks += 1
	var/mob/living/carbon/human/status_holder = owner
	if(!ishuman(owner))
		return
	ApplyBuff()
	to_chat(owner, "A voice travels between the fluttering ribbons. \
	What is your desire?")
	if(status_holder.sanity_lost)
		qdel(src)
		return
	return ..()

/datum/status_effect/stacking/urge/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(owner.stat == DEAD)//dead players turn into zombies
		Convert(owner)
		return
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -prud_mod)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -temp_mod)
	if(H.sanity_lost)
		H.apply_status_effect(/datum/status_effect/panicked_type/desirous)
		QDEL_NULL(owner.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/pink_possess
		H.InitializeAIController()
	return ..()

/datum/status_effect/stacking/urge/tick()
	..()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(owner))
		owner.adjustBruteLoss(stacks * -1)//heals abnormalities
		return
	H.apply_damage(stacks * 0.5, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
	if(H.sanity_lost)
		qdel(src)

/datum/status_effect/stacking/urge/proc/Convert(mob/living/target)//Turns human corpses into pink shoes enchantees when dead with urge
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Binding.ogg', 100, 1)
	var/mob/living/simple_animal/hostile/pink_zombie/Z = new(get_turf(target), target)
	Z.name = target.name

/datum/status_effect/panicked_type/desirous
	icon = "pinkshoes_panic"

//***Custom Panic Definiton***
/datum/ai_controller/insane/pink_possess//define AI controller
	lines_type = /datum/ai_behavior/say_line/insanity_desirous

/datum/ai_behavior/say_line/insanity_desirous
	lines = list(
				"It feels so good...",
				"They're in the way...",
				"I'm getting so close...",
				"I can't stop...",
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
	if(!shoes.possessee)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/roseate_move)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = shoes
	else
		var/mob/living/carbon/human/H = pawn
		H.SanityLossEffect(JUSTICE_ATTRIBUTE)
		return

/datum/ai_behavior/roseate_move//define AI behavior
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	var/list/current_path = list()

/datum/ai_behavior/roseate_move/perform(delta_time, datum/ai_controller/controller)//Paths the pancicked to pink shoes
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
		if(!current_path)
			finish_action(controller, FALSE)
			return
	if(!ishuman(living_pawn))
		return
	walkspeed -= (max(0.95,((get_attribute_level(living_pawn, JUSTICE_ATTRIBUTE)) * 0.01)))//same behavior as red shoes
	addtimer(CALLBACK(src, PROC_REF(Movement), controller), walkspeed SECONDS, TIMER_UNIQUE)
	if(isturf(target.loc) && living_pawn.Adjacent(target))
		finish_action(controller, TRUE)
		return

/datum/ai_behavior/roseate_move/proc/Movement(datum/ai_controller/controller)
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/pink_shoes/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!target)
		if(living_pawn)
			living_pawn.SanityLossEffect(JUSTICE_ATTRIBUTE)//switch to a justice panic
		return
	if(!LAZYLEN(current_path))
		living_pawn.SanityLossEffect(JUSTICE_ATTRIBUTE)
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
		target.Assimilate(living_pawn)
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
	health = 50
	maxHealth = 50
	obj_damage = 300
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 4
	melee_damage_upper = 6
	speed = 5
	move_to_delay = 5
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	density = TRUE
	var/mob/living/possessed_mob

/mob/living/simple_animal/hostile/pink_zombie/Initialize(loc, mob/living/H)
	..()
	if(!IsCombatMap())
		icon_state = "pinkshoes_zombie2"
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
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = FLAMMABLE
	max_integrity = 45
	armor = list(
		MELEE = 0,
		BULLET = 0,
		FIRE = -50,
		RED_DAMAGE = -30,
		WHITE_DAMAGE = 40,
		BLACK_DAMAGE = 20,
		PALE_DAMAGE = -60,
	)
	color = COLOR_PINK
	last_expand = 0 //last world.time this weed expanded
	expand_cooldown = 1.5 SECONDS
	can_expand = TRUE
	var/static/mob/living/simple_animal/hostile/abnormality/pink_shoes/connected_abno
	var/list/static/ignore_typecache
	var/list/static/atom_remove_condition

/obj/structure/spreading/pink_ribbon/Initialize()
	. = ..()
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/pink_shoes) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.ribbon_list += src

	if(!atom_remove_condition)
		atom_remove_condition = typecacheof(list(
			/obj/projectile/ego_bullet/ego_match,
			/obj/projectile/ego_bullet/ego_warring2,
			/obj/effect/decal/cleanable/wrath_acid,
			/mob/living/simple_animal/hostile/abnormality/helper,
			/mob/living/simple_animal/hostile/abnormality/greed_king,
			/mob/living/simple_animal/hostile/abnormality/dimensional_refraction,
			/mob/living/simple_animal/hostile/abnormality/wrath_servant,
			/obj/vehicle/sealed/mecha,
			/obj/structure/spreading/apple_vine,
			/obj/structure/meatfloor,
			))
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
			/mob/living/simple_animal/hostile/pink_zombie,
			))

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
	if(prob(10))
		VineEffect(AM)

/obj/structure/spreading/pink_ribbon/Destroy()
	if(connected_abno)
		connected_abno.ribbon_list -= src
	return ..()

/obj/structure/spreading/pink_ribbon/proc/VineEffect(mob/living/L)
	if(is_type_in_typecache(L, ignore_typecache))
		return
	var/temperance_value
	var/mob/living/carbon/human/H = L
	if(ishuman(H))
		if(H.sanity_lost)
			return
		temperance_value = (get_attribute_level(L, TEMPERANCE_ATTRIBUTE))
		if(prob(60 - (temperance_value / 2)))//at 120 temperance this is 0%
			entangle_mob(L)

/obj/structure/spreading/pink_ribbon/proc/entangle_mob(mob/living/target)
	if(!target)
		return
	if(target.stat == DEAD)
		if(!ishuman(target))
			return
		target.apply_status_effect(STATUS_EFFECT_URGE)
		return
	playsound(src, 'sound/abnormalities/pinkshoes/Pinkshoes_Binding.ogg', 30, 0)
	Apply_Urge(target)
	to_chat(target, span_danger("The ribbons [pick("wind", "tangle", "tighten")] around you!"))
	new /obj/effect/temp_visual/ribbon_buckle(get_turf(target))
	target.SetImmobilized(20)

/obj/structure/spreading/pink_ribbon/proc/Apply_Urge(mob/living/L)
	var/datum/status_effect/stacking/urge/G = L.has_status_effect(/datum/status_effect/stacking/urge)
	if(!G)//applying the buff for the first time (it lasts for one minute)
		to_chat(L, span_warning("The [name] tighten around you."))
		L.apply_status_effect(STATUS_EFFECT_URGE)
	else//if the employee already has the buff
		to_chat(L, span_warning("The [name] around your body tighten."))
		G.refresh()
		G.add_stacks(1)

/obj/effect/temp_visual/ribbon_buckle
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "ribbonbuckle"
	duration = 20

/obj/structure/dense_ribbon
	gender = PLURAL
	name = "dense pink ribbons"
	desc = "A massive pile of ribbons."
	icon = 'icons/effects/effects.dmi'
	icon_state = "pinkribbons2"
	pass_flags_self = PASSTABLE | LETPASSTHROW
	density = FALSE
	anchored = TRUE
	max_integrity = 1000//They're harder to break

/obj/structure/dense_ribbon/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(!H.sanity_lost)
			H.SetImmobilized(50)
			to_chat(H, span_warning("The [name] tightly coil around you!"))
			return
	return

//Attacks
/obj/effect/temp_visual/ribbon_attack
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "ribbongrab"
	duration = 10

/obj/effect/root/pinkshoes
	name = "root"
	desc = "A target warning you of incoming pain"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "ribbonwarn"
	color = COLOR_PINK
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/root_damage = 5 //White Damage
	var/mob/living/simple_animal/hostile/abnormality/pink_shoes/master
	layer = POINT_LAYER

/obj/effect/root/pinkshoes/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 0.5 SECONDS)

/obj/effect/root/pinkshoes/proc/explode()
	playsound(get_turf(src), 'sound/abnormalities/ebonyqueen/attack.ogg', 50, 0, 8)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(0, target_turf))
		new /obj/effect/temp_visual/ribbon_attack(T)
		for(var/mob/living/L in T)
			if(ishuman(L))
				L.apply_damage(root_damage, WHITE_DAMAGE, null, spread_damage = TRUE)
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost) //drop aggro on panicked people
					master.Apply_Urge(H)
					master.LoseTarget(H)
				qdel(src)
				return
			master.LoseTarget(L)
			master.AssimilateAnimal(L)
	qdel(src)

//*** Cushion ***//
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
#undef STATUS_EFFECT_PINKSHOES
