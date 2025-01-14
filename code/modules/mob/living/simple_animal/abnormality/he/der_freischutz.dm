/mob/living/simple_animal/hostile/abnormality/der_freischutz
	name = "Der Freischutz"
	desc = "A tall man adorned in grey, gold, and regal blue. His aim is impeccable."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "derfreischutz"
	icon_living = "derfreischutz"
	icon_dead = "derfreischutz"
	portrait = "der_freischutz"
	maxHealth = 900
	health = 900
	ranged = TRUE
	minimum_distance = 10
	retreat_distance = 2
	move_to_delay = 6
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.5)
	stat_attack = HARD_CRIT
	vision_range = 28 // Fit for a marksman.
	aggro_vision_range = 40
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

	observation_prompt = "Before you stands a man with an ornate rifle. <br>\
		\"My bullets never miss, whatever I take aim at will have its head pierced true by the inevitability of my bullets. <br>\
		If you have a target, you only need to make the payment.\""
	observation_choices = list(
		"Pay for his services" = list(TRUE, "True to his word, the marksman racks a bullet into his rifle, takes aim and fires at your target, piercing their head, but it travels on. <br>\
			Piercing the heads of others, forever."),
		"Don't pay" = list(FALSE, "The man scowls. <br>\"Don't waste my time with such shaky conviction.\""),
	)

	var/can_act = TRUE
	var/bullet_cooldown
	var/bullet_cooldown_time = 7 SECONDS
	var/bullet_fire_delay = 1.5 SECONDS
	var/bullet_max_range = 50
	var/bullet_damage = 80

	//PLAYABLES ATTACKS (action in this case)
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom)

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom
	name = "Toggle Sniper Sight"
	button_icon_state = "zoom_toggle0"
	chosen_message = span_warning("You activate your sniper sight.")
	button_icon_toggle_activated = "zoom_toggle1"
	toggle_message = span_warning("You deactivate your sniper sight.")
	button_icon_toggle_deactivated = "zoom_toggle0"
	var/zoom_out_amt = 5.5
	var/zoom_amt = 10
	var/original_sight

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/Grant(mob/living/L)
	. = ..()
	original_sight = owner.sight

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/Activate()
	ActivateSignals()
	owner.sight |= SEE_TURFS | SEE_MOBS | SEE_THRU
	owner.regenerate_icons()
	owner.client.view_size.zoomOut(zoom_out_amt, zoom_amt, owner.dir)
	return ..()

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/proc/ActivateSignals()
	SIGNAL_HANDLER

	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(Deactivate))
	RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, PROC_REF(Rotate))

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/Deactivate()
	DeactivateSignals()
	owner.sight = original_sight
	owner.regenerate_icons()
	owner.client.view_size.zoomIn()
	return ..()

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/proc/DeactivateSignals()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_ATOM_DIR_CHANGE)

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/proc/Rotate(old_dir, new_dir)
	SIGNAL_HANDLER

	owner.regenerate_icons()
	owner.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)


/mob/living/simple_animal/hostile/abnormality/der_freischutz/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/OpenFire()
	if(!can_act)
		return
	if(bullet_cooldown <= world.time)
		PrepareFireBullet(target)

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/IconChange(firing)
	if(firing)
		pixel_x -= 32
		icon = 'ModularTegustation/Teguicons/96x64.dmi'
		update_icon()
		return
	pixel_x += 32
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	update_icon()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/PrepareFireBullet(atom/target)
	bullet_cooldown = world.time + bullet_cooldown_time
	can_act = FALSE
	IconChange(firing = TRUE)
	var/turf/beam_start = get_turf(src)
	var/turf/target_turf = get_ranged_target_turf_direct(src, target, bullet_max_range, 0)
	var/turf/beam_end = target_turf
	var/list/turfs_to_check = getline(beam_start, target_turf)
	playsound(beam_start, 'sound/abnormalities/freischutz/prepare.ogg', 35, 0, 20)
	face_atom(target)
	for(var/turf/T in turfs_to_check)
		if(T.density)
			beam_end = T
			break
	new /datum/beam(beam_start.Beam(beam_end, "magic_bullet", time = bullet_fire_delay))
	SLEEP_CHECK_DEATH(bullet_fire_delay)
	FireBullet(target, beam_start, beam_end)

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/FireBullet(atom/target, turf/start_turf, turf/end_turf)
	playsound(start_turf, 'sound/abnormalities/freischutz/shoot.ogg', 35, 0, 20)
	var/obj/projectile/ego_bullet/ego_magicbullet/B = new(start_turf) //80 BLACK damage.
	B.starting = start_turf
	B.firer = src
	B.fired_from = start_turf
	B.yo = end_turf.y - start_turf.y
	B.xo = end_turf.x - start_turf.x
	B.original = end_turf
	B.preparePixelProjectile(end_turf, start_turf)
	B.range = bullet_max_range
	B.damage = bullet_damage
	B.fire()
	new /datum/beam(start_turf.Beam(end_turf, "magic_bullet_tracer", time = 3 SECONDS))
	IconChange(firing = FALSE)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/der_freischutz/Move()
	if(!can_act)
		return FALSE
	return ..()

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
	IconChange(firing = TRUE)
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
			IconChange(firing = FALSE)
			for(var/obj/effect/frei_magic/Port in portals)
				Port.fade_out()
	return
