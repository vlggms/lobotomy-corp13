#define HAL_LINES_FILE "hallucination.json"
#define INSANITY_LINES_FILE "insanity.json"

GLOBAL_LIST_INIT(hallucination_list, list(
	/datum/hallucination/chat = 70,
	/datum/hallucination/message = 50,
	/datum/hallucination/sounds = 30,
	/datum/hallucination/battle = 20,
	/datum/hallucination/dangerflash = 15,
	/datum/hallucination/hudscrew = 12,
	/datum/hallucination/fake_alert = 12,
	/datum/hallucination/delusion = 7,
	/datum/hallucination/stationmessage = 2,
	/datum/hallucination/self_delusion = 2
	))


/mob/living/carbon/proc/handle_hallucinations()
	if(!hallucination)
		return

	hallucination = max(hallucination - 1, 0)

	if(world.time < next_hallucination)
		return

	var/halpick = pickweight(GLOB.hallucination_list)
	new halpick(src, FALSE)

	next_hallucination = world.time + rand(100, 600)

/mob/living/carbon/proc/set_screwyhud(hud_type)
	hal_screwyhud = hud_type
	update_health_hud()

/datum/hallucination
	var/natural = TRUE
	var/mob/living/carbon/target
	var/feedback_details //extra info for investigate

/datum/hallucination/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	target = C
	natural = !forced

	// Cancel early if the target is deleted
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(target_deleting))

/datum/hallucination/proc/target_deleting()
	SIGNAL_HANDLER

	qdel(src)

/datum/hallucination/proc/wake_and_restore()
	target.set_screwyhud(SCREWYHUD_NONE)
	target.SetSleeping(0)

/datum/hallucination/Destroy()
	target.investigate_log("was afflicted with a hallucination of type [type] by [natural?"hallucination status":"an external source"]. [feedback_details]", INVESTIGATE_HALLUCINATIONS)

	if (target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)

	target = null
	return ..()

//Returns a random turf in a ring around the target mob, useful for sound hallucinations
/datum/hallucination/proc/random_far_turf()
	var/x_based = prob(50)
	var/first_offset = pick(-8,-7,-6,-5,5,6,7,8)
	var/second_offset = rand(-8,8)
	var/x_off
	var/y_off
	if(x_based)
		x_off = first_offset
		y_off = second_offset
	else
		y_off = first_offset
		x_off = second_offset
	var/turf/T = locate(target.x + x_off, target.y + y_off, target.z)
	return T

/obj/effect/hallucination
	invisibility = INVISIBILITY_OBSERVER
	anchored = TRUE
	var/mob/living/carbon/target = null

/obj/effect/hallucination/simple
	var/image_icon = 'icons/mob/alien.dmi'
	var/image_state = "alienh_pounce"
	var/px = 0
	var/py = 0
	var/col_mod = null
	var/image/current_image = null
	var/image_layer = MOB_LAYER
	var/active = TRUE //qdelery

/obj/effect/hallucination/singularity_pull()
	return

/obj/effect/hallucination/singularity_act()
	return

/obj/effect/hallucination/simple/Initialize(mapload, mob/living/carbon/T)
	. = ..()
	target = T
	current_image = GetImage()
	if(target.client)
		target.client.images |= current_image

/obj/effect/hallucination/simple/proc/GetImage()
	var/image/I = image(image_icon,src,image_state,image_layer,dir=src.dir)
	I.pixel_x = px
	I.pixel_y = py
	if(col_mod)
		I.color = col_mod
	return I

/obj/effect/hallucination/simple/proc/Show(update=1)
	if(active)
		if(target.client)
			target.client.images.Remove(current_image)
		if(update)
			current_image = GetImage()
		if(target.client)
			target.client.images |= current_image

/obj/effect/hallucination/simple/update_icon(new_state,new_icon,new_px=0,new_py=0)
	image_state = new_state
	if(new_icon)
		image_icon = new_icon
	else
		image_icon = initial(image_icon)
	px = new_px
	py = new_py
	Show()

/obj/effect/hallucination/simple/Moved(atom/OldLoc, Dir)
	. = ..()
	Show()

/obj/effect/hallucination/simple/Destroy()
	if(target.client)
		target.client.images.Remove(current_image)
	active = FALSE
	return ..()

#define FAKE_FLOOD_EXPAND_TIME 20
#define FAKE_FLOOD_MAX_RADIUS 10

/obj/effect/plasma_image_holder
	icon_state = "nothing"
	anchored = TRUE
	layer = FLY_LAYER
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/hallucination/fake_flood
	//Plasma starts flooding from the nearby vent
	var/turf/center
	var/list/flood_images = list()
	var/list/flood_image_holders = list()
	var/list/turf/flood_turfs = list()
	var/image_icon = 'icons/effects/atmospherics.dmi'
	var/image_state = "plasma"
	var/radius = 0
	var/next_expand = 0

/datum/hallucination/fake_flood/New(mob/living/carbon/C, forced = TRUE)
	..()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in orange(7,target))
		if(!U.welded)
			center = get_turf(U)
			break
	if(!center)
		qdel(src)
		return
	feedback_details += "Vent Coords: [center.x],[center.y],[center.z]"
	var/obj/effect/plasma_image_holder/pih = new(center)
	var/image/plasma_image = image(image_icon, pih, image_state, FLY_LAYER)
	plasma_image.alpha = 50
	plasma_image.plane = GAME_PLANE
	flood_images += plasma_image
	flood_image_holders += pih
	flood_turfs += center
	if(target.client)
		target.client.images |= flood_images
	next_expand = world.time + FAKE_FLOOD_EXPAND_TIME
	START_PROCESSING(SSobj, src)

/datum/hallucination/fake_flood/process()
	if(next_expand <= world.time)
		radius++
		if(radius > FAKE_FLOOD_MAX_RADIUS)
			qdel(src)
			return
		Expand()
		if((get_turf(target) in flood_turfs) && !target.internal)
			new /datum/hallucination/fake_alert(target, TRUE, "too_much_tox")
		next_expand = world.time + FAKE_FLOOD_EXPAND_TIME

/datum/hallucination/fake_flood/proc/Expand()
	for(var/image/I in flood_images)
		I.alpha = min(I.alpha + 50, 255)
	for(var/turf/FT in flood_turfs)
		for(var/dir in GLOB.cardinals)
			var/turf/T = get_step(FT, dir)
			if((T in flood_turfs) || !TURFS_CAN_SHARE(T, FT) || isspaceturf(T)) //If we've gottem already, or if they're not alright to spread with.
				continue
			var/obj/effect/plasma_image_holder/pih = new(T)
			var/image/new_plasma = image(image_icon, pih, image_state, FLY_LAYER)
			new_plasma.alpha = 50
			new_plasma.plane = GAME_PLANE
			flood_images += new_plasma
			flood_image_holders += pih
			flood_turfs += T
	if(target.client)
		target.client.images |= flood_images

/datum/hallucination/fake_flood/Destroy()
	STOP_PROCESSING(SSobj, src)
	qdel(flood_turfs)
	flood_turfs = list()
	if(target.client)
		target.client.images.Remove(flood_images)
	qdel(flood_images)
	flood_images = list()
	qdel(flood_image_holders)
	flood_image_holders = list()
	return ..()

/obj/effect/hallucination/simple/xeno
	image_icon = 'icons/mob/alien.dmi'
	image_state = "alienh_pounce"

/obj/effect/hallucination/simple/xeno/Initialize(mapload, mob/living/carbon/T)
	. = ..()
	name = "alien hunter ([rand(1, 1000)])"

/obj/effect/hallucination/simple/xeno/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	update_icon("alienh_pounce")
	if(hit_atom == target && target.stat!=DEAD)
		target.Paralyze(100)
		target.visible_message("<span class='danger'>[target] flails around wildly.</span>","<span class='userdanger'>[name] pounces on you!</span>")

