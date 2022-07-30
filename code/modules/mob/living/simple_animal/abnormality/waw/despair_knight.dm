/mob/living/simple_animal/hostile/abnormality/despair_knight
	name = "Knight of despair"
	desc = "A tall humanoid abnormality in a blue dress. \
	Half of her head is black with sharp horn segments protruding out of it."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "despair"
	icon_living = "despair"
	icon_dead = "despair_dead"

	pixel_x = -8
	base_pixel_x = -8

	ranged = TRUE
	ranged_cooldown_time = 3 SECONDS
	minimum_distance = 2

	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)
	stat_attack = HARD_CRIT

	del_on_death = FALSE
	deathsound = 'sound/abnormalities/despairknight/dead.ogg'

	speed = 3
	move_to_delay = 4
	threat_level = WAW_LEVEL

	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 60),
						ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 35, 30)
						)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/despair,
		/datum/ego_datum/armor/despair
		)

	var/mob/living/carbon/human/blessed_human = null
	var/teleport_cooldown
	var/teleport_cooldown_time = 20 SECONDS

/mob/living/simple_animal/hostile/abnormality/despair_knight/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/despair_knight/OpenFire()
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	for(var/i = 1 to 4)
		var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
		if(T.density)
			i -= 1
			continue
		var/obj/projectile/despair_rapier/P = new(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = target.y - T.y
		P.xo = target.x - T.x
		P.original = target
		P.preparePixelProjectile(target, T)
		addtimer(CALLBACK (P, .obj/projectile/proc/fire), 3)
	SLEEP_CHECK_DEATH(3)
	playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/Life()
	. = ..()
	if(.)
		if(!client)
			if(teleport_cooldown <= world.time)
				TryTeleport()

/mob/living/simple_animal/hostile/abnormality/despair_knight/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/BlessedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	breach_effect()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/TryTeleport()
	if(teleport_cooldown > world.time)
		return FALSE
	if(target) // Actively fighting
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time
	var/targets_in_range = 0
	for(var/mob/living/L in view(10, src))
		if(!faction_check_mob(L) && L.stat != DEAD)
			targets_in_range += 1
	if(targets_in_range >= 3)
		return FALSE
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		var/targets_at_tile = 0
		for(var/mob/living/L in view(10, T))
			if(!faction_check_mob(L) && L.stat != DEAD)
				targets_at_tile += 1
		if(targets_at_tile >= 2)
			teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5) // TODO: Add some cool effects here
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/despair_knight/success_effect(mob/living/carbon/human/user, work_type, pe)
	if(!blessed_human && istype(user))
		blessed_human = user
		RegisterSignal(user, COMSIG_LIVING_DEATH, .proc/BlessedDeath)
		to_chat(user, "<span class='nicegreen'>You feel protected.</span>")
		user.physiology.red_mod *= 0.5
		user.physiology.white_mod *= 0.5
		user.physiology.black_mod *= 0.5
		user.physiology.pale_mod *= 2
		user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
		playsound(get_turf(user), 'sound/abnormalities/despairknight/gift.ogg', 50, 0, 2)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/breach_effect(mob/living/carbon/human/user)
	..()
	icon_living = "despair_breach"
	icon_state = icon_living
	addtimer(CALLBACK(src, .proc/TryTeleport), 5)
	return
