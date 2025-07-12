// Bleed support skills (Level 1)

//=======================
// SUPPORT SKILLS
//=======================

// Lacerate - Next 3 attacks apply bleed
/datum/action/cooldown/bleed/lacerate
	name = "Lacerate"
	desc = "Next 3 melee attacks within 5 seconds apply 8 Bleed stacks."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "lacerate"
	cooldown_time = 12 SECONDS
	var/charges = 0
	var/buff_duration = 5 SECONDS

/datum/action/cooldown/bleed/lacerate/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	to_chat(owner, span_notice("Your next 3 attacks will cause deep lacerations!"))
	charges = 3

	// Add visual effect to weapon
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		held_item.add_atom_colour("#aa0000", TEMPORARY_COLOUR_PRIORITY)

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/bleed/lacerate/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(!charges || !target || target.stat == DEAD)
		return

	target.apply_lc_bleed(8)
	charges--

	// Visual feedback
	new /obj/effect/temp_visual/blood_slash(get_turf(target))
	playsound(target, 'sound/weapons/slash.ogg', 50, TRUE)
	to_chat(target, span_userdanger("The attack opens deep wounds!"))
	to_chat(source, span_notice("You lacerate [target]! ([charges] charges remaining)"))

	if(charges <= 0)
		remove_buff()

/datum/action/cooldown/bleed/lacerate/proc/remove_buff()
	charges = 0
	var/obj/item/held_item = owner.get_active_held_item()
	if(held_item)
		held_item.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

// Sanguine Chain - Link two targets to share bleed
/datum/action/cooldown/bleed/sanguine_chain
	name = "Sanguine Chain"
	desc = "Link selected target to nearest MOB; when one gains Bleed, other gains same stacks for 10 seconds."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "sanguine_chain"
	cooldown_time = 20 SECONDS

/datum/action/cooldown/bleed/sanguine_chain/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	// Register click handler
	to_chat(owner, span_notice("Click on a target to create a sanguine chain!"))
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/bleed/sanguine_chain/proc/on_click(mob/living/source, atom/target, params)
	SIGNAL_HANDLER

	cancel_targeting()

	if(!isliving(target))
		to_chat(source, span_warning("You must target a living creature!"))
		return

	var/mob/living/primary = target
	if(primary == source || primary.stat == DEAD)
		to_chat(source, span_warning("Invalid target!"))
		return

	// Find nearest other mob
	var/mob/living/secondary
	var/min_dist = INFINITY
	for(var/mob/living/L in view(5, primary))
		if(L == primary || L == source || L.stat == DEAD)
			continue
		var/dist = get_dist(primary, L)
		if(dist < min_dist)
			min_dist = dist
			secondary = L

	if(!secondary)
		to_chat(source, span_warning("No valid secondary target found!"))
		return

	// Create the chain
	var/datum/component/sanguine_link/link = primary.AddComponent(/datum/component/sanguine_link, secondary)
	if(!link)
		to_chat(source, span_warning("Failed to create sanguine chain!"))
		return

	// Visual effect - beam between targets
	primary.Beam(secondary, icon_state="blood_beam", time=10 SECONDS)

	to_chat(source, span_notice("You link [primary] and [secondary] with a sanguine chain!"))
	StartCooldown()

/datum/action/cooldown/bleed/sanguine_chain/proc/cancel_targeting()
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// Bloodletting Strike - Transfer bleed from self to target
/datum/action/cooldown/bleed/bloodletting_strike
	name = "Bloodletting Strike"
	desc = "Next melee attack transfers up to 15 Bleed stacks from you to target."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "bloodletting_strike"
	cooldown_time = 10 SECONDS
	var/empowered = FALSE

/datum/action/cooldown/bleed/bloodletting_strike/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	if(!isliving(owner))
		return FALSE
	var/mob/living/L = owner
	var/datum/status_effect/stacking/lc_bleed/self_bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(!self_bleed || self_bleed.stacks <= 0)
		to_chat(owner, span_warning("You have no bleed to transfer!"))
		return FALSE

	to_chat(owner, span_notice("Your next attack will transfer your bleeding wounds!"))
	empowered = TRUE

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	StartCooldown()
	return TRUE

