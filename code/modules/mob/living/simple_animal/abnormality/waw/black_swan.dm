#define SWAN_UMBRELLA_COOLDOWN (30 SECONDS)
#define SWAN_UMBRELLA_DURATION (8 SECONDS)

/mob/living/simple_animal/hostile/abnormality/black_swan
	name = "Dream of Black Swan"
	gender = FEMALE
	desc = null
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "hiding"
	icon_living = "hiding"
	icon_dead = "blackswan_dream"
	var/icon_aggro = "blackswan_closed"
	portrait = "black_swan"
	del_on_death = FALSE
	maxHealth = 3000
	health = 3000
	ranged_cooldown_time = 10 SECONDS

	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	stat_attack = HARD_CRIT

	can_breach = TRUE
	can_buckle = FALSE
	can_patrol = TRUE
	ranged = TRUE
	vision_range = 14
	aggro_vision_range = 20
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 40
	threat_level = WAW_LEVEL
	attack_sound = 'sound/abnormalities/blackswan/sis_bash.ogg'
	attack_verb_continuous = "twacks"
	attack_verb_simple = "twack"
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 45, 50, 55),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 40, 45, 50),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 45, 50, 55),
	)
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	death_message = "weeps a green sludge while clutching her brooch."
	base_pixel_x = -16
	pixel_x = -16

	ego_list = list(
		/datum/ego_datum/weapon/swan,
		/datum/ego_datum/armor/swan,
	)
	gift_type =  /datum/ego_gifts/swan
	gift_message = "You feel exhausted but if you work a little harder, things will work themselves out."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	//family breach conditions
	var/insane_humans = 0
	var/dead_humans = 0
	var/abnos_breached = 0
	//brothers from left to right
	var/list/family_status = list(
		1 = FALSE,
		2 = FALSE,
		3 = FALSE,
		4 = FALSE,
		5 = FALSE,
	)
	//If is in closed or open mode
	var/beak_closed = FALSE
	var/can_act = TRUE
	var/umbrella_open = FALSE
	//cooldowns
	var/umbrella_cooldown = 0

	//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/cooldown/blackswan_umbrella)

/datum/action/cooldown/blackswan_umbrella
	name = "Black Swan's Umbrella"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "swan"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = SWAN_UMBRELLA_COOLDOWN

/datum/action/cooldown/blackswan_umbrella/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/black_swan))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/black_swan/swan = owner
	if(swan.IsContained()) // No more using cooldowns while contained
		return FALSE
	swan.OpenUmbrella()
	StartCooldown()
	return TRUE


/mob/living/simple_animal/hostile/abnormality/black_swan/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath)) // Hell
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE, PROC_REF(OnHumanInsane))
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/mob/living/simple_animal/hostile/abnormality/black_swan/PostSpawn()
	. = ..()
	update_icon_state()
	BrotherOverlays()

//Different descriptions for different forms.
/mob/living/simple_animal/hostile/abnormality/black_swan/examine(mob/user)
	. = ..()
	if(IsContained())
		. += "Six tall blonde humanoids draped in nettle clothing. They simply stand there, waiting."
	else
		. += "A young woman with the body of a black swan. Her eyes dart around looking for something."

/mob/living/simple_animal/hostile/abnormality/black_swan/Destroy()
	UnregisterSignal(SSdcs, list(COMSIG_GLOB_MOB_DEATH, COMSIG_GLOB_HUMAN_INSANE, COMSIG_GLOB_ABNORMALITY_BREACH))
	return ..()

/mob/living/simple_animal/hostile/abnormality/black_swan/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(family_status[5] != TRUE)
		family_status[5] = TRUE
		BrotherOverlays()
	return

/mob/living/simple_animal/hostile/abnormality/black_swan/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(family_status[4] != TRUE)
		family_status[4] = TRUE
		BrotherOverlays()
	return

/mob/living/simple_animal/hostile/abnormality/black_swan/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	cut_overlays()
	update_icon()
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.xeno_spawn)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	forceMove(teleport_target)
	playsound(get_turf(src), 'sound/abnormalities/blackswan/sis_transformation.ogg', 30, 0, 4)
	return

/mob/living/simple_animal/hostile/abnormality/black_swan/OnQliphothChange(mob/living/carbon/human/user)
	for(var/brother_guy = 1 to 5)
		if(family_status[brother_guy] == FALSE)
			family_status[brother_guy] = TRUE
			break
	BrotherOverlays()

//i think this only procs if the AI is on.
/mob/living/simple_animal/hostile/abnormality/black_swan/handle_automated_action()
	. = ..()
	if(!can_act || IsContained() || stat == DEAD)
		return
	if(target && !umbrella_open && umbrella_cooldown <= world.time)
		OpenUmbrella()

/mob/living/simple_animal/hostile/abnormality/black_swan/Life()
	. = ..()
	if(!beak_closed && health <= (maxHealth*0.5))
		beak_closed = TRUE
		update_icon_state()