// The numbers of seconds it takes to get to each stage of the xeno attack choreography
#define XENO_ATTACK_STAGE_LEAP_AT_TARGET 1
#define XENO_ATTACK_STAGE_LEAP_AT_PUMP 2
#define XENO_ATTACK_STAGE_CLIMB 3
#define XENO_ATTACK_STAGE_FINISH 6

/// Xeno crawls from nearby vent,jumps at you, and goes back in
/datum/hallucination/xeno_attack
	var/turf/pump_location = null
	var/obj/effect/hallucination/simple/xeno/xeno = null
	var/time_processing = 0
	var/stage = XENO_ATTACK_STAGE_LEAP_AT_TARGET

/datum/hallucination/xeno_attack/New(mob/living/carbon/C, forced = TRUE)
	..()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in orange(7,target))
		if(!U.welded)
			pump_location = get_turf(U)
			break

	if(pump_location)
		feedback_details += "Vent Coords: [pump_location.x],[pump_location.y],[pump_location.z]"
		xeno = new(pump_location, target)
		START_PROCESSING(SSfastprocess, src)
	else
		qdel(src)

/datum/hallucination/xeno_attack/process(delta_time)
	time_processing += delta_time

	if (time_processing >= stage)
		switch (time_processing)
			if (XENO_ATTACK_STAGE_FINISH to INFINITY)
				to_chat(target, "<span class='notice'>[xeno.name] scrambles into the ventilation ducts!</span>")
				qdel(src)
			if (XENO_ATTACK_STAGE_CLIMB to XENO_ATTACK_STAGE_FINISH)
				to_chat(target, "<span class='notice'>[xeno.name] begins climbing into the ventilation system...</span>")
				stage = XENO_ATTACK_STAGE_FINISH
			if (XENO_ATTACK_STAGE_LEAP_AT_PUMP to XENO_ATTACK_STAGE_CLIMB)
				xeno.update_icon("alienh_leap",'icons/mob/alienleap.dmi', -32, -32)
				xeno.throw_at(pump_location, 7, 1, spin = FALSE, diagonals_first = TRUE)
				stage = XENO_ATTACK_STAGE_CLIMB
			if (XENO_ATTACK_STAGE_LEAP_AT_TARGET to XENO_ATTACK_STAGE_LEAP_AT_PUMP)
				xeno.update_icon("alienh_leap",'icons/mob/alienleap.dmi', -32, -32)
				xeno.throw_at(target, 7, 1, spin = FALSE, diagonals_first = TRUE)
				stage = XENO_ATTACK_STAGE_LEAP_AT_PUMP

/datum/hallucination/xeno_attack/Destroy()
	. = ..()

	STOP_PROCESSING(SSfastprocess, src)
	QDEL_NULL(xeno)
	pump_location = null

#undef XENO_ATTACK_STAGE_LEAP_AT_TARGET
#undef XENO_ATTACK_STAGE_LEAP_AT_PUMP
#undef XENO_ATTACK_STAGE_CLIMB
#undef XENO_ATTACK_STAGE_FINISH

/obj/effect/hallucination/simple/clown
	image_icon = 'icons/mob/animal.dmi'
	image_state = "clown"

/obj/effect/hallucination/simple/clown/Initialize(mapload, mob/living/carbon/T, duration)
	..(loc, T)
	name = pick(GLOB.clown_names)
	QDEL_IN(src,duration)

/obj/effect/hallucination/simple/clown/scary
	image_state = "scary_clown"

/obj/effect/hallucination/simple/bubblegum
	name = "Bubblegum"
	image_icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	image_state = "bubblegum"
	px = -32

/datum/hallucination/oh_yeah
	var/obj/effect/hallucination/simple/bubblegum/bubblegum
	var/image/fakebroken
	var/image/fakerune
	var/turf/landing
	var/charged
	var/next_action = 0

/datum/hallucination/oh_yeah/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	. = ..()
	var/turf/closed/wall/wall
	for(var/turf/closed/wall/W in range(7,target))
		wall = W
		break
	if(!wall)
		return INITIALIZE_HINT_QDEL
	feedback_details += "Source: [wall.x],[wall.y],[wall.z]"

	fakebroken = image('icons/turf/floors.dmi', wall, "plating", layer = TURF_LAYER)
	landing = get_turf(target)
	var/turf/landing_image_turf = get_step(landing, SOUTHWEST) //the icon is 3x3
	fakerune = image('icons/effects/96x96.dmi', landing_image_turf, "landing", layer = ABOVE_OPEN_TURF_LAYER)
	fakebroken.override = TRUE
	if(target.client)
		target.client.images |= fakebroken
		target.client.images |= fakerune
	target.playsound_local(wall,'sound/effects/meteorimpact.ogg', 150, 1)
	bubblegum = new(wall, target)
	addtimer(CALLBACK(src, PROC_REF(start_processing)), 10)

/datum/hallucination/oh_yeah/proc/start_processing()
	if (isnull(target))
		qdel(src)
		return
	START_PROCESSING(SSfastprocess, src)

/datum/hallucination/oh_yeah/process(delta_time)
	next_action -= delta_time

	if (next_action > 0)
		return

	if (get_turf(bubblegum) != landing && target?.stat != DEAD)
		if(!landing || (get_turf(bubblegum)).loc.z != landing.loc.z)
			qdel(src)
			return
		bubblegum.forceMove(get_step_towards(bubblegum, landing))
		bubblegum.setDir(get_dir(bubblegum, landing))
		target.playsound_local(get_turf(bubblegum), 'sound/effects/meteorimpact.ogg', 150, 1)
		shake_camera(target, 2, 1)
		if(bubblegum.Adjacent(target) && !charged)
			charged = TRUE
			target.Paralyze(80)
			target.adjustStaminaLoss(40)
			step_away(target, bubblegum)
			shake_camera(target, 4, 3)
			target.visible_message("<span class='warning'>[target] jumps backwards, falling on the ground!</span>","<span class='userdanger'>[bubblegum] slams into you!</span>")
		next_action = 0.2
	else
		STOP_PROCESSING(SSfastprocess, src)
		QDEL_IN(src, 3 SECONDS)

/datum/hallucination/oh_yeah/Destroy()
	if(target.client)
		target.client.images.Remove(fakebroken)
		target.client.images.Remove(fakerune)
	QDEL_NULL(fakebroken)
	QDEL_NULL(fakerune)
	QDEL_NULL(bubblegum)
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/hallucination/battle
	var/battle_type
	var/iterations_left
	var/hits = 0
	var/next_action = 0
	var/turf/source

/datum/hallucination/battle/New(mob/living/carbon/C, forced = TRUE, new_battle_type)
	..()

	source = random_far_turf()

	battle_type = new_battle_type
	if (isnull(battle_type))
		battle_type = pick("gun","harmbaton")
	feedback_details += "Type: [battle_type]"
	var/process = TRUE

	switch(battle_type)
		if("gun")
			iterations_left = rand(3, 6)
		if("harmbaton") //zap n slap
			iterations_left = rand(5, 12)
			target.playsound_local(source, 'sound/weapons/egloves.ogg', 40, 1)
			target.playsound_local(source, get_sfx("bodyfall"), 25, 1)
			next_action = 2 SECONDS

	if (process)
		START_PROCESSING(SSfastprocess, src)
	else
		qdel(src)

