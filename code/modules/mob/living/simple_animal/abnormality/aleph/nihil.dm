#define STATUS_EFFECT_VOID /datum/status_effect/stacking/void
//Coded by Coxswain, sprites by nutterbutter
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
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5) //change on phase
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
	// Special Attacks
	var/nuke_max_damage = 300
	var/nuke_min_damage = 15
	var/busy_attacking = FALSE //Prevents can_act from being set to true while performing a forced action
	// Greed phase dash
	var/rush_num = 10 // the length of the dash, in tiles
	var/rush_cooldown = 0
	var/rush_cooldown_time = 5 SECONDS
	var/rush_damage = 50
	var/list/rush_hit_list = list()
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

//TODO: Make this do something - make this survive the gold road attack
/obj/structure/blissfragment
	name = "brilliant bliss"
	desc = "It looks like a large gemstone. Break it for a special buff."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bliss"

//Work Code
/mob/living/simple_animal/hostile/abnormality/nihil/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)
	return

/mob/living/simple_animal/hostile/abnormality/nihil/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

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

/mob/living/simple_animal/hostile/abnormality/nihil/proc/OnGirlGoneWild() //TODO: This will lower qliphoth when friendly magical girls turn hostile!
	datum_reference.qliphoth_change(-2)

//Attacks
/mob/living/simple_animal/hostile/abnormality/nihil/proc/AreaAttack() //Replaces normal attack
	set waitfor = FALSE
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
			L.apply_void(3)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/NukeAttack() //Phase-change attack with a long cooldown
	if(!can_act || busy_attacking)
		addtimer(CALLBACK(src, PROC_REF(NukeAttack)), 10)
		return FALSE
	can_act = FALSE
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
		L.apply_void(damage_mod / 5) //inflict a void debuff
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
			for(var/i = 1 to 10)
				if(LAZYLEN(target_list))
					FindTarget(list(pick(target_list)), TRUE)
				if(!target || QDELETED(target))
					return
				var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
				if(T.density)
					i -= 1
					continue
				var/obj/effect/projectile_delayed/projectile_handler = new(T)
				var/obj/projectile/despair_rapier/P = new(projectile_handler)
				projectile_handler.projectile = P
				P.starting = T
				P.firer = src
				P.fired_from = T
				P.yo = target.y - T.y
				P.xo = target.x - T.x
				P.original = target
				P.preparePixelProjectile(target, T)
				projectile_handler.StartFiring(30)
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
			animate(src, alpha = 0,pixel_x = 0, pixel_z = 16, time = 0)
			src.pixel_z = 16
			animate(src, alpha = 255,pixel_x = 0, pixel_z = -16, time = 20)
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
	if(!phase_health)
		return
	if(damage_taken >= phase_health)
		damage_taken -= phase_health
		if(!all_phases.len)
			StartEnding()
			return
		ChangePhase()

/mob/living/simple_animal/hostile/abnormality/nihil/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	. = AreaAttack()

