// /*
//  * Bleed Status Skills
//  * These skills interact with the lc_bleed status effect
//  */

// //Base bleed skill book
// /obj/item/book/granter/action/skill/bleed
// 	name = "Bleed Skill Book"
// 	desc = "A book that teaches blood-based combat techniques."
// 	icon_state = "book2"
// 	remarks = list("The pages are stained with blood...", "I feel a strange thirst...", "My wounds begin to ache...")
// 	pages_to_mastery = 0

// //=======================
// // DAMAGE SKILLS
// //=======================

// // Hemorrhage - Teleport to target and trigger damage based on bleed stacks
// /obj/item/book/granter/action/skill/bleed/hemorrhage
// 	name = "Bleed Skill: Hemorrhage"
// 	actionname = "Hemorrhage"
// 	granted_action = /datum/action/cooldown/bleed/hemorrhage
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/hemorrhage
// 	name = "Hemorrhage"
// 	desc = "Teleport to the target and instantly trigger stacks * 10 RED damage on selected target and remove all Bleed stacks."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "hemorrhage"
// 	cooldown_time = 15 SECONDS

// /datum/action/cooldown/bleed/hemorrhage/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	var/mob/living/target_mob
// 	var/list/potential_targets = list()

// 	// Find valid targets
// 	for(var/mob/living/M in view(7, owner))
// 		if(M == owner || M.stat == DEAD)
// 			continue
// 		var/datum/status_effect/stacking/lc_bleed/bleed = M.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 		if(bleed && bleed.stacks > 0)
// 			potential_targets += M

// 	if(!length(potential_targets))
// 		to_chat(owner, span_warning("No bleeding targets in range!"))
// 		return FALSE

// 	if(length(potential_targets) == 1)
// 		target_mob = potential_targets[1]
// 	else
// 		target_mob = input(owner, "Choose a target to hemorrhage", "Hemorrhage") as null|anything in potential_targets

// 	if(!target_mob || !(target_mob in view(7, owner)))
// 		return FALSE

// 	INVOKE_ASYNC(src, PROC_REF(perform_hemorrhage), target_mob)
// 	StartCooldown()
// 	return TRUE

// /datum/action/cooldown/bleed/hemorrhage/proc/perform_hemorrhage(mob/living/target)
// 	var/datum/status_effect/stacking/lc_bleed/bleed = target.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	if(!bleed)
// 		return

// 	var/damage = bleed.stacks * 10
// 	var/turf/target_turf = get_turf(target)

// 	// Teleportation effect
// 	new /obj/effect/temp_visual/teleport_burst(get_turf(owner))
// 	owner.forceMove(target_turf)
// 	new /obj/effect/temp_visual/teleport_burst(target_turf)

// 	// Blood explosion effect
// 	for(var/i in 1 to 3)
// 		new /obj/effect/temp_visual/blood_explosion(target_turf)
// 		sleep(1)

// 	// Deal damage and remove bleed
// 	target.apply_damage(damage, RED_DAMAGE)
// 	target.remove_status_effect(/datum/status_effect/stacking/lc_bleed)

// 	// Visual and audio feedback
// 	new /obj/effect/temp_visual/dir_setting/bloodsplatter(target_turf, pick(GLOB.alldirs))
// 	playsound(target, 'sound/effects/wounds/blood3.ogg', 75, TRUE)
// 	playsound(target, 'sound/effects/splat.ogg', 50, TRUE)

// 	to_chat(target, span_userdanger("Your blood erupts violently from your wounds!"))
// 	to_chat(owner, span_boldwarning("You trigger a hemorrhage in [target] for [damage] damage!"))

// // Crimson Cleave - Wide slash that damages based on bleed stacks
// /obj/item/book/granter/action/skill/bleed/crimson_cleave
// 	name = "Bleed Skill: Crimson Cleave"
// 	actionname = "Crimson Cleave"
// 	granted_action = /datum/action/cooldown/bleed/crimson_cleave
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/crimson_cleave
// 	name = "Crimson Cleave"
// 	desc = "Wide slash dealing 30 + (MOB bleed stack * 10) RED damage and reduces the Bleed stack of all MOBs in frontal cone by 5."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "crimson_cleave"
// 	cooldown_time = 10 SECONDS

// /datum/action/cooldown/bleed/crimson_cleave/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	var/turf/T = get_turf(owner)
// 	var/facing = owner.dir

// 	// Create cleave visual
// 	new /obj/effect/temp_visual/cleave/crimson(T, facing)
// 	playsound(T, 'sound/weapons/slice.ogg', 75, TRUE)

