//Coded by Coxswain, sprites by nutterbutter
//Check modulartegustation/tegu_mobs/nihil_event.dm for all structures, minions, and event-related code

/mob/living/simple_animal/hostile/abnormality/nihil
	name = "The Jester of Nihil"
	desc = "What the heck is this... A clown?"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "nihil"
	icon_living = "nihil"
	portrait = "nihil"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 2500
	health = 2500
	move_to_delay = 4
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 30, 35, 45),
		ABNORMALITY_WORK_INSIGHT = 0, //He's the fool Tarot
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 30, 35, 40),
	)
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5) //change on phase
	melee_damage_lower = 12
	melee_damage_upper = 16
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_upper = 10
	work_damage_lower = 7
	max_boxes = 35
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	faction = list("Nihil", "hostile")
	attack_sound = 'sound/abnormalities/wrath_servant/hermit_attack_hard.ogg'
	start_qliphoth = 4
	ranged = TRUE
	casingtype = /obj/item/ammo_casing/caseless/nihil_abnormality
	projectilesound = 'sound/abnormalities/wrath_servant/hermit_magic.ogg'

	observation_prompt = "I have no plans or destination. I'm too tired to fly. <br>With no one to guide me, and no path open to me. <br>It is my fate to play the fool. <br>\
		Before I do, I turn to face the 4 Magical Girls. <br>Are they just like me, or am I just like them?"
	observation_choices = list(
		"They've become me" = list(TRUE, "It doesn't matter. <br>My choices do not matter. <br>\
			Nothing matters. <br>We will repeat this song and dance until the end of time.<br> I can only laugh at this pointless endeavor."),
		"I came to resemble them" = list(TRUE, "It doesn't matter. <br>My choices do not matter. <br>\
			Nothing matters. <br>We will repeat this song and dance until the end of time.<br> I can only laugh at this pointless endeavor."),
	)

	work_start_lines = list("%ABNO says nothing to %PERSON, only humming to itself.", "Just being near %ABNO can be quite unsettling.")
	middle_work_lines = list("%PERSON avoids looking directly into %ABNO's lightless eyes.", "An oppressive, intangible substance emanates from %ABNO.")
	work_end_lines = list("%ABNO always found itself at the end of the road.", "%ABNO seems to be waiting for something inexplicable.",
	"%ABNO doesn't seem that scary to other employees, but %PERSON knows. One wrong move could lead to the end of the company.")

	///Combat
	var/can_act = TRUE
	var/breaching = FALSE // needs a special handler for its partial breach
	//Teleports
	var/icon_inverted
	var/teleport_cooldown
	var/teleport_cooldown_time = 60 SECONDS
	var/explode_damage = 80
	//Phases
	var/current_phase = "NIHIL"
	var/phase_health
	var/damage_taken = 0 // Increments up until phase_health to change phase
	var/list/all_phases = list()
	var/death_ready = TRUE
	var/event_started = FALSE
	//Generic Special attack code
	var/nuke_max_damage = 300
	var/nuke_min_damage = 15
	var/busy_attacking = FALSE //Prevents can_act from being set to true while performing a forced action
	var/current_special_attack
	var/special_cooldown = 20 SECONDS
	var/special_cooldown_time
	var/attack_counter = 0
	// Greed phase
	var/rush_num = 10 // the length of the dash, in tiles
	var/rush_cooldown = 0
	var/rush_cooldown_time = 5 SECONDS
	var/rush_damage = 50
	var/list/rush_hit_list = list()
	// Hatred phase
	var/beam_damage = 8
	var/beam_maximum_ticks = 80
	var/datum/looping_sound/qoh_beam/nihil/beamloop
	var/datum/beam/current_beam
	var/list/spawned_effects = list()
	var/beam_startup = 2 SECONDS
	var/list/lasers = list()
	var/list/beams = list()
	var/list/hit_line = list()
	// Despair phase
	var/sword_cooldown
	var/sword_cooldown_time = 2 SECONDS
	// Wrath phase
	var/smash_damage = 60
	var/smash_damage_type = RED_DAMAGE
	// Minions
	var/list/minion_list = list()

	ego_list = list(
		/datum/ego_datum/weapon/nihil,
		/datum/ego_datum/armor/nihil,
	)
	gift_type = /datum/ego_gifts/nihil

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 5,
		/mob/living/simple_animal/hostile/abnormality/despair_knight = 5,
		/mob/living/simple_animal/hostile/abnormality/greed_king = 5,
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 5,
	)
	var/list/girl_types = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,
		/mob/living/simple_animal/hostile/abnormality/despair_knight,
		/mob/living/simple_animal/hostile/abnormality/greed_king
	)

/mob/living/simple_animal/hostile/abnormality/nihil/Initialize()
	. = ..()
	beamloop = new(list(src), FALSE)
	var/icon/I = icon('ModularTegustation/Teguicons/64x64.dmi',icon_living) //create inverted colors icon
	I.MapColors(-1,0,0, 0,-1,0, 0,0,-1, 1,1,1)
	icon_inverted = I

//Work Code
/mob/living/simple_animal/hostile/abnormality/nihil/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/nihil/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)

//Qliphoth
/mob/living/simple_animal/hostile/abnormality/nihil/PostSpawn()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/mob/living/simple_animal/hostile/abnormality/nihil/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(GirlCheck(abno))
		var/friendly_list = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,)
		if(abno.type in friendly_list)
			var/mob/living/simple_animal/hostile/abnormality/hatred_queen/possiblyfriendlygirl = abno //It shouldn't really matter which one is instanced here
			if(possiblyfriendlygirl.friendly)
				return
		datum_reference.qliphoth_change(-2)

//Breach
/mob/living/simple_animal/hostile/abnormality/nihil/ZeroQliphoth(mob/living/carbon/human/user)
	if(breaching) // We're already breaching, just havent left the cell yet.
		return
	breaching = TRUE
	var/counter = 0
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if(!GirlCheck(A))
			continue
		counter += 1
	if(counter < 2)
		BreachEffect() // Not enough girls for the event, normal breach.
	else
		event_started = TRUE
		BreachEffect()

