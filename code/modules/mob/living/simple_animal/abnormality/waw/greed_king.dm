//This abnormality does more things now! It should be enjoyable enough to play as.
/mob/living/simple_animal/hostile/abnormality/greed_king
	name = "King of Greed"
	desc = "A girl trapped in a magical crystal."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "kog"
	icon_living = "kog"
	portrait = "greed_king"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 3200
	health = 3200
	ranged = TRUE
	attack_verb_continuous = "chomps"
	attack_verb_simple = "chomps"
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	speak_emote = list("states")
	vision_range = 14
	aggro_vision_range = 20
	stat_attack = HARD_CRIT
	melee_damage_lower = 60	//Shouldn't really attack unless a player in controlling it, I guess.
	melee_damage_upper = 80
	attack_sound = 'sound/abnormalities/kog/GreedHit1.ogg'
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(25, 25, 50, 50, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 50, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	observation_prompt = "Come on, don't be like that. <br>I might look hideous but that's not important to you, right? <br>\
		I am happy that you can hear me. <br>I once fought for happiness of the world. <br>But soon after, I noticed. <br>\
		Happiness of the world means happiness for me. <br>I'm trying to stay happy. <br>\
		I don't care even if it got me to the point where I look like this. <br>Have you met my sisters? <br>We were always one. <br>\
		We fought together, and shared a common goal. <br>By the way, are you happy now?"
	observation_choices = list(
		"Yes, I'm happy" = list(TRUE, "(The egg shook violently) <br>\
			Don't lie. <br>Why have we been ruined like this if that's true? <br>\
			And why have you ended up like that? <br>My greed will not be sated with such flimsy conviction. <br>\
			But if your answer is a resolve for the future, and not just a statement of fact... <br>Things might change, slowly."),
		"No, I'm not happy" = list(FALSE, "I knew you were not happy. <br>\
			You are like me. <br>You trapped yourself inside of an egg, just like me. <br>\
			The amber-colored sky is beautiful. <br>Oh, I'm getting hungry again."),
	)

	//Some Variables cannibalized from helper
	var/charge_check_time = 1 SECONDS
	var/teleport_cooldown
	var/dash_num = 50	//Mostly a safeguard
	var/list/been_hit = list()
	var/can_act = TRUE
	var/initial_charge_damage = 800
	var/growing_charge_damage = 0

	var/nihil_present = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/goldrush,
		/datum/ego_datum/armor/goldrush,
	)
	gift_type =  /datum/ego_gifts/goldrush
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/despair_knight = 2,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 2,
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 2,
		/mob/living/simple_animal/hostile/abnormality/nihil = 1.5,
	)

	//PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/innate/abnormality_attack/kog_dash,
		/datum/action/innate/abnormality_attack/kog_teleport,
	)

/mob/living/simple_animal/hostile/abnormality/greed_king/Login()
	. = ..()
	to_chat(src, "<h1>You are King of Greed, A Tank Role Abnormality.</h1><br>\
		<b>|Gilded Cage|: Your size is 3 by 3 tiles wide, however you can still fit in 1 by 1 areas.<br>\
		<br>\
		|Endless Hunger|: When you click on a tile outside your melee range, you will start charging into the direction you clicked.<br>\
		Once you start charging into a direction you will constantly move in one direction.<br>\
		Initialy, your charge deal 200 RED damage, but for every tile you move you deal an extra 40 RED damage.<br>\
		Your charge ends after you move into a wall, or any dense object. (RHINOS/OTHER ABNORMALITIES WILL STOP YOUR CHARGE)</b>")

/datum/action/innate/abnormality_attack/kog_dash
	name = "Ravenous Charge"
	button_icon_state = "kog_charge"
	chosen_message = span_colossus("You will now dash in that direction.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/kog_teleport
	name = "Teleport"
	button_icon_state = "kog_teleport"
	chosen_message = span_warning("You will now teleport to a random area in the facility's halls.")
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/kog_teleport/Activate()
	addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality/greed_king, startTeleport)), 1)
	to_chat(A, chosen_message)

