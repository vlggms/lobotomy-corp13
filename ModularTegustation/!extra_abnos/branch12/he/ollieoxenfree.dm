/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree
	name = "Ollieoxenfree"
	desc = "The child asked 'How is it plagiarism if it was my work all along'"
	icon = 'ModularTegustation/Teguicons/branch12/48x64.dmi'
	icon_state = "ollie"
	icon_living = "ollie"
	del_on_death = TRUE
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	maxHealth = 1000
	health = 1000

	ranged = TRUE
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 3
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.2)
	melee_damage_lower = 20
	melee_damage_upper = 24
	melee_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 30, 40, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(20, 20, 20, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 70, 70, 70),
		ABNORMALITY_WORK_REPRESSION = list(20, 20, 10, 10, 10),
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/plagiarism,
		/datum/ego_datum/armor/branch12/plagiarism,
	)

	var/list/ideas_stolen = list() //affects what abilities it has on breach
	var/list/potential_ideas = list("skitter", "hallucination", "lifesteal", "blindness", "randomdamage", "flametile", "knockdown", "pulse", "bleed", "confusion")
	var/dashready = TRUE
	var/pulse_cooldown
	var/pulse_cooldown_time = 3 SECONDS
	var/pulse_damage = 20

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		datum_reference.qliphoth_change (-1)

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20) && work_type != ABNORMALITY_WORK_ATTACHMENT)
		datum_reference.qliphoth_change(-1)


/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		if(length(potential_ideas))
			ideas_stolen += pick_n_take(potential_ideas)
			//health += 100
			//maxHealth += 100

//from here on, abilities it can gain on breach
/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/AttackingTarget(atom/attacked_target) //checking it's ideas and executing them
	..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	for(var/z in ideas_stolen)
		if(z == "hallucination") //from dangle
			H.hallucination += 10
		if(z == "blindness") //kill their eyes
			H.adjust_blurriness(15)
		if(z == "confusion") //kill their legs
			H.set_confusion(10)
		if(z == "bleed") //bleed
			H.apply_lc_bleed(30)
		if(z == "knockdown") //knock them down, from smile without the weapon drop
			H.Knockdown(20)
		if(z == "lifesteal") //heal by the lowest damage it can do
			adjustBruteLoss(-melee_damage_lower)

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/proc/Skitter()
	visible_message(span_warning("[src] Skitters faster!"), span_notice("you hear the patter of hundreds of 'original' feet"))
	var/duration = 3 SECONDS
	TemporarySpeedChange(-2, duration)
	dashready = FALSE
	addtimer(CALLBACK(src, PROC_REF(dashreset)), 10 SECONDS)

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/OpenFire(atom/A)
	if("skitter" in ideas_stolen)
		if(get_dist(src, target) >= 2 && dashready)
			Skitter()

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/proc/dashreset()
	dashready = TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/CanAttack(atom/the_target)
	if("randomdamage" in ideas_stolen)
		melee_damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/proc/WhitePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/abnormalities/rudolta/throw.ogg', 50, FALSE, 4)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, WHITE_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

/mob/living/simple_animal/hostile/abnormality/branch12/ollieoxenfree/Move()
	..()
	if("flametile" in ideas_stolen)
		for(var/turf/open/T in range(1, src))
			if(locate(/obj/structure/turf_fire) in T)
				for(var/obj/structure/turf_fire/floor_fire in T)
					qdel(floor_fire)
			new /obj/structure/turf_fire(T)
	if("pulse" in ideas_stolen)
		if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
			WhitePulse()

