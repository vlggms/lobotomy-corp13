/mob/living/simple_animal/hostile/abnormality/wayward
	name = "Wayward Passenger"
	desc = "A large humanoid with its torso caved open and lined with teeth. Thread-like projections cover its open wounds."
	icon = 'ModularTegustation/Teguicons/48x96.dmi'
	icon_state = "wayward"
	icon_living = "wayward_breach"
	icon_dead = "wayward_dead"
	portrait = "wayward_passenger"
	del_on_death = FALSE
	maxHealth = 1200
	health = 1200

	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)//lovetown residents LOVE physical pain, so highly resistant to black and red
	stat_attack = HARD_CRIT

	ranged = TRUE
	melee_damage_lower = 20
	melee_damage_upper = 24
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/abnormalities/wayward_passenger/attack2.ogg'
	can_breach = TRUE
	can_buckle = FALSE
	vision_range = 14
	aggro_vision_range = 20
	threat_level = HE_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 55, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = list(40, 30, 20, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = list(55, 60, 60, 60, 55),
	)
	work_damage_amount = 11
	work_damage_type = RED_DAMAGE
	fear_level = WAW_LEVEL
	max_boxes = 16
	base_pixel_x = -8
	pixel_x = -8

	ego_list = list(
		/datum/ego_datum/weapon/warp,
		/datum/ego_datum/weapon/warp/spear,
		/datum/ego_datum/armor/warp,
	)
	gift_type =  /datum/ego_gifts/warp
	gift_message = "This lighter is branded with a certain company logo."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/wayward_tele,
		/datum/action/innate/abnormality_attack/wayward_dash,
	)

	//teleport vars
	var/teleport_cooldown
	var/teleport_cooldown_time = 10 SECONDS
	var/can_act = TRUE
	//dash vars
	var/charging = FALSE
	var/can_dash = FALSE
	var/dash_num = 6
	var/dash_cooldown = 0
	var/dash_cooldown_time = 4 SECONDS
	var/list/been_hit = list() // Don't get hit twice.

/datum/action/innate/abnormality_attack/wayward_tele
	name = "Teleport"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = span_colossus("You will now teleport to your target.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/wayward_dash
	name = "Dash"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "plasmasoul"
	chosen_message = span_colossus("You will now charge towards your target.")
	chosen_attack_num = 2

//*** Simple mob procs ***
/mob/living/simple_animal/hostile/abnormality/wayward/death()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/wayward/Life()
	. = ..()
	if(!.)
		return
	if(IsContained())
		return
	if(client || IsCombatMap())
		return
	if((teleport_cooldown <= world.time) && can_act)
		TryTeleport()
	return

/mob/living/simple_animal/hostile/abnormality/wayward/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/wayward/OpenFire()
	if(client)
		switch(chosen_attack)
			if(1)
				if(!LAZYLEN(get_path_to(src,target, TYPE_PROC_REF(/turf, Distance), 0, 30)))
					to_chat(src, span_notice("Invalid target."))
					return
				TryTeleport(get_turf(target))
			if(2)
				Dash(target)
		return

	if(dash_cooldown <= world.time && can_dash)
		Dash(target)

//*** Work mechanics ***
/mob/living/simple_animal/hostile/abnormality/wayward/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(75))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wayward/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wayward/FearEffectText(mob/affected_mob, level = 0)
	level = num2text(clamp(level, -1, 4))
	var/list/result_text_list = list(
		"-1" = list("I've got this.", "How boring.", "Doesn't even phase me."),
		"0" = list("Just calm down, do what we always do.", "Just don't lose your head and stick to the manual.", "Focus...", "Just call the squire... wait, what?", "I've seen that logo somewhere..."),
		"3" = list("Why do I feel so angry?", "Help me...", "I don't want to die!", "Why does this look familiar?"),
		"4" = list("Is that... from a wing?!", "No... it can't be...", "WHAT IS THAT THING?!"),
	)
	return pick(result_text_list[level])

//*** Breach mechanics ***

/mob/living/simple_animal/hostile/abnormality/wayward/BreachEffect(mob/living/carbon/human/user, breach_type)
	icon_state = "wayward_breach"
	playsound(src, 'sound/abnormalities/thunderbird/tbird_zombify.ogg', 45, FALSE, 5)//this is the sound effect used for Tomerry in the lovetown reception
	. = ..()