/mob/living/simple_animal/hostile/abnormality/nihil/OpenFire(atom/A)
	if(!can_act || IsContained())
		return
	if(get_dist(src, target) < 3) //Prevents ranged attack when flinching
		return
	if(current_phase == "GREED")
		if(rush_cooldown <= world.time)
			rush_cooldown = world.time + rush_cooldown_time
			var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
			can_act = FALSE
			Rush(dir_to_target, 0, target)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/nihil/proc/Rush(move_dir, times_ran, target)
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
			L.throw_at(throw_target, 3, 2)
			for(var/obj/vehicle/V in new_hits)
				V.take_damage(rush_damage, RED_DAMAGE, attack_sound)
				V.visible_message(span_boldwarning("[src] crunches [V]!"))
				playsound(V, 'sound/weapons/genhit2.ogg', 75, 1)
			continue

	playsound(src,'sound/effects/bamf.ogg', 40, TRUE, 20)
	for(var/turf/open/R in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(R)
	addtimer(CALLBACK(src, PROC_REF(Rush), move_dir, (times_ran + 1)), 2)

/mob/living/simple_animal/hostile/abnormality/nihil/Move()
	if(!can_act)
		return FALSE
	return ..()

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
		if("HATE")
			casingtype = /obj/item/ammo_casing/caseless/nihil_hatred
			projectilesound = 'sound/abnormalities/hatredqueen/attack.ogg'
		if("GREED")
			casingtype = null // Projectiles are not fired in this phase.
		if("DESPAIR")
			casingtype = /obj/item/ammo_casing/caseless/nihil_despair
			projectilesound = 'sound/abnormalities/despairknight/attack.ogg'
			for(var/i = 1 to 3)
				var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
				if(!isopenturf(dispense_turf))
					dispense_turf = get_turf(src)
				var/mob/living/simple_animal/hostile/aminion/despair_sword/newmob = new(dispense_turf)
				newmob.friend = src
				minion_list += newmob

		if("WRATH")
			casingtype = /obj/item/ammo_casing/caseless/nihil_wrath
			projectilesound = 'sound/abnormalities/wrath_servant/hermit_attack.ogg'

	if(!current_phase || current_phase == "NIHIL")
		return
	for(var/mob/player in GLOB.player_list)
		if(player.client)
			var/client/watcher = player.client
			ShowPhaseChange(watcher, current_phase)
			player.playsound_local(player, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)

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

/mob/living/simple_animal/hostile/abnormality/nihil/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if(current_phase != "GREED")
		return ..()
	 // Greed gets bullet reflect. Maybe change this later?
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

/mob/living/simple_animal/hostile/abnormality/nihil/proc/StartEnding()
	//TODO: Eventually maybe make a ending cutscene? For now just end it.
	death_ready = TRUE

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

	for(var/obj/structure/statue/petrified/magicalgirl/StoneStatue in world) //Break any statues that are still up
		StoneStatue.Destroy()

	if(girlpower >= 4) //Bonus doubled reward if all 4 of the girls were present
		for(var/path in subtypesof(/obj/item/nihil))
			new path(get_turf(src))
	SSticker.superbosses |= initial(name)
	SSlobotomy_events.PruneList(event_type = 3) //End the event TODO: Visuals and stuff I guess?
	..()

/mob/living/simple_animal/hostile/abnormality/nihil/Destroy()
	if(LAZYLEN(minion_list))
		for(var/newmob in minion_list)
			qdel(newmob)
	. = ..()

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
	var/list/potential_spawns
	var/mob/living/simple_animal/hostile/aminion/nihil_portal/portal
	for(var/turf/T in GLOB.department_centers)
		if(istype(get_area(T),/area/department_main/command))
			for(var/mob/living/simple_animal/hostile/aminion/forest_portal/FP in T.contents) // Prevents breaching on top of apocalypse bird
				potential_spawns = GLOB.department_centers.Copy()
				potential_spawns -= T
				continue
			portal = new(T)
			break
	if(!portal)
		var/turf/T = pick(GLOB.department_centers)
		portal = new(T)
	AIStatus = AI_OFF
	environment_smash = ENVIRONMENT_SMASH_NONE // This along with AI_OFF is needed to keep mobs tame while inside the contents of a structure.
	portal.owner = src
	forceMove(portal)

// Portal/Event code
/mob/living/simple_animal/hostile/aminion/nihil_portal
	name = "Portal to the Void"
	desc = "A portal leading an evil villain to this world, it doesn't seem to be open yet..."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "curse"
	pixel_x = -16
	base_pixel_x = -16
	layer = LARGE_MOB_LAYER
	faction = list("Nihil", "hostile")
	maxHealth = 15000
	health = 15000
	gender = NEUTER
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	mob_size = MOB_SIZE_HUGE
	del_on_death = TRUE
	threat_level = ALEPH_LEVEL
	fear_level = 0
	can_affect_emergency = FALSE
	var/list/portal_types = list(
		/obj/effect/magical_girl_portal/heart,
		/obj/effect/magical_girl_portal/spade,
		/obj/effect/magical_girl_portal/diamond,
		/obj/effect/magical_girl_portal/club
	)
	var/list/active_portals = list()
	var/mob/living/simple_animal/hostile/abnormality/nihil/owner = null

/mob/living/simple_animal/hostile/aminion/nihil_portal/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/aminion/nihil_portal/Move()
	return FALSE

/mob/living/simple_animal/hostile/aminion/nihil_portal/Initialize()
	. = ..()
	SSlobotomy_events.AddNihilMobs()
	for(var/mob/M in GLOB.player_list) //vfx
		if(M.z == z && M.client)
			flash_color(M, flash_color = "#CCBBBB", flash_time = 50)
			shake_camera(M, 30, 2)
	for(var/area/A in world)
		for(var/obj/machinery/light/L in A)
			L.flicker(10)

	playsound(src, 'sound/abnormalities/hatredqueen/dead.ogg', 100, FALSE, 40, falloff_distance = 10) //Play a weird sound
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "How is the situation in your branch? We've got a disaster on our hands!", 25))
	addtimer(CALLBACK(src, PROC_REF(SpawnPortals)), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(StartEvent)), 30 SECONDS)