/mob/living/simple_animal/hostile/abnormality/nihil/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(!event_started)
		return ..()
	death_ready = FALSE
	can_act = FALSE
	var/mob/living/simple_animal/hostile/aminion/nihil_portal/portal
	for(var/turf/T in GLOB.department_centers)
		if(istype(get_area(T),/area/department_main/command))
			portal = new(T)
			break
	AIStatus = AI_OFF
	environment_smash = ENVIRONMENT_SMASH_NONE
	portal.owner = src
	forceMove(portal)

//Breaching behavior
/mob/living/simple_animal/hostile/abnormality/nihil/Life()
	. = ..()
	if(IsContained()) // Contained
		return
	if(.)
		if(!can_act) //Cannot currently teleport or change phase
			return
		if(!event_started) // no phases in event - test this code!
			return
		if(teleport_cooldown <= world.time)
			INVOKE_ASYNC(src, PROC_REF(TryTeleport))

/mob/living/simple_animal/hostile/abnormality/nihil/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(death_ready)
		return
	if(amount > 0)
		damage_taken += amount
	else
		var/healing_cap = (maxHealth - health)
		var/heal_amount = clamp(-amount, 0, healing_cap)
		damage_taken -= heal_amount // We recieved healing. Oh boy, this'll be a long hatred phase.
	if(!phase_health)
		return
	if(damage_taken >= phase_health)
		damage_taken -= phase_health
		if(!all_phases.len)
			death_ready = TRUE
			return
		ChangePhase()

/mob/living/simple_animal/hostile/abnormality/nihil/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if((special_cooldown <= world.time) && current_special_attack)
		return SpecialAttack()
	if(attack_counter >= 3)
		attack_counter = 0
		. = AreaGrab()
	else
		. = AreaAttack()

/mob/living/simple_animal/hostile/abnormality/nihil/OpenFire(atom/A)
	if(!can_act || IsContained())
		return
	if(attack_counter >= 3)
		attack_counter = 0
		. = AreaGrab()
		return
	if(get_dist(src, target) < 3) //Prevents ranged attack when flinching
		SpecialAttack()
		return
	if(current_phase == "GREED")
		if(rush_cooldown <= world.time)
			rush_cooldown = world.time + rush_cooldown_time
			var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
			can_act = FALSE
			GreedRush(dir_to_target, 0, target)
			attack_counter += 1
		return
	if(current_phase == "DESPAIR")
		if(!can_act)
			return FALSE
		if(sword_cooldown > world.time)
			return FALSE
		sword_cooldown = world.time + sword_cooldown_time
		for(var/i = 1 to 4)
			var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
			if(T.density)
				i -= 1
				continue
			new /obj/effect/projectile_delayed(T, A, src, /obj/projectile/despair_rapier/nihil, 3)
		SLEEP_CHECK_DEATH(3)
		playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
		attack_counter += 1
		return
	attack_counter += 1
	return ..()

/mob/living/simple_animal/hostile/abnormality/nihil/Move()
	if(!can_act)
		return FALSE
	return ..()


