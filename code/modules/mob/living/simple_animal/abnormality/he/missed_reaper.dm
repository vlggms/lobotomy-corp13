// Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/missed_reaper
	name = "Missed Reaper"
	desc = "Appears to be a little girl standing next to a looming shadow. Your instincts tell you to avoid her at all costs."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "reaper"
	portrait = "missed_reaper"
	maxHealth = 400
	health = 400
	melee_damage_lower = 35
	melee_damage_upper = 45
	melee_damage_type = PALE_DAMAGE
	attack_verb_continuous = "pierces"
	attack_verb_simple = "pierce"
	faction = list("hostile")
	attack_sound = 'sound/weapons/fixer/generic/nail1.ogg'
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = list(50, 45, 40, 0, 0),
	)
	work_damage_amount = 8
	work_damage_type = PALE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/grasp,
		/datum/ego_datum/armor/grasp,
	)
	gift_type = /datum/ego_gifts/grasp
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK
	light_color = "FFFFFFF"
	light_power = 5
	light_range = 2
	var/meltdown_cooldown //no spamming the meltdown effect
	var/meltdown_cooldown_time = 15 SECONDS

// Spooky effects
/mob/living/simple_animal/hostile/abnormality/missed_reaper/PostSpawn()
	..()
	DestroyLights()
	var/list/spooky_zone = range(1, src)
	if((locate(/obj/structure/looming_shadow) in spooky_zone))
		return
	for(var/turf/open/O in spooky_zone)
		new /obj/effect/gloomy_darkness(O)
	new /obj/structure/looming_shadow(get_turf(src))

// Work Stuff
/mob/living/simple_animal/hostile/abnormality/missed_reaper/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	DestroyLights()
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) >= 80)
		datum_reference.qliphoth_change(-1)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60)
		KillUser(user)
		return
	if(user.sanity_lost)
		KillUser(user)
	return

/mob/living/simple_animal/hostile/abnormality/missed_reaper/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/missed_reaper/proc/KillUser(mob/living/carbon/human/user, work_type, pe)
	user.Stun(3 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	user.attack_animal(src)
	sleep(0.2 SECONDS)
	user.attack_animal(src)
	sleep(0.5 SECONDS)
	to_chat(user, span_userdanger("[src] stabs you!"))
	user.apply_damage(3000, PALE_DAMAGE, null, user.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	playsound(user, 'sound/weapons/fixer/generic/nail1.ogg', 100, FALSE, 4)
	return

// Procs
/mob/living/simple_animal/hostile/abnormality/missed_reaper/proc/DestroyLights()
	for(var/obj/machinery/light/L in range(3, src)) //blows out the lights
		L.on = 1
		L.break_light_tube()

// Breach
/mob/living/simple_animal/hostile/abnormality/missed_reaper/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(2) //no need for qliphoth to be stuck at 0
	if(meltdown_cooldown > world.time)
		return
	meltdown_cooldown = world.time + meltdown_cooldown_time
	MeltdownEffect()
	return

/mob/living/simple_animal/hostile/abnormality/missed_reaper/proc/MeltdownEffect(mob/living/carbon/human/user) //copied my code from crumbling armor
	var/list/potentialmarked = list()
	var/list/marked = list()
	var/mob/living/carbon/human/Y
	sound_to_playing_players_on_level('sound/abnormalities/someonesportrait/panic.ogg', 25, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
	var/numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
	SLEEP_CHECK_DEATH(3 SECONDS)
	while(numbermarked > marked.len && potentialmarked.len > 0)
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(Y.stat == DEAD || Y.is_working)
			continue
		marked+=Y
		playsound(get_turf(Y), 'sound/abnormalities/missed_reaper/shadowcast.ogg', 50, FALSE, -1)
	SLEEP_CHECK_DEATH(1 SECONDS)
	for(Y in marked)
		to_chat(Y, span_userdanger("A shadow appears beneath your feet!"))
		new /obj/effect/malicious_shadow(get_turf(Y))

// Decorations
/obj/structure/looming_shadow
	name = "looming shadow"
	desc = "Looks like some sort of ghost or spirit."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "looming_shadow"
	anchored = TRUE
	density = FALSE
	layer = BELOW_MOB_LAYER
	resistance_flags = INDESTRUCTIBLE

/obj/effect/gloomy_darkness
	name = "gloomy darkness"
	desc = "The kind of darkness that light doesn't penetrate."
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "darkness"
	anchored = TRUE
	density = FALSE
	layer = POINT_LAYER
	resistance_flags = INDESTRUCTIBLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/gloomy_darkness/Initialize()
	. = ..()
	alpha = 150

/obj/effect/gloomy_darkness/temporary

/obj/effect/gloomy_darkness/temporary/Initialize()
	. = ..()
	QDEL_IN(src, 0.5 SECONDS)

/obj/effect/malicious_shadow
	name = "malicious shadow"
	desc = "A tall, ominous figure"
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "looming_shadow"
	anchored = TRUE
	density = FALSE
	layer = POINT_LAYER
	resistance_flags = INDESTRUCTIBLE
	var/explode_times = 20
	var/range = -1

/obj/effect/malicious_shadow/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 0.5 SECONDS)

/obj/effect/malicious_shadow/proc/explode() //repurposed code from artillary bees, a delayed attack
	playsound(get_turf(src), 'sound/abnormalities/missed_reaper/shadowhit.ogg', 50, 0, 8)
	range = clamp(range + 1, 0, 3)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(range, target_turf))
		var/obj/effect/temp_visual/smash_effect/shadowhit =  new(T)
		shadowhit.color = "#231E1B"
		new /obj/effect/gloomy_darkness/temporary(T)
		for(var/obj/machinery/light/B in T)
			B.on = 1
			B.break_light_tube()
		for(var/mob/living/L in T)
			L.apply_damage(10, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if(ishuman(L) && L.health < 0)
				var/mob/living/carbon/human/H = L
				H.Drain()
	explode_times -= 1
	if(explode_times <= 0)
		qdel(src)
		return
	sleep(0.4 SECONDS)
	explode()