/mob/living/simple_animal/hostile/aminion/nihil_portal/proc/SpawnPortals()
	set waitfor = FALSE
	SSlobotomy_events.AddNihilMobs() //Assuming a magical girl is added to the facility now, this is the last chance they get to count for the event
	for(var/dir in GLOB.diagonals) //Spawn the portals
		if(QDELETED(src))
			return
		var/turf/T = get_step(get_step(src, dir), dir)
		var/theportal = pick_n_take(portal_types)
		new theportal(T)
		active_portals += theportal
		sleep(10)
	ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.4))

/mob/living/simple_animal/hostile/aminion/nihil_portal/proc/DeletePortals()
	for(var/obj/effect/magical_girl_portal/theportal in range(2, src))
		qdel(theportal)

/mob/living/simple_animal/hostile/aminion/nihil_portal/proc/StartEvent()
	DeletePortals()
	var/list/phase_list = list()
	var/total_phases = 0
	var/newphase = null
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "Life, Dreams, Hope, where do they come from? And where will they go?", 25))
	for(var/mob/living/simple_animal/hostile/abnormality/nihil/jester in contents)
		jester.forceMove(get_turf(src))
		jester.AIStatus = AI_ON
		jester.environment_smash = ENVIRONMENT_SMASH_STRUCTURES
		jester.teleport_cooldown = world.time + 30 SECONDS //So they don't teleport right away
		jester.can_act = TRUE
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) // Count phases for nihil
		if(!is_type_in_list(A, SSlobotomy_events.JN_breached))
			continue
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/wrath_servant))
			newphase = "WRATH"
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/hatred_queen))
			newphase = "HATE"
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/despair_knight))
			newphase = "DESPAIR"
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/greed_king))
			newphase = "GREED"
		phase_list += newphase
		total_phases += 1
	if(owner)
		owner.all_phases += phase_list
		switch(total_phases)
			if(2)
				owner.maxHealth = 5000
			if(3)
				owner.maxHealth = 7500
			if(4)
				owner.maxHealth = 10000
			else
				log_game("FailSafe: Nihil loaded with an incorrect number of phases. Using base behavior as a failsafe.")
				to_chat(GLOB.admins, span_boldannounce("ERROR: The Jester of Nihil has an invalid number of phases (Should be 2-4). Phases numbered at [total_phases]."))
		owner.adjustHealth(-maxHealth)
		var/phase_mult = (1 / total_phases)
		owner.phase_health = (owner.maxHealth * phase_mult)
		owner.ChangePhase()
		owner.NukeAttack(TRUE)
	qdel(src)

/mob/living/simple_animal/hostile/aminion/nihil_portal/death(gibbed)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "The crisis has been averted.", 25))
	DeletePortals()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //delete the magical girls cause they won
		if(!is_type_in_list(A, SSlobotomy_events.JN_breached))
			continue
		qdel(A)
	SSlobotomy_events.PruneList(event_type = 3)
	return ..()

