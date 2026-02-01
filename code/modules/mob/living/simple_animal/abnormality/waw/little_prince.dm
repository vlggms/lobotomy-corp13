/mob/living/simple_animal/hostile/abnormality/little_prince
	name = "\proper The Little Prince"
	desc = "An abnormality taking the form of a tall mushroom-like entity of dark blue and purple colors. \
	Dark blue hands hangs by its branches on a string"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "little_prince"
	portrait = "little_prince"
	health = 1500
	maxHealth = 1500
	damage_coeff = list(RED_DAMAGE = 1.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.1, PALE_DAMAGE = 1.5)
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(25, 30, 35, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 50, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 50, 50, 55),
	)
	work_damage_upper = 4
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy
	max_boxes = 24
	start_qliphoth = 2

	ego_list = list(
		/datum/ego_datum/weapon/spore,
		/datum/ego_datum/armor/spore,
	)
	gift_type = /datum/ego_gifts/spore
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "We can see things that others cannot. <br>\
		I have come across 15 billion light years to meet you. <br>\
		However, a butterfly can only fly as high in the sky as the sun warms. <br>\
		It does not know that it will crumble before it can reach the stars. <br>It fell from the sky and crushed into the ground."
	observation_choices = list(
		"Become its friend" = list(TRUE, "My voice can reach you unlike others. <br>\
			Come to me, step by step. <br>You will reach the stars if those steps continue."),
		"Do nothing" = list(FALSE, "Many who tried to reach me got lost. <br>\
			Perhaps, we are standing on parallel lines. <br>Perhaps, we were looking at something that can never be reached."),
	)

	var/insight_count = 0
	var/non_insight_count = 0
	var/list/once = list()
	var/list/twice = list()
	var/list/hypnotized = list()
	var/list/fungus_list = list()
	var/user_check = FALSE
	var/mutable_appearance/spore_icon
	base_pixel_x = -16
	pixel_x = -16

/mob/living/simple_animal/hostile/abnormality/little_prince/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/little_prince/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/little_prince/Life()
	..()
	for(var/mob/living/carbon/human/user in hypnotized)
		if ((user.stat == DEAD) || !(user.sanity_lost))
			QDEL_NULL(user.ai_controller)
			user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "spore_hypno", -HALO_LAYER))
			hypnotized -= user
	if(LAZYLEN(hypnotized))
		icon_state = "little_princea"
	else
		icon_state = "little_prince"
	return

/mob/living/simple_animal/hostile/abnormality/little_prince/proc/Hypno(mob/living/carbon/human/user)
	if (!(user.sanity_lost))
		playsound(get_turf(user), 'sound/abnormalities/littleprince/Prince_Active.ogg', 50, 0, 2)
		user.deal_damage(user.maxSanity, WHITE_DAMAGE)
		if (!(user.sanity_lost))
			//Check Sanity twice to make sure you're actually insane
			twice -= user
			to_chat(user, span_userdanger("You see mushrooms growing all over your body, and you tear them off!"))
			return
	to_chat(user, span_userdanger("You see mushrooms growing all over your body!"))
	user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "spore_hypno", -HALO_LAYER))
	QDEL_NULL(user.ai_controller)
	user.ai_controller = /datum/ai_controller/insane/hypno
	user.InitializeAIController()
	hypnotized += user
	return

//it was easier for me to keep track of this here
/mob/living/simple_animal/hostile/abnormality/little_prince/proc/PrinceDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	playsound(get_turf(source), 'sound/abnormalities/bee/spores.ogg', 50, 1, 5)
	for(var/obj/effect/prince_mushrooms/P in fungus_list)
		if(!P.active)
			P.Activate()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/little_prince/proc/Fungify(mob/living/carbon/human/user)
	once -= user
	twice -= user
	hypnotized -= user
	user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "spore_hypno", -HALO_LAYER))
	var/turf/T = get_turf(user)
	user.visible_message(span_danger("Mushrooms rapidly grow all over [user]'s body, forming a giant mass!"))
	user.emote("scream")
	user.gib()
	var /mob/living/simple_animal/hostile/little_prince_1/S = new(T)
	S.connected_abno = src
	RegisterSignal(S, COMSIG_LIVING_DEATH, PROC_REF(PrinceDeath))
	return

