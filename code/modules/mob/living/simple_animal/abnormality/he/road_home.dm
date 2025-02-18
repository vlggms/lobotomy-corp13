/mob/living/simple_animal/hostile/abnormality/road_home
	name = "The Road Home"
	desc = "An abnormality ressembling a small girl."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "road_home"
	icon_living = "road_home"
	portrait = "road_home"
	maxHealth = 1000
	health = 1000
	move_resist = MOVE_FORCE_STRONG //So she can't be yeeted away and delayed indefinitely
	move_to_delay = 13 //She needs to be slow so she doesn't reach home too fast
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 2, BLACK_DAMAGE = 2, PALE_DAMAGE = 2) //Endure red because catt mentions physical attacks can't hurt her at all.
	melee_damage_lower = 1
	melee_damage_upper = 1 //Irrelevant, she does not attack of her own volition
	generic_canpass = FALSE
	melee_damage_type = BLACK_DAMAGE
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 20,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = list(50, 60, 70, 80, 90),
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE
	can_patrol = FALSE
	death_sound = 'sound/abnormalities/roadhome/House_NormalAtk.ogg'
	ego_list = list(
		/datum/ego_datum/weapon/brick_road,
		/datum/ego_datum/weapon/homing_instinct,
		/datum/ego_datum/armor/homing_instinct,
	)
	gift_type = /datum/ego_gifts/homing_instinct
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/scarecrow = 2,
		/mob/living/simple_animal/hostile/abnormality/woodsman = 2,
		/mob/living/simple_animal/hostile/abnormality/scaredy_cat = 2,
		// Ozma = 2,
		/mob/living/simple_animal/hostile/abnormality/pinocchio = 1.5
	)

	observation_prompt = "Last of all, road that is lost. <br>I will send you home. <br>The wizard grants you..."
	observation_choices = list(
		"The home cannot be reached" = list(TRUE, "What are you fighting for so fiercely when you have nowhere to go back to?"),
		"The road home" = list(FALSE, "Wear this pair of shoes and be on your way. To the hometown you miss so much."),
	)

	///Stuff related to the house and its path
	var/obj/road_house/house
	var/list/house_path
	var/list/brick_list = list()
	var/road_finished = FALSE
	var/road_segment_finished = FALSE
	var/voluntary_movement = FALSE

	///If those abnos are available, she will make a path towards them instead. (isn't used for anything right now)
	var/list/preferred_abno_list = list(
		/mob/living/simple_animal/hostile/abnormality/woodsman,
		/mob/living/simple_animal/hostile/abnormality/scarecrow,
		/mob/living/simple_animal/hostile/abnormality/scaredy_cat,
	)
	var/move_timer_id
	var/spawn_tried = 0
	var/flip_cooldown_time = 10 SECONDS
	var/flip_cooldown = 0
	///Agents with the "stay home" status effect, they will be driven insane when the home is reached.
	var/list/agent_friends = list()

// Modifiers for work chance
/mob/living/simple_animal/hostile/abnormality/road_home/WorkChance(mob/living/carbon/human/user, chance, work_type)
	var/newchance = chance
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) >= 60) //Apparently the original road home is fortitude but I already made scaredy cat fort and I'm too stubborn to change it.
		newchance = chance-20
	return newchance

/mob/living/simple_animal/hostile/abnormality/road_home/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) >= 60)
		if(prob(40))
			datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/road_home/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/road_home/BreachEffect(mob/living/carbon/human/user, breach_type)
	flip_cooldown = world.time + flip_cooldown_time //we set it before she breach just so she doesn't affect everyone the moment she spawns
	. = ..()
	toggle_ai(AI_OFF) //Road home doesn't need to attack or patrol so the AI is unecessary
	NewHouse()
	CreateRoad()


/mob/living/simple_animal/hostile/abnormality/road_home/attackby(obj/item/W, mob/user, params)
	. = ..()
	CounterAttack(user)

/mob/living/simple_animal/hostile/abnormality/road_home/bullet_act(obj/projectile/P)
	. = ..()
	CounterAttack(P.firer)

/mob/living/simple_animal/hostile/abnormality/road_home/proc/CounterAttack(mob/living/attacker)
	var/retaliation = 6
	var/turf/user_turf = get_turf(attacker)
	for(var/obj/effect/golden_road/GR in user_turf.contents)
		retaliation = 3
	attacker.deal_damage(retaliation, BLACK_DAMAGE)
	to_chat(attacker, span_userdanger("[src] counter attacks!"))
	if(attacker.has_status_effect(/datum/status_effect/stay_home) || !ishuman(attacker) || stat == DEAD)
		return
	attacker.apply_status_effect(/datum/status_effect/stay_home)
	agent_friends += attacker

