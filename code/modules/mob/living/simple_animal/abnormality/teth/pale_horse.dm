#define STATUS_EFFECT_MORTIS /datum/status_effect/mortis
// Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/pale_horse
	name = "Pale Horse"
	desc = "The riderless pale horse of the apocalypse."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "palehorse"
	icon_living = "palehorse"
	icon_dead = "palehorse"
	portrait = "pale_horse"
	speak_emote = list("neighs")
	threat_level = TETH_LEVEL
	maxHealth = 800
	health = 800
	pixel_x = -16
	base_pixel_x = -16
	stat_attack = DEAD
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0)
	can_breach = TRUE
	start_qliphoth = 4
	is_flying_animal = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = list(70, 65, 60, 50, 50),
	)
	work_damage_amount = 3
	work_damage_type = PALE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/revelation,
		/datum/ego_datum/armor/revelation,
	)
	gift_type =  /datum/ego_gifts/revelation
	gift_message = "He will wipe away every tear from their eyes, and death shall be evermore."

	//teleport
	var/can_act = TRUE
	var/teleport_cooldown
	var/teleport_cooldown_time = 30 SECONDS
	//attack
	var/mob/living/set_target
	var/pulse_range = 11 //fairly large area - enough to breach several abnormalities
	var/fog_damage = 3
	var/ash_damage = 20

//work stuff
/mob/living/simple_animal/hostile/abnormality/pale_horse/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/pale_horse/Worktick(mob/living/carbon/human/user)
	if(user.health < (user.maxHealth * 0.5))
		return
	else
		user.apply_damage(4, PALE_DAMAGE, null, user.run_armor_check(null, PALE_DAMAGE))

/mob/living/simple_animal/hostile/abnormality/pale_horse/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath))
	if(prob(1))
		icon_state = "palehorse_hungry"

/mob/living/simple_animal/hostile/abnormality/pale_horse/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/pale_horse/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	datum_reference.qliphoth_change(-1)
	return TRUE

//Breach stuff
/mob/living/simple_animal/hostile/abnormality/pale_horse/proc/TryTeleport() //stolen from knight of despair
	dir = 2
	if(teleport_cooldown > world.time)
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.xeno_spawn)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/pale_horse/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	SpawnFog() //Periodically spews out damaging fog while breaching

/mob/living/simple_animal/hostile/abnormality/pale_horse/proc/SpawnFog()
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(2, target_turf))
		if(prob(30))
			continue
		new /obj/effect/temp_visual/palefog(T)
		for(var/mob/living/H in T)
			if(faction_check_mob(H))
				continue
			H.apply_damage(fog_damage, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)


/mob/living/simple_animal/hostile/abnormality/pale_horse/Moved() //more damaging fog when moving
	. = ..()
	if(!.)
		return
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(1, target_turf))
		new /obj/effect/temp_visual/palefog(T)

/mob/living/simple_animal/hostile/abnormality/pale_horse/AttackingTarget()
	. = ..()
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/T = target
	if(T.health > 0)
		var/datum/status_effect/mortis/M = T.has_status_effect(/datum/status_effect/mortis)
		if(!M)
			say("#Neigh.")
			T.apply_status_effect(STATUS_EFFECT_MORTIS)
			playsound(T, 'sound/abnormalities/palehorse/debuff.ogg', 50, 0, -1)
		LoseTarget(T)
	else
		addtimer(CALLBACK(src, PROC_REF(TryTeleport)), 5)
		ToAshes(T)