/mob/living/simple_animal/hostile/abnormality/little_prince/proc/OnAbnoWork(datum/source, datum/abnormality/abno_datum, mob/user, work_type)
	SIGNAL_HANDLER
	if (abno_datum == datum_reference) // They worked on us!
		return FALSE
	if (user in twice)
		once += user
		twice -= user
		return TRUE
	if (user in once)
		once -= user
		UnregisterSignal(user, COMSIG_WORK_STARTED)
		return FALSE
	return TRUE

//work stuff
/mob/living/simple_animal/hostile/abnormality/little_prince/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	user_check = FALSE

	//checks how many times they worked on prince
	if (user in once)
		once -= user
		twice += user
	if (!(user in once) && !(user in twice))
		once += user
		RegisterSignal(user, COMSIG_WORK_STARTED, PROC_REF(OnAbnoWork))

	//insight work checks
	if (work_type == ABNORMALITY_WORK_INSIGHT)
		insight_count++
		non_insight_count = 0
	else
		insight_count = 0
		non_insight_count++

	if (insight_count == 2)
		insight_count = 0
		datum_reference.qliphoth_change(1)
	if (non_insight_count == 3)
		non_insight_count = 0
		datum_reference.qliphoth_change(-1)

	//Transforms the agent instead of doing hypno
	if (datum_reference.qliphoth_meter == 0)
		datum_reference.qliphoth_change(2)
		UnregisterSignal(user, COMSIG_WORK_STARTED)
		Fungify(user)
	return

/mob/living/simple_animal/hostile/abnormality/little_prince/AttemptWork(mob/living/carbon/human/user, work_type)
	if ((user in twice) || (user in hypnotized))
		datum_reference.qliphoth_change(2)
		UnregisterSignal(user, COMSIG_WORK_STARTED)
		Fungify(user)
		return FALSE
	if (user)
		user_check = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/little_prince/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/little_prince/ZeroQliphoth(mob/living/carbon/human/user)
	if (!(user_check))
		datum_reference.qliphoth_change(2)
		var/list/potential_hypno = list()
		for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
			if(H.stat >= HARD_CRIT || H.sanity_lost || z != H.z) // Dead or in hard crit, insane, or on a different Z level.
				continue
			potential_hypno += H
		Hypno(pick(potential_hypno))
	return

/mob/living/simple_animal/hostile/abnormality/little_prince/Destroy()
	for(var/obj/effect/prince_mushrooms/P in fungus_list)
		P.connected_abno = null
		P.Despawn()
	fungus_list.Cut()
	return ..()

/* Prince-01 */
/mob/living/simple_animal/hostile/little_prince_1
	name = "Little Prince-1"
	desc = "A shambling giant mushroom chunk."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "little_princeminion"
	icon_living = "little_princeminion"
	icon_dead = "little_princeminion"
	base_pixel_x = -16
	pixel_x = -16
	health = 545
	maxHealth = 545
	move_to_delay = 3
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.1, PALE_DAMAGE = 1.5)
	melee_damage_lower = 15
	melee_damage_upper = 20		//slow melee and has nothing else.
	stat_attack = HARD_CRIT
	death_sound = 'sound/abnormalities/littleprince/Prince_Death.ogg'
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	attack_sound = 'sound/abnormalities/littleprince/Prince_Attack.ogg'
	death_message = "shakes violently."
	can_patrol = TRUE
	var/mob/living/simple_animal/hostile/abnormality/little_prince/connected_abno

/mob/living/simple_animal/hostile/little_prince_1/Move()
	. = ..()
	for(var/turf/open/T in view(src, 1))
		if(!isturf(T) || isspaceturf(T))
			continue
		if(locate(/obj/effect/prince_mushrooms) in T)
			continue
		if(locate(/turf/open/water/deep) in T)
			continue
		if(prob(15))
			var/obj/effect/prince_mushrooms/P = new(T)
			if(connected_abno)
				P.connected_abno = connected_abno
				P.connected_abno.fungus_list += P
			else
				P.Activate()

/mob/living/simple_animal/hostile/little_prince_1/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/bee/birth.ogg', 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/little_prince_1/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()


/obj/effect/prince_mushrooms
	name = "fungus"
	desc = "A pile of blue and purple mushrooms growing from the floor."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "prince_fungus"
	layer = TURF_LAYER
	anchored = TRUE
	base_pixel_x = -8
	pixel_x = -8
	base_pixel_y = -8
	pixel_y = -8
	var/active = FALSE
	var/damaging = FALSE
	var/fungus_turf_check_time = 2 SECONDS
	var/despawning = FALSE
	var/mob/living/simple_animal/hostile/abnormality/little_prince/connected_abno

