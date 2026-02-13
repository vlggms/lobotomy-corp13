//A file for all melee weapons manufactured at L-corp that is not E.G.O.

//Contains clerk and officer weapons

///////////////////////
///OFFICER EQUIPMENT///
///////////////////////

/obj/item/ego_weapon/officer
	name = "officer weapon"
	desc = "Please contact a coder if you obtain this!"
	icon_state = "officer_blade"
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	force = 6
	var/list/allowed_roles = list("Training Officer","Disciplinary Officer", "Extraction Officer","Records Officer")//we dont want other Roles to wear this!
	var/current_holder = null
	var/current_level = 1
	var/max_level = 5
	var/list/level_to_force = list(6, 12, 18, 26, 35)
	var/extra_text = "This weapon can only be wielded by any Officer. This weapon also increases in power the more ordeals are defeated."

/obj/item/ego_weapon/officer/examine(mob/user)
	. = ..()
	. += span_notice(extra_text)

/obj/item/ego_weapon/officer/SpecialEgoCheck(mob/living/carbon/human/H)
	if(!H.mind)
		return FALSE
	if(H.mind.assigned_role in allowed_roles)
		return TRUE
	return  FALSE

/obj/item/ego_weapon/officer/Initialize()
	. = ..()
	if(SSlobotomy_corp.next_ordeal)
		current_level = min(max_level, SSlobotomy_corp.next_ordeal.level)
	refresh_stats()
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(update_stats))

/obj/item/ego_weapon/officer/proc/update_stats()
	if(current_level >= max_level)
		return
	current_level++
	if(current_holder)
		to_chat(current_holder, span_nicegreen("[src]'s damage has been increased!"))
	refresh_stats()

/obj/item/ego_weapon/officer/proc/refresh_stats()
	force = level_to_force[current_level]

/obj/item/ego_weapon/officer/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/officer/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/shield/officer
	name = "officer shield"
	desc = "Please contact a coder if you obtain this!"
	icon_state = "officer_sabre"
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	force = 20
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound_volume = 30
	var/list/allowed_roles = list("Training Officer","Disciplinary Officer", "Extraction Officer","Records Officer")//we dont want other Roles to wear this!
	var/current_holder = null
	var/current_level = 1
	var/max_level = 5
	var/list/level_to_force = list(20, 32, 46, 52, 70)
	var/list/initial_reductions = list(20,20,20,20)
	var/extra_text = "This weapon can only be wielded by any Officer. This weapon also increases in power the more ordeals are defeated."
	var/armor_increase = 10

/obj/item/ego_weapon/shield/officer/examine(mob/user)
	. = ..()
	. += span_notice(extra_text)

/obj/item/ego_weapon/shield/officer/SpecialEgoCheck(mob/living/carbon/human/H)
	if(!H.mind)
		return FALSE
	if(H.mind.assigned_role in allowed_roles)
		return TRUE
	return  FALSE

/obj/item/ego_weapon/shield/officer/Initialize()
	. = ..()
	if(SSlobotomy_corp.next_ordeal)
		current_level = min(max_level, ceil(1 + SSlobotomy_corp.ordeal_stats/5))
	refresh_stats()
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(update_stats))

/obj/item/ego_weapon/shield/officer/proc/update_stats()
	if(current_level >= max_level)
		return
	current_level++
	if(current_holder)
		to_chat(current_holder, span_nicegreen("[src]'s damage has been increased!"))
	refresh_stats()

/obj/item/ego_weapon/shield/officer/proc/refresh_stats()
	force = level_to_force[current_level]
	for(var/i = 1 to 4)
		reductions[i] = initial_reductions[i] + (armor_increase * current_level)
	if(LAZYLEN(resistances_list)) //update armor tags code
		resistances_list.Cut()
	if(reductions[1] != 0)
		resistances_list += list("RED" = reductions[1])
	if(reductions[2] != 0)
		resistances_list += list("WHITE" = reductions[2])
	if(reductions[3] != 0)
		resistances_list += list("BLACK" = reductions[3])
	if(reductions[4] != 0)
		resistances_list += list("PALE" = reductions[4])

/obj/item/ego_weapon/shield/officer/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/shield/officer/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/officer/blade
	name = "officer blade"
	desc = "A basic sword for the higher-ups of L-Corp to use incase they need to get their hands dirty. Used by all Officers "
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/blade4.ogg'
	special = "Use this weapon in hand to swap between swing styles. Blunt attacks very slow but does more damage and has knockback and Pierce attacks slower but has more reach.."
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	var/swing_style = "slash"

