//G corp remenants, Survivors of the Smoke War
//Their function is as common cannon fodder. Manager buffs make them much more effective in battle.
/mob/living/simple_animal/hostile/ordeal/steel_dawn
	name = "gene corp remnant"
	desc = "A insect augmented employee of the fallen Gene corp. Word on the street says that they banded into common backstreet gangs after the Smoke War."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "gcorp1"
	icon_living = "gcorp1"
	icon_dead = "gcorp_corpse"
	faction = list("Gene_Corp")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	maxHealth = 220
	health = 220
	melee_damage_type = RED_DAMAGE
	vision_range = 8
	move_to_delay = 2.2
	melee_damage_lower = 10
	melee_damage_upper = 13
	wander = FALSE
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	footstep_type = FOOTSTEP_MOB_SHOE
	a_intent = INTENT_HELP
	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	//similar to a human
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/buggy = 2)
	silk_results = list(/obj/item/stack/sheet/silk/steel_simple = 1)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/Initialize()
	. = ..()
	attack_sound = "sound/effects/ordeals/steel/gcorp_attack[pick(1,2,3)].ogg"
	if(!istype(src, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon)) //due to being a root of noon
		icon_living = "gcorp[pick(1,2,3,4)]"
		icon_state = icon_living

/mob/living/simple_animal/hostile/ordeal/steel_dawn/Life()
	. = ..()
	//Passive regen when below 50% health.
	if(health <= maxHealth*0.5 && stat != DEAD)
		adjustBruteLoss(-2)
		if(!target)
			adjustBruteLoss(-6)

	//Soldiers when off duty will let eachother move around.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/Aggro()
	. = ..()
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP)

//More Mutated Subtype of Dawns, they are fast and hit faster.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon
	name = "gene corp corporal"
	desc = "A heavily mutated employee with two sharp insectoid arms. Gene corp utilized those who have had a more volitile reaction to the treatment as shock troops during the smoke war."
	icon_state = "gcorp5"
	icon_living = "gcorp5"
	icon_dead = "gcorp_corpse2"
	death_message = "salutes weakly before falling."
	maxHealth = 1000	//Effectively have 750 HP
	health = 1000		//Effectively have 750 HP
	rapid_melee = 2
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	death_sound = 'sound/voice/mook_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/buggy = 2)
	silk_results = list(/obj/item/stack/sheet/silk/steel_simple = 2, /obj/item/stack/sheet/silk/steel_advanced = 1)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/MeleeAction()
	health+=10
	if(health <= maxHealth*0.25 && stat != DEAD && prob(75))
		walk_to(src, 0)
		say("FOR G CORP!!!")
		animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
		addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	new /obj/effect/temp_visual/explosion(get_turf(src))
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
	for(var/mob/living/L in view(3, src))
		L.apply_damage(60, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))

	//Buff allies, all of these buffs only activate once.
	//Buff the grunts around you when you die
	for(var/mob/living/simple_animal/hostile/ordeal/steel_dawn/Y in view(7, src))
		if(Y.stat >= UNCONSCIOUS)
			continue
		Y.say("FOR G CORP!!!")

		//increase damage
		Y.melee_damage_lower = 18
		Y.melee_damage_upper = 22
		//And heal 50%
		Y.adjustBruteLoss(-maxHealth*0.5)

	//And any manager
	for(var/mob/living/simple_animal/hostile/ordeal/steel_dusk/Z in view(7, src))
		if(Z.stat >= UNCONSCIOUS)
			continue
		Z.say("There will be full-on roll call tonight.")
		Z.screech_windup = 3 SECONDS

	gib()