/mob/living/simple_animal/hostile/abnormality/nihil/death(gibbed)
	if(!death_ready)
		return FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	var/girlpower = 0
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //Delete the girls and spawn the loots
		if(!is_type_in_list(A, SSlobotomy_events.JN_breached))
			continue
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/nihil))
			continue
		var/turf/giftturf = get_turf(A)
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/wrath_servant))
			new /obj/item/nihil/club(giftturf)
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/hatred_queen))
			new /obj/item/nihil/heart(giftturf)
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/despair_knight))
			new /obj/item/nihil/spade(giftturf)
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/greed_king))
			new /obj/item/nihil/diamond(giftturf)
		girlpower += 1
		qdel(A)

	if(girlpower >= 4) //Bonus doubled reward if all 4 of the girls were present
		for(var/path in subtypesof(/obj/item/nihil))
			new path(get_turf(src))
	SSticker.superbosses |= initial(name)
	SSlobotomy_events.PruneList(event_type = 3) //End the event TODO: Visuals and stuff I guess?

	for(var/obj/effect/qoh_sygil/QS in spawned_effects)
		QS.fade_out()
	spawned_effects.Cut()
	QDEL_NULL(current_beam)
	QDEL_NULL(beamloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nihil/gib()
	if(!death_ready)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/nihil/Destroy()
	if(LAZYLEN(minion_list))
		for(var/newmob in minion_list)
			qdel(newmob)
	for(var/atom/A in lasers)
		QDEL_NULL(A)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	. = ..()


/mob/living/simple_animal/hostile/abnormality/nihil/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if(current_phase != "GREED" && !current_beam) // During greed phase or when firing a hatred beam only
		return ..() //Greed gets bullet reflect. Maybe change this later?
	if(!(P.original == src && P.firer == src)) //can't block or reflect when shooting yourself
		visible_message(span_danger("The [P.name] gets reflected by [src]!"), \
		span_userdanger("The [P.name] gets reflected by [src]!"))
		// Find a turf near or on the original location to bounce to
		if(!isturf(loc))
			P.force_hit = TRUE //The thing we're in passed the bullet to us. Pass it back, and tell it to take the damage.
			loc.bullet_act(P, def_zone, piercing_hit)
			return BULLET_ACT_HIT
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(src)
			P.original = locate(new_x, new_y, P.z)
			P.starting = curloc
			P.firer = src
			P.force *= 0.1 // Reflecting at full damage will likely instakill people
			P.yo = new_y - curloc.y
			P.xo = new_x - curloc.x
			var/new_angle_s = P.Angle + rand(120,240)
			while(new_angle_s > 180)	// Translate to regular projectile degrees
				new_angle_s -= 360
			P.set_angle(new_angle_s)
			playsound(get_turf(src),'sound/magic/blink.ogg', 50, FALSE)
			var/obj/effect/temp_visual/greed_shield/AT = new /obj/effect/temp_visual/greed_shield(loc, src)
			var/random_x = rand(-16, 16)
			AT.pixel_x += random_x
			var/random_y = rand(5, 32)
			AT.pixel_y += random_y
		return BULLET_ACT_FORCE_PIERCE // complete projectile permutation

//Default/All attacks
/mob/living/simple_animal/hostile/abnormality/nihil/proc/AreaAttack() //Replaces normal attack
	set waitfor = FALSE
	attack_counter += 1
	changeNext_move(SSnpcpool.wait / rapid_melee) //Prevents attack spam
	var/damage_dealt = rand(melee_damage_lower, melee_damage_upper)
	var/turf/myturf = get_turf(src)
	playsound(src, 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 60, FALSE, 10)
	for(var/turf/T in range(1, src)) //First hit is just an AOE around nihil
		new /obj/effect/temp_visual/eldritch_smoke(T)
		HurtInTurf(T, list(), (0.5 * damage_dealt), BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_MELEE))
	SLEEP_CHECK_DEATH(8)
	playsound(src, 'sound/abnormalities/wrath_servant/hermit_attack_hard.ogg', 25, FALSE, 15, falloff_distance = 5)
	new /obj/effect/temp_visual/voidout(myturf)
	for(var/turf/T in range(1, myturf)) //Second hit is avoidable but deals 3x damage
		for(var/mob/living/L in HurtInTurf(T, list(), (2 * damage_dealt), BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_MELEE)))
			L.apply_void(4)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/AreaGrab() // Attempts to grab the player if they have any stacks of void. Does chip damage otherwise.
	set waitfor = FALSE
	changeNext_move(SSnpcpool.wait / rapid_melee) //Prevents attack spam
	var/damage_dealt = (0.5 * rand(melee_damage_lower, melee_damage_upper))
	var/list/grab_list = list()
	playsound(src, 'sound/abnormalities/nihil/hatred_casting.ogg', 60, FALSE, 10)
	var/list/target_turfs = list()
	for(var/mob/living/L in view(10, src))
		new /obj/effect/temp_visual/eldritch_smoke(get_turf(L))
		var/datum/status_effect/stacking/void/V = L.has_status_effect(/datum/status_effect/stacking/void)
		if(V)
			grab_list += L
		target_turfs += (get_turf(L))
	for(var/turf/T in target_turfs)
		HurtInTurf(T, list(), (0.5 * damage_dealt), BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_SPECIAL))
	new /obj/effect/temp_visual/voidin(get_turf(src))
	if(LAZYLEN(grab_list))
		TryGrabbing(grab_list)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/TryGrabbing(list/grab_list)
	for(var/mob/living/L in grab_list)
		if(!L.client)
			continue
		var/objects = 5
		var/datum/status_effect/stacking/void/V = L.has_status_effect(/datum/status_effect/stacking/void)
		if(V)
			objects += (round(clamp(V.stacks * 0.1, 1, 10)))
		else
			L.apply_void(1)
			V = L.has_status_effect(/datum/status_effect/stacking/void)
		V.DoGrab(L.client, objects)


/mob/living/simple_animal/hostile/abnormality/nihil/proc/NukeAttack() //Phase-change attack with a long cooldown
	busy_attacking = TRUE
	playsound(src, 'sound/effects/clockcult_gateway_disrupted.ogg', 100, FALSE, 40, falloff_distance = 10)
	for(var/mob/M in GLOB.player_list) //vfx
		if(M.z == z && M.client)
			flash_color(M, flash_color = "#CCBBBB", flash_time = 50)
			shake_camera(M, 50, 1)
	for(var/area/A in world)
		for(var/obj/machinery/light/L in A)
			L.flicker(4)
	for(var/turf/open/L in range(7, src))
		new /obj/effect/temp_visual/cult/sparks(L)
	for(var/turf/open/T in urange(25, src))
		if(prob(50))
			addtimer(CALLBACK(src, PROC_REF(NukeAttackEffectHelper),T), rand(0,40))
	SLEEP_CHECK_DEATH(50)
	playsound(src, 'sound/effects/phasein.ogg', 100, FALSE, 40, falloff_distance = 10)
	var/matrix/init_transform = transform
	animate(src, transform = transform*1.5, time = 3, easing = BACK_EASING|EASE_OUT)
	var/obj/effect/temp_visual/explosion/mybomb = new(get_turf(src))
	mybomb.color = COLOR_HALF_TRANSPARENT_BLACK
	for(var/mob/living/L in livinginrange(25, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		var/dist = get_dist(src, L)
		var/damage_mod = (dist > 7 ? 5 : 20 )
		L.deal_damage(clamp((damage_mod * (25 - dist)), nuke_min_damage, nuke_max_damage), BLACK_DAMAGE, src, attack_type = (ATTACK_TYPE_SPECIAL)) //Between 500 and 15 damage, scaling down heavily past a distance of 7 tiles
		flash_color(L, flash_color = COLOR_ALMOST_BLACK, flash_time = 70)
		L.apply_void(damage_mod) //inflict a void debuff
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)
	can_act = TRUE
	busy_attacking = FALSE

/mob/living/simple_animal/hostile/abnormality/nihil/proc/NukeAttackEffectHelper(turf/open/T)
	new /obj/effect/temp_visual/eldritch_smoke(T)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/TryTeleport(forced = FALSE)
	if(teleport_cooldown > world.time)
		return FALSE
	if(!can_act && !forced)
		return FALSE
	var/list/teleport_potential = list()
	for(var/mob/living/L in urange(13, src)) //1st priority - anyone in about viewport distance
		if(!faction_check_mob(L) && L.stat != DEAD && !(L.status_flags & GODMODE))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.is_working) //Ignore people working
					continue
			teleport_potential += get_turf(L)
			continue
	if(!LAZYLEN(teleport_potential)) //2nd priority - anyone alive
		for(var/mob/living/L in GLOB.mob_living_list)
			if(L.stat == DEAD || L.z != z || L.status_flags & GODMODE || faction_check_mob(L))
				continue
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.is_working) //Ignore people working
					continue
			teleport_potential += get_turf(L)
	if(!LAZYLEN(teleport_potential))
		if(!LAZYLEN(GLOB.department_centers))
			return
		var/turf/P = pick(GLOB.department_centers)
		teleport_potential += P
	can_act = FALSE
	LoseTarget()
	for(var/mob/living/L in urange(13, src)) //vfx
		if(L.z == z && L.client)
			shake_camera(L, 10, 1)
	playsound(src, 'sound/abnormalities/hatredqueen/gun.ogg', 65, FALSE, 10)
	SLEEP_CHECK_DEATH(10)
	var/turf/teleport_target = pick(teleport_potential)
	if(isicon(icon_inverted)) //invert colors upon hostile teleport
		icon = icon_inverted
	animate(src, alpha = 0, time = 4)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(4)
	invisibility = INVISIBILITY_MAXIMUM //prevents nihil from being hit at all while in the process of teleporting
	density = FALSE
	TeleportOut(teleport_target)
	forceMove(teleport_target)
	SLEEP_CHECK_DEATH(2 SECONDS) //2 seconds to teleport
	invisibility = 0
	density = TRUE
	animate(src, alpha = 255, time = 4)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	SLEEP_CHECK_DEATH(3)
	TeleportIn()
	SLEEP_CHECK_DEATH(4)
	if((text2path(icon) == text2path(icon_inverted))) //revert back
		icon = 'ModularTegustation/Teguicons/64x64.dmi'
	if(!busy_attacking)
		can_act = TRUE
	teleport_cooldown = world.time + teleport_cooldown_time