/obj/item/ego_weapon/officer/blade/refresh_stats()
	force = level_to_force[current_level]
	if(swing_style == "blunt")
		force = round(force * 1.4)
		knockback = KNOCKBACK_LIGHT
		if(current_level > 2)
			knockback = KNOCKBACK_MEDIUM
		else if(current_level > 4)
			knockback = KNOCKBACK_HEAVY
	else
		knockback = null

/obj/item/ego_weapon/officer/blade/attack_self(mob/user)
	. = ..()
	var/message = ""
	if(swing_style == "slash")
		message = "This weapon is now in blunt mode, and does more damage per hit and has knockback, at the cost of having lower attack speed."
		swing_style = "blunt"
		swingstyle = WEAPONSWING_SMALLSWEEP
		attack_speed = 1.6
		attack_verb_continuous = list("bashes", "clubs")
		attack_verb_simple = list("bashes", "clubs")
		hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	else if(swing_style == "blunt")
		message = "This weapon is now in peirce mode, and has extra reach at the cost of having lower attack speed."
		swingstyle = WEAPONSWING_THRUST
		swing_style = "pierce"
		reach = 2
		stuntime = 5
		attack_speed = 1.2
		attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
		attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
		hitsound = 'sound/weapons/ego/spear1.ogg'
	else if(swing_style == "pierce")
		message = "This weapon is now in slash mode, and has a faster attack speed."
		swing_style = "slash"
		attack_speed = 1
		stuntime = 0
		reach = 1
		swingstyle = WEAPONSWING_LARGESWEEP
		hitsound = 'sound/weapons/fixer/generic/blade4.ogg'
		attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
		attack_verb_simple = list("slash", "slice", "rip", "cut")
	refresh_stats()
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)
	to_chat(user, span_notice("[message]"))

/obj/item/ego_weapon/officer/discipline
	name = "officer buster sword"
	icon_state = "officer_buster"
	desc = "A bulky sword that could leave a large dent into most things. Used by the Disciplinary Officer "

	special = "Use in hand to make your next attack deal more damage."
	force = 18
	attack_speed = 2
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	level_to_force = list(18, 26, 42, 56, 80)
	allowed_roles = list("Disciplinary Officer")
	extra_text = "This weapon can only be wielded by the Disciplinary Officer. This weapon also increases in power the more ordeals are defeated."
	swingstyle = WEAPONSWING_LARGESWEEP
	var/charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack(mob/living/M, mob/living/user)
	if(charged)
		force *= 1.5
		hitsound = 'sound/abnormalities/nothingthere/goodbye_attack.ogg'
	..()
	if(charged)
		var/obj/effect/temp_visual/dir_setting/slash/s = new(get_turf(M))
		s.dir = 0
		s.layer = M.layer + 0.1
		to_chat(user, "You cleave through [M]!")
		hitsound = initial(hitsound)
		refresh_stats()
		charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack_self(mob/user)
	. = ..()
	if(!charged)
		if(do_after(user, 12, src))
			charged = TRUE
			to_chat(user,span_warning("You put your strength behind this attack."))

/obj/item/ego_weapon/officer/discipline/get_clamped_volume()
	return 50

/obj/item/ego_weapon/officer/extraction //To do Actually do something
	name = "officer ring"
	icon_state = "officer_ring"
	desc = "A black ring that can tap into a small bit of a singularity from a former G-Corp. Used by the Extraction Officer "
	force = 5
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	knockback = KNOCKBACK_MEDIUM
	attack_verb_continuous = list("punts", "bashes")
	attack_verb_simple = list("punts", "bash")
	level_to_force = list(5, 8, 12, 18, 28)
	allowed_roles = list("Extraction Officer")
	special = "This weapon has a ranged attack that will jump from targets to target.\nUse in hand to cast a shockwave that pushes back anything damaged by it."
	extra_text = "This weapon can only be wielded by the Extraction Officer. This weapon also increases in power the more ordeals are defeated."
	var/fairy_cooldown
	var/shockwave_cooldown
	var/fairy_cooldown_time = 3 SECONDS
	var/shockwave_cooldown_time = 8 SECONDS
	var/list/fairy_damage = list(15,25,40,60,100)
	var/list/shockwave_damage = list(10,20,35,50,75)
	var/charging_attack = FALSE
	var/shockwave_range = 6