//She creates the road as she walks, the actual path is predetermined in advance, but the road has a bunch of effects.
/mob/living/simple_animal/hostile/abnormality/road_home/proc/CreateRoad()
	road_segment_finished = FALSE
	var/road_range = clamp(house_path.len - brick_list.len, 0, 4) //Creates 4 tiles at a time in front of her, sometimes 8 and I don't know why..
	if(road_range == 0)
		road_segment_finished = TRUE
		return
	for(var/i = 1 to road_range)
		addtimer(CALLBACK(src, PROC_REF(AddBrick), i, road_range), 0.25 SECONDS * i) //The road is created slowly for dramatic effect

/mob/living/simple_animal/hostile/abnormality/road_home/proc/AddBrick(current_brick, max_brick)
	if(brick_list.len == house_path.len)
		road_finished = TRUE
		return

	var/obj/effect/golden_road/GR = new(house_path[brick_list.len + 1])
	brick_list += GR
	GR.brick_number = brick_list.len
	if(current_brick == max_brick)
		road_segment_finished = TRUE

/mob/living/simple_animal/hostile/abnormality/road_home/Life()
	..()
	if(!(flags_1 & IS_SPINNING_1)) ///She never stops spinning, even in containment.
		spin(10 SECONDS, 2)

	if(status_flags & GODMODE)
		return

	if(flip_cooldown < world.time)
		SpinAnimation(20,1)
		flip_cooldown = world.time + flip_cooldown_time
		playsound(src, 'sound/abnormalities/roadhome/House_MakeRoad.ogg', 100, FALSE, 8)
		addtimer(CALLBACK(src, PROC_REF(FlipAttack)), 2 SECONDS)
		return

/mob/living/simple_animal/hostile/abnormality/road_home/Destroy(gibbed)
	for(var/obj/effect/golden_road/GR in brick_list)
		brick_list -= GR
		qdel(GR)
	qdel(house)
	for(var/mob/living/carbon/human/H in agent_friends)
		H.remove_status_effect(/datum/status_effect/stay_home)
	agent_friends = null
	return ..()

///Flips and gives everyone the stay home status effect.
/mob/living/simple_animal/hostile/abnormality/road_home/proc/FlipAttack()
	if(stat == DEAD)
		return

	playsound(src, 'sound/abnormalities/roadhome/House_NormalAtk.ogg', 100, FALSE, 8)
	for(var/mob/living/L in view(15, src))
		if(!ishuman(L) || L.stat == DEAD || L.has_status_effect(/datum/status_effect/stay_home))
			continue
		L.apply_status_effect(/datum/status_effect/stay_home)
		agent_friends += L

/mob/living/simple_animal/hostile/abnormality/road_home/Move(atom/newloc)
	if(!voluntary_movement && !ckey)
		return

	var/turf/newloc_turf = get_turf(newloc)

	for(var/obj/effect/golden_road/GR in newloc_turf.contents) //she's only allowed to move on the golden path
		if(!road_finished && road_segment_finished && GR.brick_number == brick_list.len)
			CreateRoad()
		. = ..()
	voluntary_movement = FALSE

	var/turf/current_turf = get_turf(src)
	for(var/obj/effect/golden_road/GR in current_turf.contents)
		if(GR.brick_number == house_path.len)
			spawn_tried = 0
			NewHouse()


/mob/living/simple_animal/hostile/abnormality/road_home/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(isliving(blocker))
		return TRUE
	return ..()

//What we do is we check the brick we're on and check what the next brick in line is.
//This means she won't have to figure out her entire path all over again every time she gets blocked for too long or knocked back somehow.
//Because her AI is turned off, this is for all intents and purposes her new AI.
/mob/living/simple_animal/hostile/abnormality/road_home/proc/MoveToBrick()
	if(ckey)
		return //even if player control is an edge case, it's good to account for them.

	var/turf/orgin = get_turf(src)
	for(var/obj/effect/golden_road/GR in orgin.contents)
		if(GR.brick_number < brick_list.len)
			voluntary_movement = TRUE
			step_towards(src, brick_list[GR.brick_number + 1], 1)
			if(orgin == get_turf(src))
				CheckAndDestroy(GR)


	deltimer(move_timer_id)
	move_timer_id = addtimer(CALLBACK(src, PROC_REF(MoveToBrick)), move_to_delay, TIMER_STOPPABLE)

