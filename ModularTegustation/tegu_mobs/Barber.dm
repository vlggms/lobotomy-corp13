/mob/living/simple_animal/hostile/Barber
	name = "The Barber"
	desc = "A deranged vampire with huge scissors."
	icon = 'ModularTegustation/Teguicons/TheTrioBloodfiend.dmi'
	icon_state = "Barber"
	icon_living = "Barber"
	var/icon_charge = "BarberCharge"
	pixel_x = -13
	pixel_y = -10
	base_pixel_x = 0
	maxHealth = 7000
	health = 7000
	move_to_delay = 2
	rapid_melee = 1
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5)
	melee_damage_lower = 35
	melee_damage_upper = 45 //has a wide range, he can critically hit you
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "snips"
	attack_verb_simple = "cut"
	faction = list("hostile", "nosferatu") //Shall not commit fidelity a second time
	attack_sound = 'sound/abnormalities/nosferatu/attack.ogg'
	ranged = TRUE
	del_on_death = TRUE

	var/charging = FALSE
	var/feeding
	//breach stuff
	var/blood = 0
	var/bloodlust = 4
	var/bloodlust_cooldown = 4
	var/banquet_cooldown
	var/banquet_cooldown_time = 12 SECONDS
	var/banquet_damage = 100
	var/can_act = TRUE
	var/berzerk = FALSE
	var/nightmare_mode = FALSE
	var/icon_normal = "Barber"
	var/icon_boosted = "BarberBoosted"
	var/return_timer
	var/finisher_cooldown = 0
	var/finisher_cooldown_time = 60 SECONDS
	var/finishing = FALSE
	var/wide_slash_cooldown = 0
	var/wide_slash_cooldown_time = 7 SECONDS
	var/nightmarewide_slash_cooldown_time = 1 SECONDS
	var/wide_slash_damage = 150
	var/wide_slash_range = 4
	var/wide_slash_angle = 190

/mob/living/simple_animal/hostile/Barber/Move()
	if(!can_act)
		return FALSE
	var/turf/T = get_turf(src)
	if(!T)
		return ..()
	for(var/obj/effect/decal/cleanable/blood/B in view(T, 2)) //will clean up any blood, but only heals from human blood
		if(B.blood_state == BLOOD_STATE_HUMAN)
			playsound(T, 'sound/abnormalities/nosferatu/bloodcollect.ogg', 25, 3)
			if(B.bloodiness == 10) //Bonus for "pristine" bloodpools, also to prevent footprint spam
				AdjustThirst(10)
			else
				AdjustThirst(max((B.bloodiness**2)/800,1))
		qdel(B)
	..()


/mob/living/simple_animal/hostile/Barber/proc/AdjustThirst(thirst)
	blood = clamp(thirst + blood, 0, 4000)
	src.adjustBruteLoss(-thirst)
	if(blood > 3000 && !berzerk)
		Feast()

/mob/living/simple_animal/hostile/Barber/proc/Feast()
	AdjustThirst(-300)
	playsound(get_turf(src), 'sound/creatures/lc13/bloodfiend/BarberGoodEnough.ogg', 50, 0, 0)
	bloodlust_cooldown = clamp(bloodlust_cooldown - 2, 0, 4)
	ChangeMoveToDelayBy(-1)
	icon_state = "BarberBoosted"
	berzerk = TRUE
	pixel_y = -15
	nightmare_mode = TRUE

/mob/living/simple_animal/hostile/Barber/AttackingTarget(atom/attacked_target) //Combo for double attacks
	if(!ishuman(attacked_target))
		return ..()
	var/mob/living/carbon/human/H = attacked_target
	if(bloodlust <= 0)
		bloodlust = bloodlust_cooldown
		H.deal_damage(45, RED_DAMAGE)
		playsound(get_turf(src), 'sound/abnormalities/nosferatu/bat_attack.ogg', 50, 1)
		to_chat(attacked_target, span_danger("The [src] attacks you savagely!"))
		AdjustThirst(40)
	else
		bloodlust -= 1
	AdjustThirst(40)
	if(H.health < 0 && !SSmaptype.maptype == "limbus_labs"|| H.stat == DEAD && !SSmaptype.maptype == "limbus_labs")
		H.Drain()
	return ..()

