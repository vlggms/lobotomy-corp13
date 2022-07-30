/obj/item/ego_weapon/paradise
	name = "paradise lost"
	desc = "\"Behold: you stood at the door and knocked, and it was opened to you. \
	I come from the end, and I am here to stay for but a moment.\""
	icon_state = "paradise"
	force = 40
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("purges", "purifies")
	attack_verb_simple = list("purge", "purify")
	hitsound = 'sound/weapons/ego/paradise.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 0.8 SECONDS
	var/ranged_damage = 40

/obj/item/ego_weapon/paradise/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if(get_dist(user, target_turf) < 2)
		return
	..()
	var/mob/living/carbon/human/H = user
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/weapons/ego/paradise_ranged.ogg', 50, TRUE)
	var/damage_dealt = 0
	for(var/turf/open/T in range(target_turf, 1))
		new /obj/effect/temp_visual/paradise_attack(T)
		for(var/mob/living/L in T.contents)
			L.apply_damage(ranged_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if((L.stat < DEAD) && !(L.status_flags & GODMODE))
				damage_dealt += ranged_damage
	if(damage_dealt > 0)
		H.adjustStaminaLoss(-damage_dealt*0.5)
		H.adjustBruteLoss(-damage_dealt*0.3)
		H.adjustFireLoss(-damage_dealt*0.3)
		H.adjustSanityLoss(damage_dealt*0.3)

/obj/item/ego_weapon/paradise/EgoAttackInfo(mob/user)
	return "<span class='notice'>It deals [force] [damtype] damage in melee.\n\
	Use it on a distant target to perform special attack that can heal you.</span>"

/obj/item/ego_weapon/justitia
	name = "justitia"
	desc = "A sharp sword covered in bandages. It may be able to not only cut flesh but trace of sins as well."
	icon_state = "justitia"
	force = 25
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
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
			for(var/mob/living/L in T.contents)
				if(L == user)
					continue
				if(L.stat >= DEAD)
					continue
				L.apply_damage(50, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		else
			hitsound = 'sound/weapons/ego/justitia1.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/da_capo
	name = "da capo"
	desc = "A scythe that swings silently and with discipline like a conductor's gestures and baton. \
	If there were a score for this song, it would be one that sings of the apocalypse."
	icon_state = "da_capo"
	force = 40 // It attacks very fast
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
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

/obj/item/ego_weapon/da_capo/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(1)
			hitsound = 'sound/weapons/ego/da_capo2.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
		if(2)
			hitsound = 'sound/weapons/ego/da_capo3.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.7)
			force *= 1.5
			combo = -1
		else
			hitsound = 'sound/weapons/ego/da_capo1.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.5)
	..()
	combo += 1
	force = initial(force)