/obj/effect/magical_girl_portal
	name = "Magical Portal"
	desc = "Where does it go?"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal1"
	light_range = 3
	light_power = 2
	light_color = null
	light_on = TRUE
	var/magical_girl = null

/obj/effect/magical_girl_portal/Initialize()
	. = ..()
	SpawnGirl()

/obj/effect/magical_girl_portal/proc/SpawnGirl()
	set waitfor = FALSE
	var/turf/landing_turf
	var/turf/target_turf
	for(var/mob/living/simple_animal/hostile/aminion/nihil_portal/summonpoint in range(2,src))
		target_turf = get_turf(summonpoint)
		landing_turf = get_step_towards(src, summonpoint)

	for(var/datum/abnormality/B in SSlobotomy_corp.all_abnormality_datums)
		if(!ispath(B.abno_path, magical_girl))
			continue
		if(B.current)
			qdel(B.current) // Make sure its gone
		B.RespawnAbno()
		var/mob/living/simple_animal/hostile/abnormality/greed_king/girltarget = B.current
		girltarget.EventStart()
		girltarget.BreachEffect()
		girltarget.toggle_ai(AI_OFF)
		girltarget.environment_smash = ENVIRONMENT_SMASH_NONE
		girltarget.forceMove(landing_turf)
		girltarget.face_atom(target_turf)
		playsound(girltarget, 'sound/abnormalities/hatredqueen/attack.ogg', 60, TRUE, 10)

/obj/effect/magical_girl_portal/heart
	magical_girl = /mob/living/simple_animal/hostile/abnormality/hatred_queen
	light_color = "#FE5BAC"
	color = "#FE5BAC"

/obj/effect/magical_girl_portal/spade
	magical_girl = /mob/living/simple_animal/hostile/abnormality/despair_knight
	light_color = "#371F76"
	color = "#371F76"

/obj/effect/magical_girl_portal/diamond
	magical_girl = /mob/living/simple_animal/hostile/abnormality/greed_king
	light_color = "#FFD700"
	color = "#FFD700"

/obj/effect/magical_girl_portal/club
	magical_girl = /mob/living/simple_animal/hostile/abnormality/wrath_servant
	light_color = "#CC7722"
	color = "#CC7722"

/mob/living/simple_animal/hostile/aminion/despair_sword
	name = "Sword without an Owner"
	desc = "A sword laced with grief."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "despair_sword"
	icon_living = "despair_sword"
	icon_dead = "despair_sword_dead"
	gender = NEUTER
	maxHealth = 400
	health = 400
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 10
	melee_reach = 3 // Will try to attack from this distance
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/weapons/ego/rapier1.ogg'
	death_sound = 'sound/abnormalities/despairknight/dead.ogg'
	is_flying_animal = TRUE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)
	var/charge_ready = TRUE
	var/charging
	var/revving_charge = FALSE
	var/charge_damage = 10
	var/charge_attack_cooldown = 0
	var/charge_attack_cooldown_time = 1 SECONDS
	var/charge_attack_delay = 8
	var/charging_speed = 0.6
	var/mob/living/simple_animal/hostile/abnormality/friend
	var/protect_cooldown_time = 20 SECONDS
	var/protect_cooldown

/mob/living/simple_animal/hostile/aminion/despair_sword/Life()
	. = ..()
	if(stat == DEAD) //for some reason life() works on death ain't that something
		return
	if(protect_cooldown < world.time)
		protect_cooldown = world.time + protect_cooldown_time
		if(!can_see(src, friend, vision_range))
			GoToFriend()

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/GoToFriend()
	if(!friend)
		return
	var/turf/origin = get_turf(friend)
	var/list/all_turfs = RANGE_TURFS(2, origin)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		var/available_turf
		var/list/friend_line = getline(T, friend)
		for(var/turf/line_turf in friend_line) //checks if there's a valid path between the turf and the friend
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				available_turf = FALSE
				break
			available_turf = TRUE
		if(!available_turf)
			continue
		playsound(src, 'sound/abnormalities/despairknight/gift.ogg', 50, FALSE, 4)
		forceMove(T)
		LoseTarget()
		for(var/mob/living/carbon/human/enemy in oview(src, vision_range))
			if(enemy.stat != DEAD)
				GiveTarget(enemy) //the moment he teleports he's already on the offensive
				break
		return

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/Regenerate()
	anchored = FALSE //so it can't be knocked away from his stunned effect
	if(friend)
		density = TRUE
		revive(full_heal = TRUE, admin_revive = TRUE)
		GoToFriend()
		return
	animate(src, alpha = 0, time = 3 SECONDS)
	QDEL_IN(src, 3 SECONDS)