/mob/living/simple_animal/hostile/abnormality/nihil/proc/TeleportOut(turf/teleport_target)
	set waitfor = FALSE
	switch(current_phase)
		if("GREED")
			playsound(src, 'sound/weapons/fixer/generic/dodge.ogg', 75, FALSE, 10)
			for(var/turf/T in view(2, src))
				new /obj/effect/temp_visual/small_smoke(T)
				for(var/mob/living/H in HurtInTurf(T, list(), (0.5 * explode_damage), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_SPECIAL)))
					visible_message("[src] tosses [H] out of the way!")
					var/rand_dir = pick(NORTH, SOUTH, EAST, WEST)
					var/atom/throw_target = get_edge_target_turf(H, rand_dir)
					if(!H.anchored)
						H.throw_at(throw_target, rand(6, 10), 18, H)
		if("HATE")
			var/obj/effect/qoh_sygil/S = new(teleport_target)
			S.icon_state = "qoh2"
			addtimer(CALLBACK(S, TYPE_PROC_REF(/obj/effect/qoh_sygil, fade_out)), 2 SECONDS)
			TeleportIn() //Same effect
		if("DESPAIR")
			var/list/target_list = list()
			for(var/mob/living/L in urange(10, src))
				if(L.z != z || (L.status_flags & GODMODE))
					continue
				if(faction_check_mob(L, FALSE))
					continue
				target_list += L
			for(var/i = 1 to 9)
				if(LAZYLEN(target_list))
					FindTarget(list(pick(target_list)), TRUE)
				if(!target || QDELETED(target))
					continue
				var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
				if(T.density)
					i -= 1
					continue
				new /obj/effect/projectile_delayed(T, target, src, /obj/projectile/despair_rapier/nihil, 30)
				var/list/hit_line = getline(T, get_turf(target)) //targetting line
				for(var/turf/TF in hit_line)
					if(TF.density)
						break
					new /obj/effect/temp_visual/cult/sparks(TF)
			playsound(get_turf(src), 'sound/abnormalities/despairknight/dead.ogg', 50, 0, 2)
			SLEEP_CHECK_DEATH(30)
			playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)

		if("WRATH")
			playsound(src, 'sound/abnormalities/wrath_servant/big_smash3.ogg', 75, FALSE, 10, falloff_distance = 5)
			for(var/turf/T in view(2, src))
				HurtInTurf(T, list(), explode_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
				new /obj/effect/temp_visual/kinetic_blast(T)
				if(prob(95))
					new /obj/effect/decal/cleanable/wrath_acid/bad/nihil(T)
				else
					new /obj/effect/gibspawner/generic/silent/wrath_acid/bad/nihil(T)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/TeleportIn()
	switch(current_phase)
		if("GREED")
			animate(src, alpha = 0, pixel_z = 16, time = 0)
			src.pixel_z = 16
			animate(src, alpha = 255, pixel_z = -16, time = 20)
			src.pixel_z = 0
			SLEEP_CHECK_DEATH(2 SECONDS)
			playsound(src, 'sound/abnormalities/kog/GreedHit1.ogg', 75, FALSE, 10)
			for(var/turf/T in view(3, src))
				new /obj/effect/temp_visual/small_smoke(T)
				for(var/mob/living/H in HurtInTurf(T, list(), (2 * explode_damage), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL)))
					visible_message("[src] tosses [H] out of the way!")
					var/rand_dir = pick(NORTH, SOUTH, EAST, WEST)
					var/atom/throw_target = get_edge_target_turf(H, rand_dir)
					if(!H.anchored)
						H.throw_at(throw_target, rand(6, 10), 18, H)
					if(H.stat == DEAD)
						H.gib(FALSE, FALSE, FALSE)
		if("HATE")
			visible_message(span_bolddanger("[src] explodes!"))
			var/obj/effect/temp_visual/VO = new /obj/effect/temp_visual/voidout(get_turf(src))
			var/matrix/new_matrix = matrix()
			new_matrix.Scale(1.75)
			VO.transform = new_matrix
			playsound(src, 'sound/effects/phasein.ogg', 65, FALSE, 10)
			for(var/turf/open/T in view(2, src))
				HurtInTurf(T, list(), explode_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, attack_type = (ATTACK_TYPE_SPECIAL))
		if("DESPAIR")
			SLEEP_CHECK_DEATH(4)
			TeleportOut()//Same effect but with a delay
		if("WRATH")
			SLEEP_CHECK_DEATH(4)
			TeleportOut()//Same effect but with a delay

