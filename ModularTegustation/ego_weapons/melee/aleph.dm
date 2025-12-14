/obj/item/ego_weapon/justitia
	name = "justitia"
	desc = "A sharp sword covered in bandages. It may be able to not only cut flesh but trace of sins as well."
	special = "This weapon has a combo system."
	icon_state = "justitia"
	force = 14
	modified_attack_speed = 0.4
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	hitsound = 'sound/weapons/ego/justitia1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

	var/combo = 0
	/// Maximum world.time after which combo is reset
	var/combo_time
	/// Wait time between attacks for combo to reset
	var/combo_wait = 10
	var/aoe_damage = 20

/obj/item/ego_weapon/justitia/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(5)
			hitsound = 'sound/weapons/ego/justitia2.ogg'
			force *= 1.5
			user.changeNext_move(CLICK_CD_MELEE * 0.5)
		if(1,4)
			hitsound = 'sound/weapons/ego/justitia3.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.3)
		if(6)
			hitsound = 'sound/weapons/ego/justitia4.ogg'
			combo = -1
			user.changeNext_move(CLICK_CD_MELEE * 1.2)
			var/turf/T = get_turf(M)
			new /obj/effect/temp_visual/justitia_effect(T)
			var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust / 100
			var/damage_dealt = aoe_damage * justicemod * force_multiplier
			user.HurtInTurf(T, list(), damage_dealt, PALE_DAMAGE, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
		else
			hitsound = 'sound/weapons/ego/justitia1.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/justitia/get_clamped_volume()
	return 40

/obj/item/ego_weapon/da_capo
	name = "da capo"
	desc = "A scythe that swings silently and with discipline like a conductor's gestures and baton. \
	If there were a score for this song, it would be one that sings of the apocalypse."
	special = "This weapon has a combo system, but only on a single enemy."
	icon_state = "da_capo"
	force = 20 // It attacks very fast
	attack_speed = 0.5
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/ego/da_capo1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

	var/combo = 0 // I am copy-pasting justitia "combo" system and nobody can stop me
	var/combo_time
	var/combo_wait = 14
	var/waltz_partner
	//I'm making Da Capo a waltzing weapon, It should play like a rhythm game. - Kirie.

/obj/item/ego_weapon/da_capo/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	if(!waltz_partner || waltz_partner != M)
		waltz_partner = M
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(1)
			hitsound = 'sound/weapons/ego/da_capo2.ogg'
		if(2)
			hitsound = 'sound/weapons/ego/da_capo3.ogg'
			force *= 1.5
			combo = -1
		else
			hitsound = 'sound/weapons/ego/da_capo1.ogg'
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/da_capo/get_clamped_volume()
	return 40

/obj/item/ego_weapon/mimicry
	name = "mimicry"
	desc = "The yearning to imitate the human form is sloppily reflected on the E.G.O, \
	as if it were a reminder that it should remain a mere desire."
	special = "Use this weapon in hand to swap between forms. The sword heals you on hit, the spear has higher reach, the scythe deals extra damage in an area."
	icon_state = "mimicry_sword"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 35
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/abnormalities/nothingthere/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/mob/current_holder
	var/form = "whip"
	var/list/weapon_list = list(
		"sword" = list(35, 1, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/abnormalities/nothingthere/attack.ogg'),
		"spear" = list(56, 1.4, 2, list("pierces", "stabs", "perforates"), list("pierce", "stab", "perforate"), 'sound/weapons/ego/mimicry_stab.ogg'),
		"scythe" = list(52, 1.6, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/abnormalities/nothingthere/goodbye_attack.ogg')
		)

/obj/item/ego_weapon/mimicry/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/mimicry/attack_self(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		return
	SwitchForm(user)

/obj/item/ego_weapon/mimicry/equipped(mob/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/mimicry/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/mimicry/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(form == "sword")
		if(!(target.status_flags & GODMODE) && target.stat != DEAD)
			var/heal_amt = force*0.12
			if(isanimal(target))
				var/mob/living/simple_animal/S = target
				if(S.damage_coeff.getCoeff(damtype) > 0)
					heal_amt *= S.damage_coeff.getCoeff(damtype)
				else
					heal_amt = 0
			user.adjustBruteLoss(-heal_amt)
	if(form != "scythe")
		return

	var/list/been_hit = list(target)
	for(var/turf/T in Make_Slash(get_turf(user), get_turf(target), 3, 240))
		if(user in T)
			continue
		new /obj/effect/temp_visual/nt_goodbye(T)
		for(var/mob/living/L in T)
			var/aoe = 35
			var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust/100
			aoe*=justicemod
			aoe*=force_multiplier
			if(L == user || ishuman(L))
				continue
			been_hit = user.HurtInTurf(T, been_hit, aoe, RED_DAMAGE, hurt_mechs = TRUE, hurt_structure = TRUE, attack_type = (ATTACK_TYPE_MELEE))

/obj/item/ego_weapon/mimicry/get_clamped_volume()
	return 40

// Radial menu
/obj/item/ego_weapon/mimicry/proc/SwitchForm(mob/user)
	var/list/armament_icons = list(
		"sword" = image(icon = src.icon, icon_state = "mimicry_sword"),
		"spear"  = image(icon = src.icon, icon_state = "mimicry_spear"),
		"scythe"  = image(icon = src.icon, icon_state = "mimicry_scythe")
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, src , armament_icons, custom_check = CALLBACK(src, PROC_REF(CheckMenu), user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	form = choice
	Transform()

/obj/item/ego_weapon/mimicry/proc/CheckMenu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/ego_weapon/mimicry/proc/Transform()
	icon_state = "mimicry_[form]"
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
	if(reach > 1)
		stuntime = 5
		swingstyle = WEAPONSWING_THRUST
	else
		stuntime = 0
		swingstyle = WEAPONSWING_LARGESWEEP

/obj/item/ego_weapon/goldrush
	name = "gold rush"
	desc = "The weapon of someone who can swing their weight around like a truck"
	special = "This weapon has a combo system."
	icon_state = "gold_rush"
	hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
	force = 25
	modified_attack_speed = 0.3
	damtype = RED_DAMAGE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/charging = FALSE
	var/combo = 0
	var/combo_time
	var/combo_wait = 10

//This is like an anime character attacking like 6 times with the 6th one as a finisher attack.
/obj/item/ego_weapon/goldrush/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user) || charging)
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo >= 6)
		M.visible_message(span_danger("[user] rears up and slams into [M]!"), \
						span_userdanger("[user] punches you with everything you got!!"), vision_distance = COMBAT_MESSAGE_RANGE, ignored_mobs = user)
		to_chat(user, span_danger("You throw your entire body into this punch!"))
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 3)
		playsound(src, 'sound/weapons/fixer/generic/finisher2.ogg', 50, FALSE, 9)
		to_chat(user,span_warning("You are offbalance, you take a moment to reset your stance."))
		force *= 5
		knockback = KNOCKBACK_HEAVY
	else if(combo < 6 && combo >= 3)
		for(var/i = 1 to combo)
			sleep(2)
			if(M in view(reach,user))
				combo_time = world.time + combo_wait
				user.changeNext_move(CLICK_CD_MELEE * 0.4)
				playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
				user.do_attack_animation(M)
				M.attacked_by(src, user)
				log_combat(user, M, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	else if(combo == 2)
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.6)
	..()
	knockback = null
	combo += 1

	force = initial(force)

/obj/item/ego_weapon/goldrush/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/diamond))
		return
	new /obj/item/ego_weapon/goldrush/nihil(get_turf(src))
	to_chat(user,span_warning("The [I] seems to drain all of the light away as it is absorbed into [src]!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/ego_weapon/smile
	name = "smile"
	desc = "The monstrous mouth opens wide to devour the target, its hunger insatiable."
	special = "This weapon instantly consumes targets below 5% health and attacks faster or slower depending on how \"hungry\" is it."	//To make it more unique, if it's too strong
	icon_state = "smile"
	force = 35 //~70 at max nourishment.
	attack_speed = 1
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	usesound = 'sound/weapons/ego/hammer.ogg'
	toolspeed = 0.12
	tool_behaviour = TOOL_MINING
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/nourishment = 0
	var/can_spin = TRUE
	var/spinning = FALSE
	var/aoe_range = 2
	var/multiplier = 0
	var/hunger_time = 5 SECONDS
	var/draining = FALSE
	var/hunger_timer

/obj/item/ego_weapon/smile/examine(mob/user)
	. = ..()
	switch(multiplier)
		if(0)
			. += "It seems famished, the user will attack faster but deal less damage."
		if(1 to 1.5)
			. += "It seems hungry, the user's attack speed and damage will be in the middle range."
		if(1.6)
			. += "It seems full, the user will attack more slowly but deal more damage per hit."


/obj/item/ego_weapon/smile/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!can_spin)
		return FALSE
	. = ..()
	can_spin = FALSE
	addtimer(CALLBACK(src, PROC_REF(spin_reset)), 13)
	if((target.health <= target.maxHealth * 0.05 || target.stat == DEAD) && !(target.status_flags & GODMODE))	//Makes up for the lack of damage by automatically killing things under 10% HP
		target.gib()
		adjust_nourishment(100)
	else
		adjust_nourishment(10)

/obj/item/ego_weapon/smile/proc/adjust_nourishment(amount_changed)
	nourishment = clamp(nourishment + amount_changed, 0, 100)
	switch(nourishment)
		if(0 to 49)
			multiplier = 0
			aoe_range = 1
		if(50 to 70)
			multiplier = 1.2
			aoe_range = 2
		if(71 to 94)
			multiplier = 1.4
			aoe_range = 3
		if(95 to 100)
			multiplier = 1.6
			aoe_range = 4
	if(!multiplier)
		force = initial(force)
		attack_speed = initial(attack_speed)
		return
	force = initial(force) * multiplier
	attack_speed = initial(attack_speed) * multiplier

/obj/item/ego_weapon/smile/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	if(draining)
		return
	draining = TRUE
	HungerDrain()

/obj/item/ego_weapon/smile/proc/HungerDrain()
	adjust_nourishment(-5)
	hunger_timer = addtimer(CALLBACK(src, PROC_REF(HungerDrain)), hunger_time, TIMER_STOPPABLE)

/obj/item/ego_weapon/smile/proc/spin_reset()
	can_spin = TRUE

/obj/item/ego_weapon/smile/attack_self(mob/living/user) //spin attack with knockback
	if(!CanUseEgo(user))
		return
	if(!can_spin)
		to_chat(user,span_warning("You attacked too recently."))
		return
	can_spin = FALSE

	if(do_after(user, (attack_speed * 8), src))
		user.Immobilize(0.6 SECONDS)
		ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		user.pixel_z = 16
		sleep(0.5 SECONDS)
		REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		if(QDELETED(user))
			spin_reset()
			return
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		user.pixel_z = 0
		var/aoe = force
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		var/firsthit = TRUE
		aoe*=justicemod
		aoe*=force_multiplier
		var/has_eaten = FALSE
		if(aoe_range >= 4)
			playsound(user, 'sound/abnormalities/mountain/slam.ogg', 50, TRUE, -1)
		else
			playsound(user, 'sound/weapons/ego/hammer.ogg', 50, TRUE, -1)
		for(var/turf/T in orange(aoe_range, user))
			var/obj/effect/temp_visual/smash_effect/the_effect = new(T)
			the_effect.color = COLOR_ALMOST_BLACK
		for(var/mob/living/L in range(aoe_range, user)) //knocks enemies away from you
			if(L == user || ishuman(L))
				continue
			L.deal_damage(aoe, damtype, user, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
			if(firsthit)
				aoe = (aoe / 2)
				firsthit = FALSE
			if((L.health <= L.maxHealth * 0.05 || L.stat == DEAD) && !(L.status_flags & GODMODE))	//Makes up for the lack of damage by automatically killing things under 10% HP
				L.gib()
				has_eaten = TRUE
				continue
			var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, src)))
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(throw_target, rand(1, 2), whack_speed, user)
		if(!has_eaten)
			adjust_nourishment(-100)
		spin_reset()
		return
	addtimer(CALLBACK(src, PROC_REF(spin_reset)), attack_speed * 8)