// 	// Get all turfs in cone
// 	var/list/cone_turfs = list()
// 	for(var/i in 1 to 3)
// 		var/turf/current = get_step(T, facing)
// 		if(!current)
// 			break
// 		T = current
// 		cone_turfs += T

// 		// Add side turfs for wider cone
// 		if(i > 1)
// 			var/left = turn(facing, 45)
// 			var/right = turn(facing, -45)
// 			var/turf/L = get_step(T, left)
// 			var/turf/R = get_step(T, right)
// 			if(L) cone_turfs += L
// 			if(R) cone_turfs += R

// 	// Damage all mobs in cone
// 	var/hit_count = 0
// 	for(var/turf/target_turf in cone_turfs)
// 		new /obj/effect/temp_visual/blood_wave(target_turf)
// 		for(var/mob/living/L in target_turf)
// 			if(L == owner || L.stat == DEAD)
// 				continue

// 			var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 			var/damage = 30
// 			if(bleed)
// 				damage += bleed.stacks * 10
// 				bleed.add_stacks(-5)

// 			L.apply_damage(damage, RED_DAMAGE)
// 			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), get_dir(owner, L))
// 			to_chat(L, span_userdanger("The crimson cleave tears through you!"))
// 			hit_count++

// 	if(hit_count)
// 		to_chat(owner, span_notice("Your crimson cleave hits [hit_count] target\s!"))
// 	else
// 		to_chat(owner, span_warning("Your crimson cleave hits nothing!"))

// 	StartCooldown()
// 	return TRUE

// // Blood Spike - Launch projectile that deals area damage based on target's bleed
// /obj/item/book/granter/action/skill/bleed/blood_spike
// 	name = "Bleed Skill: Blood Spike"
// 	actionname = "Blood Spike"
// 	granted_action = /datum/action/cooldown/bleed/blood_spike
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/blood_spike
// 	name = "Blood Spike"
// 	desc = "Launch projectile at selected target. This projectile deals 10 + (hit target's bleed stack * 5) RED damage in a 3x3 area. Centered around the target. Then it clears all bleed from the hit target."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "blood_spike"
// 	cooldown_time = 8 SECONDS

// /datum/action/cooldown/bleed/blood_spike/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click on a target to launch a blood spike!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
// 	return TRUE

// /datum/action/cooldown/bleed/blood_spike/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	if(!isliving(target))
// 		to_chat(source, span_warning("You must target a living creature!"))
// 		return

// 	var/mob/living/L = target
// 	if(L == source || L.stat == DEAD)
// 		to_chat(source, span_warning("Invalid target!"))
// 		return

// 	if(!L.has_status_effect(/datum/status_effect/stacking/lc_bleed))
// 		to_chat(source, span_warning("[L] is not bleeding!"))
// 		return

// 	// Fire projectile
// 	var/obj/projectile/blood_spike/spike = new(get_turf(source))
// 	spike.preparePixelProjectile(L, source)
// 	spike.firer = source
// 	spike.fire()

// 	StartCooldown()

// /datum/action/cooldown/bleed/blood_spike/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// /obj/projectile/blood_spike
// 	name = "blood spike"
// 	icon = 'icons/effects/blood.dmi'
// 	icon_state = "bloodjet"
// 	speed = 1
// 	damage = 0
// 	var/mob/living/firer

// /obj/projectile/blood_spike/on_hit(atom/target, blocked, pierce_hit)
// 	if(!isliving(target))
// 		return ..()

// 	var/mob/living/L = target
// 	var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	if(!bleed)
// 		return ..()

// 	var/damage = 10 + (bleed.stacks * 5)

// 	// Remove bleed from primary target
// 	L.remove_status_effect(/datum/status_effect/stacking/lc_bleed)

// 	// Deal area damage
// 	for(var/turf/T in range(1, get_turf(L)))
// 		new /obj/effect/temp_visual/blood_explosion(T)
// 		for(var/mob/living/victim in T)
// 			if(victim.stat == DEAD)
// 				continue
// 			victim.apply_damage(damage, RED_DAMAGE)
// 			to_chat(victim, span_userdanger("The blood spike explodes!"))

// 	playsound(target, 'sound/effects/splat.ogg', 75, TRUE)
// 	return ..()

// //=======================
// // SUPPORT SKILLS
// //=======================