/mob/living/simple_animal/hostile/abnormality/greed_king/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(nihil_present)
		return
	if(!(status_flags & GODMODE))
		if(!(!can_act || client))
			charge_check()

/mob/living/simple_animal/hostile/abnormality/greed_king/AttackingTarget()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/Move()
	if(!client && !nihil_present)
		return FALSE
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	//Center it on a hallway
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	offsets_pixel_y = list("south" = -8, "north" = -8, "west" = -8, "east" = -8)
	transform = matrix(1.5, MATRIX_SCALE)
	SetOccupiedTiles(1, 1, 1, 1)
	damage_effect_scale = 1.2
	startTeleport()	//Let's Spaghettioodle out of here

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/startTeleport()
	if(IsCombatMap())
		return
	if(nihil_present)
		return
	if(!can_act || teleport_cooldown > world.time || (status_flags & GODMODE))
		return
	teleport_cooldown = world.time + 4.9 SECONDS
	//set can_act, animate and call the proc that actually teleports.
	can_act = FALSE
	animate(src, alpha = 0, time = 5)
	addtimer(CALLBACK(src, PROC_REF(endTeleport)), 5)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/endTeleport()
	var/turf/T = pick(GLOB.xeno_spawn)
	animate(src, alpha = 255, time = 5)
	forceMove(T)
	can_act = TRUE
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(startTeleport)), 5 SECONDS)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/charge_check()
	//targeting
	var/mob/living/carbon/human/target
	if(!can_act)
		return
	var/list/possible_targets = list()
	for(var/mob/living/carbon/human/H in view(20, src))
		possible_targets += H
	if(LAZYLEN(possible_targets))
		target = pick(possible_targets)
		//Start charge
		var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
		if(dir_to_target)
			can_act = FALSE
			addtimer(CALLBACK(src, PROC_REF(charge), dir_to_target, 0, initial_charge_damage), 2 SECONDS)
			return
	return