/obj/item/ego_weapon/officer/extraction/attack_self(mob/living/user)
	if(!CanUseEgo(user) || charging_attack)
		return
	if(shockwave_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		charging_attack = TRUE
		playsound(user, 'sound/magic/arbiter/pillar_start.ogg', 50, TRUE)
		if(!do_after(user, 5))
			charging_attack = FALSE
			return
		charging_attack = FALSE
		var/list/turfs = circleview(proj_turf, 6)
		playsound(user, 'sound/magic/arbiter/repulse.ogg', 50, TRUE)
		for(var/i = 0 to shockwave_range)
			addtimer(CALLBACK(src, PROC_REF(shockwave), turfs,proj_turf,i, user), i)
		shockwave_cooldown = world.time + shockwave_cooldown_time
		return

/obj/item/ego_weapon/officer/extraction/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user) || charging_attack)
		return
	if(!proximity_flag && fairy_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		charging_attack = TRUE
		playsound(user, 'sound/magic/arbiter/pillar_start.ogg', 50, TRUE)
		if(!do_after(user, 3))
			charging_attack = FALSE
			return
		charging_attack = FALSE
		playsound(user, 'sound/magic/arbiter/fairy.ogg', 50, TRUE)
		fairy_cooldown = world.time + fairy_cooldown_time
		var/obj/projectile/beam/officer/F = new(proj_turf)
		F.firer = user
		F.preparePixelProjectile(target, user, clickparams)
		F.damage = fairy_damage[current_level]
		F.damage *= force_multiplier
		F.fire()
		return

/obj/item/ego_weapon/officer/extraction/proc/shockwave(list/turfs, turf/start, distance, mob/living/user)
	for(var/turf/T in turfs)
		if(get_dist_euclidian(start, T) <= distance + 0.3 && get_dist_euclidian(start, T) >= max(0,distance - 0.5))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/L in T) //knocks enemies away from you
				if(L == user || ishuman(L))
					continue
				L.apply_damage(shockwave_damage[current_level] * force_multiplier, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
				var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, start)))
				if(!L.anchored)
					var/whack_speed = 10
					L.throw_at(throw_target, 2, whack_speed, user)

/obj/item/ego_weapon/officer/extraction/refresh_stats()
	force = level_to_force[current_level]
	if(current_level > 3)
		knockback = KNOCKBACK_HEAVY

/obj/effect/projectile/tracer/laser/officer
	icon_state = "sm_arc"
	icon = 'icons/effects/beam.dmi'

/obj/projectile/beam/officer
	name = "energy blast "
	icon_state = "omnilaser"
	color = COLOR_YELLOW
	light_color = COLOR_YELLOW
	tracer_type = /obj/effect/projectile/tracer/laser/officer
	hitscan = TRUE
	speed = 0.1
	hit_stunned_targets = TRUE
	white_healing = FALSE
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB) & (~PASSCLOSEDTURF))
	hitscan_light_color_override = COLOR_YELLOW
	muzzle_flash_color_override = COLOR_YELLOW
	impact_light_color_override = COLOR_YELLOW
	wound_bonus = -100
	bare_wound_bonus = -100
	damage = 10
	range = 10 // Don't want people shooting it through the entire facility
	var/detect_range = 4

/obj/projectile/beam/officer/on_hit(atom/target, blocked = FALSE)
	if(!isliving(target))
		return
	var/mob/living/user = firer
	var/mob/living/enemy = target
	if(user.faction_check_mob(enemy))
		return
	. = ..()
	damage *= 0.8
	if(damage < 1)
		qdel(src)
		return
	for(var/mob/living/L in range(detect_range, src))
		if(user.faction_check_mob(L))
			continue
		if( L == target)
			continue
		if(L in impacted)
			continue
		if(L.stat == DEAD)
			continue
		if(L.status_flags & GODMODE)
			continue
		range = 8
		preparePixelProjectile(L, src, null)
		xo = 16
		yo = 16
		return
	qdel(src)

/obj/item/ego_weapon/shield/officer/records
	name = "officer sabre"
	desc = "An old sabre that also functions as a walking cane. Used by the Records Officer "
	special = "This weapon gives the user a speed boost while held in hand."
	force = 2
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	level_to_force = list(2, 4, 6, 9, 14)//Meant to be overall bad for dps since its both a parry weapon and a speed boost
	initial_reductions = list(20,10,10,0)
	projectile_block_duration = 0.75 SECONDS
	block_duration = 1.25 SECONDS
	block_cooldown = 3 SECONDS
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."
	slowdown = -0.3//its a walking cane
	item_flags = SLOWS_WHILE_IN_HAND
	allowed_roles = list("Records Officer")
	extra_text = "This weapon can only be wielded by the Records Officer. This weapon also increases in power the more ordeals are defeated."

