/mob/living/simple_animal/hostile/abnormality/cube
	name = "THE CUBE"
	desc = "A strange floating cube."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "cube"
	icon_living = "cube"
	portrait = "cube"
	maxHealth = 50
	health = 50
	is_flying_animal = TRUE
	threat_level = TETH_LEVEL
	move_to_delay = 6
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 100,
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = 30,
	)
	work_damage_amount = 4
	work_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear
	var/pulse_cooldown
	var/pulse_cooldown_time = 3 SECONDS
	var/pulse_damage = 6

/mob/living/simple_animal/hostile/abnormality/cube/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)
	addtimer(CALLBACK(src, PROC_REF(die)), 60 SECONDS)

/mob/living/simple_animal/hostile/abnormality/cube/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/cube/proc/die()
	QDEL_NULL(src)

/mob/living/simple_animal/hostile/abnormality/cube/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		WhitePulse()

/mob/living/simple_animal/hostile/abnormality/cube/AttackingTarget(atom/attacked_target)
	return

/mob/living/simple_animal/hostile/abnormality/cube/proc/WhitePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/magic/disable_tech.ogg', 50, FALSE, 4)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage(pulse_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

