/mob/living/simple_animal/hostile/abnormality/express_train
	name = "Express Train to Hell"
	desc = "A creature with glowing eyes inside of an odd-looking ticket booth."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "express_booth0"
	icon_living = "express_booth0"
	portrait = "express_train"
	faction = list("hostile")
	speak_emote = list("drones")

	threat_level = WAW_LEVEL
	start_qliphoth = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	pixel_x = -16
	base_pixel_x = -16

	ego_list = list(
		/datum/ego_datum/weapon/intentions,
		/datum/ego_datum/armor/intentions,
		/datum/ego_datum/weapon/laststop,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	var/meltdown_tick = 60 SECONDS
	var/meltdown_timer
	var/lightscount = 0
	var/list/tickets = list()
	var/maxSegments = 5
	var/list/segments = list()
	var/list/damaged = list()

/mob/living/simple_animal/hostile/abnormality/express_train/Initialize()
	meltdown_timer = world.time + meltdown_tick
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/Life()
	if(meltdown_timer < world.time && !datum_reference?.working)
		if(datum_reference.qliphoth_meter)
			meltdown_timer = world.time + meltdown_tick
			datum_reference.qliphoth_change(-1)
			lightscount = 4 - datum_reference?.qliphoth_meter
			update_icon_state()
		else
			callTrain()
			meltdown_timer = world.time + meltdown_tick + 10 SECONDS
			datum_reference.qliphoth_change(4)
			lightscount = 0
			update_icon_state()
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/AttemptWork(mob/living/carbon/human/user, work_type)
	meltdown_timer += 100 SECONDS
	switch(datum_reference.qliphoth_meter)
		if(0)
			for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
				H.adjustSanityLoss(-50)
				H.adjustBruteLoss(-50)
			tickets |= user
		if(1)
			for(var/mob/living/carbon/human/H in livinginrange(30))
				H.adjustSanityLoss(-50)
				H.adjustBruteLoss(-50)
			tickets |= user
		if(2)
			user.adjustSanityLoss(-80)
			user.adjustBruteLoss(-80)
			tickets |= user
		if(3)
			user.adjustSanityLoss(-40)
			user.adjustBruteLoss(-40)
			tickets |= user
		if(4)
			say("No tickets available. Thank you for your interest.")
	return ..()

/mob/living/simple_animal/hostile/abnormality/express_train/WorkChance(mob/living/carbon/human/user, chance)
	chance += lightscount * 10
	return chance

/mob/living/simple_animal/hostile/abnormality/express_train/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(4)
	meltdown_timer = world.time + meltdown_tick
	lightscount = 0
	update_icon_state()
	return

/mob/living/simple_animal/hostile/abnormality/express_train/update_icon_state()
	icon_state = "express_booth[lightscount]"
	icon_living = icon_state

// This proc starts the automatic train-firing process by finding the point to aim at.

/mob/living/simple_animal/hostile/abnormality/express_train/proc/callTrain()
	for(var/mob/living/M in damaged)
		damaged -= M
	var/turf/aimTurf = pick(GLOB.department_centers)
	fireTrain(aimTurf.y, pick(EAST, WEST), aimTurf.z)

// This one actually makes and fires the train. I'll probably improve this so you can set a starting X as well sometime, or maybe adjust the number of segments...

/mob/living/simple_animal/hostile/abnormality/express_train/proc/fireTrain(aimpoint, direction = pick(EAST, WEST), aimZ = src.z)
	var/spawnX
	var/xIncrement
	var/persX
	if(direction == EAST)
		spawnX = 42
		xIncrement = -4
	else
		spawnX = 214
		xIncrement = 4
	var/spawnPoint = locate(spawnX, aimpoint, aimZ)
	for(var/i = 0, i < maxSegments * 2, i++)
		if(!(i % 2)) // True whenever i is even- this is the start of each segment
			persX += xIncrement*0.75 // Makes persX (effectively) one smaller for this iteration
		else
			persX += xIncrement
		spawnPoint = locate(spawnX + persX, aimpoint, aimZ)
		var/obj/effect/expresstrain/seg = new(spawnPoint)
		seg.dir = direction
		if(i < 2)
			seg.icon_state = "expressengine_[i % 2 + 1]"
			if(i % 2)
				persX -= xIncrement/4
			if(i == 0)
				notify_ghosts("[seg] is preparing to depart!", source = seg, action = NOTIFY_ORBIT, header="Something Interesting!") // bless this mess
		else
			seg.icon_state = "expresscar_[i % 2 + 1]"
			if(round(i / 2) % 2) // True when the current car is odd-numbered
				seg.pixel_x += xIncrement * 4
				seg.base_pixel_x += xIncrement * 4
			else if(i % 2)
				persX -= xIncrement/4
		segments += seg
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(sound_to_playing_players), 'sound/abnormalities/expresstrain/express_summoned.ogg', 50), 1)
	addtimer(CALLBACK(src, PROC_REF(moveTrain)), 10 SECONDS)
	/*
	The logic is pretty simple in what it's SUPPOSED to produce.
	Every train segment is comprised of 2 effects; the spawn positions of these effects are four tiles offset from one another. This number cannot change.
	However, the distance between the start of one segment and the end of another is roughly two and a half tiles.
	I am not touching the math that achieves this any more. If someone wants to refactor it to not cause headaches to look at, be my guest.
	*/

/mob/living/simple_animal/hostile/abnormality/express_train/proc/moveTrain()
	// I HATE CALLBACKS I HATE CALLBACKS I HATE CALLBACKS I HATE CALLBACKS I HATE CALLBACKS I HATE CALLBACKS
	if(LAZYLEN(src.segments))
		addtimer(CALLBACK(src, PROC_REF(moveTrain)), 0.5)
		for(var/obj/effect/expresstrain/seg in segments)
			if((seg.x < 10 && seg.dir == WEST) || (seg.x > 245 && seg.dir == EAST))
				QDEL_IN(seg, 1)
				src.segments -= seg
			else
				seg.forceMove(get_step(seg, seg.dir))
		damageTiles()

/mob/living/simple_animal/hostile/abnormality/express_train/proc/damageTiles()
	for(var/obj/effect/expresstrain/seg in segments)
		// I wanted to use bound_width and bound_height. For some GOD FORSAKEN REASON, they don't work. Welcome to hell.
		var/list/coveredTurfs = list()
		for(var/i = -1, i < 4, i++)
			for(var/j = -1, j < 3, j++)
				var/turf/T = locate(seg.x + i, seg.y + j, seg.z)
				coveredTurfs |= T
		for(var/turf/T in coveredTurfs)
			for(var/mob/living/M in T.contents)
				if(M in src.damaged)
					continue
				src.damaged += M
				if(!seg.noise && seg.icon_state == "expressengine_1") // choo choo
					if(rand())
						playsound(get_turf(seg), 'sound/abnormalities/expresstrain/express_horn.ogg', 100, 0, 40)
					else
						playsound(get_turf(seg), 'sound/abnormalities/expresstrain/express_whistle.ogg', 100, 0, 40)
					seg.noise = 1
				M.apply_damage(400, BLACK_DAMAGE, null, M.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				var/atom/throw_target = locate(M)
				throw_target = locate(M.x, M.y + pick(rand(-8, -5), rand(5, 8)), M.z)
				if(!M.anchored)
					M.throw_at(throw_target, rand(1, 2), 2, src)
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					for(var/obj/item/bodypart/part in C.bodyparts)
						if(part.dismemberable && prob(20) && part.body_part != HEAD && part.body_part != CHEST && C.stat == DEAD)
							part.dismember()
