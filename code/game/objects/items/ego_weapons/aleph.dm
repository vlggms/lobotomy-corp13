/obj/item/ego_weapon/paradise
	name = "paradise lost"
	desc = "\"Behold: you stood at the door and knocked, and it was opened to you. \
	I come from the end, and I am here to stay for but a moment.\""
	icon_state = "paradise"
	force = 6 // Keep in mind the justice bonus
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	w_class = WEIGHT_CLASS_NORMAL
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
	var/ranged_cooldown_time = 1 SECONDS
	var/ranged_damage = 15

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
		H.adjustBruteLoss(-damage_dealt*0.25)
		H.adjustFireLoss(-damage_dealt*0.25)
		H.adjustSanityLoss(damage_dealt*0.25)

/obj/item/ego_weapon/paradise/EgoAttackInfo(mob/user)
	return "<span class='notice'>It deals [force] [damtype] damage in melee.\n\
	Use it on a distant target to perform special attack that can heal you.</span>"

/obj/item/ego_weapon/justitia
	name = "justitia"
	desc = "A sharp sword covered in bandages. It may be able to not only cut flesh but trace of sins as well."
	icon_state = "justitia"
	force = 4
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	hitsound = 'sound/weapons/ego/justitia1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 90,
							PRUDENCE_ATTRIBUTE = 90,
							TEMPERANCE_ATTRIBUTE = 90,
							JUSTICE_ATTRIBUTE = 110
							)

	var/combo = 0
	/// Maximum world.time after which combo is reset
	var/combo_time
	/// Wait time between attacks for combo to reset
	var/combo_wait = 8

/obj/item/ego_weapon/justitia/attack(mob/living/M, mob/living/user)
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(5)
			hitsound = 'sound/weapons/ego/justitia2.ogg'
			force = 6
			user.changeNext_move(CLICK_CD_MELEE * 0.5)
		if(1,4)
			hitsound = 'sound/weapons/ego/justitia3.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.3)
		if(6)
			hitsound = 'sound/weapons/ego/justitia4.ogg'
			force = 6 // Additional damage done below
			combo = -1
			user.changeNext_move(CLICK_CD_MELEE * 1.2)
			var/turf/T = get_turf(M)
			new /obj/effect/temp_visual/justitia_effect(T)
			for(var/mob/living/L in T.contents)
				if(L == user)
					continue
				if(L.stat >= DEAD)
					continue
				L.apply_damage(10, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		else
			hitsound = 'sound/weapons/ego/justitia1.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)
