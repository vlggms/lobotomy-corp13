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
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.5, FIRE = 0.5)
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
	chem_type = /datum/reagent/abnormality/sin/pride

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
	var/list/portals = list()
	var/zoomed = FALSE
	var/max_portals = 7
	var/current_portal_index = 0
	var/portal_cooldown
	var/portal_cooldown_time = 5 SECONDS

	//PLAYABLES ATTACKS (action in this case)
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom,
		/datum/action/cooldown/switch_portals,
		/datum/action/cooldown/remove_portal)

/mob/living/simple_animal/hostile/abnormality/der_freischutz/Login()
	. = ..()
	to_chat(src, "<h1>You are Der Freischutz, A Combat Role Abnormality.</h1><br>\
		<b>|Magic Bullet|: When you attack while not scoped in, there will be a 1.5 second delay before you fire a Magic Bullet. \
		The Magic Bullet deals BLACK damage and pieces through mobs. After firing a Magic Bullet, there is a 7 second cooldown between you can fire another one.<br>\
		<br>\
		|Devil's Contract|: Using the Sniper Sights ability on the top left of your screen you are able to increase your view range, see through walls and gain the ability to place down 'Magic Portals' \
		There is a 10 second cooldown between placing down portals, you can have a max of 7 portals and you can't place them in R-Corp's base or on dense terrain. \
		If you can't place down a portal, you will fire your Magic Bullet instead.<br>\
		<br>\
		|Devil's Sights|: You are able view through your portals using your 'Portal View' button on the top left of your screen, \
		Or you can use a hotkey. (Which is Space by default). When you use that ability, You will be able to toggle your view between the portals you have created. \
		While viewing through a portal, you will be able to cause them to fire towards any target you click on. They deal 25% less damage then your normal bullet, but each portal has their own cooldown between firing. \
		Also, you are able to destroy your own portals while viewing though them using your 'Removing Portal' ability, Or you can use a hotkey. (Which is E by default).\
		</b>")

/datum/action/cooldown/switch_portals
	name = "Portal View"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "freicircle2"
	desc = "Cycle through your currently active portals, to fire through them."
	cooldown_time = 10
	var/original_sight

/datum/action/cooldown/switch_portals/Grant(mob/living/L)
	. = ..()
	original_sight = owner.sight

/datum/action/cooldown/switch_portals/Trigger()
	if(!..())
		return FALSE
	if (!istype(owner, /mob/living/simple_animal/hostile/abnormality/der_freischutz))
		return
	var/mob/living/simple_animal/hostile/abnormality/der_freischutz/F = owner
	if(F.zoomed)
		return

	if(F.current_portal_index != 0)
		var/mob/living/simple_animal/hostile/der_freis_portal/P = F.portals[F.current_portal_index]
		P.StopSpin()

	F.current_portal_index = (F.current_portal_index + 1) % (F.portals.len + 1)
	if (F.current_portal_index == 0)
		F.client.eye = F
		F.sight = original_sight
	else
		F.client.eye = F.portals[F.current_portal_index]
		F.sight |= SEE_TURFS | SEE_MOBS | SEE_THRU | SEE_OBJS
		F.regenerate_icons()
		var/mob/living/simple_animal/hostile/der_freis_portal/P = F.portals[F.current_portal_index]
		P.StartSpin()




/datum/action/cooldown/remove_portal
	name = "Removing Portal"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "freicircle1"
	desc = "Remove the current portal you are currently viewing through."
	cooldown_time = 10
	var/original_sight

/datum/action/cooldown/remove_portal/Grant(mob/living/L)
	. = ..()
	original_sight = owner.sight

/datum/action/cooldown/remove_portal/Trigger()
	if(!..())
		return FALSE
	if (!istype(owner, /mob/living/simple_animal/hostile/abnormality/der_freischutz))
		return
	var/mob/living/simple_animal/hostile/abnormality/der_freischutz/F = owner
	F.RemovePortal()
	F.sight = original_sight

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

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/proc/ToggleZoom()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/der_freischutz))
		var/mob/living/simple_animal/hostile/abnormality/der_freischutz/F = owner
		F.zoomed = !F.zoomed

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/Activate()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/der_freischutz))
		var/mob/living/simple_animal/hostile/abnormality/der_freischutz/F = owner
		if (F.current_portal_index == 0)
			ActivateSignals()
			F.sight |= SEE_TURFS | SEE_MOBS | SEE_THRU
			F.regenerate_icons()
			F.client.view_size.zoomOut(zoom_out_amt, zoom_amt, owner.dir)
			ToggleZoom()
			return ..()
		else
			to_chat(F, "You are currently looking though a portal!")
			return FALSE
	else
		return FALSE

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/proc/ActivateSignals()
	SIGNAL_HANDLER

	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(Deactivate))
	RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, PROC_REF(Rotate))

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/Deactivate()
	DeactivateSignals()
	owner.sight = original_sight
	owner.regenerate_icons()
	owner.client.view_size.zoomIn()
	ToggleZoom()
	return ..()

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/proc/DeactivateSignals()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_ATOM_DIR_CHANGE)

