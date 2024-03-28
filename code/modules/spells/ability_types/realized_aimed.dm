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
	var/stop_charge = FALSE
	for(var/turf/T in getline(user, get_ranged_target_turf_direct(user, target, dash_range)))
		if(!dash_ignore_walls && T.density)
			break
		if(!dash_ignore_walls)
			for(var/obj/structure/window/W in T.contents)
				stop_charge = TRUE
				break
			for(var/obj/machinery/door/MD in T.contents)
				if(!MD.CanAStarPass(null))
					stop_charge = TRUE
					break
				if(MD.density)
					INVOKE_ASYNC(MD, TYPE_PROC_REF(/obj/machinery/door, open), 2)
		if(stop_charge)
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
	addtimer(CALLBACK(src, PROC_REF(SplashEffect), target_turf, user), 5.5)
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

/* Knight of Despair - Quenched with Blood */
/obj/effect/proc_holder/ability/aimed/despair_swords
	name = "Blades Whetted with Tears"
	desc = "An ability that summons 2 swords to attack and slow nearby enemies. \
		Each sword deals damage equal to 5% of the target's max HP as Pale, to a minimum of 120."
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
		addtimer(CALLBACK (RP, TYPE_PROC_REF(/obj/projectile, fire)), 3)
	sleep(3)
	playsound(target_turf, 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
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
		damage = max(0.05*H.maxHealth, 120)
	..()
	qdel(src)

/* Queen of Hatred - Love and Justice */
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
	INVOKE_ASYNC(src, PROC_REF(Cast), t_turf, user)
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
				addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable, say), default_speech[i*2 - 1]))
				addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable, say), default_speech[i*2]), 10)
			else
				addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable, say), custom_speech[i*2 - 1]))
				addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable, say), custom_speech[i*2]), 10)
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
		addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable, say), "ARCANA SLAVE!"))
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

/* Spider Bud - Death Stare */
/obj/effect/proc_holder/ability/aimed/gleaming_eyes
	name = "Gleaming Eyes"
	desc = "An ability that allows its user to do a jump attack that causes a slowing aoe when landing."
	action_icon_state = "cocoon0"
	base_icon_state = "cocoon"
	cooldown_time = 20 SECONDS
	var/damage_amount = 80 // Amount of red damage dealt to enemies in the epicenter.
	var/damage_range = 2
	var/damage_slowdown = 0.5

/obj/effect/proc_holder/ability/aimed/gleaming_eyes/Perform(target, mob/user)
	if(get_dist(user, target) > 10 || !(target in view(9, user)))
		return
	playsound(user, 'sound/abnormalities/spider_bud/jump.ogg', 50, FALSE, -1)
	var/turf/target_turf = get_turf(target)
	//new /mob/living/simple_animal/cocoonability(target_turf) FUCK YOU NO COCOON!!!!!!!!!!!
	animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
	user.pixel_z = 16
	sleep(0.5 SECONDS)
	for(var/i in 2 to get_dist(user, target_turf))
		step_towards(user,target_turf)
	animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
	user.pixel_z = 0
	sleep(0.1 SECONDS)
	JumpAttack(target_turf,user)
	return ..()

