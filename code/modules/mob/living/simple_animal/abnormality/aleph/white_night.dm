GLOBAL_LIST_EMPTY(apostles)

/mob/living/simple_animal/hostile/abnormality/white_night
	name = "WhiteNight"
	desc = "The heavens' wrath. Say your prayers, heretic, the day has come."
	health = 15000
	maxHealth = 15000
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "white_night"
	icon_living = "white_night"
	portrait = "white_night"
	health_doll_icon = "white_night"
	faction = list("hostile", "apostle")
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("proclaims")
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = -2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.2)
	is_flying_animal = TRUE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	loot = list(/obj/item/ego_weapon/paradise)
	death_message = "evaporates in a moment, leaving heavenly light and feathers behind."
	death_sound = 'sound/abnormalities/whitenight/apostle_death.ogg'
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL + 1
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 30, 30, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 30, 35, 40, 45),
		ABNORMALITY_WORK_REPRESSION = list(30, 30, 35, 40, 45),
	)
	work_damage_amount = 14
	work_damage_type = PALE_DAMAGE
	can_patrol = FALSE

	light_system = MOVABLE_LIGHT
	light_color = COLOR_VERY_SOFT_YELLOW
	light_range = 7
	light_power = 3

	ego_list = list(
		/datum/ego_datum/armor/paradise,
	)
	gift_type =  /datum/ego_gifts/paradise
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/onesin = 5,
	)

	observation_prompt = "Thou knocked the door, now it hath opened. <br>\
		Thou who carries burden, came to seek the answer."
	observation_choices = list( // TODO IN A FEW YEARS: multiple messages, the answer should be irrelevant, code should check for wing gift.
		"Where did you come from?" = list(TRUE, "I am from the end." ),
		"Who are you?" = list(FALSE, "Thy question is empty, I cannot answer"),
		"Why have you come?" = list(FALSE, "Thy question is empty, I cannot answer"),
	)

	var/holy_revival_cooldown
	var/holy_revival_cooldown_base = 75 SECONDS
	var/holy_revival_damage = 80 // Pale damage, scales with distance
	var/holy_revival_range = 80
	/// List of mobs that have been hit by the revival field to avoid double effect
	var/list/been_hit = list()
	/// Currently spawned apostles by this mob
	var/list/apostles = list()
	/// List of Living People on Breach
	var/list/heretics = list()

	var/datum/reusable_visual_pool/RVP = new(500)

/mob/living/simple_animal/hostile/abnormality/white_night/FearEffectText(mob/affected_mob, level = 0)
	level = num2text(clamp(level, 1, 5))
	var/list/result_text_list = list(
		"1" = list("There's no room for error here.", "My legs are trembling...", "Damn, it's scary."),
		"2" = list("GODDAMN IT!!!!", "H-Help...", "I don't want to die!"),
		"3" = list("What am I seeing...?", "I-I can't take it...", "I can't understand..."),
		"4" = list("So this is God...", "My existence is meaningless...", "We are petty beings..."),
		"5" = list("Please, mercy...", "Grant us salvation...", "Let us witness in awe..."),
		)
	return pick(result_text_list[level])

/mob/living/simple_animal/hostile/abnormality/white_night/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/white_night/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/white_night/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		if(holy_revival_cooldown < world.time)
			for(var/mob/living/simple_animal/hostile/apostle/scythe/guardian/G in apostles)
				if(G in ohearers(10, src)) // Only teleport them if they are not in view.
					continue
				var/turf/T = get_step(src, pick(NORTH,SOUTH,WEST,EAST))
				G.forceMove(T)
			revive_humans()

/mob/living/simple_animal/hostile/abnormality/white_night/death(gibbed)
	GrantMedal()
	for(var/mob/living/carbon/human/heretic in heretics)
		if(heretic.stat == DEAD || !heretic.ckey)
			continue
		heretic.Apply_Gift(new /datum/ego_gifts/blessing)
		heretic.playsound_local(get_turf(heretic), 'sound/abnormalities/whitenight/apostle_bell.ogg', 50)
		to_chat(heretic, span_userdanger("[heretic], your Heresy will not be forgotten!"))
	return ..()

/mob/living/simple_animal/hostile/abnormality/white_night/Destroy()
	for(var/mob/living/simple_animal/hostile/apostle/A in apostles)
		A.death()
		QDEL_IN(A, 1.5 SECONDS)
	apostles = null
	QDEL_NULL(particles)
	particles = null
	QDEL_NULL(RVP)
	return ..()

