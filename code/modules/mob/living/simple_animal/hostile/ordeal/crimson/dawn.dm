/mob/living/simple_animal/hostile/ordeal/crimson_clown
	name = "cheers for the start"
	desc = "A tiny humanoid creature in jester's attire."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "crimson_clown"
	icon_living = "crimson_clown"
	icon_dead = "crimson_clown_dead"
	faction = list("crimson_ordeal")
	maxHealth = 35
	health = 35
	speed = 1
	density = FALSE
	search_objects = 3
	wanted_objects = list(/obj/machinery/computer/abnormality)
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 2)
	blood_volume = BLOOD_VOLUME_NORMAL

	/// When it hits console 12 times - reduce qliphoth and teleport
	var/console_attack_counter = 0
	var/teleporting = FALSE
	var/next_escape_health_mod = 0.9

/mob/living/simple_animal/hostile/ordeal/crimson_clown/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!target && prob(25))
		TeleportAway()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/CanAttack(atom/the_target)
	if(istype(the_target, /obj/machinery/computer/abnormality))
		var/obj/machinery/computer/abnormality/CA = the_target
		if(CA.meltdown || !CA.datum_reference || !CA.datum_reference.current || !CA.datum_reference.qliphoth_meter)
			return FALSE
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/AttackingTarget(atom/attacked_target)
	if(istype(attacked_target, /obj/machinery/computer/abnormality))
		var/obj/machinery/computer/abnormality/CA = attacked_target
		if(console_attack_counter < 12)
			console_attack_counter += 1
			visible_message(span_warning("[src] hits [CA]'s buttons at random!"))
			playsound(get_turf(CA), "sound/machines/terminal_button0[rand(1,8)].ogg", 50, 1)
			changeNext_move(CLICK_CD_MELEE * 2)
		else
			console_attack_counter = 0
			visible_message(span_warning("[CA]'s screen produces an error!"))
			playsound(get_turf(CA), 'sound/machines/terminal_error.ogg', 50, 1)
			CA.datum_reference.qliphoth_change(-1, src)
			LoseTarget()
			TeleportAway()
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_clown/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(!stat && health < maxHealth * next_escape_health_mod)
		next_escape_health_mod -= 0.3
		LoseTarget()
		TeleportAway()

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
	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/CA in GLOB.lobotomy_devices)
		if(!CanTeleportTo(CA))
			continue
		potential_computers += CA
	if(LAZYLEN(potential_computers))
		var/obj/machinery/computer/abnormality/teleport_computer = pick(potential_computers)
		var/turf/T = get_step(get_turf(teleport_computer), SOUTH)
		var/matrix/init_transform = transform
		animate(src, transform = transform*0.01, time = 5, easing = BACK_EASING)
		SLEEP_CHECK_DEATH(5)
		console_attack_counter = 0
		forceMove(T)
		target = teleport_computer
		animate(src, transform = init_transform, time = 5, easing = BACK_EASING)
	teleporting = FALSE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/CanTeleportTo(obj/machinery/computer/abnormality/CA)
	if(!CA.can_meltdown || CA.meltdown || !CA.datum_reference || !CA.datum_reference.current || !CA.datum_reference.qliphoth_meter)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_clown/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	for(var/mob/living/L in view(5, src))
		if(!faction_check_mob(L))
			L.apply_damage(10, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
	gib()
