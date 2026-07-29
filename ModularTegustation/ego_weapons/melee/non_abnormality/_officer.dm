
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