/datum/hallucination/battle/process(delta_time)
	next_action -= (delta_time * 10)

	if (next_action > 0)
		return

	switch (battle_type)
		if ("disabler", "laser", "gun")
			var/fire_sound
			var/hit_person_sound
			var/hit_wall_sound
			var/number_of_hits
			var/chance_to_fall

			switch (battle_type)
				if ("disabler")
					fire_sound = 'sound/weapons/taser2.ogg'
					hit_person_sound = 'sound/weapons/tap.ogg'
					hit_wall_sound = 'sound/weapons/effects/searwall.ogg'
					number_of_hits = 3
					chance_to_fall = 70
				if ("laser")
					fire_sound = 'sound/weapons/laser.ogg'
					hit_person_sound = 'sound/weapons/sear.ogg'
					hit_wall_sound = 'sound/weapons/effects/searwall.ogg'
					number_of_hits = 4
					chance_to_fall = 70
				if ("gun")
					fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
					hit_person_sound = 'sound/weapons/pierce.ogg'
					hit_wall_sound = "ricochet"
					number_of_hits = 2
					chance_to_fall = 80

			target.playsound_local(source, fire_sound, 25, 1)

			if(prob(50))
				addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, hit_person_sound, 25, 1), rand(5,10))
				hits += 1
			else
				addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, hit_wall_sound, 25, 1), rand(5,10))

			next_action = rand(CLICK_CD_RANGE, CLICK_CD_RANGE + 6)

			if(hits >= number_of_hits && prob(chance_to_fall))
				addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, get_sfx("bodyfall"), 25, 1), next_action)
				qdel(src)
				return
		if ("esword")
			target.playsound_local(source, 'sound/weapons/blade1.ogg', 50, 1)

			if (hits == 4)
				target.playsound_local(source, get_sfx("bodyfall"), 25, 1)

			next_action = rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 6)
			hits += 1

			if (iterations_left == 1)
				target.playsound_local(source, 'sound/weapons/saberoff.ogg', 15, 1)
		if ("harmbaton")
			target.playsound_local(source, "swing_hit", 50, 1)
			next_action = rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 4)
		if ("bomb")
			target.playsound_local(source, 'sound/items/timer.ogg', 25, 0)
			next_action = 15

	iterations_left -= 1
	if (iterations_left == 0)
		qdel(src)

/datum/hallucination/battle/Destroy()
	. = ..()
	source = null
	STOP_PROCESSING(SSfastprocess, src)

/datum/hallucination/items_other

/datum/hallucination/items_other/New(mob/living/carbon/C, forced = TRUE, item_type)
	set waitfor = FALSE
	..()
	var/item
	if(!item_type)
		item = pick(list("esword","taser","ebow","baton","dual_esword","ttv","flash","armblade"))
	else
		item = item_type
	feedback_details += "Item: [item]"
	var/side
	var/image_file
	var/image/A = null
	var/list/mob_pool = list()

	for(var/mob/living/carbon/human/M in view(7,target))
		if(M != target)
			mob_pool += M
	if(!mob_pool.len)
		return

	var/mob/living/carbon/human/H = pick(mob_pool)
	feedback_details += " Mob: [H.real_name]"

	var/free_hand = H.get_empty_held_index_for_side(LEFT_HANDS)
	if(free_hand)
		side = "left"
	else
		free_hand = H.get_empty_held_index_for_side(RIGHT_HANDS)
		if(free_hand)
			side = "right"

	if(side)
		switch(item)
			if("esword")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
				target.playsound_local(H, 'sound/weapons/saberon.ogg',35,1)
				A = image(image_file,H,"swordred", layer=ABOVE_MOB_LAYER)
			if("dual_esword")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
				target.playsound_local(H, 'sound/weapons/saberon.ogg',35,1)
				A = image(image_file,H,"dualsaberred1", layer=ABOVE_MOB_LAYER)
			if("taser")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
				A = image(image_file,H,"advtaserstun4", layer=ABOVE_MOB_LAYER)
			if("ebow")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
				A = image(image_file,H,"crossbow", layer=ABOVE_MOB_LAYER)
			if("baton")
				if(side == "right")
					image_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
				target.playsound_local(H, "sparks",75,1,-1)
				A = image(image_file,H,"baton", layer=ABOVE_MOB_LAYER)
			if("ttv")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/bombs_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/bombs_lefthand.dmi'
				A = image(image_file,H,"ttv", layer=ABOVE_MOB_LAYER)
			if("flash")
				if(side == "right")
					image_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
				A = image(image_file,H,"flashtool", layer=ABOVE_MOB_LAYER)
			if("armblade")
				if(side == "right")
					image_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
				target.playsound_local(H, 'sound/effects/blobattack.ogg',30,1)
				A = image(image_file,H,"arm_blade", layer=ABOVE_MOB_LAYER)
		if(target.client)
			target.client.images |= A
			addtimer(CALLBACK(src, PROC_REF(cleanup), item, A, H), rand(15 SECONDS, 25 SECONDS))
			return
	qdel(src)

/datum/hallucination/items_other/proc/cleanup(item, atom/image_used, has_the_item)
	if (isnull(target))
		qdel(src)
		return
	if(item == "esword" || item == "dual_esword")
		target.playsound_local(has_the_item, 'sound/weapons/saberoff.ogg',35,1)
	if(item == "armblade")
		target.playsound_local(has_the_item, 'sound/effects/blobattack.ogg',30,1)
	target.client.images.Remove(image_used)
	qdel(src)

/datum/hallucination/delusion
	var/list/image/delusions = list()

/datum/hallucination/delusion/New(mob/living/carbon/C, forced, force_kind = null , duration = 300,skip_nearby = FALSE, custom_icon = null, custom_icon_file = null, custom_name = null)
	set waitfor = FALSE
	. = ..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("slime", "nakednest","bigbee","witchfriend","witch","censored","fairy","thunderbird")
	feedback_details += "Type: [kind]"
	var/list/nearby
	if(skip_nearby)
		nearby = get_hearers_in_view(7, target)
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(H == target)
			continue
		if(skip_nearby && (H in nearby))
			continue
		switch(kind)
			if("nothing")
				A = image('icons/effects/effects.dmi',H,"nothing")
				A.name = "..."
			if("monkey")//Monkey
				A = image('icons/mob/monkey.dmi',H,"monkey1")
				A.name = "Monkey ([rand(1,999)])"
			if("carp")//Carp
				A = image('icons/mob/carp.dmi',H,"carp")
				A.name = "Space Carp"
			if("corgi")//Corgi
				A = image('icons/mob/pets.dmi',H,"corgi")
				A.name = "Corgi"
			if("skeleton")//Skeletons
				A = image('icons/mob/human.dmi',H,"skeleton")
				A.name = "Skeleton"
			if("zombie")//Zombies
				A = image('icons/mob/human.dmi',H,"zombie")
				A.name = "Zombie"
			if("demon")//Demon
				A = image('icons/mob/mob.dmi',H,"daemon")
				A.name = "Demon"
			if("slime")
				A = image('ModularTegustation/Teguicons/32x32.dmi', H, "little_slime")
				A.name = "Slime Pawn"
				A.desc = "The skeletal remains of a former employee is floating in it..."
			if("nakednest")
				A = image('ModularTegustation/Teguicons/tegumobs.dmi', H, "nakednest_minion")
				A.name = "Naked Nest"
				A.desc = "A humanoid form covered in scales with numerous holes. It looks like it has reinforced itself with its hosts armor."
			if("bigbee")
				A = image('ModularTegustation/Teguicons/48x96.dmi', H, "artillerysergeant")
				A.name = "Artillery Bee"
				A.desc = "A disfigured creature with nasty fangs, and an oversized thorax."
			if("witchfriend")
				A = image('ModularTegustation/Teguicons/64x48.dmi', H, "witchfriend")
				A.name = "Little Witch's Friend"
				A.desc = "It's a horrifying amalgamation of flesh and eyes."
			if("witch")
				A = image('ModularTegustation/Teguicons/tegumobs.dmi', H, "laetitia")
				A.name = "Laetitia"
				A.desc = "A wee witch."
			if("censored")
				A = image('ModularTegustation/Teguicons/32x32.dmi', H, "censored_mini")
				A.name = H.name
				A.desc = "What the hell is this? It shouldn't exist..."
			if("fairy")
				A = image('ModularTegustation/Teguicons/tegumobs.dmi', H, "fairyswarm")
				A.name = "Fairy"
				A.desc = "A tiny, extremely hungry fairy."
			if("thunderbird")
				A = image('ModularTegustation/Teguicons/32x32.dmi', H, "human_thunderbolt")
				A.name = H.name
				A.desc = "What appears to be human, only charred and screaming incoherently..."
			if("custom")
				A = image(custom_icon_file, H, custom_icon)
				A.name = custom_name
		A.override = 1
		if(target.client)
			delusions |= A
			target.client.images |= A
	if(duration)
		QDEL_IN(src, duration)