/datum/action/innate/abnormality_attack/toggle/der_freischutz_zoom/proc/Rotate(old_dir, new_dir)
	SIGNAL_HANDLER

	owner.regenerate_icons()
	owner.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)


/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/RemovePortal(portal)
	var/P = portal
	if (!portal)
		P = portals[current_portal_index]
	portals.Remove(P)
	if (client.eye == P)
		client.eye = src
		current_portal_index = 0
	else
		if (istype(client.eye, /mob/living/simple_animal/hostile/der_freis_portal))
			var/mob/living/simple_animal/hostile/der_freis_portal/P2 = client.eye
			current_portal_index = portals.Find(P2)
	qdel(P)


/mob/living/simple_animal/hostile/abnormality/der_freischutz/AttackingTarget(atom/attacked_target)
	if(!target)
		GiveTarget(attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/OpenFire()
	if(!can_act)
		return
	var/turf/T = get_turf(target)
	var/area/A = get_area(T)
	if (zoomed)
		if (portals.len >= max_portals)
			to_chat(src, "Too many portals already!")
		else if (T.density == 1)
			to_chat(src, "Cannot place the portal there. Its to dense!")
		else if (istype(A, /area/city/outskirts/rcorp_base))
			to_chat(src, "Cannot place the portal inside the enemy base!")
		else if(portal_cooldown <= world.time)
			for(var/mob/living/simple_animal/hostile/der_freis_portal/P in T)
				to_chat(src, "Cannot place the portal on top of another")
				return
			portal_cooldown = world.time + portal_cooldown_time
			var/mob/living/simple_animal/hostile/der_freis_portal/P = new /mob/living/simple_animal/hostile/der_freis_portal(T)
			portals.Add(P)
			P.connected_abno = src
			return
		return
	if (current_portal_index > 0)
		var/mob/living/simple_animal/hostile/der_freis_portal/P = portals[current_portal_index]
		P.OpenFire(target)
	else
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
	var/obj/projectile/ego_bullet/ego_magicbullet/abnormality/B = new(start_turf) //80 BLACK damage.
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

/mob/living/simple_animal/hostile/abnormality/der_freischutz/death()
	for(var/mob/living/simple_animal/hostile/der_freis_portal/P in portals)
		P.death(FALSE)
	..()


/mob/living/simple_animal/hostile/der_freis_portal
	name = "magic portal"
	desc = "A strange blue portal... You feel like you are being watched though it."
	icon = 'icons/effects/effects.dmi'
	icon_state = "freicircle3"
	icon_living = "freicircle3"
	var/icon_selected = "freicircle2"
	maxHealth = 1000
	health = 1000
	can_patrol = FALSE
	wander = 0
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	obj_damage = 0
	del_on_death = TRUE
	alpha = 0
	density = FALSE
	environment_smash = ENVIRONMENT_SMASH_NONE
	death_message = "fades away..."
	AIStatus = AI_OFF
	var/bullet_cooldown
	var/bullet_cooldown_time = 7 SECONDS
	var/bullet_fire_delay = 1.5 SECONDS
	var/bullet_max_range = 50
	var/bullet_damage = 150

	var/mob/living/simple_animal/hostile/abnormality/der_freischutz/connected_abno
	var/datum/component/orbiter/self_orbiter

/mob/living/simple_animal/hostile/der_freis_portal/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 6)
	playsound(get_turf(src), 'sound/abnormalities/freischutz/portal.ogg', 100, 0, 10)

/mob/living/simple_animal/hostile/der_freis_portal/death()
	connected_abno.RemovePortal(src)
	..()

/mob/living/simple_animal/hostile/der_freis_portal/Move()
	return FALSE

/mob/living/simple_animal/hostile/der_freis_portal/AttackingTarget(atom/attacked_target)
	return OpenFire(attacked_target)

/mob/living/simple_animal/hostile/der_freis_portal/OpenFire(atom/target)
	if(bullet_cooldown <= world.time)
		PrepareFireBullet(target)

/mob/living/simple_animal/hostile/der_freis_portal/proc/PrepareFireBullet(atom/target)
	bullet_cooldown = world.time + bullet_cooldown_time
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

/mob/living/simple_animal/hostile/der_freis_portal/proc/FireBullet(atom/target, turf/start_turf, turf/end_turf)
	playsound(start_turf, 'sound/abnormalities/freischutz/shoot.ogg', 35, 0, 20)
	var/obj/projectile/ego_bullet/ego_magicbullet/abnormality/B = new(start_turf) //80 BLACK damage.
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

/mob/living/simple_animal/hostile/der_freis_portal/proc/StartSpin()
	icon_state = icon_selected

/mob/living/simple_animal/hostile/der_freis_portal/proc/StopSpin()
	icon_state = icon_living


/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/TriggerPortalView()
	for(var/datum/action/cooldown/switch_portals/A in actions)
		A.Trigger()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/proc/TriggerPortalRemove()
	for(var/datum/action/cooldown/remove_portal/A in actions)
		A.Trigger()