/mob/living/simple_animal/hostile/Barber/AttackingTarget(atom/attacked_target) //they spawn blood on hit
	if(ishuman(attacked_target))
		var/obj/effect/decal/cleanable/blood/B = locate() in get_turf(src)
		if(!B)
			B = new /obj/effect/decal/cleanable/blood(get_turf(src))
			B.bloodiness = 100
	return ..()

/mob/living/simple_animal/hostile/Barber/proc/Execute(target)
	if(finisher_cooldown > world.time)
		return
	if(!isliving(target))
		return
	var/mob/living/T = target
	finisher_cooldown = world.time + finisher_cooldown_time
	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, 1)
//	icon_state = "cat_prepare" maybe someday we'll have nice things
	can_act = FALSE
	finishing = TRUE
	face_atom(target)
	T.add_overlay(icon('icons/effects/effects.dmi', "zorowarning"))
	addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "zorowarning")), 40)
	say("I Don't Need Ugly Things!!")
	SLEEP_CHECK_DEATH(20)
	icon_state = "BarberCharge" //ditto
	if(target in view(10, src))
		var/turf/jump_turf = get_step(target, pick(GLOB.alldirs))
		if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
			jump_turf = get_turf(target)
		T.add_overlay(icon('icons/effects/effects.dmi', "zoro"))
		addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('icons/effects/effects.dmi', "zoro")), 14)
		playsound(target, 'sound/weapons/guillotine.ogg', 50, 0, 2)
		forceMove(jump_turf)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.Stun(9)
		else
			can_act = TRUE
		SLEEP_CHECK_DEATH(3)
		playsound(target, 'sound/abnormalities/pussinboots/counterslash.ogg', 50, 0, 2)
		SLEEP_CHECK_DEATH(6)
		playsound(target, 'sound/creatures/lc13/bloodfiend/BarberNoUglyThings.ogg', 50, 0)
		Finisher(target)
	can_act = TRUE
	finishing = FALSE
	icon_state = icon_normal


/mob/living/simple_animal/hostile/Barber/proc/Finisher(mob/living/target) //This is not so super easy to avoid.
	target.apply_damage(30, RED_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE) //30% of your health in red damage
	to_chat(target, span_danger("[src] is trying to cut your head off!"))
	if(!ishuman(target))
		target.deal_damage(500, RED_DAMAGE)
		return
	if(target.health > 0)
		return
	var/mob/living/carbon/human/H = target
	var/obj/item/bodypart/head/head = H.get_bodypart("head")
		//OFF WITH HIS HEAD!
	if(!istype(head))
		return FALSE
	head.dismember()


/mob/living/simple_animal/hostile/Barber/OpenFire()
	if(nightmare_mode)
		if(!can_act)
			return
		if(!client)
			if((finisher_cooldown < world.time) && prob(50))
				Execute(target)
			return
		ExecuteFast(target)
		Goto(target, move_to_delay, minimum_distance)
		if(wide_slash_cooldown <= world.time && !charging)
			INVOKE_ASYNC(src, PROC_REF(WideSlash), target)
	else
		if(!can_act)
			return
		if(!client)
			if((finisher_cooldown < world.time) && prob(50))
				Execute(target)
			return
		Execute(target)
		Goto(target, move_to_delay, minimum_distance)
		if(wide_slash_cooldown <= world.time && !charging)
			INVOKE_ASYNC(src, PROC_REF(WideSlash), target)