/datum/hallucination/delusion/Destroy()
	for(var/image/I in delusions)
		if(target.client)
			target.client.images.Remove(I)
	return ..()

/datum/hallucination/self_delusion
	var/image/delusion

/datum/hallucination/self_delusion/New(mob/living/carbon/C, forced, force_kind = null , duration = 300, custom_icon = null, custom_icon_file = null, wabbajack = TRUE) //set wabbajack to false if you want to use another fake source
	set waitfor = FALSE
	..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("slime", "nakednest","bigbee","witchfriend","witch","censored","fairy","thunderbird")
	feedback_details += "Type: [kind]"
	switch(kind)
		if("monkey")//Monkey
			A = image('icons/mob/monkey.dmi',target,"monkey1")
		if("carp")//Carp
			A = image('icons/mob/animal.dmi',target,"carp")
		if("corgi")//Corgi
			A = image('icons/mob/pets.dmi',target,"corgi")
		if("skeleton")//Skeletons
			A = image('icons/mob/human.dmi',target,"skeleton")
		if("zombie")//Zombies
			A = image('icons/mob/human.dmi',target,"zombie")
		if("demon")//Demon
			A = image('icons/mob/mob.dmi',target,"daemon")
		if("robot")//Cyborg
			A = image('icons/mob/robots.dmi',target,"robot")
			target.playsound_local(target,'sound/voice/liveagain.ogg', 75, 1)
		if("slime")
			A = image('ModularTegustation/Teguicons/32x32.dmi', target, "little_slime")
			target.playsound_local(target,'sound/creatures/legion_death_far.ogg', 65, 1)
		if("nakednest")
			A = image('ModularTegustation/Teguicons/tegumobs.dmi', target, "nakednest_minion")
			target.playsound_local(target,'sound/misc/moist_impact.ogg', 60, 1)
		if("bigbee")
			A = image('ModularTegustation/Teguicons/48x96.dmi', target, "artillerysergeant")
		if("witchfriend")
			A = image('ModularTegustation/Teguicons/64x48.dmi', target, "witchfriend")
			target.playsound_local(target,'sound/abnormalities/laetitia/spider_born.ogg', 50, 1)
		if("witch")
			A = image('ModularTegustation/Teguicons/tegumobs.dmi', target, "laetitia")
		if("censored")
			A = image('ModularTegustation/Teguicons/32x32.dmi', target, "censored_mini")
			target.playsound_local(target, 'sound/abnormalities/censored/mini_born.ogg', 50, 1, 4)
		if("fairy")
			A = image('ModularTegustation/Teguicons/tegumobs.dmi', target, "fairyswarm")
		if("thunderbird")
			A = image('ModularTegustation/Teguicons/32x32.dmi', target, "human_thunderbolt")
		if("custom")
			A = image(custom_icon_file, target, custom_icon)
	A.override = 1
	if(target.client)
		/*
		if(wabbajack)
			to_chat(target, "<span class='hear'>...wabbajack...wabbajack...</span>")
			target.playsound_local(target,'sound/magic/staff_change.ogg', 50, 1)
		*/
		delusion = A
		target.client.images |= A
	QDEL_IN(src, duration)

/datum/hallucination/self_delusion/Destroy()
	if(target.client)
		target.client.images.Remove(delusion)
	return ..()

/datum/hallucination/bolts
	var/list/airlocks_to_hit
	var/list/locks
	var/next_action = 0
	var/locking = TRUE

/datum/hallucination/bolts/New(mob/living/carbon/C, forced, door_number)
	set waitfor = FALSE
	..()
	if(!door_number)
		door_number = rand(0,4) //if 0 bolts all visible doors
	var/count = 0
	feedback_details += "Door amount: [door_number]"

	for(var/obj/machinery/door/airlock/A in range(7, target))
		if(count>door_number && door_number>0)
			break
		if(!A.density)
			continue
		count++
		LAZYADD(airlocks_to_hit, A)

	START_PROCESSING(SSfastprocess, src)

/datum/hallucination/bolts/process(delta_time)
	next_action -= (delta_time * 10)
	if (next_action > 0)
		return

	if (locking)
		var/atom/next_airlock = pop(airlocks_to_hit)
		if (next_airlock)
			var/obj/effect/hallucination/fake_door_lock/lock = new(get_turf(next_airlock))
			lock.target = target
			lock.airlock = next_airlock
			LAZYADD(locks, lock)

		if (!LAZYLEN(airlocks_to_hit))
			locking = FALSE
			next_action = 10 SECONDS
			return
	else
		var/obj/effect/hallucination/fake_door_lock/next_unlock = popleft(locks)
		if (next_unlock)
			next_unlock.unlock()
		else
			qdel(src)
			return

	next_action = rand(4, 12)

/datum/hallucination/bolts/Destroy()
	. = ..()
	QDEL_LIST(locks)
	STOP_PROCESSING(SSfastprocess, src)

/obj/effect/hallucination/fake_door_lock
	layer = CLOSED_DOOR_LAYER + 1 //for Bump priority
	var/image/bolt_light
	var/obj/machinery/door/airlock/airlock

/obj/effect/hallucination/fake_door_lock/proc/lock()
	bolt_light = image(airlock.overlays_file, get_turf(airlock), "lights_bolts",layer=airlock.layer+0.1)
	if(target.client)
		target.client.images |= bolt_light
		target.playsound_local(get_turf(airlock), 'sound/machines/boltsdown.ogg',30,0,3)

/obj/effect/hallucination/fake_door_lock/proc/unlock()
	if(target.client)
		target.client.images.Remove(bolt_light)
		target.playsound_local(get_turf(airlock), 'sound/machines/boltsup.ogg',30,0,3)
	qdel(src)

/obj/effect/hallucination/fake_door_lock/CanAllowThrough(atom/movable/mover, turf/_target)
	. = ..()
	if(mover == target && airlock.density)
		return FALSE

/datum/hallucination/chat

