/* All Around Helper - Grinder */
/obj/effect/proc_holder/ability/aimed/helper_dash
	name = "Blade dash"
	desc = "An ability that allows its user to dash six tiles forward in any direction."
	action_icon_state = "helper_dash0"
	base_icon_state = "helper_dash"
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
				H.adjustSanityLoss(-damage_amount)
			continue
		var/distance_decrease = get_dist(T, L) * 10
		L.apply_damage((damage_amount - distance_decrease), WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
		new /obj/effect/temp_visual/revenant(get_turf(L))

/obj/effect/proc_holder/ability/aimed/despair_swords
	name = "Blades Whetted with Tears"
	desc = "An ability that summons 2 swords to attack and slow nearby enemies. \
		Each sword deals damage equal to 2% of the target's max HP as Pale, to a minimum of 40."
	action_icon_state = "despair0"
	base_icon_state = "despair"
	cooldown_time = 20 SECONDS

	var/swords = 2

/obj/effect/proc_holder/ability/aimed/despair_swords/Perform(target, mob/user)
	var/turf/target_turf = get_turf(target)
	var/list/OT = get_adjacent_open_turfs(user)
	for(var/i = 1 to swords)
		if(OT.len <= 0)
			OT = get_adjacent_open_turfs(user)
		var/turf/T = pick(OT)
		OT -= T
		var/obj/projectile/despair_rapier/ego/RP = new(T)
		RP.starting = T
		RP.firer = user
		RP.fired_from = T
		RP.yo = target_turf.y - T.y
		RP.xo = target_turf.x - T.x
		RP.original = target_turf
		RP.preparePixelProjectile(target_turf, T)
		addtimer(CALLBACK (RP, .obj/projectile/proc/fire), 3)
	return ..()

/obj/projectile/despair_rapier/ego
	name = "Sword that Pierces Despair"
	desc = "A magic rapier, enchanted by a knight protecting the weak."
	nodamage = TRUE
	projectile_piercing = PASSMOB

/obj/projectile/despair_rapier/ego/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target))
		return
	nodamage = FALSE
	if(ishostile(target))
		var/mob/living/simple_animal/hostile/H = target
		H.TemporarySpeedChange(1, 10 SECONDS)
		damage = max(0.02*H.maxHealth, 40)
	..()
	qdel(src)

/obj/effect/proc_holder/ability/aimed/arcana_slave
	name = "Arcana Slave"
	desc = "An ability that allows you to fire off a large laser after channelling for a while. \
		Alt-Click to toggle speech. Crtl-Click to set your own speech."
	action_icon_state = "arcana0"
	base_icon_state = "arcana"
	cooldown_time = 5 MINUTES
	base_action = /datum/action/spell_action/ability/item/ego_arcana_slave

	var/list/spawned_effects = list()
	var/speak = FALSE
	var/list/default_speech = list("Heed me, thou that are more azure than justice and more crimson than love…","In the name of those buried in destiny…","I shall make this oath to the light.","Mark the hateful beings who stand before us…","Let your strength merge with mine…", "so that we may deliver the power of love to all…")
	var/list/custom_speech = list()
	var/datum/looping_sound/qoh_beam/beamloop
	var/datum/beam/current_beam = null

/obj/effect/proc_holder/ability/aimed/arcana_slave/Initialize(mob/living/owner)
	. = ..()
	beamloop = new
	beamloop.volume = 40
	custom_speech = list()
	speak = FALSE

/obj/effect/proc_holder/ability/aimed/arcana_slave/Destroy()
	. = ..()
	QDEL_NULL(beamloop)

/obj/effect/proc_holder/ability/aimed/arcana_slave/Perform(target, user)
	var/turf/t_turf = get_turf(target)
	INVOKE_ASYNC(src, .proc/Cast, t_turf, user)
	return ..()

