/mob/living/simple_animal/hostile/abnormality/headless_ichthys
	name = "Headless Ichthys"
	desc = "A giant, headless sea creature."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "headless_ichthys"
	icon_living = "headless_ichthys"
	icon_dead = "headless_ichthys"
	portrait = "headless_icthys"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 1200
	health = 1200
	ranged = TRUE
	attack_verb_continuous = "slaps"
	attack_verb_simple = "slap"
	attack_sound = 'sound/abnormalities/ichthys/slap.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 20
	melee_damage_upper = 35
	rapid_melee = 1
	melee_queue_distance = 2
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	speak_emote = list("rasps", "growls", "gurgles")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	del_on_death = FALSE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 55, 55, 50, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, -30, -60, -90),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 55, 55, 50, 45),
		ABNORMALITY_WORK_REPRESSION = list(35, 40, 40, 35, 35),
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/fluid_sac,
		/datum/ego_datum/armor/fluid_sac,
	)
	gift_type =  /datum/ego_gifts/fluid_sac
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/can_act = TRUE
	var/jump_cooldown = 0
	var/jump_cooldown_time = 8 SECONDS
	var/jump_damage = 50
	var/jump_sound = 'sound/abnormalities/ichthys/hammer2.ogg'
	var/jump_aoe = 2
	var/cannon_cooldown = 0
	var/cannon_cooldown_time = 30 SECONDS
	var/enraged = FALSE
// Blood beam vars ripped off of Queen of hatred
	var/beam_damage = 25
	var/beam_maximum_ticks = 20
	var/datum/beam/current_beam

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/IchthysJump,
		/datum/action/innate/abnormality_attack/BloodCannon,
	)