///If road home fails to advance, destroy everything in front of her so she can't be infinitely blocked.
///This includes bolted doors, barriers or built walls (even indestructible ones)
///This does NOT include dense mobs or doors that can be opened.
/mob/living/simple_animal/hostile/abnormality/road_home/proc/CheckAndDestroy(obj/effect/golden_road/GR)
	var/turf/brick_turf = get_turf(brick_list[GR.brick_number + 1])
	for(var/turf/T in brick_turf.contents)

		if(T.density)
			T.ScrapeAway()

	for(var/obj/O in brick_turf.contents)
		if(istype(O, /obj/machinery/door))
			var/obj/machinery/door/D = O
			if(!D.locked)
				continue

		if(O.density)
			qdel(O) //nothing important should be both dense AND movable, but I may add exceptions if necessary.

	if(brick_turf.density)
		brick_turf.ScrapeAway()


///Kickstarts the "going home" pattern. Teleports both the road home and the house to different tiles so she can move to the house again.
/mob/living/simple_animal/hostile/abnormality/road_home/proc/NewHouse()
	if(spawn_tried >= 10)
		death() //If she tries 10 different mix and it still doesn't work she just gets bored and dies.
		return

	var/road_home_turf = pick(GLOB.department_centers - get_turf(src))
	var/list/potential_centers = list()
	for(var/pos_targ in GLOB.department_centers)
		var/possible_house_distance = get_dist(road_home_turf, pos_targ)
		if(possible_house_distance > 50 && possible_house_distance < 200) //generally that means it should be at least 2 department away
			potential_centers += pos_targ
	if(!potential_centers.len)
		spawn_tried++
		NewHouse()
		return
	var/house_turf = pick(potential_centers)
	house_path = get_path_to(road_home_turf, house_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 400)
	if(!house_path.len)
		spawn_tried++
		NewHouse()
		return
	forceMove(road_home_turf)
	if(!house)
		house = new(house_turf)
	else
		house.forceMove(house_turf)
	house.pixel_z = 128
	house.alpha = 0
	house.road_home_mob = src

	addtimer(CALLBACK(house, TYPE_PROC_REF(/obj/road_house, FallDown)), 3 SECONDS)
	road_finished = FALSE
	road_segment_finished = FALSE
	if(move_timer_id)
		deltimer(move_timer_id)
	move_timer_id = addtimer(CALLBACK(src, PROC_REF(MoveToBrick)), 10 SECONDS, TIMER_STOPPABLE) //We give the players a slight headstart to beat the shit out of her
	for(var/obj/effect/golden_road/GR in brick_list)
		brick_list -= GR
		qdel(GR)
	BringInsane()
	CreateRoad()

//Bring everyone on the golden tiles back to road home. turn them insane if they aren't already. Also destroys all gold tiles if there are any.
/mob/living/simple_animal/hostile/abnormality/road_home/proc/BringInsane()
	for(var/mob/living/carbon/human/H in agent_friends)
		H.adjustSanityLoss(1000)
		if(H.sanity_lost)
			QDEL_NULL(H.ai_controller)
			H.forceMove(get_turf(src))
			H.ai_controller = /datum/ai_controller/insane/road_home
			H.InitializeAIController()
			var/datum/ai_controller/insane/road_home/RHI = H.ai_controller
			RHI.road_home_mob = src

//The house that road home tries to go back to. It falls down like a purple noon and serves as a "goal" to the road home.
/obj/road_house
	name = "Home"
	desc = "So let's go home! Together!"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "House"
	layer = ABOVE_MOB_LAYER
	density = FALSE //So the road home can get inside the house.
	pixel_x = -34
	pixel_z = 128
	alpha = 0
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/fall_speed = 3 SECONDS
	var/mob/living/simple_animal/hostile/abnormality/road_home/road_home_mob