/datum/hallucination/chat/New(mob/living/carbon/C, forced = TRUE, force_radio, specific_message)
	set waitfor = FALSE
	..()
	var/target_name = target.first_name()
	var/speak_messages = list(
			pick_list_replacements(HAL_LINES_FILE, "sick"),
			pick_list(HAL_LINES_FILE, "nothing"),
			pick_list(INSANITY_LINES_FILE, "murder"),
			pick_list(INSANITY_LINES_FILE, "suicide"),
			pick_list(INSANITY_LINES_FILE, "wander"),
			pick_list(INSANITY_LINES_FILE, "release")
		)
	var/radio_messages = list(
		pick_list_replacements(HAL_LINES_FILE, "sick"),
		pick_list(HAL_LINES_FILE, "combat"),
		pick_list(HAL_LINES_FILE, "clerk")
		)
	if(SSlobotomy_corp.all_abnormality_datums.len)
		var/list/abno_list = SSlobotomy_corp.all_abnormality_datums.Copy()
		for(var/datum/abnormality/AD in SSlobotomy_corp.all_abnormality_datums)
			if(!istype(AD.current) || QDELETED(AD.current) || AD.current.stat == DEAD)
				continue
			if(AD.qliphoth_meter_max <= 0)
				abno_list -= AD
		if(abno_list.len)
			var/datum/abnormality/qliphoth_abno = pick(abno_list)
			if(istype(qliphoth_abno))
				speak_messages += qliphoth_abno.name+"[pick_list_replacements(HAL_LINES_FILE, "breach")][get_area(C)][prob(50) ? "" : "!"]"
				speak_messages += "[pick_list_replacements(HAL_LINES_FILE, "meltdown")]"+qliphoth_abno.name
				radio_messages += qliphoth_abno.name+"[pick_list_replacements(HAL_LINES_FILE, "breach")][get_area(C)][prob(50) ? "" : "!"]"
				radio_messages += "[pick_list_replacements(HAL_LINES_FILE, "meltdown")]"+qliphoth_abno.name
			speak_messages += pick_list(HAL_LINES_FILE, "work")
			radio_messages += pick_list(HAL_LINES_FILE, "work")

	if(SSlobotomy_corp.qliphoth_meter + 3 >= SSlobotomy_corp.qliphoth_max)
		speak_messages += pick_list(HAL_LINES_FILE, "ordeal")
		radio_messages += pick_list(HAL_LINES_FILE, "ordeal")

	var/mob/living/carbon/person = null
	var/datum/language/understood_language = target.get_random_understood_language()
	for(var/mob/living/carbon/H in view(target))
		if(H == target)
			continue
		if(H == C)
			continue
		if(!person)
			person = H
		else
			if(get_dist(target,H)<get_dist(target,person))
				person = H

	// Get person to affect if radio hallucination
	var/is_radio = !person || force_radio
	if (is_radio)
		var/list/humans = list()
		for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
			if(H == C)
				continue
			if(H == target)
				continue
			humans += H
		if(humans.len <= 0)
			qdel(src)
			return
		person = pick(humans)

	if(isnull(person))
		qdel(src)
		return
	// Generate message
	var/spans = list(person.speech_span)
	var/chosen = !specific_message ? capitalize(pick(is_radio ? radio_messages : speak_messages)) : specific_message
	chosen = replacetext(chosen, "%TARGETNAME%", target_name)
	var/message = target.compose_message(person, understood_language, chosen, is_radio ? FREQ_COMMON : null, spans, face_name = TRUE)
	feedback_details += "Type: [is_radio ? "Radio" : "Talk"], Source: [person.real_name], Message: [message]"

	// Display message
	if (!is_radio && !target.client?.prefs.chat_on_map)
		var/image/speech_overlay = image('icons/mob/talk.dmi', person, "default0", layer = ABOVE_MOB_LAYER)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), speech_overlay, list(target.client), 30)
	if (target.client?.prefs.chat_on_map)
		target.create_chat_message(person, understood_language, chosen, spans)
	to_chat(target, message)
	qdel(src)

/datum/hallucination/message

/datum/hallucination/message/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/mobpool = list()
	var/mob/living/carbon/human/other
	var/close_other = FALSE
	for(var/mob/living/carbon/human/H in oview(target, 7))
		if(get_dist(H, target) <= 1)
			other = H
			close_other = TRUE
			break
		mobpool += H
	if(!other && mobpool.len)
		other = pick(mobpool)

	var/list/message_pool = list()
	if(other)
		if(close_other) //increase the odds
			var/obj/item/clothing/suit/armor/ego_gear/EG = C.get_item_by_slot(ITEM_SLOT_OCLOTHING)
			if(istype(EG))
				for(var/i in 1 to 3)
					message_pool.Add("<span class='warning'>[other] tries to remove your [EG].</span>")

		message_pool.Add("<B>[other]</B> [pick("sneezes","coughs")].")

	message_pool.Add(
		"<span class='notice'>You feel something cold touch the back of your leg.</span>",
		"<span class='warning'>You feel a gurgling inside of you...</span>",
		"<span class='warning'>A sudden spasming headache overtakes you...</span>",
		"<span class='userdanger'>You feel a heavy weight upon your shoulders.</span>",
		"<span class='userdanger'>You feel your head begin to split!</span>",
		"<span class='userdanger'>Funeral of the Dead Butterflies levels one of its arms at [C]!</span>",
		"<span class='nicegreen'>There's something about that sound...</span>",
		"<span class='warning'>That terrible grinding noise...</span>",
		"<span class='warning'>You can hear it again... it needs more...</span>",
		"<span class='warning'>The abnormalities seem restless...</span>",
		"<span class='warning'>The abnormalities stir as the music plays...</span>",
		"<span class='warning'>The petals are falling. They're so beautiful...</span>",
		"<span class='userdanger'><i>You can feel yourself wilting away like a delicate rose.</i></span>",
		"<span class='boldannounce'>The last of the petals are falling. You'll never forget it.</span>",
		"<span class='danger'>Your HP is too high! Decrease it or perish!.</span>",
		"<span class='danger'>Your HP is too low! Increase it or perish.</span>",
		"<span class='warning'>You feel tired...</span>",
		"<span class='danger'>Your heart-shaped present begins to crack...</span>"
		)
	if(prob(10) && GLOB.player_list.len)
		message_pool.Add(
			"<span class='userdanger'>[uppertext(pick(GLOB.player_list))] WILL PUSH DON'T TOUCH ME TO BREACH ABNORMALITIES.</span>",
			"<span class='userdanger'>[uppertext(pick(GLOB.player_list))] WILL PUSH DON'T TOUCH ME.</span>"
			)

	var/chosen = pick(message_pool)
	feedback_details += "Message: [chosen]"
	to_chat(target, chosen)
	qdel(src)

/datum/hallucination/sounds

/datum/hallucination/sounds/New(mob/living/carbon/C, forced = TRUE, sound_type)
	set waitfor = FALSE
	..()
	var/turf/source = random_far_turf()
	if(!sound_type)
		sound_type = pick("nothing there", "scorched","gbee", "alriune", "clown","kog","silent orchestra","home","bluestar","rose","price","judgement", "breach", "train")
	feedback_details += "Type: [sound_type]"
	//Strange audio
	switch(sound_type)
		if("nothing there")
			switch(rand(1,12))
				if(1 to 2)
					target.playsound_local(source,'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3)
					for(var/i = 1 to rand(1, 4))
						if(prob(10))
							continue
						addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3), 3*i)
				if(3 to 5)
					target.playsound_local(source,'sound/abnormalities/nothingthere/hello_cast.ogg', 75, 0, 3)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7), 5)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3), 5)
				if(6 to 8)
					target.playsound_local(source,'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, 0, 5)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 5), 8)
				if(9)
					target.playsound_local(source,'sound/abnormalities/nothingthere/breach.ogg', 50, 0, 5)
				if(10 to 12)
					target.playsound_local(source,'sound/abnormalities/nothingthere/attack.ogg', 75, 0, 3)
		if("sorched")
			target.playsound_local(source, 'sound/abnormalities/scorchedgirl/pre_ability.ogg', 50, 0, 2)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/abnormalities/scorchedgirl/ability.ogg', 60, 0, 4), 1.5 SECONDS)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/abnormalities/scorchedgirl/explosion.ogg', 125, 0, 8), 3 SECONDS)
		if("gbee")
			target.playsound_local(source, 'sound/effects/explosion2.ogg', 50, 0, 8)
		if("alriune")
			for(var/i = 0 to 2)
				addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/abnormalities/alriune/timer.ogg', 50, FALSE), (6*i) SECONDS)
		if("clown")
			switch(rand(1, 6))
				if(1 to 3)
					for(var/i = 1 to rand(2, 8))
						if(i % 2 == 0)
							addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/effects/clownstep2.ogg', 30, 0, 3), 2*i)
						else
							addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/effects/clownstep1.ogg', 30, 0, 3), 2*i)
				if(4)
					target.playsound_local(source,'sound/abnormalities/clownsmiling/announce.ogg', 75, 1)
				if(5 to 6)
					target.playsound_local(source,'sound/abnormalities/clownsmiling/final_stab.ogg', 50, 1)
		if("kog")
			for(var/i = 0 to get_dist(source, target))
				addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/effects/bamf.ogg', 70, TRUE, 20), 2*i)
				source = get_step_towards(source, target)
				if(prob(5))
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/abnormalities/kog/GreedHit1.ogg', 40, 1), 2*i)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/abnormalities/kog/GreedHit2.ogg', 40, 1), 2*i)
		if("silent orchestra")
			target.playsound_local(target,'sound/abnormalities/silentorchestra/movement0.ogg', 50, FALSE)
		if("home")
			target.playsound_local(source,'sound/abnormalities/roadhome/House_MakeRoad.ogg', 100, FALSE, 8)
		if("bluestar")
			target.playsound_local(source,'sound/abnormalities/bluestar/pulse.ogg', 100, FALSE, 40, falloff_distance = 10)
		if("rose")
			target.playsound_local(target, 'sound/abnormalities/rose/meltdown.ogg')
		if("price")
			if(prob(60))
				target.playsound_local(target,'sound/abnormalities/silence/ambience.ogg', 50)
			else
				target.playsound_local(target,'sound/abnormalities/silence/price.ogg', 50)
		if("judgement")
			target.playsound_local(source, 'sound/abnormalities/judgementbird/pre_ability.ogg', 50, 0, 2)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source,'sound/abnormalities/judgementbird/ability.ogg', 75, 0, 7), 2 SECONDS)
		if("breach")
			target.playsound_local(source, 'sound/effects/alertbeep.ogg', 50, FALSE)
		if("train")
			target.playsound_local(target, 'sound/abnormalities/expresstrain/express_summoned.ogg', 50)

	qdel(src)