/mob/living/simple_animal/hostile/abnormality/greed_king/OpenFire() // This exists so players can manually charge during playable abnormalities.
	if(!can_act || (!client && !nihil_present))
		return
	switch(chosen_attack)
		if(1)
			var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
			can_act = FALSE
			// do particle effect
			charge(dir_to_target, 0, initial_charge_damage)
	return

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/charge(move_dir, times_ran, charge_damage)
	setDir(move_dir)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		been_hit = list()
		stop_charge = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction()
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			stop_charge = TRUE
	for(var/mob/living/simple_animal/hostile/abnormality/D in T.contents)	//This caused issues earlier
		if(D.density)
			stop_charge = TRUE

	//Stop charging
	if(stop_charge)
		can_act = FALSE
		addtimer(CALLBACK(src, PROC_REF(endCharge)), 7 SECONDS)
		been_hit = list()
		return
	forceMove(T)

	//Hiteffect stuff

	for(var/turf/U in range(1, T))
		var/list/new_hits = HurtInTurf(U, been_hit, 0, RED_DAMAGE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			if(!nihil_present)
				L.visible_message(span_boldwarning("[src] crunches [L]!"), span_userdanger("[src] rends you with its teeth!"))
				playsound(L, attack_sound, 75, 1)
				new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
				if(ishuman(L))
					L.deal_damage(charge_damage, RED_DAMAGE)
				else
					L.adjustRedLoss(80)
				if(L.stat >= HARD_CRIT)
					L.gib()
				playsound(L, 'sound/abnormalities/kog/GreedHit1.ogg', 20, 1)
				playsound(L, 'sound/abnormalities/kog/GreedHit2.ogg', 50, 1)
				for(var/obj/vehicle/V in new_hits)
					V.take_damage(80, RED_DAMAGE, attack_sound)
					V.visible_message(span_boldwarning("[src] crunches [V]!"))
					playsound(V, 'sound/abnormalities/kog/GreedHit1.ogg', 40, 1)
					playsound(V, 'sound/abnormalities/kog/GreedHit2.ogg', 30, 1)
				continue

			if(!ishuman(L))
				L.visible_message(span_boldwarning("[src] smashes [L]!"), span_userdanger("[src] smashes you with her massive fist!"))
				playsound(L, attack_sound, 75, 1)
				new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
				L.adjustRedLoss(80)
				if(L.stat >= HARD_CRIT)
					L.gib()
				playsound(L, 'sound/abnormalities/kog/GreedHit1.ogg', 20, 1)
				playsound(L, 'sound/abnormalities/kog/GreedHit2.ogg', 50, 1)

	playsound(src,'sound/effects/bamf.ogg', 70, TRUE, 20)
	for(var/turf/open/R in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(R)
	if (IsCombatMap())
		charge_damage = charge_damage + growing_charge_damage
	addtimer(CALLBACK(src, PROC_REF(charge), move_dir, (times_ran + 1), charge_damage), 2)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/endCharge()
	can_act = TRUE
	if(!client)
		startTeleport()

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/greed_king/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(15))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/greed_king/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

//Nihil Event Code - TODO: Add attacks TODO: Add a way to teleport to nihil
/mob/living/simple_animal/hostile/abnormality/greed_king/proc/EventStart()
	set waitfor = FALSE
	NihilModeEnable()
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("So, you've finally shown yourself.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("With the Jester gone, the world can finally be free of sadness.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("We'll defeat you once and for all.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("For happiness!")
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/NihilModeEnable()
	NihilIconUpdate()
	nihil_present = TRUE
	fear_level = ZAYIN_LEVEL
	faction = list("neutral")

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/NihilIconUpdate()
	name = "Magical Girl of Happiness"
	desc = "A real magical girl!"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "kog"
	pixel_x = -8
	base_pixel_x = -8
	pixel_y = 0
	base_pixel_y = 0

/mob/living/simple_animal/hostile/abnormality/greed_king/Found(atom/A)
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/nihil)) // 1st Priority
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/petrify(statue_timer)
	if(!isturf(loc))
		MoveStatue()
	AIStatus = AI_OFF
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "kog_statue"
	pixel_x = -16
	base_pixel_x = -16
	var/obj/structure/statue/petrified/magicalgirl/S = new(loc, src, statue_timer)
	S.name = "Fossilized Greed"
	ADD_TRAIT(src, TRAIT_NOBLEED, MAGIC_TRAIT)
	SLEEP_CHECK_DEATH(1)
	S.icon = src.icon
	S.icon_state = src.icon_state
	S.pixel_x = -8
	S.base_pixel_x = -8
	var/newcolor = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	S.add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
	stat = DEAD
	return TRUE

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/MoveStatue()
	var/list/teleport_potential = list()
	if(!LAZYLEN(GLOB.department_centers))
		for(var/mob/living/L in GLOB.mob_living_list)
			if(L.stat == DEAD || L.z != z || L.status_flags & GODMODE)
				continue
			teleport_potential += get_turf(L)
	if(!LAZYLEN(teleport_potential))
		var/turf/P = pick(GLOB.department_centers)
		teleport_potential += P
	var/turf/teleport_target = pick(teleport_potential)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/greed_king/death(gibbed)
	if(!nihil_present)
		return ..()
	adjustBruteLoss(-999999)
	visible_message(span_boldwarning("Oh no, [src] has been defeated!"))
	INVOKE_ASYNC(src, PROC_REF(petrify), 500000)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/greed_king/gib()
	if(nihil_present)
		death()
		return FALSE
	return ..()

//TODO: Make this do something
/obj/structure/blissfragment
	name = "brilliant bliss"
	desc = "It looks like a large gemstone. Break it for a special buff."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bliss"
