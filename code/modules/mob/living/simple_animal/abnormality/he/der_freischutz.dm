/mob/living/simple_animal/hostile/abnormality/der_freischutz
	name = "Der Freischutz"
	desc = "A tall man adorned in grey, gold, and regal blue. His aim is impeccable."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "derfreischutz"
	icon_living = "derfreischutz"
	icon_dead = "derfreischutz"
	portrait = "der_freischutz"
	maxHealth = 1350
	health = 1350
	ranged = TRUE
	ranged_cooldown_time = 60
	minimum_distance = 2
	retreat_distance = 1
	move_to_delay = 5
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 2)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	vision_range = 20 // Fit for a marksman.
	aggro_vision_range = 26
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 30, // Can you believe he has actual attachment work rates in LC proper, despite that you can't do attachment work on him there?
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 60, 60, 60),
	)
	work_damage_amount = 8 // This was halved what it should be.
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/magicbullet,
		/datum/ego_datum/weapon/magicpistol,
		/datum/ego_datum/armor/magicbullet,
	)
	gift_type =  /datum/ego_gifts/magicbullet
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	var/can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/der_freischutz/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/OpenFire()
	if(!can_act)
		return
	can_act = FALSE
	var/turf/beam_start = get_turf(src)
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, 30, 0)
	var/turf/beam_end = target_turf
	var/list/turfs_to_check = getline(beam_start, target_turf)
	face_atom(target)
	for(var/turf/T in turfs_to_check)
		if(T.density)
			beam_end = T
			break
	new /datum/beam(beam_start.Beam(beam_end, "magic_bullet", time = 1 SECONDS))
	SLEEP_CHECK_DEATH(1 SECONDS)
	var/obj/projectile/ego_bullet/ego_magicbullet/B = new(beam_start)
	B.starting = beam_start
	B.firer = src
	B.fired_from = beam_start
	B.yo = beam_end.y - beam_start.y
	B.xo = beam_end.x - beam_start.x
	B.original = beam_end
	B.preparePixelProjectile(beam_end, beam_start)
	B.fire()
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/der_freischutz/Move()
	if(!can_act)
		return FALSE
	return ..()
//he walk

/mob/living/simple_animal/hostile/abnormality/der_freischutz/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/der_freischutz/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(75)))
	return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(50)))
	return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/ZeroQliphoth(mob/living/carbon/human/user)
	var/list/targets = list()
	var/turf/targetturf
	var/targetx
	var/targety
	for(var/mob/M in GLOB.mob_living_list)
		if(istype(M,/mob/living/simple_animal/bot) || (src.z != M.z) || (M.stat == DEAD) || (M.status_flags & GODMODE))
			continue
		targets += M
	var/mob/target = pick(targets)
	targetturf = target.loc
	targetx = targetturf.x
	targety = targetturf.y
	var/turf/centralturf
	var/centralx
	var/centraly
	for(var/turf/T in GLOB.department_centers)
		if(istype(get_area(T),/area/department_main/command))
			centralturf = T
			centralx = centralturf.x
			centraly = centralturf.y
	var/freidir
	if(abs(centralx - targetx) >= abs(centraly - targety))
		if(centralx > targetx)
			freidir = EAST
		else
			freidir = WEST
	else
		if(centraly > targety)
			freidir = NORTH
		else
			freidir = SOUTH
	src.fire_magic_bullet(targetturf, freidir)
	datum_reference.qliphoth_change(3)
	return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/Machine_Gun(mob/living/target = null, shots = 7)
	for(var/i = 0 to shots)
		if(!isnull(target))
			if(target.health <= 0)
				break
			fire_magic_bullet(target)
		else
			fire_magic_bullet()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/fire_magic_bullet(target = pick(GLOB.xeno_spawn), freidir = pick(EAST,WEST))
	src.icon = 'ModularTegustation/Teguicons/64x64.dmi'
	src.update_icon()
	var/offset = -12
	var/list/portals = list()
	var/turf/T = src.loc
	var/turf/barrel = locate(T.x + 2, T.y + 1, T.z)
	var/turf/tpos = target
	if (freidir == EAST)
		T = locate(tpos.x - 5, tpos.y, tpos.z)
	else if (freidir == WEST)
		T = locate(tpos.x + 5, tpos.y, tpos.z)
	else if (freidir == SOUTH)
		T = locate(tpos.x, tpos.y + 5, tpos.z)
	else
		T = locate(tpos.x, tpos.y - 5, tpos.z)
	playsound(T, 'sound/abnormalities/freischutz/prepare.ogg', 100, 0, 20)
	playsound(src.loc, 'sound/abnormalities/freischutz/prepare.ogg', 100, 0)
	for(var/i=1, i<5, i++)
		var/obj/effect/frei_magic/P = new(barrel)
		P.dir = EAST
		P.icon_state = "freicircle[i]"
		P.update_icon()
		P.pixel_x += offset
		portals += P
		var/obj/effect/frei_magic/PX = new(T)
		PX.dir = freidir
		PX.icon_state = "freicircle[i]"
		PX.update_icon()
		if (freidir == EAST)
			PX.pixel_x += offset
		else if (freidir == WEST)
			PX.pixel_x -= offset
		else if (freidir == SOUTH)
			PX.pixel_y -= offset
		else
			PX.pixel_y += offset
		offset += 8
		portals += PX
		sleep(6)
		if(i != 4)
			continue
		else
			var/obj/effect/magic_bullet/B = new(T)
			playsound(get_turf(src), 'sound/abnormalities/freischutz/shoot.ogg', 100, 0, 20)
			B.dir = freidir
			addtimer(CALLBACK(B, TYPE_PROC_REF(/obj/effect/magic_bullet, moveBullet)), 0.1)
			src.icon = 'ModularTegustation/Teguicons/32x64.dmi'
			src.update_icon()
			for(var/obj/effect/frei_magic/Port in portals)
				Port.fade_out()
	return