/obj/effect/proc_holder/ability/aimed/gleaming_eyes/proc/JumpAttack(target, mob/user)
	playsound(user, 'sound/abnormalities/spider_bud/land.ogg', 50, FALSE, -1)
	for(var/mob/living/L in view(1, user))
		if(user.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		var/obj/item/held = user.get_active_held_item()
		if(held)
			held.attack(L, user)
	for(var/turf/T in view(damage_range, user))
		new /obj/effect/temp_visual/smash_effect/red(T)
	for(var/mob/living/L in view(damage_range, user))
		if(user.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(ishuman(L) ? damage_amount*0.5 : damage_amount, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(ishostile(L))
			var/mob/living/simple_animal/hostile/H = L
			H.TemporarySpeedChange(H.move_to_delay * damage_slowdown, 10 SECONDS) // Slow down

/mob/living/simple_animal/cocoonability
	name = "Cocoon"
	desc = "A cocoon...."
	icon = 'icons/effects/effects.dmi'
	icon_state = "cocoon_large2"
	icon_living = "cocoon_large2"
	faction = list("neutral")
	health = 250	//They're here to help
	maxHealth = 250
	speed = 0
	turns_per_move = 10000000000000
	generic_canpass = FALSE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	var/damage_amount = 8 // Amount of red damage dealt to enemies in the epicenter.
	var/damage_range = 2
	var/damage_slowdown = 0.5

/mob/living/simple_animal/cocoonability/Initialize()
	. = ..()
	QDEL_IN(src, (30 SECONDS))
	for(var/i = 1 to 10)
		addtimer(CALLBACK(src, PROC_REF(SplashEffect)), i * 3 SECONDS)

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
			H.TemporarySpeedChange(damage_slowdown, 3 SECONDS) // Slow down

/* Lady out of Space - Fallen Colors */
/obj/effect/proc_holder/ability/aimed/blackhole
	name = "blackhole"
	desc = "An ability that allows its user to summon a black hole to drag everone near it."
	action_icon_state = "blackhole0"
	base_icon_state = "blackhole"
	cooldown_time = 30 SECONDS

/obj/effect/proc_holder/ability/aimed/blackhole/Perform(target, mob/user)
	if(get_dist(user, target) > 10 || !(target in view(9, user)))
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

	projectile_piercing = PASSMOB
	hit_nondense_targets = TRUE
	var/damage_amount = 200 // Amount of black damage dealt to enemies in the epicenter.
	var/damage_range = 3

/obj/projectile/black_hole_realized/Initialize()
	. = ..()
	QDEL_IN(src, (20 SECONDS))
	for(var/i = 1 to 10)
		addtimer(CALLBACK(src, PROC_REF(SplashEffect)), i * 2 SECONDS)

/obj/projectile/black_hole_realized/proc/SplashEffect()
	playsound(src, 'sound/effects/footstep/slime1.ogg', 100, FALSE, 12)
	for(var/turf/T in view(damage_range, src))
		new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/L in view(damage_range, src))
		var/distance_decrease = get_dist(src, L) * 40
		L.apply_damage(ishuman(L) ? (damage_amount - distance_decrease)*0.5 : (damage_amount - distance_decrease), BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_towards(L, get_turf(src))))
		L.throw_at(throw_target, 1, 2)

/* Harmony of Duality - Anarchy */
/obj/effect/proc_holder/ability/aimed/yin_laser
	name = "Anarchy"
	desc = "An ability that summons a devastating laser. \
		If another player gets hit by the laser they get +20 justice for a period of time. \
		If the person that gets hit is wearing duality of harmony, they will get huge buffs to their defenses and stats."
	action_icon_state = "yinform0"
	base_icon_state = "yinform"
	cooldown_time = 60 SECONDS
	var/laser_range = 20

/obj/effect/proc_holder/ability/aimed/yin_laser/Perform(target, user)
	var/turf/t_turf = get_turf(target)
	INVOKE_ASYNC(src, PROC_REF(Cast), t_turf, user)
	return ..()

/obj/effect/proc_holder/ability/aimed/yin_laser/proc/Cast(turf/target, mob/living/carbon/human/user)
	user.face_atom(target)
	var/turf/my_turf = get_turf(user)
	var/turf/target_turf = get_ranged_target_turf_direct(user, target, laser_range)
	var/list/to_hit = getline(user, target_turf)
	var/datum/beam/beam  = my_turf.Beam(target_turf, "volt_ray")
	for(var/turf/open/OT in to_hit)
		if(!istype(OT) || OT.density)
			break
		beam.target = OT
		beam.redrawing()
		sleep(1)
		new /obj/effect/temp_visual/revenant/cracks/yinfriend(OT)
	qdel(beam)

/obj/effect/temp_visual/revenant/cracks/yinfriend
	icon_state = "yincracks"
	duration = 9
	var/damage = 175  // Amount of black damage dealt to enemies from the laser.
	var/list/faction = list("neutral")

/obj/effect/temp_visual/revenant/cracks/yinfriend/Destroy()
	for(var/turf/T in range(1, src))
		if(T.z != z)
			continue
		for(var/mob/living/L in T)
			if(faction_check(L.faction, src.faction))
				continue
			L.apply_damage(damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		for(var/mob/living/carbon/human/L in T)
			if(!faction_check(L.faction, src.faction))
				continue
			L.apply_status_effect(/datum/status_effect/yinboost)
			if(istype(L.get_item_by_slot(ITEM_SLOT_OCLOTHING), /obj/item/clothing/suit/armor/ego_gear/realization/duality_yang))
				L.apply_status_effect(/datum/status_effect/duality_yin)
		new /obj/effect/temp_visual/small_smoke/yin_smoke/long(T)
	return ..()

/datum/status_effect/yinboost
	id = "EGO_YIN"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/yinboost
	duration = 90 SECONDS

/atom/movable/screen/alert/status_effect/yinboost
	name = "Yin Boost"
	desc = "Anarchy reigns supreme. \
		Your Justice is increased by 20."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "yinbuff"

/datum/status_effect/yinboost/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 20)

/datum/status_effect/yinboost/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -20)