//Greed Phase Attacks
/mob/living/simple_animal/hostile/abnormality/nihil/proc/GreedRush(move_dir, times_ran, target) // Greed substitute for a ranged attack
	setDir(move_dir)
	var/stop_charge = FALSE
	if(times_ran >= rush_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		rush_hit_list = list()
		stop_charge = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			stop_charge = TRUE
	for(var/mob/living/simple_animal/hostile/abnormality/D in T.contents)	//This caused issues earlier
		if(D.density)
			stop_charge = TRUE

	//Stop charging
	if(stop_charge)
		can_act = TRUE
		rush_hit_list = list()
		return
	forceMove(T)

	for(var/turf/U in range(1, T))
		var/list/new_hits = HurtInTurf(U, rush_hit_list, 0, RED_DAMAGE, hurt_mechs = TRUE, flags = (DAMAGE_UNTRACKABLE)) - rush_hit_list
		rush_hit_list += new_hits
		for(var/mob/living/L in new_hits)
			var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, get_turf(src))))
			L.visible_message(span_boldwarning("[src] slams into [L]!"), span_userdanger("[src] rends you with its teeth and claws!"))
			playsound(L, 'sound/weapons/genhit2.ogg', 75, 1)
			new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
			L.deal_damage(rush_damage, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
			L.apply_void(2)
			L.throw_at(throw_target, 3, 2)
			for(var/obj/vehicle/V in new_hits)
				V.take_damage(rush_damage, RED_DAMAGE, attack_sound)
				V.visible_message(span_boldwarning("[src] crunches [V]!"))
				playsound(V, 'sound/weapons/genhit2.ogg', 75, 1)
			continue

	playsound(src,'sound/effects/bamf.ogg', 40, TRUE, 20)
	for(var/turf/open/R in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(R)
	addtimer(CALLBACK(src, PROC_REF(GreedRush), move_dir, (times_ran + 1)), 1)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/GreedBlink()
	can_act = FALSE
	var/list/attack_candidates = list()
	if(isliving(target))
		var/mob/living/L = target
		if(!L.stat)
			attack_candidates.Add(L)
	for(var/mob/living/carbon/human/maybe_victim in GLOB.player_list)
		if(faction_check_mob(maybe_victim))
			continue
		if((maybe_victim.stat != DEAD) && maybe_victim.z == z)
			attack_candidates += maybe_victim
	attack_candidates = uniqueList(attack_candidates) // Prune duplicates
	if(!LAZYLEN(attack_candidates)) // If there is 0 candidates - stop the spell.
		to_chat(src, span_notice("There is no more human survivors in the facility."))
		can_act = TRUE
		return
	GreedCircle(null, null, src)
	var/timetoact
	var/total_targets = clamp(attack_candidates.len + 3, 5, 20) // 5-20 attacks based on the number of players that can be hit
	var/list/candidates_copy = attack_candidates.Copy()
	var/mob_spawning = TRUE
	for(var/i in 1 to total_targets)
		if(!LAZYLEN(attack_candidates)) // No more candidates left? Let's refresh the list
			attack_candidates = candidates_copy.Copy()
			mob_spawning = FALSE
		var/mob/living/carbon/human/H = pick(attack_candidates)
		attack_candidates -= H
		if(!istype(H) || QDELETED(H)) // Shouldn't be possible, but here we are
			continue
		if(mob_spawning)
			var/turf/dispense_turf = get_turf(H) // Fallback if there's somehow no turfs in view
			var/list/pickable_turfs = list()
			for(var/turf/T in view(3, H))
				if(!T || isclosedturf(T))
					continue
				if(locate(/obj/structure/window) in T.contents)
					continue
				if(locate(/obj/structure/table) in T.contents)
					continue
				if(locate(/obj/structure/railing) in T.contents)
					continue
				if(locate(/mob/living/simple_animal/hostile/aminion/blissfragment) in T.contents) // No doubling up on frags
					mob_spawning = FALSE
					break
				pickable_turfs += T
			if(mob_spawning) // Check again to make sure that we didnt find a fragment in our range
				if(pickable_turfs.len)
					dispense_turf = pick(pickable_turfs)
				var/mob/living/simple_animal/hostile/aminion/blissfragment/newmob = new(dispense_turf)
				minion_list += newmob
		addtimer(CALLBACK(src, PROC_REF(GreedBlinkWarning), H), i*4)
		timetoact += 4
	SLEEP_CHECK_DEATH(timetoact + 170)
	if(LAZYLEN(minion_list))
		for(var/newmob in minion_list)
			if(istype(newmob, /mob/living/simple_animal/hostile/aminion/blissfragment))
				qdel(newmob)
	CleanUp()
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nihil/proc/GreedBlinkWarning(mob/living/L)
	GreedCircle(L, get_step(get_turf(L), pick(GLOB.cardinals)), null)
	playsound(L, 'sound/abnormalities/hatredqueen/attack.ogg', 50, 1)
	to_chat(L, span_danger("[src] is going to hunt you down!"))
	addtimer(CALLBACK(src, PROC_REF(GreedBlinkAttack), L), 150)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/GreedBlinkAttack(mob/living/target)
	if(!istype(target) || QDELETED(target) || !target.loc)
		return
	if(target.z != z || !target.loc.AllowClick())
		to_chat(src, span_notice("Your spell fizzles out!"))
		to_chat(target, span_notice("It seems you are safe. For now..."))
		return
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc, src)
	D.color = COLOR_YELLOW
	animate(D, alpha = 0, time = 5)
	visible_message(span_warning("[src] teleports away!"))
	var/turf/tp_loc = get_step(target.loc, pick(0,1,2,4,5,6,8,9,10))
	forceMove(tp_loc)
	playsound(target, 'sound/abnormalities/kog/GreedHit1.ogg', 100, 1)
	GiveTarget(target)
	var/hard_hit = TRUE
	for(var/mob/living/simple_animal/hostile/aminion/blissfragment/thefrag in range(3, get_turf(src)))
		if(thefrag.stat == DEAD)
			hard_hit = FALSE
			break
	for(var/mob/living/L in range(1, get_turf(src))) // Attacks everyone around.
		if(faction_check_mob(L))
			continue
		if(hard_hit)
			to_chat(L, span_userdanger("[src] punishes you!"))
			L.apply_void(20)
			L.deal_damage(150, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
		else
			to_chat(L, span_userdanger("You are protected by the gemstone!"))
			L.deal_damage(10, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
			var/obj/effect/temp_visual/greed_shield/AT = new /obj/effect/temp_visual/greed_shield(get_turf(L), L)
			var/random_x = rand(-8, 8)
			AT.pixel_x += random_x
			var/random_y = rand(5, 16)
			AT.pixel_y += random_y
		new /obj/effect/temp_visual/cleave(get_turf(L))


/mob/living/simple_animal/hostile/abnormality/nihil/proc/GreedCircle(mob/first_target, turf/second_target, mob/user = null)
	var/obj/effect/qoh_sygil/kog/KS
	if(user)
		KS = new(get_turf(user))
	else
		KS = new(get_turf(first_target))
	spawned_effects += KS
	var/matrix/M = matrix(KS.transform)
	M.Translate(0, 48)
	var/rot_angle
	var/my_dir
	if(user)
		my_dir = user.dir
		rot_angle = Get_Angle(user, get_step(user, my_dir))
	else
		my_dir = get_dir(first_target, second_target)
		rot_angle = Get_Angle(first_target, get_step_towards(first_target, second_target))
	M.Turn(rot_angle)
	switch(my_dir)
		if(EAST)
			M.Scale(0.5, 1)
			KS.layer += 0.1
		if(WEST)
			M.Scale(0.5, 1)
			KS.layer += 0.1
		if(NORTH)
			M.Scale(1, 0.5)
			KS.layer += 0.1
		if(SOUTH)
			M.Scale(1, 0.5)
			KS.layer -= 0.1
	KS.transform = M
	if(first_target)
		KS.orbit(first_target, 0, FALSE, 0, 0, FALSE)
	return

/mob/living/simple_animal/hostile/abnormality/nihil/proc/CleanUp()
	for(var/obj/effect/FX in spawned_effects)
		if(istype(FX, /obj/effect/qoh_sygil/kog))
			var/obj/effect/qoh_sygil/kog/KS = FX
			KS.fade_out()
			continue
		FX.Destroy()
	listclearnulls(spawned_effects)

//Hatred Phase Attacks
/mob/living/simple_animal/hostile/abnormality/nihil/proc/HatredBeam(target)
	if(!target)
		return FALSE
	var/turf/target_turf = get_turf(target)
	face_atom(target_turf)
	var/turf/my_turf = get_turf(src)
	can_act = FALSE
	var/list/beamtalk = list(
		"To those unmarred by chaos, wandering ceasessly...",
		"In the name of those beings who are neither good nor evil...",
		"I shall make this oath to the night.",
		"Mark thine lost hollow beings who stand before us...",
		"Let your strength be consumed by mine...",
		"so that we may deliver this power of hatred to all in our path...",
	)
	SetupLaser()
	for(var/i = 1 to 3)
		var/obj/effect/qoh_sygil/S = new(my_turf)
		spawned_effects += S
		playsound(src, "sound/abnormalities/hatredqueen/beam[clamp(i, 1, 2)].ogg", 50, FALSE, 4*i)
		var/matrix/M = matrix(S.transform)
		M.Translate(0, i*24)
		var/rot_angle = Get_Angle(my_turf, target_turf)
		M.Turn(rot_angle)
		switch(i)
			if(1)
				S.icon_state = "qoh[2]"
			if(2)
				S.icon_state = "qoh[1]"
				// Normal rules don't apply for this one
				var/obj/effect/qoh_sygil/SH = new(my_turf)
				spawned_effects += SH
				SH.icon_state = "qoh[4]"
				SH.pixel_y += 60
				var/matrix/MH = SH.transform
				MH.Scale(1.5, 0.5)
				SH.transform = MH
				SH.layer = layer + 0.1
			if(3)
				S.icon_state = "qoh[1]"
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), beamtalk[i*2 - 1]))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), beamtalk[i*2]), beam_startup/2)
		S.transform = M
		SLEEP_CHECK_DEATH(beam_startup) //time between beam startup stage
	var/turf/TT = get_ranged_target_turf_direct(my_turf, target_turf, 60)
	current_beam = my_turf.Beam(TT, "nihil_beam")
	var/list/hit_line = getline(my_turf, TT)
	beamloop.start()
	var/beam_stage = 1
	var/beam_damage_final = beam_damage
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), "ARCANA SLAVE!"))
	for(var/h = 1 to beam_maximum_ticks)
		var/list/already_hit = list()
		if(h >= 60)
			if(beam_stage < 4)
				beam_stage = 4
				beam_damage_final *= 1.5
				var/matrix/M = matrix()
				M.Scale(14, 1)
				current_beam.visuals.transform = M
		else if(h >= 50)
			if(beam_stage < 3)
				beam_stage = 3
				beam_damage_final *= 1.5
				var/matrix/M = matrix()
				M.Scale(10, 1)
				current_beam.visuals.transform = M
		else if((h >= 40))
			if(beam_stage < 2)
				beam_stage = 2
				beam_damage_final *= 1.5
				var/matrix/M = matrix()
				M.Scale(8, 1)
				current_beam.visuals.transform = M
		else if((h >= 20))
			if(beam_stage < 2)
				beam_stage = 2
				beam_damage_final *= 1.5
				var/matrix/M = matrix()
				M.Scale(4, 1)
				current_beam.visuals.transform = M
		for(var/turf/TF in orange((beam_stage-1), my_turf))
			var/obj/effect/temp_visual/L = new /obj/effect/temp_visual/revenant(TF)
			L.icon_state = "shieldsparkles"
			if(prob(90))
				L.color = COLOR_ALMOST_BLACK
		for(var/turf/TF in hit_line)
			for(var/mob/living/L in range(beam_stage-1, TF))
				if(L.status_flags & GODMODE)
					continue
				if(L == src) //stop hitting yourself
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				already_hit += L
				if(faction_check_mob(L))
					L.adjustBruteLoss(-beam_damage_final * 0.5)
					if(ishuman(L))
						var/mob/living/carbon/human/H = L
						H.adjustSanityLoss(-beam_damage_final * 0.5)
					continue
				var/damage_before = L.get_damage_amount(BRUTE)
				var/truedamage = ishuman(L) ? beam_damage_final : beam_damage_final/2 //half damage dealt to nonhumans
				L.deal_damage(truedamage, BLACK_DAMAGE, src, attack_type = (ATTACK_TYPE_RANGED | ATTACK_TYPE_SPECIAL))
				L.apply_void(2)
				var/damage_dealt = abs(L.get_damage_amount(BRUTE)-damage_before)
				if(ishuman(L))
					adjustBruteLoss(-damage_dealt) //Heals from laser damage, only from humans
		SLEEP_CHECK_DEATH(1.71)
	QDEL_NULL(current_beam)
	for(var/obj/effect/qoh_sygil/S in spawned_effects)
		S.fade_out()
	spawned_effects.Cut()
	beamloop.stop()
	StopLaser()
	SLEEP_CHECK_DEATH(4 SECONDS) //Rest after laser beam
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nihil/proc/SetupLaser()
	set waitfor = FALSE
	SLEEP_CHECK_DEATH(2 SECONDS)
	HandleLasers(TRUE)
	SLEEP_CHECK_DEATH(4 SECONDS)
	FireLaser()