// // Lacerate - Next 3 attacks apply bleed
// /obj/item/book/granter/action/skill/bleed/lacerate
// 	name = "Bleed Skill: Lacerate"
// 	actionname = "Lacerate"
// 	granted_action = /datum/action/cooldown/bleed/lacerate
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/lacerate
// 	name = "Lacerate"
// 	desc = "Next 3 melee attacks within 5 seconds apply 8 Bleed stacks."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "lacerate"
// 	cooldown_time = 12 SECONDS
// 	var/charges = 0
// 	var/buff_duration = 5 SECONDS

// /datum/action/cooldown/bleed/lacerate/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	to_chat(owner, span_notice("Your next 3 attacks will cause deep lacerations!"))
// 	charges = 3

// 	// Add visual effect to weapon
// 	var/obj/item/held_item = owner.get_active_held_item()
// 	if(held_item)
// 		held_item.add_atom_colour("#aa0000", TEMPORARY_COLOUR_PRIORITY)

// 	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
// 	addtimer(CALLBACK(src, PROC_REF(remove_buff)), buff_duration)
// 	StartCooldown()
// 	return TRUE

// /datum/action/cooldown/bleed/lacerate/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
// 	SIGNAL_HANDLER

// 	if(!charges || !target || target.stat == DEAD)
// 		return

// 	target.apply_lc_bleed(8)
// 	charges--

// 	// Visual feedback
// 	new /obj/effect/temp_visual/blood_slash(get_turf(target))
// 	playsound(target, 'sound/weapons/slash.ogg', 50, TRUE)
// 	to_chat(target, span_userdanger("The attack opens deep wounds!"))
// 	to_chat(source, span_notice("You lacerate [target]! ([charges] charges remaining)"))

// 	if(charges <= 0)
// 		remove_buff()

// /datum/action/cooldown/bleed/lacerate/proc/remove_buff()
// 	charges = 0
// 	var/obj/item/held_item = owner.get_active_held_item()
// 	if(held_item)
// 		held_item.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
// 	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

// // Sanguine Chain - Link two targets to share bleed
// /obj/item/book/granter/action/skill/bleed/sanguine_chain
// 	name = "Bleed Skill: Sanguine Chain"
// 	actionname = "Sanguine Chain"
// 	granted_action = /datum/action/cooldown/bleed/sanguine_chain
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/sanguine_chain
// 	name = "Sanguine Chain"
// 	desc = "Link selected target to nearest MOB; when one gains Bleed, other gains same stacks for 10 seconds."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "sanguine_chain"
// 	cooldown_time = 20 SECONDS

// /datum/action/cooldown/bleed/sanguine_chain/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click on a target to create a sanguine chain!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
// 	return TRUE

// /datum/action/cooldown/bleed/sanguine_chain/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	if(!isliving(target))
// 		to_chat(source, span_warning("You must target a living creature!"))
// 		return

// 	var/mob/living/primary = target
// 	if(primary == source || primary.stat == DEAD)
// 		to_chat(source, span_warning("Invalid target!"))
// 		return

// 	// Find nearest other mob
// 	var/mob/living/secondary
// 	var/min_dist = INFINITY
// 	for(var/mob/living/L in view(5, primary))
// 		if(L == primary || L == source || L.stat == DEAD)
// 			continue
// 		var/dist = get_dist(primary, L)
// 		if(dist < min_dist)
// 			min_dist = dist
// 			secondary = L

// 	if(!secondary)
// 		to_chat(source, span_warning("No valid secondary target found!"))
// 		return

// 	// Create the chain
// 	var/datum/component/sanguine_link/link = primary.AddComponent(/datum/component/sanguine_link, secondary)
// 	if(!link)
// 		to_chat(source, span_warning("Failed to create sanguine chain!"))
// 		return

// 	// Visual effect - beam between targets
// 	primary.Beam(secondary, icon_state="blood_beam", time=10 SECONDS)

// 	to_chat(source, span_notice("You link [primary] and [secondary] with a sanguine chain!"))
// 	StartCooldown()

// /datum/action/cooldown/bleed/sanguine_chain/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// // Bloodletting Strike - Transfer bleed from self to target
// /obj/item/book/granter/action/skill/bleed/bloodletting_strike
// 	name = "Bleed Skill: Bloodletting Strike"
// 	actionname = "Bloodletting Strike"
// 	granted_action = /datum/action/cooldown/bleed/bloodletting_strike
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/bloodletting_strike
// 	name = "Bloodletting Strike"
// 	desc = "Next melee attack transfers up to 15 Bleed stacks from you to target."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "bloodletting_strike"
// 	cooldown_time = 10 SECONDS
// 	var/empowered = FALSE

