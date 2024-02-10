//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/clouded_monk
	name = "Clouded Monk"
	desc = "An abnormality in the form of a tall Buddhist monk wearing a kasa hat."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "cloudedmonk"
	icon_living = "cloudedmonk"
	var/icon_aggro = "pretamonk"
	icon_dead = "pretamonk"
	portrait = "clouded_monk"
	maxHealth = 2500
	health = 2500
	rapid_melee = 2
	ranged = TRUE
	damage_coeff = list(BRUTE = 1.0, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 30
	melee_damage_upper = 45
	melee_damage_type = RED_DAMAGE
	see_in_dark = 10
	stat_attack = HARD_CRIT
	move_to_delay = 4
	threat_level = WAW_LEVEL
	attack_sound = 'sound/abnormalities/clouded_monk/monk_attack.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	can_breach = TRUE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(20, 20, 55, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 45, 45, 45, 45),
		ABNORMALITY_WORK_REPRESSION = list(40, 20, 40, 40, 40),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/amrita,
		/datum/ego_datum/armor/amrita,
	)
	gift_type =  /datum/ego_gifts/amrita
	gift_message = "Anyone can become a Buddha by washing away the anguish and delusion in their heart."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	var/datum/looping_sound/cloudedmonk_ambience/soundloop
	var/charging = FALSE
	var/charge_ready = FALSE
	var/dash_num = 25
	var/dash_cooldown = 0
	var/dash_cooldown_time = 6 SECONDS
	var/list/been_hit = list() // Don't get hit twice.
	var/deathcount
	var/heal_amount = 250
	var/eaten = FALSE
	var/damage_taken

//init
/mob/living/simple_animal/hostile/abnormality/clouded_monk/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath)) // Hell
	soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/clouded_monk/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/OnMobDeath(datum/source, mob/living/died, gibbed) //stolen from big bird
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	deathcount++
	if(deathcount >= 2)
		datum_reference.qliphoth_change(-1) // Two deaths reduces it compared to base 10
		deathcount = 0
	return TRUE

/* Eventually there needs to be code here that causes it to breach when Yin gets too close. Yin is not implemented at this time. */
//work code
/mob/living/simple_animal/hostile/abnormality/clouded_monk/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/clouded_monk/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(25))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/clouded_monk/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		user.adjustSanityLoss(-30) // It's healing
		to_chat(user, span_nicegreen("[src] restores your SP with calming words."))
	return

//breach code
/mob/living/simple_animal/hostile/abnormality/clouded_monk/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= 200 && !charge_ready)
		charge_ready = TRUE
		damage_taken = 0

/mob/living/simple_animal/hostile/abnormality/clouded_monk/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	soundloop.start()
	playsound(src, 'sound/abnormalities/clouded_monk/howl.ogg', 50, 1)
	playsound(src, 'sound/abnormalities/clouded_monk/transform.ogg', 50, 1)
	icon_state = icon_aggro
	desc = "A monk that turned into a demon. It resembles a preta from legends..."
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/clouded_monk/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/clouded_monk/AttackingTarget()
	if(charging)
		return
	if(dash_cooldown <= world.time && prob(10) && !client && charge_ready)
		PrepCharge(target)
		return
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.health < 0)
		H.gib()
		playsound(src, "sound/abnormalities/clouded_monk/eat.ogg", 75, 1)
		adjustBruteLoss(-heal_amount)
	return

/mob/living/simple_animal/hostile/abnormality/clouded_monk/OpenFire()
	if(client && charge_ready)
		switch(chosen_attack)
			if(1)
				PrepCharge(target)
		return

	if(dash_cooldown <= world.time && charge_ready)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			PrepCharge(target)

//dash code
/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/PrepCharge(target)
	if(charging || dash_cooldown > world.time)
		return
	icon_state = "pretarage"
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	dash_num = (get_dist(src, target) + 3)
	addtimer(CALLBACK(src, PROC_REF(Charge), dir_to_target, 0), 2 SECONDS)
	charge_ready = FALSE
	if(!eaten) //different sfx before and after eating someone
		playsound(src, 'sound/abnormalities/clouded_monk/monk_cast.ogg', 100, 1)
		return
	playsound(src, 'sound/abnormalities/clouded_monk/eat_groggy.ogg', 100, 1)

/mob/living/simple_animal/hostile/abnormality/clouded_monk/proc/Charge(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
		break
	for(var/obj/machinery/door/D in T.contents)
		if(!D.CanAStarPass(null))
			stop_charge = TRUE
			break
		if(D.density)
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open), 2)
	if(stop_charge)
		charging = FALSE
		icon_state = icon_aggro
		return
	forceMove(T)
	playsound(src, 'sound/abnormalities/clouded_monk/monk_groggy.ogg', 150, 1)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		visible_message(span_boldwarning("[src] bites [L]!"))
		to_chat(L, span_userdanger("[src] takes a bite out of you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		L.apply_damage(350,RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		been_hit += L
		playsound(L, "sound/abnormalities/clouded_monk/monk_bite.ogg", 75, 1)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.health < 0)
			H.gib()
			playsound(src, "sound/abnormalities/clouded_monk/eat.ogg", 75, 1)
			adjustBruteLoss(-heal_amount)
			times_ran = dash_num //stop the charge, we got the meats!
			if(!eaten)
				eaten = TRUE
	addtimer(CALLBACK(src, PROC_REF(Charge), move_dir, (times_ran + 1)), 1)