/obj/effect/proc_holder/ability/aimed/arcana_slave/proc/Cast(turf/target, mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/turf/my_turf = get_turf(H)
	H.face_atom(target)
	for(var/i = 1 to 3)
		var/obj/effect/qoh_sygil/S = new(my_turf)
		spawned_effects += S
		playsound(H, "sound/abnormalities/hatredqueen/beam[clamp(i, 1, 2)].ogg", 50, FALSE, 4*i)
		var/matrix/M = matrix(S.transform)
		M.Translate(0, i*16)
		var/rot_angle = Get_Angle(my_turf, target)
		M.Turn(rot_angle)
		S.icon_state = "qoh[i]"
		switch(H.dir)
			if(EAST)
				M.Scale(0.5, 1)
				S.layer += i*0.1
			if(WEST)
				M.Scale(0.5, 1)
				S.layer += i*0.1
			if(SOUTH)
				S.layer += i*0.1
			if(NORTH)
				S.layer -= i*0.1
		S.transform = M
		if(speak)
			if(custom_speech.len <= 0)
				addtimer(CALLBACK(H, .atom/movable/proc/say, default_speech[i*2 - 1]))
				addtimer(CALLBACK(H, .atom/movable/proc/say, default_speech[i*2]), 10)
			else
				addtimer(CALLBACK(H, .atom/movable/proc/say, custom_speech[i*2 - 1]))
				addtimer(CALLBACK(H, .atom/movable/proc/say, custom_speech[i*2]), 10)
		if(!Channel(H, 20))
			CleanUp(user)
			return
	var/turf/TT = get_ranged_target_turf_direct(my_turf, target, 60)
	current_beam = my_turf.Beam(TT, "qoh")
	var/accumulated_beam_damage = 0
	var/list/hit_line = getline(my_turf, TT)
	beamloop.start(user)
	beamloop.max_loops = 0
	var/beam_stage = 1
	var/beam_damage = 10
	var/justice = get_attribute_level(H, JUSTICE_ATTRIBUTE)
	justice /= 100
	justice++
	beam_damage *= justice
	if(speak)
		addtimer(CALLBACK(H, .atom/movable/proc/say, "ARCANA SLAVE!"))
	for(var/o = 1 to 50) // Half duration but gets Justice Mod
		var/list/already_hit = list()
		if(accumulated_beam_damage >= 150 && beam_stage < 2)
			beam_stage = 2
			beam_damage *= 1.5
			var/matrix/M = matrix()
			M.Scale(4, 1)
			current_beam.visuals.transform = M
			current_beam.visuals.color = COLOR_YELLOW
		for(var/turf/TF in hit_line)
			for(var/mob/living/L in range(beam_stage-1, TF))
				if(L.status_flags & GODMODE)
					continue
				if(L == src) //stop hitting yourself
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				already_hit += L
				if(H.faction_check_mob(L))
					if(L.stat < DEAD && L.stat > CONSCIOUS) // unhealthy but not dead
						L.adjustBruteLoss(-3*justice)
					if(ishuman(L))
						var/mob/living/carbon/human/LH = L
						if(LH.sanity_lost)
							LH.adjustSanityLoss(-3*justice)
					continue
				L.apply_damage(beam_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
				accumulated_beam_damage += beam_damage
		if(!Channel(H, 8))
			break
	CleanUp(user)

/obj/effect/proc_holder/ability/aimed/arcana_slave/proc/Channel(mob/user, duration = 0)
	if(!duration)
		return FALSE
	if(!user)
		return FALSE
	if(!do_after(user, duration))
		to_chat(user, "<span class='notice'>You stop channelling the spell!</span>")
		return FALSE
	return TRUE

/obj/effect/proc_holder/ability/aimed/arcana_slave/proc/CleanUp(mob/user)
	QDEL_NULL(current_beam)
	for(var/obj/effect/FX in spawned_effects)
		if(istype(FX, /obj/effect/qoh_sygil))
			var/obj/effect/qoh_sygil/QS = FX
			QS.fade_out()
			continue
		FX.Destroy()
	beamloop.stop(user)
	listclearnulls(spawned_effects)

/datum/action/spell_action/ability/item/ego_arcana_slave

/datum/action/spell_action/ability/item/ego_arcana_slave/New(Target)
	. = ..()
	button.Destroy()
	button = new /atom/movable/screen/movable/action_button/ego_arcana_slave
	button.linked_action = src
	button.name = name
	button.actiontooltipstyle = buttontooltipstyle
	button.desc = desc

/atom/movable/screen/movable/action_button/ego_arcana_slave

/atom/movable/screen/movable/action_button/ego_arcana_slave/Click(location, control, params)
	if(!istype(linked_action, /datum/action/spell_action/ability/item/ego_arcana_slave))
		return ..()
	var/datum/action/spell_action/ability/item/ego_arcana_slave/act = linked_action
	if(!istype(act.target, /obj/effect/proc_holder/ability/aimed/arcana_slave))
		return ..()
	var/obj/effect/proc_holder/ability/aimed/arcana_slave/AS = act.target
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, ALT_CLICK))
		AS.speak = !AS.speak
		if(AS.speak)
			to_chat(act.owner, "<span class='notice'>You will now recite the chant up cast.</span>")
		else
			to_chat(act.owner, "<span class='notice'>You will no longer recite the chant.</span>")
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		switch(tgui_alert(act.owner, "Would you like to change your custom speech?", "Custom Speech", list("Yes", "No", "Reset")))
			if("Yes")
				AS.custom_speech = list()
				for(var/i = 1 to 6)
					var/words = input(act.owner, "What is your [i]\th speech line?", "Custom Speech [i]/6") as null|text
					if(!words)
						words = ""
					AS.custom_speech += words
			if("Reset")
				AS.custom_speech = AS.default_speech.Copy()
		return
	return ..()