// /datum/action/cooldown/bleed/bloodletting_strike/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	var/datum/status_effect/stacking/lc_bleed/self_bleed = owner.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	if(!self_bleed || self_bleed.stacks <= 0)
// 		to_chat(owner, span_warning("You have no bleed to transfer!"))
// 		return FALSE

// 	to_chat(owner, span_notice("Your next attack will transfer your bleeding wounds!"))
// 	empowered = TRUE

// 	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
// 	StartCooldown()
// 	return TRUE

// /datum/action/cooldown/bleed/bloodletting_strike/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/item)
// 	SIGNAL_HANDLER

// 	if(!empowered || !target || target.stat == DEAD)
// 		return

// 	var/datum/status_effect/stacking/lc_bleed/self_bleed = source.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	if(!self_bleed)
// 		remove_buff()
// 		return

// 	var/transfer_amount = min(self_bleed.stacks, 15)
// 	self_bleed.add_stacks(-transfer_amount)
// 	target.apply_lc_bleed(transfer_amount)

// 	// Visual effect
// 	new /obj/effect/temp_visual/blood_transfer(get_turf(source))
// 	new /obj/effect/temp_visual/blood_transfer(get_turf(target))
// 	playsound(target, 'sound/effects/wounds/blood2.ogg', 50, TRUE)

// 	to_chat(source, span_notice("You transfer [transfer_amount] bleed stacks to [target]!"))
// 	to_chat(target, span_userdanger("Fresh wounds open as blood is forced into you!"))

// 	remove_buff()

// /datum/action/cooldown/bleed/bloodletting_strike/proc/remove_buff()
// 	empowered = FALSE
// 	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

// //=======================
// // CONTROL SKILLS
// //=======================

// // Sanguine Feast - Remove bleed from ally and heal them
// /obj/item/book/granter/action/skill/bleed/sanguine_feast
// 	name = "Bleed Skill: Sanguine Feast"
// 	actionname = "Sanguine Feast"
// 	granted_action = /datum/action/cooldown/bleed/sanguine_feast
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/sanguine_feast
// 	name = "Sanguine Feast"
// 	desc = "Remove all Bleed from selected ally and heal them stacks * 4 HP/SP."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "sanguine_feast"
// 	cooldown_time = 15 SECONDS

// /datum/action/cooldown/bleed/sanguine_feast/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click on an ally to feast on their blood!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 5 SECONDS)
// 	return TRUE

// /datum/action/cooldown/bleed/sanguine_feast/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	if(!isliving(target))
// 		to_chat(source, span_warning("You must target a living creature!"))
// 		return

// 	var/mob/living/L = target
// 	if(L.stat == DEAD)
// 		to_chat(source, span_warning("[L] is already dead!"))
// 		return

// 	if(get_dist(source, L) > 1)
// 		to_chat(source, span_warning("[L] is too far away!"))
// 		return

// 	var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	if(!bleed || bleed.stacks <= 0)
// 		to_chat(source, span_warning("[L] is not bleeding!"))
// 		return

// 	// Calculate healing
// 	var/heal_amount = bleed.stacks * 4

// 	// Remove bleed and heal
// 	L.remove_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	L.adjustBruteLoss(-heal_amount)
// 	L.adjustSanityLoss(-heal_amount)

// 	// Visual effects
// 	new /obj/effect/temp_visual/heal/blood(get_turf(L))
// 	playsound(L, 'sound/effects/wounds/blood1.ogg', 50, TRUE)
// 	playsound(L, 'sound/magic/staff_healing.ogg', 25, TRUE)

// 	to_chat(L, span_nicegreen("Your wounds close as the blood returns to your body!"))
// 	to_chat(source, span_notice("You feast on [L]'s blood, healing them for [heal_amount] damage!"))

// 	StartCooldown()

// /datum/action/cooldown/bleed/sanguine_feast/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// // Blood Pool - Create area that applies bleed
// /obj/item/book/granter/action/skill/bleed/blood_pool
// 	name = "Bleed Skill: Blood Pool"
// 	actionname = "Blood Pool"
// 	granted_action = /datum/action/cooldown/bleed/blood_pool
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/blood_pool
// 	name = "Blood Pool"
// 	desc = "Create 3x3 area centered around you that applies 5 Bleed stack/sec to all targets for 5 seconds."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "blood_pool"
// 	cooldown_time = 10 SECONDS

