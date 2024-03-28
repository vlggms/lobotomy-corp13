/mob/living/simple_animal/hostile/abnormality/steam
	name = "Steam Transport Machine"
	desc = "A bipedal, steam-powered automaton made of a brown, wood-like material with brass edges."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "steam"
	icon_living = "steam"
	portrait = "steam_transport_machine"
	maxHealth = 1600
	health = 1600
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

	var/gear = 0
	var/steam_damage = 5
	var/steam_venting = FALSE
	var/can_act = TRUE
	var/guntimer
	var/updatetimer

//Gear Shift - Most mechanics are determined by round time
/mob/living/simple_animal/hostile/abnormality/steam/proc/GearUpdate()
	var/new_gear = gear
	if(world.time >= 75 MINUTES) // Full facility expected
		new_gear = 4
	else if(world.time >= 60 MINUTES) // More than one ALEPH
		new_gear = 3
	else if(world.time >= 45 MINUTES) // Wowzer, an ALEPH?
		new_gear = 2
	else if(world.time >= 30 MINUTES) // Expecting WAW
		new_gear = 1
	else
		new_gear = 0
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
	ChangeResistances(list(
		RED_DAMAGE = (0.5 - (gear * 0.1)),
		WHITE_DAMAGE = (1 - (gear * 0.1)),
		BLACK_DAMAGE = (2 - (gear * 0.1)),
		PALE_DAMAGE = (1.5 - (gear * 0.1)),
	))
	var/oldhealth = maxHealth
	maxHealth = (1600 + (400 * gear))
	adjustBruteLoss(oldhealth - maxHealth) //Heals 400 health in a gear shift if it's already breached
	melee_damage_lower = (20 + (10 * gear))
	melee_damage_upper = (35 + (10 * gear))
	steam_damage = (5 + (3 * gear))
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
			H.apply_damage(steam_damage, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
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

/obj/projectile/steam
	name = "steam"
	icon_state = "smoke"
	hitsound = 'sound/machines/clockcult/steam_whoosh.ogg'
	damage = 4
	speed = 0.4
	damage_type = RED_DAMAGE
