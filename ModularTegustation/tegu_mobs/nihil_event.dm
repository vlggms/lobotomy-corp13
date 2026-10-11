//All code related to the nihil event but not specifically attached to one mob -Coxswain
//For the mob itself, check abnormalities/aleph/nihil.dm

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
	SSlobotomy_events.AddNihilMobs()

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
		owner.can_act = FALSE
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

// Minions
/mob/living/simple_animal/hostile/aminion/despair_sword
	name = "Sword without an Owner"
	desc = "A sword laced with grief."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "despair_sword_nihil"
	icon_living = "despair_sword_nihil"
	icon_dead = "despair_sword_nihil_dead"
	gender = NEUTER
	maxHealth = 400
	health = 400
	faction = list("Nihil", "hostile")
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 3
	melee_damage_upper = 6
	melee_reach = 3 // Will try to attack from this distance
	rapid_melee = 3
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/weapons/ego/rapier1.ogg'
	death_sound = 'sound/abnormalities/despairknight/dead.ogg'
	is_flying_animal = TRUE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)
	can_affect_emergency = FALSE
	var/charge_ready = TRUE
	var/charging
	var/revving_charge = FALSE
	var/charge_damage = 40
	var/charge_attack_cooldown = 0
	var/charge_attack_cooldown_time = 1 SECONDS
	var/charge_attack_delay = 8
	var/charging_speed = 0.6
	var/mob/living/simple_animal/hostile/abnormality/nihil/friend
	var/blessed = FALSE

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
		forceMove(T)
		LoseTarget()
		for(var/mob/living/carbon/human/enemy in oview(src, vision_range))
			if(enemy.stat != DEAD)
				GiveTarget(enemy) //the moment he teleports he's already on the offensive
				break
		return

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/Regenerate()
	anchored = FALSE
	if(friend)
		density = TRUE
		revive(full_heal = TRUE, admin_revive = TRUE)
		return
	animate(src, alpha = 0, time = 3 SECONDS)
	QDEL_IN(src, 3 SECONDS)

