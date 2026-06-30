/mob/living/simple_animal/hostile/ordeal/crimson_clown
	name = "cheers for the start"
	desc = "A tiny humanoid creature in jester's attire."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "crimson_clown"
	icon_living = "crimson_clown"
	icon_dead = "crimson_clown_dead"
	faction = list("crimson_ordeal")
	maxHealth = 80
	health = 80
	speed = 1
	density = FALSE
	search_objects = 3
	wanted_objects = list(/obj/machinery/computer/abnormality)
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL

	/// When it hits console 10 times - reduce qliphoth, PE, and teleport
	var/panel_attack_counter = 0
	var/teleporting = FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!target && prob(25))
		TeleportAway()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/CanAttack(atom/the_target)
	if(istype(the_target, /obj/machinery/containment_panel))
		var/obj/machinery/containment_panel/CP = the_target
		if(!CP.linked_console)
			return FALSE
		var/obj/machinery/computer/abnormality/CA = CP.linked_console
		if(CA.meltdown || !CA.datum_reference || !CA.datum_reference.current || !CA.datum_reference.current.IsContained())
			return FALSE
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/AttackingTarget(atom/attacked_target)
	if(istype(attacked_target, /obj/machinery/containment_panel))
		var/obj/machinery/containment_panel/CP = attacked_target
		var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(CP))
		dir = dir_to_target
		do_attack_animation(get_step(src, dir_to_target))
		if(panel_attack_counter < 10)
			panel_attack_counter += 1
			visible_message(span_warning("[src] hits at [CP]!"))
			playsound(get_turf(CP), "sound/machines/terminal_button0[rand(1,8)].ogg", 75, 1)
			changeNext_move(CLICK_CD_MELEE * 2)
		else
			panel_attack_counter = 0
			visible_message(span_warning("[CP]'s screen produces an error!"))
			playsound(get_turf(CP), 'sound/machines/terminal_error.ogg', 75, 1)
			CP.linked_console.datum_reference.qliphoth_change(-1, src)
			CP.linked_console.datum_reference.stored_boxes = floor(CP.linked_console.datum_reference.stored_boxes * 0.7) //My fucking boxes
			LoseTarget()
			TeleportAway()
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/death(gibbed)
	animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
	addtimer(CALLBACK(src, PROC_REF(DeathExplosion), ordeal_reference), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/TeleportAway()
	if(teleporting)
		return
	if(stat)
		return
	teleporting = TRUE
	var/list/potential_panels = list()
	for(var/obj/machinery/computer/abnormality/CA in GLOB.lobotomy_devices)
		if(!CanTeleportTo(CA))
			continue
		if(!CA.linked_panel)
			continue
		potential_panels += CA.linked_panel
	if(LAZYLEN(potential_panels))
		var/obj/machinery/containment_panel/teleport_panel = pick(potential_panels)
		var/turf/T = get_step(get_turf(teleport_panel), SOUTH)
		var/matrix/init_transform = transform
		animate(src, transform = transform*0.01, time = 5, easing = BACK_EASING)
		SLEEP_CHECK_DEATH(5)
		panel_attack_counter = 0
		forceMove(T)
		target = teleport_panel
		animate(src, transform = init_transform, time = 5, easing = BACK_EASING)
	teleporting = FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/CanTeleportTo(obj/machinery/computer/abnormality/CA)
	if(!CA.can_meltdown || CA.meltdown || !CA.datum_reference || !CA.datum_reference.current || !CA.datum_reference.current.IsContained())
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	for(var/mob/living/L in view(2, src))
		if(!faction_check_mob(L))
			L.deal_damage(10, RED_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
	gib()
