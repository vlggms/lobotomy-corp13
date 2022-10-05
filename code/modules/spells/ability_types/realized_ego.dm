/* All Around Helper - Grinder */
/obj/effect/proc_holder/ability/aimed/helper_dash
	name = "Blade dash"
	desc = "An ability that allows its user to dash six tiles forward in any direction."
	action_icon_state = "helper_dash0"
	base_icon_state = "helper_dash"
	base_action = /datum/action/spell_action/ability/item
	cooldown_time = 10 SECONDS

	var/dash_damage = 200
	var/dash_range = 6
	var/dash_ignore_walls = FALSE

/obj/effect/proc_holder/ability/aimed/helper_dash/Perform(target, mob/user)
	var/turf/target_turf = get_turf(user)
	var/list/line_turfs = list(target_turf)
	var/list/mobs_to_hit = list()
	for(var/turf/T in getline(user, get_ranged_target_turf_direct(user, target, dash_range)))
		if(!dash_ignore_walls && T.density)
			break
		target_turf = T
		line_turfs += T
		for(var/mob/living/L in view(1, T))
			mobs_to_hit |= L
	user.SpinAnimation(2, 1)
	user.forceMove(target_turf)
	// "Movement" effect
	for(var/i = 1 to line_turfs.len)
		var/turf/T = line_turfs[i]
		if(!istype(T))
			continue
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, user)
		var/matrix/M = matrix(D.transform)
		M.Turn(45 * i)
		D.transform = M
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 2 + i*2)
		playsound(D, "sound/abnormalities/helper/move0[pick(1,2,3)].ogg", rand(10, 30), 1, 3)
		for(var/obj/machinery/door/MD in T.contents)
			if(MD.density)
				addtimer(CALLBACK (MD, .obj/machinery/door/proc/open))
	// Damage
	for(var/mob/living/L in mobs_to_hit)
		if(user.faction_check_mob(L))
			continue
		if(L.status_flags & GODMODE)
			continue
		visible_message("<span class='boldwarning'>[user] runs through [L]!</span>")
		playsound(L, 'sound/abnormalities/helper/attack.ogg', 25, 1)
		new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
		L.apply_damage(dash_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
		if(L.health <= 0)
			L.gib()
	return .. ()

/* One Sin and Hundreds of Good Deeds - Confessional */
/obj/effect/proc_holder/ability/aimed/cross_spawn
	name = "Cross summon"
	desc = "An ability that allows its user to summon a holy cross to damage the enemies and heal the mind of their allies."
	action_icon_state = "cross_spawn0"
	base_icon_state = "cross_spawn"
	base_action = /datum/action/spell_action/ability/item
	cooldown_time = 20 SECONDS

	var/damage_amount = 200 // Amount of white damage dealt to enemies in the epicenter. Allies heal that amount of sanity instead.
	var/damage_range = 6

/obj/effect/proc_holder/ability/aimed/cross_spawn/Perform(target, mob/user)
	if(get_dist(user, target) > 10)
		return
	var/turf/target_turf = get_turf(target)
	new /obj/effect/temp_visual/cross/fall(target_turf)
	addtimer(CALLBACK(src, .proc/SplashEffect, target_turf, user), 5.5)
	return ..()

/obj/effect/proc_holder/ability/aimed/cross_spawn/proc/SplashEffect(turf/T, mob/user)
	visible_message("<span class='warning'>A giant cross falls down on the ground!</span>")
	playsound(T, 'sound/effects/impact_thunder.ogg', 50, FALSE)
	playsound(T, 'sound/effects/impact_thunder_far.ogg', 25, FALSE, 7)
	var/obj/effect/temp_visual/cross/C = new(T)
	animate(C, alpha = 0, transform = matrix()*2, time = 10)
	for(var/turf/open/TF in view(damage_range, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
	for(var/mob/living/L in view(damage_range, T))
		if(user.faction_check_mob(L))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.adjustSanityLoss(damage_amount)
			continue
		var/distance_decrease = get_dist(T, L) * 10
		L.apply_damage((damage_amount - distance_decrease), WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
		new /obj/effect/temp_visual/revenant(get_turf(L))
