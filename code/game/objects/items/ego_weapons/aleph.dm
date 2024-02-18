/obj/item/ego_weapon/paradise
	name = "paradise lost"
	desc = "\"Behold: you stood at the door and knocked, and it was opened to you. \
	I come from the end, and I am here to stay for but a moment.\""
	special = "This weapon has a ranged attack."
	icon_state = "paradise"
	worn_icon_state = "paradise"
	force = 70
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
	var/ranged_cooldown
	var/ranged_cooldown_time = 0.8 SECONDS
	var/ranged_damage = 70

/obj/item/ego_weapon/paradise/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || !(target_turf in view(10, user)))
		return
	..()
	var/mob/living/carbon/human/H = user
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/weapons/ego/paradise_ranged.ogg', 50, TRUE)
	var/damage_dealt = 0
	var/modified_damage = (ranged_damage*force_multiplier)
	for(var/turf/open/T in range(target_turf, 1))
		new /obj/effect/temp_visual/paradise_attack(T)
		for(var/mob/living/L in user.HurtInTurf(T, list(), modified_damage, PALE_DAMAGE, hurt_mechs = TRUE))
			if((L.stat < DEAD) && !(L.status_flags & GODMODE))
				damage_dealt += modified_damage
	if(damage_dealt > 0)
		H.adjustStaminaLoss(-damage_dealt*0.2)
		H.adjustBruteLoss(-damage_dealt*0.1)
		H.adjustFireLoss(-damage_dealt*0.1)
		H.adjustSanityLoss(-damage_dealt*0.1)

/obj/item/ego_weapon/paradise/get_clamped_volume()
	return 40

/obj/item/ego_weapon/justitia
	name = "justitia"
	desc = "A sharp sword covered in bandages. It may be able to not only cut flesh but trace of sins as well."
	special = "This weapon has a combo system."
	icon_state = "justitia"
	force = 25
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
			user.HurtInTurf(T, list(), 50, PALE_DAMAGE)
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
	force = 40 // It attacks very fast
	attack_speed = 0.5
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
	special = "This weapon heals you on hit."
	icon_state = "mimicry"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 70
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/abnormalities/nothingthere/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/mimicry/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.15
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)
	..()

/obj/item/ego_weapon/mimicry/get_clamped_volume()
	return 40

/obj/item/ego_weapon/twilight
	name = "twilight"
	desc = "Just like how the ever-watching eyes, the scale that could measure any and all sin, \
	and the beak that could swallow everything protected the peace of the Black Forest... \
	The wielder of this armament may also bring peace as they did."
	icon_state = "twilight"
	worn_icon_state = "twilight"
	force = 35
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

/obj/item/ego_weapon/twilight/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
		damtype = damage_type
		M.attacked_by(src, user)
	damtype = initial(damtype)

/obj/item/ego_weapon/twilight/EgoAttackInfo(mob/user)
	if(force_multiplier != 1)
		return span_notice("It deals [round((force * 4) * force_multiplier)] red, white, black and pale damage combined. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [force * 4] red, white, black and pale damage combined.")

/obj/item/ego_weapon/goldrush
	name = "gold rush"
	desc = "The weapon of someone who can swing their weight around like a truck"
	special = "This weapon deals its damage after a short windup."
	icon_state = "gold_rush"
	force = 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/goldrush_damage = 140
	var/finisher_on = TRUE //this is for a subtype, it should NEVER be false on this item.
	damtype = RED_DAMAGE