/mob/living/simple_animal/hostile/Barber/proc/WideSlash(atom/target)
	if(!istype(target) || QDELETED(target))
		return
	if(nightmare_mode)
		if(wide_slash_cooldown > world.time)
			return
		wide_slash_cooldown = world.time + nightmarewide_slash_cooldown_time
	else
		if(wide_slash_cooldown > world.time)
			return
	wide_slash_cooldown = world.time + wide_slash_cooldown_time
	charging = TRUE
	var/turf/TT = get_turf(target)
	face_atom(TT)
	playsound(src, 'sound/abnormalities/clownsmiling/egoslash.ogg', 100, 1)
	SLEEP_CHECK_DEATH(0.7 SECONDS)
	playsound(src, 'sound/abnormalities/clownsmiling/egostab.ogg', 100, 1)
	var/turf/T = get_turf(src)
	var/rotate_dir = pick(1, -1)
	var/angle_to_target = Get_Angle(T, TT)
	var/angle = angle_to_target + (wide_slash_angle * rotate_dir) * 0.5
	if(angle > 360)
		angle -= 360
	else if(angle < 0)
		angle += 360
	var/turf/T2 = get_turf_in_angle(angle, T, wide_slash_range)
	var/list/line = getline(T, T2)
	INVOKE_ASYNC(src, PROC_REF(DoLineAttack), line)
	for(var/i = 1 to 20)
		angle += ((wide_slash_angle / 20) * rotate_dir)
		if(angle > 360)
			angle += 360
		else if(angle < 0)
			angle -= 360
		T2 = get_turf_in_angle(angle, T, wide_slash_range)
		line = getline(T, T2)
		addtimer(CALLBACK(src, PROC_REF(DoLineAttack), line), i * 0.04)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	icon_state = icon_living
	charging = FALSE

/mob/living/simple_animal/hostile/Barber/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/small_smoke/second) in T)
			continue
		new /obj/effect/temp_visual/sparkles(T)
		new /obj/effect/temp_visual/small_smoke/second(T)
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.status_flags & GODMODE)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(wide_slash_damage, RED_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))


/mob/living/simple_animal/hostile/Barber/proc/ExecuteFast(target)
	if(finisher_cooldown > world.time)
		return
	if(!isliving(target))
		return
	var/mob/living/T = target
	finisher_cooldown = world.time + finisher_cooldown_time
	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, 1)
//	icon_state = "cat_prepare" maybe someday we'll have nice things
	can_act = FALSE
	finishing = TRUE
	face_atom(target)
	T.add_overlay(icon('icons/effects/effects.dmi', "zorowarning"))
	addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "zorowarning")), 40)
	say("I Don't Need Ugly Things!!")
	SLEEP_CHECK_DEATH(5)
	icon_state = "BarberCharge" //ditto
	if(target in view(10, src))
		var/turf/jump_turf = get_step(target, pick(GLOB.alldirs))
		if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
			jump_turf = get_turf(target)
		T.add_overlay(icon('icons/effects/effects.dmi', "zoro"))
		addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('icons/effects/effects.dmi', "zoro")), 14)
		playsound(target, 'sound/weapons/guillotine.ogg', 50, 0, 2)
		forceMove(jump_turf)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.Stun(9)
		else
			can_act = TRUE
		SLEEP_CHECK_DEATH(3)
		playsound(target, 'sound/abnormalities/pussinboots/counterslash.ogg', 50, 0, 2)
		SLEEP_CHECK_DEATH(6)
		playsound(target, 'sound/creatures/lc13/bloodfiend/BarberNoUglyThings.ogg', 50, 0)
		FinisherFast(target)
	can_act = TRUE
	finishing = FALSE
	icon_state = icon_boosted

/mob/living/simple_animal/hostile/Barber/proc/FinisherFast(mob/living/target) //Death
	target.apply_damage(100, RED_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE) //100% of your health in red damage
	to_chat(target, span_danger("[src] is trying to cut your head off!"))
	if(!ishuman(target))
		target.deal_damage(1000, RED_DAMAGE)
		return
	if(target.health > 0)
		return
	var/mob/living/carbon/human/H = target
	var/obj/item/bodypart/head/head = H.get_bodypart("head")
		//OFF WITH HIS HEAD!
	if(!istype(head))
		return FALSE
	head.dismember()