/datum/status_effect/duality_yin
	id = "EGO_YIN2"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/duality_yin
	duration = 90 SECONDS

/atom/movable/screen/alert/status_effect/duality_yin
	name = "Harmony of duality"
	desc = "Decreases red and black damage taken by 25%. \
		All your stats are increased by 10."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "duality"

/datum/status_effect/duality_yin/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.physiology.red_mod *= 0.75
	H.physiology.black_mod *= 0.75
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 10)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)

/datum/status_effect/duality_yin/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.physiology.red_mod /= 0.75
	H.physiology.black_mod /= 0.75
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -10)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -10)
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10)

/* The Road Home - Forever Home */
/obj/effect/proc_holder/ability/aimed/house_spawn
	name = "You... Wicked Wizard!"
	desc = "Summon a home that WILL be reached on your enemies dealing BLACK damage and buffing your allies defenses."
	action_icon_state = "home_spawn0"
	base_icon_state = "home_spawn"
	cooldown_time = 20 SECONDS
	var/damage_amount = 300
	var/damage_range = 10

/obj/effect/proc_holder/ability/aimed/house_spawn/Perform(target, mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(get_dist(user, target) > 10)
		return
	var/turf/target_turf = get_turf(target)
	var/obj/effect/temp_visual/house/F = new(target_turf)
	animate(F, pixel_z = 0, alpha = 255, time = 1 SECONDS)
	playsound(user, 'sound/abnormalities/roadhome/House_MakeRoad.ogg', 50, FALSE, 8)
	addtimer(CALLBACK(src, PROC_REF(HouseSlam), target_turf, user), 1 SECONDS)
	return ..()

/obj/effect/proc_holder/ability/aimed/house_spawn/proc/HouseSlam(turf/T, mob/user)
	visible_message("<span class='warning'>A giant House falls down on the ground!</span>")
	playsound(T, 'sound/abnormalities/roadhome/House_HouseBoom.ogg', 75, FALSE, 10, falloff_exponent = 0.75) //LOUD
	for(var/turf/open/TF in view(damage_range, T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
	for(var/mob/living/L in view(damage_range, T))
		if(user.faction_check_mob(L))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.apply_status_effect(/datum/status_effect/home_buff)
			continue
		var/distance_decrease = get_dist(T, L) * 10
		L.apply_damage((damage_amount - distance_decrease), BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		new /obj/effect/temp_visual/revenant(get_turf(L))

/datum/status_effect/home_buff
	id = "homebuff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/home_buff

/atom/movable/screen/alert/status_effect/home_buff
	name = "A Road Walked Together"
	desc = "The sight of a home so familiar encourages you to hang on!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "home"

/datum/status_effect/home_buff/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.physiology.red_mod *= 0.75
	H.physiology.white_mod *= 0.75
	H.physiology.black_mod *= 0.75
	H.physiology.pale_mod *= 0.75

/datum/status_effect/home_buff/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.physiology.red_mod /= 0.75
	H.physiology.white_mod /= 0.75
	H.physiology.black_mod /= 0.75
	H.physiology.pale_mod /= 0.75