/obj/item/ego_weapon/smile/get_clamped_volume()
	return clamp(force * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100

/obj/item/ego_weapon/smile/suicide_act(mob/living/carbon/user)
	. = ..()
	user.visible_message(span_suicide("[user] holds \the [src] in front of [user.p_them()], and begins to swing [user.p_them()]self with it! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(user, 'sound/weapons/ego/hammer.ogg', 50, TRUE, -1)
	user.gib()
	return MANUAL_SUICIDE

/obj/item/ego_weapon/smile/Destroy(mob/user)
	. = ..()
	deltimer(hunger_timer)

/obj/item/ego_weapon/blooming
	name = "blooming"
	desc = "A rose is a rose, by any other name."
	special = "Use this weapon to change its damage type between red, white and pale."	//like a different rabbit knife. No black though
	icon_state = "rosered"
	force = 40 //Less damage, can swap damage type
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/ego/rapier2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/blooming/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
			force = 40 //Prefers red, you can swap to white if needed
			icon_state = "rosewhite"
		if(WHITE_DAMAGE)
			damtype = PALE_DAMAGE
			force = 30
			icon_state = "rosepale"
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
			force = 40
			icon_state = "rosered"
	to_chat(user, span_notice("[src] will now deal [force] [damtype] damage."))
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

/obj/item/ego_weapon/censored
	name = "CENSORED"
	desc = "(CENSORED) has the ability to (CENSORED), but this is a horrendous sight for those watching. \
			Looking at the E.G.O for more than 3 seconds will make you sick."
	special = "Using it in hand will activate its special ability. To perform this attack - click on a distant target."
	icon_state = "censored"
	worn_icon_state = "censored"
	force = 35	//there's a focus on the ranged attack here.
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("attacks")
	attack_verb_simple = list("attack")
	hitsound = 'sound/weapons/ego/censored1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

	var/special_attack = FALSE
	var/special_damage = 120
	var/special_cooldown
	var/special_cooldown_time = 10 SECONDS
	var/special_checks_faction = TRUE

/obj/item/ego_weapon/censored/attack_self(mob/living/user)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	special_attack = !special_attack
	if(special_attack)
		to_chat(user, span_notice("You prepare special attack."))
	else
		to_chat(user, span_notice("You decide to not use special attack."))

/obj/item/ego_weapon/censored/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	if(!special_attack)
		return
	special_attack = FALSE
	var/turf/target_turf = get_ranged_target_turf_direct(user, A, 4)
	var/list/turfs_to_hit = getline(user, target_turf)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		new /obj/effect/temp_visual/cult/sparks(T)
	playsound(user, 'sound/weapons/ego/censored2.ogg', 75)
	special_cooldown = world.time + special_cooldown_time
	if(!do_after(user, 7, src))
		return
	playsound(user, 'sound/weapons/ego/censored3.ogg', 75)
	var/turf/MT = get_turf(user)
	MT.Beam(target_turf, "censored", time=5)
	var/modified_damage = (special_damage * force_multiplier)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		for(var/mob/living/L in T)
			if(special_checks_faction && user.faction_check_mob(L))
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(!H.sanity_lost)
						continue
				else
					continue
			L.deal_damage(modified_damage, BLACK_DAMAGE, user, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

/obj/item/ego_weapon/censored/get_clamped_volume()
	return 30

/obj/item/ego_weapon/soulmate
	name = "Soulmate"
	desc = "The course of true love never did run smooth."
	special = "Hitting enemies will mark them. Hitting marked enemies will give different buffs depending on attack type."
	icon_state = "soulmate"
	force = 20
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE
	attack_speed = 0.8
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/blade1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

	var/bladebuff = FALSE
	var/gunbuff = FALSE
	var/list/blademark_targets = list()
	var/list/gunmark_targets = list()
	var/gun_cooldown
	var/blademark_cooldown
	var/gunmark_cooldown
	var/gun_cooldown_time = 1 SECONDS
	var/mark_cooldown_time = 15 SECONDS

/obj/item/ego_weapon/soulmate/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/soulmate/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target) && !(gunbuff))
		if(target in gunmark_targets)
			gunmark_targets = list()
			bladebuff = TRUE
			icon_state = "soulmate_blade"
			update_icon_state()
			update_icon()
			attack_speed = 0.4
			gunmark_cooldown = world.time + mark_cooldown_time
			addtimer(CALLBACK(src, PROC_REF(BladeRevert)), 50)
			return
		if(!(bladebuff) && blademark_cooldown <= world.time)
			blademark_targets += target

/obj/item/ego_weapon/soulmate/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/ego_bullet/gunblade/G = new /obj/projectile/ego_bullet/gunblade(proj_turf)
		if(gunbuff)
			G.damage = 45
			G.icon_state = "red_laser"
			playsound(user, 'sound/weapons/ionrifle.ogg', 100, TRUE)
		else
			G.fired_from = src //for signal check
			playsound(user, 'sound/weapons/plasma_cutter.ogg', 100, TRUE)
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		G.damage *= force_multiplier
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/soulmate/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	if(isliving(target) && !(bladebuff))
		if(target in blademark_targets)
			blademark_targets = list()
			gunbuff = TRUE
			icon_state = "soulmate_gun"
			update_icon_state()
			update_icon()
			blademark_cooldown = world.time + mark_cooldown_time
			addtimer(CALLBACK(src, PROC_REF(GunRevert)), 80)
			return TRUE
		if(!(gunbuff) && gunmark_cooldown <= world.time)
			gunmark_targets += target
	return TRUE

/obj/item/ego_weapon/soulmate/proc/BladeRevert()
	if(bladebuff)
		icon_state = "soulmate"
		update_icon_state()
		update_icon()
		attack_speed = 0.8
		bladebuff = FALSE

/obj/item/ego_weapon/soulmate/proc/GunRevert()
	if(gunbuff)
		icon_state = "soulmate"
		update_icon_state()
		update_icon()
		gunbuff = FALSE

/obj/projectile/ego_bullet/gunblade
	name = "energy bullet"
	damage = 30
	damage_type = RED_DAMAGE
	icon_state = "ice_1"

/obj/item/ego_weapon/space
	name = "out of space"
	desc = "It hails from realms whose mere existence stuns the brain and numbs us with the black extra-cosmic gulfs it throws open before our frenzied eyes."
	special = "Use this weapon in hand to dash. Attack after a dash for an AOE."
	icon_state = "space"
	force = 22.5	//Half white, half black.
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/rapierhit.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	var/canaoe

/obj/item/ego_weapon/space/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/space/attack_self(mob/living/carbon/user)
	if(!CanUseEgo(user))
		return
	var/dodgelanding
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)

	//Nullcatch (should never happen)
	if(!dodgelanding)
		return

	icon_state = "space_aoe"
	update_icon_state()
	user.density = FALSE
	user.adjustStaminaLoss(15, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = FALSE) // This still collides with people, by the way.
	canaoe = TRUE
	sleep(3)
	user.density = TRUE

/obj/item/ego_weapon/space/attack(mob/living/target, mob/living/user)
	..()
	if(!CanUseEgo(user))
		return
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	var/damage = force * justicemod * force_multiplier
	target.deal_damage(damage, BLACK_DAMAGE, user, attack_type = (ATTACK_TYPE_MELEE))

	if(!canaoe)
		return
	if(do_after(user, 5, src, IGNORE_USER_LOC_CHANGE))
		playsound(src, 'sound/weapons/rapierhit.ogg', 100, FALSE, 4)
		for(var/turf/T in orange(2, user))
			new /obj/effect/temp_visual/smash_effect(T)

		for(var/mob/living/L in range(2, user))
			var/aoe = 15
			aoe*=justicemod
			aoe*=force_multiplier
			if(L == user || ishuman(L))
				continue
			L.deal_damage(aoe, BLACK_DAMAGE, user, attack_type = (ATTACK_TYPE_SPECIAL))
			L.deal_damage(aoe, WHITE_DAMAGE, user, attack_type = (ATTACK_TYPE_SPECIAL))
	icon_state = "space"
	update_icon_state()
	canaoe = FALSE

/obj/item/ego_weapon/space/EgoAttackInfo(mob/user)
	if(force_multiplier != 1)
		return span_notice("It deals [round((force * 2) * force_multiplier)] white and black damage combined. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [force * 2] white and black damage combined.")

/obj/item/ego_weapon/seasons
	name = "Seasons Greetings"
	desc = "If you are reading this let a developer know."
	special = "This E.G.O. will transform to match the seasons."
	icon_state = "spring"
	force = 40
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs")
	attack_verb_simple = list("poke", "jab")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	var/current_season = "winter"
	var/mob/current_holder
	var/list/season_list = list(
		"spring" = list(40, 1, 1, list("bashes", "bludgeons"), list("bash", "bludgeon"), 'sound/weapons/fixer/generic/gen1.ogg', "vernal equinox", WHITE_DAMAGE, WHITE_DAMAGE,
		"A gigantic, thorny bouquet of roses."),
		"summer" = list(60, 1.6, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/abnormalities/seasons/summer_attack.ogg', "summer solstice", RED_DAMAGE, RED_DAMAGE,
		"Looks some sort of axe or bladed mace. An unbearable amount of heat comes off of it."),
		"fall" = list(50, 1.2, 1, list("crushes", "burns"), list("crush", "burn"), 'sound/abnormalities/seasons/fall_attack.ogg', "autumnal equinox",BLACK_DAMAGE ,BLACK_DAMAGE,
		"In nature, a light is often used as a simple but effective lure. This weapon follows the same premise."),
		"winter" = list(40, 1, 2, list("skewers", "jabs"), list("skewer", "jab"), 'sound/abnormalities/seasons/winter_attack.ogg', "winter solstice",PALE_DAMAGE ,PALE_DAMAGE,
		"This odd weapon is akin to the biting cold of the north.")
		)
	var/transforming = TRUE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/seasons/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	RegisterSignal(SSdcs, COMSIG_GLOB_SEASON_CHANGE, PROC_REF(Transform))
	Transform()

/obj/item/ego_weapon/seasons/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/seasons/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/seasons/attack_self(mob/user)
	..()
	if(transforming)
		to_chat(user,span_warning("[src] will no longer transform to match the seasons."))
		transforming = FALSE
		special = "This E.G.O. will not transform to match the seasons."
		return
	if(!transforming)
		to_chat(user,span_warning("[src] will now transform to match the seasons."))
		transforming = TRUE
		special = "This E.G.O. will transform to match the seasons."
		return

/obj/item/ego_weapon/seasons/proc/Transform()
	if(!transforming)
		return
	current_season = SSlobotomy_events.current_season
	icon_state = current_season
	if(current_season == "summer")
		knockback = KNOCKBACK_LIGHT
		lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
		righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
		inhand_x_dimension = 64
		inhand_y_dimension = 64
	else
		knockback = FALSE
		lefthand_file = 'icons/mob/inhands/weapons/ego_lefthand.dmi'
		righthand_file = 'icons/mob/inhands/weapons/ego_righthand.dmi'
		inhand_x_dimension = 32
		inhand_y_dimension = 32
	update_icon_state()
	if(current_holder)
		to_chat(current_holder,span_notice("[src] suddenly transforms!"))
		current_holder.update_inv_hands()
		playsound(current_holder, "sound/abnormalities/seasons/[current_season]_change.ogg", 50, FALSE)
	force = season_list[current_season][1]
	attack_speed = season_list[current_season][2]
	reach = season_list[current_season][3]
	if(reach > 1)
		stuntime = 5
		swingstyle = WEAPONSWING_THRUST
	else
		stuntime = 0
		swingstyle = WEAPONSWING_SMALLSWEEP
	attack_verb_continuous = season_list[current_season][4]
	attack_verb_simple = season_list[current_season][5]
	hitsound = season_list[current_season][6]
	name = season_list[current_season][7]
	damtype = season_list[current_season][8]
	desc = season_list[current_season][10]

/obj/item/ego_weapon/seasons/get_clamped_volume()
	return 40

/obj/item/ego_weapon/farmwatch
	name = "farmwatch"
	desc = "What use is technology that cannot change the world?"
	special = "Activate this weapon in your hand to plant 4 trees of desire. Killing them with this weapon restores HP and sanity."
	icon_state = "farmwatch"
	force = 50
	attack_speed = 1.3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts", "reaps")
	attack_verb_simple = list("slash", "slice", "rip", "cut", "reap")
	hitsound = 'sound/weapons/ego/farmwatch.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/ability_cooldown
	var/ability_cooldown_time = 20 SECONDS

/obj/item/ego_weapon/farmwatch/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(istype(target, /mob/living/simple_animal/hostile/farmwatch_plant))
		if (force <= (initial(force) * 2))
			force += 25//this is a bit over one half of 50. Keeps nice whole numbers on examine text
		playsound(src, 'sound/weapons/ego/farmwatch_tree.ogg', 200, 1)
		user.adjustBruteLoss(-8)
		user.adjustSanityLoss(-12)
		to_chat(user, span_notice("You reap the fruits of your labor!"))
		..()
		return
	..()
	force = initial(force)

/obj/item/ego_weapon/farmwatch/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(ability_cooldown > world.time)
		to_chat(user, span_warning("You have used this ability too recently!"))
		return
	playsound(src, 'sound/effects/ordeals/white/white_reflect.ogg', 50, TRUE)
	to_chat(user, "You cultivate seeds of desires.")
	ability_cooldown = world.time + ability_cooldown_time
	spawn_plant(user, EAST, NORTH)
	spawn_plant(user, WEST, NORTH)
	spawn_plant(user, EAST, SOUTH)
	spawn_plant(user, WEST, SOUTH)
	..()

/obj/item/ego_weapon/farmwatch/proc/spawn_plant(mob/user, dir1, dir2)
	var/turf/T = get_turf(user)
	T = get_ranged_target_turf(T, dir1, 2)//spawns one spicebush plant 2 tiles away in each corner
	T = get_ranged_target_turf(T, dir2, 2)
	new /mob/living/simple_animal/hostile/farmwatch_plant(get_turf(T))//mob located at ability_types/realized.dm

/obj/item/ego_weapon/spicebush//TODO: actually code this
	name = "spicebush"
	desc = "and the scent of the grave was in full bloom."
	special = "Activate this weapon in your hand to plant 4 soon-to-bloom flowers. While fragile, they will restore the HP and sanity of nearby humans."
	icon_state = "spicebush"
	worn_icon = 'icons/obj/clothing/belt_overlays.dmi'
	worn_icon_state = "spicebush"
	force = 35
	reach = 2
	attack_speed = 1.2
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "pokes", "cuts", "stabs")
	attack_verb_simple = list("slash", "slice", "poke", "cut", "stab")
	hitsound = 'sound/weapons/ego/spicebush.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/ability_cooldown
	var/ability_cooldown_time = 30 SECONDS

