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
	maxHealth = 15000
	health = 15000
	move_to_delay = 4
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_INSIGHT = 0, //He's the fool Tarot
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 30, 35, 45),
	)
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5) //change on phase
	melee_damage_lower = 40
	melee_damage_upper = 55
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 20
	work_damage_type = WHITE_DAMAGE
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

	var/can_act = TRUE
	//Teleports
	var/icon_inverted
	var/teleport_cooldown
	var/teleport_cooldown_time = 60 SECONDS
	var/explode_damage = 120
	//Phases
	var/current_phase
	var/death_ready = TRUE
	var/event_enabled
	//Attacks
	var/nuke_cooldown
	var/nuke_cooldown_time = 5 MINUTES //Once per phase goes off every 5 minutes otherwise
	var/nuke_damage = 500
	var/busy_attacking = FALSE //Prevents can_act from being set to true while performing a forced action

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
	var/list/quotes = list(
		"Everybody's agony becomes one.",
		"I slowly traced the road back. It's the road you would've taken.",
		"Where is the right path? Where do I go?",
		"Where is the bright dog when I need it to lead me?",
		"Leading the way through foolishness, there's not a thing to guide me.",
		"All I can do is trust my own intuition.",
		"I look just like them, and they look just like me when they're together.",
		"I become more fearless as they become more vacant.",
		"My mind is a void; my thoughts are empty.",
		"In the end, all returns to nihil.",
	)

	// Prevents spawning in normal game modes
	can_spawn = FALSE

//Work Code
/mob/living/simple_animal/hostile/abnormality/nihil/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)
	return

/mob/living/simple_animal/hostile/abnormality/nihil/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/nihil/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_type = WHITE_DAMAGE
	switch(work_type)
		if(ABNORMALITY_WORK_REPRESSION)
			work_damage_type = BLACK_DAMAGE
	return ..()

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