/mob/living/simple_animal/hostile/abnormality/white_night/proc/revive_humans(range_override = null, faction_check = "apostle")
	if(holy_revival_cooldown > world.time)
		return
	if(range_override == null)
		range_override = holy_revival_range
	holy_revival_cooldown = (world.time + holy_revival_cooldown_base)
	been_hit = list()
	playsound(src, 'sound/abnormalities/whitenight/apostle_spell.ogg', 75, 1, range_override)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	for(var/i = 1 to range_override)
		turf_list = (target_c.y - i > 0 			? getline(locate(max(target_c.x - i, 1), target_c.y - i, target_c.z), locate(min(target_c.x + i - 1, world.maxx), target_c.y - i, target_c.z)) : list()) +\
					(target_c.x + i <= world.maxx ? getline(locate(target_c.x + i, max(target_c.y - i, 1), target_c.z), locate(target_c.x + i, min(target_c.y + i - 1, world.maxy), target_c.z)) : list()) +\
					(target_c.y + i <= world.maxy ? getline(locate(min(target_c.x + i, world.maxx), target_c.y + i, target_c.z), locate(max(target_c.x - i + 1, 1), target_c.y + i, target_c.z)) : list()) +\
					(target_c.x - i > 0 			? getline(locate(target_c.x - i, min(target_c.y + i, world.maxy), target_c.z), locate(target_c.x - i, max(target_c.y - i + 1, 1), target_c.z)) : list())
		for(var/turf/open/T in turf_list)
			CHECK_TICK
			if(faction_check != "apostle")
				RVP.NewSparkles(T, 10, "#AAFFAA") // Indicating that it's a good thing
			else
				RVP.NewCultSparks(T, 10)
			for(var/mob/living/L in T)
				RVP.NewCultIn(T, L.dir)
				INVOKE_ASYNC(src, PROC_REF(revive_target), L, i, faction_check)
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/abnormality/white_night/proc/revive_target(mob/living/L, attack_range = 1, faction_check = "apostle")
	if(L in been_hit)
		return
	been_hit += L
	if(!(faction_check in L.faction))
		playsound(L.loc, 'sound/machines/clockcult/ark_damage.ogg', 50 - attack_range, TRUE, -1)
		// The farther you are from white night - the less damage it deals
		var/dealt_damage = max(5, holy_revival_damage - attack_range)
		L.deal_damage(dealt_damage, PALE_DAMAGE)
		if(ishuman(L) && dealt_damage > 25)
			L.emote("scream")
		to_chat(L, span_userdanger("The holy light... IT BURNS!!"))
	else
		if(istype(L, /mob/living/simple_animal/hostile/apostle) && L.stat == DEAD)
			L.revive(full_heal = TRUE, admin_revive = FALSE)
			L.grab_ghost(force = TRUE)
			to_chat(L, span_notice("The holy light compels you to live!"))
		else if(L.stat != DEAD)
			L.adjustBruteLoss(-(holy_revival_damage * 0.75) * (L.maxHealth/100))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.adjustSanityLoss(-(holy_revival_damage * 0.75) * (H.maxSanity/100))
			L.regenerate_limbs()
			L.regenerate_organs()
			to_chat(L, span_notice("The holy light heals you!"))

/mob/living/simple_animal/hostile/abnormality/white_night/proc/SpawnApostles()
	for(var/i = 1 to 11)
		var/apostle_type = /mob/living/simple_animal/hostile/apostle/scythe
		if(i in list(1,11))
			apostle_type = /mob/living/simple_animal/hostile/apostle/scythe/guardian
		if(i in list(4,5,6))
			apostle_type = /mob/living/simple_animal/hostile/apostle/staff
		if(i in list(7,8,9,10))
			apostle_type = /mob/living/simple_animal/hostile/apostle/spear
		apostles += new apostle_type(get_turf(src))
		var/list/possible_locs = GLOB.xeno_spawn.Copy()
		for(var/mob/living/simple_animal/hostile/apostle/A in apostles)
			if(istype(A, /mob/living/simple_animal/hostile/apostle/scythe/guardian))
				continue
			var/turf/T = pick(possible_locs)
			A.forceMove(T)
			if(length(possible_locs) > 1)
				possible_locs -= T

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/white_night/OnQliphothChange(mob/living/carbon/human/user)
	if(datum_reference.qliphoth_meter <= 0)
		return
	var/flashing_color = COLOR_ORANGE
	if(datum_reference.qliphoth_meter == 1)
		flashing_color = COLOR_SOFT_RED
	if(datum_reference.qliphoth_meter == 3)
		flashing_color = COLOR_GREEN
	for(var/mob/M in GLOB.player_list)
		flash_color(M, flash_color = flashing_color, flash_time = 25)
	sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg', (25 * (3 - datum_reference.qliphoth_meter)))
	return