//Replaces the normal attack with the gigafuck punch
/obj/item/ego_weapon/goldrush/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(!finisher_on)
		..()
		return
	if(do_after(user, 5, target))

		target.visible_message(span_danger("[user] rears up and slams into [target]!"), \
						span_userdanger("[user] punches you with everything you got!!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("You throw your entire body into this punch!"))
		goldrush_damage = force
		//I gotta regrab  justice here
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		goldrush_damage *= justicemod
		goldrush_damage *= force_multiplier

		if(ishuman(target))
			goldrush_damage = 50

		target.apply_damage(goldrush_damage, RED_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)		//MASSIVE fuckoff punch

		playsound(src, 'sound/weapons/fixer/generic/gen2.ogg', 50, TRUE)
		var/atom/throw_target = get_edge_target_turf(target, user.dir)
		if(!target.anchored)
			target.throw_at(throw_target, 2, 4, user)		//Bigass knockback. You are punching someone with a glove of GOLD
		goldrush_damage = initial(goldrush_damage)
	else
		to_chat(user, "<span class='spider'><b>Your attack was interrupted!</b></span>")
		return

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
	special = "This weapon instantly kills targets below 10% health"	//To make it more unique, if it's too strong
	icon_state = "smile"
	force = 110 //Slightly less damage, has an ability
	attack_speed = 1.6
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/smile/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	..()
	if((target.health<=target.maxHealth *0.1	|| target.stat == DEAD) && !(GODMODE in target.status_flags))	//Makes up for the lack of damage by automatically killing things under 10% HP
		target.gib()
		user.adjustBruteLoss(-user.maxHealth*0.15)	//Heal 15% HP. Moved here from the armor, because that's a nightmare to code

/obj/item/ego_weapon/smile/get_clamped_volume()
	return 50

/obj/item/ego_weapon/blooming
	name = "blooming"
	desc = "A rose is a rose, by any other name."
	special = "Use this weapon to change its damage type between red, white and pale."	//like a different rabbit knife. No black though
	icon_state = "rosered"
	force = 80 //Less damage, can swap damage type
	damtype = RED_DAMAGE
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
			force = 70 //Prefers red, you can swap to white if needed
			icon_state = "rosewhite"
		if(WHITE_DAMAGE)
			damtype = PALE_DAMAGE
			force = 50	//I'm not making this more than 40.
			icon_state = "rosepale"
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
			force = 80
			icon_state = "rosered"
	to_chat(user, span_notice("\[src] will now deal [force] [damtype] damage."))
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

/obj/item/ego_weapon/censored
	name = "CENSORED"
	desc = "(CENSORED) has the ability to (CENSORED), but this is a horrendous sight for those watching. \
			Looking at the E.G.O for more than 3 seconds will make you sick."
	special = "Using it in hand will activate its special ability. To perform this attack - click on a distant target."
	icon_state = "censored"
	worn_icon_state = "censored"
	force = 70	//there's a focus on the ranged attack here.
	damtype = BLACK_DAMAGE
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
	var/special_damage = 240
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
			L.apply_damage(modified_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

/obj/item/ego_weapon/censored/get_clamped_volume()
	return 30

/obj/item/ego_weapon/soulmate
	name = "Soulmate"
	desc = "The course of true love never did run smooth."
	special = "Hitting enemies will mark them. Hitting marked enemies will give different buffs depending on attack type."
	icon_state = "soulmate"
	force = 40
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
	..()
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
			G.damage = 90
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
	damage = 40
	damage_type = RED_DAMAGE
	icon_state = "ice_1"

/obj/item/ego_weapon/space
	name = "out of space"
	desc = "It hails from realms whose mere existence stuns the brain and numbs us with the black extra-cosmic gulfs it throws open before our frenzied eyes."
	special = "Use this weapon in hand to dash. Attack after a dash for an AOE."
	icon_state = "space"
	force = 50	//Half white, half black.
	damtype = WHITE_DAMAGE
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
	..()
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
	target.apply_damage(damage, BLACK_DAMAGE, null, target.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

	if(!canaoe)
		return
	if(do_after(user, 5, src, IGNORE_USER_LOC_CHANGE))
		playsound(src, 'sound/weapons/rapierhit.ogg', 100, FALSE, 4)
		for(var/turf/T in orange(3, user))
			new /obj/effect/temp_visual/smash_effect(T)

		for(var/mob/living/L in range(3, user))
			var/aoe = force
			aoe*=justicemod
			aoe*=force_multiplier
			if(L == user || ishuman(L))
				continue
			L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	icon_state = "space"
	update_icon_state()
	canaoe = FALSE

/obj/item/ego_weapon/space/EgoAttackInfo(mob/user)
	if(force_multiplier != 1)
		return span_notice("It deals [round(force * force_multiplier)] of both white and black damage. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [force] of both white and black damage.")

/obj/item/ego_weapon/seasons
	name = "Seasons Greetings"
	desc = "If you are reading this let a developer know."
	special = "This E.G.O. will transform to match the seasons."
	icon_state = "spring"
	force = 80
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs")
	attack_verb_simple = list("poke", "jab")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	var/current_season = "winter"
	var/mob/current_holder
	var/list/season_list = list(
		"spring" = list(80, 1, 1, list("bashes", "bludgeons"), list("bash", "bludgeon"), 'sound/weapons/fixer/generic/gen1.ogg', "vernal equinox", WHITE_DAMAGE, WHITE_DAMAGE,
		"A gigantic, thorny bouquet of roses."),
		"summer" = list(120, 1.6, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/abnormalities/seasons/summer_attack.ogg', "summer solstice", RED_DAMAGE, RED_DAMAGE,
		"Looks some sort of axe or bladed mace. An unbearable amount of heat comes off of it."),
		"fall" = list(100, 1.2, 1, list("crushes", "burns"), list("crush", "burn"), 'sound/abnormalities/seasons/fall_attack.ogg', "autumnal equinox",BLACK_DAMAGE ,BLACK_DAMAGE,
		"In nature, a light is often used as a simple but effective lure. This weapon follows the same premise."),
		"winter" = list(60, 1.2, 2, list("skewers", "jabs"), list("skewer", "jab"), 'sound/abnormalities/seasons/winter_attack.ogg', "winter solstice",PALE_DAMAGE ,PALE_DAMAGE,
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
		lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
		righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
		inhand_x_dimension = 64
		inhand_y_dimension = 64
	else
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
	attack_verb_continuous = season_list[current_season][4]
	attack_verb_simple = season_list[current_season][5]
	hitsound = season_list[current_season][6]
	name = season_list[current_season][7]
	damtype = season_list[current_season][8]
	desc = season_list[current_season][10]

/obj/item/ego_weapon/seasons/attack(mob/living/target, mob/living/user) //other forms could probably use something. Probably.
	. = ..()
	if(!.)
		return FALSE
	if(current_season == "summer")
		var/atom/throw_target = get_edge_target_turf(target, user.dir)
		if(!target.anchored)
			var/whack_speed = (prob(60) ? 1 : 4)
			target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/seasons/get_clamped_volume()
	return 40

/obj/item/ego_weapon/shield/distortion
	name = "distortion"
	desc = "The fragile human mind is fated to twist and distort."
	special = "This weapon requires two hands to use and always blocks ranged attacks."
	icon_state = "distortion"
	force = 35 //Twilight but lower in terms of damage
	attack_speed = 1.8
	damtype = RED_DAMAGE
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


/obj/item/ego_weapon/shield/distortion/EgoAttackInfo(mob/user)
	return span_notice("It deals [force * 4] red, white, black and pale damage combined.")

/obj/item/ego_weapon/shield/distortion/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
		damtype = damage_type
		target.attacked_by(src, user)
	damtype = initial(damtype)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 3 : 6)
		target.throw_at(throw_target, rand(2, 3), whack_speed, user)

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

/obj/item/ego_weapon/farmwatch
	name = "farmwatch"
	desc = "What use is technology that cannot change the world?"
	special = "Activate this weapon in your hand to plant 4 trees of desire. Killing them with this weapon restores HP and sanity."
	icon_state = "farmwatch"
	force = 84
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
			force += 22//this is a bit over one fourth of 84. Keeps nice whole numbers on examine text
		playsound(src, 'sound/weapons/ego/farmwatch_tree.ogg', 200, 1)
		user.adjustBruteLoss(-10)
		user.adjustSanityLoss(-15)
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
		return FALSE
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
	force = 70
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
		return FALSE
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
	var/ranged_damage = 70

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
				L.apply_damage(modified_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				if((L.stat < DEAD) && !(L.status_flags & GODMODE))
					damage_dealt += modified_damage

/obj/effect/temp_visual/spicebloom
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "spicebush"
	duration = 10


//temporary
/obj/item/ego_weapon/willing
	name = "the flesh is willing"
	desc = "And really nothing will stop it."
	special = "This weapon has knockback."
	icon_state = "willing"
	force = 105	//Still lower DPS
	attack_speed = 1.4
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)


/obj/item/ego_weapon/willing/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/shield/combust
	name = "Combusting Courage"
	desc = "A searing blade, setting the world ablaze to eradicate evil. \
			Using this E.G.O will eventually reduce you to ashes."
	special = "Activate again during block to perform Blazing Strike. This weapon becomes stronger the more burn stacks you have."
	icon_state = "combust"
	worn_icon = 'icons/obj/clothing/belt_overlays.dmi'
	worn_icon_state = "combust"
	force = 80 // Quite high with passive buffs, but deals pure damage to yourself
	attack_speed = 0.8
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slash", "stab", "scorch")
	attack_verb_simple = list("slashes", "stabs", "scorches")
	hitsound = 'sound/weapons/ego/burn_sword.ogg'
	reductions = list(30, 30, 30, 30) // 120 with no corresponding armor
	projectile_block_duration = 0.8 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 9 SECONDS
	block_sound = 'sound/weapons/ego/burn_guard.ogg'
	hit_message = "softened the blow by expelling some heat!"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/special_attack = FALSE
	var/special_damage = 100
	var/special_cooldown
	var/special_cooldown_time = 10 SECONDS
	var/special_checks_faction = TRUE
	var/burn_self = 2
	var/burn_enemy = 2
	var/burn_stack = 0

/obj/item/ego_weapon/shield/combust/proc/Check_Ego(mob/living/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/clothing/suit/armor/ego_gear/aleph/combust/C = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/realization/desperation/D = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(C) || istype(D))
		reductions = list(30, 50, 40, 30) // 150 with combust/desperation
		projectile_block_message = "The heat from your wing melted the projectile!"
		block_message = "You cover yourself with your wing!"
		block_cooldown_message = "You streched your wing."
		if(istype(C))
			burn_self = 3
			burn_enemy = 3
		if(istype(D))
			burn_self = 4
			burn_enemy = 4
	else
		reductions = list(30, 30, 30, 30)
		projectile_block_message ="You swat the projectile away!"
		block_message = "You attempt to parry the attack!"
		block_cooldown_message = "You rearm your blade."
		burn_self = 2
		burn_enemy = 2

/obj/item/ego_weapon/shield/combust/proc/Check_Burn(mob/living/user)
	var/datum/status_effect/stacking/lc_burn/B = user.has_status_effect(/datum/status_effect/stacking/lc_burn)
	if(B)
		burn_stack = B.stacks
	else
		burn_stack = 0
	force = (80 + round(burn_stack/2))
	burn_enemy = burn_enemy + round(burn_stack/10)

/obj/item/ego_weapon/shield/combust/CanUseEgo(mob/living/user)
	. = ..()
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot use [src] with only one hand!"))
		return FALSE

/obj/item/ego_weapon/shield/combust/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	Check_Ego(user)
	Check_Burn(user)

	if (block && !special_attack && special_cooldown < world.time)
		special_attack = TRUE
		to_chat(user, span_notice("You prepare to perform a blazing strike."))
	..()

// Counter
/obj/item/ego_weapon/shield/combust/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	source.apply_lc_burn(2)
	for(var/turf/T in view(1, source))
		new /obj/effect/temp_visual/fire/fast(T)
		for(var/mob/living/L in T)
			if(L == source)
				continue
			if(special_checks_faction && source.faction_check_mob(L))
				continue
			L.apply_damage(20, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			L.apply_lc_burn(2)
	..()

/obj/item/ego_weapon/shield/combust/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	Check_Ego(user)
	Check_Burn(user)
	..()
	user.apply_lc_burn(burn_self)
	if(user != target)
		target.apply_lc_burn(burn_enemy)

// Blazing Strike
/obj/item/ego_weapon/shield/combust/afterattack(atom/A, mob/living/user, proximity_flag, params)
	..()
	if(!CanUseEgo(user))
		return
	if(!special_attack)
		return

	special_attack = FALSE
	special_cooldown = world.time + special_cooldown_time

	Check_Burn(user)
	var/extra_damage = 10 // Extra damage each 10 stacks, maxed at 320
	for(var/i = 0, i < round(burn_stack/10), i++)
		extra_damage = extra_damage * 2

	// Movement
	var/list/been_hit = list()
	var/turf/target_turf = get_turf(user)
	var/list/line_turfs = list(target_turf)
	for(var/turf/T in getline(user, get_ranged_target_turf_direct(user, A, 6)))
		if(T.density)
			break
		for(var/obj/machinery/door/D in T.contents)
			if(D.density)
				addtimer(CALLBACK (D, TYPE_PROC_REF(/obj/machinery/door, open)))
		target_turf = T
		line_turfs += T
	user.dir = get_dir(user, A)
	user.forceMove(target_turf)
	playsound(target_turf, 'sound/abnormalities/firebird/Firebird_Hit.ogg', 50, TRUE)

	// Damage
	for(var/turf/T in line_turfs)
		for(var/turf/TF in view(1, T))
			new /obj/effect/temp_visual/fire/fast(TF)
			for(var/mob/living/L in TF)
				if(special_checks_faction && user.faction_check_mob(L))
					continue
				if(L in been_hit || L == user)
					continue
				user.visible_message(span_boldwarning("[user] blazes through [L]!"))
				L.apply_damage((special_damage + extra_damage), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				been_hit += L

	// Remove burn if it's safety is on
	var/datum/status_effect/stacking/lc_burn/B = user.has_status_effect(/datum/status_effect/stacking/lc_burn)
	if(B.safety)
		user.remove_status_effect(STATUS_EFFECT_LCBURN)

/obj/item/ego_weapon/mockery
	name = "mockery"
	desc = "...If I earned a name, will I get to receive love and hate from you? \
	Will you remember me as that name, as someone whom you cared for?"
	special = "Use this weapon in hand to swap between forms. The whip has higher reach, the hammer deals damage in an area, and the bat knocks back enemies."
	icon_state = "mockery_whip"
	force = 35
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
		"whip" = list(35, 0.5, 3, list("lacerates", "disciplines"), list("lacerate", "discipline"), 'sound/weapons/whip.ogg'),
		"sword" = list(80, 1, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/weapons/fixer/generic/blade4.ogg'),
		"hammer" = list(40, 1.4, 1, list("crushes"), list("crush"), 'sound/weapons/fixer/generic/baton2.ogg'),
		"bat" = list(120, 1.6, 1, list("bludgeons", "bashes"), list("bludgeon", "bash"), 'sound/weapons/fixer/generic/gen1.ogg')
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
		return FALSE
	switch(form)
		if("bat")
			var/atom/throw_target = get_edge_target_turf(target, user.dir)
			if(!target.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				target.throw_at(throw_target, rand(1, 2), whack_speed, user)
		if("hammer")
			for(var/mob/living/L in view(2, target))
				var/aoe = force
				var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
				var/justicemod = 1 + userjust/100
				aoe*=justicemod
				if(user.faction_check_mob(L))
					continue
				L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
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

/obj/item/ego_weapon/ultimate_christmas
	name = "ultimate christmas"
	desc = "The Santa's bag is very heavy, capable of carrying a gift for everyone in the world. This one is no exception."
	special = "This weapon has absurd knockback."
	icon_state = "ultimate_christmas"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 160
	attack_speed = 1.6
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/abnormalities/rudolta_buff/onrush1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ultimate_christmas/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		target.throw_at(throw_target, 7, 7, user)

/obj/item/ego_weapon/oberon
	name = "oberon"
	desc = "Then yes, I am the Oberon you seek."
	special = "Use this weapon in hand to swap between forms. This form has higher reach, hits 3 times, and builds up attack speed before unleasheing a powerful burst of damage."
	icon_state = "oberon_whip"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 30
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
		"whip" = list(30, 0.8, 3, list("lacerates", "disciplines"), list("lacerate", "discipline"), 'sound/weapons/whip.ogg', BLACK_DAMAGE, "This form has higher reach, hits 3 times, and builds up attack speed before unleasheing a powerful burst of damage."),
		"sword" = list(55, 0.8, 1, list("tears", "slices", "mutilates"), list("tear", "slice","mutilate"), 'sound/weapons/fixer/generic/blade4.ogg', BLACK_DAMAGE, "This form can fire a projectile and does both RED DAMAGE and BLACK DAMAGE."),
		"hammer" = list(55, 1.4, 1, list("crushes"), list("crush"), 'sound/weapons/fixer/generic/baton2.ogg', BLACK_DAMAGE, "This form deals damage in an area and incease the RED and BLACK vulnerability by 0.2 to everything in that area."),
		"bat" = list(160, 1.6, 1, list("bludgeons", "bashes"), list("bludgeon", "bash"), 'sound/weapons/fixer/generic/gen1.ogg', RED_DAMAGE, "This form does RED DAMAGE and knocks back enemies."),
		"scythe" = list(100, 1.2, 1, list("slashes", "slices", "rips", "cuts"), list("slash", "slice", "rip", "cut"), 'sound/abnormalities/nothingthere/attack.ogg', RED_DAMAGE, "This form does RED DAMAGE and does 50% more damage when hitting targets below 50% health.")
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
	switch(form)
		if("scythe")
			if(target.health <= (target.maxHealth * 0.5))
				playsound(get_turf(target), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 7)
				new /obj/effect/temp_visual/nobody_grab(get_turf(target))
				force = 150
			else
				force = 100
	. = ..()
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	if(!.)
		return FALSE
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
					target.send_item_attack_message(src, user,target)
					target.apply_damage(multihit * force_multiplier, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
					user.do_attack_animation(target)
					playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		if("bat")
			var/atom/throw_target = get_edge_target_turf(target, user.dir)
			if(!target.anchored)
				var/whack_speed = (prob(60) ? 2 : 5)
				target.throw_at(throw_target, rand(2, 4), whack_speed, user)
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
			if (isliving(target))
				user.changeNext_move(CLICK_CD_MELEE * build_up) // Starts a little fast, but....
				if (build_up <= 0.1)
					build_up = 0.8
					user.changeNext_move(CLICK_CD_MELEE * 4)
					if(!smashing)
						to_chat(user,"<span class='warning'>The whip starts to thrash around uncontrollably!</span>")
						Smash(user, target)
				else
					build_up -= 0.1
			else
				user.changeNext_move(CLICK_CD_MELEE * 0.8)

/obj/item/ego_weapon/oberon/proc/Smash(mob/user, atom/target)
	smashing = TRUE
	playsound(user, 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 50, 0, 3)
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	var/smash_damage = 170
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
				G.damage = 90
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
		to_chat(current_holder,"<span class='notice'>[src] suddenly transforms!</span>")
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