/mob/living/simple_animal/hostile/aminion/despair_sword/death()
	density = FALSE
	anchored = TRUE
	if(blessed || !friend)
		if(friend)
			friend.deal_damage(maxHealth, BRUTE, src, flags = (DAMAGE_UNTRACKABLE), attack_type = (ATTACK_TYPE_SPECIAL))
			friend.minion_list -= src
			playsound(src, 'sound/abnormalities/despairknight/dead.ogg', 100, FALSE, FALSE)
		animate(src, alpha = 0, time = 3 SECONDS)
		QDEL_IN(src, 3 SECONDS)
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
		DestroySurroundings() //to break tables in the way
		for(var/atom/A in get_turf(src))
			ChargeHit(A)
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
	pass_flags = PASSTABLE | PASSMOB
	var/turf/chargeturf = get_turf(chargeat)
	if(chargeturf) //for some reason this can end up being null
		new /obj/effect/temp_visual/cult/sparks(chargeturf) //in case the big effect is behind a wall
	revving_charge = TRUE
	charge_ready = FALSE
	walk(src, 0)
	playsound(src, 'sound/abnormalities/despairknight/attack.ogg', 75, FALSE)
	var/angle_to_target = Get_Angle(src, target)
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "despair_nihil"
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

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/EndCharge()
	if(!charging)
		return
	pass_flags = NONE
	charging = FALSE
	revving_charge = FALSE
	walk(src, 0) // cancel the movement
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "despair_sword_nihil"
	var/matrix/matrix = new
	transform = matrix
	ResetCharge()

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/ResetCharge()
	charge_attack_cooldown = world.time + charge_attack_cooldown_time
	charge_ready = TRUE //redundancy is good

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/ChargeHit(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!faction_check_mob(L))
			do_attack_animation(L, ATTACK_EFFECT_SLASH)
			L.deal_damage(charge_damage, melee_damage_type, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
			L.apply_void(3)
			playsound(src, attack_sound, 125, 1)
	else if(isvehicle(A))
		var/obj/vehicle/V = A
		V.take_damage(charge_damage*1.5, melee_damage_type)
		for(var/mob/living/occupant in V.occupants)
			to_chat(occupant, span_userdanger("Your [V.name] is slashed by [src]!"))

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/Bless()
	if(blessed)
		return
	blessed = TRUE
	add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
	add_filter("blessing_outline", 2, list("type" = "drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(255, 255, 255)))
	charge_damage = 50
	charge_attack_cooldown_time = 0.8 SECONDS
	charge_attack_delay = 6
	charging_speed = 0.4

/mob/living/simple_animal/hostile/aminion/despair_sword/proc/Unbless()
	if(!blessed)
		return
	blessed = FALSE
	cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
	remove_filter("blessing_outline")
	charge_damage = initial(charge_damage)
	charge_attack_cooldown_time = initial(charge_attack_cooldown_time)
	charge_attack_delay = initial(charge_attack_delay)
	charging_speed = initial(charging_speed)

/mob/living/simple_animal/hostile/aminion/blissfragment
	name = "brilliant bliss"
	desc = "It looks like a large gemstone. Breaking it might reduce the power of a powerful attack."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bliss"
	icon_living = "bliss"
	icon_dead = "bliss"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	maxHealth = 100
	health = 100
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 2, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	can_affect_emergency = FALSE
	density = FALSE
	AIStatus = AI_OFF
	environment_smash = ENVIRONMENT_SMASH_NONE
	var/obj/effect/temp_visual/distortedwarning/current_effect
	var/color_list = list(COLOR_WHITE, COLOR_VERY_LIGHT_GRAY, COLOR_SILVER, COLOR_BLACK, COLOR_ALMOST_BLACK, COLOR_FLOORTILE_GRAY)

/mob/living/simple_animal/hostile/aminion/blissfragment/Life()
	. = ..()
	for(var/mob/living/carbon/human/twinkler in range(3, src))
		var/obj/effect/temp_visual/sparkle/sparkleFX = new(get_turf(twinkler))
		sparkleFX.color = pick(color_list)
		sparkleFX.pixel_x += rand(-8,8)
		sparkleFX.pixel_y += rand(-8,8)

/mob/living/simple_animal/hostile/aminion/blissfragment/Initialize()
	. = ..()
	color = COLOR_GRAY
	new /obj/effect/temp_visual/point(get_turf(src))
	current_effect = new (get_turf(src))
	if(current_effect.timerid) // Don't want the visual to disappear
		deltimer(current_effect.timerid)

/mob/living/simple_animal/hostile/aminion/blissfragment/Move()
	return FALSE

/mob/living/simple_animal/hostile/aminion/blissfragment/death()
	density = FALSE
	anchored = TRUE
	animate(src, color = null, time = 1 SECONDS)
	set_light(5, 7, "D4FAF37")
	visible_message("[src] shines brightly!")
	if(current_effect)
		QDEL_NULL(current_effect)
	current_effect = new (get_turf(src))
	current_effect.color = COLOR_YELLOW
	if(current_effect.timerid) // Don't want the visual to disappear
		deltimer(current_effect.timerid)
	color_list = list(COLOR_YELLOW, COLOR_VIVID_YELLOW, COLOR_VERY_SOFT_YELLOW, COLOR_VIBRANT_LIME)
	..()

/mob/living/simple_animal/hostile/aminion/blissfragment/Destroy()
	if(current_effect)
		QDEL_NULL(current_effect)
	..()

/mob/living/simple_animal/hostile/aminion/blissfragment/gib()
	death()
	return FALSE // Does not gib

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
	max_stacks = 99
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/void
	consumed_on_threshold = FALSE
	var/list/overlay_objects = list()
	var/grabbing = FALSE
	var/can_modify_stats = TRUE // May prevent on_remove being called twice.

/atom/movable/screen/alert/status_effect/void
	name = "Void"
	desc = "You are empty inside."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "nihil"

/datum/status_effect/stacking/void/on_apply()
	. = ..()
	to_chat(owner, span_warning("A mysterious power is sapping your vitality!"))

/datum/status_effect/stacking/void/add_stacks(stacks_added)
	. = ..()
	if(!ishuman(owner))
		return
	if(!can_modify_stats)
		return
	if((stacks + stacks_added) > max_stacks) // Prevents stacks_added from being over max_stacks for justice calculations
		var/difference = stacks + stacks_added - max_stacks
		stacks_added -= difference
		if(stacks_added < 0)
			return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -2 * stacks_added)

/datum/status_effect/stacking/void/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	if(!can_modify_stats)
		return
	can_modify_stats = FALSE
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, (2 * (stacks - 1))) // -1 stack to account for the stack from applying
	to_chat(owner, span_nicegreen("You feel normal again."))

/datum/status_effect/stacking/void/proc/DoGrab(client/C, num, screen_location = "Center,Center")
	if(!C)
		return
	var/list/potential_icons = list("WRATH", "HATE", "DESPAIR", "GREED")
	for(var/i = 1 to num)
		var/obj/effect/overlay/nihil/T = new()
		overlay_objects += T
		T.icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
		var/myicon = pick(potential_icons)
		T.icon_state = "[myicon]"
		T.alpha = rand(200, 255)
		T.icon_w = rand(-100,100)
		T.icon_z = rand(-100,100)
		T.layer = FLOAT_LAYER
		T.plane = HUD_PLANE
		T.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		T.screen_loc = screen_location
		T.transform = matrix()*2
		T.owner = owner
		T.source = src
		C.screen += T
	grabbing = TRUE
	playsound(owner, 'sound/abnormalities/nihil/hatred_invocation.ogg', 60, FALSE, 10)

/datum/status_effect/stacking/void/process()
	. = ..()
	if(!grabbing)
		return
	removeNullsFromList(overlay_objects)
	if(!LAZYLEN(overlay_objects))
		qdel(src)
		return
	if(!owner)
		qdel(src)
		return
	owner.Immobilize(1)
	owner.deal_damage(stacks * 0.1, PALE_DAMAGE)
	var/obj/effect/temp_visual/sparkle/sparkleFX = new(get_turf(owner))
	sparkleFX.color = pick(COLOR_WHITE, COLOR_VERY_LIGHT_GRAY, COLOR_SILVER, COLOR_BLACK, COLOR_ALMOST_BLACK, COLOR_FLOORTILE_GRAY)
	sparkleFX.pixel_x += rand(-8,8)
	sparkleFX.pixel_y += rand(-8,8)

/obj/effect/overlay/nihil
	var/mob/living/owner
	var/datum/status_effect/stacking/void/source

/obj/effect/overlay/nihil/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=2, color=rgb(255, 255, 255))

/obj/effect/overlay/nihil/Click()
	if(owner)
		owner.playsound_local(owner, 'sound/abnormalities/missed_reaper/shadowhit.ogg', 30, FALSE)
		owner = null
	if(source)
		source.overlay_objects -= src
	qdel(src)

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

//Mob Proc
/mob/living/proc/apply_void(stacks)
	if(stat == DEAD || !ishuman(src))
		return
	var/datum/status_effect/stacking/void/V = src.has_status_effect(/datum/status_effect/stacking/void)
	if(!V)
		src.apply_status_effect(/datum/status_effect/stacking/void, stacks)
		playsound(src, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	else
		V.add_stacks(stacks)
		V.refresh()
	src.OtherDamageEffect(stacks, "void")