/mob/living/simple_animal/hostile/abnormality/nihil/proc/OnGirlGoneWild() //TODO: This will lower qliphoth when friendly magical girls turn hostile
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
		for(var/mob/living/L in HurtInTurf(T, list(), damage_dealt, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			if(GirlCheck(L)) //EXTRA magical girl damage to kill them faster
				L.deal_damage((2 * damage_dealt), BRUTE)
	SLEEP_CHECK_DEATH(8)
	playsound(src, 'sound/abnormalities/wrath_servant/hermit_attack_hard.ogg', 25, FALSE, 15, falloff_distance = 5)
	new /obj/effect/temp_visual/voidout(myturf)
	for(var/turf/T in range(1, myturf)) //Second hit is avoidable but deals 3x damage
		for(var/mob/living/L in HurtInTurf(T, list(), (3 * damage_dealt), BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			L.apply_void(3)
			if(GirlCheck(L)) //EXTRA magical girl damage to kill them faster
				L.deal_damage((3 * damage_dealt), BRUTE)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/NukeAttack(forced) //Phase-change attack with a long cooldown
	if(nuke_cooldown > world.time && !forced)
		return FALSE
	if(!can_act && !forced)
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
	for(var/mob/living/L in livinginrange(25, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		var/dist = get_dist(src, L)
		var/damage_mod = (dist > 7 ? 5 : 20 )
		L.deal_damage(clamp((damage_mod * (25 - dist)), 15, nuke_damage), BLACK_DAMAGE) //Between 500 and 15 damage, scaling down heavily past a distance of 7 tiles
		flash_color(L, flash_color = COLOR_ALMOST_BLACK, flash_time = 70)
		L.apply_void(damage_mod / 5) //inflict a void debuff
		if(GirlCheck(L)) //This should kill them most of the time if they are too close
			L.deal_damage((100 * damage_mod), BRUTE)
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)
	addtimer(CALLBACK(src, PROC_REF(NukeAttack)), 5 MINUTES)
	nuke_cooldown = world.time + nuke_cooldown_time
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
				for(var/mob/living/H in HurtInTurf(T, list(), (0.5 * explode_damage), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
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
					target = pick(target_list)
				if(!target)
					return
				var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
				if(T.density)
					i -= 1
					continue
				var/obj/projectile/despair_rapier/P
				P = new(T)
				P.starting = T
				P.firer = src
				P.fired_from = T
				P.yo = target.y - T.y
				P.xo = target.x - T.x
				P.original = target
				P.preparePixelProjectile(target, T)
				addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), 30)
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
				HurtInTurf(T, list(), explode_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
				new /obj/effect/temp_visual/kinetic_blast(T)
				if(prob(95))
					new /obj/effect/decal/cleanable/wrath_acid/bad(T)
				else
					new /obj/effect/gibspawner/generic/silent/wrath_acid/bad(T)

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
				for(var/mob/living/H in HurtInTurf(T, list(), (2 * explode_damage), RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
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
				HurtInTurf(T, list(), explode_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
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
	if(!event_enabled)
		return
	if(.)
		if(!can_act) //Cannot currently teleport or change phase
			return
		switch(current_phase)
			if("NIHIL")
				if(maxHealth*0.8 > health)
					ChangePhase("GREED")
					return
			if("GREED")
				if(maxHealth*0.6 > health)
					ChangePhase("HATE")
					return
			if("HATE")
				if(maxHealth*0.4 > health)
					ChangePhase("DESPAIR")
					return
			if("DESPAIR")
				if(maxHealth*0.2 > health)
					ChangePhase("WRATH")
					return
			if("WRATH")
				if(maxHealth*0.05 > health)
					StartEnding()
					return
		if(teleport_cooldown <= world.time)
			INVOKE_ASYNC(src, PROC_REF(TryTeleport))
		return

/mob/living/simple_animal/hostile/abnormality/nihil/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	. = AreaAttack()

/mob/living/simple_animal/hostile/abnormality/nihil/OpenFire()
	if(!can_act || IsContained())
		return
	if(get_dist(src, target) > 4) //Prevents ranged attack when flinching
		return
	..()

/mob/living/simple_animal/hostile/abnormality/nihil/Move()
	if(!can_act)
		return FALSE
	return ..()

//Stages/Boss mechanics
/mob/living/simple_animal/hostile/abnormality/nihil/proc/GirlCheck(mob/living/themob) //I was temped to call this something cursed, but I won't.
	if(themob.type in girl_types)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/nihil/proc/ChangePhase(phase)
	//TODO: more stuff
	current_phase = phase
	NukeAttack(TRUE)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/StartEnding()
	//TODO: more stuff
	current_phase = null
	death_ready = TRUE
	can_act = FALSE

/mob/living/simple_animal/hostile/abnormality/nihil/death(gibbed)
	if(!death_ready)
		return
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	if(!event_enabled) //admin spawned
		return ..()
	var/girlpower = 0
	for(var/obj/structure/statue/petrified/magicalgirl/StoneStatue in world) //Break any statues that are still up
		StoneStatue.Destroy()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //Delete the girls and spawn the loots
		if(!is_type_in_list(A, SSlobotomy_events.JN_breached))
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
		var/mob/living/simple_animal/hostile/abnormality/greed_king/girltarget = A //It shouldn't really matter which one is instanced here
		girltarget.nihil_present = FALSE //So they really die... maybe change this to a cutscene proc instead in the future
		girltarget.death()
		girlpower += 1

	if(girlpower >= 4) //Bonus doubled reward if all 4 of the girls were present
		for(var/path in subtypesof(/obj/item/nihil))
			new path(get_turf(src))
	SSlobotomy_events.PruneList(event_type = 3) //End the event TODO: Visuals and stuff I guess?
	..()

//Breach
/mob/living/simple_animal/hostile/abnormality/nihil/ZeroQliphoth(mob/living/carbon/human/user)
	var/counter = 0
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if(!GirlCheck(A))
			continue
		counter += 1
	if(counter < 2)
		Debuff(0, FALSE)
	else
		Debuff(0, TRUE)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/Debuff(attack_count,event_start)
	if(attack_count > 13)
		datum_reference.qliphoth_change(3)
		return
	if(!attack_count)
		sound_to_playing_players_on_level("sound/abnormalities/nihil/attack.ogg", 30, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		L.apply_void(1)
		if(attack_count < 8 && attack_count) //having an index at 0 will break it
			to_chat(L, span_warning("[quotes[attack_count]]"))
		else
			to_chat(L, span_warning("[quotes[10]]"))
	if(attack_count == 10)
		if(event_start)
			BreachEffect()
			return
		else
			SSlobotomy_corp.InitiateMeltdown((SSlobotomy_corp.all_abnormality_datums.len), TRUE)
	SLEEP_CHECK_DEATH(4 SECONDS)
	attack_count += 1
	Debuff(attack_count, event_start)

/mob/living/simple_animal/hostile/abnormality/nihil/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	event_enabled = TRUE //We're not admin spawned
	death_ready = FALSE
	can_act = FALSE
	var/list/potential_spawns
	var/mob/living/simple_animal/nihil_portal/portal
	for(var/turf/T in GLOB.department_centers)
		if(istype(get_area(T),/area/department_main/command))
			for(var/mob/living/simple_animal/forest_portal/FP in T.contents) // Prevents breaching on top of apocalypse bird
				potential_spawns = GLOB.department_centers.Copy()
				potential_spawns -= T
				continue
			portal = new(T)
			break
	if(!portal)
		var/turf/T = pick(GLOB.department_centers)
		portal = new(T)
	AIStatus = AI_OFF
	forceMove(portal)

// Portal/Event code
/mob/living/simple_animal/nihil_portal
	name = "Portal to the Void"
	desc = "A portal leading an evil villain to this world, it doesn't seem to be open yet..."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "curse"
	pixel_x = -16
	base_pixel_x = -16
	layer = LARGE_MOB_LAYER
	faction = list("Nihil", "hostile")
	maxHealth = 30000
	health = 30000
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	mob_size = MOB_SIZE_HUGE
	del_on_death = TRUE
	var/list/portal_types = list(
		/obj/effect/magical_girl_portal/heart,
		/obj/effect/magical_girl_portal/spade,
		/obj/effect/magical_girl_portal/diamond,
		/obj/effect/magical_girl_portal/club
	)
	var/list/active_portals = list()

/mob/living/simple_animal/nihil_portal/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/nihil_portal/Move()
	return FALSE

/mob/living/simple_animal/nihil_portal/Initialize()
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

/mob/living/simple_animal/nihil_portal/proc/SpawnPortals()
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

/mob/living/simple_animal/nihil_portal/proc/DeletePortals()
	for(var/obj/effect/magical_girl_portal/theportal in range(2, src))
		qdel(theportal)

/mob/living/simple_animal/nihil_portal/proc/StartEvent()
	DeletePortals()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "Life, Dreams, Hope, where do they come from? And where will they go?", 25))
	for(var/mob/living/simple_animal/hostile/abnormality/nihil/jester in contents)
		jester.forceMove(get_turf(src))
		jester.AIStatus = AI_ON
		jester.teleport_cooldown = world.time + 30 SECONDS //So they don't teleport right away
		jester.can_act = TRUE
		addtimer(CALLBACK(jester, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality/nihil, ChangePhase), "NIHIL"), 5 SECONDS)
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //enable their AI again
		if(!is_type_in_list(A, SSlobotomy_events.JN_breached))
			continue
		A.toggle_ai(AI_ON)
	qdel(src)

/mob/living/simple_animal/nihil_portal/death(gibbed)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "The crisis has been averted.", 25))
	DeletePortals()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //delete the magical girls cause they won
		if(!is_type_in_list(A, SSlobotomy_events.JN_breached))
			continue
		qdel(A)
	SSlobotomy_events.PruneList(event_type = 3)
	return

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
	for(var/mob/living/simple_animal/nihil_portal/summonpoint in range(2,src))
		target_turf = get_turf(summonpoint)
		landing_turf = get_step_towards(src, summonpoint)

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //breach the girls
		if(!istype(A, magical_girl))
			continue
		var/mob/living/simple_animal/hostile/abnormality/greed_king/girltarget = A //It shouldn't really matter which one is instanced here
		if(girltarget.IsContained())
			girltarget.NihilModeEnable() //Run this first to make sure they don't teleport or something
			girltarget.BreachEffect()
		girltarget.toggle_ai(AI_OFF)
		girltarget.forceMove(landing_turf)
		girltarget.face_atom(target_turf)
		girltarget.EventStart()
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

/datum/status_effect/stacking/void/add_stacks(stacks_added)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -10 * stacks_added)

/datum/status_effect/stacking/void/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 10 * stacks)
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
	max_integrity = 50
	var/list/girl_types = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,
		/mob/living/simple_animal/hostile/abnormality/despair_knight,
		/mob/living/simple_animal/hostile/abnormality/greed_king
	)

/obj/structure/statue/petrified/magicalgirl/deconstruct(disassembled = TRUE) //You HAVE to use force to smash it
	qdel(src)

/obj/structure/statue/petrified/magicalgirl/Destroy()
	if(istype(src.loc, /mob/living/simple_animal/hostile/statue))
		var/mob/living/simple_animal/hostile/statue/S = src.loc
		forceMove(S.loc)
		if(S.mind)
			if(petrified_mob)
				S.mind.transfer_to(petrified_mob)
				to_chat(petrified_mob, span_notice("You slowly come back to your senses. You are in control of yourself again!"))
		qdel(S)

	for(var/obj/O in src)
		O.forceMove(loc)

	if(petrified_mob)
		petrified_mob.status_flags &= ~GODMODE
		petrified_mob.forceMove(loc)
		REMOVE_TRAIT(petrified_mob, TRAIT_MUTE, STATUE_MUTE)
		REMOVE_TRAIT(petrified_mob, TRAIT_NOBLEED, MAGIC_TRAIT)
		petrified_mob.faction -= "mimic"
		if(is_type_in_list(petrified_mob, girl_types))
			var/mob/living/simple_animal/hostile/abnormality/greed_king/magicalgirl = petrified_mob //It shouldn't really matter which one is instanced here
			magicalgirl.NihilIconUpdate()
			magicalgirl.AIStatus = AI_ON
			magicalgirl.stat = CONSCIOUS
			magicalgirl.can_act = TRUE
		petrified_mob = null
	return ..()

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