/mob/living/simple_animal/hostile/abnormality/white_night/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(66))
		datum_reference.qliphoth_change(1)
		if(prob(66)) // Rare effect, mmmm
			INVOKE_ASYNC(src, PROC_REF(revive_humans), 48, "neutral") // Big heal
	return

/mob/living/simple_animal/hostile/abnormality/white_night/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/white_night/BreachEffect(mob/living/carbon/human/user, breach_type)
	holy_revival_cooldown = world.time + holy_revival_cooldown_base
	. = ..()
	for(var/mob/M in GLOB.player_list)
		if(M.stat != DEAD && ishuman(M) && M.ckey)
			heretics += M
		flash_color(M, flash_color = COLOR_RED, flash_time = 100)
	sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg')
	add_filter("apostle", 1, rays_filter(size = 64, color = "#FFFF00", offset = 6, density = 16, threshold = 0.05))
	if(LAZYLEN(GLOB.department_centers))
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)
	SpawnApostles()
	particles = new /particles/white_night()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(sound_to_playing_players), 'sound/abnormalities/whitenight/rapture2.ogg', 50), 10 SECONDS)
	return

/// Grants medals and achievements to surrounding players
//May move this to _abnormality some day.
/mob/living/simple_animal/hostile/abnormality/white_night/proc/GrantMedal()
	if(!client && !(flags_1 & ADMIN_SPAWNED_1) && SSachievements.achievements_enabled)
		for(var/mob/living/L in view(7,src))
			if(L.stat || !L.client)
				continue
			L.client.give_award(/datum/award/achievement/lc13/white_night, L)

/* Apostles */

/mob/living/simple_animal/hostile/apostle
	name = "apostle"
	desc = "An apostle."
	health = 2000
	maxHealth = 2000
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/abnormalities/whitenight/scythe.ogg'
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "apostle_scythe"
	icon_living = "apostle_scythe"
	icon_dead = "apostle_dead"
	faction = list("hostile", "apostle")
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("says")
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 35
	melee_damage_upper = 45
	obj_damage = 400
	ranged = TRUE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	move_to_delay = 5
	pixel_x = -8
	base_pixel_x = -8
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	a_intent = INTENT_HARM
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE
	mob_size = MOB_SIZE_HUGE
	blood_volume = BLOOD_VOLUME_NORMAL
	can_patrol = TRUE // You have legs, use them.
	var/can_act = TRUE
	var/death_counter = 0

/mob/living/simple_animal/hostile/apostle/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/apostle/death(gibbed)
	death_counter = clamp(death_counter + 1, 0, 3)
	return ..()

/mob/living/simple_animal/hostile/apostle/revive(full_heal = FALSE, admin_revive = FALSE, excess_healing = 0)
	.= ..()
	can_act = TRUE // In case we died while performing special attack
	adjustBruteLoss(maxHealth * (death_counter * 0.15), TRUE)

/mob/living/simple_animal/hostile/apostle/gib(no_brain, no_organs, no_bodyparts)
	return FALSE // Cannot be gibbed

/mob/living/simple_animal/hostile/apostle/CanBeAttacked()
	if(stat == DEAD) // Simple mobs cannot attack them when they are "dead"
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/apostle/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return

	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(faction_check_mob(L))
			return
	. = ..()
	if(. && isliving(attacked_target))
		if(!client && ranged && ranged_cooldown <= world.time)
			OpenFire()

/mob/living/simple_animal/hostile/apostle/scythe
	name = "scythe apostle"
	desc = "A disformed human wielding a terrifying scythe."
	var/scythe_cooldown
	var/scythe_cooldown_time = 10 SECONDS
	var/scythe_range = 2
	var/scythe_damage = 250
	var/scythe_damage_type = RED_DAMAGE