//*** Teleport code ***//
/mob/living/simple_animal/hostile/abnormality/wayward/proc/TryTeleport(turf/teleport_target)//argument is used when the proc is called with a client
	if(teleport_cooldown > world.time || !can_act)
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time//so it doesn't get called twice by life()
	if(!teleport_target)
		var/list/teleport_potential = list()
		for(var/mob/living/L in GLOB.mob_living_list)
			if(L.stat == DEAD || L.z != z || L.status_flags & GODMODE || faction_check_mob(L))
				continue
			if(L in view(8, src))//vibe check
				continue
			if(!ishuman(L))
				continue
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.is_working)
					continue
			teleport_potential += get_turf(L)
		if(!LAZYLEN(teleport_potential))
			if(!LAZYLEN(GLOB.department_centers))
				return
			var/turf/P = pick(GLOB.department_centers)
			if(P in view(8, src))//nope, try again!
				return FALSE
			teleport_potential += P//there is an edge case here where a dept center within LoS can be picked if there are no other players. This is fine
		teleport_target = pick(teleport_potential)
	icon_state = "wayward_tpstart"
	playsound(src, 'sound/abnormalities/wayward_passenger/teleport.ogg', 600, 1)
	can_act = FALSE
	LoseTarget()
	SLEEP_CHECK_DEATH(4)
	playsound(src, 'sound/abnormalities/wayward_passenger/teleport2.ogg', 100, 1)
	density = FALSE
	var/obj/effect/portal/abno_warp/P1 = new(get_turf(src))
	forceMove(teleport_target)
	var/obj/effect/portal/abno_warp/P2 = new(teleport_target)
	P1.link_portal(P2)
	P2.link_portal(P1)
	icon_state = "wayward_tpend"
	playsound(src, 'sound/abnormalities/wayward_passenger/teleport2.ogg', 100, 1)
	SLEEP_CHECK_DEATH(2 SECONDS) //2 seconds to teleport
	density = TRUE
	SLEEP_CHECK_DEATH(4)
	can_act = TRUE
	icon_state = "wayward_breach"
	can_dash = TRUE

/*** Dash code ***/
/mob/living/simple_animal/hostile/abnormality/wayward/proc/Dash(target)
	if(charging || dash_cooldown > world.time)
		return
	if(!can_act)
		return
	can_act = FALSE
	can_dash = FALSE
	update_icon()//TODO: dash sprite
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	addtimer(CALLBACK(src, PROC_REF(Do_Dash), dir_to_target, 0), 2 SECONDS)//how long it takes for the dash to initiate.
	playsound(src, 'sound/abnormalities/wayward_passenger/attack1.ogg', 300, 1)
	icon_state = "wayward_charge"

/mob/living/simple_animal/hostile/abnormality/wayward/proc/Do_Dash(move_dir, times_ran)
	can_act = TRUE
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		icon_state = "wayward_breach"
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
	for(var/obj/machinery/door/poddoor/P in T.contents)
		stop_charge = TRUE
		continue
	for(var/obj/machinery/door/D in T.contents)
		if(istype(D, /obj/machinery/door/poddoor))
			continue
		if(D.density)
			D.open(2)
	if(stop_charge)
		playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 75, 1)
		charging = FALSE
		icon_state = "wayward_breach"
		return
	forceMove(T)
	playsound(src,"sound/abnormalities/thunderbird/tbird_peck.ogg", rand(50, 70), 1)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(L.z != z)
			continue
		if(!faction_check_mob(L))
			if(L in been_hit)
				continue
			L.visible_message(span_boldwarning("[src] slices through [L]!"), span_userdanger("[src] rushes past you, searing you with its blades!"))
			playsound(L, attack_sound, 75, 1)
			var/turf/LT = get_turf(L)
			new /obj/effect/temp_visual/kinetic_blast(LT)
			L.apply_damage(60,RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			if(!(L in been_hit))
				been_hit += L
	addtimer(CALLBACK(src, PROC_REF(Do_Dash), move_dir, (times_ran + 1)), 1)

/obj/effect/portal/abno_warp
	name = "dimensional rift"
	desc = "A glowing, pulsating rift through space and time."
	icon = 'ModularTegustation/Teguicons/48x96.dmi'
	icon_state = "rift_big"
	base_pixel_x = -8
	pixel_x = -8
	teleport_channel = TELEPORT_CHANNEL_FREE

/obj/effect/portal/abno_warp/Crossed(atom/movable/AM, oldloc, force_stop = 0)
	if(istype(AM, /mob/living/simple_animal/hostile/abnormality/wayward))
		return
	playsound(src, 'sound/abnormalities/wayward_passenger/teleport2.ogg', 50, TRUE)
	..()

/obj/effect/portal/abno_warp/Initialize()
	QDEL_IN(src, 3 SECONDS)
	..()