/datum/action/cooldown/bleed/bloodletting_strike/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
	SIGNAL_HANDLER

	if(!empowered || !target || target.stat == DEAD)
		return

	var/datum/status_effect/stacking/lc_bleed/self_bleed = source.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(!self_bleed)
		remove_buff()
		return

	var/transfer_amount = min(self_bleed.stacks, 15)
	self_bleed.add_stacks(-transfer_amount)
	target.apply_lc_bleed(transfer_amount)

	// Visual effect
	new /obj/effect/temp_visual/blood_transfer(get_turf(source))
	new /obj/effect/temp_visual/blood_transfer(get_turf(target))
	playsound(target, 'sound/effects/wounds/blood2.ogg', 50, TRUE)

	to_chat(source, span_notice("You transfer [transfer_amount] bleed stacks to [target]!"))
	to_chat(target, span_userdanger("Fresh wounds open as blood is forced into you!"))

	remove_buff()

/datum/action/cooldown/bleed/bloodletting_strike/proc/remove_buff()
	empowered = FALSE
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

//=======================
// CONTROL SKILLS
//=======================

// Sanguine Feast - Remove bleed from ally and heal them
/datum/action/cooldown/bleed/sanguine_feast
	name = "Sanguine Feast"
	desc = "Remove all Bleed from selected ally and heal them stacks * 4 HP/SP."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "sanguine_feast"
	cooldown_time = 15 SECONDS

/datum/action/cooldown/bleed/sanguine_feast/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	// Register click handler
	to_chat(owner, span_notice("Click on an ally to feast on their blood!"))
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
	return TRUE

/datum/action/cooldown/bleed/sanguine_feast/proc/on_click(mob/living/source, atom/target, params)
	SIGNAL_HANDLER

	cancel_targeting()

	if(!isliving(target))
		to_chat(source, span_warning("You must target a living creature!"))
		return

	var/mob/living/L = target
	if(L.stat == DEAD)
		to_chat(source, span_warning("[L] is already dead!"))
		return

	if(L == source)
		to_chat(source, span_warning("Can't target self!"))
		return

	if(get_dist(source, L) > 4)
		to_chat(source, span_warning("[L] is too far away!"))
		return

	var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(!bleed || bleed.stacks <= 0)
		to_chat(source, span_warning("[L] is not bleeding!"))
		return

	// Calculate healing
	var/heal_amount = bleed.stacks * 4

	// Remove bleed and heal
	L.remove_status_effect(/datum/status_effect/stacking/lc_bleed)
	L.adjustBruteLoss(-heal_amount)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.adjustSanityLoss(-heal_amount)

	// Visual effects
	new /obj/effect/temp_visual/heal/blood(get_turf(L))
	playsound(L, 'sound/effects/wounds/blood1.ogg', 50, TRUE)
	playsound(L, 'sound/magic/staff_healing.ogg', 25, TRUE)

	to_chat(L, span_nicegreen("Your wounds close as the blood returns to your body!"))
	to_chat(source, span_notice("You feast on [L]'s blood, healing them for [heal_amount] damage!"))

	StartCooldown()

/datum/action/cooldown/bleed/sanguine_feast/proc/cancel_targeting()
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// Blood Pool - Create area that applies bleed
/datum/action/cooldown/bleed/blood_pool
	name = "Blood Pool"
	desc = "Create 3x3 area centered around you that applies 5 Bleed stack/2 sec to all targets for 15 seconds."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "blood_pool"
	cooldown_time = 20 SECONDS

/datum/action/cooldown/bleed/blood_pool/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	var/turf/center = get_turf(owner)
	if(!center)
		return FALSE

	// Create blood pool
	for(var/turf/T in range(1, center))
		new /obj/effect/blood_pool_area(T, owner)

	playsound(center, 'sound/effects/splat.ogg', 75, TRUE)
	to_chat(owner, span_notice("You create a pool of blood around you!"))

	StartCooldown()
	return TRUE

// Crimson Repulsion - Push away bleeding targets
/datum/action/cooldown/bleed/crimson_repulsion
	name = "Crimson Repulsion"
	desc = "If the selected target has 5+ Bleed, repel them away from you and slow them by 50% for 2.5 seconds."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "crimson_repulsion"
	cooldown_time = 5 SECONDS

/datum/action/cooldown/bleed/crimson_repulsion/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	// Register click handler
	to_chat(owner, span_notice("Click on a bleeding target to repel them!"))
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 3 SECONDS)
	return TRUE