/mob/living/simple_animal/hostile/apostle/scythe/OpenFire()
	if(!can_act)
		return

	if(client)
		ScytheAttack()
		return

	if(get_dist(src, target) <= scythe_range && scythe_cooldown <= world.time)
		ScytheAttack()

/mob/living/simple_animal/hostile/apostle/scythe/proc/ScytheAttack()
	if(scythe_cooldown > world.time)
		return
	scythe_cooldown = world.time + scythe_cooldown_time
	can_act = FALSE
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), scythe_damage, scythe_damage_type, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE, break_not_destroy = TRUE)
	playsound(get_turf(src), 'sound/abnormalities/whitenight/scythe_spell.ogg', 75, FALSE, 5)
	SLEEP_CHECK_DEATH(5)
	can_act = TRUE

/mob/living/simple_animal/hostile/apostle/scythe/guardian
	name = "guardian apostle"
	health = 3000
	maxHealth = 3000
	move_to_delay = 7
	melee_damage_type = PALE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	vision_range = 12
	aggro_vision_range = 12
	patrol_cooldown_time = 10 SECONDS
	scythe_range = 3
	scythe_cooldown_time = 8 SECONDS // More often, since the damage increase was disliked.
	scythe_damage_type = PALE_DAMAGE
	scythe_damage = 150 // It's a big AoE unlike base game where it's smaller and as it is you straight up die unless you have 7+ Pale resist. You also have TWO of these AND WN hitting you for ~80 Pale at this range.

/mob/living/simple_animal/hostile/apostle/scythe/guardian/CanStartPatrol()
	if(locate(/mob/living/simple_animal/hostile/abnormality/white_night) in ohearers(9, src))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/apostle/scythe/guardian/patrol_select()
	var/mob/living/simple_animal/hostile/abnormality/white_night/WN = locate() in GLOB.abnormality_mob_list
	if(!istype(WN))
		return
	var/turf/target_turf = pick(RANGE_TURFS(2, WN))
	patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
	playsound(get_turf(src), 'sound/abnormalities/whitenight/apostle_growl.ogg', 75, FALSE)
	TemporarySpeedChange(-4, 5 SECONDS) // OUT OF MY WAY

/mob/living/simple_animal/hostile/apostle/scythe/guardian/ScytheAttack()
	if(scythe_cooldown > world.time)
		return
	scythe_cooldown = world.time + scythe_cooldown_time
	can_act = FALSE
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(10)
	var/gibbed = FALSE
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T) // Not changing this one because it notable does not gib pre-dead bodies, only living ones.
			if(L.stat == DEAD)
				continue
			if(faction_check_mob(L))
				continue
			L.deal_damage(scythe_damage, scythe_damage_type)
			if(L.stat == DEAD) // Total overkill
				for(var/i = 1 to 5) // Alternative to gib()
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
				new /obj/effect/gibspawner/generic/silent(get_turf(L))
				gibbed = TRUE
	playsound(get_turf(src), (gibbed ? 'sound/abnormalities/whitenight/scythe_gib.ogg' : 'sound/abnormalities/whitenight/scythe_spell.ogg'), (gibbed ? 100 : 75), FALSE, (gibbed ? 12 : 5))
	SLEEP_CHECK_DEATH(5)
	can_act = TRUE

/mob/living/simple_animal/hostile/apostle/spear
	name = "spear apostle"
	desc = "A disformed human wielding a spear."
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/abnormalities/whitenight/spear.ogg'
	icon_state = "apostle_spear"
	icon_living = "apostle_spear"
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.5)
	var/spear_cooldown
	var/spear_cooldown_time = 10 SECONDS
	var/spear_max = 50
	var/spear_damage = 300
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/apostle/spear/OpenFire()
	if(client)
		SpearAttack(target)
		return

	if(spear_cooldown <= world.time)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(src, target)
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			SpearAttack(target)

/mob/living/simple_animal/hostile/apostle/spear/proc/SpearAttack(target)
	if(spear_cooldown > world.time)
		return
	can_act = FALSE
	var/dir_to_target = get_dir(src, target)
	var/turf/T = get_turf(src)
	for(var/i = 1 to spear_max)
		T = get_step(T, dir_to_target)
		if(T.density)
			if(i < 4) // Mob attempted to dash into a wall too close, stop it
				can_act = TRUE
				return
			break
		new /obj/effect/temp_visual/cult/sparks(T)
	spear_cooldown = world.time + spear_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/whitenight/spear_charge.ogg', 75, 0, 5)
	SLEEP_CHECK_DEATH(22)
	been_hit = list()
	playsound(get_turf(src), 'sound/abnormalities/whitenight/spear_dash.ogg', 100, 0, 20)
	do_dash(dir_to_target, 0)