///////////////////////
////AGENT EQUIPMENT////
///////////////////////

/obj/item/ego_weapon/city/lcorp
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20,
							PRUDENCE_ATTRIBUTE = 20,
							TEMPERANCE_ATTRIBUTE = 20,
							JUSTICE_ATTRIBUTE = 20
							)
	var/installed_shard
	var/equipped
	custom_price = 100
	is_city_gear = FALSE

/obj/item/ego_weapon/city/lcorp/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/ego_weapon/city/lcorp/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/ego_weapon/city/lcorp/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("You need to put down [src] before attempting this!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src] already has an egoshard installed!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/ego_weapon/city/lcorp/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	force = egoshard.base_damage //base damage
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("The requirements to equip [src] have increased!"))
	to_chat(user, span_nicegreen("[src] has been successfully improved!"))
	icon_state = "[initial(icon_state)]_[egoshard.damage_type]"

/obj/item/ego_weapon/city/lcorp/examine(mob/user)
	. = ..()
	if(!installed_shard)
		. += span_warning("This weapon can be enhanced with an egoshard.")
	else
		. += span_nicegreen("It has a [installed_shard] installed.")

/obj/item/ego_weapon/city/lcorp/baton
	name = "l-corp combat baton"
	icon_state = "baton"
	desc = "A baton issued by L-Corp to those who cannot utilize E.G.O."
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/baton1.ogg'
	force = 10
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/machete
	name = "l-corp machete"
	icon_state = "machete"
	desc = "A sharp machete issued by L-Corp to those who cannot utilize E.G.O."
	hitsound = 'sound/weapons/fixer/generic/sword2.ogg'
	force = 6
	attack_speed = 0.5
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/machete/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = floor(egoshard.base_damage * 0.6)

/obj/item/ego_weapon/city/lcorp/club
	name = "l-corp club"
	icon_state = "club"
	desc = "A heavy club issued by L-Corp to those who cannot utilize E.G.O."
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'
	force = 14 //Still less DPS, replaces baseball bat
	attack_speed = 1.6
	knockback = KNOCKBACK_LIGHT
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/club/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = floor(egoshard.base_damage * 1.4)
	if(egoshard.tier >= 3)
		knockback = KNOCKBACK_MEDIUM
	if(egoshard.tier >= 5)
		knockback = KNOCKBACK_HEAVY

/obj/item/ego_weapon/shield/lcorp_shield
	name = "l-corp shield"
	desc = "A heavy shield issued by L-Corp to those who cannot utilize E.G.O."
	special = "This weapon deals atrocious damage."
	icon_state = "shield"
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	force = 20
	damtype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(30, 0, 0, 0) // 30
	projectile_block_duration = 3 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound_volume = 30
	custom_price = 300
	var/installed_shard
	var/equipped
	attribute_requirements = list( //They need to be listed for the attributes to increase
							FORTITUDE_ATTRIBUTE = 0,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)

/obj/item/ego_weapon/shield/lcorp_shield/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/ego_weapon/shield/lcorp_shield/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/ego_weapon/shield/lcorp_shield/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("You need to put down [src] before attempting this!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src] already has an egoshard installed!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/ego_weapon/shield/lcorp_shield/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	force = floor(egoshard.base_damage * 2) //2* base damage, 3 attack speed for shields
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("The requirements to equip [src] have increased!"))
	var/list/new_armor_values = list( //Same as armor, +20 from armor's base 2 in red
		egoshard.red_bonus + 20,
		egoshard.white_bonus,
		egoshard.black_bonus,
		egoshard.pale_bonus
	)
	reductions =  new_armor_values.Copy()
	if(LAZYLEN(resistances_list)) //armor tags code
		resistances_list.Cut()
	if(reductions[1] != 0)
		resistances_list += list("RED" = reductions[1])
	if(reductions[2] != 0)
		resistances_list += list("WHITE" = reductions[2])
	if(reductions[3] != 0)
		resistances_list += list("BLACK" = reductions[3])
	if(reductions[4] != 0)
		resistances_list += list("PALE" = reductions[4])
	to_chat(user, span_nicegreen("[src] has been successfully improved!"))
	icon_state = "shield_[egoshard.damage_type]"