//flying varient trades movement and attack speed for a sweeping attack.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying
	name = "gene corp arial scout"
	desc = "A heavily mutated employee with wings and long insectoid arms. During the smoke war, rabbit teams would get ambushed by swarms that hid in the smoke choked sky."
	icon_state = "gcorp6"
	icon_living = "gcorp6"
	environment_smash = FALSE
	is_flying_animal = TRUE
	footstep_type = null
	rapid_melee = 1
	ranged = TRUE
	ranged_cooldown_time = 15 SECONDS
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	buffed = FALSE
	move_to_delay = 3
	var/charging = FALSE

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/Move()
	if(buffed && !charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/MeleeAction()
	if(ranged_cooldown <= world.time && prob(30))
		OpenFire()
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/CanAllowThrough(atom/movable/mover, turf/target)
	if(charging && isliving(mover))
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/Shoot(atom/A)
	if(buffed || !isliving(A))
		return FALSE
	animate(src, alpha = alpha - 50, pixel_y = base_pixel_y + 25, layer = 6, time = 10)
	buffed = TRUE
	density = FALSE
	if(do_after(src, 2 SECONDS, target = src))
		ArialSupport()
	else
		visible_message(span_notice("[src] crashes to the ground."))
		apply_damage(100, RED_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	//return to the ground
	density = TRUE
	layer = initial(layer)
	buffed = FALSE
	alpha = initial(alpha)
	pixel_y = initial(pixel_y)
	base_pixel_y = initial(base_pixel_y)

	//from current location fly to the enemy and hit them. Utilizes some little helper abnormality code. Later on i should make them less accurate.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/ArialSupport()
	charging = TRUE
	var/turf/target_turf = get_turf(target)
	for(var/i=0 to 7)
		var/turf/wallcheck = get_step(src, get_dir(src, target_turf))
		if(!ClearSky(wallcheck))
			break
		var/mob/living/sweeptarget = locate(target) in wallcheck
		if(sweeptarget)
			SweepAttack(sweeptarget)
			break
		forceMove(wallcheck)
		SLEEP_CHECK_DEATH(0.5)
	charging = FALSE

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/SweepAttack(mob/living/sweeptarget)
	sweeptarget.visible_message(span_danger("[src] slams into [sweeptarget]!"), span_userdanger("[src] slams into you!"))
	sweeptarget.apply_damage(30, RED_DAMAGE, null, run_armor_check(null, RED_DAMAGE))
	playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 50, TRUE)
	if(sweeptarget.mob_size <= MOB_SIZE_HUMAN)
		DoKnockback(sweeptarget, src, get_dir(src, sweeptarget))
		shake_camera(sweeptarget, 4, 3)
		shake_camera(src, 2, 3)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/DoKnockback(atom/target, mob/thrower, throw_dir) //stolen from the knockback component since this happens only once
	if(!ismovable(target) || throw_dir == null)
		return
	var/atom/movable/throwee = target
	if(throwee.anchored)
		return
	if(QDELETED(throwee))
		return
	var/atom/throw_target = get_edge_target_turf(throwee, throw_dir)
	throwee.safe_throw_at(throw_target, 1, 1, thrower, gentle = TRUE)

//Has a very complex AI that generally functions as the brain of a army.
/mob/living/simple_animal/hostile/ordeal/steel_dusk
	name = "gene corp manager"
	desc = "A bug headed manager of the fallen Gene corp. Gene corp hoped that the enhanced sonic abilities of their managers would embolden their own while shattering the minds of their enemies."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "gcorp1"
	icon_living = "gcorp1"
	icon_dead = "gcorp_corpse"
	faction = list("Gene_Corp")
	death_message = "mutters something under their breath before collapsing."
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	ranged_cooldown_time = 15 SECONDS
	a_intent = INTENT_HELP
	maxHealth = 1300
	health = 1300
	melee_damage_lower = 40
	melee_damage_upper = 57
	vision_range = 12
	move_to_delay = 3
	ranged = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1)
	can_patrol = TRUE
	wander = FALSE
	patrol_cooldown_time = 1 MINUTES
	footstep_type = FOOTSTEP_MOB_SHOE
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_HARM)
	death_sound = 'sound/voice/hiss5.ogg'
	butcher_results = list(/obj/item/food/meat/slab/buggy = 3)
	silk_results = list(/obj/item/stack/sheet/silk/steel_simple = 4, /obj/item/stack/sheet/silk/steel_advanced = 2, /obj/item/stack/sheet/silk/steel_elegant = 1)
	//Last command issued
	var/last_command = 0
	//Delay on charge command
	var/chargecommand_cooldown = 0
	var/screech_cooldown = 0
	var/screech_windup = 5 SECONDS
	var/chargecommand_delay = 1 MINUTES
	//Delay on general commands
	var/command_cooldown = 0
	var/command_delay = 18 SECONDS
	//If this creature can act.
	var/can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/steel_dawn = 6,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon = 2,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 2
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE, TRUE)

	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/head_trophy/steel_head = 1)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Life()
	. = ..()
	if(health <= maxHealth*0.5 && stat != DEAD)
		adjustBruteLoss(-2)
		if(!target)
			adjustBruteLoss(-6)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/handle_automated_action()
	. = ..()
	if(command_cooldown < world.time && target && can_act && stat != DEAD)
		switch(last_command)
			if(1)
				Command(2) //always buff defense at start of battle
			else
				Command(pick(2,3))

