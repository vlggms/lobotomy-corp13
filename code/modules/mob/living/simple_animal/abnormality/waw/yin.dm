/mob/living/simple_animal/hostile/abnormality/yin
	name = "Yin"
	desc = "A floating black fish that seems to hurt everyone near it."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "yin"
	icon_living = "yin"
	var/icon_breach = "yin_breach"
	icon_dead = "yin_slain"
	portrait = "yin"
	is_flying_animal = TRUE
	maxHealth = 1600
	health = 1600
	move_to_delay = 7
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -8
	base_pixel_y = -8
	stat_attack = HARD_CRIT

	//work stuff
	can_breach = TRUE
	start_qliphoth = 2
	threat_level = WAW_LEVEL
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 55, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	max_boxes = 20
	success_boxes = 16
	neutral_boxes = 9

	ego_list = list(
		/datum/ego_datum/weapon/discord,
		/datum/ego_datum/armor/discord,
	)
	gift_type = /datum/ego_gifts/discord
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/yang = 5, // TAKE THE FISH. DO IT
	)

	observation_prompt = "The Devil's Pendant was one half of a greater whole, but now they've been cleaved in half, forever wanting to reunite. <br>\
		The pendant laid upon the podium before you, even being in the same room as it seemed to suck the life out of you and erodes your very essence."
	observation_choices = list(
		"Put it on" = list(TRUE, "The moment you put it on, your body is stricken with deepest agony, feeling like thorns racing through your body, puncturing flesh and mind alike but you endure. <br>\
			It didn't mean to harm you, it's just the way it is. <br>\
			If there is light and goodness in this world, shouldn't there be darkness and evil too? <br>\
			The world is far more than brightness and warmth."),
		"Don't put it on" = list(FALSE, "It is darkness made manifest, made to encapsulate all the negativity in the world. <br>\
			If you can't accept the darkness of the world, you're not ready to accept the darkness in you."),
	)

	faction = list("neutral", "hostile") // Not fought by anything, typically. But...
	var/faction_override = list("hostile") // The effects hit non-hostiles.

	//Melee
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0, PALE_DAMAGE = 1)
	melee_damage_lower = 60 // Doesn't actually swing individually
	melee_damage_upper = 60
	melee_damage_type = BLACK_DAMAGE

	//Ranged
	COOLDOWN_DECLARE(beam)
	var/beam_cooldown = 10 SECONDS
	var/beam_distance = 20

	COOLDOWN_DECLARE(pulse)
	var/pulse_cooldown = 5 SECONDS
	var/pulse_damage = 40
	var/pulse_distance = 4

	var/busy = FALSE

	var/list/hit_people = list()
	var/list/spawned_effects = list()
	var/list/prohibitted_flips = list(
		/mob/living/simple_animal/hostile/abnormality/nihil,
		/mob/living/simple_animal/hostile/abnormality/white_night,
		/mob/living/simple_animal/hostile/megafauna/apocalypse_bird,
		/mob/living/simple_animal/hostile/megafauna/arbiter,
		/mob/living/simple_animal/hostile/abnormality/yang,
		/mob/living/simple_animal/hostile/abnormality/yin,
	)
	var/dragon_spawned = FALSE

/mob/living/simple_animal/hostile/abnormality/yin/New(loc, ...)
	. = ..()
	if(YangCheck())
		max_boxes = 25

/mob/living/simple_animal/hostile/abnormality/yin/Life()
	if(!..())
		return FALSE
	if(dragon_spawned)
		return FALSE
	if(SSlobotomy_events.yin_downed)
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/yang/yang
	for(var/mob/living/L in view(2, src))
		if(istype(L, /mob/living/simple_animal/hostile/abnormality/yang))
			yang = L
			SSlobotomy_events.YY_middle = null
			SSlobotomy_events.YY_breached = list()
	if(!yang)
		return
	if(SSlobotomy_events.yang_downed)
		return
	if(yang.status_flags & GODMODE)
		return
	SpawnDragon(yang)

/mob/living/simple_animal/hostile/abnormality/yin/Move()
	if(busy || SSlobotomy_events.yin_downed)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/yin/Moved(atom/OldLoc, Dir, override = TRUE)
	if(!COOLDOWN_FINISHED(src, pulse) || SSlobotomy_events.yin_downed)
		return ..()
	var/turfs_to_check = view(2, src)
	for(var/mob/living/L in turfs_to_check)
		if(L == src)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(faction_check(L.faction, faction_override))
			continue
		if(L.stat >= DEAD)
			continue
		COOLDOWN_START(src, pulse, pulse_cooldown)
		INVOKE_ASYNC(src, PROC_REF(Pulse))
		return ..()
	for(var/obj/vehicle/sealed/mecha/M in turfs_to_check)
		if(!M.occupants || length(M.occupants) == 0)
			continue
		COOLDOWN_START(src, pulse, pulse_cooldown)
		INVOKE_ASYNC(src, PROC_REF(Pulse))
		return ..()
	return ..()

/mob/living/simple_animal/hostile/abnormality/yin/death(gibbed)
	if(SSlobotomy_events.yang_downed)
		SSlobotomy_events.yin_downed = TRUE
		return ..()
	if(SSlobotomy_events.yin_downed)
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(BeDead))

/mob/living/simple_animal/hostile/abnormality/yin/proc/BeDead()
	icon_state = icon_dead
	playsound(src, 'sound/effects/magic.ogg', 60)
	SSlobotomy_events.yin_downed = TRUE
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, PALE_DAMAGE = 0))
	for(var/i = 1 to 12)
		SLEEP_CHECK_DEATH(5 SECONDS)
		if(SSlobotomy_events.yang_downed)
			death()
			return
	adjustBruteLoss(-maxHealth, forced = TRUE)
	ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, PALE_DAMAGE = 1))
	SSlobotomy_events.yin_downed = FALSE
	icon_state = icon_breach

/mob/living/simple_animal/hostile/abnormality/yin/Destroy()
	for(var/atom/AT in spawned_effects)
		qdel(AT)
	return ..()

/mob/living/simple_animal/hostile/abnormality/yin/WorkChance(mob/living/carbon/human/user, chance, work_type)
	return YangCheck() ? chance + 10 : chance

/mob/living/simple_animal/hostile/abnormality/yin/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_time >= (30 SECONDS))
		for(var/datum/abnormality/AD in SSlobotomy_corp.all_abnormality_datums)
			if(AD.abno_path != /mob/living/simple_animal/hostile/abnormality/yang)
				continue
			AD.qliphoth_change(-1, user)
			break
	return

/mob/living/simple_animal/hostile/abnormality/yin/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = icon_breach
	SSlobotomy_events.yin_downed = FALSE

/mob/living/simple_animal/hostile/abnormality/yin/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1, user)
	return

/mob/living/simple_animal/hostile/abnormality/yin/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	FireLaser(user)
	return

/mob/living/simple_animal/hostile/abnormality/yin/attack_hand(mob/living/carbon/human/M)
	. = ..()
	FireLaser(M)
	return

/mob/living/simple_animal/hostile/abnormality/yin/attack_animal(mob/living/simple_animal/M)
	. = ..()
	FireLaser(M)
	return

/mob/living/simple_animal/hostile/abnormality/yin/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	apply_damage(P.damage, P.damage_type)
	P.on_hit(src, 0, piercing_hit)
	. = BULLET_ACT_HIT
	if(!P.firer)
		return .
	if(!isliving(P.firer) && !ismecha(P.firer))
		return .
	FireLaser(P.firer)
	return .

/mob/living/simple_animal/hostile/abnormality/yin/AttackingTarget(atom/attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/yin/proc/Pulse()
	var/list/hit_turfs = list()
	var/list/hit = list()
	for(var/i = 1 to pulse_distance)
		var/list/to_hit = range(i, src) - hit_turfs
		hit_turfs |= to_hit
		for(var/turf/open/OT in to_hit)
			hit = HurtInTurf(OT, hit, pulse_damage, BLACK_DAMAGE, null, TRUE, faction_override, TRUE)
			new /obj/effect/temp_visual/small_smoke/yin_smoke/short(OT)
		sleep(3)
	return

/mob/living/simple_animal/hostile/abnormality/yin/proc/FireLaser(mob/target)
	if(busy || !COOLDOWN_FINISHED(src, beam) || SSlobotomy_events.yin_downed)
		return FALSE
	busy = TRUE
	face_atom(target)
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, beam_distance)
	var/list/to_hit = getline(src, target_turf)
	var/datum/beam/beam = Beam(get_turf(src),"volt_ray")
	for(var/turf/open/OT in to_hit)
		if(!istype(OT) || OT.density)
			break
		beam.target = OT
		beam.redrawing()
		sleep(1)
		new /obj/effect/temp_visual/revenant/cracks/yin(OT)
	for(var/obj/effect/FX in spawned_effects)
		qdel(FX)
	qdel(beam)
	COOLDOWN_START(src, beam, beam_cooldown)
	busy = FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/yin/proc/SpawnDragon(mob/living/simple_animal/hostile/abnormality/yang/Y)
	if(!istype(Y))
		return
	Y.status_flags &= ~GODMODE
	Y.forceMove(src)
	src.status_flags &= ~GODMODE
	animate(src, 8, alpha = 0)
	new /obj/effect/temp_visual/guardian/phase
	dragon_spawned = TRUE
	var/start_dir = pick(NORTH, EAST, SOUTH, WEST)
	var/turf/start_turf
	var/turf/mid_turf = get_turf(src)
	var/angle
	switch(start_dir)
		if(NORTH)
			start_turf = locate(1, 255, src.z)
		if(EAST)
			start_turf = locate(255, 255, src.z)
		if(SOUTH)
			start_turf = locate(255, 1, src.z)
		if(WEST)
			start_turf = locate(1, 1, src.z)
	angle = Get_Angle(start_turf, mid_turf)
	angle += rand(-10, 10)
	var/turf/end_turf = get_turf_in_angle(angle, start_turf, 300)
	var/list/path = getline(start_turf, end_turf)
	sound_to_playing_players_on_level("sound/abnormalities/yin/dragon_spawn.ogg", 75, zlevel = src.z)
	for(var/i = 0 to 7)
		var/obj/effect/yinyang_dragon/DP
		var/turf/T = path[15-(i*2)]
		var/list/temp_path = getline(T, end_turf)
		switch(i)
			if(0)
				DP = new /obj/effect/yinyang_dragon/dragon_head(T)
				DP.layer += 0.1
				notify_ghosts("The Dragon has arrived!", source = DP, action = NOTIFY_ORBIT, header="Something Interesting!")
			if(7)
				DP = new /obj/effect/yinyang_dragon/dragon_tail(T)
				DP.layer += 0.1
				src.forceMove(DP)
			else
				DP = new(T)
		var/matrix/M = matrix(DP.transform)
		M.Turn(angle-90)
		DP.transform = M
		MoveDragon(DP, temp_path)
	return