/mob/living/simple_animal/hostile/abnormality/nihil/proc/HandleLasers()
	for(var/i = 1 to 3)
		var/obj/effect/qoh_sygil/S = new(get_turf(src))
		lasers += S
	var/i = 0
	var/new_angle = rand(0, 360)
	for(var/obj/effect/qoh_sygil/L in lasers)
		i++
		lasers[L] = get_turf_in_angle(new_angle, get_turf(L), 64)
		L.dir = get_dir(get_turf(src), lasers[L])
		L.icon_state = "qoh[2]"
		var/matrix/MH = L.transform
		switch(L.dir)
			if(NORTH)
				MH.Scale(1, 0.5)
			if(SOUTH)
				MH.Scale(1, 0.5)
			if(EAST)
				MH.Scale(0.5, 1)
			if(WEST)
				MH.Scale(0.5, 1)
			else
				MH.Scale(0.75, 0.75)
		L.transform = MH
		L.layer = layer + 0.1
		L.Move(get_ranged_target_turf(src, L.dir, 1))//src, dir, distance
		playsound(get_turf(src), 'sound/abnormalities/hatredqueen/attack.ogg', 50 + 5 * (i - 3), FALSE)
		addtimer(CALLBACK(src, PROC_REF(PrepareLaser), L), 0.5 SECONDS + (i * 3))
		var/old_angle = new_angle
		for(var/attempt = 1 to 3) // Just so that we don't get ourselves absolutely the same angle twice in a row
			new_angle = rand(0, 360)
			if((new_angle > old_angle + 30) || (new_angle < old_angle - 30))
				break
		SLEEP_CHECK_DEATH(3)