/obj/item/ego_weapon/spicebush/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(ability_cooldown > world.time)
		to_chat(user, span_warning("You have used this ability too recently!"))
		return
	if(do_after(user, 20, src))
		playsound(src, 'sound/weapons/ego/spicebush_special.ogg', 50, FALSE)
		to_chat(user, "You plant some flower buds.")
		spawn_plant(user, EAST, NORTH)//spawns one spicebush plant 2 tiles away in each corner
		spawn_plant(user, WEST, NORTH)
		spawn_plant(user, EAST, SOUTH)
		spawn_plant(user, WEST, SOUTH)
	ability_cooldown = world.time + ability_cooldown_time
	..()

/obj/item/ego_weapon/spicebush/proc/spawn_plant(mob/user, dir1, dir2)
	var/turf/T = get_turf(user)
	T = get_ranged_target_turf(T, dir1, 2)
	T = get_ranged_target_turf(T, dir2, 2)
	new /mob/living/simple_animal/hostile/spicebush_plant(get_turf(T))//mob located at ability_types/realized.dm

/obj/item/ego_weapon/spicebush/get_clamped_volume()
	return 30

/obj/item/ego_weapon/spicebush/fan
	desc = "I will leave behind a morrow, strong and fertile like fallen petals."
	icon_state = "spicebush_2"
	reach = 1
	attack_speed = 1
	worn_icon = 'icons/obj/clothing/belt_overlays.dmi'
	worn_icon_state = "spicebush_2"
	hitsound = 'sound/weapons/slap.ogg'
	var/ranged_cooldown
	var/ranged_cooldown_time = 1 SECONDS
	var/ranged_damage = 35