/obj/item/ego_weapon/shield/lcorp_shield/examine(mob/user)
	. = ..()
	if(!installed_shard)
		. += span_warning("This weapon can be enhanced with an egoshard.")
	else
		. += span_nicegreen("It has a [installed_shard] installed.")

/obj/item/ego_weapon/shield/lcorp_shield/Topic(href, href_list) //An override to make the attribute tag only show up when upgraded
	. = ..()
	if(!installed_shard)
		to_chat(usr, span_nicegreen("This weapon can be used by anyone."))

/////////////////////
//OFFICER EQUIPMENT//
/////////////////////

//Nothing here at the moment

///////////////////
//CLERK EQUIPMENT//
///////////////////

//Agent baton
/obj/item/melee/classic_baton
	name = "agent baton"
	desc = "A cheap weapon for beating Abnormalities or Clerks."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "classic_baton"
	inhand_icon_state = "classic_baton"
	worn_icon_state = "classic_baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 4
	w_class = WEIGHT_CLASS_NORMAL

	var/cooldown_check = 0 // Used interally, you don't want to modify

	var/cooldown = 30 // Default wait time until can stun again.
	var/knockdown_time_carbon = (2 SECONDS) // Knockdown length for carbons. Only used when targeting legs.
	var/stun_time_silicon = (5 SECONDS) // If enabled, how long do we stun silicons.
	var/stamina_damage = 25 // Do we deal stamina damage.
	var/stunarmor_penetration = 1 // A modifier from 0 to 1. How much armor we can ignore. Less = Ignores more armor.
	var/affect_silicon = FALSE // Does it stun silicons.
	var/on_sound // "On" sound, played when switching between able to stun or not.
	var/on_stun_sound = 'sound/effects/woodhit.ogg' // Default path to sound for when we stun.
	var/stun_animation = TRUE // Do we animate the "hit" when stunning.
	var/on = TRUE // Are we on or off.

	var/on_icon_state // What is our sprite when turned on
	var/off_icon_state // What is our sprite when turned off
	var/on_inhand_icon_state // What is our in-hand sprite when turned on
	var/force_on // Damage when on - not stunning
	var/force_off // Damage when off - not stunning
	var/weight_class_on // What is the new size class when turned on

	wound_bonus = 15

//Examine text
/obj/item/melee/classic_baton/examine(mob/user)
	. = ..()

	. += span_notice("This weapon works differently from most weapons and can be used to disarm other players.")

	. += span_notice("It has a <a href='byond://?src=[REF(src)];'>tag</a> explaining how to use [src].")

/obj/item/melee/classic_baton/Topic(href, href_list)
	. = ..()
	var/list/readout = list("<u><b>Attacks that are not on harm intent deal nonlethal stamina damage, which will eventually cause humans to collapse from exhaustion.</u></b>")
	readout += "\nAim for a leg to attempt to trip someone over when attacking."
	readout += "\nAim for an arm to attempt to force the target to drop the item they are holding in that hand."
	to_chat(usr, "[span_notice(readout.Join())]")

// Description for trying to stun when still on cooldown.
/obj/item/melee/classic_baton/proc/get_wait_description()
	return

// Description for when turning their baton "on"
/obj/item/melee/classic_baton/proc/get_on_description()
	. = list()

	.["local_on"] = "<span class ='warning'>You extend the baton.</span>"
	.["local_off"] = "<span class ='notice'>You collapse the baton.</span>"

	return .

// Default message for stunning mob.
/obj/item/melee/classic_baton/proc/get_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visibletrip"] =  "<span class ='danger'>[user] has knocked [target]'s legs out from under them with [src]!</span>"
	.["localtrip"] = "<span class ='danger'>[user]  has knocked your legs out from under you [src]!</span>"
	.["visibledisarm"] =  "<span class ='danger'>[user] has disarmed [target] with [src]!</span>"
	.["localdisarm"] = "<span class ='danger'>[user] whacks your arm with [src], causing a coursing pain!</span>"
	.["visiblestun"] =  "<span class ='danger'>[user] beat [target] with [src]!</span>"
	.["localstun"] = "<span class ='danger'>[user] has beat you with [src]!</span>"

	return .

// Default message for stunning a silicon.
/obj/item/melee/classic_baton/proc/get_silicon_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = "<span class='danger'>[user] pulses [target]'s sensors with the baton!</span>"
	.["local"] = "<span class='danger'>You pulse [target]'s sensors with the baton!</span>"

	return .