/datum/hallucination/mech_sounds
	var/mech_dir
	var/steps_left
	var/next_action = 0
	var/turf/source

/datum/hallucination/mech_sounds/New()
	. = ..()
	mech_dir = pick(GLOB.cardinals)
	steps_left = rand(4, 9)
	source = random_far_turf()
	START_PROCESSING(SSfastprocess, src)

/datum/hallucination/mech_sounds/process(delta_time)
	next_action -= delta_time
	if (next_action > 0)
		return

	if(prob(75))
		target.playsound_local(source, 'sound/mecha/mechstep.ogg', 40, 1)
		source = get_step(source, mech_dir)
	else
		target.playsound_local(source, 'sound/mecha/mechturn.ogg', 40, 1)
		mech_dir = pick(GLOB.cardinals)

	steps_left -= 1
	if (!steps_left)
		qdel(src)
		return
	next_action = 1

/datum/hallucination/mech_sounds/Destroy()
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)

/datum/hallucination/weird_sounds

/datum/hallucination/weird_sounds/New(mob/living/carbon/C, forced = TRUE, sound_type)
	set waitfor = FALSE
	..()
	var/turf/source = random_far_turf()
	if(!sound_type)
		sound_type = pick("phone","hallelujah","highlander","laughter","hyperspace","game over","creepy","tesla")
	feedback_details += "Type: [sound_type]"
	//Strange audio
	switch(sound_type)
		if("phone")
			target.playsound_local(source, 'sound/weapons/ring.ogg', 15)
			for (var/next_rings in 1 to 3)
				addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/weapons/ring.ogg', 15), 25 * next_rings)
		if("hyperspace")
			target.playsound_local(null, 'sound/runtime/hyperspace/hyperspace_begin.ogg', 50)
		if("hallelujah")
			target.playsound_local(source, 'sound/effects/pray_chaplain.ogg', 50)
		if("highlander")
			target.playsound_local(null, 'sound/misc/highlander.ogg', 50)
		if("game over")
			target.playsound_local(source, 'sound/misc/compiler-failure.ogg', 50)
		if("laughter")
			if(prob(50))
				target.playsound_local(source, 'sound/voice/human/womanlaugh.ogg', 50, 1)
			else
				target.playsound_local(source, pick('sound/voice/human/manlaugh1.ogg', 'sound/voice/human/manlaugh2.ogg'), 50, 1)
		if("creepy")
		//These sounds are (mostly) taken from Hidden: Source
			target.playsound_local(source, pick(GLOB.creepy_ambience), 50, 1)
		if("tesla") //Tesla loose!
			target.playsound_local(source, 'sound/magic/lightningbolt.ogg', 35, 1)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/magic/lightningbolt.ogg', 65, 1), 30)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), source, 'sound/magic/lightningbolt.ogg', 100, 1), 60)

	qdel(src)

/datum/hallucination/stationmessage

/datum/hallucination/stationmessage/New(mob/living/carbon/C, forced = TRUE, message)
	set waitfor = FALSE
	..()
	if(!message)
		message = pick("no alert","first","second","third")
	feedback_details += "Type: [message]"
	switch(message)
		if("no alert")
			to_chat(target, "<span class='minorannounce'><font color = red>Attention!</font color><BR>Warning level has been reset. All dangerous abnormalities have been re-contained and situation is under control.</span><BR>")
			SEND_SOUND(target, sound('sound/misc/notice2.ogg'))
		if("first")
			to_chat(target, "<span class='minorannounce'><font color = red>Attention! First warning!</font color><BR>First warning level achieved. Few dangerous abnormalities have breached the containment.</span><BR>")
			SEND_SOUND(target, sound('sound/misc/notice1.ogg'))
		if("second")
			to_chat(target, "<span class='minorannounce'><font color = red>Attention! Second warning!</font color><BR>Second warning level achieved. Most dangerous abnormalities have breached containment and several agents might be dead or out of control.</span><BR>")
			SEND_SOUND(target, sound('sound/misc/notice1.ogg'))
		if("third")
			to_chat(target, "<span class='minorannounce'><font color = red>Attention! Third warning!</font color><BR>Warning level three achieved. Facility's integrity is in danger. Most if not all of the dangerous abnormalities have breached containment and many agents have been lost.</span><BR>")
			SEND_SOUND(target, sound('sound/misc/notice1.ogg'))

/datum/hallucination/hudscrew

/datum/hallucination/hudscrew/New(mob/living/carbon/C, forced = TRUE, screwyhud_type)
	set waitfor = FALSE
	..()
	//Screwy HUD
	var/chosen_screwyhud = screwyhud_type
	if(!chosen_screwyhud)
		chosen_screwyhud = pick(SCREWYHUD_CRIT,SCREWYHUD_DEAD,SCREWYHUD_HEALTHY)
	target.set_screwyhud(chosen_screwyhud)
	feedback_details += "Type: [target.hal_screwyhud]"
	QDEL_IN(src, rand(100, 250))

/datum/hallucination/hudscrew/Destroy()
	target?.set_screwyhud(SCREWYHUD_NONE)
	return ..()

/datum/hallucination/fake_alert
	var/alert_type

/datum/hallucination/fake_alert/New(mob/living/carbon/C, forced = TRUE, specific, duration = 150)
	set waitfor = FALSE
	..()
	alert_type = pick("rose 1", "rose 2", "silent girl 1", "firebird 1", "firebird 2", "porccubus", "galaxy child", "luna", "apple")
	if(specific)
		alert_type = specific
	feedback_details += "Type: [alert_type]"
	switch(alert_type)
		if("rose 1")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/sacrifice, override = TRUE)
		if("rose 2")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/schismatic, override = TRUE)
		if("silent girl 1")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/sg_guilty, override = TRUE)
		if("firebird 1")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/FireRegen, override = TRUE)
		if("firebird 2")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/OwMyEyes, override = TRUE)
		if("porccubus")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/porccubus_addiction, override = TRUE)
		if("galaxy child")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/friendship, override = TRUE)
		if("luna")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/lunar, override = TRUE)
		if("apple")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/golden_sheen, override = TRUE)
		if("crumbling")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/cowardice, override = TRUE)


	addtimer(CALLBACK(src, PROC_REF(cleanup)), duration)