// Player-Controlled code
/datum/action/innate/abnormality_attack/IchthysJump
	name = "Pressing Sac"
	icon_icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	button_icon_state = "_HE"
	chosen_message = span_colossus("You will now jump with your next attack.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/BloodCannon
	name = "Blood Cannon"
	icon_icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	button_icon_state = "heart"
	chosen_message = span_colossus("You will now fire a blood cannon.")
	chosen_attack_num = 2

// Attacks
/mob/living/simple_animal/hostile/abnormality/headless_ichthys/proc/IchthysJump(mob/living/target)
	if(!istype(target) || !can_act)
		return
	var/dist = get_dist(target, src)
	if(dist > 1 && jump_cooldown < world.time)
		jump_cooldown = world.time + jump_cooldown_time
		can_act = FALSE
		icon_state = enraged ? "headless_ichthys_charging_enraged" : "headless_ichthys_charging"
		SLEEP_CHECK_DEATH(0.25 SECONDS)
		animate(src, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		src.pixel_z = 16
		playsound(src, 'sound/abnormalities/ichthys/jump.ogg', 50, FALSE, 4)
		var/turf/target_turf = get_turf(target)
		SLEEP_CHECK_DEATH(1 SECONDS)
		forceMove(target_turf) //look out, someone is rushing you!
		playsound(src, jump_sound, 50, FALSE, 4)
		animate(src, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		src.pixel_z = 0
		SLEEP_CHECK_DEATH(0.1 SECONDS)
		icon_state = enraged ? "headless_ichthys_enraged" : "headless_ichthys"
		for(var/turf/T in view(jump_aoe, src))
			var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
			FX.color = "#b52e19"
			for(var/mob/living/L in T)
				if(faction_check_mob(L))
					continue
				L.apply_damage(jump_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				if(L.health < 0)
					L.gib()
		SLEEP_CHECK_DEATH(0.5 SECONDS)
		can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/proc/BloodCannon(target)
	if(cannon_cooldown > world.time)
		return FALSE
	if(!can_act)
		return FALSE
	if(!target)
		return FALSE
	cannon_cooldown = world.time + cannon_cooldown_time
	icon_state = enraged ? "headless_ichthys_charging_enraged" : "headless_ichthys_charging"
	var/turf/target_turf = get_turf(target)
	face_atom(target_turf)
	var/turf/my_turf = get_turf(src)
	can_act = FALSE
	playsound(src, "sound/abnormalities/ichthys/charge.ogg", 50, FALSE)
	var/turf/TT = get_ranged_target_turf_direct(my_turf, target_turf, 15)
	SLEEP_CHECK_DEATH(2 SECONDS) //Chargin' mah lazor
	icon_state = enraged ? "headless_ichthys_firing_enraged" : "headless_ichthys_firing"
	var/list/target_line = getline(my_turf, TT) //gets a line 15 tiles away
	for(var/turf/TF in target_line) //checks if that line has anything in the way, resets TT as the new beam end location
		if(TF.density)
			TT = TF
			break
	var/list/hit_line = getline(my_turf, TT) //old target_line is discarded with hit_line which respects walls
	for(var/turf/TF in hit_line) //spawns blood effects, separate loop because we only want to do it once
		if(TF.density)
			break
		var/obj/effect/decal/cleanable/blood/B  = new(TF)
		B.bloodiness = 100
	current_beam = my_turf.Beam(TT, "qoh")
	playsound(src, "sound/abnormalities/ichthys/blast.ogg", 50, FALSE)
	for(var/h = 1 to beam_maximum_ticks) //from this point on it's basically the same as queenie's but with balance adjustments
		var/list/already_hit = list()
		current_beam.visuals.color = COLOR_RED
		for(var/turf/TF in hit_line)
			if(TF.density)
				break
			for(var/mob/living/L in range(1, TF))
				if(L.status_flags & GODMODE)
					continue
				if(L == src) //stop hitting yourself
					continue
				if(L in already_hit)
					continue
				if(L.stat == DEAD)
					continue
				if(faction_check_mob(L))
					continue
				if(!(is_A_facing_B(src,L))) //so it doesn't hit people behind the mob
					continue
				already_hit += L
				var/truedamage = ishuman(L) ? beam_damage : beam_damage/2 //half damage dealt to nonhumans
				L.apply_damage(truedamage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		SLEEP_CHECK_DEATH(1.71)
	QDEL_NULL(current_beam)
	SLEEP_CHECK_DEATH(4 SECONDS) //Rest after laser beam
	if(health <= (maxHealth * 0.3))
		Enrage()
	icon_state = enraged ? "headless_ichthys_enraged" : "headless_ichthys"
	can_act = TRUE

// Breach Stuff
/mob/living/simple_animal/hostile/abnormality/headless_ichthys/AttackingTarget()
	if(!can_act)
		return
	if(jump_cooldown <= world.time && prob(10) && !client)
		IchthysJump(target)
		return
	if(cannon_cooldown <= world.time && prob(5) && !client)
		BloodCannon(target)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/OpenFire()
	if(!can_act)
		return FALSE
	if(client)
		switch(chosen_attack)
			if(1)
				IchthysJump(target)
			if(2)
				BloodCannon(target)
		return

	var/dist = get_dist(target, src)
	if(jump_cooldown <= world.time)
		var/chance_to_jump = 25
		if(dist > 3)
			chance_to_jump = 100
		if(prob(chance_to_jump))
			IchthysJump(target)
			return

	if(cannon_cooldown <= world.time && dist > 1)
		BloodCannon(target)
		return

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/proc/Enrage() //gains 25% more damage dealt and shorter cooldowns
	if(enraged)
		return
	src.visible_message(span_userdanger("[src] looks angry!"))
	enraged = TRUE
	icon_state = "[icon_state]" + "_enraged"
	melee_damage_lower = 25
	melee_damage_upper = 44
	jump_cooldown_time = 6 SECONDS
	jump_damage = 62
	cannon_cooldown_time = 22.5 SECONDS
	beam_damage = 31
	attack_sound = 'sound/abnormalities/ichthys/hardslap.ogg'
	jump_sound = 'sound/abnormalities/ichthys/hammer3.ogg'
	jump_aoe = 3
	return

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/face_atom() //VERY important; prevents spinning while firing bloodcannon
	if(!can_act)
		return
	..()

// Work stuff
/mob/living/simple_animal/hostile/abnormality/headless_ichthys/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()
	GiveTarget(user)
	AddComponent(/datum/component/knockback, 2, FALSE, TRUE)
	cannon_cooldown = world.time + cannon_cooldown_time //Can't fire it right away.

/mob/living/simple_animal/hostile/abnormality/headless_ichthys/death(gibbed)
	playsound(src, 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 60, 1)
	animate(src, transform = matrix()*0.6,time = 0)
	icon_state = "headless_ichthys"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	QDEL_NULL(current_beam)
	update_icon_state()
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()
