/mob/living/simple_animal/hostile/abnormality/steam
	name = "Steam Transport Machine"
	desc = "A bipedal, steam-powered automaton made of a brown, wood-like material with brass edges."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "steam"
	icon_living = "steam"
	icon_dead = "steammachine_egg"
	core_icon = "steammachine_egg"
	portrait = "steam_transport_machine"
	del_on_death = FALSE
	maxHealth = 1600
	health = 1600
	blood_volume = 0
	ranged = TRUE
	attack_sound = 'sound/abnormalities/steam/attack.ogg'
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1.5)
	speak_emote = list("bellows")
	pixel_x = -16
	can_breach = TRUE
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 5
	melee_damage_lower = 20
	melee_damage_upper = 35
	melee_damage_type = RED_DAMAGE
	threat_level = HE_LEVEL
	start_qliphoth = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_amount = 9
	work_damage_type = RED_DAMAGE

	ranged = TRUE
	rapid = 5
	rapid_fire_delay = 1
	ranged_cooldown_time = 50
	projectiletype = /obj/projectile/steam
	projectilesound = 'sound/abnormalities/steam/steamfire.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/nixie,
		/datum/ego_datum/armor/nixie,
	)
	gift_type =  /datum/ego_gifts/nixie
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "It carries heavy objects without a word. <br>\
		As it does its work, the number on the electronic display seems to update. <br>\
		Machines exist for a purpose. <br>\
		You feel like you should give it an order."
	observation_choices = list(
		"Order it to carry luggage" = list(TRUE, "It lifts a nearby object to carry it from left to right. <br>\
			The count on its body went up by 1. <br>\
			Just as you started to wonder if that was it, the machine replaced one of its vacuum tubes with a new one. <br>\
			It presented the old one to you, and naturally, you accepted."),
		"Order it to do nothing" = list(FALSE, "A purposeless machine is bound to lose the meaning of its existence, even if it is functional. <br>\
			A machine whose purpose is to do nothing will do whatever it takes to achieve its directive. <br>\
			With a loud boiling noise, the machine’s body begins to heat, expelling hot steam. <br>\
			Seeing it glow a dangerous-looking hue, you quickly escaped the room."),
	)

	var/gear = 0
	var/steam_damage = 5
	var/steam_venting = FALSE
	var/can_act = TRUE
	var/guntimer
	var/updatetimer

//Gear Shift - Most mechanics are determined by round time
/mob/living/simple_animal/hostile/abnormality/steam/proc/GearUpdate()
	var/new_gear = gear
	var/facility_full_percentage = 0
	if(SSabnormality_queue.spawned_abnos) // dont divide by 0
		facility_full_percentage = 100 * (SSabnormality_queue.spawned_abnos / SSabnormality_queue.rooms_start)
	// how full the facility is, from 0 abnormalities out of 24 cells being 0% and 24/24 cells being 100%
	switch(facility_full_percentage)
		if(0 to 49) // Expecting Hes and Teths still
			new_gear = 1
		if(50 to 69)  // Expecting WAW
			new_gear = 1
		if(70 to 79) // Wowzer, an ALEPH?
			new_gear = 2
		if(80 to 99) // More than one ALEPH
			new_gear = 3
		if(100) // Full facility expected
			new_gear = 4
	if(gear != new_gear)
		gear = new_gear
		ClankSound()
		UpdateStats()
	if(gear < 4)
		updatetimer = addtimer(CALLBACK(src, PROC_REF(GearUpdate)), 1 MINUTES, TIMER_STOPPABLE) //Let's just call this every minute
	return

/mob/living/simple_animal/hostile/abnormality/steam/proc/ClankSound()
	set waitfor = FALSE
	playsound(src.loc, 'sound/abnormalities/clock/clank.ogg', 75, TRUE)
	SLEEP_CHECK_DEATH(10)
	playsound(src.loc, 'sound/abnormalities/clock/turn_on.ogg', 75, TRUE)