/datum/hallucination/fake_alert/proc/cleanup()
	target.clear_alert(alert_type, clear_override = TRUE)
	qdel(src)

/datum/hallucination/items/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	//Strange items

	var/obj/halitem = new

	halitem = new
	var/obj/item/l_hand = target.get_item_for_held_index(1)
	var/obj/item/r_hand = target.get_item_for_held_index(2)
	var/l = ui_hand_position(target.get_held_index_of_item(l_hand))
	var/r = ui_hand_position(target.get_held_index_of_item(r_hand))
	var/list/slots_free = list(l,r)
	if(l_hand)
		slots_free -= l
	if(r_hand)
		slots_free -= r
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.belt)
			slots_free += ui_belt
		if(!H.l_store)
			slots_free += ui_storage1
		if(!H.r_store)
			slots_free += ui_storage2
	if(slots_free.len)
		halitem.screen_loc = pick(slots_free)
		halitem.layer = ABOVE_HUD_LAYER
		halitem.plane = ABOVE_HUD_PLANE
		switch(rand(1,6))
			if(1) //revolver
				halitem.icon = 'icons/obj/guns/projectile.dmi'
				halitem.icon_state = "revolver"
				halitem.name = "Revolver"
			if(2) //c4
				halitem.icon = 'icons/obj/grenade.dmi'
				halitem.icon_state = "plastic-explosive0"
				halitem.name = "C4"
				if(prob(25))
					halitem.icon_state = "plasticx40"
			if(3) //sword
				halitem.icon = 'icons/obj/transforming_energy.dmi'
				halitem.icon_state = "sword0"
				halitem.name = "Energy Sword"
			if(4) //stun baton
				halitem.icon = 'icons/obj/items_and_weapons.dmi'
				halitem.icon_state = "stunbaton"
				halitem.name = "Stun Baton"
			if(5) //emag
				halitem.icon = 'icons/obj/card.dmi'
				halitem.icon_state = "emag"
				halitem.name = "Cryptographic Sequencer"
			if(6) //flashbang
				halitem.icon = 'icons/obj/grenade.dmi'
				halitem.icon_state = "flashbang1"
				halitem.name = "Flashbang"
		feedback_details += "Type: [halitem.name]"
		if(target.client)
			target.client.screen += halitem
		QDEL_IN(halitem, rand(150, 350))

	qdel(src)

/datum/hallucination/dangerflash

/datum/hallucination/dangerflash/New(mob/living/carbon/C, forced = TRUE, danger_type)
	set waitfor = FALSE
	..()
	//Flashes of danger

	var/list/possible_points = list()
	for(var/turf/open/floor/F in view(target,world.view))
		possible_points += F
	if(possible_points.len)
		var/turf/open/floor/danger_point = pick(possible_points)
		if(!danger_type)
			danger_type = pick("abnormality", "misc")
		switch(danger_type)
			if("lava")
				new /obj/effect/hallucination/danger/lava(danger_point, target)
			if("chasm")
				new /obj/effect/hallucination/danger/chasm(danger_point, target)
			if("anomaly")
				new /obj/effect/hallucination/danger/anomaly(danger_point, target)
			if("abnormality")
				var/A_path = pick(subtypesof(/mob/living/simple_animal/hostile/abnormality))
				var/mob/living/simple_animal/hostile/abnormality/A = new A_path(target)
				new /obj/effect/hallucination/danger/abnormality(danger_point, target, A.icon, (A.icon_living == "" ? A.icon_state : A.icon_living), A.attack_sound, A.attack_verb_continuous, A.name, A.threat_level, A.pixel_x, A.pixel_y)
				qdel(A)
			if("misc")
				new /obj/effect/hallucination/danger/misc(danger_point, target)

	qdel(src)

/obj/effect/hallucination/danger
	var/image/image

/obj/effect/hallucination/danger/proc/show_icon()
	return

/obj/effect/hallucination/danger/proc/clear_icon()
	if(image && target.client)
		target.client.images -= image

/obj/effect/hallucination/danger/Initialize(mapload, _target)
	. = ..()
	target = _target
	show_icon()
	QDEL_IN(src, rand(200, 450))

/obj/effect/hallucination/danger/Destroy()
	clear_icon()
	. = ..()

/obj/effect/hallucination/danger/lava
	name = "lava"

/obj/effect/hallucination/danger/lava/show_icon()
	image = image('icons/turf/floors/lava.dmi', src, "lava-0", TURF_LAYER)
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/lava/Crossed(atom/movable/AM)
	. = ..()
	if(AM == target)
		target.adjustStaminaLoss(20)
		new /datum/hallucination/fire(target)

/obj/effect/hallucination/danger/chasm
	name = "chasm"

/obj/effect/hallucination/danger/chasm/show_icon()
	var/turf/target_loc = get_turf(target)
	image = image('icons/turf/floors/chasms.dmi', src, "chasms-[target_loc.smoothing_junction]", TURF_LAYER)
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/chasm/Crossed(atom/movable/AM)
	. = ..()
	if(AM == target)
		if(istype(target, /obj/effect/dummy/phased_mob))
			return
		to_chat(target, "<span class='userdanger'>You fall into the chasm!</span>")
		target.Paralyze(40)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, "<span class='notice'>It's surprisingly shallow.</span>"), 15)
		QDEL_IN(src, 30)

/obj/effect/hallucination/danger/anomaly
	name = "flux wave anomaly"

/obj/effect/hallucination/danger/anomaly/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/hallucination/danger/anomaly/process(delta_time)
	if(DT_PROB(45, delta_time))
		step(src,pick(GLOB.alldirs))

/obj/effect/hallucination/danger/anomaly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/hallucination/danger/anomaly/show_icon()
	image = image('icons/effects/effects.dmi',src,"electricity2",OBJ_LAYER+0.01)
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/anomaly/Crossed(atom/movable/AM)
	. = ..()
	if(AM == target)
		new /datum/hallucination/shock(target)

/obj/effect/hallucination/danger/abnormality
	var/sound
	var/damage_text
	var/state
	var/file
	var/pixel = list()
	var/damage

/obj/effect/hallucination/danger/abnormality/Initialize(mapload, _target, _file, _state, _sound, _damage_text, _name, _damage, pixel_x = 0, pixel_y = 0)
	file = _file
	state = _state
	damage_text = _damage_text
	sound = _sound
	name = _name
	damage = 5*_damage // 5-25 damage, more if WN/CENSORED
	pixel = list(pixel_x, pixel_y)
	. = ..()

/obj/effect/hallucination/danger/abnormality/show_icon()
	image = image(file, src, state, LARGE_MOB_LAYER, pixel[1], pixel[2])
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/abnormality/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(AM != target)
		return
	if(!isnull(sound))
		target.playsound_local(get_turf(src), sound, 60, 0, 3)
	else
		target.playsound_local(get_turf(src), 'sound/weapons/slash.ogg', 60, 0, 3)
	to_chat(target, "<span class='warning'>[src] [damage_text] you!</span>")
	if(damage)
		target.apply_damage(damage, WHITE_DAMAGE, null, target.run_armor_check(null, WHITE_DAMAGE))
	new /datum/hallucination/hudscrew(target, TRUE, SCREWYHUD_CRIT)
	qdel(src)

/obj/effect/hallucination/danger/misc
	name = "a totally real thing"
	var/list/objects = list(
		list("justitia", 'icons/obj/ego_weapons.dmi', "justitia", OBJ_LAYER, 5, 0, 0),
		list("bee shell", 'icons/effects/effects.dmi', "beetillery", POINT_LAYER, 0, 0, 0),
		list("blood", 'icons/effects/blood.dmi', "floor1", ABOVE_NORMAL_TURF_LAYER, 0, 0, 0),
		list("Meat Lantern", 'ModularTegustation/Teguicons/64x32.dmi', "lantern_breach", LARGE_MOB_LAYER, 20, -16, 0)
		)
	var/damage = 0