/obj/effect/prince_mushrooms/Initialize()
	. = ..()
	//Might as well have some randomness
	setDir(pick(NORTH, SOUTH, EAST, WEST))
	var/x_rand = rand(-2,2)
	var/y_rand = rand(-2,2)
	base_pixel_x += x_rand
	pixel_x += x_rand
	base_pixel_y += y_rand
	pixel_y += y_rand
	alpha = 0
	var/matrix/init_transform = transform
	transform *= 0.1
	animate(src, alpha = 255, transform = init_transform, time = 5 + rand(0,5))
	color = "#666666"

/obj/effect/prince_mushrooms/Crossed(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	if(!active || despawning)
		return
	if(!damaging)
		damaging = TRUE
		Check()

/obj/effect/prince_mushrooms/proc/Check()
	if(!active || despawning)
		return
	var/dealt_damage = FALSE
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(!H)
			continue
		if( H.stat != DEAD)
			DoDamage(H)
			dealt_damage = TRUE
	if(!dealt_damage)
		damaging = FALSE
		return
	addtimer(CALLBACK(src, PROC_REF(Check)), fungus_turf_check_time)

//The Damage Proc
/obj/effect/prince_mushrooms/proc/DoDamage(mob/living/carbon/human/H)
	H.deal_damage(rand(2, 5), WHITE_DAMAGE)
	to_chat(H, span_warning("You feel something weird touching your skin..."))
	if (H.sanity_lost && connected_abno)
		connected_abno.Hypno(H)

/obj/effect/prince_mushrooms/proc/Activate()
	active = TRUE
	color = "#FFFFFF"
	if(connected_abno)
		addtimer(CALLBACK(src, PROC_REF(Despawn)), 2 MINUTES)
		return
	addtimer(CALLBACK(src, PROC_REF(Despawn)), 30 SECONDS)

/obj/effect/prince_mushrooms/proc/Despawn()
	var/despawn_time = rand(5, 10)
	despawning = TRUE
	animate(src, alpha = 0, transform = transform, time = despawn_time)
	QDEL_IN(src, despawn_time)

/obj/effect/prince_mushrooms/Destroy()
	if(connected_abno)
		connected_abno.fungus_list -= src
	return ..()

//AI taken from Apoc
/datum/ai_controller/insane/hypno
	lines_type = /datum/ai_behavior/say_line/insanity_hypno

/datum/ai_behavior/say_line/insanity_hypno
	lines = list(
		"I'm coming...",
		"I have to go...",
		"It's calling for me...",
		"We'll finally be together...",
	)

/datum/ai_controller/insane/hypno/SelectBehaviors(delta_time)
	..()
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return

	current_behaviors += GET_AI_BEHAVIOR(lines_type)

	var/mob/living/simple_animal/hostile/abnormality/little_prince/mushy
	for(var/mob/living/simple_animal/hostile/abnormality/little_prince/M in GLOB.mob_living_list)
		if(!istype(M))
			continue
		mushy = M
	if(mushy)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/hypno_move)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = mushy

/datum/ai_controller/insane/hypno/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(DT_PROB(30, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	if(DT_PROB(25, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

/datum/ai_behavior/hypno_move
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	var/list/current_path = list()

/datum/ai_behavior/hypno_move/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/carbon/human/living_pawn = controller.pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	var/mob/living/simple_animal/hostile/abnormality/little_prince/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!istype(target))
		finish_action(controller, FALSE)
		return

	if(!LAZYLEN(current_path))
		current_path = get_path_to(living_pawn, target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 80)
		if(!current_path) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
	addtimer(CALLBACK(src, PROC_REF(Movement), controller), 1.25 SECONDS, TIMER_UNIQUE)

	if(isturf(target.loc) && living_pawn.Adjacent(target))
		finish_action(controller, TRUE)
		return

/datum/ai_behavior/hypno_move/proc/Movement(datum/ai_controller/controller)
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/little_prince/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	if(!LAZYLEN(current_path))
		return
	var/target_turf = current_path[1]
	step_towards(living_pawn, target_turf)
	current_path.Cut(1, 2)
	if(target)
		if(isturf(target.loc) && living_pawn.Adjacent(target))
			finish_action(controller, TRUE)
			return

/datum/ai_behavior/hypno_move/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/abnormality/little_prince/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(succeeded)
		target.Fungify(living_pawn)
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null
