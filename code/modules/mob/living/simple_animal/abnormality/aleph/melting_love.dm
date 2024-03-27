#define STATUS_EFFECT_SLIMED  /datum/status_effect/melty_slimed
/mob/living/simple_animal/hostile/abnormality/melting_love
	name = "Melting Love"
	desc = "A pink slime creature, resembling a female humanoid."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "melting_love"
	icon_living = "melting_love"
	portrait = "melting_love"
	pixel_x = -16
	base_pixel_x = -16
	speak_emote = list("gurgle")
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"
	/* Stats */
	threat_level = ALEPH_LEVEL
	health = 4000
	maxHealth = 4000
	obj_damage = 600
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.8)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 55
	melee_damage_upper = 60 // AOE damage increases it drastically
	projectiletype = /obj/projectile/melting_blob
	ranged = TRUE
	stat_attack = DEAD
	minimum_distance = 0
	ranged_cooldown_time = 5 SECONDS
	move_to_delay = 4
	/* Works */
	start_qliphoth = 3
	can_breach = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 30, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 45, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 40, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 0, 0),
	)
	work_damage_amount = 14
	work_damage_type = BLACK_DAMAGE
	/* Sounds */
	projectilesound = 'sound/abnormalities/meltinglove/ranged.ogg'
	attack_sound = 'sound/abnormalities/meltinglove/attack.ogg'
	death_sound = 'sound/abnormalities/meltinglove/death.ogg'
	/*Vars and others */
	loot = list(/obj/item/reagent_containers/glass/bucket/melting)
	del_on_death = FALSE
	ego_list = list(/datum/ego_datum/weapon/adoration, /datum/ego_datum/armor/adoration)
	gift_type =  /datum/ego_gifts/adoration
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	var/mob/living/carbon/human/gifted_human = null
	/// Amount of BLACK damage done to all enemies around main target on melee attack. Also includes original target
	var/radius_damage = 30
	var/sanityheal_cooldown = 15 SECONDS
	var/sanityheal_cooldown_base = 15 SECONDS

/mob/living/simple_animal/hostile/abnormality/melting_love/Life()
	. = ..()
	if(gifted_human)
		sanityheal()

/mob/living/simple_animal/hostile/abnormality/melting_love/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = (5 SECONDS))
	QDEL_IN(src, (5 SECONDS))
	return ..()

/* Attacks */
/mob/living/simple_animal/hostile/abnormality/melting_love/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
		if(L.type == /mob/living/simple_animal/hostile/slime && health <= maxHealth * 0.8) // We need healing
			return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/OpenFire(atom/A)
	if(get_dist(src, A) < 2) // We can't fire normal ranged attack that close
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/AttackingTarget()
	// Convert
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.stat == DEAD || H.health <= HEALTH_THRESHOLD_DEAD)
			return SlimeConvert(H)

	// Consume a slime. Cannot work on the big one, so the check is not istype()
	if(target.type == /mob/living/simple_animal/hostile/slime)
		var/mob/living/simple_animal/hostile/slime/S = target
		visible_message(span_warning("[src] consumes \the [S], restoring its own health."))
		. = ..() // We do a normal attack without AOE and then consume the slime to restore HP
		adjustBruteLoss(-maxHealth * 0.2)
		S.adjustBruteLoss(S.maxHealth) // To make sure it dies
		return .

	// AOE attack
	if(isliving(target))
		new /obj/effect/gibspawner/generic/silent/melty_slime(get_turf(target))
		for(var/turf/open/T in view(1, target))
			var/obj/effect/temp_visual/small_smoke/halfsecond/S = new(T)
			S.color = "#FF0081"
		for(var/mob/living/L in view(1, target))
			if(faction_check_mob(L))
				continue
			L.apply_damage(radius_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			L.apply_status_effect(STATUS_EFFECT_SLIMED)

	return ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/Move()
	. = ..()
	var/turf/T = get_turf(src)
	if(!isturf(T) || isspaceturf(T))
		return
	if(locate(/obj/effect/decal/cleanable/melty_slime) in T)
		for(var/obj/effect/decal/cleanable/melty_slime/slime in T)
			slime.Refresh()
		return
	new /obj/effect/decal/cleanable/melty_slime(T)

/* Slime Conversion */
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SlimeConvert(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	visible_message(span_danger("[src] glomps on \the [H] as another slime pawn appears!"))
	new /mob/living/simple_animal/hostile/slime(get_turf(H))
	H.gib()
	return TRUE

/* Qliphoth things */
/mob/living/simple_animal/hostile/abnormality/melting_love/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(33) && user == gifted_human)
		datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_living = "melting_breach"
	icon_state = icon_living
	icon_dead = "melting_breach_dead"
	pixel_x = -32
	base_pixel_x = -32
	desc = "A pink hunched creature with long arms, there are also visible bones coming from insides of the slime."
	if(istype(gifted_human))
		to_chat(gifted_human, span_userdanger("You feel like you are about to burst !"))
		gifted_human.emote("scream")
		if(KillGifted())
			UnregisterSignal(gifted_human, COMSIG_LIVING_DEATH)
			UnregisterSignal(gifted_human, COMSIG_WORK_COMPLETED)
	else
		Empower()

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/KillGifted()
	var/mob/living/carbon/human/H = gifted_human
	H.apply_damage(800, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	if(!H || QDELETED(H))
		return TRUE
	if(H.stat == DEAD)
		H.gib()
		return TRUE
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -30)
	H.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "gift", -HALO_LAYER))

