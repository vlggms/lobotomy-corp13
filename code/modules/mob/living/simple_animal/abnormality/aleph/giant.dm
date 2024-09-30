/mob/living/simple_animal/hostile/abnormality/giant
	name = "The Giant Atop the Beanstalk"
	desc = "A hunchbacked, sweaty man. Easily over 20 feet tall."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "giant"
	icon_living = "giant"
	icon_dead = "giant"
	core_icon = "giant"
	portrait = "beanstalk"
	pixel_x = -48
	base_pixel_x = -48
	speak_emote = list("bellows")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/mountain/slam.ogg'
	/* Stats */
	threat_level = ALEPH_LEVEL
	health = 3500
	maxHealth = 3500
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.2)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 80
	melee_damage_upper = 100
	move_to_delay = 5
	casingtype = /obj/item/ammo_casing/caseless/giant
	projectilesound = 'sound/weapons/fixer/reverb_grand_dash.ogg'
	ranged = TRUE
	/* Works */
	start_qliphoth = 2
	can_breach = TRUE
	del_on_death = FALSE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(25, 30, 30, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = 20,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 45, 50),
	)
	max_boxes = 32
	work_damage_amount = 14
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/bonecrusher,
		/datum/ego_datum/weapon/giant,//this is the TETH one
		/datum/ego_datum/armor/giant,
	)

	gift_type =  /datum/ego_gifts/giant//FIXME:this is the one you get from beanstalk
	gift_message = "You find the giant's treasure!"
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	can_spawn = FALSE//This is a secret abnormality. You can only spawn it via special means

	observation_prompt = "The giant sits in his cell, brushing the hair of his wife's severed head. <br>\
	You can only imagine how she was reduced to such a miserable state. <br>\
	Across the room, you see the goose that laid golden eggs."
	observation_choices = list("Steal the Giant's treasure.", "Don't enter")
	correct_choices = list("Steal the Giant's treasure.")
	observation_success_message = "You manage to steal the giant's treasure, at your own peril. <br>\
	It would be best to avoid this abnormality for the time being."
	observation_fail_message = "The bored giant picks his nose. It would be fruitless to provoke him."

	var/jump_cooldown = 0
	var/jump_cooldown_time = 25 SECONDS
	var/can_act = TRUE
	var/stomping = FALSE

/mob/living/simple_animal/hostile/abnormality/giant/AttackingTarget()
	if(!can_act)
		return FALSE
	if(prob(35) && (!client))
		return TryJump()//put the grab here instead
	return Ground_Smack()

/mob/living/simple_animal/hostile/abnormality/giant/OpenFire()
	if(!can_act)
		return FALSE
	if(prob(35) && !client)
		return Ground_Smack()//TODO: make a "hello" styled version of this. It only works in cardinal directions
	..()

/mob/living/simple_animal/hostile/abnormality/giant/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/giant/Moved()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/doomsdaycalendar/Doomsday_Attack.ogg', 50, 0, 3)
	for(var/mob/living/M in livinginrange(20, get_turf(src)))
		shake_camera(M, 1, 1)
	if(!stomping)
		return
	var/list/been_hit = list()
	var/stomp_damage = melee_damage_upper / 10
	for(var/turf/T in view(2))
		new /obj/effect/temp_visual/smash_effect(T)
		been_hit = HurtInTurf(T, been_hit, stomp_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)

/mob/living/simple_animal/hostile/abnormality/giant/Life()
	. = ..()
	if(IsContained()) // Contained
		return
	if(!can_act)
		return
	if(.)
		if(client)
			return
		if(jump_cooldown <= world.time)
			INVOKE_ASYNC(src, PROC_REF(TryJump))
		return

/mob/living/simple_animal/hostile/abnormality/giant/death()
	new /obj/effect/temp_visual/abnocore_spiral(get_turf(src))
	icon = 'ModularTegustation/Teguicons/abno_cores/aleph.dmi'
	pixel_x = -16
	base_pixel_x = -16
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/giant/CreateAbnoCore(name, core_icon)//This is how you're supposed to place it in the facility.
	var/obj/structure/abno_core/C = new(get_turf(src))//some duplicate code because I need a reference to C
	C.name = initial(name) + " Core"
	C.desc = "The core of [initial(name)]"
	C.icon_state = core_icon
	C.contained_abno = src.type
	C.threat_level = threat_level
	C.icon = 'ModularTegustation/Teguicons/abno_cores/aleph.dmi'
	new /obj/item/abno_core_key(get_turf(src))

/mob/living/simple_animal/hostile/abnormality/giant/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	TryJump()

//*****Work Mechanics*****
/mob/living/simple_animal/hostile/abnormality/giant/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
	if(istype(user.ego_gift_list[LEFTBACK], /datum/ego_gifts/giant))
		say("THAT'S MINE!!!")
	return