/mob/living/simple_animal/hostile/aminion/despair_sword/death()
	density = FALSE
	anchored = TRUE
	if(friend)
		addtimer(CALLBACK(src, PROC_REF(Regenerate)), 20 SECONDS)
	else
		animate(src, alpha = 0, time = 10 SECONDS)
		QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/aminion/despair_sword/AttackingTarget(atom/attacked_target)
	if(revving_charge || charging)
		return
	if(charge_attack_cooldown <= world.time && charge_ready && !attacked_target.Adjacent(targets_from))
		Charge(chargeat = attacked_target, delay = (charge_attack_delay))
		return
	. = ..()

/mob/living/simple_animal/hostile/aminion/despair_sword/Goto(target, delay, minimum_distance)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/aminion/despair_sword/MoveToTarget(list/possible_targets)
	if(revving_charge || charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/aminion/despair_sword/Move()
	if(revving_charge)
		return FALSE
	if(charging)
		DestroySurroundings() //to break tables ssin the way
	return ..()

//charge code
/mob/living/simple_animal/hostile/aminion/despair_sword/proc/Charge(atom/chargeat = target, delay = 1 SECONDS, chargepast = 2)
	if(stat == DEAD)
		return
	if(charge_attack_cooldown > world.time || charging || revving_charge)
		return
	if(!chargeat)
		return
	face_atom(chargeat)
	var/turf/T = get_ranged_target_turf(chargeat, dir, chargepast)
	if(!T)
		return
	var/turf/chargeturf = get_turf(chargeat)
	if(chargeturf) //for some reason this can end up being null
		new /obj/effect/temp_visual/cult/sparks(chargeturf) //in case the big effect is behind a wall
	revving_charge = TRUE
	charge_ready = FALSE
	walk(src, 0)
	playsound(src, 'sound/abnormalities/despairknight/attack.ogg', 75, FALSE)
	var/angle_to_target = Get_Angle(src, target)
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "despair"
	var/matrix/matrix = new
	matrix.Turn(angle_to_target)
	transform = matrix
	SLEEP_CHECK_DEATH(delay)
	if(!revving_charge) //to end charges prematurely
		EndCharge()
		return
	charging = TRUE
	revving_charge = FALSE
	walk_towards(src, T, charging_speed)
	SLEEP_CHECK_DEATH(get_dist(src, T) * charging_speed)
	EndCharge()

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/EndCharge(bump = FALSE)
	if(!charging)
		return
	charging = FALSE
	revving_charge = FALSE
	walk(src, 0) // cancel the movement
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "despair_sword"
	var/matrix/matrix = new
	transform = matrix
	ResetCharge()

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/ResetCharge()
	charge_attack_cooldown = world.time + charge_attack_cooldown_time
	charge_ready = TRUE //redundancy is good

/mob/living/simple_animal/hostile/aminion/despair_sword/Bump(atom/A)
	if(charging)
		if(isliving(A))
			var/mob/living/L = A
			if(!faction_check_mob(L))
				do_attack_animation(L, ATTACK_EFFECT_SLASH)
				L.deal_damage(charge_damage, melee_damage_type, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
				if(L.health < 0)
					L.gib()
					playsound(src, 'sound/abnormalities/despairknight/attack.ogg', 75, 1)
				else
					playsound(src, attack_sound, 125, 1)
				EndCharge(TRUE)
				ResetCharge()
		else if(isvehicle(A))
			var/obj/vehicle/V = A
			V.take_damage(charge_damage*1.5, melee_damage_type)
			for(var/mob/living/occupant in V.occupants)
				to_chat(occupant, span_userdanger("Your [V.name] is slashed by [src]!"))
			EndCharge(FALSE)
	return ..()

// Object effect
/obj/effect/temp_visual/greed_shield
	name = "greed_shield"
	desc = "A shimmering forcefield protecting the Jester of Nihil."
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield1"
	layer = FLY_LAYER
	light_system = MOVABLE_LIGHT
	light_range = 2
	duration = 8

/obj/effect/decal/cleanable/wrath_acid/bad/nihil
	safe_types = list(/mob/living/simple_animal/hostile/abnormality/nihil)
	applied_status = /datum/status_effect/wrath_burning/nihil
	damage_dealt = 4

/datum/status_effect/wrath_burning/nihil
	id = "wrath_burning_nihil"
	converts = FALSE
	damage_dealt = 2

/obj/effect/gibspawner/generic/silent/wrath_acid/bad/nihil
	gibtypes = list(/obj/effect/decal/cleanable/wrath_acid/bad/nihil)

//Void Status effect
//Decrease everyone's attributes.
/datum/status_effect/stacking/void
	id = "stacking_void"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20 SECONDS
	alert_type = null
	stack_decay = 0
	stacks = 1
	max_stacks = 13
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/void
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/void
	name = "Void"
	desc = "You are empty inside."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "nihil"

/datum/status_effect/stacking/void/on_apply()
	. = ..()
	to_chat(owner, span_warning("The whole world feels dark and empty..."))
	if(owner.client)
		owner.add_client_colour(/datum/client_colour/monochrome)
	owner.deal_damage(stacks, PALE_DAMAGE)

/datum/status_effect/stacking/void/add_stacks(stacks_added)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -5 * stacks_added)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -5 * stacks_added)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -5 * stacks_added)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -5 * stacks_added)