// Rotate the laser and creates a warning beam
/mob/living/simple_animal/hostile/abnormality/nihil/proc/PrepareLaser(obj/effect/qoh_sygil/L)
	if(stat == DEAD || QDELETED(L))
		return
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	var/turf/T = get_turf(L)
	var/datum/beam/B = T.Beam(lasers[L], "light_beam")
	beams += B
	B.visuals.alpha = 0
	animate(B.visuals, alpha = 255, time = 30)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/FireLaser()
	if(stat == DEAD)
		return
	for(var/datum/beam/B in beams)//elevate this y tiles
		B.visuals.icon_state = "light_beam" // WARNING, YOU ARE ABOUT TO DIE!!!
		var/matrix/M = matrix()
		M.Scale(3, 1)
		animate(B.visuals, transform = M, time = 30)
	SLEEP_CHECK_DEATH(3 SECONDS)
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	hit_line = list()
	for(var/obj/effect/qoh_sygil/L in lasers)
		var/turf/T = get_turf(L)
		var/datum/beam/B = T.Beam(lasers[L], "nihil_beam")
		var/matrix/M = matrix()
		M.Scale(3, 1)
		B.visuals.transform = M
		beams += B
		hit_line |= getline(T, lasers[L])
	INVOKE_ASYNC(src, PROC_REF(LaserEffect))

/mob/living/simple_animal/hostile/abnormality/nihil/proc/LaserEffect()
	if(stat == DEAD)
		return
	for(var/i = 1 to 30)
		//This following chunk of code basically fires a mini laser barrage on ticks 8, 16, 24 and 32. (4 barrages)
		var/list/already_hit = list()
		for(var/turf/T in hit_line)
			for(var/mob/living/L in range(1, T))
				if(L.status_flags & GODMODE)
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				if(faction_check_mob(L))
					continue
				already_hit += L
				L.deal_damage(beam_damage, BLACK_DAMAGE, src, attack_type = (ATTACK_TYPE_RANGED | ATTACK_TYPE_SPECIAL))
				L.apply_void(1)
		SLEEP_CHECK_DEATH(0.25 SECONDS)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/StopLaser()
	for(var/datum/beam/B in beams)
		QDEL_NULL(B)
	beams = list()
	for(var/atom/A in lasers)
		A.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		animate(A, alpha = 0, time = 1 SECONDS)
		QDEL_IN(A, 15)
	lasers = list()