// Are we applying any special effects when we stun to carbon
/obj/item/melee/classic_baton/proc/additional_effects_carbon(mob/living/target, mob/living/user)
	return

// Are we applying any special effects when we stun to silicon
/obj/item/melee/classic_baton/proc/additional_effects_silicon(mob/living/target, mob/living/user)
	return

/obj/item/melee/classic_baton/attack(mob/living/target, mob/living/user)
	if(!on)
		return ..()

	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, "<span class ='userdanger'>You hit yourself over the head!</span>")

		user.Paralyze(knockdown_time_carbon * force)
		user.apply_damage(stamina_damage, STAMINA, BODY_ZONE_HEAD)

		additional_effects_carbon(user) // user is the target here
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		// We don't stun if we're on harm.
		if (user.a_intent != INTENT_HARM)
			if (affect_silicon)
				var/list/desc = get_silicon_stun_description(target, user)

				target.flash_act(affect_silicon = TRUE)
				target.Paralyze(stun_time_silicon)
				additional_effects_silicon(target, user)

				user.visible_message(desc["visible"], desc["local"])
				playsound(get_turf(src), on_stun_sound, 100, TRUE, -1)

				if (stun_animation)
					user.do_attack_animation(target)
			else
				..()
		else
			..()
		return
	if(!isliving(target))
		return
	if (user.a_intent == INTENT_HARM || !ishuman(target))
		if(!..())
			return
		if(!iscyborg(target))
			return
	else
		if(cooldown_check <= world.time)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if (H.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK))
					return
				if(check_martial_counter(H, user))
					return

			var/list/desc = get_stun_description(target, user)

			if (stun_animation)
				user.do_attack_animation(target)

			playsound(get_turf(src), on_stun_sound, 75, TRUE, -1)
			additional_effects_carbon(target, user)

			var/selected_bodypart_area = check_zone(user.zone_selected)
			var/target_limb = target.get_bodypart(selected_bodypart_area)
			var/def_check = (target.getarmor(target_limb, type = "melee") * stunarmor_penetration)
			switch(selected_bodypart_area)
				if(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
					if(target.stat || target.IsKnockdown() || (target == user) || def_check < 41) // Can't knock down someone with shit-load of armor.
						var/armor_effect = 1 - (def_check / 100)
						target.Knockdown(knockdown_time_carbon * armor_effect)
						log_combat(user, target, "tripped", src)
						target.visible_message(desc["visibletrip"], desc["localtrip"])
						target.apply_damage(stamina_damage*0.25, STAMINA, selected_bodypart_area, def_check)
					else
						log_combat(user, target, "stunned", src)
						target.visible_message(desc["visiblestun"], desc["localstun"])
						target.apply_damage(stamina_damage, STAMINA, selected_bodypart_area, def_check)

				if(BODY_ZONE_L_ARM)
					baton_disarm(user, target, LEFT_HANDS, selected_bodypart_area, def_check)

				if(BODY_ZONE_R_ARM)
					baton_disarm(user, target, RIGHT_HANDS, selected_bodypart_area, def_check)

				else // Normal effect.
					target.apply_damage(stamina_damage, STAMINA, selected_bodypart_area, def_check)
					log_combat(user, target, "stunned", src)
					target.visible_message(desc["visiblestun"], desc["localstun"])

			add_fingerprint(user)

			if(!iscarbon(user))
				target.LAssailant = null
			else
				target.LAssailant = user
			cooldown_check = world.time + cooldown
		else
			var/wait_desc = get_wait_description()
			if (wait_desc)
				to_chat(user, wait_desc)

/obj/item/melee/classic_baton/proc/baton_disarm(mob/living/carbon/user, mob/living/carbon/target, side, bodypart_target, def_check)
	var/obj/item/I = target.get_held_items_for_side(side)
	var/list/desc = get_stun_description(target, user)
	if(I && target.dropItemToGround(I)) // There is an item in this hand. Drop it and deal slightly less stamina damage.
		log_combat(user, target, "disarmed", src)
		target.visible_message(desc["visibledisarm"], desc["localdisarm"])
		target.apply_damage(stamina_damage*0.5, STAMINA, bodypart_target, def_check)
	else // No item in that hand. Deal normal stamina damage.
		log_combat(user, target, "stunned", src)
		target.visible_message(desc["visiblestun"], desc["localstun"])
		target.apply_damage(stamina_damage, STAMINA, bodypart_target, def_check)