/* Gift */
/mob/living/simple_animal/hostile/abnormality/melting_love/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(GODMODE in user.status_flags)
		return
	if(!gifted_human && istype(user) && work_type != ABNORMALITY_WORK_REPRESSION && user.stat != DEAD && (status_flags & GODMODE))
		gifted_human = user
		RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(GiftedDeath))
		RegisterSignal(user, COMSIG_WORK_COMPLETED, PROC_REF(GiftedAnger))
		to_chat(user, span_nicegreen("You feel like you received a gift..."))
		user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 30)
		user.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "gift", -HALO_LAYER))
		playsound(get_turf(user), 'sound/abnormalities/meltinglove/gift.ogg', 50, 0, 2)
		return
	if(istype(user) && user == gifted_human)
		to_chat(gifted_human, span_nicegreen("Melting Love was happy to see you!"))
		gifted_human.adjustSanityLoss(rand(-25,-35))
		return

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/GiftedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	SpawnBigSlime()
	datum_reference.qliphoth_change(-9)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/GiftedAnger(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		to_chat(gifted_human, span_userdanger("[src] didn't like that!"))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/sanityheal()
	if(sanityheal_cooldown <= world.time)
		gifted_human.adjustSanityLoss(-30)
		sanityheal_cooldown = (world.time + sanityheal_cooldown_base)

/mob/living/simple_animal/hostile/abnormality/melting_love/WorkChance(mob/living/carbon/human/user, chance)
	if(user == gifted_human)
		return chance + 10
	return chance

/* Checking if bigslime is dead or not and apply a damage buff if yes */
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SlimeDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	Empower()
	for(var/mob/M in GLOB.player_list)
		if(M.z == z && M.client)
			to_chat(M, span_userdanger("You can hear a gooey cry!"))
			SEND_SOUND(M, 'sound/abnormalities/meltinglove/empower.ogg')
			flash_color(M, flash_color = "#FF0081", flash_time = 50)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/Empower()
	SpeedChange(-0.5)
	melee_damage_lower = 80
	melee_damage_upper = 85
	projectiletype = /obj/projectile/melting_blob/enraged
	adjustBruteLoss(-maxHealth)
	desc += " It looks angry."

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SpawnBigSlime()
	var/turf/T = get_turf(gifted_human)
	gifted_human.gib()
	gifted_human = null
	var/mob/living/simple_animal/hostile/slime/big/S = new(T)
	RegisterSignal(S, COMSIG_LIVING_DEATH, PROC_REF(SlimeDeath))


/* Slimes (HE) */
/mob/living/simple_animal/hostile/slime
	name = "slime pawn"
	desc = "The skeletal remains of a former employee is floating in it..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "little_slime"
	icon_living = "little_slime"
	speak_emote = list("gurgle")
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"
	/* Stats */
	health = 400
	maxHealth = 400
	obj_damage = 200
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 25
	rapid_melee = 2
	speed = 2
	move_to_delay = 3
	/* Sounds */
	death_sound = 'sound/abnormalities/meltinglove/pawn_death.ogg'
	attack_sound = 'sound/abnormalities/meltinglove/pawn_attack.ogg'
	/* Vars and others */
	robust_searching = TRUE
	stat_attack = DEAD
	del_on_death = TRUE
	var/spawn_sound = 'sound/abnormalities/meltinglove/pawn_convert.ogg'
	var/statuschance = 25

/mob/living/simple_animal/hostile/slime/Initialize()
	. = ..()
	playsound(get_turf(src), spawn_sound, 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/slime/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/slime/AttackingTarget()
	// Convert
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.stat == DEAD || H.health <= HEALTH_THRESHOLD_DEAD)
			return SlimeConvert(H)
		if(prob(statuschance))
			H.apply_status_effect(STATUS_EFFECT_SLIMED)
	return ..()

/mob/living/simple_animal/hostile/slime/proc/SlimeConvert(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	visible_message(span_danger("[src] glomps on \the [H] as another slime pawn appears!"))
	new /mob/living/simple_animal/hostile/slime(get_turf(H))
	H.gib()
	return TRUE

/* Big Slimes (WAW) */
/mob/living/simple_animal/hostile/slime/big
	name = "big slime"
	desc = "The skeletal remains of the former gifted employee is floating in it..."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "big_slime"
	icon_living = "big_slime"
	pixel_x = -8
	base_pixel_x = -8
	/* Stats */
	health = 2000
	maxHealth = 2000
	melee_damage_lower = 35
	melee_damage_upper = 40
	spawn_sound = 'sound/abnormalities/meltinglove/pawn_big_convert.ogg'
	statuschance = 75

//Slime trails
/obj/effect/decal/cleanable/melty_slime
	name = "Slime"
	desc = "It looks corrosive."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "melty_slime3"
	random_icon_states = list("melty_slime3")
	mergeable_decal = TRUE
	var/duration = 30 SECONDS
	var/state = 3
	var/timer1
	var/timer2
	var/list/slime_types = list(
		/mob/living/simple_animal/hostile/abnormality/melting_love,
		/mob/living/simple_animal/hostile/slime/big,
		/mob/living/simple_animal/hostile/slime
	)

/obj/effect/decal/cleanable/melty_slime/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	START_PROCESSING(SSobj, src)
	duration += world.time
	timer1 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 10 SECONDS, TIMER_STOPPABLE)
	timer2 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 20 SECONDS, TIMER_STOPPABLE)