/datum/status_effect/stacking/void/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 5 * stacks)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 5 * stacks)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 5 * stacks)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 5 * stacks)
	to_chat(owner, span_nicegreen("You feel normal again."))
	if(owner.client)
		owner.remove_client_colour(/datum/client_colour/monochrome)

//Items - Loot
/obj/item/nihil
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	desc = "A playing card that seems to resonate with certain E.G.O."
	var/special

/obj/item/nihil/examine(mob/user)
	. = ..()
	if(special)
		. += span_notice("[special]")

/obj/item/nihil/heart
	name = "ace of hearts"
	icon_state = "nihil_heart"
	special = "Someone has to be the villain..."

/obj/item/nihil/spade
	name = "ace of spades"
	icon_state = "nihil_spade"
	special = "If I can't protect others, I may as well disappear..."

/obj/item/nihil/diamond
	name = "ace of diamonds"
	icon_state = "nihil_diamond"
	special = "I feel empty inside... Hungry. I want more things!"

/obj/item/nihil/club
	name = "ace of clubs"
	icon_state = "nihil_club"
	special = "Sinners of the otherworlds! Embodiments of evil!!!"

//Petrified statue code for the magical girls
/obj/structure/statue/petrified/magicalgirl
	name = "magical girl statue"
	desc = "A petrified magical girl."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	density = FALSE // So they dont get in the way of stuff.
	var/list/girl_types = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,
		/mob/living/simple_animal/hostile/abnormality/despair_knight,
		/mob/living/simple_animal/hostile/abnormality/greed_king
	)

//Mob Proc
/mob/living/proc/apply_void(stacks)
	var/datum/status_effect/stacking/void/V = src.has_status_effect(/datum/status_effect/stacking/void)
	if(!V)
		src.apply_status_effect(STATUS_EFFECT_VOID)
		if(stacks <= 1)
			return
		var/datum/status_effect/stacking/void/G = src.has_status_effect(/datum/status_effect/stacking/void)
		SLEEP_CHECK_DEATH(1) //Prevent runtimes
		G.add_stacks(stacks - 1)
	else
		V.add_stacks(stacks)
		V.refresh()
		playsound(src, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)

#undef STATUS_EFFECT_VOID
