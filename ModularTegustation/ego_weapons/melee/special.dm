//Abnormality rewards
//Fire Bird

//It's still a sword. Cope Kirie
/obj/item/ego_weapon/feather
	name = "feather of honor"
	desc = "A flaming, but very sharp, feather."
	icon_state = "featherofhonor"
	worn_icon_state = "featherofhonor"
	inhand_icon_state = "featherofhonor"
	force = 16
	attack_speed = 0.7
	special = "This E.G.O. functions as both a ranged and a melee weapon."
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60
	)
	var/gun_cooldown
	var/gun_cooldown_time = 3 SECONDS


/obj/item/ego_weapon/feather/proc/get_adjacent_open_turfs_feather(atom/center)
	. = list(get_open_turf_in_dir(center, NORTH),
			get_open_turf_in_dir(center, SOUTH),
			get_open_turf_in_dir(center, EAST),
			get_open_turf_in_dir(center, WEST),
			get_open_turf_in_dir(center, NORTHWEST),
			get_open_turf_in_dir(center, SOUTHWEST),
			get_open_turf_in_dir(center, NORTHEAST),
			get_open_turf_in_dir(center, SOUTHEAST))
	listclearnulls(.)

/obj/item/ego_weapon/feather/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		var/turf/target_turf = get_turf(target)
		if(!isturf(proj_turf))
			return
		user.changeNext_move(CLICK_CD_MELEE)
		var/list/OT = get_adjacent_open_turfs_feather(user)
		for(var/i = 1 to 4)
			if(OT.len <= 0)
				OT = get_adjacent_open_turfs_feather(user)
			var/turf/T = pick(OT)
			OT -= T
			var/obj/projectile/ego_bullet/ego_feather/F = new(T)
			F.starting = T
			F.firer = user
			F.fired_from = T
			F.yo = target_turf.y - T.y
			F.xo = target_turf.x - T.x
			F.original = target_turf
			F.preparePixelProjectile(target_turf, T)
			addtimer(CALLBACK (F, TYPE_PROC_REF(/obj/projectile, fire)), 2 + (i*2))
			F.damage*=force_multiplier
		playsound(target_turf, 'sound/abnormalities/firebird/Firebird_Hit.ogg', 50, 0, 4)
		gun_cooldown = world.time + gun_cooldown_time
		return

//White Night
/obj/item/ego_weapon/paradise
	name = "paradise lost"
	desc = "\"Behold: you stood at the door and knocked, and it was opened to you. \
	I come from the end, and I am here to stay for but a moment.\""
	special = "This weapon has a ranged attack that also happens on hit that heals you."
	icon_state = "paradise"
	worn_icon_state = "paradise"
	force = 40
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("purges", "purifies")
	attack_verb_simple = list("purge", "purify")
	hitsound = 'sound/weapons/ego/paradise.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)
	var/aoe_damage = 30
	var/aoe_cap = 6
	var/healing_amount = 0
	var/healing = 2
	var/list/been_hit = list()

/obj/item/ego_weapon/paradise/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/turf/target_turf = get_turf(M)
	healing_amount += healing
	been_hit += M
	DoAoe(user, target_turf)

/obj/item/ego_weapon/paradise/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || !(target_turf in view(10, user)))
		return
	..()
	user.changeNext_move(CLICK_CD_MELEE)
	DoAoe(user, target_turf)