// /datum/action/cooldown/bleed/blood_pool/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	var/turf/center = get_turf(owner)
// 	if(!center)
// 		return FALSE

// 	// Create blood pool
// 	for(var/turf/T in range(1, center))
// 		new /obj/effect/blood_pool_area(T, owner)

// 	playsound(center, 'sound/effects/splat.ogg', 75, TRUE)
// 	to_chat(owner, span_notice("You create a pool of blood around you!"))

// 	StartCooldown()
// 	return TRUE

// /obj/effect/blood_pool_area
// 	name = "blood pool"
// 	desc = "A pool of viscous blood."
// 	icon = 'icons/effects/blood.dmi'
// 	icon_state = "floor7"
// 	density = FALSE
// 	anchored = TRUE
// 	layer = TURF_LAYER + 0.1
// 	var/mob/living/owner

// /obj/effect/blood_pool_area/Initialize(mapload, mob/living/caster)
// 	. = ..()
// 	owner = caster
// 	START_PROCESSING(SSobj, src)
// 	QDEL_IN(src, 5 SECONDS)
// 	alpha = 150

// /obj/effect/blood_pool_area/Destroy()
// 	STOP_PROCESSING(SSobj, src)
// 	return ..()

// /obj/effect/blood_pool_area/process()
// 	for(var/mob/living/L in get_turf(src))
// 		if(L == owner || L.stat == DEAD)
// 			continue
// 		L.apply_lc_bleed(5)
// 		new /obj/effect/temp_visual/small_blood(get_turf(L))

// // Crimson Repulsion - Push away bleeding targets
// /obj/item/book/granter/action/skill/bleed/crimson_repulsion
// 	name = "Bleed Skill: Crimson Repulsion"
// 	actionname = "Crimson Repulsion"
// 	granted_action = /datum/action/cooldown/bleed/crimson_repulsion
// 	level = -1 // Status skills don't use standard levels
// 	custom_premium_price = 1200

// /datum/action/cooldown/bleed/crimson_repulsion
// 	name = "Crimson Repulsion"
// 	desc = "If the selected target has 5+ Bleed, repel them away from you and slow them by 50% for 2.5 seconds."
// 	icon_icon = 'icons/hud/screen_skills.dmi'
// 	button_icon_state = "crimson_repulsion"
// 	cooldown_time = 5 SECONDS

// /datum/action/cooldown/bleed/crimson_repulsion/Trigger()
// 	. = ..()
// 	if(!.)
// 		return FALSE

// 	if(owner.stat == DEAD)
// 		return FALSE

// 	// Register click handler
// 	to_chat(owner, span_notice("Click on a bleeding target to repel them!"))
// 	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_click))
// 	addtimer(CALLBACK(src, PROC_REF(cancel_targeting)), 3 SECONDS)
// 	return TRUE

// /datum/action/cooldown/bleed/crimson_repulsion/proc/on_click(mob/living/source, atom/target, params)
// 	SIGNAL_HANDLER

// 	cancel_targeting()

// 	if(!isliving(target))
// 		to_chat(source, span_warning("You must target a living creature!"))
// 		return

// 	var/mob/living/L = target
// 	if(L == source || L.stat == DEAD)
// 		to_chat(source, span_warning("Invalid target!"))
// 		return

// 	var/datum/status_effect/stacking/lc_bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	if(!bleed || bleed.stacks < 5)
// 		to_chat(source, span_warning("[L] doesn't have enough bleed stacks!"))
// 		return

// 	// Apply knockback
// 	var/turf/target_turf = get_turf(L)
// 	var/turf/source_turf = get_turf(source)
// 	var/dir_away = get_dir(source_turf, target_turf)
// 	var/turf/throw_target = get_edge_target_turf(target_turf, dir_away)

// 	L.throw_at(throw_target, 3, 2)
// 	L.apply_status_effect(/datum/status_effect/crimson_slow)

// 	// Visual effects
// 	new /obj/effect/temp_visual/kinetic_blast(target_turf)
// 	playsound(target_turf, 'sound/effects/gravhit.ogg', 50, TRUE)

// 	to_chat(L, span_userdanger("Your blood recoils, pushing you away!"))
// 	to_chat(source, span_notice("You repel [L] with their own blood!"))

// 	StartCooldown()

// /datum/action/cooldown/bleed/crimson_repulsion/proc/cancel_targeting()
// 	UnregisterSignal(owner, COMSIG_MOB_CLICKON)

// /datum/status_effect/crimson_slow
// 	id = "crimson_slow"
// 	duration = 2.5 SECONDS
// 	alert_type = null