/obj/effect/proc_holder/ability/aimed/cocoon_spawn
	name = "Cocoon summon"
	desc = "An ability that allows its user to summon a cocoon to take hits and slow and damage enemies near it."
	action_icon_state = "cocoon0"
	base_icon_state = "cocoon"
	cooldown_time = 30 SECONDS

/obj/effect/proc_holder/ability/aimed/cocoon_spawn/Perform(target, mob/user)
	if(get_dist(user, target) > 10)
		return
	var/turf/target_turf = get_turf(target)
	new /mob/living/simple_animal/cocoonability(target_turf)
	return ..()


/mob/living/simple_animal/cocoonability
	name = "Cocoon"
	desc = "A cocoon...."
	icon = 'icons/effects/effects.dmi'
	icon_state = "cocoon_large2"
	icon_living = "cocoon_large2"
	faction = list("neutral")
	health = 300	//They're here to help
	maxHealth = 300
	speed = 0
	turns_per_move = 10000000000000
	generic_canpass = FALSE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	var/damage_amount = 8 // Amount of red damage dealt to enemies in the epicenter.
	var/damage_range = 2
	var/damage_slowdown = 0.5

/mob/living/simple_animal/cocoonability/Initialize()
	. = ..()
	QDEL_IN(src, (120 SECONDS))

/mob/living/simple_animal/cocoonability/Life()
	if(..())
		SplashEffect()

/mob/living/simple_animal/cocoonability/proc/SplashEffect()
	for(var/turf/T in view(damage_range, src))
		new /obj/effect/temp_visual/smash_effect(T)
	for(var/mob/living/L in view(damage_range, src))
		if(src.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(ishuman(L) ? damage_amount*0.5 : damage_amount, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(ishostile(L))
			var/mob/living/simple_animal/hostile/H = L
			H.TemporarySpeedChange(damage_slowdown, 2 SECONDS) // Slow down


/obj/effect/proc_holder/ability/aimed/blackhole
	name = "blackhole"
	desc = "An ability that allows its user to summon a black hole to drag everone near it."
	action_icon_state = "blackhole0"
	base_icon_state = "blackhole"
	cooldown_time = 60 SECONDS

/obj/effect/proc_holder/ability/aimed/blackhole/Perform(target, mob/user)
	if(get_dist(user, target) > 10)
		return
	var/turf/target_turf = get_turf(target)
	new /obj/projectile/black_hole_realized(target_turf)
	return ..()

/obj/projectile/black_hole_realized
	name = "black hole"
	icon = 'icons/effects/effects.dmi'
	icon_state = "blackhole"
	desc = "A mini black hole."
	nodamage = TRUE
	hitsound = "sound/effects/footstep/slime1.ogg"
	speed = 0
	damage = 30
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	hit_nondense_targets = TRUE
	var/damage_amount = 100 // Amount of black damage dealt to enemies in the epicenter.
	var/damage_range = 3

/obj/projectile/black_hole_realized/Initialize()
	. = ..()
	QDEL_IN(src, (60 SECONDS))
	for(var/i = 1 to 30)
		addtimer(CALLBACK(src, .proc/SplashEffect), i * 2 SECONDS)

/obj/projectile/black_hole_realized/proc/SplashEffect()
	playsound(src, 'sound/effects/footstep/slime1.ogg', 100, FALSE, 12)
	for(var/turf/T in view(damage_range, src))
		new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/L in view(damage_range, src))
		var/distance_decrease = get_dist(src, L) * 30
		L.apply_damage(ishuman(L) ? (damage_amount - distance_decrease)*0.5 : (damage_amount - distance_decrease), BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_towards(L, get_turf(src))))
		L.throw_at(throw_target, 1, 2)