/obj/item/ego_weapon/paradise/proc/DoAoe(mob/living/user, turf/target_turf)
	playsound(target_turf, 'sound/weapons/ego/paradise_ranged.ogg', 50, TRUE)
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust / 100
	var/modified_damage = (aoe_damage*force_multiplier) * justicemod
	new /obj/effect/temp_visual/paradise_attack_large(target_turf)
	for(var/dir in list(NORTH,SOUTH))
		if(get_open_turf_in_dir(target_turf, dir))
			new /obj/effect/temp_visual/paradise_attack_large(get_step(target_turf,dir))
	for(var/dir in list(NORTHWEST,WEST, SOUTHWEST))
		if(get_open_turf_in_dir(target_turf, dir))
			new /obj/effect/temp_visual/paradise_attack_large/left(get_step(target_turf,dir))
	for(var/dir in list(NORTHEAST,EAST, SOUTHEAST))
		if(get_open_turf_in_dir(target_turf, dir))
			new /obj/effect/temp_visual/paradise_attack_large/right(get_step(target_turf,dir))
	for(var/turf/open/T in range(target_turf, 1))
		for(var/mob/living/L in user.HurtInTurf(T, been_hit, modified_damage, PALE_DAMAGE, hurt_mechs = TRUE) - been_hit)
			been_hit += L
			if((L.stat < DEAD) && !(L.status_flags & GODMODE))
				healing_amount += healing
	var/enemies = 0
	for(var/mob/living/L in oview(6, get_turf(src)))
		if(enemies > aoe_cap)
			break
		if(user.faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		been_hit += L
		enemies += 1
		if((L.stat < DEAD) && !(L.status_flags & GODMODE))
			healing_amount += healing
			L.apply_damage(modified_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/paradise_attack(get_turf(L))
	if(healing_amount > 0)
		var/mob/living/carbon/human/H = user
		H.adjustStaminaLoss(-healing_amount*2)
		H.adjustBruteLoss(-healing_amount)
		H.adjustFireLoss(-healing_amount)
		H.adjustSanityLoss(-healing_amount)
	been_hit = list()
	healing_amount = 0

/obj/item/ego_weapon/paradise/get_clamped_volume()
	return 40

//Apocalypse Bird
/obj/item/ego_weapon/twilight
	name = "twilight"
	desc = "Just like how the ever-watching eyes, the scale that could measure any and all sin, \
	and the beak that could swallow everything protected the peace of the Black Forest... \
	The wielder of this armament may also bring peace as they did."
	special = "This weapon pierces to hit everything on the target's tile.\nUsing it in hand will activate its special ability. To perform this - click on a close by target to preform a devastating slash attack.\nPressing the middle mouse button click/alt click will perform a large area attack."
	icon_state = "twilight"
	worn_icon_state = "twilight"
	force = 20
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE // It's all damage types, actually
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/ego/twilight.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)
	var/mob/current_holder
	var/can_ultimate = TRUE
	var/ultimate_attack = FALSE
	var/ultimate_cooldown_time = 60 SECONDS
	var/ultimate_damage = 120 //does 480 total
	var/slash_length = 6
	var/slash_angle = 260
	var/aoe_cooldown_time = 5 SECONDS
	var/aoe_cooldown
	var/max_targets = 10 // Max targets for the AOE. 30 projectiles is a lot.

/obj/item/ego_weapon/twilight/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/twilight/dropped(mob/user)
	. = ..()
	if(!user)
		return
	current_holder = null

/obj/item/ego_weapon/twilight/attack(mob/living/M, mob/living/user)
	var/turf/T = get_turf(M)
	if(!CanUseEgo(user))
		return
	if(ultimate_attack)
		playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		user.do_attack_animation(M)
		ultimate_attack = FALSE
		can_ultimate = FALSE
		ultimate_attack = FALSE
		user.changeNext_move(CLICK_CD_MELEE * 3)
		do_slash(get_turf(M), user)
		addtimer(CALLBACK(src, PROC_REF(ultimate_reset)), ultimate_cooldown_time)
		return
	..()
	var/list/been_hit = QDELETED(M) ? list() : list(M)
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust / 100
	var/damage_dealt = force * justicemod * force_multiplier
	user.HurtInTurf(T, been_hit, damage_dealt, RED_DAMAGE, hurt_mechs = TRUE, hurt_structure = TRUE)
	for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
		user.HurtInTurf(T, been_hit, damage_dealt, damage_type, hurt_mechs = TRUE, hurt_structure = TRUE)
		damtype = damage_type
		M.attacked_by(src, user)
	damtype = initial(damtype)

/obj/item/ego_weapon/twilight/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	var/turf/target_turf = get_turf(A)
	if((get_dist(user, target_turf) > 5) || !(target_turf in view(10, user)))
		return
	..()
	if(ultimate_attack)
		playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		user.do_attack_animation(A)
		can_ultimate = FALSE
		ultimate_attack = FALSE
		user.changeNext_move(CLICK_CD_MELEE * 2)
		do_slash(get_turf(A), user)
		addtimer(CALLBACK(src, PROC_REF(ultimate_reset)), ultimate_cooldown_time)

/obj/item/ego_weapon/twilight/proc/ultimate_reset()
	if(current_holder)
		to_chat(current_holder, span_nicegreen("You're able to preform another ultimate slash with twilight."))
	can_ultimate = TRUE

/obj/item/ego_weapon/twilight/proc/do_slash(turf/target_turf, mob/living/user)
	user.visible_message(span_danger("[user] swings [src] with full force!"), \
	span_userdanger(""), vision_distance = COMBAT_MESSAGE_RANGE, ignored_mobs = user)
	to_chat(user, span_danger("You swing [src] with full force!"))
	var/list/slash_area = Make_Slash(get_turf(user), target_turf,slash_length, slash_angle, TRUE, -0.4)
	for(var/turf/T in slash_area)
		var/obj/effect/temp_visual/smash_effect/S = new(T)
		S.color = COLOR_MAROON
		for(var/mob/living/L in T)
			if(user.faction_check_mob(L))
				continue
			if(L.status_flags & GODMODE)
				continue
			L.visible_message(span_danger("[user] decimates [L]!"))
			var/aoe = ultimate_damage
			var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust / 100
			aoe *= justicemod
			aoe *= force_multiplier
			for(var/damage_type in list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
				L.apply_damage(aoe, damage_type, null, L.run_armor_check(null, damage_type))
			if(L.health <= 0)
				L.gib()

/obj/item/ego_weapon/twilight/EgoAttackInfo(mob/user)
	if(force_multiplier != 1)
		return span_notice("It deals [round((force * 4) * force_multiplier)] red, white, black and pale damage combined. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [force * 4] red, white, black and pale damage combined.")

/obj/item/ego_weapon/twilight/attack_self(mob/living/user)
	if(!CanUseEgo(user))
		return
	if(!can_ultimate)
		return
	ultimate_attack = !ultimate_attack
	if(ultimate_attack)
		to_chat(user, span_notice("You prepare an ultimate attack."))
	else
		to_chat(user, span_notice("You decide to not use the ultimate attack."))

/obj/item/ego_weapon/twilight/MiddleClickAction(atom/target, mob/living/user)
	. = ..()
	if(.)
		return
	if(!CanUseEgo(user))
		return
	if(ultimate_attack)
		return
	if(aoe_cooldown > world.time)
		to_chat(user, span_notice("This ability is on cooldown."))
		return
	var/list/candidates = list()
	var/current_targets = 0
	for(var/mob/living/L in view(8, user))
		if(user.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		if(current_targets >= max_targets)
			return
		candidates += L
		current_targets += 1
	if(!LAZYLEN(candidates))
		return
	aoe_cooldown = aoe_cooldown_time + world.time
	playsound(user, 'sound/abnormalities/bigbird/hypnosis.ogg', 75, FALSE, 4)
	for(var/mob/living/C in candidates)
		C.add_filter("target_outline", 1, drop_shadow_filter(color = "#EBD407", size = 2))
		addtimer(CALLBACK(C, TYPE_PROC_REF(/atom, remove_filter),"target_outline"), 30)
		user.add_filter("user_outline", 1, drop_shadow_filter(color = "#04080FAA", size = -8))
		addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, remove_filter),"user_outline"), 30)
	user.Immobilize(30)
	if(!do_after(user, 30, src))
		return
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	var/newdamage = (force * 1.2)
	newdamage *= justicemod
	newdamage *= force_multiplier
	for(var/i = 1 to 3 * length(candidates))
		var/atom/PT
		PT = pick(candidates)
		var/turf/T = get_step(get_turf(PT), pick(GLOB.alldirs))
		var/obj/projectile/ego_twilight/P = new(T)
		P.damage = newdamage
		P.starting = T
		P.firer = user
		P.fired_from = T
		P.yo = PT.y - T.y
		P.xo = PT.x - T.x
		P.original = PT
		P.preparePixelProjectile(PT, T)
		P.set_homing_target(PT)
		addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), 0.5 SECONDS)
	playsound(user, 'sound/abnormalities/apocalypse/fire.ogg', 50, FALSE, 12)