/obj/effect/hallucination/danger/misc/show_icon()
	var/list/chosen = pick(objects)
	name = chosen[1]
	image = image(chosen[2], src, chosen[3], chosen[4], pixel_x = chosen[6], pixel_y = chosen[7])
	damage = chosen[5]
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/misc/Crossed(atom/movable/AM)
	. = ..()
	if(AM == target && damage)
		target.apply_damage(damage, WHITE_DAMAGE, null, target.run_armor_check(null, WHITE_DAMAGE))


/datum/hallucination/death

/datum/hallucination/death/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	target.set_screwyhud(SCREWYHUD_DEAD)
	target.Paralyze(300)
	target.silent += 10
	to_chat(target, "<span class='deadsay'><b>[target.real_name]</b> has died at <b>[get_area_name(target)]</b>.</span>")

	var/delay = 0

	if(prob(50))
		var/mob/fakemob
		var/list/dead_people = list()
		for(var/mob/dead/observer/G in GLOB.player_list)
			dead_people += G
		if(LAZYLEN(dead_people))
			fakemob = pick(dead_people)
		else
			fakemob = target //ever been so lonely you had to haunt yourself?
		if(fakemob)
			delay = rand(20, 50)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, "<span class='deadsay'><b>DEAD: [fakemob.name]</b> says, \"[pick("rip","why did i just drop dead?","hey [target.first_name()]","git gud","you too?","is the AI rogue?",\
				"i[prob(50)?" fucking":""] hate [pick("blood cult", "clock cult", "revenants", "this round","this","myself","admins","you")]")]\"</span>"), delay)

	addtimer(CALLBACK(src, PROC_REF(cleanup)), delay + rand(70, 90))

/datum/hallucination/death/proc/cleanup()
	if (target)
		target.set_screwyhud(SCREWYHUD_NONE)
		target.SetParalyzed(0)
		target.silent = FALSE
	qdel(src)

#define RAISE_FIRE_COUNT 3
#define RAISE_FIRE_TIME 3

/datum/hallucination/fire
	var/active = TRUE
	var/stage = 0
	var/image/fire_overlay

	var/next_action = 0
	var/times_to_lower_stamina
	var/fire_clearing = FALSE
	var/increasing_stages = TRUE
	var/time_spent = 0

/datum/hallucination/fire/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	target.set_fire_stacks(max(target.fire_stacks, 0.1)) //Placebo flammability
	fire_overlay = image('icons/mob/OnFire.dmi', target, "Standing", ABOVE_MOB_LAYER)
	if(target.client)
		target.client.images += fire_overlay
	to_chat(target, "<span class='userdanger'>You're set on fire!</span>")
	target.throw_alert("fire", /atom/movable/screen/alert/fire, override = TRUE)
	times_to_lower_stamina = rand(5, 10)
	addtimer(CALLBACK(src, PROC_REF(start_expanding)), 20)

/datum/hallucination/fire/Destroy()
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)

/datum/hallucination/fire/proc/start_expanding()
	if (isnull(target))
		qdel(src)
		return
	START_PROCESSING(SSfastprocess, src)

/datum/hallucination/fire/process(delta_time)
	if (isnull(target))
		qdel(src)
		return

	if(target.fire_stacks <= 0)
		clear_fire()

	time_spent += delta_time

	if (fire_clearing)
		next_action -= delta_time
		if (next_action < 0)
			stage -= 1
			update_temp()
			next_action += 3
	else if (increasing_stages)
		var/new_stage = min(round(time_spent / RAISE_FIRE_TIME), RAISE_FIRE_COUNT)
		if (stage != new_stage)
			stage = new_stage
			update_temp()

			if (stage == RAISE_FIRE_COUNT)
				increasing_stages = FALSE
	else if (times_to_lower_stamina)
		next_action -= delta_time
		if (next_action < 0)
			target.adjustStaminaLoss(15)
			next_action += 2
			times_to_lower_stamina -= 1
	else
		clear_fire()

/datum/hallucination/fire/proc/update_temp()
	if(stage <= 0)
		target.clear_alert("temp", clear_override = TRUE)
	else
		target.clear_alert("temp", clear_override = TRUE)
		target.throw_alert("temp", /atom/movable/screen/alert/hot, stage, override = TRUE)

/datum/hallucination/fire/proc/clear_fire()
	if(!active)
		return
	active = FALSE
	target.clear_alert("fire", clear_override = TRUE)
	if(target.client)
		target.client.images -= fire_overlay
	QDEL_NULL(fire_overlay)
	fire_clearing = TRUE
	next_action = 0

#undef RAISE_FIRE_COUNT
#undef RAISE_FIRE_TIME

/datum/hallucination/shock
	var/image/shock_image
	var/image/electrocution_skeleton_anim

/datum/hallucination/shock/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	shock_image = image(target, target, dir = target.dir)
	shock_image.appearance_flags |= KEEP_APART
	shock_image.color = rgb(0,0,0)
	shock_image.override = TRUE
	electrocution_skeleton_anim = image('icons/mob/human.dmi', target, icon_state = "electrocuted_base", layer=ABOVE_MOB_LAYER)
	electrocution_skeleton_anim.appearance_flags |= RESET_COLOR|KEEP_APART
	to_chat(target, "<span class='userdanger'>You feel a powerful shock course through your body!</span>")
	if(target.client)
		target.client.images |= shock_image
		target.client.images |= electrocution_skeleton_anim
	addtimer(CALLBACK(src, PROC_REF(reset_shock_animation)), 40)
	target.playsound_local(get_turf(src), "sparks", 100, 1)
	target.staminaloss += 50
	target.Stun(40)
	target.jitteriness += 1000
	target.do_jitter_animation(target.jitteriness)
	addtimer(CALLBACK(src, PROC_REF(shock_drop)), 20)

/datum/hallucination/shock/proc/reset_shock_animation()
	if(target.client)
		target.client.images.Remove(shock_image)
		target.client.images.Remove(electrocution_skeleton_anim)

/datum/hallucination/shock/proc/shock_drop()
	target.jitteriness = max(target.jitteriness - 990, 10) //Still jittery, but vastly less
	target.Paralyze(60)

/datum/hallucination/husks
	var/image/halbody

/datum/hallucination/husks/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/possible_points = list()
	for(var/turf/open/floor/F in view(target,world.view))
		possible_points += F
	if(possible_points.len)
		var/turf/open/floor/husk_point = pick(possible_points)
		switch(rand(1,4))
			if(1)
				var/image/body = image('icons/mob/human.dmi',husk_point,"husk",TURF_LAYER)
				var/matrix/M = matrix()
				M.Turn(90)
				body.transform = M
				halbody = body
			if(2,3)
				halbody = image('icons/mob/human.dmi',husk_point,"husk",TURF_LAYER)
			if(4)
				halbody = image('icons/mob/alien.dmi',husk_point,"alienother",TURF_LAYER)

		if(target.client)
			target.client.images += halbody
		QDEL_IN(src, rand(30,50)) //Only seen for a brief moment.

/datum/hallucination/husks/Destroy()
	target?.client?.images -= halbody
	QDEL_NULL(halbody)
	return ..()

//hallucination projectile code in code/modules/projectiles/projectile/special.dm
/datum/hallucination/stray_bullet

/datum/hallucination/stray_bullet/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/turf/startlocs = list()
	for(var/turf/open/T in view(world.view+1,target)-view(world.view,target))
		startlocs += T
	if(!startlocs.len)
		qdel(src)
		return
	var/turf/start = pick(startlocs)
	var/proj_type = pick(subtypesof(/obj/projectile/hallucination))
	feedback_details += "Type: [proj_type]"
	var/obj/projectile/hallucination/H = new proj_type(start)
	target.playsound_local(start, H.hal_fire_sound, 60, 1)
	H.hal_target = target
	H.preparePixelProjectile(target, start)
	H.fire()
	qdel(src)
