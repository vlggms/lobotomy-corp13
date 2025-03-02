//What if a CoL butcherer became star of the city but for real?
/obj/item/ego_weapon/city/ensemble/greta
	name = "The Tenderizer"
	desc = " There’s more than enough food for everyone to feast on, but people always feel that there’s not enough ‘cause some of ‘em like their meals luxurious."
	special = "This weapon can throw meathook as ranged attack to pull in, this weapon kills weak foes instantly and heals you, can also cook corpses."
	icon_state = "Greta"
	icon = 'ModularTegustation/Teguicons/EnsembleWeaponIcon.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/EnsembleWeaponL.dmi'
	righthand_file = 'ModularTegustation/Teguicons/EnsembleWeaponR.dmi'
	force = 190
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	var/gun_cooldown
	var/blademark_cooldown
	var/gunmark_cooldown
	var/gun_cooldown_time = 1.2 SECONDS
	attack_speed = 2
	attack_verb_continuous = list("slams", "tenderizes")
	attack_verb_simple = list("smashes", "flattens")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 130,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
/obj/item/ego_weapon/city/ensemble/greta/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return


	. = ..()
	if((target.health <= target.maxHealth * 0.1 || target.stat == DEAD) && !(target.status_flags & GODMODE))	//She eats people live.
		target.gib()
		user.adjustBruteLoss(-user.maxHealth * 0.30)	//Heal 30% HP. Very funny.

/obj/item/ego_weapon/city/ensemble/greta/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/hook/G = new /obj/projectile/hook
		G.fired_from = src //for signal check
		playsound(user, 'sound/weapons/batonextend.ogg', 100, TRUE)
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/ensemble/greta/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE




// Philip goes here, this guy is a total nightmare for me to code for many reasons.
/obj/item/ego_weapon/shield/city/ensemble/philip
	name = "Combusting Courage"
	desc = "Can't a person be himself and walk down a path he chose purely on his own, without anyone else's intervention? He may seem like a nobody, but he'll ultimately gain more. \
			Using this E.G.O will eventually reduce you to ashes."
	special = "Activate again during block to perform Blazing Strike. This weapon becomes stronger the more burn stacks you have."
	icon_state = "Philip"
	icon = 'ModularTegustation/Teguicons/EnsembleWeaponIcon.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/EnsembleWeaponL.dmi'
	righthand_file = 'ModularTegustation/Teguicons/EnsembleWeaponR.dmi'
	force = 120 // Quite high with passive buffs, but deals pure damage to yourself
	attack_speed = 0.8
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "stabs", "scorches")
	attack_verb_simple = list("slash", "stab", "scorch")
	hitsound = 'sound/weapons/ego/burn_sword.ogg'
	reductions = list(30, 30, 30, 30) // 120 with no corresponding armor
	projectile_block_duration = 8 SECONDS
	block_duration = 8 SECONDS
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
	var/special_damage = 300
	var/special_cooldown
	var/special_cooldown_time = 10 SECONDS
	var/special_checks_faction = TRUE
	var/burn_self = 2
	var/burn_enemy = 2
	var/burn_stack = 0
	var/gun_cooldown
	var/blademark_cooldown
	var/gunmark_cooldown
	var/gun_cooldown_time = 1.2 SECONDS
/obj/item/ego_weapon/shield/city/ensemble/philip/proc/Check_Ego(mob/living/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/clothing/suit/armor/ego_gear/aleph/waxen/C = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/realization/desperation/D = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(C) || istype(D))
		reductions = list(30, 50, 40, 30) // 150 with waxen/desperation
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

/obj/item/ego_weapon/shield/city/ensemble/philip/proc/Check_Burn(mob/living/user)
	var/datum/status_effect/stacking/lc_burn/B = user.has_status_effect(/datum/status_effect/stacking/lc_burn)
	if(B)
		burn_stack = B.stacks
	else
		burn_stack = 0
	force = (80 + round(burn_stack/2))
	burn_enemy = burn_enemy + round(burn_stack/10)

/obj/item/ego_weapon/shield/city/ensemble/philip/CanUseEgo(mob/living/user)
	. = ..()
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot use [src] with only one hand!"))
		return FALSE

/obj/item/ego_weapon/shield/city/ensemble/philip/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	Check_Ego(user)
	Check_Burn(user)

	if (block && !special_attack && special_cooldown < world.time)
		special_attack = TRUE
		to_chat(user, span_notice("You prepare to perform a blazing strike."))
	..()

// Counter
/obj/item/ego_weapon/shield/city/ensemble/philip/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	source.apply_lc_burn(2)
	for(var/turf/T in view(1, source))
		new /obj/effect/temp_visual/fire/fast(T)
		for(var/mob/living/L in T)
			if(L == source)
				continue
			if(special_checks_faction && source.faction_check_mob(L))
				continue
			L.apply_damage(60, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			L.apply_lc_burn(2)
	..()

/obj/item/ego_weapon/shield/city/ensemble/philip/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	Check_Ego(user)
	Check_Burn(user)
	..()
	user.apply_lc_burn(burn_self)
	if(user != target)
		target.apply_lc_burn(burn_enemy)

// Blazing Strike
/obj/item/ego_weapon/shield/city/ensemble/philip/afterattack(atom/A, mob/living/user, proximity_flag, params)
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

/obj/item/ego_weapon/shield/city/ensemble/philip/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/beam/sorrow_beam/G = new /obj/projectile/beam/sorrow_beam
		G.fired_from = src //for signal check
		playsound(user, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 100, TRUE)
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/shield/city/ensemble/philip/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE
