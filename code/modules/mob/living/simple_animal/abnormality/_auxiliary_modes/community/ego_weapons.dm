// ZAYIN
/obj/item/ego_weapon/support/dragon_staff
	name = "dragon's staff"
	desc = "A staff built from stained wood tipped with a strange, twisted skull. It reminds you of the the tall tales a father would tell."
	special = "Use this weapon in your hand when wearing matching armor to shield nearby humans. The shield's health scales with your prudence."
	icon_state = "dragon_staff"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_lefthand.dmi'
	righthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_righthand.dmi'
	force = 6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("bashes", "whacks", "smacks")
	attack_verb_simple = list("bash", "whack", "smack")
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/dragon_staff
	ability_cooldown_time = 30 SECONDS
	use_message = "You prepare a protective spell!"
	var/inuse
	var/effect
	var/shield_time = 15 SECONDS

/obj/item/ego_weapon/support/dragon_staff/attack_self(mob/user)
	if(inuse)
		return
	return ..()

/obj/item/ego_weapon/support/dragon_staff/Pulse(mob/living/carbon/human/user)
	AdjustCircle(user)
	inuse = TRUE
	if(!do_after(user, 12, src))
		if(effect)
			qdel(effect)
		ability_cooldown = world.time//hacky as hell fix but it works
		inuse = FALSE
		to_chat(user, span_notice("You stop casting the spell."))
		return
	inuse = FALSE
	ability_cooldown = world.time + ability_cooldown_time
	playsound(user, 'sound/abnormalities/faelantern/faelantern_breach.ogg', 100)
	user.visible_message(span_warning("[user] casts MASS BARKSKIN!"),span_warning("You casts MASS BARKSKIN!"), null, COMBAT_MESSAGE_RANGE, user)
	var/shield_hp = 10 + (max(10, get_attribute_level(user, PRUDENCE_ATTRIBUTE)/2))//20-75 shield hp
	for(var/mob/living/carbon/human/L in livinginview(8, user))
		if((!ishuman(L)) || L.stat == DEAD)
			continue
		L.apply_shield(/datum/status_effect/interventionshield/perfect, shield_health = shield_hp, shield_duration = shield_time)

/obj/item/ego_weapon/support/dragon_staff/proc/AdjustCircle(mob/living/carbon/human/user)
	playsound(user, 'sound/abnormalities/hatredqueen/attack.ogg', 100)
	var/obj/effect/dragon_circle/S = new(get_turf(src))
	effect = S
	QDEL_IN(S, 1.2 SECONDS)
	var/matrix/M = matrix(S.transform)
	M.Translate(-8, 0)
	if(user.dir != SOUTH)
		S.layer -= 0.2
	switch(user.dir)
		if(EAST)
			M.Scale(0.5, 1)
			M.Translate(12, -8)
		if(WEST)
			M.Scale(0.5, 1)
			M.Translate(-20, -8)
		if(SOUTH)
			M.Translate(0, -8)
	S.transform = M

// TETH

// HE
/obj/item/ego_weapon/security_ego
	name = "security"
	desc = "Those who would give up essential liberty, to purchase a little temporary safety, deserve neither liberty nor safety."
	icon_state = "security"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_lefthand.dmi'
	righthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_righthand.dmi'
	force = 16
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "jabs", "smacks")
	attack_verb_simple = list("bash", "jab", "smack")
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)
	charge = TRUE
	charge_cost = 2
	allow_ability_cancel = FALSE
	ability_type = ABILITY_ON_ACTIVATION
	charge_effect = "Scan the location of all nearby mobs for 1 second."
	failed_activation = "You press the button of your weapon, but nothing happens."
	successfull_activation = "You scan your surroundings."

/obj/item/ego_weapon/security_ego/ChargeAttack(mob/living/target, mob/living/user)
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	Scan(user)

/obj/item/ego_weapon/security_ego/proc/Scan(mob/living/user)
	user.apply_status_effect(/datum/status_effect/display/glimpse_thermal)

//WAW
/obj/item/ego_weapon/gleaming
	name = "incandescent gleaming"
	desc = "Goodness gracious, great mauls of fire!"
	special = "Use in hand to prepare a powerful area attack. This attack requires charge to use, but deals armor-piercing burn damage."
	icon_state = "gleaming"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 37
	attack_speed = 1.6
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE
	hitsound = 'sound/abnormalities/seasons/fall_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

	charge = TRUE
	ability_type = ABILITY_ON_ACTIVATION
	charge_cost = 3
	charge_cap = 6
	allow_ability_cancel = FALSE
	charge_effect = "Perform a powerful area attack."
	successfull_activation = "You release your charge!"
	var/can_spin = TRUE
	var/spinning = FALSE
	var/aoe_damage = 37
	var/aoe_size = 2
	var/wide_slash_angle = 290
	var/current_orientation = 1

/obj/item/ego_weapon/gleaming/proc/spin_reset()
	can_spin = TRUE

/obj/item/ego_weapon/gleaming/attack(mob/living/target, mob/living/user)
	if(spinning)
		return FALSE
	..()
	if(charge_amount == charge_cost || charge_amount == charge_cap)//audio cue for when you have enough charge
		playsound(src, 'sound/abnormalities/seasons/old_fall_attack.ogg', 25, TRUE)
	can_spin = FALSE
	addtimer(CALLBACK(src, PROC_REF(spin_reset)), 12)

/obj/item/ego_weapon/gleaming/attack_self(mob/living/user)
	if(!charge || !CanUseEgo(user))
		return ..()
	if(charge_amount >= charge_cost)
		ChargeAttack(user = user)
		return
	return ..()

/obj/item/ego_weapon/gleaming/ChargeAttack(mob/living/target, mob/living/user)
	if(!can_spin)
		to_chat(user,span_warning("You attacked too recently."))
		return
	if(do_after(user, 8, src))
		charge_amount -= charge_cost
		addtimer(CALLBACK(src, PROC_REF(spin_reset)), 12)
		playsound(src, 'sound/abnormalities/seasons/summer_attack.ogg', 75, FALSE, 4)
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe_damage = (force * justicemod)
		addtimer(CALLBACK(src, PROC_REF(WideSlash), user), 1)

/obj/item/ego_weapon/gleaming/proc/WideSlash(mob/living/carbon/human/user)
	var/turf/TT = get_turf(get_step(user, user.dir))
	var/turf/T = get_turf(src)
	current_orientation = -current_orientation // Makes it so AOE is flipped each time
	var/rotate_dir = current_orientation
	var/angle_to_target = Get_Angle(T, TT)
	var/angle = angle_to_target + (wide_slash_angle * rotate_dir) * 0.5
	if(angle > 360)
		angle -= 360
	else if(angle < 0)
		angle += 360
	var/turf/T2 = get_turf_in_angle(angle, T, aoe_size)
	var/list/line = getline(T, T2)
	for(var/i = 1 to 20)
		angle += ((wide_slash_angle / 20) * rotate_dir)
		if(angle > 360)
			angle -= 360
		else if(angle < 0)
			angle += 360
		T2 = get_turf_in_angle(angle, T, aoe_size)
		line = getline(T, T2)
		addtimer(CALLBACK(src, PROC_REF(DoLineAttack), line, TT, user), i * 0.12)

/obj/item/ego_weapon/gleaming/proc/DoLineAttack(list/line, atom/target, mob/living/carbon/human/user)
	var/list/been_hit = list()
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/smash_effect) in T)
			continue
		playsound(T, 'sound/weapons/fixer/generic/fire3.ogg', 30, TRUE, 3)
		new /obj/effect/temp_visual/smash_effect(T)
		new /obj/effect/temp_visual/fire/fast(T)
		been_hit = user.HurtInTurf(T, been_hit, aoe_damage, FIRE, check_faction = TRUE)

/obj/item/ego_weapon/gleaming/get_clamped_volume()
	return 40

/obj/item/ego_weapon/furrows
	name = "furrows"
	desc = "A rusty pick-mattock caked in mud. Its texture is heavily decayed, as if it had been buried for a long time."
	icon_state = "furrows"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_lefthand.dmi'
	righthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_righthand.dmi'
	force = 24
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "jabs", "picks", "impales", "spikes")
	attack_verb_simple = list("bash", "jab", "pick", "impale", "spike")
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'
	usesound = 'sound/effects/picaxe1.ogg'
	toolspeed = 0.1
	tool_behaviour = TOOL_MINING
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//ALEPH
//Waxen Pinion
/obj/item/ego_weapon/shield/waxen
	name = "Waxen Pinion"
	desc = "A searing blade, setting the world ablaze to eradicate evil. \
			Using this E.G.O will eventually reduce you to ashes."
	special = "Activate again during block to perform Blazing Strike. This weapon becomes stronger the more burn stacks you have."
	icon_state = "combust"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	worn_icon = 'icons/obj/clothing/belt_overlays.dmi'
	worn_icon_state = "combust"
	force = 40 // Quite high with passive buffs, but deals pure damage to yourself
	attack_speed = 0.8
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "stabs", "scorches")
	attack_verb_simple = list("slash", "stab", "scorch")
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
	var/special_damage = 54
	var/special_cooldown
	var/special_cooldown_time = 10 SECONDS
	var/special_checks_faction = TRUE
	var/burn_self = 2
	var/burn_enemy = 2
	var/burn_stack = 0

/obj/item/ego_weapon/shield/waxen/proc/Check_Ego(mob/living/user)
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

/obj/item/ego_weapon/shield/waxen/proc/Check_Burn(mob/living/user)
	var/datum/status_effect/stacking/lc_burn/B = user.has_status_effect(/datum/status_effect/stacking/lc_burn)
	if(B)
		burn_stack = B.stacks
	else
		burn_stack = 0
	force = (40 + round(burn_stack/2))
	burn_enemy = burn_enemy + round(burn_stack/10)

/obj/item/ego_weapon/shield/waxen/CanUseEgo(mob/living/user)
	. = ..()
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot use [src] with only one hand!"))
		return FALSE

/obj/item/ego_weapon/shield/waxen/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	Check_Ego(user)
	Check_Burn(user)

	if (block && !special_attack && special_cooldown < world.time)
		special_attack = TRUE
		to_chat(user, span_notice("You prepare to perform a blazing strike."))
	..()

// Counter
/obj/item/ego_weapon/shield/waxen/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	source.apply_lc_burn(2)
	for(var/turf/T in view(1, source))
		new /obj/effect/temp_visual/fire/fast(T)
		for(var/mob/living/L in T)
			if(L == source)
				continue
			if(special_checks_faction && source.faction_check_mob(L))
				continue
			L.apply_damage(10, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			L.apply_lc_burn(2)
	..()

/obj/item/ego_weapon/shield/waxen/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	Check_Ego(user)
	Check_Burn(user)
	..()
	user.apply_lc_burn(burn_self)
	if(user != target)
		target.apply_lc_burn(burn_enemy)

// Blazing Strike
/obj/item/ego_weapon/shield/waxen/afterattack(atom/A, mob/living/user, proximity_flag, params)
	..()
	if(!CanUseEgo(user))
		return
	if(!special_attack)
		return

	special_attack = FALSE
	special_cooldown = world.time + special_cooldown_time

	Check_Burn(user)
	var/extra_damage = 5 // Extra damage each 10 stacks, maxed at 320
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

/obj/item/ego_weapon/wield/ochre
	name = "ochre sheet"
	desc = "Everyone says its a myth until one day something happens that brings it back to life."
	special = "This weapon can fire a damaging projectile that scales with justice when held with both hands."
	icon_state = "ochre"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 32
	wielded_force = 32
	reach = 2		//Has 2 Square Reach.
	wielded_reach = 2
	attack_speed = 0.9
	wielded_attack_speed = 0.9
	stuntime = 3	//Longer reach, gives you a short stun.
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/fixer/generic/blade5.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)
	var/firing_cooldown = 0
	var/firing_cooldown_time = 1 SECONDS

/obj/item/ego_weapon/wield/ochre/OnWield(obj/item/source, mob/user)
	icon_state = "ochre_wielded"
	return ..()

/obj/item/ego_weapon/wield/ochre/on_unwield(obj/item/source, mob/user)
	icon_state = "ochre"
	return ..()

/obj/item/ego_weapon/wield/ochre/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!wielded)
		return
	if(!CanUseEgo(user))
		return
	if((get_dist(user,target)) < reach)
		return
	..()
	var/turf/proj_turf = user.loc
	if(!isturf(proj_turf))
		return
	if(world.time >= user.next_click) //important - prevents comboing
		return
	if(firing_cooldown >= world.time)
		to_chat(user, span_notice("[src] is not ready to fire!"))
		return
	var/obj/projectile/ego_bullet/ochre/G = new /obj/projectile/ego_bullet/ochre(proj_turf)
	G.fired_from = src //for signal check
	playsound(user, 'sound/weapons/fixer/generic/dodge.ogg', 100, TRUE)
	G.firer = user
	G.preparePixelProjectile(target, user, clickparams)
	G.fire()
	G.damage*=force_multiplier
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	G.damage*=justicemod
	firing_cooldown = firing_cooldown_time + world.time
	user.changeNext_move(CLICK_CD_MELEE * attack_speed)
	user.Immobilize(stuntime)
	//Visual stuff to give you better feedback
	new /obj/effect/temp_visual/weapon_stun(get_turf(user))

/obj/projectile/ego_bullet/ochre
	name = "ochre sheet"
	icon_state = "ochre"
	damage = 40
	damage_type = RED_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/nail2.ogg'

/obj/item/ego_weapon/lance/miasma
	name = "miasma skin"
	desc = "We human beings would have been wiped out a long time ago. \
	Either the monsters would have gotten us or we would have killed each other off with greed and jealousy and anger."
	special = "This lance randomly spews out caustic venom when charging."
	icon_state = "miasma"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 76
	reach = 2		//Has 2 Square Reach.
	stuntime = 6	//Longer reach, gives you a short stun.
	attack_speed = 1.8// really slow
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("stabs", "impales", "skewers", "shishkababs")
	attack_verb_simple = list("stab", "impale", "skewer")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	charge_speed_cap = 3 //Charges slower, weaker overall while charging, dealing less damage at a full charge. But it has an AOE!
	force_per_tile = 2
	pierce_force_cost = 15
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/lance/miasma/UserMoved(mob/user)
	..()
	if(raised)
		return
	if(!(charge_speed <= -(charge_speed_cap / 2)))
		return
	if(prob(75))
		new /obj/effect/gibspawner/generic/silent/liquid_miasma(get_turf(src))

/obj/item/ego_weapon/lance/miasma/UserBump(mob/living/carbon/human/user, atom/A)
	. = ..()
	if(charge_speed <= -(charge_speed_cap / 2)) //At a decent charge level, it'll do this once.
		charge_speed += (2 * pierce_speed_cost)
		if(isliving(A))
			VenomBlast(user, A)

/obj/item/ego_weapon/lance/miasma/proc/VenomBlast(mob/living/carbon/human/user, mob/target)
	playsound(target, 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 80, TRUE, -3) //yes im reusing a sound bite me
	var/damage_dealt = force
	damage_dealt*=force_multiplier
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	damage_dealt*=justicemod
	for(var/turf/T in view(1, target))
		var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
		FX.color = "#96BB00"
		user.HurtInTurf(T, list(), damage_dealt, BLACK_DAMAGE, check_faction = TRUE)
	return

/obj/effect/decal/cleanable/liquid_miasma
	name = "Caustic Venom"
	desc = "A yucky, nasty, no-good substance. Luckily, this one seems harmless."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "wrath_acid"
	random_icon_states = list("wrath_acid")
	mergeable_decal = FALSE
	color = "#96BB00"
	var/duration = 15 SECONDS
	var/delling = FALSE
	var/damage_dealt = 30

/obj/effect/decal/cleanable/liquid_miasma/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	START_PROCESSING(SSobj, src)
	duration += world.time

/obj/effect/decal/cleanable/liquid_miasma/Destroy()
	if(!delling)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/liquid_miasma/process(delta_time)
	if(world.time > duration)
		Remove()

/obj/effect/decal/cleanable/liquid_miasma/proc/Remove()
	delling = TRUE
	STOP_PROCESSING(SSobj, src)
	animate(src, time = (5 SECONDS), alpha = 0)
	QDEL_IN(src, 5 SECONDS)

/obj/effect/decal/cleanable/liquid_miasma/proc/streak(list/directions, mapload=FALSE)
	set waitfor = FALSE
	var/direction = pick(directions)
	for(var/i in 0 to pick(0, 200; 1, 150; 2, 50; 3, 17; 50)) //the 3% chance of 50 steps is intentional and played for laughs.
		if (!mapload)
			sleep(2)
		if(!step_to(src, get_step(src, direction), 0))
			break
	var/turf/T = get_turf(src)
	for(var/obj/effect/decal/cleanable/wrath_acid/w in T)
		if(w != src && !QDELETED(w))
			qdel(w)

/obj/effect/decal/cleanable/liquid_miasma/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		return FALSE
	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	L.deal_damage(damage_dealt, BLACK_DAMAGE)
	new /obj/effect/temp_visual/damage_effect/black(get_turf(L))

/obj/effect/gibspawner/generic/silent/liquid_miasma
	gibtypes = list(/obj/effect/decal/cleanable/liquid_miasma)
	gibamounts = list(1)

/obj/effect/gibspawner/generic/silent/liquid_miasma/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH))
	. = ..()
	return

/obj/item/ego_weapon/mini/limos
	name = "limos"
	desc = "Food? Does it have to be human? Does it have to be mine? How am I supposed to get it?"
	special = "This weapon has a combo system. To turn off this combo system, use in hand. \
			This weapon has a fast attack speed, is capable of closing short gaps when attacking, and heals a small amount on a combo finsiher."
	icon_state = "limos"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_lefthand.dmi'
	righthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_righthand.dmi'
	force = 14 // VERY fast attacks potentially
	attack_speed = 0.6
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife4.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE
	var/dash_range = 3

/obj/item/ego_weapon/mini/limos/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,span_warning("You swap your grip, and will no longer perform a finisher."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,span_warning("You swap your grip, and will now perform a finisher."))
		combo_on =TRUE
		return

/obj/item/ego_weapon/mini/limos/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		ComboAttack(M, user)
		user.changeNext_move(CLICK_CD_MELEE * 2)
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1

/obj/item/ego_weapon/mini/limos/proc/ComboAttack(mob/living/target, mob/living/user)
	set waitfor = FALSE
	for(var/i = 1 to 4)
		sleep(2)
		if(target in view(reach,user))
			switch(i)
				if(2)
					hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
				if(3)
					hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
				if(4)
					hitsound = 'sound/effects/ordeals/crimson/noon_bite.ogg'
					force *= 1.5
					if(!(target.status_flags & GODMODE) && target.stat != DEAD)
						var/heal_amt = force*0.30
						if(isanimal(target))
							var/mob/living/simple_animal/S = target
							if(S.damage_coeff.getCoeff(damtype) > 0)
								heal_amt *= S.damage_coeff.getCoeff(damtype)
							else
								heal_amt = 0
						user.adjustBruteLoss(-heal_amt)
			playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
			user.do_attack_animation(target)
			target.attacked_by(src, user)
			log_combat(user, target, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	hitsound = initial(hitsound)
	force = initial(force)

/obj/item/ego_weapon/mini/limos/melee_attack_chain(mob/living/user, atom/target, params)
	if(!..())
		return
	if(isliving(target))
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))


/obj/item/ego_weapon/mini/limos/afterattack(atom/A, mob/living/user, proximity_flag, params)
	..()
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		A.attackby(src,user)
	playsound(src, 'sound/weapons/fixer/generic/dodge.ogg', 50, FALSE, 9)

#define STATUS_EFFECT_REND_RED /datum/status_effect/display/rend
#define STATUS_EFFECT_REND_WHITE /datum/status_effect/display/rend/white
#define STATUS_EFFECT_REND_BLACK_WEAK /datum/status_effect/display/rend/black/weak
#define STATUS_EFFECT_CRASH_CURSE /datum/status_effect/display/crash_curse

/obj/item/ego_weapon/ranged/nightmares
	name = "lucid nightmares"
	desc = "The beast was a product of fear and imagination. When I worked the courage to visit the cabin myself, nothing remained but overgrown rubble."
	special = "Activate in your hand to curse enemies with vulnerability in a small radius. Most curses apply a 10% weakness to BLACK damage, with a 20% weakness as a secondary effect. \
	The third 'crashing curse' will deal up to 200 accumulated BLACK damage if the target is hit repeatedly."
	icon_state = "nightmares"
	inhand_icon_state = "nightmares"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_weapons.dmi'
	lefthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_lefthand.dmi'
	righthand_file = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_righthand.dmi'
	force = 30
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/nightmares
	weapon_weight = WEAPON_HEAVY
	//shotsleft = 999
	fire_delay = 1
	burst_size = 5

	fire_sound = 'sound/misc/moist_impact.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 25

	attack_verb_continuous = list("bashes", "jabs", "smacks")
	attack_verb_simple = list("bash", "jab", "smack")
	hitsound = 'sound/abnormalities/clouded_monk/monk_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/cursing
	var/curse_cooldown
	var/curse_cooldown_time = 10 SECONDS
	var/list/curses = list("drowning" = STATUS_EFFECT_REND_WHITE, "chattering" = STATUS_EFFECT_REND_RED, "crashing" = /datum/status_effect/display/crash_curse)
	var/curse_damage = 45

/obj/item/ego_weapon/ranged/nightmares/afterattack(atom/target, mob/living/user, flag, params)
	if(!CanUseEgo(user))
		return
	if(!cursing)
		return ..()
	var/turf/target_turf = get_turf(target)
	if((get_dist(user, target_turf) < 2) || !(target_turf in view(10, user)))
		return ..()
	if(!istype(target_turf))
		return
	AdjustCircle(user)
	cursing = FALSE
	if(!do_after(user, 12, src))
		return
	var/curse_type = pick(curses)
	curse_cooldown = world.time + curse_cooldown_time
	playsound(target_turf, 'sound/weapons/ego/paradise_ranged.ogg', 50, TRUE)
	var/modified_damage = (curse_damage)//add a prudence mod
	new /obj/effect/nightmares_vis/evil_circle(target_turf)
	spawn(20)
		for(var/turf/open/T in range(target_turf, 2))
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in user.HurtInTurf(T, list(), modified_damage, BLACK_DAMAGE, hurt_mechs = TRUE))
				L.apply_status_effect(STATUS_EFFECT_REND_BLACK_WEAK)
				L.apply_status_effect(curses[curse_type])
		switch(curse_type)
			if("drowning")
				new /obj/effect/nightmares_vis/curse_drown(target_turf)
			if("chattering")
				new /obj/effect/nightmares_vis/curse_chatter(target_turf)
			if("crashing")
				new /obj/effect/nightmares_vis/curse_clock(target_turf)

/obj/item/ego_weapon/ranged/nightmares/attack_self(mob/user)
	shotsleft = initial(shotsleft)
	if(cursing)
		cursing = FALSE
		to_chat(user,span_notice("You will no longer attack your cursor."))
		return
	if(curse_cooldown > world.time)
		to_chat(user,span_warning("You cannot prepare a curse yet!"))
		return
	cursing = TRUE
	to_chat(user,span_notice("You will now create a 5x5 curse at your cursor."))

/obj/item/ego_weapon/ranged/nightmares/proc/AdjustCircle(mob/living/carbon/human/user)
	playsound(user, 'sound/abnormalities/hatredqueen/attack.ogg', 100)
	var/obj/effect/evil_circle/S = new(get_turf(src))
	QDEL_IN(S, 1.2 SECONDS)
	var/matrix/M = matrix(S.transform)
	M.Translate(-8, 0)
	if(user.dir != SOUTH)
		S.layer -= 0.2
	switch(user.dir)
		if(EAST)
			M.Scale(0.5, 1)
			M.Translate(12, -8)
		if(WEST)
			M.Scale(0.5, 1)
			M.Translate(-20, -8)
		if(SOUTH)
			M.Translate(0, -8)
	S.transform = M

/obj/projectile/ego_bullet/nightmares
	name = "nightmarish tooth"
	icon_state = "nightmare"
	damage = 12
	damage_type = BLACK_DAMAGE

/obj/effect/evil_circle
	name = "evil circle"
	desc = "A magical circle with exotic patterns."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "evilcircle"
	pixel_x = 8
	base_pixel_x = 8
	pixel_y = 8
	base_pixel_y = 8
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/nightmares_vis
	icon = 'ModularTegustation/Teguicons/lc13_effects.dmi'
	pixel_x = -8
	base_pixel_x = -8
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/expiry_time = 1.2 SECONDS
	var/fade_time = 0.5 SECONDS

/obj/effect/nightmares_vis/Initialize()
	..()
	QDEL_IN(src, expiry_time)
	spawn(fade_time)
		animate(src, alpha = 0, time = (expiry_time - fade_time))

/obj/effect/nightmares_vis/evil_circle
	name = "chattering curse"
	desc = "A magical circle drawn on the ground."
	icon_state = "evil_circle"
	expiry_time = 3 SECONDS
	fade_time = 1 SECONDS

/obj/effect/nightmares_vis/curse_drown
	name = "drowning curse"
	desc = "Hands arise from a dank pool."
	icon_state = "nightmare_drown"

/obj/effect/nightmares_vis/curse_chatter
	name = "chattering curse"
	desc = "Clearly it must be English."
	icon_state = "nightmare_chatter"

/obj/effect/nightmares_vis/curse_clock
	name = "crashing curse"
	desc = "This terrible magic inflicts severe pain after a delay."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "evilcircle_clock"
	pixel_x = 0
	base_pixel_x = 0

/datum/status_effect/display/crash_curse
	id = "crashing_curse"
	display_name = "evildragon"
	duration = 90
	alert_type = null
	var/max_damage = 200
	var/dam_per_hit = 10
	var/current_damage = 0

/datum/status_effect/display/crash_curse/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(stack_damage))
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(stack_damage))

/datum/status_effect/display/crash_curse/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(owner, COMSIG_ATOM_BULLET_ACT)
	if(!current_damage)//0 damage stacked
		return
	owner.apply_damage(current_damage, BLACK_DAMAGE)
	new /obj/effect/temp_visual/explosion(get_turf(owner))

/datum/status_effect/display/crash_curse/proc/stack_damage()
	SIGNAL_HANDLER

	current_damage += dam_per_hit
	if(current_damage >= max_damage)
		on_remove()
		qdel(src)

#undef STATUS_EFFECT_REND_RED
#undef STATUS_EFFECT_REND_WHITE
#undef STATUS_EFFECT_REND_BLACK_WEAK
#undef STATUS_EFFECT_CRASH_CURSE