/obj/projectile/ego_twilight/Initialize()
	. = ..()
	animate(src, alpha = 255, pixel_x = rand(-10,10), pixel_y = rand(-10,10), time = 0.3 SECONDS)

/obj/projectile/ego_twilight
	name = "light"
	icon_state = "apocalypse"
	damage_type = BLACK_DAMAGE
	damage = 10
	alpha = 0
	spread = 45
	projectile_phasing = (ALL & (~PASSMOB))

//Distorted Form
/obj/item/ego_weapon/shield/distortion
	name = "distortion"
	desc = "The fragile human mind is fated to twist and distort."
	special = "This weapon requires two hands to use and always blocks ranged attacks."
	icon_state = "distortion"
	force = 20 //Twilight but lower in terms of damage
	attack_speed = 1.8
	damtype = RED_DAMAGE
	knockback = KNOCKBACK_MEDIUM
	attack_verb_continuous = list("pulverizes", "bashes", "slams", "blockades")
	attack_verb_simple = list("pulverize", "bash", "slam", "blockade")
	hitsound = 'sound/abnormalities/distortedform/slam.ogg'
	reductions = list(60, 60, 60, 60)
	projectile_block_duration = 3 SECONDS
	block_duration = 4.5 SECONDS
	block_cooldown = 2.5 SECONDS
	block_sound = 'sound/weapons/ego/heavy_guard.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

	attacking = TRUE //ALWAYS blocking ranged attacks

/obj/item/ego_weapon/shield/distortion/Initialize()
	. = ..()
	aggro_on_block *= 4

/obj/item/ego_weapon/shield/distortion/EgoAttackInfo(mob/user)
	return span_notice("It deals [force * 4] red, white, black and pale damage combined.")

/obj/item/ego_weapon/shield/distortion/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return
	for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
		damtype = damage_type
		target.attacked_by(src, user)
	damtype = initial(damtype)

/obj/item/ego_weapon/shield/distortion/CanUseEgo(mob/living/user)
	. = ..()
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot use [src] with only one hand!"))
		return FALSE

/obj/item/ego_weapon/shield/distortion/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	if(src != source.get_active_held_item() || !CanUseEgo(source))
		DisableBlock(source)
		return
	..()

/obj/item/ego_weapon/shield/distortion/DisableBlock(mob/living/carbon/human/user)
	if(!block)
		return
	..()

/obj/item/ego_weapon/shield/distortion/get_clamped_volume()
	return 40

/obj/item/ego_weapon/shield/distortion/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!CanUseEgo(owner)) //No blocking with one hand
		return
	..()

/obj/item/ego_weapon/shield/distortion/DropStance() //ALWAYS blocking ranged attacks, NEVER drop your stance!
	return

//Oberon
/obj/item/ego_weapon/oberon
	name = "fairy king"
	desc = "Then yes, I am the Oberon you seek."
	special = "Use this weapon in hand to swap between forms. This form has higher reach, hits 3 times, and builds up attack speed before unleasheing a powerful burst of damage."
	icon_state = "oberon_whip"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 20
	attack_speed = 0.8
	reach = 3
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("lacerates", "disciplines")
	attack_verb_simple = list("lacerate", "discipline")
	hitsound = 'sound/weapons/whip.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)
	var/mob/current_holder
	var/form = "whip"
	var/list/weapon_list = list(
		"whip" = list(20, 0.8, 3, list("lacerates", "disciplines"), list("lacerate", "discipline"), 'sound/weapons/whip.ogg', BLACK_DAMAGE, "This form has higher reach, hits 3 times, and builds up attack speed before unleasheing a powerful burst of damage."),
		"sword" = list(30, 0.8, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/weapons/fixer/generic/blade4.ogg', BLACK_DAMAGE, "This form can fire a projectile and does both RED DAMAGE and BLACK DAMAGE."),
		"hammer" = list(25, 1.4, 1, list("crushes"), list("crush"), 'sound/weapons/fixer/generic/baton2.ogg', BLACK_DAMAGE, "This form deals damage in an area and incease the RED and BLACK vulnerability by 0.2 to everything in that area."),
		"bat" = list(80, 1.6, 1, list("bludgeons", "bashes"), list("bludgeon", "bash"), 'sound/weapons/fixer/generic/gen1.ogg', RED_DAMAGE, "This form does RED DAMAGE and knocks back enemies."),
		"scythe" = list(50, 1.2, 1, list("slashes", "slices", "rips", "cuts"), list("slash", "slice", "rip", "cut"), 'sound/abnormalities/nothingthere/attack.ogg', RED_DAMAGE, "This form does RED DAMAGE and does 50% more damage when hitting targets below 50% health.")
		)
	var/gun_cooldown
	var/gun_cooldown_time = 1 SECONDS
	var/build_up = 0.8
	var/smashing = FALSE
	var/combo_time
	var/combo_wait = 15

/*
	Each form is meant to have their own purpose and niche,
	Whip: Far reaching melee and raw fast attacking black damage.(It looks cool as hell and has good dps I think. It's an aleph fusion of logging and aninmalism with animalism's multiple hits when you attack and loggings attack speed build up into aoe burst.)
	Sword: Raw mixed damage/ranged weapon also.(Since its like a buffed soulmate without the mark gimmick.)
	Hammer: Black damage aoe support/armor weakener.(Meant to combo with the other weapons with the red and black rend it has and to deal with groups also incase you somehow kill oberon before amber midnight.)
	Bat: Slow attacking red damage with knockback.(Simple yes, but it's useful versus stuff like Censored or Black Fixer. I guess it's an upgrade/sidegrade of flesh is willing and summer solstice but that wasn't intentional since it was black before I changed it.)
	Scythe: A good finisher that has dps on par with the sword when the target has 50% hp or lower while being slightly worse than aleph dps wise otherwise I think.(Used to be a shittier mimicry)
	Whip, Sword, and Bat are meant to be raw damage, Hammer is meant to be utility, and  Scythe is meant to be a finisher.
*/

/obj/item/ego_weapon/oberon/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/oberon/attack_self(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		return
	SwitchForm(user)

/obj/item/ego_weapon/oberon/equipped(mob/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/oberon/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/oberon/attack(mob/living/target, mob/living/carbon/human/user)
	if(world.time > combo_time)
		build_up = 0.8
	combo_time = world.time + combo_wait
	knockback = FALSE
	switch(form)
		if("scythe")
			if(target.health <= (target.maxHealth * 0.5))
				playsound(get_turf(target), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 7)
				new /obj/effect/temp_visual/nobody_grab(get_turf(target))
				force = 75
			else
				force = 50

		if("bat")
			knockback = KNOCKBACK_MEDIUM

	. = ..()
	if(!.)
		return

	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust / 100

	switch(form)
		if("sword")
			var/red = force
			red*=justicemod
			target.apply_damage(red * force_multiplier, RED_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

		if("whip")
			var/multihit = force
			multihit*= justicemod
			for(var/i = 1 to 2)
				sleep(2)
				if(target in view(reach,user))
					playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
					user.do_attack_animation(target)
					target.attacked_by(src, user)
					log_combat(user, target, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

		if("hammer")
			for(var/mob/living/L in view(2, target))
				var/aoe = force
				aoe*=justicemod
				if(user.faction_check_mob(L))
					continue
				L.apply_damage(aoe * force_multiplier, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))
				if(!ishuman(L))
					if(!L.has_status_effect(/datum/status_effect/rend_black))
						L.apply_status_effect(/datum/status_effect/rend_black)
					if(!L.has_status_effect(/datum/status_effect/rend_red))
						L.apply_status_effect(/datum/status_effect/rend_red)

/obj/item/ego_weapon/oberon/melee_attack_chain(mob/user, atom/target, params)
	..()
	switch(form)
		if("whip")
			if(isliving(target))
				user.changeNext_move(CLICK_CD_MELEE * build_up) // Starts a little fast, but....
				if (build_up <= 0.1)
					build_up = 0.8
					user.changeNext_move(CLICK_CD_MELEE * 4)
					if(!smashing)
						to_chat(user,span_warning("The whip starts to thrash around uncontrollably!"))
						Smash(user, target)
				else
					build_up -= (0.1/3)//sortof silly but its a way to fix each whip hit from increasing build up 3 times as it should.
			else
				user.changeNext_move(CLICK_CD_MELEE * 0.8)

/obj/item/ego_weapon/oberon/proc/Smash(mob/user, atom/target)
	smashing = TRUE
	playsound(user, 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 50, 0, 3)
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	var/smash_damage = 85
	smash_damage *= justicemod
	sleep(0.5 SECONDS)
	for(var/i = 0; i < 3; i++)
		for(var/turf/T in view(3, user))
			new /obj/effect/temp_visual/nobody_grab(T)
			for(var/mob/living/L in T)
				if(user.faction_check_mob(L))
					continue
				L.apply_damage(smash_damage * force_multiplier, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		playsound(user, 'sound/abnormalities/fairy_longlegs/attack.ogg', 75, 0, 3)
		sleep(0.5 SECONDS)
	smashing = FALSE
	return

/obj/item/ego_weapon/oberon/get_clamped_volume()
	return 40

/obj/item/ego_weapon/oberon/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	switch(form)
		if("sword")
			if(!proximity_flag && gun_cooldown <= world.time)
				var/turf/proj_turf = user.loc
				if(!isturf(proj_turf))
					return
				var/obj/projectile/ego_bullet/gunblade/G = new /obj/projectile/ego_bullet/gunblade(proj_turf)
				G.damage = 45
				G.icon_state = "red_laser"
				playsound(user, 'sound/weapons/ionrifle.ogg', 100, TRUE)
				G.firer = user
				G.preparePixelProjectile(target, user, clickparams)
				G.fire()
				G.damage *= force_multiplier
				gun_cooldown = world.time + gun_cooldown_time
				return
// Radial menu
/obj/item/ego_weapon/oberon/proc/SwitchForm(mob/user)
	var/list/armament_icons = list(
		"whip" = image(icon = src.icon, icon_state = "oberon_whip"),
		"sword"  = image(icon = src.icon, icon_state = "oberon_sword"),
		"hammer"  = image(icon = src.icon, icon_state = "oberon_hammer"),
		"bat"  = image(icon = src.icon, icon_state = "oberon_bat"),
		"scythe" = image(icon = src.icon, icon_state = "oberon_scythe")
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, src , armament_icons, custom_check = CALLBACK(src, PROC_REF(CheckMenu), user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	form = choice
	Transform()

/obj/item/ego_weapon/oberon/proc/CheckMenu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/ego_weapon/oberon/proc/Transform()
	icon_state = "oberon_[form]"
	update_icon_state()
	if(current_holder)
		to_chat(current_holder,span_notice("[src] suddenly transforms!"))
		current_holder.update_inv_hands()
		current_holder.playsound_local(current_holder, 'sound/effects/blobattack.ogg', 75, FALSE)
	force = weapon_list[form][1]
	attack_speed = weapon_list[form][2]
	reach = weapon_list[form][3]
	attack_verb_continuous = weapon_list[form][4]
	attack_verb_simple = weapon_list[form][5]
	hitsound = weapon_list[form][6]
	damtype = weapon_list[form][7]
	special = "Use this weapon in hand to swap between forms. [weapon_list[form][8]]"
	build_up = 0.8

//Bottle of Tears
/**
 * Here's how it works. It scales with Fortitude.
 * This is more balanced than it sounds.
 * Think of it as if Fortitude adjusted base force.
 * Once you get yourself to 80, an additional scaling factor begins to kick in that will let you keep up through the endgame.
 * This scaling factor only applies if it's the only weapon in your inventory, however. Use it faithfully, and it can cut through even enemies immune to black.
 * Why? Because well Catt has been stated to work on WAWs, which means that she's at least level 3-4.
 * Why is she still using Eyeball Scooper from a Zayin? Maybe it scales with fortitude?
 */
/obj/item/ego_weapon/eyeball
	name = "eyeball scooper"
	desc = "Mind if I take them?"
	special = "This weapon grows more powerful as you do, but its potential is limited if you possess any other EGO weapons."
	icon_state = "eyeball1"
	force = 12
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("cuts", "smacks", "bashes")
	attack_verb_simple = list("cuts", "smacks", "bashes")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 20, //It's 20 to keep clerks from using it
	)

/obj/item/ego_weapon/eyeball/attack(mob/living/target, mob/living/carbon/human/user)
	force = initial(force)
	damtype = initial(damtype)
	var/userfort = (get_attribute_level(user, FORTITUDE_ATTRIBUTE))
	var/fortitude_mod = clamp((userfort - 40) / 4 + 2, 0, 50) // 3 at 40 fortitude, 17 at 100 fortitude
	var/extra_mod = fortitude_mod * 0.5
	var/list/search_area = user.contents.Copy()
	for(var/obj/item/storage/spare_space in search_area)
		search_area |= spare_space.contents
	for(var/obj/item/ego_weapon/ranged/disloyal_gun in search_area)
		extra_mod = 0
		break
	for(var/obj/item/ego_weapon/disloyal_weapon in search_area)
		if(disloyal_weapon == src)
			continue
		extra_mod = 0
		break
	force = 12 + fortitude_mod
	if(extra_mod > 0)
		var/resistance = target.run_armor_check(null, damtype)
		icon_state = "eyeball2"				// Cool sprite
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) <= 0)
				resistance = 100
		if(resistance >= 100) // If the eyeball wielder is going no-balls and using one fucking weapon, let's throw them a bone.
			force *= 0.1
			damtype = BRUTE //Armor-piercing
	else
		icon_state = "eyeball1" //Cool sprite gone
	if(ishuman(target))
		force *= 1.3
	return ..()

//Pile of Mail
/obj/item/ego_weapon/mail_satchel
	name = "envelope"
	desc = "Heavy satchel filled to the brim with letters."
	icon_state = "mailsatchel"
	force = 6
	attack_speed = 1.2
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("slams", "bashes", "strikes")
	attack_verb_simple = list("slams", "bashes", "strikes")
	attribute_requirements = list(TEMPERANCE_ATTRIBUTE = 20) //pesky clerks!

/obj/item/ego_weapon/mail_satchel/attack(atom/A, mob/living/user, proximity_flag, params)
	force = initial(force)
	var/usertemp = (get_attribute_level(user, TEMPERANCE_ATTRIBUTE))
	var/temperance_mod = clamp((usertemp - 20) / 4 + 2, 0, 14)
	force = 6 + temperance_mod
	if(prob(30))
		new /obj/effect/temp_visual/maildecal(get_turf(A))

	return ..()

//Puss in Boots
/obj/item/ego_weapon/lance/famiglia
	name = "famiglia"
	desc = "Do not be cast down, for I will provide for your well-being as well as mine."
	icon_state = "famiglia"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 20
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	attack_speed = 1.4// slow
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/ego/mace1.ogg'

/obj/item/ego_weapon/lance/famiglia/CanUseEgo(mob/living/carbon/human/user)
	. = ..()
	var/datum/status_effect/chosen/C = user.has_status_effect(/datum/status_effect/chosen)
	if(!C)
		to_chat(user, span_notice("You cannot use [src], only the abnormality's chosen can!"))
		return FALSE

/obj/item/ego_weapon/lance/famiglia/attack(mob/living/target, mob/living/user)
	if(raised)
		knockback = KNOCKBACK_LIGHT
	else
		knockback = FALSE

	return ..()

/obj/item/ego_weapon/lance/famiglia/LowerLance(mob/user)
	hitsound = 'sound/weapons/ego/spear1.ogg'
	..()

/obj/item/ego_weapon/lance/famiglia/RaiseLance(mob/user)
	hitsound = 'sound/weapons/ego/mace1.ogg'
	..()

//We Can Change Anything
/obj/item/ego_weapon/iron_maiden
	name = "iron maiden"
	desc = "Just open up the machine, step inside, and press the button to make it shut. Now everything will be just fine.."
	special = "This weapon builds up the amount of times it hits as you attack, at maximum speed it will damage you per hit, increasing more and more, use it in hands."
	icon_state = "iron_maiden"
	force = 14 //DPS of 14, 28, 42, 56 at each ramping level
	damtype = RED_DAMAGE

	attack_verb_continuous = list("clamps")
	attack_verb_simple = list("clamp")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/ramping_speed = 0 //maximum of 10
	var/ramping_damage = 0 //no maximum, will stack as long as people are attacking with it.

/obj/item/ego_weapon/iron_maiden/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/iron_maiden/proc/Multihit(mob/living/target, mob/living/user, attack_amount)
	sleep(1)
	for(var/i = 1 to attack_amount)
		switch(attack_amount)
			if(1)
				sleep(5)
			if(2)
				sleep(3)
			if(3)
				sleep(2)
		if(target in view(reach,user))
			playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
			user.do_attack_animation(target)
			target.attacked_by(src, user)
			log_combat(user, target, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/iron_maiden/melee_attack_chain(mob/living/user, atom/target, params)
	..()
	if(isliving(target))
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))

/obj/item/ego_weapon/iron_maiden/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	if (ramping_speed < 25)
		ramping_speed += 1
	else
		ramping_damage += 0.02
		user.adjustBruteLoss(user.maxHealth*ramping_damage)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(user), pick(GLOB.alldirs))
	playsound(loc, 'sound/abnormalities/we_can_change_anything/change_generate.ogg', get_clamped_volume(), FALSE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	switch(ramping_speed)
		if(5 to 10)
			Multihit(target, user, 1)
		if(10 to 15)
			Multihit(target, user, 2)
		if(15 to 25)
			if(icon_state != "iron_maiden_open")
				playsound(src, 'sound/abnormalities/we_can_change_anything/change_gas.ogg', 50, TRUE)
				icon_state = "iron_maiden_open"
				update_icon_state()
			Multihit(target, user, 3)
	return

/obj/item/ego_weapon/iron_maiden/attack_self(mob/user)
	if(ramping_speed == 0)
		to_chat(user,span_notice("It is already revved down!"))
		return
	to_chat(user,span_notice("You being to cool down [src]."))
	playsound(src, 'sound/abnormalities/we_can_change_anything/change_gas.ogg', 50, TRUE)
	if(do_after(user, 2 SECONDS, src))
		icon_state = "iron_maiden"
		update_icon_state()
		playsound(src, 'sound/abnormalities/we_can_change_anything/change_start.ogg', 50, FALSE)
		ramping_speed = 0
		ramping_damage = 0
		force = initial(force)
		to_chat(user,span_notice("The mechanism on [src] dies down!"))

//Nihil Event rewards
/obj/item/ego_weapon/goldrush/nihil
	name = "worthless greed"
	desc = "The magical girl, who was no longer a magical girl, ate many things. \
	Authority, money, fame, and many other forms of pleasure. She ended up eating away anything in her sight."
	special = "This weapon has a combo system and can charge up a powerful charge attack."
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'
	icon_state = "greed"
	force = 35
	var/charge_damage = 120
	var/charge_wind_up = 2 SECONDS
	var/can_charge = TRUE
	var/prepair_charge = FALSE
	var/charge_cooldown_time = 7 SECONDS

/obj/item/ego_weapon/goldrush/nihil/attack_self(mob/user) //spin attack with knockback
	if(!CanUseEgo(user) || charging)
		return
	if(!can_charge)
		to_chat(user,span_warning("You attacked too recently."))
		return
	prepair_charge = !prepair_charge
	if(!prepair_charge)
		to_chat(user,span_notice("You prepair to preform a dash."))
	else
		to_chat(user,span_notice("You decide to not preform a dash."))
	. = ..()

/obj/item/ego_weapon/goldrush/nihil/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user) || !prepair_charge || charging)
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	..()
	to_chat(user,span_notice("You start charging up a dash."))
	prepair_charge = FALSE
	charging = TRUE
	user.Immobilize(stuntime)
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	if(do_after(user, charge_wind_up, src))
		if(QDELETED(user))
			charge_reset_forced()
			return
		can_charge = FALSE
		var/list/been_hit = list()
		var/turf/end_turf = get_ranged_target_turf_direct(user, target_turf, 12, 0)
		var/list/turf_list = getline(user, end_turf)
		for(var/turf/T in turf_list)
			var/dir = get_dir(get_turf(src), T)
			var/stop_charge = FALSE
			if(T.density)
				break
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
			if(QDELETED(user))
				charge_reset_forced()
				return
			user.loc = T
			var/aoe = charge_damage
			var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust / 100
			aoe *= justicemod
			aoe *= force_multiplier
			for(var/mob/living/L in range(1, user))
				if(L == user)
					continue
				if(ishuman(L))
					continue
				if(L in been_hit)
					continue
				been_hit += L
				L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				var/throw_target = get_edge_target_turf(L, dir)
				var/whack_speed = (prob(60) ? 2 : 4)
				L.throw_at(throw_target, rand(2, 4), whack_speed, user)
				L.visible_message(span_danger("[user] tackles [L]!"))
				playsound(T, 'sound/abnormalities/kog/GreedHit1.ogg', 40, 1)
				playsound(T, 'sound/abnormalities/kog/GreedHit2.ogg', 30, 1)
			for(var/turf/open/R in range(1, T))
				new /obj/effect/temp_visual/small_smoke/halfsecond(R)
			playsound(src,'sound/effects/bamf.ogg', 70, TRUE, 20)
			user.Immobilize(0.6)
			sleep(0.6)
		REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		addtimer(CALLBACK(src, PROC_REF(charge_reset)), charge_cooldown_time)
		charging = FALSE
	else
		charge_reset_forced()

/obj/item/ego_weapon/goldrush/goldrush/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/nihil))
		return
	..()