/mob/living/simple_animal/hostile/abnormality/black_swan/update_icon_state()
	if(IsContained())
		icon_state = initial(icon_state)
	else if(stat == DEAD)
		icon_state = icon_dead
	else if(beak_closed)
		icon_state = icon_aggro
	else
		icon_state = "blackswan"
	if(umbrella_open && stat != DEAD) //in the future i should make these overlays by cutting out a swan shaped hole in the shield
		switch(beak_closed)
			if(TRUE)
				icon_state = "blackswan_closedr"
			if(FALSE)
				icon_state = "blackswan_r"
	icon_living = icon_state

/mob/living/simple_animal/hostile/abnormality/black_swan/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/black_swan/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/black_swan/bullet_act(obj/projectile/P) //umbrella shield code
	if(umbrella_open)
		if(is_A_facing_B(src,P.firer))
			if(P.reflectable != NONE)
				visible_message(span_userdanger("[src] deflects [P] with their umbrella!"))
				ReflectProjectile(P)
				return BULLET_ACT_FORCE_PIERCE
			return BULLET_ACT_BLOCK
	..()

/mob/living/simple_animal/hostile/abnormality/black_swan/OpenFire()
	if(!can_act)
		return
	else if(beak_closed && ranged_cooldown <= world.time) //redundant check if player controlled.
		Wail()
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/OpenUmbrella()
	if(umbrella_open)
		return
	playsound(get_turf(src), 'sound/abnormalities/blackswan/sis_swoop.ogg', 10, 0, 4)
	umbrella_open = TRUE
	umbrella_cooldown = world.time + SWAN_UMBRELLA_COOLDOWN
	update_icon_state()
	visible_message(span_userdanger("[src] opens up their umbrella!"), span_notice("You open up your umbrella"))
	addtimer(CALLBACK(src, PROC_REF(CloseUmbrella)), SWAN_UMBRELLA_DURATION)

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/CloseUmbrella()
	if(QDELETED(src))
		return
	umbrella_open = FALSE
	update_icon_state()

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/Wail()
	var/mutable_appearance/visual_overlay = mutable_appearance('icons/effects/effects.dmi', "blip")
	visual_overlay.pixel_x = -pixel_x
	visual_overlay.pixel_y = -pixel_y
	add_overlay(visual_overlay)
	can_act = FALSE
	if(do_after(src, 2 SECONDS, target = src))
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
		for(var/mob/living/L in orange(9, src))
			if(isabnormalitymob(L))
				var/mob/living/simple_animal/hostile/abnormality/maybe_brothers = L
				if(maybe_brothers.IsContained())
					maybe_brothers.datum_reference.qliphoth_change(-1)
					continue
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(70, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		playsound(get_turf(src), 'sound/abnormalities/blackswan/sis_roar.ogg', 30, 0, 4)
	cut_overlay(visual_overlay)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/BrotherOverlays()
	if(!IsContained())
		return FALSE
	cut_overlays()
	var/icon_type
	var/brothers_harmed = 0
	for(var/brother_position = 1 to 5)
		if(family_status[brother_position] != TRUE)
			icon_type = "blackswan_bro[brother_position]"
		else
			icon_type = "blackswan_bro[brother_position]a"
			brothers_harmed += 1
		switch(brother_position)
			if(1, 5)
				brother_position = layer + 0.1
			if(2, 4)
				brother_position = layer + 0.2
			else
				brother_position = layer + 0.3
		var/mutable_appearance/brother_overlay = mutable_appearance(icon, icon_type, brother_position)
		add_overlay(brother_overlay)
	//breach if all brothers are harmed
	if(brothers_harmed >= 5)
		BreachEffect()

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/OnAbnoBreach()
	SIGNAL_HANDLER
	if(!IsContained() || family_status[3] == TRUE) // If it's breaching right now
		return FALSE
	abnos_breached += 1
	if(abnos_breached > 2)
		family_status[3] = TRUE
		BrotherOverlays()
		abnos_breached = 0
		UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained() || family_status[1] == TRUE) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	dead_humans += 1
	if(dead_humans >= 2)
		family_status[1] = TRUE
		BrotherOverlays()
		dead_humans = 0
		UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/OnHumanInsane(datum/source, mob/living/carbon/human/H, attribute)
	SIGNAL_HANDLER
	if(!IsContained() || family_status[2] == TRUE)
		return FALSE
	if(!H.mind) // That wasn't a player at all...
		return FALSE
	if(H.z != z)
		return FALSE
	insane_humans += 1
	if(insane_humans >= 2)
		family_status[2] = TRUE
		BrotherOverlays()
		insane_humans = 0
		UnregisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/black_swan/proc/ReflectProjectile(obj/projectile/P) //reflection code from human_defense.dm
	if(P.starting)
		var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
		var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
		// redirect the projectile
		P.firer = src
		P.preparePixelProjectile(locate(clamp(new_x, 1, world.maxx), clamp(new_y, 1, world.maxy), z), src)

#undef SWAN_UMBRELLA_COOLDOWN
#undef SWAN_UMBRELLA_DURATION