/mob/living/simple_animal/hostile/apostle/spear/proc/do_dash(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= spear_max)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		can_act = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("holy spear")
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			addtimer(CALLBACK (D, TYPE_PROC_REF(/obj/machinery/door, open)))
	if(stop_charge)
		can_act = TRUE
		return
	forceMove(T)
	for(var/turf/TF in view(1, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
		var/list/new_hits = HurtInTurf(T, been_hit, spear_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			visible_message(span_boldwarning("[src] runs through [L]!"), span_nicegreen("You impaled heretic [L]!"))
			new /obj/effect/temp_visual/cleave(get_turf(L))
	addtimer(CALLBACK(src, PROC_REF(do_dash), move_dir, (times_ran + 1)), 0.5) // SPEED

/mob/living/simple_animal/hostile/apostle/staff
	name = "staff apostle"
	desc = "A disformed human wielding a magic staff."
	icon_state = "apostle_staff"
	icon_living = "apostle_staff"
	attack_sound = 'sound/weapons/genhit1.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	minimum_distance = 4
	melee_damage_lower = 25
	melee_damage_upper = 35
	melee_damage_type = BLACK_DAMAGE // Okay, look, they aren't really meant to melee anyway
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	var/staff_cooldown
	var/staff_cooldown_time = 20 SECONDS
	var/staff_damage = 20
	var/hit_ticks = 60
	var/datum/looping_sound/apostle_beam/beamloop

/mob/living/simple_animal/hostile/apostle/staff/Initialize()
	. = ..()
	beamloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/apostle/staff/Destroy()
	QDEL_NULL(beamloop)
	return ..()

/mob/living/simple_animal/hostile/apostle/staff/death(gibbed)
	beamloop.stop()
	return ..()

/mob/living/simple_animal/hostile/apostle/staff/OpenFire()
	if(!can_act)
		return

	if(client)
		StaffAttack(target)
		return

	if(staff_cooldown <= world.time)
		StaffAttack(target)

/mob/living/simple_animal/hostile/apostle/staff/proc/StaffAttack(target)
	if(staff_cooldown > world.time)
		return
	staff_cooldown = world.time + staff_cooldown_time
	can_act = FALSE
	var/list/chosen_turfs = list()
	var/list/potential_dirs = GLOB.alldirs.Copy()
	potential_dirs -= get_dir(target, src)
	for(var/i = 1 to 3)
		if(!LAZYLEN(potential_dirs))
			break
		var/chosen_dir = pick(potential_dirs)
		potential_dirs -= chosen_dir
		var/turf/NT = get_turf(target)
		for(var/e = 1 to 4)
			var/turf/temp_turf = get_step(NT, chosen_dir)
			if(temp_turf.density)
				break
			NT = temp_turf
		chosen_turfs += NT
	if(!LAZYLEN(chosen_turfs))
		can_act = TRUE
		return FALSE
	for(var/turf/TT in chosen_turfs)
		addtimer(CALLBACK(src, PROC_REF(HolyBeam), TT))
	playsound(get_turf(src), 'sound/abnormalities/whitenight/staff_prepare.ogg', 75, 0, 7)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	beamloop.start()
	SLEEP_CHECK_DEATH(hit_ticks * 2)
	beamloop.stop()
	can_act = TRUE

/mob/living/simple_animal/hostile/apostle/staff/proc/HolyBeam(turf/T)
	new /obj/effect/temp_visual/dir_setting/curse/grasp_portal/fading(T)
	var/turf/MT = get_turf(src)
	SLEEP_CHECK_DEATH(2.5 SECONDS)
	var/datum/beam/B = MT.Beam(T, "sm_arc_dbz_referance", time=hit_ticks*2)
	var/list/affected_turfs = getline(MT, T)
	for(var/i = 1 to hit_ticks)
		for(var/turf/AT in affected_turfs)
			for(var/mob/living/L in AT)
				if(faction_check_mob(L))
					continue
				L.deal_damage(staff_damage, WHITE_DAMAGE)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.sanity_lost)
						H.gib() // lmao
		sleep(2)
	QDEL_NULL(B)