/datum/action/cooldown/bleed/crimson_repulsion/proc/on_click(mob/living/source, atom/target, params)
	SIGNAL_HANDLER

	cancel_targeting()

	if(!isliving(target))
		to_chat(source, span_warning("You must target a living creature!"))
		return

	var/mob/living/L = target
	if(L == source || L.stat == DEAD)
		to_chat(source, span_warning("Invalid target!"))
		return

	var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(!bleed || bleed.stacks < 5)
		to_chat(source, span_warning("[L] doesn't have enough bleed stacks!"))
		return

	// Apply knockback
	var/turf/target_turf = get_turf(L)
	var/turf/source_turf = get_turf(source)
	var/dir_away = get_dir(source_turf, target_turf)
	var/turf/throw_target = get_edge_target_turf(target_turf, dir_away)

	L.throw_at(throw_target, 3, 2)
	L.apply_status_effect(/datum/status_effect/crimson_slow)

	// Visual effects
	new /obj/effect/temp_visual/kinetic_blast(target_turf)
	playsound(target_turf, 'sound/effects/gravhit.ogg', 50, TRUE)

	to_chat(L, span_userdanger("Your blood recoils, pushing you away!"))
	to_chat(source, span_notice("You repel [L] with their own blood!"))

	StartCooldown()

/datum/action/cooldown/bleed/crimson_repulsion/proc/cancel_targeting()
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

//=======================
// VISUAL EFFECTS
//=======================

/obj/effect/temp_visual/blood_slash
	icon = 'icons/effects/effects.dmi'
	color = "#ff0000"
	icon_state = "slice"
	duration = 5

/obj/effect/temp_visual/blood_transfer
	icon = 'icons/effects/blood.dmi'
	icon_state = "helmetblood"
	duration = 10

/obj/effect/temp_visual/blood_transfer/Initialize()
	. = ..()
	animate(src, pixel_y = pixel_y + 16, alpha = 0, time = duration)

/obj/effect/temp_visual/heal/blood
	color = "#ff0000"

/obj/effect/blood_pool_area
	name = "blood pool"
	desc = "A pool of viscous blood."
	icon = 'icons/effects/blood.dmi'
	icon_state = "splatter2"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER + 0.1
	var/mob/living/owner

/obj/effect/blood_pool_area/Initialize(mapload, mob/living/caster)
	. = ..()
	owner = caster
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, 15 SECONDS)
	alpha = 150

/obj/effect/blood_pool_area/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/blood_pool_area/process()
	for(var/mob/living/L in get_turf(src))
		if(L == owner || L.stat == DEAD)
			continue
		L.apply_lc_bleed(5)
		new /obj/effect/temp_visual/small_blood(get_turf(L))

/obj/effect/temp_visual/small_blood
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	duration = 3

/obj/effect/temp_visual/small_blood/Initialize()
	. = ..()
	icon_state = pick("floor1", "floor2", "floor3", "floor4", "floor5")

//=======================
// STATUS EFFECTS
//=======================

/datum/status_effect/crimson_slow
	id = "crimson_slow"
	duration = 2.5 SECONDS
	alert_type = null

/datum/status_effect/crimson_slow/on_apply()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/crimson_slow)
	return TRUE

/datum/status_effect/crimson_slow/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/crimson_slow)

/datum/movespeed_modifier/crimson_slow
	multiplicative_slowdown = 2

//=======================
// COMPONENTS
//=======================

/datum/component/sanguine_link
	var/mob/living/linked_mob
	var/link_duration = 10 SECONDS

/datum/component/sanguine_link/Initialize(mob/living/link_target)
	if(!isliving(parent) || !link_target)
		return COMPONENT_INCOMPATIBLE

	linked_mob = link_target
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, link_duration)

/datum/component/sanguine_link/Destroy()
	STOP_PROCESSING(SSobj, src)
	linked_mob = null
	return ..()

/datum/component/sanguine_link/process()
	if(!parent || !linked_mob || QDELETED(parent) || QDELETED(linked_mob))
		qdel(src)
		return

	var/mob/living/owner = parent
	var/datum/status_effect/stacking/lc_bleed/owner_bleed = owner.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	var/datum/status_effect/stacking/lc_bleed/linked_bleed = linked_mob.has_status_effect(/datum/status_effect/stacking/lc_bleed)

	// Share bleed stacks
	if(owner_bleed && !linked_bleed)
		linked_mob.apply_lc_bleed(owner_bleed.stacks)
		new /obj/effect/temp_visual/blood_transfer(get_turf(linked_mob))
	else if(!owner_bleed && linked_bleed)
		owner.apply_lc_bleed(linked_bleed.stacks)
		new /obj/effect/temp_visual/blood_transfer(get_turf(owner))
	else if(owner_bleed && linked_bleed)
		// Average out the stacks
		var/avg_stacks = (owner_bleed.stacks + linked_bleed.stacks) / 2
		owner_bleed.stacks = avg_stacks
		linked_bleed.stacks = avg_stacks
