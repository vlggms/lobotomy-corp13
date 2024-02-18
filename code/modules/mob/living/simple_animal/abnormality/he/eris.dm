/mob/living/simple_animal/hostile/abnormality/eris
	name = "Eris"
	desc = "A towering, intimidating woman without a mouth."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "eris"
	icon_living = "eris"
	maxHealth = 1100
	health = 1100
	ranged = TRUE
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	stat_attack = HARD_CRIT
	melee_damage_lower = 11
	melee_damage_upper = 12
	move_to_delay = 2.6
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1)
	speak_emote = list("croons")
	pixel_x = -8

	can_breach = TRUE
	threat_level = HE_LEVEL
	pet_bonus = TRUE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(35, 40, 40, 35, 35),
		ABNORMALITY_WORK_INSIGHT = list(35, 40, 40, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = list(50, 55, 55, 50, 45),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/coiling,
		/datum/ego_datum/armor/coiling,
	)
	gift_type =  /datum/ego_gifts/coiling
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL
	var/girlboss_level = 0


//Okay, but here's the breach on death
/mob/living/simple_animal/hostile/abnormality/eris/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

/mob/living/simple_animal/hostile/abnormality/eris/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/eris/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	return TRUE



//Okay, but here's the life stuff
/mob/living/simple_animal/hostile/abnormality/eris/Life()
	..()
	if(IsContained())
		return
	healpulse()

//Okay, but here's the patrolling stuff
/mob/living/simple_animal/hostile/abnormality/eris/patrol_select()
	var/list/target_turfs = list() // Stolen from Punishing Bird
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(H.stat >= SOFT_CRIT) // prefer the near dead.
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()


//Okay, but here's the attacking stuff
/mob/living/simple_animal/hostile/abnormality/eris/CanAttack(atom/the_target)
	if(!ishuman(the_target))
		return FALSE
	var/mob/living/H = the_target
	if(H.stat >= SOFT_CRIT)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/eris/AttackingTarget(atom/attacked_target)
	if(ishuman(target))
		var/mob/living/H = target
		if(H.stat >= SOFT_CRIT)
			Dine(target)
			return
	..()

//Okay, but here's the cannibalism
/mob/living/simple_animal/hostile/abnormality/eris/proc/Dine(mob/living/carbon/human/poorfuck)
	manual_emote("unhinges her jaw, revealing many rows of teeth!")
	playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
	poorfuck.dust()
	new /obj/effect/gibspawner/generic/silent(get_turf(poorfuck))

	//Lose sanity
	for(var/mob/living/carbon/human/H in view(10, get_turf(src)))
		H.apply_damage(girlboss_level*10, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)

	SLEEP_CHECK_DEATH(10)
	manual_emote("wipes her mouth with a hankerchief")
	SLEEP_CHECK_DEATH(15)
	say("Thank you for the meal, love.")
	girlboss_level += 1

//Okay, but here's the Sex work
/mob/living/simple_animal/hostile/abnormality/eris/funpet(mob/living/carbon/human/current_petter)
	..()
	if(!(status_flags & GODMODE))
		return

	emote("giggles")
	current_petter.Stun(30 SECONDS)
	SLEEP_CHECK_DEATH(20)
	say("I'm glad you've come for dinner, my dear.")
	SLEEP_CHECK_DEATH(20)
	say("Oh you look just so... delicious.")
	SLEEP_CHECK_DEATH(20)
	emote("giggles")
	SLEEP_CHECK_DEATH(20)
	say("Here's your reward. You're mine forever.")
	SLEEP_CHECK_DEATH(20)
	manual_emote("unhinges her jaw, revealing many rows of teeth!")

	playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
	new /obj/effect/gibspawner/generic/silent(get_turf(current_petter))
	current_petter.dust()

	SLEEP_CHECK_DEATH(20)
	manual_emote("wipes her mouth with a hankerchief")
	SLEEP_CHECK_DEATH(20)
	say("Thank you for the meal, dear.")
	girlboss_level += 5
	datum_reference.qliphoth_change(-3)

//Okay, but here's the math
/mob/living/simple_animal/hostile/abnormality/eris/proc/healpulse()
	for(var/mob/living/H in view(10, get_turf(src)))
		if(H.stat >= SOFT_CRIT)
			continue
		//Shamelessly fucking stolen from risk of rain's teddy bear. Maxes out at 20.
		var/healamount = 20 * (TOUGHER_TIMES(girlboss_level))
		H.adjustBruteLoss(-healamount)	//Healing for those around.
		new /obj/effect/temp_visual/heal(get_turf(H), "#FF4444")

//Okay but here's the defensive options
/mob/living/simple_animal/hostile/abnormality/eris/bullet_act(obj/projectile/Proj)
	..()
	if(!ishuman(Proj.firer))
		return
	var/mob/living/carbon/human/H = Proj.firer
	H.apply_damage(40*(TOUGHER_TIMES(girlboss_level)), WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)


/mob/living/simple_animal/hostile/abnormality/eris/attacked_by(obj/item/I, mob/living/user)
	..()
	if(!user)
		return
	user.apply_damage(40*(TOUGHER_TIMES(girlboss_level)), WHITE_DAMAGE, null, user.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)


//Okay, but here's the work effects

/mob/living/simple_animal/hostile/abnormality/eris/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		if(prob(20))
			Dine(user)

/mob/living/simple_animal/hostile/abnormality/eris/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-3)
	return

/mob/living/simple_animal/hostile/abnormality/eris/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()
	GiveTarget(user)