/obj/item/ego_weapon/spicebush/fan/proc/ResetIcons()
	playsound(src, 'sound/weapons/ego/spicebush_openfan.ogg', 50, TRUE)
	icon_state = "spicebush_2"

/obj/item/ego_weapon/spicebush/fan/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	playsound(src, 'sound/weapons/ego/spicebush_openfan.ogg', 50, TRUE)
	icon_state = "spicebush_2a"
	addtimer(CALLBACK(src, PROC_REF(ResetIcons)), 30 SECONDS)
	..()

/obj/item/ego_weapon/spicebush/fan/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || (get_dist(user, target_turf) > 10))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/weapons/ego/spicebush_fan.ogg', 50, TRUE)
	var/damage_dealt = 0
	var/modified_damage = (ranged_damage * force_multiplier)
	if(do_after(user, 5))
		for(var/turf/open/T in range(target_turf, 1))
			new /obj/effect/temp_visual/spicebloom(T)
			for(var/mob/living/L in T.contents)
				L.deal_damage(modified_damage, WHITE_DAMAGE, user, attack_type = (ATTACK_TYPE_SPECIAL))
				if((L.stat < DEAD) && !(L.status_flags & GODMODE))
					damage_dealt += modified_damage

/obj/effect/temp_visual/spicebloom
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "spicebush"
	duration = 10

