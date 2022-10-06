/mob/living/simple_animal/hostile/abnormality/der_freischutz
	name = "Der Freischutz"
	desc = "A tall man adorned in grey, gold, and regal blue. His aim is impeccable."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "derfreischutz"
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 30, // Can you believe he has actual attachment work rates in LC proper, despite that you can't do attachment work on him there?
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 60, 60, 60)
		)
	work_damage_amount = 8 // This was halved what it should be.
	work_damage_type = BLACK_DAMAGE

	pinkable = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/magicbullet,
		/datum/ego_datum/weapon/magicpistol,
		/datum/ego_datum/armor/magicbullet
		)
	gift_type =  /datum/ego_gifts/magicbullet
	var/pink_cooldown = 30 SECONDS
	var/pink_shots = 0
	var/pink_declared = FALSE
	COOLDOWN_DECLARE(pink)

/mob/living/simple_animal/hostile/abnormality/der_freischutz/Life()
	. = ..()
	var/pink_midnight = FALSE
	for(var/mob/living/simple_animal/hostile/A in GLOB.mob_list)
		if(A != src)
			if("pink_midnight" in A.faction)
				pink_midnight = TRUE
				break
	if(pink_midnight)
		if(!pink_declared)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 5 SECONDS, "And so he once again picked up his gun for the one he loved.", 25))
			pink_declared = TRUE
		if(COOLDOWN_FINISHED(src, pink))
			if(pink_shots >= 7)
				pink_shots = 0
			pink_shots++

			var/list/targets = list()
			var/turf/targetturf
			var/targetx
			var/targety
			for(var/mob/M in GLOB.mob_living_list)
				if(pink_shots != 7)
					if(istype(M,/mob/living/simple_animal/hostile) || (src.z != M.z) || (M.stat == DEAD) || (M.status_flags & GODMODE))
						continue
					targets += M
				else
					if(!("pink_midnight" in M.faction))
						continue
					targets += M
			if(targets.len < 1)
				return
			COOLDOWN_START(src, pink, pink_cooldown)
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
	if(!pink_midnight && pink_declared)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 5 SECONDS, "The marksman, now a devil himself, continues to pull the trigger to gather the souls of others.", 25))
		pink_declared = FALSE

/mob/living/simple_animal/hostile/abnormality/der_freischutz/Initialize(mapload)
	. = ..()
	COOLDOWN_START(src, pink, pink_cooldown)

/mob/living/simple_animal/hostile/abnormality/der_freischutz/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(75)))
	return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(50)))
	return ..()

/mob/living/simple_animal/hostile/abnormality/der_freischutz/zero_qliphoth(mob/living/carbon/human/user)
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
			walk(B,freidir,0,0)
			src.icon = 'ModularTegustation/Teguicons/32x64.dmi'
			src.update_icon()
			for(var/obj/effect/frei_magic/Port in portals)
				Port.fade_out()
	return