/obj/effect/decal/cleanable/melty_slime/proc/Refresh()
	icon_state = "melty_slime3"
	duration = 30 SECONDS
	if(timer1)
		deltimer(timer1)
		timer1 = null
	if(timer2)
		deltimer(timer2)
		timer2 = null
	timer1 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 10 SECONDS, TIMER_STOPPABLE)
	timer2 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 20 SECONDS, TIMER_STOPPABLE)


/obj/effect/decal/cleanable/melty_slime/proc/Reduce()
	state -= 1
	icon_state = "melty_slime[state]"
	update_icon()

/obj/effect/decal/cleanable/melty_slime/process(delta_time)
	if(world.time > duration)
		Remove()

/obj/effect/decal/cleanable/melty_slime/proc/Remove()
	STOP_PROCESSING(SSobj, src)
	animate(src, time = (5 SECONDS), alpha = 0)
	QDEL_IN(src, 5 SECONDS)

/obj/effect/decal/cleanable/melty_slime/proc/streak(list/directions, mapload=FALSE)
	set waitfor = FALSE
	var/direction = pick(directions)
	for(var/i in 0 to pick(0, 200; 1, 150; 2, 50; 3, 17; 50)) //the 3% chance of 50 steps is intentional and played for laughs.
		if (!mapload)
			sleep(2)
		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/melty_slime/Crossed(atom/movable/AM)
	. = ..()
	if(!isliving(AM))
		return FALSE
	if(is_type_in_list(AM, slime_types, FALSE))
		return
	var/mob/living/L = AM
	L.apply_status_effect(STATUS_EFFECT_SLIMED)

/obj/effect/gibspawner/generic/silent/melty_slime
	gibtypes = list(/obj/effect/decal/cleanable/melty_slime)
	gibamounts = list(3)

/obj/effect/gibspawner/generic/silent/melty_slime/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH))
	. = ..()
	return

/datum/status_effect/melty_slimed
	id = "melty_slimed"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/melty_slimed
	duration = 10 SECONDS // Hits 5 times
	tick_interval = 2 SECONDS

/atom/movable/screen/alert/status_effect/melty_slimed
	name = "Acidic Goo"
	desc = "Slime is stuck to your skin, slowing you down and dealing BLACK damage!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "slimed"

/datum/status_effect/melty_slimed/tick()
	. = ..()
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	L.apply_damage(10, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	owner.playsound_local(owner, 'sound/effects/wounds/sizzle2.ogg', 25, TRUE)
	if(!ishuman(L))
		return
	if((L.sanityhealth <= 0) || (L.health <= 0))
		var/turf/T = get_turf(L)
		new /mob/living/simple_animal/hostile/slime(T)
		L.gib(TRUE, TRUE, TRUE)

/datum/status_effect/melty_slimed/on_apply()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/slimed)
	owner.playsound_local(owner, 'sound/abnormalities/meltinglove/ranged_hit.ogg', 50, TRUE)
	return ..()

/datum/status_effect/melty_slimed/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/slimed)
	return ..()

/datum/movespeed_modifier/slimed
	multiplicative_slowdown = 1
	variable = FALSE

#undef STATUS_EFFECT_SLIMED