/mob/living/simple_animal/hostile/abnormality/yin/proc/MoveDragon(obj/effect/yinyang_dragon/DP, list/path = list())
	set waitfor = FALSE
	if(path.len <= 0)
		qdel(DP)
		return
	for(var/turf/T in path)
		DP.forceMove(T)
		DragonFlip(DP)
		sleep(1)
	qdel(DP)
	return

/mob/living/simple_animal/hostile/abnormality/yin/proc/DragonFlip(obj/effect/yinyang_dragon/DP)
	for(var/obj/machinery/computer/abnormality/AC in range(2, DP))
		if(AC in hit_people)
			continue
		if(!AC.datum_reference.current)
			continue
		var/qlip = AC.datum_reference.qliphoth_meter
		if(!qlip)
			continue
		AC.datum_reference.qliphoth_change(999)
		AC.datum_reference.qliphoth_change(-qlip)
		hit_people += AC
	for(var/mob/living/L in range(2, DP))
		if(L in hit_people)
			continue
		if(L.type in prohibitted_flips)
			continue
		var/damage = L.health
		L.adjustBruteLoss(-L.maxHealth+40)
		L.adjustBruteLoss(damage+40)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			damage = H.sanityhealth
			H.adjustSanityLoss(-H.maxSanity)
			H.adjustSanityLoss(damage)
		hit_people += L
		to_chat(L, span_userdanger("All that is shall become all that isn't."))

/mob/living/simple_animal/hostile/abnormality/yin/proc/YangCheck()
	for(var/datum/abnormality/AD in SSlobotomy_corp.all_abnormality_datums)
		if(AD.abno_path == /mob/living/simple_animal/hostile/abnormality/yang)
			return TRUE
	return FALSE

/obj/effect/yinyang_dragon
	name = "Avatar of Harmony"
	desc = "All that isn't shall become all that is."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "dragon_body"

/obj/effect/yinyang_dragon/Initialize(mapload)
	. = ..()
	src.transform *= 1.5

/obj/effect/yinyang_dragon/Destroy(force)
	. = ..()
	for(var/atom/at in src)
		qdel(at)
	return
/obj/effect/yinyang_dragon/dragon_head
	icon_state = "dragon_head"

/obj/effect/yinyang_dragon/dragon_tail
	icon_state = "dragon_tail"

/obj/effect/temp_visual/small_smoke/yin_smoke
	color = COLOR_PURPLE
	duration = 10

/obj/effect/temp_visual/small_smoke/yin_smoke/short
	duration = 5

/obj/effect/temp_visual/small_smoke/yin_smoke/long
	duration = 20

/obj/effect/temp_visual/revenant/cracks/yin
	icon_state = "yincracks"
	duration = 9
	var/damage = 60
	var/list/faction = list("hostile")

/obj/effect/temp_visual/revenant/cracks/yin/Destroy()
	for(var/turf/T in range(1, src))
		for(var/mob/living/L in T)
			if(faction_check(L.faction, src.faction))
				continue
			L.deal_damage(damage, BLACK_DAMAGE)
		for(var/obj/vehicle/sealed/mecha/V in T)
			V.take_damage(damage, BLACK_DAMAGE)
		new /obj/effect/temp_visual/small_smoke/yin_smoke/long(T)
	return ..()