/mob/living/simple_animal/hostile/abnormality/giant/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//*****Breached attacks*****
/mob/living/simple_animal/hostile/abnormality/giant/proc/Ground_Smack()
	can_act = FALSE
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	var/upline = NORTH
	var/downline = SOUTH
	var/smash_length = 8
	var/smash_width = 2
	face_atom(target)
	middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
	if(dir_to_target == NORTH || dir_to_target == SOUTH)
		upline = EAST
		downline = WEST
	for(var/turf/T in middle_line)
		if(T.density)
			break
		for(var/turf/Y in getline(T, get_ranged_target_turf(T, upline, smash_width)))
			if (Y.density)
				break
			if (Y in area_of_effect)
				continue
			area_of_effect += Y
		for(var/turf/U in getline(T, get_ranged_target_turf(T, downline, smash_width)))
			if (U.density)
				break
			if (U in area_of_effect)
				continue
			area_of_effect += U
	if(!dir_to_target)
		for(var/turf/TT in view(1, src))
			if (TT.density)
				break
			if (TT in area_of_effect)
				continue
			area_of_effect |= TT
	if (!LAZYLEN(area_of_effect))
		return
	for(var/turf/T in area_of_effect)
		new/obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(15)
	playsound(get_turf(src), attack_sound, 75, 0, 3)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), melee_damage_upper, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/giant/proc/TryJump(atom/target)
	if(!can_act)
		return FALSE
	if(jump_cooldown >= world.time)
		return
	var/inverse = FALSE
	if(prob(50))
		inverse = TRUE
	jump_cooldown = world.time + jump_cooldown_time //We reset the cooldown later if there are no targets
	SLEEP_CHECK_DEATH(0.1 SECONDS)
	var/list/potentialmarked = list()
	var/list/marked = list()
	var/mob/living/carbon/human/Y
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
	var/numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
	for(var/i = numbermarked, i>=1, i--)
		if(potentialmarked.len <= 0)
			break
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(Y.stat == DEAD || Y.is_working)
			continue
		marked+=Y
	if(marked.len <= 0) //Oh no, everyone's dead!
		jump_cooldown = world.time
		return
	can_act = FALSE
	var/mob/living/carbon/human/final_target = pick(marked)
	playsound(get_turf(final_target), 'sound/abnormalities/giant/jump_warning.ogg', 30, FALSE)
	JumpAttack(final_target, inverse)

/mob/living/simple_animal/hostile/abnormality/giant/proc/JumpAttack(atom/target, inverse = FALSE)
	can_act = FALSE
	pixel_z = 128
	alpha = 0
	density = FALSE
	var/turf/target_turf = get_turf(target)
	var/spike_turf_dist = 8
	var/sweetspot = 0
	forceMove(target_turf) //look out, someone is rushing you!
	if(inverse)
		sweetspot = 8
		spike_turf_dist = 1
		new /obj/effect/temp_visual/giant_warning/pull(target_turf)
	else
		new /obj/effect/temp_visual/giant_warning(target_turf)
	SLEEP_CHECK_DEATH(5 SECONDS)
	animate(src, pixel_z = 0, alpha = 255, time = 5)
	SLEEP_CHECK_DEATH(5)
	density = TRUE
	visible_message(span_danger("[src] drops down from the ceiling!"))
	playsound(get_turf(src), 'sound/abnormalities/giant/land.ogg', 100, FALSE, 20)
	var/obj/effect/temp_visual/decoy/D = new(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)
	for(var/turf/open/T in view(3, src))
		new /obj/effect/temp_visual/tile_broken(T)
	for(var/turf/open/T in view(8, src))
		new /obj/effect/temp_visual/tile_broken/type_2(T)
		if(get_dist(src, T) == spike_turf_dist)
			new /obj/effect/temp_visual/thornspike(T)
			continue
		if(prob(20))
			new /obj/effect/temp_visual/tile_broken/type_3(T)
	for(var/mob/living/L in livinginrange(15, src))
		shake_camera(L, 5, 5)
	for(var/mob/living/L in view(8, src))
		if(faction_check_mob(L, TRUE))//prevent self-damage and allows for co-op if possible
			continue
		var/dist = get_dist(src, L)
		if(ishuman(L)) //Different damage formulae for humans vs mobs
			L.deal_damage(clamp((15 * (2 ** (sweetspot - dist))), 15, 1000), RED_DAMAGE) //15-1000 damage scaling exponentially with distance. Since mistakes are much more likely, the cap is a bit more survivable
		else
			L.deal_damage(600 - ((dist > 2 ? dist : 0 )* 75), RED_DAMAGE) //0-600 damage scaling on distance, we don't want it oneshotting mobs
		if(L == src || L.throwing)
			continue
		to_chat(L, span_userdanger("[src]'s ground slam shockwave sends you flying!"))
		var/turf/thrownat = get_ranged_target_turf_direct(src, L, 8, rand(-10, 10))
		L.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
		if(L.health < 0)
			L.gib()
	can_act = TRUE

/obj/effect/temp_visual/giant_warning
	name = "approaching giant"
	desc = "LOOK OUT!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "push_warning"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	layer = POINT_LAYER//Sprite should always be visible
	duration = 5 SECONDS

/obj/effect/temp_visual/giant_warning/pull
	icon_state = "pull_warning"