/obj/item/ego_weapon/wield/willing
	name = "the flesh is willing"
	desc = "And really nothing will stop it."
	icon_state = "willing"
	force = 40
	damtype = RED_DAMAGE
	wielded_attack_speed = 1.8
	wielded_force = 80
	should_slow = TRUE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/baton1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/wield/willing/OnWield(obj/item/source, mob/user)
	hitsound = 'sound/weapons/fixer/generic/baton2.ogg'
	knockback = KNOCKBACK_MEDIUM
	stuntime = 5
	return ..()

/obj/item/ego_weapon/wield/willing/on_unwield(obj/item/source, mob/user)
	hitsound = 'sound/weapons/fixer/generic/baton1.ogg'
	knockback = null
	stuntime = 0
	return ..()


/obj/item/ego_weapon/mockery
	name = "mockery"
	desc = "...If I earned a name, will I get to receive love and hate from you? \
	Will you remember me as that name, as someone whom you cared for?"
	special = "Use this weapon in hand to swap between forms. The sword heals some sanity on hit, the whip has higher reach, the hammer deals damage in an area, and the bat knocks back enemies."
	icon_state = "mockery_whip"
	force = 17
	attack_speed = 0.5
	reach = 3
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("lacerates", "disciplines")
	attack_verb_simple = list("lacerate", "discipline")
	hitsound = 'sound/weapons/whip.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/mob/current_holder
	var/form = "whip"
	var/list/weapon_list = list(
		"whip" = list(18, 0.5, 3, list("lacerates", "disciplines"), list("lacerate", "discipline"), 'sound/weapons/whip.ogg'),
		"sword" = list(35, 1, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/weapons/fixer/generic/blade4.ogg'),
		"hammer" = list(45, 1.4, 1, list("crushes"), list("crush"), 'sound/weapons/fixer/generic/baton2.ogg'),
		"bat" = list(60, 1.6, 1, list("bludgeons", "bashes"), list("bludgeon", "bash"), 'sound/weapons/fixer/generic/gen1.ogg')
		)

/obj/item/ego_weapon/mockery/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/mockery/attack_self(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		return
	SwitchForm(user)

/obj/item/ego_weapon/mockery/equipped(mob/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/mockery/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/mockery/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(form == "sword")
		if(!(target.status_flags & GODMODE) && target.stat != DEAD)
			var/heal_amt = force*0.12
			if(isanimal(target))
				var/mob/living/simple_animal/S = target
				if(S.damage_coeff.getCoeff(damtype) > 0)
					heal_amt *= S.damage_coeff.getCoeff(damtype)
				else
					heal_amt = 0
			user.adjustSanityLoss(-heal_amt)

	if(form != "hammer")
		return

	for(var/mob/living/L in view(2, target))
		var/aoe = 25
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		if(user.faction_check_mob(L) || L == target)
			continue
		L.deal_damage(aoe, BLACK_DAMAGE, user, attack_type = (ATTACK_TYPE_MELEE))
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

/obj/item/ego_weapon/mockery/get_clamped_volume()
	return 40

// Radial menu
/obj/item/ego_weapon/mockery/proc/SwitchForm(mob/user)
	var/list/armament_icons = list(
		"whip" = image(icon = src.icon, icon_state = "mockery_whip"),
		"sword"  = image(icon = src.icon, icon_state = "mockery_sword"),
		"hammer"  = image(icon = src.icon, icon_state = "mockery_hammer"),
		"bat"  = image(icon = src.icon, icon_state = "mockery_bat")
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, src , armament_icons, custom_check = CALLBACK(src, PROC_REF(CheckMenu), user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	form = choice
	Transform()

/obj/item/ego_weapon/mockery/proc/CheckMenu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/ego_weapon/mockery/proc/Transform()
	icon_state = "mockery_[form]"
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
	if(reach > 1)
		swingstyle = WEAPONSWING_THRUST
	else
		if(form == "sword")
			swingstyle = WEAPONSWING_LARGESWEEP
		else
			swingstyle = WEAPONSWING_SMALLSWEEP
	if(form == "bat")
		knockback = KNOCKBACK_LIGHT
	else
		knockback = null

/obj/item/ego_weapon/shield/gasharpoon
	name = "gasharpoon"
	desc = "As long as I can kill the pallid whale with my own two hands... I care not about what happens next."
	special = "Activate in your hand while wearing the corresponding suit to change forms. Each form has a unique ability; alt-click or right-click and select 'revert' to change forms again."
	icon_state = "gasharpoon"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 35
	attack_speed = 1.2
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("stabs", "jabs", "slaps", "skewers")
	attack_verb_simple = list("stab", "jab", "slap", "skewer")
	hitsound = 'sound/weapons/ego/gasharpoon_hit.ogg'
	reductions = list(60, 40, 70, 40)
	projectile_block_duration = 2 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 2 SECONDS
	block_sound = 'sound/weapons/ego/gasharpoon_queeblock.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/form
	var/mob/current_holder
	var/dodgeturf
	var/gun_cooldown
	var/gun_cooldown_time = 2 SECONDS
	var/burst_size = 5
	var/matching_armor = /obj/item/clothing/suit/armor/ego_gear/realization/gasharpoon
	var/list/weapon_list = list(
		"pip" = list(20, 1.6, 1, 'sound/weapons/ego/gasharpoon_piphit.ogg', "You burn the E.G.O of the innocent deckhand."),
		"starbuck" = list(35, 1, 1, 'sound/weapons/ego/gasharpoon_starbuckhit.ogg', "Your burn the E.G.O of your first mate."),
		"queeqeg" = list(35, 1.6, 2, 'sound/weapons/ego/gasharpoon_queehit.ogg', "You burn the E.G.O of the indominable harpooneer.")
		)

/obj/item/ego_weapon/shield/gasharpoon/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))

/obj/item/ego_weapon/shield/gasharpoon/equipped(mob/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/shield/gasharpoon/dropped(mob/user)
	. = ..()
	Revert()
	current_holder = null

/obj/item/ego_weapon/shield/gasharpoon/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(form != "pip")//pip form gets an AOE attack
		return
	for(var/mob/living/L in view(1, M))
		var/aoe = 15
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		aoe*=force_multiplier
		if(L == user || ishuman(L))
			continue
		L.deal_damage(aoe, PALE_DAMAGE, user, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

/obj/item/ego_weapon/shield/gasharpoon/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(form != "starbuck")
		return
	if(!check_suit(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		gun_cooldown = world.time + gun_cooldown_time
		for(var/i = 0 , i <= burst_size, i++)
			var/obj/projectile/ego_bullet/gasharpoon/G = new /obj/projectile/ego_bullet/gasharpoon(proj_turf)
			G.fired_from = src //for signal check
			playsound(user, 'sound/weapons/ego/gasharpoon_fire.ogg', 100, TRUE)
			G.firer = user
			var/spread = rand(-25,25)
			G.preparePixelProjectile(target, user, clickparams, spread)
			G.fire()
			sleep(0.1 SECONDS)
		return

/obj/item/ego_weapon/shield/gasharpoon/attack_self(mob/living/carbon/user)
	if(!CanUseEgo(user))
		return
	if(!check_suit(user))
		return
	if(!form)
		SwitchForm(user)
		return
	if(form == "pip")//better bloodbath dodge
		switch(user.dir)
			if(NORTH)
				dodgeturf = locate(user.x, user.y + 5, user.z)
			if(SOUTH)
				dodgeturf = locate(user.x, user.y - 5, user.z)
			if(EAST)
				dodgeturf = locate(user.x + 5, user.y, user.z)
			if(WEST)
				dodgeturf = locate(user.x - 5, user.y, user.z)
		user.adjustStaminaLoss(5, TRUE, TRUE)
		user.throw_at(dodgeturf, 3, 2, spin = TRUE)
	if(form == "queeqeg")
		..()//NOW you can use the shield

#define STATUS_EFFECT_PALLIDNOISE /datum/status_effect/stacking/pallid_noise//located in debuffs.dm

/obj/item/ego_weapon/shield/gasharpoon/AnnounceBlock(mob/living/carbon/user)//block
	..()
	var/aoe = 3
	var/userfort = (get_modified_attribute_level(user, FORTITUDE_ATTRIBUTE))
	var/fortmod = 1 + userfort/100
	aoe*=fortmod
	aoe*=force_multiplier
	for(var/turf/T in view(1, user))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in view(1, user))
		if(L == user || ishuman(L))
			continue
		L.deal_damage(aoe, PALE_DAMAGE, user, attack_type = (ATTACK_TYPE_COUNTER | ATTACK_TYPE_SPECIAL))
		var/datum/status_effect/stacking/pallid_noise/P = L.has_status_effect(/datum/status_effect/stacking/pallid_noise)
		if(!P)
			L.apply_status_effect(STATUS_EFFECT_PALLIDNOISE)
			return
		P.add_stacks(1)

#undef STATUS_EFFECT_PALLIDNOISE

// Radial menu
/obj/item/ego_weapon/shield/gasharpoon/proc/SwitchForm(mob/user)
	var/list/armament_icons = list(
		"pip" = image(icon = src.icon, icon_state = "gasharpoon_pip"),
		"starbuck"  = image(icon = src.icon, icon_state = "gasharpoon_starbuck"),
		"queeqeg"  = image(icon = src.icon, icon_state = "gasharpoon_queeqeg")
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, src , armament_icons, custom_check = CALLBACK(src, PROC_REF(CheckMenu), user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	form = choice
	Transform()

/obj/item/ego_weapon/shield/gasharpoon/proc/CheckMenu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/ego_weapon/shield/gasharpoon/proc/Transform()
	icon_state = "gasharpoon_[form]"
	update_icon_state()
	if(current_holder)
		current_holder.update_inv_hands()
		current_holder.playsound_local(current_holder, 'sound/weapons/ego/gasharpoon_transform.ogg', 75, FALSE)
	force = weapon_list[form][1]
	attack_speed = weapon_list[form][2]
	reach = weapon_list[form][3]
	hitsound = weapon_list[form][4]
	to_chat(current_holder, span_notice(weapon_list[form][5]))

/obj/item/ego_weapon/shield/gasharpoon/proc/Revert()
	if(!form)//is it not transformed?
		return
	form = initial(form)
	icon_state = initial(icon_state)
	update_icon_state()
	force = initial(force)
	attack_speed = initial(attack_speed)
	reach = initial(reach)
	hitsound = initial(hitsound)
	if(current_holder)
		to_chat(current_holder,span_notice("[src] returns to its original shape."))
		current_holder.update_inv_hands()
		current_holder.playsound_local(current_holder, 'sound/weapons/ego/gasharpoon_transform.ogg', 75, FALSE)

/obj/item/ego_weapon/shield/gasharpoon/verb/Toggle()//this is just a verb that calls Revert. Verbs appear in the right-click drop-down menu
	set name = "Revert"
	set category = "Object"
	return Revert()

/obj/item/ego_weapon/shield/gasharpoon/AltClick(mob/user)
	..()
	return Revert()

/obj/item/ego_weapon/shield/gasharpoon/get_clamped_volume()
	return 40


/obj/item/ego_weapon/shield/gasharpoon/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE

/obj/item/ego_weapon/shield/gasharpoon/proc/check_suit(mob/living/carbon/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/gasharpoon/P = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(P, matching_armor))
		Revert()
		to_chat(current_holder,span_notice("[src] appears unable to release its full potential."))
		return FALSE
	return TRUE

/obj/projectile/ego_bullet/gasharpoon
	name = "harpoon"
	icon_state = "gasharpoon"
	damage = 15
	damage_type = PALE_DAMAGE
	hitsound = "sound/weapons/ego/gasharpoon_bullet_impact.ogg"

/obj/item/ego_weapon/wield/darkcarnival
	name = "dark carnival"
	desc = "Get ready! I'm comin' to get ya!"
	icon_state = "dark_carnival"
	special = "This weapon deals RED damage when wielded and WHITE otherwise."
	swingstyle = WEAPONSWING_LARGESWEEP
	icon_state = "dark_carnival"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 45
	damtype = WHITE_DAMAGE
	wielded_attack_speed = 0.5
	wielded_reach = 2
	wielded_force = 27
	attack_speed = 1.2
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/abnormalities/clownsmiling/egoslash.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

	var/dash_cooldown
	var/dash_cooldown_time = 4 SECONDS
	var/dash_range = 6

/obj/item/ego_weapon/wield/darkcarnival/OnWield(obj/item/source, mob/user)
	damtype = RED_DAMAGE
	hitsound = 'sound/abnormalities/clownsmiling/egostab.ogg'
	icon_state = "dark_carnival_open"
	stuntime = 3
	swingstyle = WEAPONSWING_THRUST
	return ..()

/obj/item/ego_weapon/wield/darkcarnival/on_unwield(obj/item/source, mob/user)
	damtype = WHITE_DAMAGE
	hitsound = 'sound/abnormalities/clownsmiling/egoslash.ogg'
	icon_state = "dark_carnival"
	stuntime = 0
	swingstyle = WEAPONSWING_LARGESWEEP
	return ..()

/obj/item/ego_weapon/wield/darkcarnival/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your dash is still recharging!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		A.attackby(src,user)
	playsound(src, 'sound/abnormalities/clownsmiling/jumpscare.ogg', 50, FALSE, 9)
	to_chat(user, "<span class='warning'>You dash to [A]!")