/obj/item/ego_weapon/goldrush/nihil/proc/charge_reset_forced()
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	charge_reset()

/obj/item/ego_weapon/goldrush/nihil/proc/charge_reset()
	can_charge = TRUE
	charging = FALSE

/obj/item/ego_weapon/shield/despair_nihil
	name = "meaningless despair"
	desc = "When Justice turns its back once more, several dozen blades will rove without a purpose. \
	The swords will eventually point at those she could not protect."
	special = "This weapon has a combo system."
	icon_state = "despair_nihil"
	force = 20
	attack_speed = 1
	visual_attack_speed = 0.4
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	reductions = list(90, 90, 90, 50)
	projectile_block_duration = 1 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/shield/despair_nihil/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fixer/generic/sword5.ogg', 50, FALSE, 9)
		to_chat(user,span_warning("You are offbalance, you take a moment to reset your stance."))
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/blind_rage/nihil
	name = "senseless wrath"
	desc = "The Servant of Wrath valued justice and balance more than anyone, but she began sharing knowledge with the \
	Hermit - an enemy of her realm, becoming friends with her in secret."
	icon_state = "wrath"
	force = 50
	attack_speed = 1.2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	aoe_damage = 30
	aoe_range = 3

/obj/item/ego_weapon/blind_rage/nihil/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/nihil))
		return
	..()

//Tutorial
/obj/item/ego_weapon/tutorial
	name = "rookie dagger"
	desc = "E.G.O intended for Agent Education"
	icon_state = "rookie"
	force = 3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "stabs", "slashes")
	attack_verb_simple = list("cuts", "stabs", "slashes")

/obj/item/ego_weapon/tutorial/white
	name = "fledgling dagger"
	icon_state = "fledgling"
	damtype = WHITE_DAMAGE

/obj/item/ego_weapon/tutorial/black
	name = "apprentice dagger"
	icon_state = "apprentice"
	damtype = BLACK_DAMAGE

/obj/item/ego_weapon/tutorial/pale
	name = "freshman dagger"
	icon_state = "freshman"
	damtype = PALE_DAMAGE