/mob/living/simple_animal/hostile/ordeal/steel_dusk/patrol_select()
	if(prob(25))
		say("Nothin here. Lets move on.")
	..()

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Aggro()
	. = ..()
	if(chargecommand_cooldown <= world.time)
		Command(1)
		ranged_cooldown = world.time + (10 SECONDS)
		chargecommand_cooldown = world.time + chargecommand_delay
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/OpenFire()
	if(can_act && ranged_cooldown <= world.time)
		ManagerScreech()
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Move()
	if(!can_act)
		return FALSE
	return ..()

//used for attacks and commands. could possibly make this a modular spell or ability.
/mob/living/simple_animal/hostile/ordeal/steel_dusk/proc/Command(manager_order)
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_chitter.ogg', 60, TRUE)
	switch(manager_order)
		if(1)
			if(prob(20))
				say(pick("Lads we got a hostile!", "Shit, wake up troops hell just found us!", "I warn you, we dont die easy.", "Keep your cool and we can all get out of this alive!"))
			for(var/mob/living/simple_animal/hostile/ordeal/G in oview(9, src))
				if(istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn) && G.stat != DEAD && (!has_status_effect(/datum/status_effect/all_armor_buff) || !has_status_effect(/datum/status_effect/minor_damage_buff)))
					G.GiveTarget(target)
					G.TemporarySpeedChange(-1, 1 SECONDS)
			last_command = 1
		if(2)
			say("Hold fast!")
			for(var/mob/living/simple_animal/hostile/ordeal/G in oview(9, src))
				if((istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon) || istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn)) && G.stat != DEAD && !has_status_effect((/datum/status_effect/all_armor_buff || /datum/status_effect/minor_damage_buff)))
					G.apply_status_effect(/datum/status_effect/all_armor_buff)
			last_command = 2
		if(3)
			say("Onslaught!")
			for(var/mob/living/simple_animal/hostile/ordeal/G in oview(9, src))
				if((istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon) || istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn)) && G.stat != DEAD && !has_status_effect((/datum/status_effect/all_armor_buff || /datum/status_effect/minor_damage_buff)))
					G.apply_status_effect(/datum/status_effect/minor_damage_buff)
			last_command = 3
	command_cooldown = world.time + command_delay

/mob/living/simple_animal/hostile/ordeal/steel_dusk/proc/ManagerScreech()
	var/visual_overlay = mutable_appearance('icons/effects/effects.dmi', "blip")
	add_overlay(visual_overlay)
	can_act = FALSE
	if(!do_after(src, screech_windup, target = src))
		cut_overlay(visual_overlay)
		can_act = TRUE
		return
	can_act = TRUE
	cut_overlay(visual_overlay)
	playsound(loc, 'sound/effects/screech.ogg', 60, TRUE)
	new /obj/effect/temp_visual/screech(get_turf(src))
	for(var/mob/living/L in oview(10, src))
		if(!faction_check_mob(L))
			L.apply_damage(120, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