/mob/living/simple_animal/hostile/abnormality/steam/proc/UpdateStats()
	src.set_light(3, (gear * 2), "D4FAF37")
	if(SSmaptype.maptype == "limbus_labs")
		ChangeResistances(list(
			RED_DAMAGE = (1 - (gear * 0.1)),
			WHITE_DAMAGE = (1 - (gear * 0.1)),
			BLACK_DAMAGE = (2 - (gear * 0.1)),
			PALE_DAMAGE = (1.5 - (gear * 0.1)),
		))
		melee_damage_lower = (20 + (4 * gear))
		melee_damage_upper = (35 + (4 * gear))
		steam_damage = (5 + (1.5 * gear))
	else
		ChangeResistances(list(
			RED_DAMAGE = (0.5 - (gear * 0.1)),
			WHITE_DAMAGE = (1 - (gear * 0.1)),
			BLACK_DAMAGE = (2 - (gear * 0.1)),
			PALE_DAMAGE = (1.5 - (gear * 0.1)),
		))
		melee_damage_lower = (20 + (10 * gear))
		melee_damage_upper = (35 + (10 * gear))
		steam_damage = (5 + (3 * gear))
	var/oldhealth = maxHealth
	maxHealth = (1600 + (400 * gear))
	adjustBruteLoss(oldhealth - maxHealth) //Heals 400 health in a gear shift if it's already breached
	work_damage_amount = (9 + (2 * gear))
	ranged_cooldown_time = (40 - (5 * gear))
	start_qliphoth = (max(1,(4 - gear)))
	if(datum_reference.qliphoth_meter > start_qliphoth) //we want to bring the qliphoth down to the new maximum
		if(datum_reference.qliphoth_meter == 4)
			datum_reference.qliphoth_change(-min(gear,3))
		else
			datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/steam/PostSpawn()
	. = ..()
	GearUpdate()

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/steam/AttemptWork(mob/living/carbon/human/user, work_type)
	return ..()

/mob/living/simple_animal/hostile/abnormality/steam/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/steam/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

//Responds better to work performed earlier in the round
/mob/living/simple_animal/hostile/abnormality/steam/WorkChance(mob/living/carbon/human/user, chance)
	var/chance_multiplier = 1
	chance_multiplier -= (gear * 0.1)
	return chance * chance_multiplier

//Breach
/mob/living/simple_animal/hostile/abnormality/steam/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(!steam_venting)
		return
	SpawnSteam() //Periodically spews out damaging fog while breaching

/mob/living/simple_animal/hostile/abnormality/steam/proc/SpawnSteam()
	playsound(get_turf(src), 'sound/abnormalities/steam/exhale.ogg', 75, 0, 8)
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(2, target_turf))
		if(prob(30))
			continue
		new /obj/effect/temp_visual/palefog(T)
		for(var/mob/living/H in T)
			if(faction_check_mob(H))
				continue
			H.deal_damage(steam_damage, RED_DAMAGE)
	adjustBruteLoss(10) //Take some damage every time steam is vented

/mob/living/simple_animal/hostile/abnormality/steam/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(steam_venting)
		return
	if(health <= (maxHealth * 0.3))
		steam_venting = TRUE
		visible_message(span_warning("[src]'s engine explodes!"), span_boldwarning("Your steam engine malfunctions!"))
		new /obj/effect/temp_visual/explosion(get_turf(src))
		playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/explosion.ogg', 50, FALSE, 8)
		playsound(get_turf(src), 'sound/abnormalities/steam/steambreak.ogg', 125, FALSE)
		rapid = 3

/mob/living/simple_animal/hostile/abnormality/steam/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/steam/AttackingTarget()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/steam/OpenFire()
	if(get_dist(src, target) > 4)
		return
	. = ..()
	can_act = FALSE
	guntimer = addtimer(CALLBACK(src, PROC_REF(startMoving)), (10), TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/abnormality/steam/proc/startMoving()
	can_act = TRUE
	deltimer(guntimer)

/mob/living/simple_animal/hostile/abnormality/steam/Moved()
	. = ..()
	if(!(status_flags & GODMODE)) // Whitaker nerf
		playsound(get_turf(src), 'sound/abnormalities/steam/step.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/steam/death(gibbed)
	. = ..()
	if(guntimer)
		deltimer(guntimer)
	if(updatetimer)
		deltimer(updatetimer)
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	pixel_x = -16
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)

/obj/projectile/steam
	name = "steam"
	icon_state = "smoke"
	hitsound = 'sound/machines/clockcult/steam_whoosh.ogg'
	damage = 4
	speed = 0.4
	damage_type = RED_DAMAGE