//Despair Phase Attacks
/mob/living/simple_animal/hostile/abnormality/nihil/proc/DespairGuard()
	listclearnulls(minion_list)
	if(!LAZYLEN(minion_list))
		SpawnDespairSwords()
		return
	playsound(get_turf(src), 'sound/abnormalities/despairknight/gift.ogg', 50, 0, 2)
	for(var/mob/living/simple_animal/hostile/aminion/despair_sword/newmob in minion_list)
		newmob.Regenerate()
		newmob.GoToFriend()
		newmob.Unbless()
	var/mob/living/simple_animal/hostile/aminion/despair_sword/chosenmob = pick(minion_list)
	chosenmob.Bless()

/mob/living/simple_animal/hostile/abnormality/nihil/proc/SpawnDespairSwords()
	if(!(current_phase == "DESPAIR"))
		return
	for(var/i = 1 to 3)
		var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
		if(!isopenturf(dispense_turf))
			dispense_turf = get_turf(src)
		var/mob/living/simple_animal/hostile/aminion/despair_sword/newmob = new(dispense_turf)
		newmob.friend = src
		minion_list += newmob
	var/mob/living/simple_animal/hostile/aminion/despair_sword/chosenmob = pick(minion_list)
	chosenmob.Bless()

//Wrath Phase Attacks
/mob/living/simple_animal/hostile/abnormality/nihil/proc/WrathSmash(target)
	if(!can_act)
		return
	can_act = FALSE
	var/list/turf/hit_turfs = list()
	playsound(src, 'sound/abnormalities/wrath_servant/enrage.ogg', 75, FALSE, 20, falloff_distance = 10)
	manual_emote("raises a hammer!")
	var/list/show_area = list()
	show_area |= range(7, src)
	show_area |= view(9, src)
	for(var/turf/sT in show_area)
		new /obj/effect/temp_visual/cult/sparks(sT)
	SLEEP_CHECK_DEATH(1 SECONDS)
	for(var/x = 1 to 3)
		var/list/been_hit = list()
		playsound(src, "sound/abnormalities/wrath_servant/big_smash[x].ogg", 75, FALSE, 20, falloff_distance = 10) // heard from a distance
		for(var/i = 1 to 8)
			if(i < 4)
				hit_turfs = (range(i, src) - range(i-1, src)) // Ignores walls for first 3
				if(i == 1)
					hit_turfs += get_turf(src)
			else
				hit_turfs = (view(i, src) - range(i-1, src)) // Respects walls for last 2
			for(var/turf/T in hit_turfs)
				been_hit = HurtInTurf(T, been_hit, smash_damage, smash_damage_type, null, TRUE, FALSE, TRUE, FALSE, TRUE, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
				new /obj/effect/temp_visual/kinetic_blast(T)
				if(prob(10))
					new /obj/effect/gibspawner/generic/silent/wrath_acid/bad/nihil(T)
			SLEEP_CHECK_DEATH(1)
		for(var/mob/living/L in been_hit)
			L.apply_void(10)
	icon_state = icon_living
	can_act = TRUE

//Stages/Boss mechanics
/mob/living/simple_animal/hostile/abnormality/nihil/proc/GirlCheck(mob/living/themob)
	if(themob.type in girl_types)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/nihil/proc/ChangePhase()
	if(!event_started) // Does not change the phase from the default "Nihil" phase
		return
	if(LAZYLEN(minion_list))
		for(var/newmob in minion_list)
			qdel(newmob)
	var/new_phase = pick(all_phases)
	all_phases -= new_phase
	current_phase = new_phase
	switch(current_phase)
		if("NIHIL")
			casingtype = initial(casingtype)
			projectilesound = 'sound/abnormalities/wrath_servant/hermit_magic.ogg'
			ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5))
		if("HATE")
			casingtype = /obj/item/ammo_casing/caseless/nihil_hatred
			projectilesound = 'sound/abnormalities/hatredqueen/attack.ogg'
			current_special_attack = PROC_REF(HatredBeam)
			special_cooldown_time = 40 SECONDS
			ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.8))

		if("GREED")
			casingtype = null // Projectiles are not fired in this phase.
			current_special_attack = PROC_REF(GreedBlink)
			special_cooldown_time = 60 SECONDS
			ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8))

		if("DESPAIR")
			current_special_attack = PROC_REF(DespairGuard)
			special_cooldown_time = 30 SECONDS
			ChangeResistances(list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.3))
			var/delay_timer = 3 SECONDS
			if(!can_act)
				delay_timer = 6 SECONDS // Usually this means that despair was the first phase, so lets give nukeattack time to fire.
			addtimer(CALLBACK(src, PROC_REF(SpawnDespairSwords)), delay_timer)

		if("WRATH")
			casingtype = /obj/item/ammo_casing/caseless/nihil_wrath
			projectilesound = 'sound/abnormalities/wrath_servant/hermit_attack.ogg'
			current_special_attack = PROC_REF(WrathSmash)
			special_cooldown_time = 20 SECONDS
			ChangeResistances(list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.8))
	special_cooldown = world.time // Reset special attack timer
	if(!current_phase || current_phase == "NIHIL")
		return
	for(var/mob/player in GLOB.player_list)
		if(player.client)
			var/client/watcher = player.client
			ShowPhaseChange(watcher, current_phase)
			player.playsound_local(player, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/SpecialAttack()
	if(!current_special_attack)
		return
	if(!can_act)
		return
	if(special_cooldown >= world.time)
		return
	if(!target)
		return
	special_cooldown = world.time + special_cooldown_time
	. = call(src, current_special_attack)(target)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/ShowPhaseChange(client/C, phase, screen_location = "Center,Center")
	if(!C)
		return
	var/obj/effect/overlay/T = new()
	T.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	T.icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	T.icon_state = "[phase]"
	T.alpha = 200
	T.icon_w = -4
	T.icon_z = 8
	T.layer = FLOAT_LAYER
	T.plane = HUD_PLANE
	T.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	T.screen_loc = screen_location
	T.transform = matrix()*10
	C.screen += T
	animate(T, transform = matrix()*12,alpha = 140, time = 10)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_blurb), C, T, 5), 15) //fade_blurb qdels the object