/mob/living/simple_animal/hostile/abnormality/pale_horse/proc/ToAshes(target)
	var/mob/living/carbon/human/T = target
	playsound(get_turf(src), 'sound/abnormalities/palehorse/kill.ogg', 50, 0, 8)
	visible_message(span_danger("[T] collapses into a heap of ashes!"))
	new /obj/effect/particle_effect/smoke(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(7, get_turf(src))
	S.start()
	for(var/mob/living/simple_animal/hostile/abnormality/P in range(pulse_range, src))
		if(!(P.IsContained()))
			continue
		P.datum_reference.qliphoth_change(-1)
	for(var/turf/F in view(pulse_range, src))
		new /obj/effect/temp_visual/palefog(F)
		for(var/mob/living/H in F)
			if(faction_check_mob(H))
				continue
			H.apply_damage(ash_damage, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if(H.health < 0 && ishuman(H))
				H.dust()
	T.dust()

//Combat
/mob/living/simple_animal/hostile/abnormality/pale_horse/CanAttack(atom/the_target)
	if(!ishuman(the_target))
		return FALSE
	var/mob/living/carbon/human/H = the_target
	if (H.health > H.maxHealth*0.5) //ignore healthy people
		return FALSE
	if(H.has_status_effect(/datum/status_effect/mortis)) //find something else to chase or go idle
		return FALSE
	set_target = H
	return ..()

//Copied MOSB corpse-seeking behavior
/mob/living/simple_animal/hostile/abnormality/pale_horse/patrol_select()
	var/list/low_priority_turfs = list() // Oh, you're wounded, how nice.
	var/list/medium_priority_turfs = list() // You're about to die and you are close? Splendid.
	var/list/high_priority_turfs = list() // IS THAT A DEAD BODY?
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4) // Way too close
			continue
		if(H.stat != DEAD) // Not dead people
			if(H.health < H.maxHealth*0.5)
				if(get_dist(src, H) > 24) // Way too far
					low_priority_turfs += get_turf(H)
					continue
				medium_priority_turfs += get_turf(H)
			continue
		if(get_dist(src, H) > 24) // Those are dead people
			medium_priority_turfs += get_turf(H)
			continue
		high_priority_turfs += get_turf(H)

	var/turf/target_turf
	if(LAZYLEN(high_priority_turfs))
		target_turf = get_closest_atom(/turf/open, high_priority_turfs, src)
	else if(LAZYLEN(medium_priority_turfs))
		target_turf = get_closest_atom(/turf/open, medium_priority_turfs, src)
	else if(LAZYLEN(low_priority_turfs))
		target_turf = get_closest_atom(/turf/open, low_priority_turfs, src)

	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/pale_horse/Goto(target, delay, minimum_distance)
	if(LAZYLEN(patrol_path)) // This is here so projectiles won't cause it to go off track
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/pale_horse/GiveTarget(new_target)
	if(LAZYLEN(patrol_path))
		if(locate(/mob/living/carbon/human) in patrol_path[patrol_path.len])
			return // IGNORE EVERYTHING, CHARGE!!!!
	return ..()

/mob/living/simple_animal/hostile/abnormality/pale_horse/PickTarget(list/Targets) //Attack corpses first if there are any
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(L.health < 0 || L.stat == DEAD)
			if(ishuman(L))
				highest_priority += L
			else
				lower_priority += L
		else if(L.health < L.maxHealth*0.5)
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

//If it's not our target, we ignore it
/mob/living/simple_animal/hostile/abnormality/pale_horse/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(mover == set_target)
		return FALSE
	if(istype(mover, /obj/projectile))
		var/obj/projectile/P = mover
		if(P.firer == set_target)
			return FALSE

//objects
/obj/effect/temp_visual/palefog
	name = "fog"
	desc = "A vapor that faintly smells of formaldehyde."
	icon_state = "smoke"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	duration = 5

//status effects
//MORTIS - Raises pale vulnurability briefly and deals pale damage over time
/datum/status_effect/mortis
	id = "mortis"
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/mortis
	var/datum/abnormality/datum_reference = null
	var/damage = 2

/atom/movable/screen/alert/status_effect/mortis
	name = "Fated to die"
	desc = "The pale horse saw your end and wept."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "mortis"

/datum/status_effect/mortis/tick()
	owner.apply_damage(damage, PALE_DAMAGE, null, owner.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	if(owner.health < 0 && ishuman(owner))
		owner.dust()

/datum/status_effect/mortis/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	to_chat(owner, span_warning("You feel weak..."))
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.pale_mod *= 2

/datum/status_effect/mortis/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	to_chat(owner, span_warning("You regain your vigor."))
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.pale_mod /= 2

#undef STATUS_EFFECT_MORTIS