//Repurposed purple noon code, except it deals white damage in an AOE and red damage if you stand on the ONE TILE it's landing on.
/obj/road_house/proc/FallDown()
	animate(src, pixel_z = 0, alpha = 255, time = fall_speed)
	playsound(src, 'sound/abnormalities/roadhome/Cartoon_Falling_Sound_Effect.ogg', 100, FALSE, 8, falloff_exponent = 1.25)
	sleep(fall_speed)
	if(fall_speed > 0.5 SECONDS) //it falls very slowly at first but it can get very fast if you let her reach home too many times.
		fall_speed -= 0.5 SECONDS //home falls faster and faster

	visible_message(span_danger("[src] falls down on the ground!"))
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 3)
	var/turf/orgin = get_turf(src)

	playsound(get_turf(src), 'sound/abnormalities/roadhome/House_HouseBoom.ogg', 100, FALSE, 8)
	for(var/mob/living/L in orgin.contents)//Listen, if you're still standing in the one turf this thing is falling from, you deserve to die.
		L.deal_damage(1000, RED_DAMAGE)
		if(L.health < 0)
			L.gib()

	for(var/turf/open/T in view(4, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)

	for(var/mob/living/L in view(6, src))
		if(!road_home_mob.faction_check_mob(L))
			var/distance_decrease = get_dist(src, L) * 75
			L.deal_damage((600 - distance_decrease), WHITE_DAMAGE) //white damage so they can join the road home..
			if(!ishuman(L))
				continue
			var/mob/living/carbon/human/H = L
			if(H.sanity_lost)
				QDEL_NULL(H.ai_controller)
				H.forceMove(get_turf(road_home_mob))
				H.ai_controller = /datum/ai_controller/insane/road_home
				H.InitializeAIController()
				var/datum/ai_controller/insane/road_home/RHI = H.ai_controller
				RHI.road_home_mob = road_home_mob
				L.apply_status_effect(/datum/status_effect/stay_home)
				road_home_mob.agent_friends += H

//Not an actual floor, but an effect you put on top of it. The gold road is periodically being created by the road home.
/obj/effect/golden_road
	name = "Golden Road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "gold" //note : find a proper brick road sprite later
	alpha = 0
	anchored = TRUE
	var/brick_number //The index of this brick in the brick list

/obj/effect/golden_road/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 0.5 SECONDS)

//This will make those people try to reach the house, they will be slowed to be easier to intercept, and are generally rather harmless.
/datum/ai_controller/insane/road_home
	lines_type = /datum/ai_behavior/say_line/insanity_road_home
	var/mob/living/simple_animal/hostile/abnormality/road_home/road_home_mob
	var/move_speed

/datum/ai_behavior/say_line/insanity_road_home
	lines = list(
		"The sound of back home... If I can just go back...",
		"Let us all gather, let us all dance around...",
		"Let's go on an adventure!",
	)

/datum/ai_controller/insane/road_home/PossessPawn(atom/new_pawn)
	. = ..()
	move_speed = rand(14, 23) //Everyone has a slightly different move speed so they don't trip over each other. They should also be slower than the road home.
	addtimer(CALLBACK(src, PROC_REF(MoveToBrick)), move_speed)

/datum/ai_controller/insane/road_home/proc/MoveToBrick()
	var/mob/living/living_pawn = pawn
	if(!(living_pawn.mobility_flags & MOBILITY_MOVE))
		return

	var/turf/orgin = get_turf(living_pawn)
	for(var/obj/effect/golden_road/GR in orgin.contents)
		if(GR.brick_number < road_home_mob.brick_list.len && living_pawn.stat != DEAD)
			step_towards(living_pawn, road_home_mob.brick_list[GR.brick_number + 1], 1)
		addtimer(CALLBACK(src, PROC_REF(MoveToBrick)), move_speed)

/datum/status_effect/stay_home
	id = "stay home"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/stay_home
	var/stepped_on_road = FALSE

/atom/movable/screen/alert/status_effect/stay_home
	name = "stay home"
	desc = "Everyone must go home eventually, you are no different."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "home"

/datum/status_effect/stay_home/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(Moved))

///If someone has this status effect, they will be incapable of leaving the gold road if they ever step on it.
/datum/status_effect/stay_home/proc/Moved(datum/source, atom/new_location)
	SIGNAL_HANDLER
	var/turf/newloc_turf = get_turf(new_location)
	var/valid_tile = FALSE

	for(var/obj/effect/golden_road/GR in newloc_turf.contents)
		stepped_on_road = TRUE
		valid_tile = TRUE

	if(!stepped_on_road)
		valid_tile = TRUE

	if(!valid_tile)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/status_effect/stay_home/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
	return ..()