// /datum/status_effect/crimson_slow/on_apply()
// 	owner.add_movespeed_modifier(/datum/movespeed_modifier/crimson_slow)
// 	return TRUE

// /datum/status_effect/crimson_slow/on_remove()
// 	owner.remove_movespeed_modifier(/datum/movespeed_modifier/crimson_slow)

// /datum/movespeed_modifier/crimson_slow
// 	multiplicative_slowdown = 2

// //=======================
// // VISUAL EFFECTS
// //=======================

// /obj/effect/temp_visual/teleport_burst
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "shield-old"
// 	duration = 5
// 	color = "#ff0000"

// /obj/effect/temp_visual/teleport_burst/Initialize()
// 	. = ..()
// 	animate(src, transform = matrix() * 2, alpha = 0, time = duration)

// /obj/effect/temp_visual/blood_explosion
// 	icon = 'icons/effects/blood.dmi'
// 	icon_state = "bloodsplatter3"
// 	duration = 10

// /obj/effect/temp_visual/blood_explosion/Initialize()
// 	. = ..()
// 	pixel_x = rand(-8, 8)
// 	pixel_y = rand(-8, 8)
// 	var/target_scale = rand(8, 12) / 10
// 	animate(src, transform = matrix() * target_scale, time = 2)
// 	animate(alpha = 0, time = duration - 2)

// /obj/effect/temp_visual/cleave/crimson
// 	color = "#aa0000"

// /obj/effect/temp_visual/blood_wave
// 	icon = 'icons/effects/blood.dmi'
// 	icon_state = "bloodwave"
// 	duration = 8

// /obj/effect/temp_visual/blood_slash
// 	icon = 'icons/effects/blood.dmi'
// 	icon_state = "bloodslash"
// 	duration = 5

// /obj/effect/temp_visual/blood_transfer
// 	icon = 'icons/effects/blood.dmi'
// 	icon_state = "bloodjet"
// 	duration = 10

// /obj/effect/temp_visual/blood_transfer/Initialize()
// 	. = ..()
// 	animate(src, pixel_y = pixel_y + 16, alpha = 0, time = duration)

// /obj/effect/temp_visual/heal/blood
// 	color = "#ff0000"

// /obj/effect/temp_visual/small_blood
// 	icon = 'icons/effects/blood.dmi'
// 	icon_state = "drip1"
// 	duration = 3

// /obj/effect/temp_visual/small_blood/Initialize()
// 	. = ..()
// 	icon_state = pick("drip1", "drip2", "drip3", "drip4", "drip5")

// //=======================
// // COMPONENTS
// //=======================

// /datum/component/sanguine_link
// 	var/mob/living/linked_mob
// 	var/link_duration = 10 SECONDS

// /datum/component/sanguine_link/Initialize(mob/living/link_target)
// 	if(!isliving(parent) || !link_target)
// 		return COMPONENT_INCOMPATIBLE

// 	linked_mob = link_target
// 	START_PROCESSING(SSobj, src)
// 	QDEL_IN(src, link_duration)

// /datum/component/sanguine_link/Destroy()
// 	STOP_PROCESSING(SSobj, src)
// 	linked_mob = null
// 	return ..()

// /datum/component/sanguine_link/process()
// 	if(!parent || !linked_mob || QDELETED(parent) || QDELETED(linked_mob))
// 		qdel(src)
// 		return

// 	var/mob/living/owner = parent
// 	var/datum/status_effect/stacking/lc_bleed/owner_bleed = owner.has_status_effect(/datum/status_effect/stacking/lc_bleed)
// 	var/datum/status_effect/stacking/lc_bleed/linked_bleed = linked_mob.has_status_effect(/datum/status_effect/stacking/lc_bleed)

// 	// Share bleed stacks
// 	if(owner_bleed && !linked_bleed)
// 		linked_mob.apply_lc_bleed(owner_bleed.stacks)
// 		new /obj/effect/temp_visual/blood_transfer(get_turf(linked_mob))
// 	else if(!owner_bleed && linked_bleed)
// 		owner.apply_lc_bleed(linked_bleed.stacks)
// 		new /obj/effect/temp_visual/blood_transfer(get_turf(owner))
// 	else if(owner_bleed && linked_bleed)
// 		// Average out the stacks
// 		var/avg_stacks = (owner_bleed.stacks + linked_bleed.stacks) / 2
// 		owner_bleed.stacks = avg_stacks
// 		linked_bleed.stacks = avg_stacks
